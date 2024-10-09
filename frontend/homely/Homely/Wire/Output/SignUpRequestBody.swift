//
//  SignUpRequestBody.swift
//  Homely
//
//  Created by Pedro Belfort on 09.10.24.
//

import Foundation

struct SignUpRequestBody: Encodable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
}

extension SignUpRequestBody {
    func validate() -> SignUpFormValidations {
        return SignUpFormValidations(input: self)
    }
}
