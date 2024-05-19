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
OUTPUT_FILE="/github/workspace/easyp_lint_output.txt"
easyp lint -p "$2" > "$OUTPUT_FILE"

# Проверяем, обнаружены ли ошибки
if grep -q ":" "$OUTPUT_FILE"; then
  # Ошибки найдены, создаем аннотации для GitHub Actions
  while IFS= read -r line; do
    if echo "$line" | grep -q ":"; then
      FILE_PATH=$(echo "$line" | awk -F ':' '{print $1}')
      LINE=$(echo "$line" | awk -F ':' '{print $2}')
      COLUMN=$(echo "$line" | awk -F ':' '{print $3}')
      MESSAGE=$(echo "$line" | awk -F ':' '{print $4}')
      # Создаем аннотацию ошибки для GitHub Actions
      echo "::error file=$FILE_PATH,line=$LINE,col=$COLUMN::$MESSAGE"
    fi
  done < "$OUTPUT_FILE"
  exit 1
else
  echo "No linting errors found."
fi

exit 0