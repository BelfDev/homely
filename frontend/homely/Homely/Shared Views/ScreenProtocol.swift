//
//  ScreenProtocol.swift
//  Homely
//
//  Created by Pedro Belfort on 08.10.24.
//

import SwiftUI

enum ScreenID: Codable, Hashable {
    case login, signUp, home
}

protocol ScreenProtocol: View {
    static var id: ScreenID { get }
}
