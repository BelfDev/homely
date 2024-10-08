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
        let isLoggedIn = components.session.isLoggedIn
        
        Group {
            if isLoggedIn {
                HomeRouter()
            } else {
                LoginRouter()
                    .transition(.push(from: .bottom))
            }
        }
        .animation(.snappy(), value: isLoggedIn)
    }
}
