//
//  View+Keyboard.swift
//  Homely
//
//  Created by Pedro Belfort on 29.09.24.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
