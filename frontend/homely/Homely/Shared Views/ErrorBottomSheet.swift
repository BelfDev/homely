//
//  ErrorBottomSheet.swift
//  Homely
//
//  Created by Pedro Belfort on 24.09.24.
//

import SwiftUI

struct BottomSheetView<Content>: View where Content : View {
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack {
            content
        }
        .padding()
        .presentationDetents([.height(200)])
        .presentationCornerRadius(42)
    }
}

struct ErrorBottomSheet: View {
    @ThemeProvider private var theme
    @Environment(\.dismiss) private var dismiss
    
    let errorMessage: String
    let closeAction: (() -> Void)? = nil
    
    var body: some View {
        BottomSheetView {
            Text(SharedStrings.errorBottomSheet)
                .font(theme.font.h6)
                .foregroundColor(theme.color.onSurface)
            
            Spacer().frame(height: 16)
            
            Text(errorMessage)
                .fixedSize(horizontal: false, vertical: true)
                .font(theme.font.body1)
                .foregroundColor(theme.color.onSurface)
            
            Spacer().frame(height: 32)
            
            Button {
                closeAction?() ?? dismiss()
            } label: {
                Text(LoginStrings.loginButton)
                    .font(theme.font.button)
                    .foregroundColor(theme.color.onError)
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, minHeight: 56.0)
            .contentShape(Rectangle())
            .background(theme.color.error)
            .cornerRadius(8)
        }
        .background(theme.color.surface)
    }
}
