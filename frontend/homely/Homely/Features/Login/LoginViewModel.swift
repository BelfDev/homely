//
//  LoginScreenState.swift
//  Homely
//
//  Created by Pedro Belfort on 11.08.24.
//

import Foundation
import Combine

// Placeholder
class HomeViewModel: ObservableObject {

    enum ViewState {
        case START
        case LOADING
        case SUCCESS(users: [User])
        case FAILURE(error: String)
    }

    @Published var currentState: ViewState = .START
    private var cancelables = Set<AnyCancellable>()

    init() {
        getUsers()
    }

    func getUsers() {
        self.currentState = .LOADING
        APIService.shared.getUsers()
            .sink { completion in
                switch completion {
                case .finished:
                    print("Execution Finihsed.")
                case .failure(let error):
                    self.currentState = .FAILURE(error: error.localizedDescription)
                }
            } receiveValue: { users in
                print(users)
                self.currentState = .SUCCESS(users: users)
            }.store(in: &cancelables)
    }
}
