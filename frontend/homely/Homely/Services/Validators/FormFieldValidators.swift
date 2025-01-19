//
//  FormFieldValidators.swift
//  Homely
//
//  Created by Pedro Belfort on 05.10.24.
//

import Foundation

struct FormFieldValidators {
    
    private init() {}
    
    // MARK: - Constants
    
    private static let titleMaxLength = 140
    private static let descriptionMaxLength = 280
    private static let minDateRange = TimeInterval(60)
    
    /// A regex pattern for basic email address validation.
    ///
    /// This pattern checks for a standard format with the following characteristics:
    /// - **Local Part**: Allows uppercase and lowercase letters, digits, and special characters
    ///   (`.`, `_`, `%`, `+`, `-`), while ensuring at least one character is present.
    /// - **Domain Part**: Allows uppercase and lowercase letters, digits, and hyphens,
    ///   separated by a period (`.`), with at least one domain segment.
    /// - **Top-Level Domain (TLD)**: Enforces a minimum of 2 and a maximum of 64 letters
    ///   (e.g., `.com`, `.net`, `.example`).
    ///
    /// ### Example Matches:
    /// - `example@example.com`
    /// - `user.name+tag@sub.domain.co`
    ///
    /// ### Limitations:
    /// - Does not support more complex email address formats (quoted strings, IP addresses).
    /// - Doesn't cover all valid email addresses as per [RFC 5322](https://www.ietf.org/rfc/rfc5322.txt) but provides a simpler, practical validation.
    private static let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    private static let emailRegex = try? NSRegularExpression(
        pattern: emailPattern,
        options: .caseInsensitive
    )
    private static let minPasswordLength = 6
    private static let namePattern = "[A-Za-z0-9\\p{Greek}\\-\\s]{2,64}"
    private static let nameRegex = try? NSRegularExpression(
        pattern: namePattern
    )
    
    
    // MARK: - Methods
    
    /// Validates an email address.
    ///
    /// - Parameter fieldValue: The email address to validate.
    /// - Returns: A `FormFieldError` if validation fails, otherwise `nil`.
    static func validateEmail(_ fieldValue: String?) -> FormFieldError? {
        guard let email = fieldValue, !email.isEmpty else {
            return .empty
        }
        guard let emailRegex = emailRegex else {
            return .invalidEmail
        }
        
        let range = NSRange(location: 0, length: email.utf16.count)
        if emailRegex.firstMatch(in: email, options: [], range: range) == nil {
            return .invalidEmail
        }
        
        return nil
    }
    
    /// Validates a password field based on specified criteria.
    ///
    /// - Parameter fieldValue: The password string to validate. Can be `nil`.
    /// - Returns: A `FormFieldError` if validation fails, otherwise `nil`.
    static func validatePassword(_ fieldValue: String?) -> FormFieldError? {
        guard let password = fieldValue, !password.isEmpty else {
            return .empty
        }
        
        if password.count < minPasswordLength {
            return .invalidPassword(minCount: minPasswordLength)
        }
        
        return nil
    }
    
    /// Validates a first or last name field.
    ///
    /// - Parameter fieldValue: The first or last name to validate.
    /// - Returns: A `FormFieldError` if validation fails, otherwise `nil`.
    static func validateName(_ fieldValue: String?) -> FormFieldError? {
        guard let name = fieldValue, !name.isEmpty else {
            return .empty
        }
        guard let nameRegex = nameRegex else {
            return .invalidName
        }
        
        let range = NSRange(location: 0, length: name.utf16.count)
        if nameRegex.firstMatch(in: name, options: [], range: range) == nil {
            return .invalidName
        }
        
        return nil
    }
    
    /// Validates a task title.
    ///
    /// - Parameter fieldValue: The title to validate.
    /// - Returns: A `FormFieldError` if validation fails, otherwise `nil`.
    static func validateTitle(_ fieldValue: String?) -> FormFieldError? {
        guard let title = fieldValue, !title.isEmpty else {
            return .empty
        }
            
        if title.count > titleMaxLength {
            return .tooLong(maxCount: titleMaxLength)
        }
            
        return nil
    }
    
    /// Validates a task description.
    ///
    /// - Parameter fieldValue: The description to validate.
    /// - Returns: A `FormFieldError` if validation fails, otherwise `nil`.
    static func validateDescription(_ fieldValue: String?) -> FormFieldError? {
        guard let description = fieldValue, !description.isEmpty else {
            return nil
        }
        
        if description.count > descriptionMaxLength {
            return .tooLong(maxCount: descriptionMaxLength)
        }
        
        return nil
    }
    
    /// Validates a `startAt` date to ensure it is in the future.
    ///
    /// - Parameter startAt: The start date to validate.
    /// - Returns: A `FormFieldError` if validation fails, otherwise `nil`.
    static func validateStartAt(_ startAt: Date?) -> FormFieldError? {
        guard let startAt = startAt else {
            return nil
        }
          
        if startAt < Date().addingTimeInterval(-1 * 60 * 60) {
            return .dateInPast
        }
          
        return nil
    }
    
    /// Validates an `endAt` date to ensure it is after `startAt`.
    ///
    /// - Parameters:
    ///   - startAt: The start date to compare against.
    ///   - endAt: The end date to validate.
    /// - Returns: A `FormFieldError` if validation fails, otherwise `nil`.
    static func validateEndAt(startAt: Date?, endAt: Date?) -> FormFieldError? {
        guard let endAt = endAt else {
            return nil
        }
        
        if let startAt = startAt {
            guard endAt > startAt else {
                return .endDateBeforeStartDate
            }
            
            if endAt.timeIntervalSince(startAt) < minDateRange {
                return .dateRangeTooShort(minDuration: minDateRange)
            }
        }
            
        return nil
    }
}
