//
//  APIService.swift
//  MPViewerApp
//
//  Created by Egor Geronin on 02.12.2025.
//

import Foundation
import MPDTO

final class APIService {
    static let shared = APIService()
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchBuilds() async throws -> BuildsResponse {
        let urlString = Endpoints.builds()
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.httpError(statusCode: httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        
        do {
            let dto = try decoder.decode(GetBuildsResponseDTO.self, from: data)
            return BuildsResponse(from: dto)
        } catch {
            throw APIError.decodingError(error)
        }
    }
    
    func fetchTestSuiteLog(testSuiteResultId: UUID) async throws -> String {
        let urlString = Endpoints.testSuiteLog(testSuiteResultId: testSuiteResultId)
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.httpError(statusCode: httpResponse.statusCode)
        }
        
        guard let logText = String(data: data, encoding: .utf8) else {
            throw APIError.decodingError(NSError(domain: "Не удалось декодировать лог как UTF-8", code: -1))
        }
        
        return logText
    }
}

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Неверный URL"
        case .invalidResponse:
            return "Неверный ответ"
        case .httpError(let statusCode):
            return "HTTP ошибка со статус-кодом: \(statusCode)"
        case .decodingError(let error):
            return "Ошибка декодирования: \(error.localizedDescription)"
        }
    }
}

