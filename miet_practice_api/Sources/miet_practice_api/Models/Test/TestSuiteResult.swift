import Fluent
import Vapor

/// Наборы тестов (модули/группы) в рамках сборки
final class TestSuiteResult: Model, Content, @unchecked Sendable {
    static let schema = DatabaseSchema.testSuiteResult.rawValue

    /// Уникальный идентификатор набора тестов (первичный ключ)
    @ID(custom: "id", generatedBy: .none) var id: UUID?
    
    /// Связь с фреймворком тестирования
    @Parent(key: "framework_code") var framework: TestFramework
    
    /// Связь со сборкой
    @Parent(key: "build_id") var build: Build

    init() { }

    init(id: UUID? = nil, frameworkCode: TestFramework.IDValue, buildID: Build.IDValue) {
        self.id = id
        self.$framework.id = frameworkCode
        self.$build.id = buildID
    }
}

