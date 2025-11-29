#!/usr/bin/env bash
# Функции для работы с кешем

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
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    
    if [ ! -f "$REPORTER_PATH" ]; then
        log_info "Файл run_reporter не найден, создаём..."
        "$script_dir/Factory/maker.sh" --reporter
        log_success "run_reporter создан"
    fi
    
    rm -f "$PARSER_PATH"
    if [ ! -f "$PARSER_PATH" ]; then
        log_info "Файл run_parser не найден, создаём..."
        "$script_dir/Factory/maker.sh" --parser
        log_success "run_parser создан"
    fi
}

# Создание директории кеша, если её нет
ensure_cache_directory() {
    mkdir -p "$CACHE_DIR"
}

