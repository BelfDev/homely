//
//  NewTaskFormValidations.swift
//  Homely
//
//  Created by Pedro Belfort on 19.01.25.
//

import Foundation

struct NewTaskFormValidations {
    
    let titleFieldError: FormFieldError?
    let startAtFieldError: FormFieldError?
    let endAtFieldError: FormFieldError?
    let descriptionFieldError: FormFieldError?
    
    var hasFieldErrors: Bool {
        return [
            titleFieldError,
            startAtFieldError,
            endAtFieldError,
            descriptionFieldError
        ].contains(where: {$0 != nil})
    }
    
    init(input: NewTaskRequestBody) {
        self.titleFieldError = FormFieldValidators.validateTitle(input.title)
        self.startAtFieldError = FormFieldValidators.validateStartAt(input.start)
        self.endAtFieldError = FormFieldValidators.validateEndAt(startAt: input.start, endAt: input.end)
        self.descriptionFieldError = FormFieldValidators.validateDescription(input.description)
    }
}
