//
//  LoginView.swift
//  homely
//
//  Created by Pedro Belfort on 08.06.24.
//

import SwiftUI

struct LoginView: View {    
    @EnvironmentObject private var theme: ThemeManager
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack(alignment: .top) {
                BackgroundImage(minHeight: geometry.size.height * 0.3)
                Text("Homely")
                    .foregroundStyle(theme.current.color.onPrimary)
                    .font(theme.current.font.h2)
                    .bold()
                    .padding(.top, geometry.size.height * 0.12)
                
                ScrollView {
                    
                    VStack {
                        Spacer()
                            .frame(height: 32.0)
                        
                        Text("Login")
                            .font(theme.current.font.h5)
                            .bold()
                            .foregroundColor(theme.current.color.onSurface)
                        Spacer()
                            .frame(height: 32.0)
                        EmailInputField()
                        Spacer()
                            .frame(height: 24.0)
                        PasswordInputField()
                        Spacer()
                            .frame(height: 8.0)
                        ForgotPasswordButton()
                        Spacer()
                        LoginButton()
                        Spacer()
                            .frame(height: 8.0)
                        SignUpRow()
                    }
                    .padding([.horizontal, .bottom], 24.0)
                    .background(
                        UnevenRoundedRectangle(
                            cornerRadii: .init(topLeading: 32.0, topTrailing: 32.0),
                            style: .continuous
                        )
                        .foregroundStyle(theme.current.color.surface)
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
                                 theme.current.color.surface,
                                 theme.current.color.surface]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(ThemeManager())
}

struct LoginButton: View {
    @EnvironmentObject private var theme: ThemeManager
    
    var body: some View {
        Button {
            print("Log user in")
        } label: {
            Text("Login")
                .font(theme.current.font.button)
                .foregroundColor(theme.current.color.onPrimary)
        }
        .frame(maxWidth: .infinity, minHeight: 56.0)
        .background(theme.current.color.primary)
        .cornerRadius(8)
    }
}

struct SignUpRow: View {
    @EnvironmentObject private var theme: ThemeManager
    
    var body: some View {
        HStack {
            Text("Don't have an account?")
                .font(theme.current.font.body1)
                .foregroundColor(theme.current.color.onSurface)
            Spacer()
            Button {
                print("Sign up")
            } label: {
                HStack {
                    Text("Sign Up")
                        .font(theme.current.font.body1)
                        .foregroundColor(theme.current.color.onSurface)
                    Image(systemName: "arrow.right")
                        .foregroundColor(theme.current.color.onSurface)
                }
            }
            
        }
    }
}

struct ForgotPasswordButton: View {
    @EnvironmentObject private var theme: ThemeManager
    
    var body: some View {
        HStack {
            Spacer()
            Button("Forgot password?") {
                print("Forgot")
            }
            .font(theme.current.font.body1)
            .foregroundColor(theme.current.color.onSurface)
        }
    }
}

struct PasswordInputField: View {
    @EnvironmentObject private var theme: ThemeManager
    @State private var password: String = ""
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 8.0) {
                Text("Password")
                    .font(theme.current.font.body1)
                    .fontWeight(.medium)
                    .foregroundColor(theme.current.color.onSurface)
                    .frame(height: 15, alignment: .leading)
           
                HStack {
                    SecureField("", text: $password)
                    Image(systemName:"eye")
                        .foregroundColor(theme.current.color.onSurface)
                }
                .frame(height: 48.0)
                .padding(.horizontal, 12)
                .background(theme.current.color.surfaceContainerHigh)
                .cornerRadius(8)
            }
    }
}

struct EmailInputField: View {
    @EnvironmentObject private var theme: ThemeManager
    @State private var email: String = ""
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 8.0) {
                Text("E-mail")
                    .font(theme.current.font.body1)
                    .fontWeight(.medium)
                    .foregroundColor(theme.current.color.onSurface)
                    .frame(alignment: .leading)
                
                TextField("", text: $email)
                .frame(height: 48.0)
                .padding(.horizontal, 12)
                .background(theme.current.color.surfaceContainerHigh)
                .cornerRadius(8)
            }
    }
}

struct BackgroundImage: View {
    let minHeight: CGFloat
    
    var body: some View {
        Image(.background)
            .resizable()
            .scaledToFit()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity, minHeight: minHeight)
            .edgesIgnoringSafeArea(.all)
    }
}
