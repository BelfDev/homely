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

    var body: some View {
        Text(status.localizedName.uppercased())
            .font(theme.font.caption)
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
}
