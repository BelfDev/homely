//
//  LoginScreen.swift
//  homely
//
//  Created by Pedro Belfort on 08.06.24.
//

import SwiftUI

struct LoginScreen: ScreenProtocol {
    static var id = ScreenID.login
    
    @ThemeProvider private var theme
    @ComponentsProvider private var components // Review this
    @NavigationManagerProvider<LoginRoute> private var navigation
    
    @State private var vm: LoginViewModel
    @FocusState private var focusedField: FocusedField?
    
    init(_ components: ComponentManager) {
        vm = LoginViewModel(with: components)
    }
    
    var body: some View {
        LoginScreenScaffold(
            isLoading: vm.isLoading
        ) { geometry in
            BackgroundImage(minHeight: geometry.size.height * 0.4)
            
            HomelyAppTitle()
                .padding(.top, geometry.size.height * 0.15)
            
            mainContent()
                .padding(.top, geometry.size.height * 0.30)
                .sheet(isPresented: $vm.hasGeneralError) {
                    ErrorBottomSheet(errorMessage: vm.errorMessage)
                }
                .onSubmit(focusNextField)
        }
    }
    
    private func mainContent() -> some View {
        VStack(spacing: 24) {
            Text(LoginStrings.screenTitle)
                .font(theme.font.h5)
                .bold()
                .foregroundColor(theme.color.onSurface)
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
            
            Spacer()
            
            FilledButton(
                title: LoginStrings.loginButton,
                action: vm.login
            )
            SignUpRow() {
                navigation.navigate(to: .signUp)
            }
            .padding(.top, -16.0)
        }
        .padding(.horizontal, 24.0)
        .padding(.vertical, 24.0)
        .background(
            UnevenRoundedRectangle(
                cornerRadii: .init(
                    topLeading: 32.0,
                    topTrailing: 32.0
                ),
                style: .continuous
            ).foregroundStyle(theme.color.surface)
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
    let minHeight: CGFloat
    
    var body: some View {
        Image(.background)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: minHeight, alignment: .topLeading)
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
                .frame(maxWidth: .infinity, minHeight: geometry.size.height)
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
        .ignoresSafeArea(.keyboard)    }
}

#Preview {
    let components = ComponentManager(.development)
    LoginScreen(components)
        .environment(NavigationManager<LoginRoute>())
        .environment(components)
}
