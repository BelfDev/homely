//
//  LoginRequestBody.swift
//  Homely
//
//  Created by Pedro Belfort on 21.09.24.
//

import Foundation

struct LoginRequestBody: Encodable {
    let email: String
    let password: String
}

extension LoginRequestBody {
    func validate() -> LoginFormValidations {
        return LoginFormValidations(input: self)
    }
}
