//
//  NewTaskRequestBody.swift
//  Homely
//
//  Created by Pedro Belfort on 19.01.25.
//

import Foundation

struct NewTaskRequestBody: Encodable {
    let title: String
    let description: String?
    let start: Date?
    let end: Date?
}

extension NewTaskRequestBody {
    func validate() -> NewTaskFormValidations {
        return NewTaskFormValidations(input: self)
    }
}
