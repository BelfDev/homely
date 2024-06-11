//
//  LoginView.swift
//  homely
//
//  Created by Pedro Belfort on 08.06.24.
//

import SwiftUI

struct LoginView: View {
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack(alignment: .top) {
                BackgroundImage(minHeight: geometry.size.height * 0.3)
                Text("Homely")
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .padding(.top, geometry.size.height * 0.12)
                
                ScrollView {
                    
                    VStack {
                        Spacer()
                            .frame(height: 32.0)
                        Text("Login")
                            .foregroundStyle(.black)
                            .font(.title)
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
                        
                        Spacer()
                            .frame(height: 400.0)
                    }
                    .padding([.horizontal, .bottom], 24.0)
                    .background(
                        UnevenRoundedRectangle(
                            cornerRadii: .init(topLeading: 32.0, topTrailing: 32.0),
                            style: .continuous
                        )
                        .foregroundStyle(.white)
                    )
                    .frame(maxWidth: .infinity, minHeight: geometry.size.height * 0.7)
                    .padding(.top, geometry.size.height * 0.3)
                }
                .scrollBounceBehavior(.basedOnSize)
            }
            .edgesIgnoringSafeArea(.bottom)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.blue, .white, .white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
    }
}

#Preview {
    LoginView()
}

struct LoginButton: View {
    var body: some View {
        Button {
            print("Log user in")
        } label: {
            Text("Login")
                .font(.title2)
                .bold()
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, minHeight: 56.0)
        .background(.black)
        .cornerRadius(8.0)
    }
}

struct SignUpRow: View {
    var body: some View {
        HStack {
            Text("Don't have an account?")
            Spacer()
            Button {
                print("Sign up")
            } label: {
                HStack {
                    Text("Sign Up")
                    Image(systemName: "arrow.right")
                }
            }
            
        }
    }
}

struct ForgotPasswordButton: View {
    var body: some View {
        HStack {
            Spacer()
            Button("Forgot password?") {
                print("Forgot")
            }
        }
    }
}

struct PasswordInputField: View {
    @State private var password: String = ""
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 8.0) {
                Text("Password")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                    .frame(height: 15, alignment: .leading)
                
                SecureField("", text: $password)
                    .font(.system(size: 17, weight: .thin))
                    .foregroundColor(.primary)
                    .frame(height: 48.0)
                    .padding(.horizontal, 12)
                    .background(.gray)
                    .cornerRadius(16.0)
            }
    }
}

struct EmailInputField: View {
    @State private var email: String = ""
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 8.0) {
                Text("Login")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                    .frame(alignment: .leading)
                
                TextField("", text: $email)
                    .font(.system(size: 17, weight: .thin))
                    .foregroundColor(.primary)
                    .frame(height: 48.0)
                    .padding(.horizontal, 12)
                    .background(.gray)
                    .cornerRadius(16.0)
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
