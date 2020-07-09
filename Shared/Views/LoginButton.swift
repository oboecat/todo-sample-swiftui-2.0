//
//  LoginButton.swift
//  NewTodoSample
//
//  Created by Lila Pustovoyt on 6/29/20.
//

import SwiftUI
import AuthenticationServices

#if targetEnvironment(simulator)
// Currently Sign in with Apple doesn't work on simulators
struct LoginButton: View {
    @Environment(\.userInteractor) var userInteractor: UserInteractions
    
    var body: some View {
        Button(action: {
            self.userInteractor.testLogin()
        }) {
            Text("Sign In")
        }
    }
}
#else
struct LoginButton: View {
    @Environment(\.userInteractor) var userInteractor: UserInteractions
    
    var body: some View {
        SignInWithAppleButton(
            .signIn,
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                switch result {
                case .success(let authResults):
                    let appleIDCredential = authResults.credential as! ASAuthorizationAppleIDCredential
                    self.userInteractor.loginApple(appleIDCredential)
                case .failure(let error):
                    print("Authorization failed: " + error.localizedDescription)
                }
            }
        ).frame(width: 200, height: 44, alignment: .center)
    }
}
#endif

struct LoginButton_Previews: PreviewProvider {
    static var previews: some View {
        LoginButton()
    }
}
