import Fluent
import Vapor

/// Справочник статусов сборок
final class BuildStatus: Model, Content, @unchecked Sendable {
    static let schema = DatabaseSchema.buildStatus.rawValue

    /// Код статуса сборки (первичный ключ)
    @ID(custom: "code", generatedBy: .none) var id: UUID?
    
    /// Значение статуса
    @Field(key: "value") var value: String

    init() { }

    init(id: UUID? = nil, value: String) {
        self.id = id
        self.value = value
    }
}
