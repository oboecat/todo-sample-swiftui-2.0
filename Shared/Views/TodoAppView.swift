//
//  TodoAppView.swift
//  NewTodoSample
//
//  Created by Lila Pustovoyt on 6/29/20.
//

import SwiftUI
import Auth0

struct TodoAppView: View {
    var body: some View {
        #if os(macOS)
        return Router()
            .frame(width: 360, height: 480, alignment: .center)
        #else
        return Router()
        #endif
    }
}

struct TodoAppView_Previews: PreviewProvider {
    static var previews: some View {
        TodoAppView()
    }
}
