//
//  LogoutButton.swift
//  NewTodoSample
//
//  Created by Lila Pustovoyt on 6/29/20.
//

import SwiftUI

struct LogoutButton: View {
    @Environment(\.userInteractor) var userInteractor: UserInteractions
    
    var body: some View {
        Button(action: {
            self.userInteractor.logout()
        }) {
            Text(" Sign out")
        }
        .accentColor(.red)
    }
}

struct LogoutButton_Previews: PreviewProvider {
    static var previews: some View {
        LogoutButton()
    }
}
