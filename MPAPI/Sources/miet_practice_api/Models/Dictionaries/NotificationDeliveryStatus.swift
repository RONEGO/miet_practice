import Fluent
import Vapor

enum NotificationDeliveryStatusEnum: String, MPDictionaryEnum {
    /// Отправлено
    case sent = "SENT"
    /// Прочитано
    case read = "READ"
    /// Неизвестный статус (fallback)
    case unknown = "UKNOWN"
}

/// Справочник статусов доставки уведомлений
final class NotificationDeliveryStatus: MPDictionary, @unchecked Sendable {
    static let schema = DatabaseSchema.notificationDeliveryStatus.rawValue

    /// Код статуса доставки (первичный ключ)
    @ID(custom: "code", generatedBy: .none) var id: Int?

    /// Значение статуса
    @Field(key: "value") var value: NotificationDeliveryStatusEnum

    init() { }

    init(code: Int? = nil, value: NotificationDeliveryStatusEnum) {
        self.id = code
        self.value = value
    }
}
