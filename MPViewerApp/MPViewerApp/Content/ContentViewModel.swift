//
//  ContentViewModel.swift
//  MPViewerApp
//
//  Created by Egor Geronin on 02.12.2025.
//

import Combine

final class ContentViewModel: ObservableObject {
    @MainActor @Published private(set) var state = ContentViewState() {
        didSet {
            print("Отладка: \(state)")
        }
    }

    func handle(input: ContentViewInput) async {
        switch input {
        case .viewDidAppear:
            await fetchNextBuilds()
        case .didTapReload:
            await fetchNextBuilds()
        }
    }

    func fetchNextBuilds() async {
        guard state.loadingState != .loading else {
            return
        }
        await updateState { $0.loadingState = .loading }
        do {
            let response = try await APIService.shared.fetchBuilds()
            state.builds = response.builds
            await updateState { $0.loadingState = .loaded }
        } catch {
            await updateState { $0.loadingState = .error }
        }
    }

    @MainActor
    func updateState(_ changeState: ((inout ContentViewState) -> Void)) async {
        changeState(&state)
    }
}
