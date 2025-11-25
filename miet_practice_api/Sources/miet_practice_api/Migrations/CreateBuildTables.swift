import Fluent

struct CreateBuildTables: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(DatabaseSchema.build.rawValue)
            .field("id", .uuid, .identifier(auto: false))
            .field("status_code", .uuid, .required, .references(DatabaseSchema.buildStatus.rawValue, "code"))
            .field("task_id", .uuid, .references(DatabaseSchema.task.rawValue, "id"))
            .field("git_branch", .string, .required)
            .field("started_at", .datetime, .required)
            .field("ended_at", .datetime)
            .field("duration", .int64)
            .create()

        try await database.schema(DatabaseSchema.buildArtefact.rawValue)
            .field("id", .uuid, .identifier(auto: false))
            .field("build_id", .uuid, .required, .references(DatabaseSchema.build.rawValue, "id", onDelete: .cascade))
            .field("logs_url", .string)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema(DatabaseSchema.buildArtefact.rawValue).delete()
        try await database.schema(DatabaseSchema.build.rawValue).delete()
    }
}

