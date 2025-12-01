import Fluent

struct CreateTaskTable: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(DatabaseSchema.task.rawValue)
            .field("id", .uuid, .identifier(auto: false))
            .field("assignee_id", .uuid, .references(DatabaseSchema.user.rawValue, "id"))
            .field("qa_id", .uuid, .references(DatabaseSchema.user.rawValue, "id"))
            .field(
                "status_code",
                .int8,
                .required,
                .references(DatabaseSchema.taskStatus.rawValue, "code")
            )
            .field("completed_at", .datetime)
            .field("created_at", .datetime, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema(DatabaseSchema.task.rawValue).delete()
    }
}

