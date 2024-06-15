//
//  MainTheme.swift
//  homely
//
//  Created by Pedro Belfort on 15.06.24.
//

import Foundation
import SwiftUI

struct Main: ThemeProtocol {
    var largeTitleFont: Font = .custom("Graphik-Bold", size: 30.0)
    var textTitleFont: Font = .custom("Graphik-Medium", size: 24.0)
    var normalBtnTitleFont: Font = .custom("Graphik-Regular", size: 20.0)
    var boldBtnTitleFont: Font = .custom("Graphik-Regular", size: 20.0)
    var bodyTextFont: Font = .custom("Graphik-Light", size: 18.0)
    var captionTxtFont: Font = .custom("Graphik-SemiBold", size: 20.0)
  
    
    var surfaceThemeColor: Color { return Color("surfaceBackground") }
    var surfaceTintThemeColor: Color { return Color("tintBackground") }
//    var primaryThemeColor: Color { return Color("mnPrimaryThemeColor") }
//    var secondoryThemeColor: Color { return Color("mnSecondoryThemeColor") }
//    var affirmBtnTitleColor: Color { return Color("mnAffirmBtnTitleColor") }
//    var negativeBtnTitleColor: Color { return Color("mnNegativeBtnTitleColor") }
//    var bodyTextColor: Color { return Color("mnBodyTextColor") }
//    var textBoxColor: Color { return Color("mnTextBoxColor") }
}
