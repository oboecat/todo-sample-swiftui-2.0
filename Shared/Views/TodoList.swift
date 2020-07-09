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
    var filteredList: [Todo] {
            store.todos.filter { self.isShowingCompleted || !$0.completed }
    }
    
    var body: some View {
        #if os(macOS)
        return ScrollView(showsIndicators: false) {
            Divider()
            ForEach(filteredList) { todo in
                TodoItem(todo: todo)
                Divider()
            }
            .padding(.horizontal)
            NewTodoItem().padding(.horizontal)
        }
        .padding(.vertical)
        .animation(.default)
        #else
        return List {
            ForEach(filteredList) { todo in
                TodoItem(todo: todo)
            }
            NewTodoItem()
        }
        .animation(.default)
        #endif
    }
    
    var listItems: some View {
        return Group {
            
        }
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
