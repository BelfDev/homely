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
                        input: $vm.title
                        //                        error: vm.validations?.firstNameFieldError
                    )
                    .padding(.top, 24)
                    .focused($focusedField, equals: .title)
                    .submitLabel(.next)
                    
                    DateInputField(
                        label: NewTaskStrings.startAtInputLabel,
                        input: $vm.startAt
                    )
                    .focused($focusedField, equals: .start)
                    .submitLabel(.next)
                    
                    DateInputField(
                        label: NewTaskStrings.endAtInputLabel,
                        input: $vm.endAt,
                        minimumDate: vm.startAt
                    )
                    .focused($focusedField, equals: .end)
                    .submitLabel(.next)
                    
                    TextInputField(
                        type: .textArea(
                            label: NewTaskStrings.descriptionInputLabel
                        ),
                        input: $vm.description
                        //                                            error: vm.validations?.lastNameFieldError
                    )
                    .focused($focusedField, equals: .description)
                    .submitLabel(.done)

               
                    
                    //                    TextInputField(
                    //                        type: .email,
                    //                        input: $vm.email,
                    //                        error: vm.validations?.emailFieldError
                    //                    )
                    //                    .focused($focusedField, equals: .email)
                    //                    .submitLabel(.next)
                    //                    PasswordInputField(
                    //                        input: $vm.password,
                    //                        error: vm.validations?.passwordFieldError
                    //                    )
                    //                    .focused($focusedField, equals: .password)
                    //                    .submitLabel(.done)
                    //                    Spacer(minLength: 16)
                    //                    FilledButton(title: SignUpStrings.screenTitle, action: vm.signUp)
                    //                        .padding(.bottom, 54)
                }
                .sheet(isPresented: $vm.hasGeneralError) {
                    ErrorBottomSheet(errorMessage: vm.errorMessage)
                }
                //                .onSubmit(focusNextField)
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
            focusedField = .start 
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
