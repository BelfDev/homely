//
//  ContentView.swift
//  homely
//
//  Created by Pedro Belfort on 26.05.24.
//

import SwiftUI

struct ContentView: View {
    var data: DummyModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: "photo")
            
            CustomImage()
            Text(data.prop)
            Text("3 ingredients")
                .font(.subheadline)
        }
        .padding()
    }
}

#Preview {
    ContentView(data: dummyData)
}

struct CustomImage: View {
    var body: some View {
        Image(systemName: "globe")
            .imageScale(.large)
            .foregroundStyle(.tint)
    }
}
