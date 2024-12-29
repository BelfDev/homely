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
        var mode: EnvConfig = .development
//        #if DEBUG
//        mode = .development
//        #endif
        self.components = ComponentManager(mode)
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(components)
                .onChange(of: components.tokenProvider.jwtToken) {
                    components.session.didChangeAccessToken()
                }
        }
    }
}
