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
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    TextInputField(
                        type: .firstName,
                        input: $vm.firstName,
                        error: vm.validations?.firstNameFieldError
                    )
                    .padding(.top, 24)
                    .focused($focusedField, equals: .firstName)
                    .submitLabel(.next)
                    TextInputField(
                        type: .lastName,
                        input: $vm.lastName,
                        error: vm.validations?.lastNameFieldError
                    )
                    .focused($focusedField, equals: .lastName)
                    .submitLabel(.next)
                    TextInputField(
                        type: .email,
                        input: $vm.email,
                        error: vm.validations?.emailFieldError
                    )
                    .focused($focusedField, equals: .email)
                    .submitLabel(.next)
                    PasswordInputField(
                        input: $vm.password,
                        error: vm.validations?.passwordFieldError
                    )
                    .focused($focusedField, equals: .password)
                    .submitLabel(.done)
                    Spacer(minLength: 16)
                    FilledButton(title: SignUpStrings.screenTitle, action: vm.signUp)
                        .padding(.bottom, 54)
                }
                .sheet(isPresented: $vm.hasGeneralError) {
                    ErrorBottomSheet(errorMessage: vm.errorMessage)
                }
                .onSubmit(focusNextField)
                .frame(minHeight: geometry.size.height)
                .padding(.horizontal, 16)
            }
            .disabled(vm.isLoading)
            .overlay {
                if vm.isLoading {
                    LoadingOverlay()
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
            .scrollBounceBehavior(.basedOnSize)
            .background(theme.color.surface)
            .navigationTitle(SignUpStrings.screenTitle)
            .toolbarTitleDisplayMode(.inlineLarge)
        }
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
        case firstName, lastName, email, password
    }
    
    private func focusNextField() {
        switch focusedField {
        case .firstName:
            focusedField = .lastName
        case .lastName:
            focusedField = .email
        case .email:
            focusedField = .password
        case .password:
            focusedField = nil
        case .none:
            break
        }
    }
}
