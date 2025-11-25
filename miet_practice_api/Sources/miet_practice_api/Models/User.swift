import Fluent
import Vapor

/// Участники процесса: разработчики и тестировщики
final class User: Model, Content, @unchecked Sendable {
    static let schema = DatabaseSchema.user.rawValue

    /// Уникальный идентификатор пользователя (первичный ключ)
    @ID(custom: "id", generatedBy: .none) var id: UUID?
    
    /// Имя пользователя
    @Field(key: "name") var name: String
    
    /// Связь с ролью пользователя
    @Parent(key: "role_code") var role: UserRole
    
    /// Email пользователя
    @Field(key: "email") var email: String
    
    /// Дата создания записи
    @Timestamp(key: "created_at", on: .create) var createdAt: Date?

    init() { }

    init(id: UUID? = nil, name: String, email: String, roleCode: UserRole.IDValue) {
        self.id = id
        self.name = name
        self.email = email
        self.$role.id = roleCode
    }
}
