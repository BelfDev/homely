//
//  ThemeManager.swift
//  homely
//
//  Created by Pedro Belfort on 15.06.24.
//

import Foundation
import SwiftUI

class ThemeManager: ObservableObject {
    @Published var current: ThemeProtocol = MainTheme()
    
    func setTheme(_ theme: ThemeProtocol) {
        current = theme
    }
}
