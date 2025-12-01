import Foundation

/// Enum для централизованного хранения названий схем таблиц базы данных
enum DatabaseSchema: String {
    // Справочники
    case userRole = "user_role"
    case testFramework = "test_framework"
    case testResultStatus = "test_result_status"
    case taskStatus = "task_status"
    case notificationDeliveryStatus = "notification_delivery_status"
    case buildStatus = "build_status"
    
    // Основные таблицы
    case user = "user"
    case task = "task"
    case build = "build"
    case testSuiteResult = "test_suite_result"
    case testSuiteResultArtefact = "test_suite_result_artefact"
    case testCaseResult = "test_case_result"
    case testResult = "test_result"
    case notification = "notification"
}

