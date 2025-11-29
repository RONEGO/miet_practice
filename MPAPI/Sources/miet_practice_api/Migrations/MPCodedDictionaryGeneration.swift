import Fluent

struct MPCodedDictionaryGeneration<_Dictionary: MPCodedDictionary>: AsyncMigration {
    private typealias Enum = _Dictionary._DictionaryEnum

    func prepare(on database: any Database) async throws {
        for (offset, value) in Enum.allCases.enumerated() {
            guard
                try await _Dictionary.find(offser, on: database) == nil
            else { continue }
            let model = _Dictionary(
                id: offset,
                value: value
            )
            try await model.save(on: database)
        }
    }
    
    func revert(on database: any Database) async throws {}
}
