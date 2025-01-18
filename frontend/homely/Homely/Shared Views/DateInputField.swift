//
//  DateInputField.swift
//  Homely
//
//  Created by Pedro Belfort on 18.01.25.
//

import SwiftUI

struct DateInputField: View {
    @ThemeProvider private var theme

    var label: String
    var input: Binding<Date>
    var error: FormFieldError?
    
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)
        let endOfYear = calendar.date(
            byAdding: .year,
            value: 1,
            to: startOfToday
        )!
        return startOfToday...endOfYear
    }()
    
    var body: some View {
        DatePicker(
            label,
            selection: input,
            in: dateRange,
            displayedComponents: [.date, .hourAndMinute]
        )
        .datePickerStyle(.compact)
        
    }
}

#Preview {
    let components = ComponentManager(.development)
    let fakeInput = Binding<Date>(
        get: { Date() },
        set: { _ in }
    )
    
    DateInputField(
        label: "Start Date",
        input: fakeInput
    )
    .padding()
    .environment(components)
}
