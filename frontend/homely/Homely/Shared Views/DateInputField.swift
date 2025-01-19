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
    var onDateSelected: ((Date) -> Void)? = nil

    private let animationDuration: Double = 0.2

    private var dateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)
        let endOfYear = calendar.date(
            byAdding: .year,
            value: 1,
            to: startOfToday
        )!
        return (minimumDate ?? startOfToday)...endOfYear
    }

    var body: some View {
        VStack(alignment: .leading) {
            if isDatePickerVisible, let selectedDate = input.wrappedValue {
                SelectedDateView(
                    label: label,
                    selectedDate: selectedDate,
                    dateRange: dateRange,
                    onDateSelected: { selectedDate in
                        input.wrappedValue = selectedDate
                        onDateSelected?(selectedDate)
                    },
                    clearAction: clearDate
                )
                .transition(.opacity.combined(with: .move(edge: .top)))
            } else {
                SelectDateButton(label: label, action: showDatePicker)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }

            ErrorInputFieldLabel(error: error)
        }
        .font(theme.font.body1)
        .fontWeight(.medium)
        .foregroundColor(theme.color.onSurface)
        .animation(.easeInOut, value: isDatePickerVisible)
    }

    // MARK: - Actions

    private func showDatePicker() {
        withAnimation {
            input.wrappedValue = Date()
            isDatePickerVisible = true
        }
    }

    private func clearDate() {
        withAnimation(.easeInOut(duration: animationDuration)) {
            input.wrappedValue = nil
            isDatePickerVisible = false
            showClearButton = false
        }
    }
}

// MARK: - Subviews

private struct SelectedDateView: View {
    @ThemeProvider private var theme
    @State private var showClearButton = false
    
    let label: String
    let selectedDate: Date
    let dateRange: ClosedRange<Date>
    let onDateSelected: ((Date) -> Void)?
    let clearAction: () -> Void
    
    private let animationDuration: Double = 0.2

    var body: some View {
        HStack {
            DatePicker(
                label,
                selection: Binding<Date>(
                    get: { selectedDate },
                    set: { onDateSelected?($0) }
                ),
                in: dateRange,
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(.compact)
            .gesture(
                DragGesture(minimumDistance: 20)
                    .onEnded(handleSwipeGesture)
            )

            if showClearButton {
                ClearButton(action: clearAction)
                    .transition(.opacity.combined(with: .scale))
            }
        }
    }

    private func handleSwipeGesture(_ value: DragGesture.Value) {
        if value.translation.width < 0 {
            withAnimation(.easeInOut(duration: animationDuration)) {
                showClearButton = true
            }
        } else if value.translation.width > 0 {
            withAnimation(.easeInOut(duration: animationDuration)) {
                showClearButton = false
            }
        }
    }
}

private struct SelectDateButton: View {
    @ThemeProvider private var theme
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
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
    }
}

private struct ClearButton: View {
    @ThemeProvider private var theme
    let action: () -> Void

    var body: some View {
        Button(action: action) {
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
