//
//  Environment+App.swift
//  NewTodoSample
//
//  Created by Lila Pustovoyt on 6/30/20.
//

import Foundation
import SwiftUI
import Auth0

struct TodosInteractorKey: EnvironmentKey {
    static var defaultValue: TodoInteractions = MockTodoInteractor()
}

struct UserInteractionsKey: EnvironmentKey {
    static var defaultValue: UserInteractions = MockUserInteractor()
}

extension EnvironmentValues {
    var todosInteractor: TodoInteractions {
        get { self[TodosInteractorKey.self] }
        set { self[TodosInteractorKey.self] = newValue }
    }
    
    var userInteractor: UserInteractions {
        get { self[UserInteractionsKey.self] }
        set { self[UserInteractionsKey.self] = newValue }
    }
}
