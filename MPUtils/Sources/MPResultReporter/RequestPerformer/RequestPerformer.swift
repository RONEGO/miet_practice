//
//  RequestPerformer.swift
//  MPUtils
//
//  Created by Egor Geronin on 29.11.2025.
//

import Foundation

final class RequestPerformer: IRequestPerformer {

    /// URL для endpoint-ов
    private let baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    /// Выполнение запроса
    func perform<_Endpoint: Endpoint>(
        _ endpoint: _Endpoint
    ) async throws -> _Endpoint.Response {
        let url: URL = baseURL.appending(path: endpoint.path)

        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(endpoint.request)

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let (data, _) = try await URLSession.shared.data(for: request)

        return try JSONDecoder().decode(_Endpoint.Response.self, from: data)
    }
}
