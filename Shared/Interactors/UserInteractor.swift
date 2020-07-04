//
//  UserInteractor.swift
//  NewTodoSample
//
//  Created by Lila Pustovoyt on 6/29/20.
//

import Foundation
import AuthenticationServices
import SimpleKeychain
import Auth0
import JWTDecode

protocol UserInteractions {
    func loginApple(_ appleIdCredential: ASAuthorizationAppleIDCredential)
    func logout()
    func checkSession()
    func testLogin()
}

class UserInteractor: UserInteractions {
    private unowned var store: AppStore
    private var credsManager: CredentialsManager
    private var keychain = A0SimpleKeychain()
    
    init(store: AppStore, credsManager: CredentialsManager) {
        self.store = store
        self.credsManager = credsManager
    }
    
    func testLogin() {
        Auth0
            .authentication()
            .login(
                usernameOrEmail: "test@goph.me",
                password: "secret-password",
                realm: "Username-Password-Authentication",
                audience: "https://todo.example.org",
                scope: "openid profile"
            )
            .start { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let credentials):
                        // NEW - store the credentials in the credentials manager
                        self.credsManager.store(credentials: credentials)
                        self.setUser(credentials: credentials)
                        
                    case .failure(let error):
                        print("Exchange Failed: \(error)")
                        self.store.authStatus = .notSignedIn(error: error)
                    }
                }
            }
    }
    
    func loginApple(_ appleIDCredential: ASAuthorizationAppleIDCredential) {
        guard let authCode = appleIDCredential.authorizationCode,
              let authCodeString = String(data: authCode, encoding: .utf8) else {
            print("Problem with the authorizaton code")
            return
        }
        
        Auth0
            .authentication()
            .login(
                appleAuthorizationCode: authCodeString,
                fullName: appleIDCredential.fullName,
                scope: "openid profile",
                audience: "https://todo.example.org"
            )
            .start { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let credentials):
                        // NEW - store the user ID in the keychain
                        self.keychain.setString(appleIDCredential.user, forKey: "userId")
                        print("Login success! \(credentials.accessToken!)")

                        // NEW - store the credentials in the credentials manager
                        self.credsManager.store(credentials: credentials)
                        self.setUser(credentials: credentials)
                        
                    case .failure(let error):
                        print("Exchange Failed: \(error)")
                        self.store.authStatus = .notSignedIn(error: error)
                    }
                }
            }
    }
    
    func logout() {
        self.store.authStatus = .notSignedIn(error: nil)
        self.keychain.deleteEntry(forKey: "userId")
        self.credsManager.clear()
    }
    
    func checkSession() {
        // Try to fetch the user ID
        guard let userID = keychain.string(forKey: "userId") else {
            print("No user ID found in Keychain")
            self.store.authStatus = .notSignedIn(error: nil)
            return
        }
        
        let provider = ASAuthorizationAppleIDProvider()

        // Check the Apple credential state
        provider.getCredentialState(forUserID: userID) { state, error in
            DispatchQueue.main.async {
                switch state {
                case .authorized:
                    // Try to get credentials from the creds manager (ID token, Access Token, etc)
                    self.credsManager.credentials { error, credentials in
                        guard error == nil, let credentials = credentials else {
                            self.store.authStatus = .notSignedIn(error: error)
                            return
                        }
                        self.setUser(credentials: credentials)
                    }
                default:
                    // User is not authorized
                    self.logout()
                }
            }
        }
    }
    
    private func setUser(credentials: Credentials) {
        let jwt = try? decode(jwt: credentials.idToken!)
        self.store.user = UserInfo(json: jwt!.body)!
        self.store.authStatus = .signedIn
    }
}

struct MockUserInteractor: UserInteractions {
    func testLogin() {
    }
    
    func loginApple(_ appleIdCredential: ASAuthorizationAppleIDCredential) {
    }
    
    func logout() {
    }
    
    func checkSession() {
    }
}
