import Fluent

struct CreateTestResultTables: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(DatabaseSchema.testSuiteResult.rawValue)
            .field("id", .uuid, .identifier(auto: false))
            .field("framework_code", .uuid, .required, .references(DatabaseSchema.testFramework.rawValue, "code"))
            .field("build_id", .uuid, .required, .references(DatabaseSchema.build.rawValue, "id", onDelete: .cascade))
            .create()

        try await database.schema(DatabaseSchema.testCaseResult.rawValue)
            .field("id", .uuid, .identifier(auto: false))
            .field("suite_id", .uuid, .required, .references(DatabaseSchema.testSuiteResult.rawValue, "id", onDelete: .cascade))
            .field("name", .string, .required)
            .field("duration", .int64)
            .create()

        try await database.schema(DatabaseSchema.testResult.rawValue)
            .field("id", .uuid, .identifier(auto: false))
            .field("case_id", .uuid, .required, .references(DatabaseSchema.testCaseResult.rawValue, "id", onDelete: .cascade))
            .field("name", .string, .required)
            .field("status_code", .uuid, .required, .references(DatabaseSchema.testCaseResultStatus.rawValue, "code"))
            .field("duration", .int64)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema(DatabaseSchema.testResult.rawValue).delete()
        try await database.schema(DatabaseSchema.testCaseResult.rawValue).delete()
        try await database.schema(DatabaseSchema.testSuiteResult.rawValue).delete()
    }
}

