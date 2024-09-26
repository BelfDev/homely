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
}
