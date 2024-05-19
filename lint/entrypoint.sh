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

# Запуск линтера и запись вывода в переменную
OUTPUT=$(easyp lint -p $2)
echo "$OUTPUT"

# Проверка OUTPUT на наличие шаблона, указывающего на ошибку
if echo "$OUTPUT" | grep -q "CODE_"; then
  echo "Linting errors found"
  # Выводим ошибки в формате, который GitHub Actions распознает как аннотации
  echo "$OUTPUT" | grep "CODE_" | while read -r line; do
    FILE_PATH=$(echo "$line" | cut -d: -f1)
    LINE=$(echo "$line" | cut -d: -f2)
    MESSAGE=$(echo "$line" | cut -d' ' -f3-)
    echo "::error file=$FILE_PATH,line=$LINE::$(echo $MESSAGE)"
  done
  exit 1
fi

# Если ошибок не обнаружено, скрипт завершится успешно
exit 0
