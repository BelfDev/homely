//
//  ThemeProtocol.swift
//  homely
//
//  Created by Pedro Belfort on 15.06.24.
//

import Foundation
import SwiftUI

protocol ThemeProtocol {
    var largeTitleFont: Font { get }
    var textTitleFont: Font { get }
    var normalBtnTitleFont: Font { get }
    var boldBtnTitleFont: Font { get }
    var bodyTextFont: Font { get }
    var captionTxtFont: Font { get }
    
    var surfaceThemeColor: Color { get }
    var surfaceTintThemeColor: Color { get }
//    var primaryThemeColor: Color { get }
//    var secondoryThemeColor: Color { get }
//    var affirmBtnTitleColor: Color { get }
//    var negativeBtnTitleColor: Color { get }
//    var bodyTextColor: Color { get }
//    var textBoxColor: Color { get }
}
