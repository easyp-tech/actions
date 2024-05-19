#!/bin/sh -l

export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/go/bin

# Установка EasyP указанной версии
go install github.com/easyp-tech/easyp/cmd/easyp@$1

# Проверка, что EasyP установлен
if ! command -v easyp > /dev/null; then
  echo "::error::EasyP installation failed or EasyP is not in the PATH"
  exit 1
fi

# Проверка, что указан каталог
if [ -z "$2" ]; then
  echo "::error ::Please provide the directory path to lint."
  exit 1
fi

# Запуск линтера и печать результатов в формате GitHub Annotations
easyp lint -p $2 | while read -r line; do
    if echo "$line" | grep -qE '([^:]+):([0-9]+):([0-9]+):([^:]+):(.+)'; then
      FILE=$(echo "$line" | cut -d ':' -f 1)
      LINE=$(echo "$line" | cut -d ':' -f 2)
      COL=$(echo "$line" | cut -d ':' -f 3)
      # CODE is not used directly but might be handy for including in the message
      CODE=$(echo "$line" | cut -d ':' -f 4)
      MESSAGE=$(echo "$line" | cut -d ':' -f 5-)
      echo "::error file=$FILE,line=$LINE,col=$COL::$MESSAGE"
    fi
done
