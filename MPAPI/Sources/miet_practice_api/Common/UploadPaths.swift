import Foundation

/// Константы для путей загрузки файлов
enum UploadPaths {
    /// Название основной папки для загрузок
    static let uploadsFolder = "Uploads"
    
    /// Название папки для артефактов test suite
    static let testSuitesResultArtefactsFolder = "test_suites_result_artefacts"
    
    /// Относительный путь к папке с артефактами test suite (относительно uploads)
    static var testSuitesResultArtefactsRelativePath: String {
        "\(uploadsFolder)/\(testSuitesResultArtefactsFolder)"
    }
    
    /// Полный путь к папке с артефактами test suite (относительно рабочей директории)
    static func testSuitesResultArtefactsPath(workingDirectory: String) -> String {
        "\(workingDirectory)/\(testSuitesResultArtefactsRelativePath)"
    }
    
    /// Полный путь к папке с артефактами test suite с завершающим слешем
    static func testSuitesResultArtefactsPathWithSlash(workingDirectory: String) -> String {
        "\(testSuitesResultArtefactsPath(workingDirectory: workingDirectory))/"
    }
    
    /// Формирует имя файла лога для артефакта
    static func logFileName(artefactId: UUID) -> String {
        "\(artefactId).log"
    }
    
    /// Формирует относительный путь к файлу лога
    static func logFileRelativePath(artefactId: UUID) -> String {
        "\(testSuitesResultArtefactsRelativePath)/\(logFileName(artefactId: artefactId))"
    }
}

