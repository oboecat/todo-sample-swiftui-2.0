//
//  TodoItem.swift
//  NewTodoSample
//
//  Created by Lila Pustovoyt on 6/29/20.
//

import SwiftUI

struct TodoItem: View {
    @Environment(\.todosInteractor) var interactor: TodoInteractions
    @State var bodyDraft: String = ""
    @State var isMarkedCompleted = false
    var todo: Todo
     
    var body: some View {
        #if os(tvOS)
        return todoItem.onPlayPauseCommand(perform: self.toggleCompleted)
        #else
        return todoItem
        #endif
    }
    
    var todoItem: some View {
        HStack {
            #if os(tvOS)
            TodoStatus(isCompleted: isMarkedCompleted)
            #else
            Button(action: self.toggleCompleted) {
                TodoStatus(isCompleted: self.isMarkedCompleted)
            }
            .buttonStyle(BorderlessButtonStyle())
            #endif

            TextField("To-do", text: $bodyDraft, onEditingChanged: { editing in
            }, onCommit: {
                var updatedTodo = self.todo
                updatedTodo.body = self.bodyDraft
                self.interactor.updateTodo(updatedTodo)
            })
            .textFieldStyle(PlainTextFieldStyle())
            
            Spacer()
        }
        .onAppear {
            self.isMarkedCompleted = self.todo.completed
            self.bodyDraft = self.todo.body
        }
    }
    
    private func toggleCompleted() {
        var updatedTodo = self.todo
        updatedTodo.completed.toggle()
        self.isMarkedCompleted = updatedTodo.completed
        self.interactor.updateTodo(updatedTodo)
    }
}

struct TodoItem_Previews: PreviewProvider {
    static var previews: some View {
        TodoItem(todo: Todo(body: "Buy new cat toy", completed: true, id: "test"))
    }
}

