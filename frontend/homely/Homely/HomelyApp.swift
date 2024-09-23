//
//  HomelyApp.swift
//  homely
//
//  Created by Pedro Belfort on 26.05.24.
//

import SwiftUI

@main
struct HomelyApp: App {
    @State private var components: ComponentManager
    
    init() {
        components = ComponentManager(.development)
    }
    
    var body: some Scene {
        WindowGroup {
            LoginScreen(components)
        }.environment(components)
    }
}
