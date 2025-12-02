//
//  ContentViewState.swift
//  MPViewerApp
//
//  Created by Egor Geronin on 02.12.2025.
//

struct ContentViewState {
    enum LoadingState {
        /// Начальный стейт
        case idle
        /// Загружается
        case loading
        /// Ошибка
        case error
        /// Загружено
        case loaded
    }

    /// Билды для отображения
    var builds: [BuildInfo] = []
    /// Стейт загрузки
    var loadingState: LoadingState = .idle
}
