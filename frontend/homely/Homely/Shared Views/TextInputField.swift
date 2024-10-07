//
//  TextInputField.swift
//  Homely
//
//  Created by Pedro Belfort on 07.10.24.
//

import SwiftUI

enum TextInputContentType {
    case email
    
    var defaultLabel: String {
        switch self {
        case .email:
            SharedStrings.emailInputLabel
        }
    }
    
    var textContentType: UITextContentType {
        switch self {
        case .email:
                .emailAddress
        }
    }
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .email:
                .emailAddress
        }
    }
}

struct TextInputField: View {
    @ThemeProvider private var theme
    
    let type: TextInputContentType
    
    var label: String?
    var input: Binding<String>
    var error: FormFieldError?
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 8.0) {
                Text(label ?? type.defaultLabel)
                    .font(theme.font.body1)
                    .fontWeight(.medium)
                    .foregroundColor(theme.color.onSurface)
                    .frame(alignment: .leading)
                    .padding([.leading], 2)
                
                TextField("", text: input)
                    .frame(height: 48.0)
                    .padding(.horizontal, 12)
                    .background(theme.color.surfaceContainerHigh)
                    .cornerRadius(8)
                    .textContentType(type.textContentType)
                    .keyboardType(type.keyboardType)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
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
}

#Preview {
    let components = ComponentManager(.development)
    let fakeInput = Binding<String>(
        get: { "fake" },
        set: { _ in }
    )
    
    TextInputField(
        type: .email,
        input: fakeInput
    )
    .padding()
    .environment(components)
}
