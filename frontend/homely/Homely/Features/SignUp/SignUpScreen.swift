//
//  SignUpScreen.swift
//  Homely
//
//  Created by Pedro Belfort on 08.10.24.
//

import SwiftUI

struct SignUpScreen: View {
    @ThemeProvider private var theme
    @State private var vm: SignUpViewModel
    @FocusState private var focusedField: FocusedField?
    
    init(_ components: ComponentManager) {
        vm = SignUpViewModel(with: components)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            TextInputField(type: .firstName, input: $vm.firstName)
            TextInputField(type: .lastName, input: $vm.lastName)
            TextInputField(type: .email, input: $vm.email)
            PasswordInputField(input: $vm.password)
            Spacer(minLength: 32)
            FilledButton(title: SignUpStrings.screenTitle, action: vm.signUp)
        }
        .navigationTitle("Sign Up")
        .padding(.horizontal, 24.0)
        .padding(.top, 40.0)
        .padding(.bottom, 32.0)
    }
}

#Preview {
    let components = ComponentManager(.development)

    NavigationStack {
        SignUpScreen(components).environment(components)
    }
}

// MARK: - Focus

private extension SignUpScreen {
    private enum FocusedField {
        case email, password
    }
    
    private func focusNextField() {
        switch focusedField {
        case .email:
            focusedField = .password
        case .password:
            focusedField = nil
        case .none:
            break
        }
    }
}
