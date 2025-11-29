import Fluent
import Vapor

enum UserRoleEnum: String, MPDictionaryEnum {
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
final class UserRole: MPDictionary, @unchecked Sendable {
    static let schema = DatabaseSchema.userRole.rawValue

    /// Код роли (первичный ключ)
    @ID(custom: "code", generatedBy: .none) var id: Int?

    /// Значение роли
    @Field(key: "value") var value: UserRoleEnum

    init() { }

    init(code: Int? = nil, value: UserRoleEnum) {
        self.id = code
        self.value = value
    }
}

