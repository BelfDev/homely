//
//  PasswordInputField.swift
//  Homely
//
//  Created by Pedro Belfort on 07.10.24.
//

import SwiftUI

struct PasswordInputField: View {
    @ThemeProvider private var theme
    @State private var isPasswordVisible: Bool = false
    
    var label: String?
    var input: Binding<String>
    var error: FormFieldError?
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 8.0) {
                Text(label ?? SharedStrings.passwordInputLabel)
                    .font(theme.font.body1)
                    .fontWeight(.medium)
                    .foregroundColor(theme.color.onSurface)
                    .frame(height: 15, alignment: .leading)
                    .padding([.leading], 2)
                
                HStack {
                    
                    Group {
                        if isPasswordVisible {
                            TextField("", text: input)
                        } else {
                            SecureField("", text: input)
                        }
                    }
                    .textContentType(.password)
                    .keyboardType(.default)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .symbolEffect(.bounce, value: isPasswordVisible)
                        .foregroundColor(theme.color.onSurface)
                        .onTapGesture {
                            isPasswordVisible.toggle()
                        }
                }
                .frame(height: 48.0)
                .padding(.horizontal, 12)
                .background(theme.color.surfaceContainerHigh)
                .cornerRadius(8)
                
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
    
    PasswordInputField(
        input: fakeInput
    )
    .padding()
    .environment(components)
}
