//
//  NewTodoItem.swift
//  NewTodoSample
//
//  Created by Lila Pustovoyt on 6/29/20.
//

import SwiftUI

struct NewTodoItem: View {
    @Environment(\.todosInteractor) var interactor: TodoInteractions
    @State var bodyDraft: String = ""
    @State var isMarkedCompleted = false
    
    var body: some View {
        #if os(tvOS)
        return todoItem.onPlayPauseCommand { self.isMarkedCompleted.toggle() }
        #else
        return todoItem
        #endif
    }
    
    var todoItem: some View {
        HStack {
            #if os(tvOS)
            TodoStatus(isCompleted: isMarkedCompleted)
            #else
            Button(action: {
                self.isMarkedCompleted.toggle()
            }) {
                TodoStatus(isCompleted: self.isMarkedCompleted)
            }
            #endif

            TextField("New to-do", text: $bodyDraft, onCommit: {
                guard self.bodyDraft.count > 0 else {
                    return
                }
                
                let newTodo = Todo(body: self.bodyDraft, completed: self.isMarkedCompleted, id: "null")
                self.interactor.addNewTodo(newTodo)
                
                self.bodyDraft = ""
                self.isMarkedCompleted = false
            })
            .textFieldStyle(PlainTextFieldStyle())

            Spacer()
        }
    }
}

struct NewTodoItem_Previews: PreviewProvider {
    static var previews: some View {
        NewTodoItem()
    }
}
