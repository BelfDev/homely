//
//  EnvProviders.swift
//  Homely
//
//  Created by Pedro Belfort on 22.09.24.
//

import SwiftUI

@propertyWrapper
struct ComponentsProvider: DynamicProperty {
    @Environment(ComponentManager.self) private var components
    
    var wrappedValue: ComponentManager {
        components
    }
}

@propertyWrapper
struct ThemeProvider: DynamicProperty {
    @Environment(ComponentManager.self) private var components
    
    var wrappedValue: ThemeManager {
        components.theme
    }
}

@propertyWrapper
struct GlobalStateProvider: DynamicProperty {
    @Environment(ComponentManager.self) private var components
    
    var wrappedValue: GlobalState {
        components.globalState
    }
}
