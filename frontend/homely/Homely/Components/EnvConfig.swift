//
//  Environment.swift
//  Homely
//
//  Created by Pedro Belfort on 21.09.24.
//

import Foundation

enum EnvConfig {
    case development
    case production
    
    var baseHomelyAPIUrl: String {
        switch self {
        case .development:
            return "http://127.0.0.1:5050"
        case .production:
            return "https://homely-uabv.onrender.com"
        }
        
    }
}
