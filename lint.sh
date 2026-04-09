#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")"

bash_files=(
  setup.sh
  bin/1password
  bin/cron-exec
)

zsh_files=(
  .zshrc
)

exit_code=0

for file in "${bash_files[@]}"; do
  echo "shellcheck $file..."
  if ! shellcheck "$file"; then
    exit_code=1
  fi
done

for file in "${zsh_files[@]}"; do
  echo "zsh -n $file..."
  if ! zsh -n "$file"; then
    exit_code=1
  fi
done

if [ "$exit_code" -eq 0 ]; then
  echo "All files passed."
fi

exit "$exit_code"
