import Fluent

struct MPCodedDictionaryGeneration<_Dictionary: MPCodedDictionary>: AsyncMigration {
    private typealias Enum = _Dictionary._DictionaryEnum

    var name: String {
        "MPCodedDictionaryGeneration_\(String(describing: _Dictionary.self))_" +
            Enum.allCases.map { String(describing: $0) }.joined(separator: "_")
    }

    func prepare(on database: any Database) async throws {
        for value in Enum.allCases {
            guard
                try await _Dictionary.find(value.code, on: database) == nil
            else { continue }
            let model = _Dictionary(id: value.code, value: value)
            try await model.save(on: database)
        }
    }
    
    func revert(on database: any Database) async throws {}
}
