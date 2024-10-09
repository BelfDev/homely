//
//  SignUpResponse.swift
//  Homely
//
//  Created by Pedro Belfort on 09.10.24.
//

import Foundation

struct SignUpResponse: Codable {
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
