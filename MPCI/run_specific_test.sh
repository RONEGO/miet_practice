#!/bin/bash

set -o pipefail

# Подключение библиотеки логирования
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$(dirname "$0")/Helpers/logging.sh"
source "$(dirname "$0")/Helpers/spinner.sh"

# Параметры конфигурации
# Схема передается как первый аргумент командной строки
SCHEME="$1"
PROJECT_PATH="$2"
BUILD_LOG_PATH="${3:-./UnknownBuildLogs.text}"
RESULT_PATH="${4:-./UnknownResultPath.xcresult}"
DESTINATION="${5:-platform=iOS Simulator,name=iPhone 17 Pro,OS=26.1}"

# Проверка обязательных параметров
if [[ -z "$SCHEME" || -z "$PROJECT_PATH" ]]; then
    log_error "Недостаточно аргументов."
    log_info "Использование: $0 <SCHEME> <PROJECT_PATH> [BUILD_LOG_PATH] [RESULT_PATH] [DESTINATION]"
    exit 1
fi

# Проверка опциональных, но желательных параметров
if [ -z "$3"  ]; then
    log_warn "Параметр вывода логов сборки не проставлен. Будет выводиться в UnknownBuildLogs.text"
fi

# Проверка опциональных, но желательных параметров
if [ -z "$4"  ]; then
    log_warn "Параметр вывода результатов не проставлен. Будет выводиться в UnknownResultPath.xcresult"
fi

# Проверка существования проекта
if [ ! -d "$PROJECT_PATH" ]; then
    log_error "Проект не найден по пути $PROJECT_PATH"
    exit 1
fi

# Проверка файла Xcresult результатов
if [ -d "$RESULT_PATH" ] || [ -f "$RESULT_PATH" ]; then
    rm -rf "$RESULT_PATH"
    log_warn "Удалён старый кеш результатов (Xcresult): $RESULT_PATH"
fi

# Проверка файла логов сборки
if [ -d "$BUILD_LOG_PATH" ] || [ -f "$BUILD_LOG_PATH" ]; then
    rm -rf "$BUILD_LOG_PATH"
    log_warn "Удалён старый кеш логов сборки (Build Logs): $BUILD_LOG_PATH"
fi
touch $BUILD_LOG_PATH

log ""
log_info "Запуск тестов..."
log "Проект: $PROJECT_PATH"
log "Схема: $SCHEME"
log "Устройство: $DESTINATION\n"

# --- 1. Запускаем xcodebuild в фоне ---
(
    NSUnbufferedIO=YES xcodebuild test \
        -project "$PROJECT_PATH" \
        -scheme "$SCHEME" \
        -destination "$DESTINATION" \
        -resultBundlePath "$RESULT_PATH" \
        > "$BUILD_LOG_PATH" 2>&1
) &
BUILD_PID=$!

# --- 2. Запускаем спиннер параллельно ---
spinner "$BUILD_PID" & SPINNER_PID=$!

# --- 3. Ждём окончания xcodebuild ---
wait "$BUILD_PID"
TEST_STATUS=$?

printf "\r\033[K"

cat "$BUILD_LOG_PATH" \
    | xcbeautify \
    | grep -E "(Test Suite|Test case|✖|⊘|✔)"

log ""

if [ "$TEST_STATUS" -eq 0 ]; then
    log_success "Тесты успешно пройдены."
else
    log_error "Тесты завершились ошибкой!"
fi

