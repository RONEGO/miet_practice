import Vapor

/// DTO для запроса на загрузку логов
/// Файлы передаются через multipart/form-data
public struct UploadLogRequestDTO: Content {
    /// Файл лога
    public let log: File
    
    public init(log: File) {
        self.log = log
    }
}

