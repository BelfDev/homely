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
    
    var backgroundColor: Color?
    
    var body: some View {
        VStack {
            Image(systemName: iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
            
            Text(title)
                .font(theme.font.h6)
                .bold()
                .padding(.bottom, 4)
            
            Text(description)
                .font(theme.font.body1)
                .foregroundColor(theme.color.onSurface)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 150)
        .padding(.all, 16)
        .background(backgroundColor ?? theme.color.surface)
        .cornerRadius(24)
        
    }
}

#Preview {
    let components = ComponentManager(.development)
    
    FeatureModuleView(title: "Rewards", description: "Track household tasks", iconName: "star")
        .environment(components)
        .padding()
}
