//
//  AppEnvironment.swift
//  NewTodoSample
//
//  Created by Lila Pustovoyt on 6/30/20.
//

import Foundation
import Auth0

class AppEnvironment: ObservableObject {
    @Published var store: AppStore
    var todoInteractor: TodoInteractions
    var userInteractor: UserInteractor
    
    init() {
        let store = AppStore()
        let authentication = Auth0.authentication()
        let credsManager = CredentialsManager(authentication: authentication)
        let apiClient = APIClient(credsManager: credsManager)
        
        self.store = store
        self.todoInteractor = TodoInteractor(store: store, apiClient: apiClient)
        self.userInteractor = UserInteractor(store: store, credsManager: credsManager)
    }
}
