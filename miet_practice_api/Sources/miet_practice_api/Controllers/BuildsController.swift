import Fluent
import Vapor

struct BuildsController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let builds = routes.grouped("v1", "builds")
        builds.post("run", use: run)
        builds.patch("complete", use: completeBuild)
    }
    
    /// POST /v1/builds/run
    /// Создает новую сборку с опциональными task_id и git_branch
    func run(req: Request) async throws -> RunBuildResponseDTO {
        let request = try req.content.decode(RunBuildRequestDTO.self)
        
        // Получаем ID статуса "RUNNING" из индекса enum (соответствует порядку в allCases)
        guard let runningStatusIndex = BuildStatusEnum.allCases.firstIndex(of: .running) else {
            throw Abort(.internalServerError, reason: "Build status 'RUNNING' not found in enum")
        }
        let runningStatusId = runningStatusIndex
        
        // Проверяем существование Task, если taskId передан
        if let taskId = request.taskId {
            guard try await Task.find(taskId, on: req.db) != nil else {
                throw Abort(.notFound, reason: "Task with id \(taskId) not found")
            }
        }
        
        // Создаем новую уникальную сборку
        let build = Build()
        build.id = UUID()
        build.$status.id = runningStatusId
        // Устанавливаем gitBranch (если не передан, используем пустую строку, так как поле required в БД)
        build.gitBranch = request.gitBranch

        // Устанавливаем связь с Task, если taskId передан
        if let taskId = request.taskId {
            build.$task.id = taskId
        }
        
        // Сохраняем сборку в базу данных
        try await build.save(on: req.db)
        
        // Возвращаем ответ с build_id
        guard let buildId = build.id else {
            throw Abort(.internalServerError, reason: "Failed to generate build ID")
        }
        
        return RunBuildResponseDTO(buildId: buildId)
    }
    
    /// PATCH /v1/builds/complete
    /// Завершает сборку, устанавливая статус, время окончания и длительность
    func completeBuild(req: Request) async throws -> CompleteBuildResponseDTO {
        let request = try req.content.decode(CompleteBuildRequestDTO.self)
        
        // Находим сборку по ID
        guard let build = try await Build.find(request.buildId, on: req.db) else {
            throw Abort(.notFound, reason: "Build with id \(request.buildId) not found")
        }
        
        // Загружаем статус для проверки
        try await build.$status.load(on: req.db)
        
        // Проверяем, что сборка в состоянии RUNNING
        guard build.status.value == .running else {
            throw Abort(.badRequest, reason: "Build is not in RUNNING status. Current status: \(build.status.value.rawValue)")
        }
        
        // Валидируем новый статус (должен быть SUCCESS или FAILURE)
        guard let newStatus = BuildStatusEnum(rawValue: request.buildStatus),
              newStatus == .success || newStatus == .failure else {
            throw Abort(.badRequest, reason: "Invalid build_status. Must be 'SUCCESS' or 'FAILURE'")
        }
        
        // Получаем ID нового статуса из индекса enum
        guard let newStatusIndex = BuildStatusEnum.allCases.firstIndex(of: newStatus) else {
            throw Abort(.internalServerError, reason: "Build status '\(newStatus.rawValue)' not found in enum")
        }
        
        // Вычисляем длительность (разница между started_at и текущим временем в миллисекундах)
        let endTime = Date()
        guard let startTime = build.startedAt else {
            throw Abort(.internalServerError, reason: "Build started_at is missing")
        }

        // Обновляем сборку
        build.endedAt = endTime
        build.$status.id = newStatusIndex
        
        // Сохраняем изменения
        try await build.save(on: req.db)
        
        guard let buildId = build.id else {
            throw Abort(.internalServerError, reason: "Build ID is missing")
        }
        
        return CompleteBuildResponseDTO(
            buildId: buildId,
            message: "Build completed with status: \(newStatus.rawValue)"
        )
    }
}

