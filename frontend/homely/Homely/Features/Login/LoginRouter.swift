//
//  LoginRouter.swift
//  Homely
//
//  Created by Pedro Belfort on 08.10.24.
//

import SwiftUI

enum LoginRoute: Route {
    case signUp
}

struct LoginRouter: View {
    @ComponentsProvider private var components
    @State private var navigation = NavigationManager<LoginRoute>()
    
    var body: some View {
        NavigationStack(path: $navigation.path) {
//            SignUpScreen(components)
            
            
            LoginScreen(components)
                .navigationDestination(for: LoginRoute.self) { destination in
                    switch destination {
                    case .signUp:
                        SignUpScreen(components)
                            
                    }
                }
        }
        .tint(components.theme.color.primary)
        .environment(navigation)
    }
}
