//
//  FloatingActionButton.swift
//  Homely
//
//  Created by Pedro Belfort on 18.01.25.
//

import SwiftUI

struct FloatingActionButton: View {
    @ThemeProvider private var theme
    
    var actionType: ButtonActionType
    var action: @MainActor () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: actionType.systemImageName)
                .font(.title.weight(.semibold))
                .padding()
                .background(theme.color.primary)
                .foregroundColor(theme.color.onPrimary)
                .clipShape(Circle())
                .shadow(
                    color: theme.color.shadow,
                    radius: 4, x: 0, y: 4
                )

        }
    }
}

#Preview {
    let components = ComponentManager(.development)
    FloatingActionButton(actionType: .add) {
        // Do something
    }
    .environment(components)
}
