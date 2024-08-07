//
//  LoginView.swift
//  homely
//
//  Created by Pedro Belfort on 08.06.24.
//

import SwiftUI

struct LoginScreen: View {
    @EnvironmentObject private var theme: ThemeManager
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack(alignment: .top) {
                backgroundImage(minHeight: geometry.size.height * 0.3)
                Text("Homely")
                    .foregroundStyle(theme.color.onPrimary)
                    .font(theme.font.h2)
                    .bold()
                    .padding(.top, geometry.size.height * 0.12)
                
                ScrollView {
                    
                    VStack {
                        Spacer()
                            .frame(height: 32.0)
                        
                        Text("Login")
                            .font(theme.font.h5)
                            .bold()
                            .foregroundColor(theme.color.onSurface)
                        Spacer()
                            .frame(height: 32.0)
                        emailInputField
                        Spacer()
                            .frame(height: 24.0)
                        passwordInputField
                        Spacer()
                            .frame(height: 8.0)
                        forgotPasswordButton
                        Spacer()
                        loginButton
                        Spacer()
                            .frame(height: 8.0)
                        signUpRow
                    }
                    .padding([.horizontal, .bottom], 24.0)
                    .background(
                        UnevenRoundedRectangle(
                            cornerRadii: .init(topLeading: 32.0, topTrailing: 32.0),
                            style: .continuous
                        )
                        .foregroundStyle(theme.color.surface)
                    )
                    .frame(maxWidth: .infinity, minHeight: geometry.size.height * 0.7)
                    .padding(.top, geometry.size.height * 0.3)
                }
                .scrollBounceBehavior(.basedOnSize)
            }
            .edgesIgnoringSafeArea(.bottom)
            .background(
                LinearGradient(
                    gradient: Gradient(
                        colors: [.blue,
                                 theme.color.surface,
                                 theme.color.surface]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
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
            Text("Don't have an account?")
                .font(theme.font.body1)
                .foregroundColor(theme.color.onSurface)
            Spacer()
            Button {
                print("Sign up")
            } label: {
                HStack {
                    Text("Sign Up")
                        .font(theme.font.body1)
                        .foregroundColor(theme.color.onSurface)
                    Image(systemName: "arrow.right")
                        .foregroundColor(theme.color.onSurface)
                }
            }
            
        }
    }
    
    private var emailInputField: some View {
        VStack(
            alignment: .leading,
            spacing: 8.0) {
                Text("E-mail")
                    .font(theme.font.body1)
                    .fontWeight(.medium)
                    .foregroundColor(theme.color.onSurface)
                    .frame(alignment: .leading)
                
                TextField("", text: $email)
                    .frame(height: 48.0)
                    .padding(.horizontal, 12)
                    .background(theme.color.surfaceContainerHigh)
                    .cornerRadius(8)
            }
    }
    
    private var passwordInputField: some View {
        VStack(
            alignment: .leading,
            spacing: 8.0) {
                Text("Password")
                    .font(theme.font.body1)
                    .fontWeight(.medium)
                    .foregroundColor(theme.color.onSurface)
                    .frame(height: 15, alignment: .leading)
                
                HStack {
                    SecureField("", text: $password)
                    Image(systemName:"eye")
                        .foregroundColor(theme.color.onSurface)
                }
                .frame(height: 48.0)
                .padding(.horizontal, 12)
                .background(theme.color.surfaceContainerHigh)
                .cornerRadius(8)
            }
    }
    
    private var loginButton: some View {
        Button {
            print("Log user in")
        } label: {
            Text("Login")
                .font(theme.font.button)
                .foregroundColor(theme.color.onPrimary)
        }
        .frame(maxWidth: .infinity, minHeight: 56.0)
        .background(theme.color.primary)
        .cornerRadius(8)
    }
    
    private var forgotPasswordButton: some View {
        HStack {
            Spacer()
            Button("Forgot password?") {
                print("Forgot")
            }
            .font(theme.font.body1)
            .foregroundColor(theme.color.onSurface)
        }
    }
}

#Preview {
    LoginScreen()
        .environmentObject(ThemeManager())
}
