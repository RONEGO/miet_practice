//
//  IEndpoint.swift
//  MPUtils
//
//  Created by Egor Geronin on 29.11.2025.
//

protocol Endpoint<Request, Response> {
    associatedtype Request: Encodable
    associatedtype Response: Decodable

    /// Путь к baseURL
    var path: String { get }
    /// Получение запроса
    var request: Request { get }
    /// HTTP
    var httpMethod: HTTPMethod { get }
}
