//
//  HomeNavStack.swift
//  Homely
//
//  Created by Pedro Belfort on 29.09.24.
//

import SwiftUI

enum HomeRoute: Route {
    case tasks
}

struct HomeRouter: View {
    @ComponentsProvider private var components
    @State private var navigator = NavigationManager()
    
    var body: some View {
        NavigationStack(path: $navigator.path) {
            HomeScreen(components)
                .navigationDestination(for: HomeRoute.self) { destination in
                    switch destination {
                    case .tasks:
                        TaskRouter()
                    }
                }
        }
        .tint(components.theme.color.primary)
        .environment(navigator)
    }
}
