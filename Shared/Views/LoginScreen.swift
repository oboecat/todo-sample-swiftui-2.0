//
//  LoginScreen.swift
//  NewTodoSample
//
//  Created by Lila Pustovoyt on 7/2/20.
//

import SwiftUI

struct LoginScreen: View {
    var body: some View {
        VStack() {
            Spacer()
            TodoListTitle()
            Spacer()
            LoginButton()
            Spacer()
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
            .frame(width: 480, height: 360, alignment: .center)
    }
}
