//
//  LoadinScreen.swift
//  NewTodoSample
//
//  Created by Lila Pustovoyt on 7/2/20.
//

import SwiftUI

struct LoadingScreen: View {
    var body: some View {
        VStack() {
            Spacer()
            TodoListTitle()
            Spacer()
            ProgressView()
            Spacer()
        }
    }
}

struct LoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScreen()
    }
}
