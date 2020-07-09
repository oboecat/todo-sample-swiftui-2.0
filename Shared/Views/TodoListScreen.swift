//
//  TodoListScreen.swift
//  NewTodoSample
//
//  Created by Lila Pustovoyt on 7/3/20.
//

import SwiftUI
import Combine

struct TodoListScreen: View {
    @Environment(\.todosInteractor) var interactor: TodoInteractions
    @State private var isShowingCompleted = true
    @State private var cancellable: AnyCancellable! = nil
    
    func poll() {
        self.cancellable = Timer.publish(every: 3, on: RunLoop.main, in: .common)
            .autoconnect()
            .sink { _ in self.interactor.getTodos() }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            TodoListTitle()
            
            #if os(tvOS)
            HStack {
                Picker("View", selection: $isShowingCompleted) {
                    Text("Pending").tag(false)
                    Text("All").tag(true)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.bottom)
                
                Spacer()
            }
            #else
            Picker("", selection: $isShowingCompleted) {
                Text("Pending").tag(false)
                Text("All").tag(true)
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 200, height: nil)
            #endif
            
            TodoList(isShowingCompleted: isShowingCompleted)
            
            AppFooter()
        }
        .onAppear {
            self.interactor.getTodos()
            self.poll()
        }
        .onDisappear {
            self.cancellable.cancel()
        }
    }
}

struct TodoListScreen_Previews: PreviewProvider {
    static var previews: some View {
        TodoListScreen()
            .environmentObject(AppStore.sample)
    }
}
