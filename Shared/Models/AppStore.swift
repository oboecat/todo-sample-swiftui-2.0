//
//  AppStore.swift
//  NewTodoSample
//
//  Created by Lila Pustovoyt on 6/29/20.
//

import Foundation
import Auth0
import Combine

class AppStore: ObservableObject {
    @Published var authStatus: AuthStatus = .loading
    @Published var user: UserInfo?
    @Published var todos: [Todo]
    @Published var error: ErrorLog?
    
    init(user: UserInfo?, todos: [Todo]) {
        self.authStatus = .loading
        self.user = user
        self.todos = todos
    }
    
    convenience init() {
        self.init(user: nil, todos: [])
    }
    
    enum AuthStatus {
        case loading
        case notSignedIn(error: Error?)
        case signedIn(error: Error?)
    }
}

extension AppStore {
    static var sample = AppStore(
        user: UserInfo(json: ["sub": "null", "name": "User"])!,
        todos: Todo.sampleList
    )
}
