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
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .firstTextBaseline) {
                    Text(vm.greeting)
                        .font(theme.font.h3)
                    Spacer()
                    Button("Logout", action: vm.logout)
                        .buttonStyle(.bordered)
                }
                Text(vm.currentDate)
                    .font(theme.font.h6)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 16)
                        
            Spacer(minLength: 40)
            
            LazyVGrid(columns: columns, spacing: 16) {
                FeatureModuleView(title: "Rewards", description: "Track household tasks", iconName: "star")
                FeatureModuleView(title: "Shopping List", description: "Manage groceries", iconName: "cart")
                FeatureModuleView(title: "Bills", description: "Track monthly expenses", iconName: "creditcard")
                FeatureModuleView(title: "Chores", description: "Daily chores schedule", iconName: "list.bullet")
            }
            .padding(8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .background(theme.color.surface)
        .scrollBounceBehavior(.basedOnSize)
        .toolbarTitleDisplayMode(.inlineLarge)
    }
    
}

#Preview {
    let components = ComponentManager(.development)
    HomeScreen(components)
        .environment(NavigationManager<HomeRoute>())
        .environment(components)
}
