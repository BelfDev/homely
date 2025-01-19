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
    case invalidName
    case tooLong(maxCount: Int)
    case dateInPast
    case endDateBeforeStartDate
    case dateRangeTooShort(minDuration: TimeInterval)
    
    var errorFeedback: String {
        switch self {
        case .empty:
            return SharedStrings.errorEmptyField
        case .invalidEmail:
            return SharedStrings.errorInvalidEmail
        case .invalidPassword(let minCount):
            return SharedStrings.errorShortPassword(minCount: minCount)
        case .invalidName:
            return SharedStrings.errorInvalidName
        case .tooLong(let maxCount):
            return SharedStrings.errorTooLongText(maxCount: maxCount)
        case .dateInPast:
            return SharedStrings.errorDateInPast
        case .endDateBeforeStartDate:
            return SharedStrings.errorEndDateBeforeStartDate
        case .dateRangeTooShort(let minDuration):
            return SharedStrings
                .errorDateRangeTooShort(minDuration: Int(minDuration / 60))
        }
    }
}
