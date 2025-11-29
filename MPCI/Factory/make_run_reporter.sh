#!/usr/bin/env bash

#!/usr/bin/env bash
set -e

# Папка, откуда вызвали скрипт (папка с make / текущая при запуске)
CALLER_DIR="$(pwd)"

# Папка, где лежит сам скрипт (и Package.swift)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$SCRIPT_DIR/../../MPUtils/"

swift build -c release --product MPResultReporter

cp "./.build/release/MPResultReporter" "$CALLER_DIR/run_reporter"
