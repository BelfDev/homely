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
struct SessionManagerProvider: DynamicProperty {
    @Environment(ComponentManager.self) private var components
    
    var wrappedValue: SessionManager {
        components.session
    }
}

//@propertyWrapper
//struct NavigationManagerProvider<T: Route>: DynamicProperty {
//    @Environment(NavigationManager<T>.self) private var navigator
//    
//    var wrappedValue: NavigationManager<T> {
//        navigator
//    }
//}


@propertyWrapper
struct NavigationManagerProvider: DynamicProperty {
    @Environment(NavigationManager.self) private var navigator
    
    var wrappedValue: NavigationManager {
        navigator
    }
}
