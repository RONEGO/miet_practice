import Fluent
import Vapor

/// Журнал отправленных уведомлений
final class NotificationLog: Model, Content, @unchecked Sendable {
    static let schema = DatabaseSchema.notification.rawValue

    /// Уникальный идентификатор уведомления (первичный ключ)
    @ID(custom: "id", generatedBy: .none) var id: UUID?
    
    /// Содержимое уведомления (payload)
    @Field(key: "payload") var payload: String
    
    /// Время отправки уведомления
    @Field(key: "sent_at") var sentAt: Date
    
    /// Связь с получателем уведомления
    @Parent(key: "receiver_id") var receiver: User
    
    /// Связь со статусом доставки уведомления
    @Parent(key: "delivery_status_code") var deliveryStatus: NotificationDeliveryStatus

    init() { }

    init(id: UUID? = nil, payload: String, sentAt: Date, receiverID: User.IDValue, deliveryStatusCode: NotificationDeliveryStatus.IDValue) {
        self.id = id
        self.payload = payload
        self.sentAt = sentAt
        self.$receiver.id = receiverID
        self.$deliveryStatus.id = deliveryStatusCode
    }
}
