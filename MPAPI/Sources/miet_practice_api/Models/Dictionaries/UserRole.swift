import Fluent
import Vapor

enum UserRoleEnum: String, MPCodedDictionaryEnum {
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
final class UserRole: MPCodedDictionary, @unchecked Sendable {
    static let schema = DatabaseSchema.userRole.rawValue

    /// Код роли (первичный ключ)
    @ID(custom: "code", generatedBy: .none) var id: Int?

    /// Значение роли
    @Field(key: "value") var value: UserRoleEnum

    init() { }

    init(id: Int?, value: UserRoleEnum) {
        self.id = id
        self.value = value
    }
}

