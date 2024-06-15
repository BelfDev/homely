//
//  ThemeManager.swift
//  homely
//
//  Created by Pedro Belfort on 15.06.24.
//

import Foundation
import SwiftUI

class ThemeManager: ObservableObject {
    @Published var selectedTheme: ThemeProtocol = Main()
    
    func setTheme(_ theme: ThemeProtocol) {
        selectedTheme = theme
    }
}
