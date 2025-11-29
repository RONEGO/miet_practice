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
    try await regenerateDictionaries(app.db)

    // register routes
    try routes(app)
}

private func regenerateDictionaries(_ db: any Database) async throws {
    for status in UserRoleEnum.allCases.enumerated() {
        let status = UserRole(
            id: status.offset,
            value: status.element
        )
        guard status._$idExists else { continue }
        try await status.save(on: db)
    }

    for status in NotificationDeliveryStatusEnum.allCases.enumerated() {
        let status = NotificationDeliveryStatus(
            id: status.offset,
            value: status.element
        )
        guard status._$idExists else { continue }
        try await status.save(on: db)
    }

    for status in TaskStatusEnum.allCases.enumerated() {
        let status = TaskStatus(
            id: status.offset,
            value: status.element
        )
        guard status._$idExists else { continue }
        try await status.save(on: db)
    }

    for status in TestFrameworkEnum.allCases.enumerated() {
        let status = TestFramework(
            id: status.offset,
            value: status.element
        )
        guard status._$idExists else { continue }
        try await status.save(on: db)
    }

    for status in TestStatusEnum.allCases.enumerated() {
        let status = TestStatus(
            id: status.offset,
            value: status.element
        )
        guard status._$idExists else { continue }
        try await status.save(on: db)
    }
}
