//
//  AuthentificationViewModel.swift
//  miet_practice_application
//
//  Created by Egor Geronin on 23.11.2025.
//

import Combine

final class AuthentificationViewModel: ObservableObject {

    @Published var viewState = AuthentificationViewState(
        loginText: "",
        passwordText: ""
    )

    func handle(_ viewInput: AuthentificationViewInput) {
        switch viewInput {
        case .didTapSignIn:
            break
        }
    }
}
