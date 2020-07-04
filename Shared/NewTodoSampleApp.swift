//
//  NewTodoSampleApp.swift
//  Shared
//
//  Created by Lila Pustovoyt on 6/24/20.
//

import SwiftUI
import Auth0

@main
struct NewTodoSampleApp: App {
    @StateObject var appEnvironment = AppEnvironment()
    
    var body: some Scene {
        WindowGroup {
            TodoAppView()
                .environmentObject(appEnvironment.store)
                .environment(\.todosInteractor, appEnvironment.todoInteractor)
                .environment(\.userInteractor, appEnvironment.userInteractor)
        }
        .commands {
            
        }
    }
}
