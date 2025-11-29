//
//  IRequestPerformer.swift
//  MPUtils
//
//  Created by Egor Geronin on 29.11.2025.
//

protocol IRequestPerformer {
    /// Выполнение запроса
    func perform<_Endpoint: Endpoint>(
        _ endpoint: _Endpoint
    ) async throws -> _Endpoint.Response
}
