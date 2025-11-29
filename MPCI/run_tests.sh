#!/usr/bin/env bash
set -o pipefail

# Подключение библиотек
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/Helpers/logging.sh"
source "$SCRIPT_DIR/Helpers/config.sh"
source "$SCRIPT_DIR/Helpers/cache.sh"
source "$SCRIPT_DIR/Helpers/api.sh"
source "$SCRIPT_DIR/Helpers/test_runner.sh"

# Парсим аргументы
CLEAR_CACHE=false
BASE_URL=""

# Проверяем первый аргумент на --cache
if [ "$1" = "--cache" ]; then
    CLEAR_CACHE=true
    # BASE_URL будет вторым аргументом
    BASE_URL="$2"
else
    # BASE_URL будет первым аргументом
    BASE_URL="$1"
fi

log ""
# Очищаем кеш, если передан флаг --cache
if [ "$CLEAR_CACHE" = true ]; then
    clear_cache
fi

log ""
# Проверяем наличие run_reporter и run_parser, создаём их при необходимости (только если BASE_URL передан)
if [ -n "$BASE_URL" ]; then
    create_reporter_and_parser
fi

# Создаём директорию Cache, если её нет
ensure_cache_directory

log ""
# Отправляем запрос на запуск сборки в начале скрипта (только если BASE_URL передан)
if [ -n "$BASE_URL" ]; then
    REPORTER_CACHE_FILE="$CACHE_DIR/run_reporter_cache.json"
    send_run_request "$BASE_URL" "$REPORTER_CACHE_FILE"
fi

log ""
# Запускаем все тесты
TESTS_FAILED=false
run_all_tests "$BASE_URL" TESTS_FAILED

tput cnorm 2>/dev/null || true

# Отправляем запрос на завершение сборки (только если BASE_URL передан)
if [ -n "$BASE_URL" ]; then
    REPORTER_CACHE_FILE="$CACHE_DIR/run_reporter_cache.json"
    
    # Определяем статус сборки
    if [ "$TESTS_FAILED" = "true" ]; then
        BUILD_STATUS="FAILURE"
    else
        BUILD_STATUS="SUCCESS"
    fi
    
    log ""
    send_complete_request "$BASE_URL" "$REPORTER_CACHE_FILE" "$BUILD_STATUS"
    log ""
fi

log_warn "Все прогоны завершены!"
