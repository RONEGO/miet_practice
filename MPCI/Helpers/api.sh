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
    
    local absolute_path
    absolute_path=$(get_absolute_path "$cache_file")
    
    log_info "Отправляем запрос на запуск сборки..."
    "$REPORTER_PATH" "$base_url" "$absolute_path" --run || {
        log_warn "Не удалось отправить запрос на запуск сборки"
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
    "$REPORTER_PATH" "$base_url" "$absolute_path" --complete --build-status "$build_status" || {
        log_warn "Не удалось отправить запрос на завершение сборки"
        return 1
    }
}

