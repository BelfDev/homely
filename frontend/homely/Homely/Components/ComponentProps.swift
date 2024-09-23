//
//  ComponentProps.swift
//  Homely
//
//  Created by Pedro Belfort on 22.09.24.
//

import SwiftUI

@propertyWrapper
struct ThemeProvider: DynamicProperty {
    @Environment(ComponentManager.self) private var components
    
    var wrappedValue: ThemeManager {
        components.theme
    }
}
