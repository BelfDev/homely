//
//  LoginRequestBody.swift
//  Homely
//
//  Created by Pedro Belfort on 21.09.24.
//

import Foundation

struct LoginRequestBody {
    let email: String
    let password: String
    
    func toDictionary() -> [String: Any] {
        return [
            "email": email,
            "password": password
        ]
    }
}
