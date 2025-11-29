#!/usr/bin/env bash
# Конфигурация скрипта запуска тестов

# Глобальные переменные
CACHE_DIR="./Cache"
PROJECT_PATH="../MPTestableApp/MPTestableApp.xcodeproj"
REPORTER_PATH="./run_reporter"
PARSER_PATH="./run_parser"

# Список тестов для запуска
TESTS=(
    "MPTestableAppUnitTests"
    "MPTestableAppUITests"
)

