#!/usr/bin/env bash

#!/usr/bin/env bash
set -e

# Проверяем наличие флага --parser или --reporter
if [ "$1" != "--parser" ] && [ "$1" != "--reporter" ]; then
    exit 1
fi

# Папка, откуда вызвали скрипт (папка с make / текущая при запуске)
CALLER_DIR="$(pwd)"

# Папка, где лежит сам скрипт (и Package.swift)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$SCRIPT_DIR/../../MPUtils/"

if [ "$1" == "--parser" ]; then
    swift build -c release --product MPResultParser
    cp "./.build/release/MPResultParser" "$CALLER_DIR/run_parser"
elif [ "$1" == "--reporter" ]; then
    swift build -c release --product MPResultReporter
    cp "./.build/release/MPResultReporter" "$CALLER_DIR/run_reporter"
fi
