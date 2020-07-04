//
//  TodoInteractor.swift
//  NewTodoSample
//
//  Created by Lila Pustovoyt on 6/29/20.
//

import Foundation
import Combine
import AuthenticationServices
import SimpleKeychain

protocol TodoInteractions {
    func getTodos()
//    func pollTodos()
    func updateTodo(_ todo: Todo)
    func addNewTodo(_ todo: Todo)
    func deleteTodo(_ todoId: String)
}

class ActualTodoInteractor: TodoInteractions {
    private var api: APIClient
    private unowned var store: AppStore
    private var cancelBag = Set<AnyCancellable>()
    
    init(store: AppStore, apiClient: APIClient) {
        print("Hello interactor")
        self.store = store
        self.api = apiClient
    }

    func getTodos() {
        api.getTodos()
            .receive(on: RunLoop.main)
            .assign(to: \.todos, on: store)
            .store(in: &cancelBag)
    }
    
    func updateTodo(_ todo: Todo) {
        api.updateTodo(todo)
            .receive(on: RunLoop.main)
            .sink { todo in
                if let index = self.store.todos.firstIndex(where: { $0.id == todo.id }) {
                    self.store.todos[index] = todo
                }
            }
            .store(in: &cancelBag)
    }
    
    func addNewTodo(_ todo: Todo) {
        api.addNewTodo(todo)
            .receive(on: RunLoop.main)
            .sink { todo in
                self.store.todos.append(todo)
            }
            .store(in: &cancelBag)
    }
    
    func deleteTodo(_ todoId: String) {
        // to-do
    }
}

struct MockTodoInteractor: TodoInteractions {
    func getTodos() {}
    func updateTodo(_ todo: Todo) {}
    func addNewTodo(_ todo: Todo) {}
    func deleteTodo(_ todoId: String) {}
}
