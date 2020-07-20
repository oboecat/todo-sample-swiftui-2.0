//
//  Auth0Helper.swift
//  NewTodoSample
//
//  Created by Lila Pustovoyt on 7/14/20.
//

import Foundation
import Auth0
import Combine
import JWTDecode
import AuthenticationServices
import SimpleKeychain

extension UserInfo {
    convenience init?(credentials: Credentials?) {
        guard let idToken = credentials?.idToken,
              let jwt = try? decode(jwt: idToken) else {
            return nil
        }
        self.init(json: jwt.body)
    }
}

class Auth0Helper {
    var credManager: CredentialsManager
    
    init(credManager: CredentialsManager) {
        self.credManager = credManager
    }

    /*:
        Helper function get Credentials
     */
    func credentials() -> AnyPublisher<Credentials, Error> {
        return Future { promise in
            if (!self.credManager.hasValid()) {
                promise(.failure(AuthenticationError(string: "You are not logged in", statusCode: 401)))
            }
            self.credManager.credentials { (error, credentials) in
                guard error == nil else {
                    promise(.failure(error!))
                    return
                }
                
                if credentials == nil {
                    promise(.failure(AuthenticationError(string: "Unexpected Error, Credentials not in the payload", statusCode: 500)))
                    return
                }
                
                
                promise(.success(credentials!))
            }
        }.eraseToAnyPublisher()
    }
    
    /*:
        Helper method to get logged in user
     */
    func userInfo() -> AnyPublisher<UserInfo, Error> {
        return self.credentials().tryMap { credentials in
            guard let userInfo = UserInfo(credentials: credentials) else {
                throw AuthenticationError(string: "Unexpected Error, IdToken not in response or invalid", statusCode: 401)
            }
            return userInfo
        }
        .eraseToAnyPublisher()
    }
    
    func loginWithAppleID(authorization: ASAuthorizationAppleIDCredential?, scope: String, audience: String) -> AnyPublisher<Credentials, Error> {
        return Future { promise in
            guard let authz = authorization,
                  let authzCodeData = authz.authorizationCode,
                  let authCode = String(data: authzCodeData, encoding: .utf8) else {
                promise(.failure(AuthenticationError(string: "Invalid Apple Authorization Response or nil response", statusCode: 400)))
                return
            }
            
            Auth0
                .authentication()
                .login(appleAuthorizationCode: authCode, fullName: authz.fullName, scope: scope, audience: audience)
                .start { result in
                    switch result {
                    case .success(let credentials):
                        promise(.success(credentials))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    func testLogin(username: String, password: String, scope: String, audience: String) -> AnyPublisher<Credentials, Error> {
        return Future { promise in
            Auth0
                .authentication()
                .login(
                    usernameOrEmail: username,
                    password: password,
                    realm: "Username-Password-Authentication",
                    audience: audience,
                    scope: scope
                )
                .start { result in
                    switch result {
                    case .success(let credentials):
                        promise(.success(credentials))
                    case .failure(let err):
                        promise(.failure(err))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, Error> {
        return Future { promise in
            if (!self.credManager.hasValid()) {
                promise(.failure(AuthenticationError(string: "You are not logged in", statusCode: 401)))
            }
            self.credManager.revoke { (error) in
                guard error == nil else {
                    promise(.failure(error!))
                    return
                }
                 
                promise(.success(()))
            }
        }.eraseToAnyPublisher()

    }
}
