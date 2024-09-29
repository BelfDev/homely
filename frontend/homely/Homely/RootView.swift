//
//  RootView.swift
//  Homely
//
//  Created by Pedro Belfort on 29.09.24.
//

import SwiftUI

struct RootView: View {
    @ComponentsProvider private var components
    
    var body: some View {
        let isLoggedIn = components.globalState.isLoggedIn
        
        Group {
            if isLoggedIn {
                HomeNavStack()
                    .transition(.push(from: .bottom))
                
            } else {
                LoginScreen(components)
                    .transition(.push(from: .top))
            }
        }
        .animation(.bouncy, value: isLoggedIn)
    }
}

//#Preview {
//    AppRoot()
//}
