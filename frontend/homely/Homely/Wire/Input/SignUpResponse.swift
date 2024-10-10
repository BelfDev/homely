//
//  SignUpResponse.swift
//  Homely
//
//  Created by Pedro Belfort on 09.10.24.
//

import Foundation

struct SignUpResponse: Codable {
    
    let id: String
    let email: String
    let firstName: String
    let lastName: String
    let accessToken: String
}
