#!/usr/bin/env bash

#!/usr/bin/env bash
set -e

# Папка, откуда вызвали скрипт (папка с make / текущая при запуске)
CALLER_DIR="$(pwd)"

# Папка, где лежит сам скрипт (и Package.swift)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$SCRIPT_DIR"

swift build -c release

cp "./.build/release/xcresult-reporter" "$CALLER_DIR/"
