//
//  LoginView.swift
//  homely
//
//  Created by Pedro Belfort on 08.06.24.
//

import SwiftUI

struct LoginScreen: View {
    @EnvironmentObject private var theme: ThemeManager
    
    var body: some View {
        GeometryReader { geometry in
    
            ZStack(alignment: .top) {
                BackgroundImage(minHeight: geometry.size.height * 0.3)
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
}

#Preview {
    LoginScreen()
        .environmentObject(ThemeManager())
}
