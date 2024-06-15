//
//  HomelyApp.swift
//  homely
//
//  Created by Pedro Belfort on 26.05.24.
//

import SwiftUI

@main
struct HomelyApp: App {
    @StateObject var themeManager = ThemeManager()
    
    var body: some Scene {
        WindowGroup {
//            ContentView(data: dummyData)
            LoginView()
                .environmentObject(themeManager)
        }
    }
}
