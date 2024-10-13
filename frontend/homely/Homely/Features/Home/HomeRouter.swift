//
//  HomeNavStack.swift
//  Homely
//
//  Created by Pedro Belfort on 29.09.24.
//

import SwiftUI

enum HomeRoute: Route {
    case details
}

struct HomeRouter: View {
    @ComponentsProvider private var components
    @State private var navigation = NavigationManager<HomeRoute>()
    
    var body: some View {
        NavigationStack(path: $navigation.path) {
            HomeScreen(components)
        }
        .tint(components.theme.color.primary)
        .environment(navigation)
    }
}
