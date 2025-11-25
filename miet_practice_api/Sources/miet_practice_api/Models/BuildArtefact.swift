import Fluent
import Vapor

/// Артефакты сборки/тестов (логи, отчёты, скриншоты, IPA, dSYM)
final class BuildArtefact: Model, Content, @unchecked Sendable {
    static let schema = DatabaseSchema.buildArtefact.rawValue

    /// Уникальный идентификатор артефакта (первичный ключ)
    @ID(custom: "id", generatedBy: .none) var id: UUID?
    
    /// Связь со сборкой
    @Parent(key: "build_id") var build: Build
    
    /// URL логов артефакта
    @OptionalField(key: "logs_url") var logsURL: String?

    init() { }

    init(id: UUID? = nil, buildID: Build.IDValue, logsURL: String?) {
        self.id = id
        self.$build.id = buildID
        self.logsURL = logsURL
    }
}
