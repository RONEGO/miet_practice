#!/usr/bin/env bash
set -o pipefail
source "$(dirname "$0")/Helpers/logging.sh"

# Глобальные переменные
CACHE_DIR="./Cache"
PROJECT_PATH="../MPTestableApp/MPTestableApp.xcodeproj"
REPORTER_PATH="./run_reporter"
PARSER_PATH="./run_parser"

# Функция очистки кеша
clear_cache() {
    log_info "Очищаем кеш..."

    # Удаляем директорию Cache
    if [ -d "$CACHE_DIR" ]; then
        rm -rf "$CACHE_DIR"/*
    fi

    # Удаляем parser и reporter
    if [ -f "$PARSER_PATH" ]; then
        rm -f "$PARSER_PATH"
    fi

    if [ -f "$REPORTER_PATH" ]; then
        rm -f "$REPORTER_PATH"
    fi

    log_success "Кеш очищен"
}

# Функция создания reporter и parser
create_reporter_and_parser() {
    if [ ! -f "$REPORTER_PATH" ]; then
        log_info "Файл run_reporter не найден, создаём..."
        "$(dirname "$0")/Factory/maker.sh" --reporter
        log_success "run_reporter создан"
    fi
    
    rm -f "$PARSER_PATH"
    if [ ! -f "$PARSER_PATH" ]; then
        log_info "Файл run_parser не найден, создаём..."
        "$(dirname "$0")/Factory/maker.sh" --parser
        log_success "run_parser создан"
    fi
}

# Парсим аргументы
CLEAR_CACHE=false
BASE_URL=""

# Проверяем первый аргумент на --cache
if [ "$1" = "--cache" ]; then
    CLEAR_CACHE=true
    # BASE_URL будет вторым аргументом
    BASE_URL="$2"
else
    # BASE_URL будет первым аргументом, проверяем остальные на --cache
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
mkdir -p $CACHE_DIR

log ""
# Отправляем запрос на запуск сборки в начале скрипта (только если BASE_URL передан)
if [ -n "$BASE_URL" ]; then
    REPORTER_CACHE_FILE="$CACHE_DIR/run_reporter_cache.json"
    REPORTER_ABSOLUTE_PATH="$(cd "$(dirname "$REPORTER_CACHE_FILE")" && pwd)/$(basename "$REPORTER_CACHE_FILE")"
    log_info "Отправляем запрос на запуск сборки..."
    $REPORTER_PATH "$BASE_URL" "$REPORTER_ABSOLUTE_PATH" --run || log_warn "Не удалось отправить запрос на запуск сборки"
fi

TESTS=(
#    "MPTestableAppUnitTests"
    "MPTestableAppUITests"
)

# Флаг для отслеживания успешности всех тестов
TESTS_FAILED=false

log ""
for SCHEME in "${TESTS[@]}"; do
    BUILD_LOGS_PATH="$CACHE_DIR/${SCHEME}Build.log"
    RESULT_PATH="$CACHE_DIR/${SCHEME}Results.xcresult"

    # Запускаем тесты, сохраняя pid
    ./run_specific_test.sh $SCHEME $PROJECT_PATH $BUILD_LOGS_PATH $RESULT_PATH & pid=$!

    log_info "PID $pid"
    wait "$pid"
    TEST_EXIT_CODE=$?

    # Проверяем результат теста
    if [ $TEST_EXIT_CODE -ne 0 ]; then
        TESTS_FAILED=true
        log_warn "Тесты $SCHEME завершились с ошибкой (код: $TEST_EXIT_CODE)"
    fi

    # Парсим результаты только если BASE_URL передан
    if [ -n "$BASE_URL" ]; then
        PARSING_FILE_PATH="$CACHE_DIR/${SCHEME}Parsing.json"
        RESULT_ABSOLUTE_PATH="$(cd "$RESULT_PATH" && pwd)"
        PARSING_ABSOLUTE_PATH="$(cd "$(dirname "$PARSING_FILE_PATH")" && pwd)/$(basename "$PARSING_FILE_PATH")"
        $PARSER_PATH "$RESULT_ABSOLUTE_PATH" "$PARSING_ABSOLUTE_PATH"
    fi

    echo ""
done

tput cnorm 2>/dev/null || true

# Отправляем запрос на завершение сборки (только если BASE_URL передан)
if [ -n "$BASE_URL" ]; then
    REPORTER_CACHE_FILE="$CACHE_DIR/run_reporter_cache.json"
    REPORTER_ABSOLUTE_PATH="$(cd "$(dirname "$REPORTER_CACHE_FILE")" && pwd)/$(basename "$REPORTER_CACHE_FILE")"
    
    # Определяем статус сборки
    if [ "$TESTS_FAILED" = true ]; then
        BUILD_STATUS="FAILURE"
    else
        BUILD_STATUS="SUCCESS"
    fi

    log ""
    log_info "Отправляем запрос на завершение сборки со статусом $BUILD_STATUS..."
    $REPORTER_PATH "$BASE_URL" "$REPORTER_ABSOLUTE_PATH" --complete --build-status "$BUILD_STATUS" || log_warn "Не удалось отправить запрос на завершение сборки"

    log ""
fi

log_warn "Все прогоны завершены!"
