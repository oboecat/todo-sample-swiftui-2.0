//
//  UserInteractor.swift
//  NewTodoSample
//
//  Created by Lila Pustovoyt on 6/29/20.
//

import Foundation
import AuthenticationServices
import Combine
import SimpleKeychain
import Auth0
import JWTDecode

protocol UserInteractions {
    func loginApple(_ appleIdCredential: ASAuthorizationAppleIDCredential?)
    func logout()
    func checkSession()
    func testLogin()
}

class UserInteractor: UserInteractions {
    private unowned var store: AppStore
    private var auth0Helper: Auth0Helper
    private var credsManager: CredentialsManager
    private var keychain = A0SimpleKeychain()
    private var cancelBag = Set<AnyCancellable>()
    
    init(store: AppStore, auth0Helper: Auth0Helper, credsManager: CredentialsManager) {
        self.store = store
        self.auth0Helper = auth0Helper
        self.credsManager = credsManager
    }
    
    func testLogin() {
        auth0Helper.testLogin(username: "test@goph.me", password: "secret-password", scope: "openid profile", audience: "https://todo.example.org")
            .receive(on: RunLoop.main)
            .map { creds in
                self.credsManager.store(credentials: creds)
                self.setUser(credentials: creds)
                return AppStore.AuthStatus.signedIn(error: nil)
            }
            .catch { err -> AnyPublisher<AppStore.AuthStatus, Never> in
                self.logError(err)
                return Just(AppStore.AuthStatus.notSignedIn(error: err))
                    .eraseToAnyPublisher()
            }
            .assign(to: \.authStatus, on: store)
            .store(in: &cancelBag)
    }
    
    func loginApple(_ appleIDCredential: ASAuthorizationAppleIDCredential?) {
        auth0Helper.loginWithAppleID(authorization: appleIDCredential, scope: "openid profile", audience: "https://todo.example.org")
            .receive(on: RunLoop.main)
            .map { creds in
                self.keychain.setString(appleIDCredential!.user, forKey: "userId")
                self.credsManager.store(credentials: creds)
                self.setUser(credentials: creds)
                
                return AppStore.AuthStatus.signedIn(error: nil)
            }
            .catch { err -> AnyPublisher<AppStore.AuthStatus, Never> in
                self.logError(err)
                return Just(AppStore.AuthStatus.notSignedIn(error: err))
                    .eraseToAnyPublisher()
            }
            .assign(to: \.authStatus, on: store)
            .store(in: &cancelBag)
    }
    
    func logout() {
        auth0Logout()
            .receive(on: RunLoop.main)
            .assign(to: \.authStatus, on: store)
            .store(in: &cancelBag)
    }
    
    // Checks the existing credentials state with Apple,
    // then check the credentials state with Auth0,
    // then assigns the user and auth status
    func checkSession() {
        getAppleCredentialState()
            .flatMap { state -> AnyPublisher<UserInfo, Error> in
                switch state {
                case .authorized:
                    return self.auth0Helper.userInfo()
                default:
                    return Fail(error: AuthenticationError(string: "You are not logged in"))
                        .eraseToAnyPublisher()
                }
            }
            .receive(on: RunLoop.main)
            .map { userInfo in
                self.store.user = userInfo
                return AppStore.AuthStatus.signedIn(error: nil)
            }
            .catch { err -> AnyPublisher<AppStore.AuthStatus, Never> in
                self.logError(err)
                return self.auth0Logout()
            }
            .receive(on: RunLoop.main)
            .assign(to: \.authStatus, on: store)
            .store(in: &cancelBag)
    }
    
    private func auth0Logout() -> AnyPublisher<AppStore.AuthStatus, Never> {
        return auth0Helper.logout()
            .receive(on: RunLoop.main)
            .map { _ in
                self.keychain.deleteEntry(forKey: "userId")
                return AppStore.AuthStatus.notSignedIn(error: nil)
            }
            .catch { err -> AnyPublisher<AppStore.AuthStatus, Never> in
                self.logError(err)
                return Just(AppStore.AuthStatus.notSignedIn(error: err))
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func getAppleCredentialState() -> Future<ASAuthorizationAppleIDProvider.CredentialState?, Error> {
        Future { promise in
            // Try to fetch the user ID
            guard let userID = self.keychain.string(forKey: "userId") else {
                return promise(.success(nil))
            }
            
            let provider = ASAuthorizationAppleIDProvider()
            // Check the Apple credential state
            provider.getCredentialState(forUserID: userID) { state, err in
                guard err == nil else {
                    return promise(.failure(err!))
                }
                promise(.success(state))
            }
        }
    }
    
    private func setUser(credentials: Credentials) {
        store.user = UserInfo(credentials: credentials)
    }
    
    private func logError(_ err: Error) {
        store.error = ErrorLog(error: err)
    }
}

struct MockUserInteractor: UserInteractions {
    func testLogin() {
    }
    
    func loginApple(_ appleIdCredential: ASAuthorizationAppleIDCredential?) {
    }
    
    func logout() {
    }
    
    func checkSession() {
    }
}
