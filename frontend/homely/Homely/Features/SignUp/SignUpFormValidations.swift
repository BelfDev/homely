//
//  SignUpFormValidations.swift
//  Homely
//
//  Created by Pedro Belfort on 09.10.24.
//

import Foundation

struct SignUpFormValidations {
    
    let firstNameFieldError: FormFieldError?
    let lastNameFieldError: FormFieldError?
    let emailFieldError: FormFieldError?
    let passwordFieldError: FormFieldError?
    
    var hasFieldErrors: Bool {
        return [
            firstNameFieldError,
            lastNameFieldError,
            emailFieldError,
            passwordFieldError
        ].contains(where: {$0 != nil})
    }
    
    init(input: SignUpRequestBody) {
        self.firstNameFieldError = FormFieldValidators.validateName(input.firstName)
        self.lastNameFieldError = FormFieldValidators.validateName(input.lastName)
        self.emailFieldError = FormFieldValidators.validateEmail(input.email)
        self.passwordFieldError = FormFieldValidators.validatePassword(input.password)
    }
}
