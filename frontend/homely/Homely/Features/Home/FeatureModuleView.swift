//
//  FeatureModuleView.swift
//  Homely
//
//  Created by Pedro Belfort on 12.10.24.
//

import SwiftUI

struct FeatureModuleView: View {
    @ThemeProvider private var theme
    
    let title: String
    let description: String
    let iconName: String
    
    var body: some View {
        VStack {
            Image(systemName: iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .padding(.bottom, 8)
            Text(title)
                .font(theme.font.h5)
                .bold()
            Text(description)
                .font(theme.font.body2)
                .foregroundColor(theme.color.onSurface)
                .multilineTextAlignment(.center)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, minHeight: 150)
        .padding()
        .background(theme.color.surface)
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}

#Preview {
    let components = ComponentManager(.development)
    
    FeatureModuleView(title: "Rewards", description: "Track household tasks", iconName: "star")
        .environment(components)
}
