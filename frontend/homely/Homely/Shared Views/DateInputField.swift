//
//  DateInputField.swift
//  Homely
//
//  Created by Pedro Belfort on 18.01.25.
//

import SwiftUI

struct DateInputField: View {
    @ThemeProvider private var theme
    @State private var isDatePickerVisible = false

    var label: String
    var input: Binding<Date?>
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
        VStack(alignment: .leading) {
            if isDatePickerVisible, let selectedDate = input.wrappedValue {
                HStack {
                    DatePicker(
                        label,
                        selection: Binding<Date>(
                            get: { selectedDate },
                            set: { input.wrappedValue = $0 }
                        ),
                        in: dateRange,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.compact)
                    
                    Button(action: {
                        withAnimation {
                            input.wrappedValue = nil
                            isDatePickerVisible = false
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(theme.color.error)
                            .accessibilityLabel(SharedStrings.dateInputClearAccessibility)
                    }
                    .buttonStyle(.plain)
                    .padding(.leading, 4)
                }
                .transition(
                    .opacity.combined(with: .move(edge: .top))
                )
            } else {
                Button(action: {
                    withAnimation {
                        input.wrappedValue = Date()
                        isDatePickerVisible = true
                    }
                }) {
                    HStack {
                        Text(label)
                        Spacer()
                        Text(SharedStrings.dateInputPlaceholder)
                            .foregroundColor(theme.color.secondary)
                            .padding(8)
                            .background(theme.color.surfaceContainerHigh)
                            .cornerRadius(10)
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }

            ErrorInputFieldLabel(error: error)
        }
        .font(theme.font.body1)
        .fontWeight(.medium)
        .foregroundColor(theme.color.onSurface)
        .animation(.easeInOut, value: isDatePickerVisible)
    }
}

#Preview {
    let components = ComponentManager(.development)
    let fakeInput = Binding<Date?>(
        get: { Date() },
        set: { _ in }
    )
    let fakeNilInput = Binding<Date?>(
        get: { nil },
        set: { _ in }
    )
    
    
    DateInputField(
        label: "Start Date",
        input: fakeInput
    )
    .padding()
    .environment(components)
    
    DateInputField(
        label: "Start Date",
        input: fakeNilInput
    )
    .padding()
    .environment(components)
}
