import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)

    app.migrations.add(CreateLookupTables())
    app.migrations.add(CreateUserTable())
    app.migrations.add(CreateTaskTable())
    app.migrations.add(CreateBuildTables())
    app.migrations.add(CreateTestResultTables())
    app.migrations.add(CreateNotificationTable())

    // Запуск миграций автоматически при старте приложения
    try await app.autoMigrate()

    // Создание словарей
    try await BuildStatus.regenerate(on: app.db)
    try await NotificationDeliveryStatus.regenerate(on: app.db)
    try await UserRole.regenerate(on: app.db)
    try await TaskStatus.regenerate(on: app.db)
    try await TestFramework.regenerate(on: app.db)
    try await TestStatus.regenerate(on: app.db)

    // register routes
    try routes(app)
}
