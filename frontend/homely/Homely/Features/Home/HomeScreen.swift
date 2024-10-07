//
//  HomeScreen.swift
//  Homely
//
//  Created by Pedro Belfort on 29.09.24.
//

import SwiftUI

struct HomeScreen: View {
    @ThemeProvider private var theme
    @State private var vm: HomeViewModel
    
    init(_ components: ComponentManager) {
        vm = HomeViewModel(with: components)
    }
    
    var body: some View {
        VStack {
            Text("Home Screen")
            
            Button {
                vm.logout()
            } label: {
                Text("Logout")
            }
        }
    }
}
