//
//  CardView.swift
//  Homely
//
//  Created by Pedro Belfort on 13.10.24.
//

import SwiftUI

struct CardView<Content>: View where Content: View {
    @ThemeProvider private var theme
    @State private var debouncer = Debouncer(delay: 3.0)
    
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack {
            content()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.color.secondaryContainer)
        .cornerRadius(24)
        .shadow(color: theme.color.shadow, radius: 16)
    }
}

#Preview {
    let components = ComponentManager(.development)
    CardView {
        Text("Special Highlight")
            .font(.headline)
            .padding()
    }
    .environment(components)
    .padding()
}
