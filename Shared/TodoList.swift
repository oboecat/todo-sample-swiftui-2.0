//
//  TodoListView.swift
//  NewTodoSample
//
//  Created by Lila Pustovoyt on 6/29/20.
//

import SwiftUI
import Combine

struct TodoList: View {
    @EnvironmentObject var store: AppStore
    var isShowingCompleted: Bool
    
    var body: some View {
        List {
            ForEach(store.todos.filter { self.isShowingCompleted || !$0.completed }) { todo in
                TodoItem(todo: todo)
            }
            NewTodoItem()
        }
        .animation(.default)
    }
}

struct TodoList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TodoList(isShowingCompleted: true)
                .environmentObject(AppStore.sample)
        }
    }
}
