//
//  FilledButton.swift
//  Homely
//
//  Created by Pedro Belfort on 07.10.24.
//

import SwiftUI

struct FilledButton: View {
    @ThemeProvider private var theme
    
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action)
        {
            Text(title)
                .font(theme.font.button)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, minHeight: 56.0)
        .contentShape(Rectangle())
        .background(theme.color.primary)
        .tint(theme.color.onPrimary)
        .cornerRadius(8)
    }
}

#Preview {
    let components = ComponentManager(.development)
    
    FilledButton(
        title: "Login"
    ) {
        print("Login action!")
    }
    .environment(components)
    .padding()
}
