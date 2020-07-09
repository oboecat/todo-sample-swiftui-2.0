//
//  TodoStatus.swift
//  NewTodoSample
//
//  Created by Lila Pustovoyt on 7/3/20.
//

import SwiftUI

struct TodoStatus: View {
    var isCompleted: Bool
    
    var body: some View {
        Image(systemName: isCompleted ? "largecircle.fill.circle" : "circle")
            .foregroundColor(isCompleted ? .accentColor : .gray)
    }
}

struct TodoStatus_Previews: PreviewProvider {
    static var previews: some View {
        TodoStatus(isCompleted: true)
    }
}
