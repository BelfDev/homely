//
//  LoginScreen.swift
//  homely
//
//  Created by Pedro Belfort on 08.06.24.
//

import SwiftUI

struct LoginScreen: View {
    @ThemeProvider private var theme
    @State private var vm: LoginViewModel
    @FocusState private var focusedField: FocusedField?
    
    init(_ components: ComponentManager) {
        vm = LoginViewModel(with: components)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ZStack(alignment: .top) {
                    backgroundImage(minHeight: geometry.size.height * 0.4)
                    
                    Text(FixedStrings.appTitle)
                        .foregroundStyle(theme.color.onPrimary)
                        .font(theme.font.h2)
                        .bold()
                        .padding(.top, geometry.size.height * 0.18)
                    
                    mainContent(geometry: geometry)
                        .padding(.top, geometry.size.height * 0.35)
                        .sheet(isPresented: $vm.hasGeneralError) {
                            ErrorBottomSheet(errorMessage: vm.errorMessage)
                        }
                        .onSubmit(focusNextField)
                }
                .frame(maxWidth: .infinity, minHeight: geometry.size.height)
            }
            .frame(maxHeight: .infinity)
            .scrollBounceBehavior(.basedOnSize)
            .edgesIgnoringSafeArea(.all)
            .background(theme.color.surface)
            .disabled(vm.isLoading)
            .overlay {
                if vm.isLoading {
                    LoadingOverlay()
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
    
    private func mainContent(geometry: GeometryProxy) -> some View {
        VStack {
            Spacer()
                .frame(maxHeight: 32.0)
            
            Text(LoginStrings.screenTitle)
                .font(theme.font.h5)
                .bold()
                .foregroundColor(theme.color.onSurface)
            Spacer()
                .frame(maxHeight: 32.0)
            TextInputField(
                type: .email,
                input: $vm.email,
                error: vm.validations?.emailFieldError
            )
            .focused($focusedField, equals: .email)
            .submitLabel(.next)
            Spacer()
                .frame(maxHeight: 24.0)
            PasswordInputField(
                input: $vm.password,
                error: vm.validations?.passwordFieldError
            )
            .focused($focusedField, equals: .password)
            .submitLabel(.done)
            
            Spacer()
                .frame(minHeight: 16.0)
            FilledButton(
                title: LoginStrings.loginButton,
                action: vm.login
            )
            Spacer()
                .frame(maxHeight: 8.0)
            signUpRow
        }
        .padding([.horizontal, .bottom], 24.0)
        .background(
            UnevenRoundedRectangle(
                cornerRadii: .init(topLeading: 32.0, topTrailing: 32.0),
                style: .continuous
            ).foregroundStyle(theme.color.surface)
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func backgroundImage(minHeight: CGFloat) -> some View {
        Image(.background)
            .resizable()
            .scaledToFit()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity, minHeight: minHeight)
            .edgesIgnoringSafeArea(.all)
    }
    
    private var signUpRow: some View {
        HStack {
            Text(LoginStrings.signUpHelperText)
                .font(theme.font.body1)
                .foregroundColor(theme.color.onSurface)
                .padding([.leading], 2)
            Spacer()
            TextButton(
                title: LoginStrings.signUpButton,
                action: {print("TODO: Sign Up")},
                showIcon: true
            )
        }
    }
}

#Preview {
    let components = ComponentManager(.development)
    LoginScreen(components).environment(components)
}

// MARK: - Focus

extension LoginScreen {
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
