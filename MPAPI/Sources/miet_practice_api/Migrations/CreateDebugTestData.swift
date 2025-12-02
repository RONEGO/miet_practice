import Fluent
import Foundation

/// Миграция для создания тестовых данных (только для debug сборки)
struct CreateDebugTestData: AsyncMigration {
    func prepare(on database: any Database) async throws {
        #if DEBUG
        // Получаем коды ролей
        let developerRoleCode = try UserRole.getCode(.developer)
        let testerRoleCode = try UserRole.getCode(.tester)
        
        // Получаем код статуса задачи
        let newTaskStatusCode = try TaskStatus.getCode(.new)
        
        // Создаем Developer
        let developerId = UUID()
        let developer = User(
            id: developerId,
            name: "Test Developer",
            email: "developer@test.com",
            roleCode: developerRoleCode
        )
        try await developer.save(on: database)
        
        // Создаем QA/Tester
        let qaId = UUID()
        let qa = User(
            id: qaId,
            name: "Test QA",
            email: "qa@test.com",
            roleCode: testerRoleCode
        )
        try await qa.save(on: database)
        
        // Создаем Task
        let taskId = UUID()
        let task = Task(id: taskId, statusCode: newTaskStatusCode)
        task.$assignee.id = developerId
        task.$qa.id = qaId
        try await task.save(on: database)
        #endif
    }
    
    func revert(on database: any Database) async throws {
        #if DEBUG
        // Находим тестовых пользователей
        guard let developer = try await User.query(on: database)
            .filter(\.$email == "developer@test.com")
            .first(),
              let qa = try await User.query(on: database)
            .filter(\.$email == "qa@test.com")
            .first(),
              let developerId = developer.id,
              let qaId = qa.id else {
            // Если пользователи не найдены, ничего не делаем
            return
        }
        
        // Удаляем задачи, связанные с тестовыми пользователями
        // Загружаем все задачи и проверяем их связи
        let allTasks = try await Task.query(on: database).all()
        for task in allTasks {
            try await task.$assignee.load(on: database)
            try await task.$qa.load(on: database)
            if task.assignee?.id == developerId || task.qa?.id == qaId {
                try await task.delete(on: database)
            }
        }
        
        // Удаляем тестовых пользователей
        try await developer.delete(on: database)
        try await qa.delete(on: database)
        #endif
    }
}

