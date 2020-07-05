//
//  FooterView.swift
//  NewTodoSample
//
//  Created by Lila Pustovoyt on 6/29/20.
//

import SwiftUI

struct AppFooter: View {
    var body: some View {
        HStack {
            UserIndicator()
            Spacer()
            LogoutButton()
        }
        .edgesIgnoringSafeArea(.all)
        .padding()
    }
}

struct AppFooter_Previews: PreviewProvider {
    static var previews: some View {
        AppFooter()
            .environmentObject(AppStore.sample)
    }
}
