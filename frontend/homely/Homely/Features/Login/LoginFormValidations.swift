//
//  LoginFormValidations.swift
//  Homely
//
//  Created by Pedro Belfort on 05.10.24.
//

import Foundation

struct LoginFormValidations {
    
    let emailFieldError: FormFieldError?
    let passwordFieldError: FormFieldError?
        
    var hasFieldErrors: Bool {
        return [emailFieldError, passwordFieldError].contains(where: {$0 != nil})
    }
    
    init(input: LoginRequestBody) {
        self.emailFieldError = FormFieldValidators.validateEmail(input.email)
        self.passwordFieldError = FormFieldValidators.validatePassword(input.password)
    }
}
