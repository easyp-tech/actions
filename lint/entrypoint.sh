#!/bin/sh -l

export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/go/bin

# Install EasyP with the given version
go install github.com/easyp-tech/easyp/cmd/easyp@$1

# Check if EasyP installed successfully
if ! command -v easyp > /dev/null; then
  echo "EasyP installation failed or EasyP is not in the PATH"
  exit 1
fi

# Check if a directory was provided
if [ -z "$2" ]; then
  echo "Please provide the directory path to lint."
  exit 1
fi

# Run EasyP linter and format its output
output=$(easyp lint -p "$2")

# Emit GitHub Actions error logs

# Initialize a variable to track if any errors were emitted
errors_emitted=false

# Process each line of the output
echo "$output" | while IFS= read -r line; do
  echo "Processing line: $line"
  file=$(echo "$line" | awk -F: '{print $1}')
  line_number=$(echo "$line" | awk -F: '{print $2}')
  column=$(echo "$line" | awk -F: '{print $3}')
  message=$(echo "$line" | awk -F: '{print $4 $5}')
  if [ -n "$file" ] && [ -n "$line_number" ] && [ -n "$column" ] && [ -n "$message" ]; then
    # If the line matches the format file:line:column:message, format it for GitHub Actions
    echo "::error file=$file,line=$line_number,col=$column::$message"
    # Set the errors_emitted variable to true
    errors_emitted=true
  else
    # If the line does not match the expected format, print it as is
    echo "$line"
  fi
done

# If any errors were emitted, exit with code 1
if [ "$errors_emitted" = true ]; then
  echo "Errors were emitted during linting."
  exit 1
fi
