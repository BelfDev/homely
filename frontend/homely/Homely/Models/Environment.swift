//
//  Environment.swift
//  Homely
//
//  Created by Pedro Belfort on 21.09.24.
//

import Foundation

enum Environment {
    case development
    case production
    
    var baseApiUrl: String {
        switch self {
        case .development:
            return "https://dev-api.example.com"
        case .production:
            return "https://api.example.com"
        }
        
    }
}
