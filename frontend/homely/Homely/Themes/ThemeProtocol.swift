//
//  ThemeProtocol.swift
//  homely
//
//  Created by Pedro Belfort on 15.06.24.
//

import SwiftUI

protocol TypographyThemeProtocol {
    /// Light | 96
    var h1: Font { get }
    /// Light | 60
    var h2: Font { get }
    /// Regular | 48
    var h3: Font { get }
    /// Regular | 34
    var h4: Font { get }
    /// Regular | 24
    var h5: Font { get }
    /// Medium | 20
    var h6: Font { get }
    /// Regular | 16
    var subtitle1: Font { get }
    /// Medium | 14
    var subtitle2: Font { get }
    /// Light | 16
    var body1: Font { get }
    /// Light | 14
    var body2: Font { get }
    /// Bold | 18
    var button: Font { get }
    /// Bold | 16
    var button2: Font { get }
    /// Regular | 12
    var caption: Font { get }
    /// Regular | 10
    var overline: Font { get }
}

protocol ColorThemeProtocol {
    var primary: Color { get }
    var surfaceTint: Color { get }
    var onPrimary: Color { get }
    var primaryContainer: Color { get }
    var onPrimaryContainer: Color { get }
    var secondary: Color { get }
    var onSecondary: Color { get }
    var secondaryContainer: Color { get }
    var onSecondaryContainer: Color { get }
    var tertiary: Color { get }
    var onTertiary: Color { get }
    var tertiaryContainer: Color { get }
    var onTertiaryContainer: Color { get }
    var error: Color { get }
    var onError: Color { get }
    var errorContainer: Color { get }
    var onErrorContainer: Color { get }
    var background: Color { get }
    var onBackground: Color { get }
    var surface: Color { get }
    var onSurface: Color { get }
    var outline: Color { get }
    var outlineVariant: Color { get }
    var shadow: Color { get }
    var scrim: Color { get }
    var inverseSurface: Color { get }
    var inverseOnSurface: Color { get }
    var inversePrimary: Color { get }
    var surfaceDim: Color { get }
    var surfaceBright: Color { get }
    var surfaceContainerLowest: Color { get }
    var surfaceContainerLow: Color { get }
    var surfaceContainer: Color { get }
    var surfaceContainerHigh: Color { get }
    var surfaceContainerHighest: Color { get }
}

protocol ThemeProtocol {
    var font: TypographyThemeProtocol { get }
    var color: ColorThemeProtocol { get }
}
