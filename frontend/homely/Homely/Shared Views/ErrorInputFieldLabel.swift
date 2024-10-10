//
//  ErrorInputFieldLabel.swift
//  Homely
//
//  Created by Pedro Belfort on 07.10.24.
//

import SwiftUI

struct ErrorInputFieldLabel: View {
    @ThemeProvider private var theme
    
    var error: FormFieldError?
    
    var body: some View {
        if let error = self.error {
            Text(error.errorFeedback)
                .font(theme.font.body2)
                .foregroundColor(theme.color.error)
                .padding([.leading], 2)
                .transition(.opacity)
                .animation(.easeInOut, value: error)
        }
    }
}

#Preview {
    let components = ComponentManager(.development)
    
    ErrorInputFieldLabel()
        .padding()
        .environment(components)
}
