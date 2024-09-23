//
//  LoginComponentProps.swift
//  Homely
//
//  Created by Pedro Belfort on 23.09.24.
//

import SwiftUI

@propertyWrapper
struct LoginViewModelProvider: DynamicProperty {
    @Environment(ComponentManager.self) private var components
    
    var wrappedValue: LoginViewModel {
        LoginViewModel(with: components)
    }
}
