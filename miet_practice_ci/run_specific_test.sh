#!/bin/bash

set -e  # Остановка при ошибке

# Подключение библиотеки логирования
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/logging.sh"

# Параметры конфигурации
# Схема передается как первый аргумент командной строки
SCHEME="$1"
PROJECT_PATH="$2"
RESULT_PATH="${3:-./UnknownResultPath.xcresult}"
DESTINATION="${4:-platform=iOS Simulator,name=iPhone 17 Pro,OS=26.1}"

# Проверка обязательных параметров
if [[ -z "$SCHEME" || -z "$PROJECT_PATH" ]]; then
    log_error "Недостаточно аргументов."
    log_info "Использование: $0 <SCHEME> <PROJECT_PATH> [RESULT_PATH] [DESTINATION]"
    exit 1
fi

# Проверка опциональных, но желательных параметров
if [ -z "$3"  ]; then
    log_warn "Параметр вывода результатов не проставлен. Будет выводиться в UnknownResultPath.xcresult"
fi

# Проверка существования проекта
if [ ! -d "$PROJECT_PATH" ]; then
    log_error "Проект не найден по пути $PROJECT_PATH"
    exit 1
fi

# Проверка папки кеша результатов
if [ -d "$RESULT_PATH" ] || [ -f "$RESULT_PATH" ]; then
    rm -rf "$RESULT_PATH"
    log_warn "Удалён старый кеш результатов: $RESULT_PATH"
fi

echo ""

log_info "Запуск тестов..."
log "Проект: $PROJECT_PATH"
log "Схема: $SCHEME"
log "Устройство: $DESTINATION"
echo ""

# Запуск тестов (выводится только stderr - ошибки)
xcodebuild test \
    -project "$PROJECT_PATH" \
    -scheme "$SCHEME" \
    -destination "$DESTINATION" \
    -resultBundlePath "$RESULT_PATH" \
    > /dev/null

# Проверка результата
if [ $? -eq 0 ]; then
    echo ""
    log "Результаты сохранены в: $RESULT_PATH"
    log_success "Тесты успешно завершены!"
    exit 0
else
    echo ""
    log_error "Тесты завершились с ошибками"
    exit 1
fi

