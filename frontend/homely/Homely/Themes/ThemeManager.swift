//
//  ThemeManager.swift
//  homely
//
//  Created by Pedro Belfort on 15.06.24.
//

import SwiftUI

@Observable class ThemeManager{
    private var current: ThemeProtocol = MainTheme()
    
    func setTheme(_ theme: ThemeProtocol) {
        current = theme
    }
    
    var font: TypographyThemeProtocol  { return current.font }
    var color: ColorThemeProtocol  { return current.color }
}
