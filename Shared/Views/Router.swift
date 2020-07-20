//
//  Router.swift
//  NewTodoSample
//
//  Created by Lila Pustovoyt on 6/29/20.
//

import SwiftUI

struct Router: View {
    @EnvironmentObject var store: AppStore
    @Environment(\.userInteractor) var userInteractor: UserInteractions
    
    var body: some View {
        Group {
            switch store.authStatus {
            case .loading:
                LoadingScreen()
            case .notSignedIn:
                LoginScreen()
            case .signedIn:
                TodoListScreen()
            }
        }
        .alert(item: $store.error) { log in
            Alert(title: Text("Error"),
                  message: Text("An error occurred: \(log.error.localizedDescription)"),
                  dismissButton: Alert.Button.cancel(Text("Ok")))
        }
        .onAppear {
            self.userInteractor.checkSession()
        }
    }
}

struct Router_Previews: PreviewProvider {
    static var previews: some View {
        Router()
            .environmentObject(AppStore.sample)
    }
}
