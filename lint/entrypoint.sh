#!/bin/sh -l

export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/go/bin

# Установка EasyP указанной версии
go install github.com/easyp-tech/easyp/cmd/easyp@$1

# Проверка, что EasyP установлен
if ! command -v easyp > /dev/null; then
  echo "EasyP installation failed or EasyP is not in the PATH"
  exit 1
fi

# Проверка, что указан каталог
if [ -z "$2" ]; then
  echo "Please provide the directory path to lint."
  exit 1
fi

# Запуск линтера и сохранение вывода в переменную
OUTPUT=$(easyp lint -p $2)
echo "$OUTPUT"

# Переменная для отслеживания наличия ошибок
ERROR_DETECTED=0

# Анализируем каждую строку вывода
echo "$OUTPUT" | while read -r line; do
  # Проверяем, содержит ли строка путь к файлу и номер строки, что указывает на ошибку
  if echo "$line" | grep -q ":[0-9]\+:[0-9]\+:"; then
    ERROR_DETECTED=1
    # Извлекаем данные из строки
    FILE_PATH=$(echo "$line" | cut -d: -f1)
    LINE=$(echo "$line" | cut -d: -f2)
    COLUMN=$(echo "$line" | cut -d: -f3)
    MESSAGE=$(echo "$line" | cut -d: -f4-)
    # Создаем аннотацию ошибки для GitHub Actions
    echo "::error file=$FILE_PATH,line=$LINE,col=$COLUMN::$MESSAGE"
  fi
done

# Если были обнаружены ошибки, завершаем с ошибкой
if [ "$ERROR_DETECTED" -eq 1 ]; then
  exit 1
fi

# Если ошибок не обнаружено, скрипт завершится успешно
exit 0