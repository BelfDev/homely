//
//  DummyModel.swift
//  homely
//
//  Created by Pedro Belfort on 08.06.24.
//

import Foundation

struct DummyModel: Identifiable {
    
    var id = UUID()
    var prop: String = "Hello, World!"
    
}

let dummyData = DummyModel()
