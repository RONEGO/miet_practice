import Fluent

struct CreateNotificationTable: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(DatabaseSchema.notification.rawValue)
            .field("id", .uuid, .identifier(auto: false))
            .field("payload", .string, .required)
            .field("sent_at", .datetime, .required)
            .field("receiver_id", .uuid, .required, .references(DatabaseSchema.user.rawValue, "id"))
            .field(
                "delivery_status_code",
                .int,
                .required,
                .references(
                    DatabaseSchema.notificationDeliveryStatus.rawValue,
                    "code"
                )
            )
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema(DatabaseSchema.notification.rawValue).delete()
    }
}

