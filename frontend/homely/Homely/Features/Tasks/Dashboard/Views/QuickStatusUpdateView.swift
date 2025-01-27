//
//  QuickStatusUpdateView.swift
//  Homely
//
//  Created by Pedro Belfort on 27.01.25.
//

import SwiftUI

// TODO(BelfDev): Shake up this layout.
struct QuickStatusUpdateView: View {
    @ThemeProvider private var theme

    let task: TaskModel
    let onStatusChange: (TaskStatus) -> Void
    let onClose: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 16) {
                HStack {
                    Spacer()
                    Spacer()
                    Text("Update Status")
                        .font(theme.font.h5)
                    Spacer()

                    Button(action: onClose) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title.weight(.regular))
                            .foregroundColor(theme.color.onSurface)
                            .clipShape(Circle())

                    }

                }
                .padding(.vertical, 8)

                ForEach(TaskStatus.allCases, id: \.self) { status in
                    Button(action: {
                        onStatusChange(status)
                    }) {
                        Text(status.localizedName)
                            .foregroundColor(theme.color.onPrimary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(theme.color.secondary)
                            )
                    }
                }

            }
            .padding()
            .background(theme.color.surface)
            .cornerRadius(16)
            .shadow(radius: 10)
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    let components = ComponentManager(.development)

    NavigationStack {
        QuickStatusUpdateView(
            task: TaskModel.makeStub(),
            onStatusChange: { _ in },
            onClose: {}
        )
        .environment(components)
    }

}
