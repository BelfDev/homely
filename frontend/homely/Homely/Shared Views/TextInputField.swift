//
//  TextInputField.swift
//  Homely
//
//  Created by Pedro Belfort on 07.10.24.
//

import SwiftUI

enum TextInputContentType {
    case email, firstName, lastName, text(label: String), textArea(
        label: String
    )
    
    var defaultLabel: String {
        switch self {
        case .email:
            SharedStrings.emailInputLabel
        case .firstName:
            SharedStrings.firstNameInputLabel
        case .lastName:
            SharedStrings.lastNameInputLabel
        case .text(let label):
            label
        case .textArea(let label):
            label
        }
    }
    
    var textContentType: UITextContentType {
        switch self {
        case .email:
                .emailAddress
        case .firstName:
                .givenName
        case .lastName:
                .familyName
        case .text:
                .name
        case .textArea:
                .name
        }
    }
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .email:
                .emailAddress
        case .firstName:
                .namePhonePad
        case .lastName:
                .namePhonePad
        case .text:
                .default
        case .textArea:
                .default
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
            
                Group {
                    switch type {
                    case .email, .firstName, .lastName, .text:
                        TextField("", text: input)
                            .frame(height: 48.0)
                            .padding(.horizontal, 12)
                            
                    case .textArea:
                        TextEditor(text: input)
                            .frame(height: 300.0)
                            .padding(.horizontal, 12)
                            .scrollContentBackground(.hidden)
                            .autocapitalization(.sentences)
                    }
                }
                .background(theme.color.surfaceContainerHigh)
                .cornerRadius(8)
                .textContentType(type.textContentType)
                .keyboardType(type.keyboardType)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                
                ErrorInputFieldLabel(error: error)
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
    
    TextInputField(
        type: .textArea(label: "Hi"),
        input: fakeInput
    )
    .padding()
    .environment(components)
}
