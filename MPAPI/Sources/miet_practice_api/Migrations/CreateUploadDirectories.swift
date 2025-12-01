import Fluent
import Foundation

struct CreateUploadDirectories: AsyncMigration {
    func prepare(on database: any Database) async throws {
        let fileManager = FileManager.default
        
        // Получаем рабочую директорию
        let workingDirectory = fileManager.currentDirectoryPath
        let uploadsDirectory = "\(workingDirectory)/\(UploadPaths.uploadsFolder)"
        let artefactsDirectory = UploadPaths.testSuitesResultArtefactsPath(workingDirectory: workingDirectory)
        
        // Создаем директорию uploads, если её нет
        if !fileManager.fileExists(atPath: uploadsDirectory) {
            try fileManager.createDirectory(atPath: uploadsDirectory, withIntermediateDirectories: true)
        }
        
        // Создаем директорию test_suites_result_artefacts, если её нет
        if !fileManager.fileExists(atPath: artefactsDirectory) {
            try fileManager.createDirectory(atPath: artefactsDirectory, withIntermediateDirectories: true)
        }
    }
    
    func revert(on database: any Database) async throws {
        let fileManager = FileManager.default
        let workingDirectory = fileManager.currentDirectoryPath
        let uploadsDirectory = "\(workingDirectory)/\(UploadPaths.uploadsFolder)"
        let artefactsDirectory = UploadPaths.testSuitesResultArtefactsPath(workingDirectory: workingDirectory)
        
        // Удаляем директорию test_suites_result_artefacts
        if fileManager.fileExists(atPath: artefactsDirectory) {
            try fileManager.removeItem(atPath: artefactsDirectory)
        }
        
        // Удаляем директорию uploads, если она пустая
        if fileManager.fileExists(atPath: uploadsDirectory) {
            let contents = try fileManager.contentsOfDirectory(atPath: uploadsDirectory)
            if contents.isEmpty {
                try fileManager.removeItem(atPath: uploadsDirectory)
            }
        }
    }
}

