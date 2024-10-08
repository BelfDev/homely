//
//  HomeNavStack.swift
//  Homely
//
//  Created by Pedro Belfort on 29.09.24.
//

import SwiftUI

struct HomeRouter: View {
    @ComponentsProvider private var components
    
    var body: some View {
        NavigationStack {
            HomeScreen(components)
        }
    }
}
