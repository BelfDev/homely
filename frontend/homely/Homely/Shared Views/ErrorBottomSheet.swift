//
//  ErrorBottomSheet.swift
//  Homely
//
//  Created by Pedro Belfort on 24.09.24.
//

import SwiftUI

struct BottomSheetView<Content>: View where Content : View {
    @ThemeProvider private var theme
    
    let content: Content
    let presentationDetents: Set<PresentationDetent>
    
    init(_ presentationDetents: Set<PresentationDetent>,
         @ViewBuilder content: () -> Content) {
        self.presentationDetents = presentationDetents
        self.content = content()
    }
    
    var body: some View {
        ScrollView {
            VStack {
                content
            }
            .padding([.horizontal, .vertical], 16.0)
            .presentationDetents(presentationDetents)
            .presentationCornerRadius(32)
            .presentationBackground(theme.color.surface)
        }
        .scrollBounceBehavior(.basedOnSize)
    }
}

struct ErrorBottomSheet: View {
    @ThemeProvider private var theme
    @Environment(\.dismiss) private var dismiss
    
    let errorMessage: String
    let closeAction: (() -> Void)?
    
    init(errorMessage: String, closeAction: (() -> Void)? = nil) {
           self.errorMessage = errorMessage
           self.closeAction = closeAction
       }
    
    var body: some View {
        BottomSheetView([.fraction(0.30)]) {
            Text(SharedStrings.errorBottomSheetTitle)
                .font(theme.font.h6)
                .foregroundColor(theme.color.onSurface)
            
            Spacer().frame(height: 16)
            
            Text(errorMessage)
                .fixedSize(horizontal: false, vertical: true)
                .font(theme.font.body1)
                .foregroundColor(theme.color.onSurface)
            
            Spacer().frame(height: 32)
            
            Button {
                closeAction?()
                dismiss()
            } label: {
                Text(SharedStrings.errorBottomSheetButton)
                    .font(theme.font.button)
                    .foregroundColor(theme.color.onError)
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, minHeight: 56.0)
            .contentShape(Rectangle())
            .background(theme.color.error)
            .cornerRadius(8)
        }
    }
}
