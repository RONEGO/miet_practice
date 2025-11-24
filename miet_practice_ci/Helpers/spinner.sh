#!/usr/bin/env bash

spinner() {
    local pid=$1
    local delay=0.1               # скорость вращения спиннера
    local phrase_delay=3          # раз в сколько секунд менять фразу
    local spin='|/-\'             # сам спиннер
    local phrases=(
        "Задабриваем симулятор 🖥️       "
        "Следим за утечками памяти 🧐   "
        "Просим Xcode не падать 🙏      "
        "Ускоряем тесты силой мысли ⚡️  "
        "Подкручиваем фреймворки 🧩     "
        "Ставим кофе ☕️                 "
        "Греем процессор 🔥             "
    )

    local start_time=$(date +%s)
    local current_phrase_index=0
    local current_phrase="${phrases[$current_phrase_index]}"

    tput civis 2>/dev/null || true # скрыть курсор

    while kill -0 "$pid" 2>/dev/null; do
        # выбираем фразу каждые N секунд
        local now=$(date +%s)
        local elapsed=$(( now - start_time ))
        local index=$(( elapsed / phrase_delay ))

        if (( index != current_phrase_index )); then
            current_phrase_index=$index
            current_phrase="${phrases[$(( current_phrase_index % ${#phrases[@]} ))]}"
        fi

        # крутим спиннер
        for (( i=0; i<${#spin}; i++ )); do
            printf "\r\033[K[%c] %s" "${spin:$i:1}" "$current_phrase"
            sleep "$delay"

            # если процесс завершился в середине цикла — прерываем
            kill -0 "$pid" 2>/dev/null || break
        done
    done
}
