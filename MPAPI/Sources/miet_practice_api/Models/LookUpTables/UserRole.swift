import Fluent
import Vapor

enum UserRoleEnum: String, LookUpTableEnum {
    /// Разработчик
    case developer = "DEVELOPER"
    /// Тестировщик
    case tester = "TESTER"
    /// Менеджер
    case manager = "MANAGER"
    /// Неизвестная роль (fallback)
    case unknown = "UNKNOWN"
}

/// Справочник ролей
final class UserRole: LookUpTable, @unchecked Sendable {
    static let schema = DatabaseSchema.userRole.rawValue

    /// Код роли (первичный ключ)
    @ID(custom: "code", generatedBy: .none) var id: UInt8?

    /// Значение роли
    @Field(key: "value") var value: UserRoleEnum

    init() { }

    init(id: UInt8?, value: UserRoleEnum) {
        self.id = id
        self.value = value
    }
}

