//
//  FooterView.swift
//  NewTodoSample
//
//  Created by Lila Pustovoyt on 6/29/20.
//

import SwiftUI

struct FooterView: View {
    var body: some View {
        HStack {
            UserView()
            Spacer()
            LogoutButton()
        }
        .edgesIgnoringSafeArea(.all)
        .padding()
    }
}

struct FooterView_Previews: PreviewProvider {
    static var previews: some View {
        FooterView()
            .environmentObject(AppStore.sample)
    }
}
