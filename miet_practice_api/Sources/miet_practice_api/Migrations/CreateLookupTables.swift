import Fluent

struct CreateLookupTables: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(DatabaseSchema.userRole.rawValue)
            .field("code", .uuid, .identifier(auto: false))
            .field("value", .string, .required)
            .create()

        try await database.schema(DatabaseSchema.testFramework.rawValue)
            .field("code", .uuid, .identifier(auto: false))
            .field("value", .string, .required)
            .create()

        try await database.schema(DatabaseSchema.testCaseResultStatus.rawValue)
            .field("code", .uuid, .identifier(auto: false))
            .field("value", .string, .required)
            .create()

        try await database.schema(DatabaseSchema.taskStatus.rawValue)
            .field("code", .uuid, .identifier(auto: false))
            .field("value", .string, .required)
            .create()

        try await database.schema(DatabaseSchema.notificationDeliveryStatus.rawValue)
            .field("code", .uuid, .identifier(auto: false))
            .field("value", .string, .required)
            .create()

        try await database.schema(DatabaseSchema.buildStatus.rawValue)
            .field("code", .uuid, .identifier(auto: false))
            .field("value", .string, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema(DatabaseSchema.buildStatus.rawValue).delete()
        try await database.schema(DatabaseSchema.notificationDeliveryStatus.rawValue).delete()
        try await database.schema(DatabaseSchema.taskStatus.rawValue).delete()
        try await database.schema(DatabaseSchema.testCaseResultStatus.rawValue).delete()
        try await database.schema(DatabaseSchema.testFramework.rawValue).delete()
        try await database.schema(DatabaseSchema.userRole.rawValue).delete()
    }
}

