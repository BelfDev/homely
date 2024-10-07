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
    @State private var isPasswordVisible: Bool = false
    
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
            Spacer()
                .frame(maxHeight: 24.0)
            passwordInputField
            Spacer()
                .frame(maxHeight: 8.0)
            forgotPasswordButton
            Spacer()
                .frame(minHeight: 16.0)
            loginButton
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
            Button {
                print("Sign up")
            } label: {
                HStack {
                    Text(LoginStrings.signUpButton)
                        .font(theme.font.body1)
                        .foregroundColor(theme.color.onSurface)
                    Image(systemName: "arrow.right")
                        .foregroundColor(theme.color.onSurface)
                }
            }
        }
    }
    
    private var passwordInputField: some View {
        VStack(
            alignment: .leading,
            spacing: 8.0) {
                Text(SharedStrings.passwordInputLabel)
                    .font(theme.font.body1)
                    .fontWeight(.medium)
                    .foregroundColor(theme.color.onSurface)
                    .frame(height: 15, alignment: .leading)
                    .padding([.leading], 2)
                
                HStack {
                    
                    Group {
                        if isPasswordVisible {
                            TextField("", text: $vm.password)
                        } else {
                            SecureField("", text: $vm.password)
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
                
                if let passwordError = vm.validations?.passwordFieldError {
                    Text(passwordError.errorFeedback)
                        .font(theme.font.body2)
                        .foregroundColor(theme.color.error)
                        .padding([.leading], 2)
                        .transition(.opacity)
                        .animation(.easeInOut, value: passwordError)
                }
            }
    }
    
    private var loginButton: some View {
        Button {
            vm.login()
        } label: {
            Text(LoginStrings.loginButton)
                .font(theme.font.button)
                .foregroundColor(theme.color.onPrimary)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, minHeight: 56.0)
        .contentShape(Rectangle())
        .background(theme.color.primary)
        .cornerRadius(8)
    }
    
    private var forgotPasswordButton: some View {
        HStack {
            Spacer()
            Button {
                print("Forgot")
            } label: {
                Text(LoginStrings.forgotPasswordButton)
                    .font(theme.font.body1)
                    .foregroundColor(theme.color.onSurface)
            }
            
        }
    }
}

#Preview {
    let components = ComponentManager(.development)
    LoginScreen(components).environment(components)
}
