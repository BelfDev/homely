//
//  IconButton.swift
//  Homely
//
//  Created by Pedro Belfort on 12.10.24.
//

import SwiftUI

struct IconButton: View {
    @ThemeProvider private var theme
    @State private var debouncer = Debouncer(delay: 3.0)
    
    let iconName: String
    let action: () -> Void
    
    var body: some View {
        Button {
            debouncer.execute { action() }
        } label: {
            Image(systemName: iconName)
                .foregroundColor(theme.color.primary)
        }
    }
}

#Preview {
    let components = ComponentManager(.development)
    
    IconButton(
        iconName: "faceid"
    ) {
        print("Hi")
    }
    .environment(components)
    .padding()
}
