//
//  MainTheme.swift
//  homely
//
//  Created by Pedro Belfort on 15.06.24.
//

import Foundation
import SwiftUI

struct MainTypographyTheme: TypographyThemeProtocol {
    var h1: Font { return .custom(Fonts.hankenGroteskLight, size: 96.0, relativeTo: .largeTitle) }
    var h2: Font { return .custom(Fonts.hankenGroteskLight, size: 60.0, relativeTo: .title) }
    var h3: Font { return .custom(Fonts.hankenGroteskRegular, size: 48.0, relativeTo: .title2) }
    var h4: Font { return .custom(Fonts.hankenGroteskRegular, size: 34.0, relativeTo: .title3) }
    var h5: Font { return .custom(Fonts.hankenGroteskRegular, size: 24.0, relativeTo: .headline) }
    var h6: Font { return .custom(Fonts.hankenGroteskMedium, size: 20.0) }
    var subtitle1: Font { return .custom(Fonts.hankenGroteskRegular, size: 16.0, relativeTo: .subheadline) }
    var subtitle2: Font { return .custom(Fonts.hankenGroteskMedium, size: 14.0) }
    var body1: Font { return .custom(Fonts.hankenGroteskLight, size: 16.0) }
    var body2: Font { return .custom(Fonts.hankenGroteskLight, size: 14.0, relativeTo: .body) }
    var button: Font { return .custom(Fonts.hankenGroteskBold, size: 18.0) }
    var caption: Font { return .custom(Fonts.hankenGroteskRegular, size: 12.0, relativeTo: .caption) }
    var overline: Font { return .custom(Fonts.hankenGroteskRegular, size: 10.0, relativeTo: .caption2) }
}


struct MainColorTheme: ColorThemeProtocol {
    var primary: Color { return Color("primary") }
    var surfaceTint: Color { return Color("surfaceTint") }
    var onPrimary: Color { return Color("onPrimary") }
    var primaryContainer: Color { return Color("primaryContainer") }
    var onPrimaryContainer: Color { return Color("onPrimaryContainer") }
    var secondary: Color { return Color("secondary") }
    var onSecondary: Color { return Color("onSecondary") }
    var secondaryContainer: Color { return Color("secondaryContainer") }
    var onSecondaryContainer: Color { return Color("onSecondaryContainer") }
    var tertiary: Color { return Color("tertiary") }
    var onTertiary: Color { return Color("onTertiary") }
    var tertiaryContainer: Color { return Color("tertiaryContainer") }
    var onTertiaryContainer: Color { return Color("onTertiaryContainer") }
    var error: Color { return Color("error") }
    var onError: Color { return Color("onError") }
    var errorContainer: Color { return Color("errorContainer") }
    var onErrorContainer: Color { return Color("onErrorContainer") }
    var background: Color { return Color("background") }
    var onBackground: Color { return Color("onBackground") }
    var surface: Color { return Color("surface") }
    var onSurface: Color { return Color("onSurface") }
    var outline: Color { return Color("outline") }
    var outlineVariant: Color { return Color("outlineVariant") }
    var shadow: Color { return Color("shadow") }
    var scrim: Color { return Color("scrim") }
    var inverseSurface: Color { return Color("inverseSurface") }
    var inverseOnSurface: Color { return Color("inverseOnSurface") }
    var inversePrimary: Color { return Color("inversePrimary") }
    var surfaceDim: Color { return Color("surfaceDim") }
    var surfaceBright: Color { return Color("surfaceBright") }
    var surfaceContainerLowest: Color { return Color("surfaceContainerLowest") }
    var surfaceContainerLow: Color { return Color("surfaceContainerLow") }
    var surfaceContainer: Color { return Color("surfaceContainer") }
    var surfaceContainerHigh: Color { return Color("surfaceContainerHigh") }
    var surfaceContainerHighest: Color { return Color("surfaceContainerHighest") }
}

struct MainTheme: ThemeProtocol {
    var font: TypographyThemeProtocol { return MainTypographyTheme() }
    var color: ColorThemeProtocol { return MainColorTheme() }
}
