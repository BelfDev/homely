//
//  TaskDetailsScreen.swift
//  Homely
//
//  Created by Pedro Belfort on 29.12.24.
//

import SwiftUI

struct TaskDetailsScreen: View {
    @NavigationManagerProvider private var navigator
    
    var body: some View {
        Text("Hello, World!")
        
        
        // Test
        Button("Pop to root") {
            navigator.popToRoot()
        }
        .padding()
    }
}

#Preview {
    TaskDetailsScreen()
}
