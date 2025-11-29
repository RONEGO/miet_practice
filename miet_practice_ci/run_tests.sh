#!/usr/bin/env bash
set -o pipefail
source "$(dirname "$0")/Helpers/logging.sh"

# Глобальная переменная для пути к кешу результатов unit-тестов
CACHE_DIR="./Cache"
PROJECT_PATH="../MPTestableApp/MPTestableApp.xcodeproj"

TESTS=(
    "MPTestableAppUnitTests"  "$CACHE_DIR/UnitTestsBuild.log" "$CACHE_DIR/UnitTestsResults.xcresult"
    "MPTestableAppUITests"    "$CACHE_DIR/UITestsBuild.log"   "$CACHE_DIR/UITestsResults.xcresult"
)

# Создаём директорию Cache, если её нет
mkdir -p $CACHE_DIR

for ((i=0; i < ${#TESTS[@]}; i+=3)); do
    SCHEME="${TESTS[i]}"
    BUILD_LOGS_PATH="${TESTS[i+1]}"
    RESULT_PATH="${TESTS[i+2]}"

    if (( i > 0 )); then
    log "=== \n"
    else
    log ""
    fi

    # Запускаем тесты, сохраняя pid
    ./run_specific_test.sh $SCHEME $PROJECT_PATH $BUILD_LOGS_PATH $RESULT_PATH & pid=$!

    log_info "PID $pid"
    log ""
    wait "$pid"

    ./xcresult-reporter "$(cd "$RESULT_PATH" && pwd)"

    echo ""
done

tput cnorm 2>/dev/null || true
log_warn "Все прогоны завершены!"
