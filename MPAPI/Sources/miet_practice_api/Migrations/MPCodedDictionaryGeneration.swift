import Fluent
import MPCore

private enum MPCodedDictionaryGenerationError: Error {
    /// Код уже существует для заполнения
    case codeAlreadyExisted
}

struct MPCodedDictionaryGeneration<_Dictionary: LookUpTable>: AsyncMigration {
    private typealias Enum = _Dictionary._Enum

    var name: String {
        "MPCodedDictionaryGeneration_\(String(describing: _Dictionary.self))_" +
            Enum.allCases.map { String(describing: $0) }.joined(separator: "_")
    }

    func prepare(on database: any Database) async throws {
        for value in Enum.allCases {
            let code = try _Dictionary.getCode(value)
            if let oldValue = try await _Dictionary.find(code, on: database) {
                guard oldValue.value == value else { throw MPCodedDictionaryGenerationError.codeAlreadyExisted }
                continue
            }
            guard try await _Dictionary.find(code, on: database).isNil else { continue }
            let model = _Dictionary(id: code, value: value)
            try await model.save(on: database)
        }
    }
    
    func revert(on database: any Database) async throws {}
}
