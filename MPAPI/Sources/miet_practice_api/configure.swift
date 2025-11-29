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

    /// Создание таблиц
    app.migrations.add(CreateLookupTables())
    app.migrations.add(CreateUserTable())
    app.migrations.add(CreateTaskTable())
    app.migrations.add(CreateBuildTables())
    app.migrations.add(CreateTestResultTables())
    app.migrations.add(CreateNotificationTable())

    /// Наполнение словарей
    app.migrations.add(MPCodedDictionaryGeneration<BuildStatus>())
    app.migrations.add(MPCodedDictionaryGeneration<NotificationDeliveryStatus>())
    app.migrations.add(MPCodedDictionaryGeneration<UserRole>())
    app.migrations.add(MPCodedDictionaryGeneration<TestFramework>())
    app.migrations.add(MPCodedDictionaryGeneration<TestStatus>())
    app.migrations.add(MPCodedDictionaryGeneration<TaskStatus>())

    // Запуск миграций автоматически при старте приложения
    try await app.autoMigrate()

    // register routes
    try routes(app)
}
