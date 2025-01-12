//
//  HomeScreen.swift
//  Homely
//
//  Created by Pedro Belfort on 29.09.24.
//

import SwiftUI

struct HomeScreen: View {
    
    @ThemeProvider private var theme
    @NavigationManagerProvider private var navigator
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
                        Text(vm.currentDate)
                            .font(theme.font.h5)
                        Spacer()
                        Button("Logout", action: vm.logout)
                            .buttonStyle(.borderless)
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 16)
                
                CardView {
                    Text(TaskStrings.dashboardScreenTitle)
                        .font(theme.font.h5)
                        .bold()
                }
                .frame(minHeight: 256)
                .padding(.vertical, 16)
                .onTapGesture(perform:  {
                    navigator.push(HomeRoute.tasks)
                })
                
                Group {
                    Text("More will come, promise!")
                    Text("...")
                }
                .font(theme.font.h6)
                .foregroundColor(theme.color.secondary)
            }
            .padding()
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
        .environment(NavigationManager())
        .environment(components)
}
