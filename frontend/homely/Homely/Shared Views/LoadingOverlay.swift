//
//  LoadingOverlay.swift
//  Homely
//
//  Created by Pedro Belfort on 29.09.24.
//


import SwiftUI

struct LoadingOverlay: View {
    @ThemeProvider private var theme
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2.0)
                    .tint(theme.color.onPrimaryContainer)
            }
            .frame(maxWidth: 100, maxHeight: 100)
            .background(theme.color.primaryContainer)
            .cornerRadius(16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
    }
}
