import Fluent

struct CreateUserTable: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(DatabaseSchema.user.rawValue)
            .field("id", .uuid, .identifier(auto: false))
            .field("name", .string, .required)
            .field(
                "role_code",
                .int,
                .required,
                .references(DatabaseSchema.userRole.rawValue, "code")
            )
            .field("email", .string, .required)
            .field("created_at", .datetime, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema(DatabaseSchema.user.rawValue).delete()
    }
}

