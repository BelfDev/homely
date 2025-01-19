//
//  ButtonActionType.swift
//  Homely
//
//  Created by Pedro Belfort on 18.01.25.
//

import Foundation

enum ButtonActionType {
    case add
    
    var systemImageName: String {
        switch self {
        case .add:
            return "plus"
        }
    }
}
