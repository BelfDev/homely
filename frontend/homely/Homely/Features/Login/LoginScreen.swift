//
//  LoginScreen.swift
//  homely
//
//  Created by Pedro Belfort on 08.06.24.
//

import SwiftUI

struct LoginScreen: View {
    @ThemeProvider private var theme
    @ComponentsProvider private var components
    @NavigationManagerProvider private var navigator
    
    @State private var vm: LoginViewModel
    @State private var showAutofill: Bool = true
    @FocusState private var focusedField: FocusedField?
    
    init(_ components: ComponentManager) {
        vm = LoginViewModel(with: components)
        vm.autofillLastEnteredEmail()
    }
    
    var body: some View {
        LoginScreenScaffold(
            isLoading: vm.isLoading
        ) { geometry in
            BackgroundImage(
                width: geometry.size.width,
                height: geometry.size.height * 0.4
            )
            
            HomelyAppTitle()
                .padding(.top, geometry.size.height * 0.15)
            
            mainContent()
                .frame(height: geometry.size.height * 0.7)
                .padding(.top, geometry.size.height * 0.3)
                .sheet(isPresented: $vm.hasGeneralError) {
                    ErrorBottomSheet(errorMessage: vm.errorMessage)
                }
                .onSubmit(focusNextField)
                .onChange(of: focusedField) { _, newFocus in
                    let willHideKeyboard = newFocus == nil
                    withAnimation(willHideKeyboard ? .easeInOut(duration: 0.5) : nil) {
                        showAutofill = willHideKeyboard
                    }
                }
        }
    }
    
    private func mainContent() -> some View {
        VStack(spacing: 24) {
            Text(LoginStrings.screenTitle)
                .font(theme.font.h5)
                .bold()
                .foregroundColor(theme.color.onSurface)
                .padding(.top, 24)
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
            
            Toggle("Remember me?", isOn: $vm.saveCredentials)
                .font(theme.font.body1)
                .foregroundColor(theme.color.onSurface)
                .padding(.horizontal, 2)
                .padding(.top, -16)
            
            if showAutofill {
                Spacer(minLength: 0)
                IconButton(
                    iconName: "faceid",
                    action: vm.authenticateWithFaceID
                )
                .font(theme.font.h2)
            }
            
            Spacer(minLength: 0)
            
            FilledButton(
                title: LoginStrings.loginButton,
                action: vm.login
            )
            SignUpRow() {
                navigator.push(LoginRoute.signUp)
            }
            .padding(.top, -16)
            .padding(.bottom, 24)
        }
        .padding(.horizontal, 24)
        .background(
            UnevenRoundedRectangle(
                cornerRadii: .init(
                    topLeading: 32,
                    topTrailing: 32
                ),
                style: .continuous
            )
            .foregroundStyle(theme.color.surface)
        )
    }
}

// MARK: - Focus

private extension LoginScreen {
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

// MARK: - Subviews

private struct HomelyAppTitle: View {
    @ThemeProvider private var theme
    
    var body: some View {
        Text(FixedStrings.appTitle)
            .foregroundStyle(theme.color.onPrimary)
            .font(theme.font.h2)
            .bold()
    }
}

private struct BackgroundImage: View {
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        Image(.background)
            .resizable()
            .scaledToFill()
            .frame(width: width, height: height)
    }
}

private struct SignUpRow: View {
    @ThemeProvider private var theme
    
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text(LoginStrings.signUpHelperText)
                .font(theme.font.body1)
                .foregroundColor(theme.color.onSurface)
                .padding([.leading], 2)
            Spacer()
            TextButton(
                title: LoginStrings.signUpButton,
                action: action,
                showIcon: true
            )
        }
    }
}

private struct LoginScreenScaffold<Content>: View where Content : View {
    @ThemeProvider private var theme
    
    var isLoading: Bool
    @ViewBuilder var content: (GeometryProxy) -> Content
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ZStack(alignment: .top) {
                    content(geometry)
                }
                .frame(
                    idealWidth: geometry.size.width,
                    minHeight: geometry.size.height
                )
            }
            .scrollBounceBehavior(.basedOnSize)
            .background(theme.color.surface)
            .disabled(isLoading)
            .overlay {
                if isLoading {
                    LoadingOverlay()
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    let components = ComponentManager(.development)
    LoginScreen(components)
        .environment(NavigationManager())
        .environment(components)
}
