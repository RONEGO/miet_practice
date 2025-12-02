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
TASK_ID=""
GIT_BRANCH=""

# Парсим аргументы
while [[ $# -gt 0 ]]; do
    case $1 in
        --clear)
            CLEAR_CACHE=true
            shift
            ;;
        --task-id)
            TASK_ID="$2"
            shift 2
            ;;
        --git-branch)
            GIT_BRANCH="$2"
            shift 2
            ;;
        *)
            # Если это не флаг, то это BASE_URL
            if [ -z "$BASE_URL" ]; then
                BASE_URL="$1"
            fi
            shift
            ;;
    esac
done

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
    send_run_request "$BASE_URL" "$REPORTER_CACHE_FILE" "$TASK_ID" "$GIT_BRANCH"
fi

log ""
# Запускаем все тесты
TESTS_FAILED=false
REPORTER_CACHE_FILE="$CACHE_DIR/run_reporter_cache.json"
run_all_tests "$BASE_URL" TESTS_FAILED "$REPORTER_CACHE_FILE"

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
