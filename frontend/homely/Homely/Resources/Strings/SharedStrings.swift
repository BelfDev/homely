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
    static let errorBottomSheetTitle = String(
        localized: "key:error_bottom_sheet_title",
        table: table
    )
    static let errorBottomSheetButton = String(
        localized: "key:error_bottom_sheet_button",
        table: table
    )
}

// MARK: - Error Feedback

extension SharedStrings {
    static let errorInvalidCredentials = String(
        localized: "key:error_invalid_credentials",
        table: table
    )
    static let errorGeneric = String(
        localized: "key:error_generic",
        table: table
    )
    
    static let errorEmptyField = String(
        localized: "key:error_empty_field",
        table: table
    )
    static let errorInvalidEmail = String(
        localized: "key:error_invalid_email",
        table: table
    )
    static func errorShortPassword(minCount: Int) -> String {
        let format = String(localized: "key:error_short_password", table: table)
        return String.localizedStringWithFormat(format, minCount)
    }
    static let errorInvalidName = String(
        localized: "key:error_invalid_name",
        table: table
    )
    static let errorRequestTimeout = String(
        localized: "key:error_request_timeout",
        table: table
    )
}

// MARK: - Input Fields

extension SharedStrings {
    static let emailInputLabel = String(
        localized: "key:email_input_label",
        table: table
    )
    static let passwordInputLabel = String(
        localized: "key:password_input_label",
        table: table
    )
    static let firstNameInputLabel = String(
        localized: "key:first_name_input_label",
        table: table
    )
    static let lastNameInputLabel = String(
        localized: "key:last_name_input_label",
        table: table
    )
    static let dateInputPlaceholder = String(
        localized: "key:date_input_placeholder",
        table: table
    )
    static let dateInputClearAccessibility = String(
        localized: "key:date_input_clear_accessibility",
        table: table
    )
    static let errorEndDateBeforeStartDate = String(
        localized: "key:error_end_date_before_start_date",
        table: table
    )
    static let errorDateInPast = String(
        localized: "key:error_date_in_past",
        table: table
    )
    static let errorTooLongText = String(
        localized: "key:error_too_long_text",
        table: table
    )
    static func errorTooLongText(maxCount: Int) -> String {
        let format = String(localized: "key:error_too_long_text", table: table)
        return String.localizedStringWithFormat(format, maxCount)
    }
    static func errorDateRangeTooShort(minDuration: Int) -> String {
        let format = String(
            localized: "key:error_date_range_too_short",
            table: table
        )
        return String.localizedStringWithFormat(format, minDuration)
    }
    static let swipeToDeleteButton = String(
        localized: "key:swipe_to_delete",
        table: table
    )
}
