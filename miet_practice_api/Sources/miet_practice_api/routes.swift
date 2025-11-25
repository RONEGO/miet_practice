import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        let result = try? await Task.query(on: req.db).all()
        return result ?? []
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
}
