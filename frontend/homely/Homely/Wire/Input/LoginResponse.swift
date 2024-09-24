//
//  LoginResponse.swift
//  Homely
//
//  Created by Pedro Belfort on 11.08.24.
//

import Foundation

struct LoginResponse: Codable {
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
