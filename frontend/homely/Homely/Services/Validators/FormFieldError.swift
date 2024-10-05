//
//  FormFieldError.swift
//  Homely
//
//  Created by Pedro Belfort on 05.10.24.
//

import Foundation

enum FormFieldError: Equatable {
    
    case empty
    case invalidEmail
    case invalidPassword(minCount: Int)
    
    var errorFeedback: String {
        switch self {
        case .empty:
            return SharedStrings.errorEmptyField
        case .invalidEmail:
            return SharedStrings.errorInvalidEmail
        case .invalidPassword(let minCount):
            return SharedStrings.errorShortPassword(minCount: minCount)
        }
    }
}
