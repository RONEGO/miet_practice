#!/usr/bin/env bash

# Цвета
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;36m"
WHITE="\033[0;37m"
RESET="\033[0m"

# Эмодзи
CHECK="✅"
CROSS="❌"
INFO="ℹ️"
WARN="⚠️"

# Функции логирования
log() {
    echo -e "${WHITE}$1${RESET}"
}

log_info() {
    echo -e "${BLUE}${INFO} $1${RESET}"
}

log_success() {
    echo -e "${GREEN}${CHECK} $1${RESET}"
}

log_warn() {
    echo -e "${YELLOW}${WARN} $1${RESET}"
}

log_error() {
    echo -e "${RED}${CROSS} $1${RESET}"
}

