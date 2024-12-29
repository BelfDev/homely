//
//  NavigationManager.swift
//  Homely
//
//  Created by Pedro Belfort on 08.10.24.
//

import SwiftUI

typealias Route = Hashable & Codable

@Observable
final class NavigationManager {
    var path = NavigationPath()
    
    func push(_ route: any Route) {
        path.append(route)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}
