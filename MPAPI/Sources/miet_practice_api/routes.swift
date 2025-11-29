import Fluent
import Vapor

func routes(_ app: Application) throws {
    // Регистрация контроллеров
    try app.register(collection: BuildsController())
}
