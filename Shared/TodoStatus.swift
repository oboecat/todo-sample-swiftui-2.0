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
        if isCompleted {
            return Image(systemName: "largecircle.fill.circle")
                .foregroundColor(.accentColor)
        } else {
            return Image(systemName: "circle")
                .foregroundColor(.gray)
        }
    }
}

struct TodoStatus_Previews: PreviewProvider {
    static var previews: some View {
        TodoStatus(isCompleted: true)
    }
}
