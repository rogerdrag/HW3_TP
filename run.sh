#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$SCRIPT_DIR/data"
LOCAL_DATA_DIR="$SCRIPT_DIR/local_data"

case "$1" in

  build_generator)
    echo "==> Сборка образа генератора..."
    docker build -t generator "$SCRIPT_DIR/generator"
    ;;

  run_generator)
    echo "==> Запуск генератора данных..."
    mkdir -p "$DATA_DIR"
    docker run --rm -v "$DATA_DIR":/data generator
    echo "==> Файл сгенерирован: data/data.csv"
    ;;

  create_local_data)
    echo "==> Создание data.csv локально в local_data/..."
    mkdir -p "$LOCAL_DATA_DIR"
    python3 "$SCRIPT_DIR/generate.py" "$LOCAL_DATA_DIR"
    echo "==> Файл создан: local_data/data.csv"
    ;;

  build_reporter)
    echo "==> Сборка образа аналитика..."
    docker build -t reporter "$SCRIPT_DIR/reporter"
    ;;

  run_reporter)
    echo "==> Запуск аналитика данных..."
    mkdir -p "$DATA_DIR"
    docker run --rm -v "$DATA_DIR":/data reporter
    echo "==> Отчёт сгенерирован: data/report.html"
    ;;

  structure)
    echo "==> Структура проекта:"
    ls -R "$SCRIPT_DIR"
    ;;

  clear_data)
    echo "==> Удаление сгенерированных файлов из data/..."
    rm -f "$DATA_DIR"/*.csv "$DATA_DIR"/*.html
    echo "==> Папка data/ очищена"
    ;;

  inside_generator)
    echo "==> Содержимое /data внутри контейнера генератора:"
    mkdir -p "$DATA_DIR"
    docker run --rm -v "$DATA_DIR":/data --entrypoint ls generator -la /data
    ;;

  inside_reporter)
    echo "==> Содержимое /data внутри контейнера аналитика:"
    mkdir -p "$DATA_DIR"
    docker run --rm -v "$DATA_DIR":/data --entrypoint ls reporter -la /data
    ;;

  report_server)
    echo "==> Запуск веб-сервера с отчётом..."
    mkdir -p "$DATA_DIR"
    docker run -d --rm \
      -p 8080:80 \
      -v "$DATA_DIR":/usr/share/nginx/html:ro \
      --name report_server \
      nginx
    echo "==> Сервер запущен: http://localhost:8080/report.html"
    ;;

  *)
    echo "Использование: $0 <команда>"
    echo ""
    echo "Команды:"
    echo "  build_generator    — собрать образ генератора"
    echo "  run_generator      — запустить генератор (создаёт data/data.csv)"
    echo "  create_local_data  — создать data.csv локально в local_data/"
    echo "  build_reporter     — собрать образ аналитика"
    echo "  run_reporter       — запустить аналитика (создаёт data/report.html)"
    echo "  structure          — показать структуру файлов проекта"
    echo "  clear_data         — удалить .csv и .html из data/"
    echo "  inside_generator   — показать /data изнутри контейнера генератора"
    echo "  inside_reporter    — показать /data изнутри контейнера аналитика"
    echo "  report_server      — запустить nginx-контейнер для просмотра отчёта"
    exit 1
    ;;

esac
