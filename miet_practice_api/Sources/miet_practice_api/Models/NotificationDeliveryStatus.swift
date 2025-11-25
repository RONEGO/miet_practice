import Fluent
import Vapor

/// Справочник статусов доставки уведомлений
final class NotificationDeliveryStatus: Model, Content, @unchecked Sendable {
    static let schema = DatabaseSchema.notificationDeliveryStatus.rawValue

    /// Код статуса доставки (первичный ключ)
    @ID(custom: "code", generatedBy: .none) var id: UUID?
    
    /// Значение статуса
    @Field(key: "value") var value: String

    init() { }

    init(id: UUID? = nil, value: String) {
        self.id = id
        self.value = value
    }
}
