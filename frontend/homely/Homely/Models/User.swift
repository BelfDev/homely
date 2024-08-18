//
//  User.swift
//  Homely
//
//  Created by Pedro Belfort on 11.08.24.
//

import Foundation

struct User: Codable, Identifiable {
    var id: Int
    var login: String?
    var avatar_url: String?
    
    init(id: Int, login: String? = nil, avatar_url: String? = nil) {
        self.id = id
        self.login = login
        self.avatar_url = avatar_url
    }
}
