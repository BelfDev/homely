//
//  LoginViews.swift
//  homely
//
//  Created by Pedro Belfort on 06.08.24.
//

import SwiftUI

struct LoginButton: View {
    @EnvironmentObject private var theme: ThemeManager
    
    var body: some View {
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
}

struct SignUpRow: View {
    @EnvironmentObject private var theme: ThemeManager
    
    var body: some View {
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
}

struct ForgotPasswordButton: View {
    @EnvironmentObject private var theme: ThemeManager
    
    var body: some View {
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

struct PasswordInputField: View {
    @EnvironmentObject private var theme: ThemeManager
    @State private var password: String = ""
    
    var body: some View {
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
}

struct EmailInputField: View {
    @EnvironmentObject private var theme: ThemeManager
    @State private var email: String = ""
    
    var body: some View {
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
