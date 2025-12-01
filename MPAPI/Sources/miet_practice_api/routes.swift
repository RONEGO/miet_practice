import Fluent
import Vapor

func routes(_ app: Application) throws {
    // Регистрация контроллеров
    try app.register(collection: BuildsController())
    try app.register(collection: TestsController())
}
