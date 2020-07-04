//
//  TodoListTitle.swift
//  NewTodoSample
//
//  Created by Lila Pustovoyt on 6/29/20.
//

import SwiftUI

struct TodoListTitle: View {
    var body: some View {
        Text("Todo Sample")
            .font(.system(.largeTitle, design: .rounded))
            .foregroundColor(.accentColor)
    }
}

struct TodoListTitle_Previews: PreviewProvider {
    static var previews: some View {
        TodoListTitle()
    }
}
