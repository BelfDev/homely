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
    @State private var navigator = NavigationManager()
    
    var body: some View {
        NavigationStack(path: $navigator.path) {
            LoginScreen(components)
                .navigationDestination(for: LoginRoute.self) { destination in
                    switch destination {
                    case .signUp:
                        SignUpScreen(components)
                    }
                }
        }
        .tint(components.theme.color.primary)
        .environment(navigator)
    }
}
