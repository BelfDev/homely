//
//  LoginStringKeys.swift
//  Homely
//
//  Created by Pedro Belfort on 10.08.24.
//

import SwiftUI

struct LoginStrings {
    private static let table = "LoginScreen"
    
    static let emailInputLabel = String(localized: "key:email_input_label", table: table)
    static let forgotPasswordButton = String(localized: "key:forgot_password_button", table: table)
    static let loginButton = String(localized: "key:login_button", table: table)
    static let screenTitle = String(localized: "key:login_screen_title", table: table)
    static let passwordInputLabel = String(localized: "key:password_input_label", table: table)
    static let signUpButton = String(localized: "key:sign_up_button", table: table)
    static let signUpHelperText = String(localized: "key:sign_up_helper_text", table: table)
}
