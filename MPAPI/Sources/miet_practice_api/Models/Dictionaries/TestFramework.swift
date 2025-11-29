import Fluent
import Vapor

enum TestFrameworkEnum: String, MPDictionaryEnum {
    /// Xcode UI тесты
    case xcodeUI = "XCODE_UI"
    /// Xcode Unit тесты
    case xcodeUnit = "XCODE_UNIT"
    /// Неизвестный фреймворк (fallback)
    case unknown = "UNKNOWN"
}

/// Справочник библиотек тестов
final class TestFramework: MPDictionary, @unchecked Sendable {
    static let schema = DatabaseSchema.testFramework.rawValue

    /// Код фреймворка тестирования (первичный ключ)
    @ID(custom: "code", generatedBy: .none) var id: Int?

    /// Значение фреймворка
    @Field(key: "value") var value: TestFrameworkEnum

    init() { }

    init(code: Int? = nil, value: TestFrameworkEnum) {
        self.id = code
        self.value = value
    }
}

