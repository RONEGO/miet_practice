#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/logging.sh"

# Глобальная переменная для пути к кешу результатов unit-тестов
CACHE_DIR="./Cache"
PROJECT_PATH="../miet_practice_application/miet_practice_application.xcodeproj"

TESTS=(
    "miet-practice-application_unit_tests"   "$CACHE_DIR/UnitTestsResults.xcresult"
#    "miet-practice-application_ui_tests"     "$CACHE_DIR/UITestsResults.xcresult"
)

# Создаём директорию Cache, если её нет
mkdir -p $CACHE_DIR

for ((i=0; i < ${#TESTS[@]}; i+=2)); do
    SCHEME="${TESTS[i]}"
    RESULT_PATH="${TESTS[i+1]}"

    # Запускаем тесты, сохраняя pid
    ./run_specific_test.sh $SCHEME $PROJECT_PATH $RESULT_PATH & pid=$!

    log_info "PID $pid"
    wait "$pid"
    status_unit=$?
    log "Статус выхода: $status_unit"

    if [ $status_unit -ne 0 ]; then
      log_error "Тесты со схемой ${SCHEME} завершились ошибкой."
      exit 1
    fi

    echo ""
done

log_success "Все прогоны завершились успешно!"

