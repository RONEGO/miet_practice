import Fluent

struct CreateBuildTables: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(DatabaseSchema.build.rawValue)
            .field("id", .uuid, .identifier(auto: false))
            .field(
                "status_code",
                .int8,
                .required,
                .references(
                    DatabaseSchema.buildStatus.rawValue,
                    "code"
                )
            )
            .field("task_id", .uuid, .references(DatabaseSchema.task.rawValue, "id"))
            .field("git_branch", .string)
            .field("started_at", .datetime, .required)
            .field("ended_at", .datetime)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema(DatabaseSchema.build.rawValue).delete()
    }
}

