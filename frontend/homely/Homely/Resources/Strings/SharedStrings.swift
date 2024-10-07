//
//  SharedStrings.swift
//  Homely
//
//  Created by Pedro Belfort on 25.09.24.
//

import SwiftUI

struct SharedStrings {
    private static let table = "Shared"
}

// MARK: - ErrorBottomSheet

extension SharedStrings {
    static let errorBottomSheetTitle = String(localized: "key:error_bottom_sheet_title", table: table)
    static let errorBottomSheetButton = String(localized: "key:error_bottom_sheet_button", table: table)
}

// MARK: - Error Feedback

extension SharedStrings {
    static let errorInvalidCredentials = String(localized: "key:error_invalid_credentials", table: table)
    static let errorGeneric = String(localized: "key:error_generic", table: table)
    
    static let errorEmptyField = String(localized: "key:error_empty_field", table: table)
    static let errorInvalidEmail = String(localized: "key:error_invalid_email", table: table)
    static func errorShortPassword(minCount: Int) -> String {
        let format = String(localized: "key:error_short_password", table: table)
        return String.localizedStringWithFormat(format, minCount)
    }
}

// MARK: - Input Fields

extension SharedStrings {
    static let emailInputLabel = String(localized: "key:email_input_label", table: table)
    static let passwordInputLabel = String(localized: "key:password_input_label", table: table)
}
