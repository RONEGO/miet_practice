import Fluent
import Vapor

enum NotificationDeliveryStatusEnum: String, MPCodedDictionaryEnum {
    /// Отправлено
    case sent = "SENT"
    /// Прочитано
    case read = "READ"
    /// Неизвестный статус (fallback)
    case unknown = "UKNOWN"
}

/// Справочник статусов доставки уведомлений
final class NotificationDeliveryStatus: MPCodedDictionary, @unchecked Sendable {
    static let schema = DatabaseSchema.notificationDeliveryStatus.rawValue

    /// Код статуса доставки (первичный ключ)
    @ID(custom: "code", generatedBy: .none) var id: Int?

    /// Значение статуса
    @Field(key: "value") var value: NotificationDeliveryStatusEnum

    init() { }

    init(id: Int?, value: NotificationDeliveryStatusEnum) {
        self.id = id
        self.value = value
    }
}
