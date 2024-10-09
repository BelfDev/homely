//
//  SignUpScreen.swift
//  Homely
//
//  Created by Pedro Belfort on 08.10.24.
//

import SwiftUI

struct SignUpScreen: ScreenProtocol {
    static var id = ScreenID.signUp
    
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
            //            Spacer(minLength: 32)
            
            Spacer()
            FilledButton(title: SignUpStrings.screenTitle, action: vm.signUp)
        }
        .navigationTitle(SignUpStrings.screenTitle)
        .toolbarTitleDisplayMode(.inlineLarge)
        .padding(.horizontal, 16.0)
        .padding(.top, 32.0)
        .padding(.bottom, 54)
        .ignoresSafeArea(.keyboard)
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
