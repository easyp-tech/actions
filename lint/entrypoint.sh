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

# Запуск линтера и запись вывода в файл
OUTPUT_FILE=easyp_lint_output.txt
easyp lint -p "$2" > "$OUTPUT_FILE"

# Проверяем, обнаружены ли ошибки
if grep -q ":" "$OUTPUT_FILE"; then
  # Ошибки найдены, печатаем их и создаем аннотации для GitHub Actions
  while IFS= read -r line; do
    FILE_PATH=$(echo "$line" | cut -d: -f1)
    LINE=$(echo "$line" | cut -d: -f2)
    COLUMN=$(echo "$line" | cut -d: -f3)
    MESSAGE=$(echo "$line" | cut -d: -f4-)
    echo "::error file=$FILE_PATH,line=$LINE,col=$COLUMN::$MESSAGE"
  done < "$OUTPUT_FILE"
  exit 1
else
  echo "No linting errors found."
fi

exit 0