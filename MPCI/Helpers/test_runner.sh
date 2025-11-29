#!/usr/bin/env bash
# Функции для запуска и обработки тестов

# Парсинг результатов теста
parse_test_results() {
    local result_path="$1"
    local parsing_file_path="$2"
    local parser_path="$3"
    
    local result_absolute_path
    result_absolute_path=$(cd "$result_path" && pwd)
    
    local parsing_absolute_path
    parsing_absolute_path=$(cd "$(dirname "$parsing_file_path")" && pwd)/$(basename "$parsing_file_path")
    
    "$parser_path" "$result_absolute_path" "$parsing_absolute_path"
}

# Запуск одного теста
run_single_test() {
    local scheme="$1"
    local project_path="$2"
    local build_logs_path="$3"
    local result_path="$4"
    
    # Запускаем тесты, сохраняя pid
    ./run_specific_test.sh "$scheme" "$project_path" "$build_logs_path" "$result_path" & 
    local pid=$!
    
    log_info "PID $pid"
    wait "$pid"
    return $?
}

# Запуск всех тестов
run_all_tests() {
    local base_url="$1"
    local tests_failed_ref="$2"  # Имя переменной для возврата результата
    
    local tests_failed=false
    
    for scheme in "${TESTS[@]}"; do
        local build_logs_path="$CACHE_DIR/${scheme}Build.log"
        local result_path="$CACHE_DIR/${scheme}Results.xcresult"
        
        # Запускаем тест
        run_single_test "$scheme" "$PROJECT_PATH" "$build_logs_path" "$result_path"
        local test_exit_code=$?
        
        if [ $test_exit_code -ne 0 ]; then
            tests_failed=true
        fi
        
        # Парсим результаты только если BASE_URL передан
        if [ -n "$base_url" ]; then
            local parsing_file_path="$CACHE_DIR/${scheme}Parsing.json"
            parse_test_results "$result_path" "$parsing_file_path" "$PARSER_PATH"
        fi
        
        echo ""
    done
    
    # Возвращаем результат через переменную
    eval "$tests_failed_ref=\"$tests_failed\""
}

