//
//  NavigationManager.swift
//  Homely
//
//  Created by Pedro Belfort on 08.10.24.
//

import SwiftUI

typealias Route = Hashable & Codable

@Observable
final class NavigationManager<T: Route> {
    var path = NavigationPath()
    
    func navigate(to route: T) {
        path.append(route)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    
    func navigateToRoot() {
        path.removeLast(path.count)
    }
}
