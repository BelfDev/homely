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
    
    init(_ components: ComponentManager) {
        vm = LoginViewModel(with: components)
    }

    var body: some View {
         GeometryReader { geometry in
             ZStack(alignment: .top) {
                 backgroundImage(minHeight: geometry.size.height * 0.3)
                 
                 mainContent(geometry: geometry).disabled(vm.isLoading)
                 if vm.isLoading {
                    loadingOverlay
                 }
             }
             .edgesIgnoringSafeArea(.bottom)
             .background(
                 LinearGradient(
                     gradient: Gradient(
                         colors: [.blue, theme.color.surface, theme.color.surface]),
                     startPoint: .top,
                     endPoint: .bottom
                 )
             )
         }
     }
    
    private func mainContent(geometry: GeometryProxy) -> some View {
        ZStack(alignment: .top) {
            backgroundImage(minHeight: geometry.size.height * 0.3)
            Text(FixedStrings.appTitle)
                .foregroundStyle(theme.color.onPrimary)
                .font(theme.font.h2)
                .bold()
                .padding(.top, geometry.size.height * 0.12)
            
            ScrollView {
                
                VStack {
                    Spacer()
                        .frame(height: 32.0)
                    
                    Text(LoginStrings.screenTitle)
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
    
    private var emailInputField: some View {
        VStack(
            alignment: .leading,
            spacing: 8.0) {
                Text(LoginStrings.emailInputLabel)
                    .font(theme.font.body1)
                    .fontWeight(.medium)
                    .foregroundColor(theme.color.onSurface)
                    .frame(alignment: .leading)
                
                TextField("", text: $vm.email)
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
                Text(LoginStrings.passwordInputLabel)
                    .font(theme.font.body1)
                    .fontWeight(.medium)
                    .foregroundColor(theme.color.onSurface)
                    .frame(height: 15, alignment: .leading)
                
                HStack {
                    SecureField("", text: $vm.password)
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
            vm.login()
        } label: {
            Text(LoginStrings.loginButton)
                .font(theme.font.button)
                .foregroundColor(theme.color.onPrimary)
                .frame(maxWidth: .infinity) // Ensure text takes up the full button frame
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
    
    private var loadingOverlay: some View {
        ZStack {
              Color.black.opacity(0.5)
                  .edgesIgnoringSafeArea(.all)
              
              VStack {
                  ProgressView()
                      .progressViewStyle(CircularProgressViewStyle())
                      .scaleEffect(2.0)
                      .tint(theme.color.onPrimary)
              }
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .edgesIgnoringSafeArea(.all)
      }
}

#Preview {
    let components = ComponentManager(.development)
    LoginScreen(components).environment(components)
}
