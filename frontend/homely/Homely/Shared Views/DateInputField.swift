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
    @State private var showClearButton = false
    
    var label: String
    var input: Binding<Date?>
    var minimumDate: Date?
    var error: FormFieldError?
    
    let dateRange: ClosedRange<Date>
    let animationDuration: Double = 0.20
    var onDateSelected: ((Date) -> Void)? = nil

    init(
        label: String,
        input: Binding<Date?>,
        error: FormFieldError? = nil,
        minimumDate: Date? = nil
    ) {
        self.label = label
        self.input = input
        self.error = error
        self.minimumDate = minimumDate

        let calendar = Calendar.current
        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)
        let endOfYear = calendar.date(
            byAdding: .year,
            value: 1,
            to: startOfToday
        )!
        self.dateRange = (minimumDate ?? startOfToday)...endOfYear
    }

    
    var body: some View {
        VStack(alignment: .leading) {
            if isDatePickerVisible, let selectedDate = input.wrappedValue {
                HStack {
                    DatePicker(
                        label,
                        selection: Binding<Date>(
                            get: { selectedDate },
                            set: {
                                input.wrappedValue = $0
                                onDateSelected?($0)
                            }
                        ),
                        in: dateRange,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.compact)
                    .gesture(
                        DragGesture(minimumDistance: 20)
                            .onEnded { value in
                                if value.translation.width < 0 {
                                    withAnimation(
                                        .easeInOut(duration: animationDuration)
                                    ) {
                                        showClearButton = true
                                    }
                                } else if value.translation.width > 0 {
                                    withAnimation(
                                        .easeInOut(duration: animationDuration)
                                    ) {
                                        showClearButton = false
                                    }
                                }
                            }
                    )
                       
                    if showClearButton {
                        Button(
                            action: {
                                withAnimation(
                                    .easeInOut(duration: animationDuration)
                                ) {
                                    input.wrappedValue = nil
                                    isDatePickerVisible = false
                                    showClearButton = false
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(theme.color.error)
                                    .accessibilityLabel(
                                        SharedStrings.dateInputClearAccessibility
                                    )
                            }
                            .buttonStyle(.plain)
                            .padding(.leading, 4)
                            .transition(.opacity.combined(with: .scale))
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
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
