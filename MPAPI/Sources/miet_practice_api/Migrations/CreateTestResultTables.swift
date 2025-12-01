import Fluent

struct CreateTestResultTables: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(DatabaseSchema.testSuiteResult.rawValue)
            .field("id", .uuid, .identifier(auto: false))
            .field(
                "framework_code",
                .int8,
                .required,
                .references(DatabaseSchema.testFramework.rawValue, "code")
            )
            .field("build_id", .uuid, .required, .references(DatabaseSchema.build.rawValue, "id", onDelete: .cascade))
            .field("name", .string, .required)
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
            .field(
                "status_code",
                .int8,
                .required,
                .references(DatabaseSchema.testResultStatus.rawValue, "code")
            )
            .field("duration", .int64)
            .create()

        try await database.schema(DatabaseSchema.testSuiteResultArtefact.rawValue)
            .field("id", .uuid, .identifier(auto: false))
            .field("test_suite_result_id", .uuid, .required, .references(DatabaseSchema.testSuiteResult.rawValue, "id", onDelete: .cascade))
            .field("logs_url", .string)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema(DatabaseSchema.testSuiteResultArtefact.rawValue).delete()
        try await database.schema(DatabaseSchema.testResult.rawValue).delete()
        try await database.schema(DatabaseSchema.testCaseResult.rawValue).delete()
        try await database.schema(DatabaseSchema.testSuiteResult.rawValue).delete()
    }
}

