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
            VStack {
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
                
                CardView {
                    Text("Special Highlight")
                        .font(.headline)
                        .padding()
                }
                .frame(minHeight: 256)
                .padding(.vertical, 16)
                
                Group {
                    Text("Modules")
                        .font(theme.font.h5)
                        .fontWeight(.semibold)
                    
                    LazyVGrid(columns: columns, spacing: 16) {
                        FeatureModuleView(title: "Rewards", description: "Track household tasks", iconName: "star", backgroundColor: .green.opacity(0.2))
                        FeatureModuleView(title: "Shopping List", description: "Manage groceries", iconName: "cart", backgroundColor: .purple.opacity(0.2))
                        FeatureModuleView(title: "Bills", description: "Track monthly expenses", iconName: "creditcard", backgroundColor: .yellow.opacity(0.2))
                        FeatureModuleView(title: "Chores", description: "Daily chores schedule", iconName: "list.bullet", backgroundColor: .red.opacity(0.2))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.color.surface)
        .scrollClipDisabled()
        .scrollBounceBehavior(.basedOnSize)
        .toolbarTitleDisplayMode(.inline)
        .navigationTitle(FixedStrings.appTitle)
    }
    
}

#Preview {
    let components = ComponentManager(.development)
    HomeScreen(components)
        .environment(NavigationManager<HomeRoute>())
        .environment(components)
}
