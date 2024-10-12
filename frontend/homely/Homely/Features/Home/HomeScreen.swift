//
//  HomeScreen.swift
//  Homely
//
//  Created by Pedro Belfort on 29.09.24.
//

import SwiftUI

struct HomeScreen: ScreenProtocol {
    static var id = ScreenID.home
    
    @ThemeProvider private var theme
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    @State private var vm: HomeViewModel
    
    init(_ components: ComponentManager) {
        vm = HomeViewModel(with: components)
    }
    
    var body: some View {
        ScrollView {
            Spacer(minLength: 32)
            
            Text("Welcome\nPerson")
                .font(theme.font.h3)
            
            Spacer(minLength: 40)
            
            Button {
                vm.logout()
            } label: {
                Text("Logout")
            }
            
            Spacer(minLength: 40)
            
            LazyVGrid(columns: columns, spacing: 16) {
                FeatureModuleView(title: "Rewards", description: "Track household tasks", iconName: "star")
                FeatureModuleView(title: "Shopping List", description: "Manage groceries", iconName: "cart")
                FeatureModuleView(title: "Bills", description: "Track monthly expenses", iconName: "creditcard")
                FeatureModuleView(title: "Chores", description: "Daily chores schedule", iconName: "list.bullet")
            }
            .padding(8)
        }
        .padding(.horizontal, 24)
        .background(theme.color.surface)
        .scrollBounceBehavior(.basedOnSize)
        .navigationTitle("Home Screen")
        .toolbarTitleDisplayMode(.inlineLarge)
    }
    
}

#Preview {
    let components = ComponentManager(.development)
    HomeScreen(components)
        .environment(NavigationManager<HomeRoute>())
        .environment(components)
}
