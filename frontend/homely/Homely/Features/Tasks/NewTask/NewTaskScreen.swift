//
//  NewTaskScreen.swift
//  Homely
//
//  Created by Pedro Belfort on 18.01.25.
//

import SwiftUI

struct NewTaskScreen: View {
    @ThemeProvider private var theme
    @NavigationManagerProvider private var navigator
    
    @State private var vm: NewTaskViewModel
    @FocusState private var focusedField: FocusedField?
    
    init(_ components: ComponentManager) {
        vm = NewTaskViewModel(with: components)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    TextInputField(
                        type: .text(
                            label: NewTaskStrings.titleInputLabel
                        ),
                        input: $vm.title,
                        error: vm.validations?.titleFieldError
                    )
                    .padding(.top, 24)
                    .focused($focusedField, equals: .title)
                    .submitLabel(.next)
                    
                    DateInputField(
                        label: NewTaskStrings.startAtInputLabel,
                        input: $vm.startAt,
                        error: vm.validations?.startAtFieldError
                    )
                    .focused($focusedField, equals: .start)
                    .submitLabel(.next)
                    
                    DateInputField(
                        label: NewTaskStrings.endAtInputLabel,
                        input: $vm.endAt,
                        minimumDate: vm.startAt,
                        error: vm.validations?.endAtFieldError
                    )
                    .focused($focusedField, equals: .end)
                    .submitLabel(.next)
                    
                    TextInputField(
                        type: .textArea(
                            label: NewTaskStrings.descriptionInputLabel
                        ),
                        input: $vm.description,
                        error: vm.validations?.descriptionFieldError
                    )
                    .focused($focusedField, equals: .description)
                    .submitLabel(.done)
                    
                    FilledButton(
                        title: NewTaskStrings.createTaskButton,
                        action: vm.createNewTask
                    )
                }
                .sheet(isPresented: $vm.hasGeneralError) {
                    ErrorBottomSheet(errorMessage: vm.errorMessage)
                }
                .onSubmit(focusNextField)
                .frame(minHeight: geometry.size.height, alignment: .top)
                .padding(.horizontal, 16)
            }
            .disabled(vm.isLoading)
            .overlay {
                if vm.isLoading {
                    LoadingOverlay()
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
            .scrollBounceBehavior(.basedOnSize)
            .background(theme.color.surface)
            .navigationBarTitle(NewTaskStrings.screenTitle)
            .toolbarTitleDisplayMode(.inlineLarge)
            .onChange(of: vm.taskCreated) {
                navigator.pop()
            }
        }
    }
}

// MARK: - Focus

private extension NewTaskScreen {
    private enum FocusedField {
        case title, description, start, end
    }
    
    private func focusNextField() {
        switch focusedField {
        case .title:
            focusedField = .description
        case .start:
            focusedField = .end
        case .end:
            focusedField = .description
        case .description:
            focusedField = nil
        case .none:
            break
        }
    }
}

#Preview {
    let components = ComponentManager(.development)
    let nav = NavigationManager()
    
    NewTaskScreen(components)
        .environment(components)
        .environment(nav)
}
