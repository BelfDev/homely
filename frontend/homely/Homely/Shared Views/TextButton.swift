//
//  TextButton.swift
//  Homely
//
//  Created by Pedro Belfort on 07.10.24.
//

import SwiftUI

struct TextButton: View {
    @ThemeProvider private var theme
    @State private var debouncer = Debouncer(delay: 3.0)
    
    let title: String
    let action: () -> Void
    
    var imageName: String = "arrow.right"
    var showIcon: Bool = false
    
    var body: some View {
        
        Button {
            debouncer.execute { action() }
        } label: {
            HStack {
                Text(title)
                    .font(theme.font.button2)
                if (showIcon) {
                    Image(systemName: imageName)
                }
            }
        }
        .buttonStyle(.borderless)
        .tint(theme.color.onSurface)
    }
}

#Preview {
    let components = ComponentManager(.development)
    
    TextButton(
        title: "Sign Up"
    ) {
        print("Sign Up action!")
    }
    .environment(components)
}
