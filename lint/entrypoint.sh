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

# Запуск линтера и вывод ошибок в формате, понятном GitHub Actions
easyp lint -p $2 | while IFS= read -r line; do
  # Предполагаем, что формат строки ошибки: filepath:line:col:CODE: message
  FILE_PATH=$(echo "$line" | cut -d: -f1)
  LINE=$(echo "$line" | cut -d: -f2)
  COLUMN=$(echo "$line" | cut -d: -f3)
  MESSAGE=$(echo "$line" | cut -d: -f4-)
  echo "::error file=$FILE_PATH,line=$LINE,col=$COLUMN::$MESSAGE"
done

# Если вы хотите завершить работу с ненулевым статусом в случае обнаружения ошибок
if [ -s easyp_lint_output.txt ]; then
  exit 1
fi