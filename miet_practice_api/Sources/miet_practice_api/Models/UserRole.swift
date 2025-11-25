import Fluent
import Vapor

/// Справочник ролей
final class UserRole: Model, Content, @unchecked Sendable {
    static let schema = DatabaseSchema.userRole.rawValue

    /// Код роли (первичный ключ)
    @ID(custom: "code", generatedBy: .none) var id: UUID?
    
    /// Значение роли
    @Field(key: "value") var value: String

    init() { }

    init(id: UUID? = nil, value: String) {
        self.id = id
        self.value = value
    }
}
