#!/usr/bin/env bash
# Функции для работы с API

# Получение абсолютного пути к файлу
get_absolute_path() {
    local file_path="$1"
    echo "$(cd "$(dirname "$file_path")" && pwd)/$(basename "$file_path")"
}

# Отправка запроса на запуск сборки
send_run_request() {
    local base_url="$1"
    local cache_file="$2"
    local task_id="$3"  # Опциональный task_id
    local git_branch="$4"  # Опциональный git_branch
    
    local absolute_path
    absolute_path=$(get_absolute_path "$cache_file")
    
    log_info "Отправляем запрос на запуск сборки..."
    
    # Формируем массив аргументов для команды
    local args=("run")

    args+=("$base_url" "$absolute_path")

    if [ -n "$task_id" ]; then
        args+=("--task-id" "$task_id")
    fi
    
    if [ -n "$git_branch" ]; then
        args+=("--git-branch" "$git_branch")
    fi

    "$REPORTER_PATH" "${args[@]}" || {
        log_warn "Не удалось отправить запрос на запуск сборки"
        return 1
    }
}

# Отправка запроса на отправку результатов одного теста
send_submit_single_test_result() {
    local base_url="$1"
    local cache_file="$2"
    local parsing_file_path="$3"
    
    local absolute_path
    absolute_path=$(get_absolute_path "$cache_file")
    
    if [ ! -f "$parsing_file_path" ]; then
        log_warn "Файл с результатами теста не найден: $parsing_file_path"
        return 1
    fi
    
    local parsing_absolute_path
    parsing_absolute_path=$(get_absolute_path "$parsing_file_path")
    
    log_info "Отправляем результаты теста..."
    "$REPORTER_PATH" submit-tests --test-results-file "$parsing_absolute_path" "$base_url" "$absolute_path" || {
        log_warn "Не удалось отправить результаты теста"
        return 1
    }
}

# Отправка запроса на завершение сборки
send_complete_request() {
    local base_url="$1"
    local cache_file="$2"
    local build_status="$3"
    
    local absolute_path
    absolute_path=$(get_absolute_path "$cache_file")
    
    log_info "Отправляем запрос на завершение сборки со статусом $build_status..."
    "$REPORTER_PATH" complete --build-status "$build_status" "$base_url" "$absolute_path" || {
        log_warn "Не удалось отправить запрос на завершение сборки"
        return 1
    }
}

# Отправка файла лога для test suite
send_log_file() {
    local base_url="$1"
    local cache_file="$2"
    local log_file_path="$3"
    
    local absolute_path
    absolute_path=$(get_absolute_path "$cache_file")
    
    if [ ! -f "$log_file_path" ]; then
        log_warn "Файл лога не найден: $log_file_path"
        return 1
    fi
    
    local log_absolute_path
    log_absolute_path=$(get_absolute_path "$log_file_path")

    log_info "Отправляем файл лога..."
    "$REPORTER_PATH" submit-log --test-suite-log "$log_absolute_path" "$base_url" "$absolute_path" || {
        log_warn "Не удалось отправить файл лога"
        return 1
    }
}

