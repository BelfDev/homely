//
//  FilledTextFieldStyle.swift
//  homely
//
//  Created by Pedro Belfort on 15.06.24.
//

import Foundation
import SwiftUI

//struct FilledTextFieldStyle: TextFieldStyle {
//    func _body(configuration: TextField<Self._Label>) -> some View {
//        configuration
//            .padding(10)
//            .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing))
//            .cornerRadius(20)
//            .shadow(color: .gray, radius: 10)
//    }
//}

struct FilledTextFieldStyle: TextFieldStyle {
    @EnvironmentObject private var theme: ThemeManager
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .frame(height: 48.0)
            .padding(.horizontal, 12)
            .background(theme.color.background)
            .cornerRadius(8)
        
        
        
        //                    .font(.system(size: 17, weight: .thin))
        //                    .foregroundColor(.primary)
//                            .frame(height: 48.0)
//                            .padding(.horizontal, 12)
//                            .background(.gray)
//                            .cornerRadius(16.0)
    }
}
