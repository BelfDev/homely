//
//  LoginView.swift
//  homely
//
//  Created by Pedro Belfort on 08.06.24.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack(alignment: .top) {
                Image(.background)
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, minHeight: geometry.size.height * 0.3)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    
                    VStack {
                        Text("Homely")
                            .foregroundStyle(.white)
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity, minHeight: geometry.size.height * 0.3)
                        
                        
                        VStack {
                            Spacer()
                                .frame(height: 32.0)
                            
                            Text("Login")
                                .foregroundStyle(.black)
                                .font(.title)
                            
                            Spacer()
                                .frame(height: 32.0)
                            
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
                            
                            Spacer()
                                .frame(height: 24.0)
                            
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
                            
                            Spacer()
                                .frame(height: 8.0)
                            
                            // OK
                            HStack {
                                Spacer()
                                Button("Forgot password?") {
                                    print("Forgot")
                                }
                            }
                            
                            
                            Spacer()
                            
                            // OK
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
                            
                            Spacer()
                                .frame(height: 8.0)
                            
                            // OK
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
                        .padding([.horizontal, .bottom], 24.0)
                        .background(
                            UnevenRoundedRectangle(
                                cornerRadii: .init(topLeading: 32.0, topTrailing: 32.0),
                                style: .continuous
                            )
                            .foregroundStyle(.white)
                        )
                    }
                    .frame(maxWidth: .infinity, minHeight: geometry.size.height)
                }
                .scrollBounceBehavior(.basedOnSize)
            }
            .edgesIgnoringSafeArea(.bottom)
            .background(.white)
        }
    }
}

#Preview {
    LoginView()
}
