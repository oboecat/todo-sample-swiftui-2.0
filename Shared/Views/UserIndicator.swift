//
//  UserIndicator.swift
//  NewTodoSample
//
//  Created by Lila Pustovoyt on 6/29/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserIndicator: View {
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        HStack(alignment: .center) {
            if let userIconURL = store.user?.picture {
                WebImage(url: userIconURL)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFit()
            }
            
            Text("\(store.user?.name ?? "anonymous")")
        }
        .frame(width: nil, height: 32, alignment: .leading)
    }
}

struct UserIndicator_Previews: PreviewProvider {
    static var previews: some View {
        UserIndicator()
            .environmentObject(AppStore())
    }
}
