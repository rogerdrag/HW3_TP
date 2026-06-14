# HW3: Docker Generator and Reporter Сулоев Николай ББИ2507

## Тематика данных: студенты
Колонки: `student_id`, `gpa`, `exam_score`, `group`

## Команды

```bash
./run.sh build_generator
```
Собирает Docker-образ генератора

```bash
./run.sh run_generator
```
Запускает контейнер, который создаёт `data/data.csv` локально на хосте

```bash
./run.sh create_local_data
```
Создаёт `local_data/data.csv` локально без Docker (для отладки)

```bash
./run.sh build_reporter
```
Собирает Docker-образ аналитика

```bash
./run.sh run_reporter
```
Запускает контейнер, который создаёт `data/report.html` локально на хосте

```bash
./run.sh structure
```
Выводит структуру всех файлов проекта

```bash
./run.sh clear_data
```
Удаляет все `.csv` и `.html` из папки `data/`

```bash
./run.sh inside_generator
```
Показывает содержимое `/data` изнутри контейнера генератора

```bash
./run.sh inside_reporter
```
Показывает содержимое `/data` изнутри контейнера аналитика

```bash
./run.sh report_server
```
Запускает nginx-контейнер на порту 8080, который раздаёт `report.html`
