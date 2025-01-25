//
//  StatusBadge.swift
//  Homely
//
//  Created by Pedro Belfort on 25.01.25.
//

import SwiftUI

struct StatusBadge: View {
    @ThemeProvider private var theme

    let status: TaskStatus
    var size: Size = .small

    enum Size { case small, big }
    var contentFont: Font {
        switch size {
        case .small:
            return theme.font.caption
        case .big:
            return theme.font.h6
        }
    }

    var body: some View {
        Text(status.localizedName.uppercased())
            .font(contentFont)
            .fontWeight(.bold)
            .foregroundColor(theme.color.onSecondary)
            .padding(.vertical, 2)
            .padding(.horizontal, 4)
            .background(status.color(theme.color))
            .cornerRadius(4)
    }
}

#Preview {
    let components = ComponentManager(.development)
    
    StatusBadge(status: .done)
        .environment(components)
        .padding()
    
    StatusBadge(status: .done, size: .big)
        .environment(components)
        .padding()
}
