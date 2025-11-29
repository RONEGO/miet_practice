import Fluent
import Vapor

enum NotificationDeliveryStatusEnum: String, LookUpTableEnum {
    /// Отправлено
    case sent = "SENT"
    /// Прочитано
    case read = "READ"
    /// Неизвестный статус (fallback)
    case unknown = "UKNOWN"
}

/// Справочник статусов доставки уведомлений
final class NotificationDeliveryStatus: LookUpTable, @unchecked Sendable {
    static let schema = DatabaseSchema.notificationDeliveryStatus.rawValue

    /// Код статуса доставки (первичный ключ)
    @ID(custom: "code", generatedBy: .none) var id: UInt8?

    /// Значение статуса
    @Field(key: "value") var value: NotificationDeliveryStatusEnum

    init() { }

    init(id: UInt8?, value: NotificationDeliveryStatusEnum) {
        self.id = id
        self.value = value
    }
}
