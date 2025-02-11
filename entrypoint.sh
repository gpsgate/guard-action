#!/bin/sh

if [ -z "$INPUT_DATA_DIRECTORY" ]; then
  echo "Environment variable DATA_DIRECTORY is not set. Quitting." >&2
  exit 1
fi

if [ ! -d "$INPUT_DATA_DIRECTORY" ]; then
  echo "${INPUT_DATA_DIRECTORY} path not found. Quitting." >&2
  exit 1
fi

if [ -f "/${INPUT_RULE_SET}.guard" ]; then
  # Construct cfn-guard command
  # shellcheck disable=SC2086 # Intentionally pass options as-is
  [ -n "$INPUT_OPTIONS" ] && set -- $INPUT_OPTIONS
  [ -n "$INPUT_DATA_DIRECTORY" ] && set -- --data "$INPUT_DATA_DIRECTORY" "$@"
  [ -n "$INPUT_RULE_SET" ] && set -- --rules "$INPUT_RULE_SET" "$@"
  [ -n "$INPUT_SHOW_SUMMARY" ] && set -- --show-summary "$INPUT_SHOW_SUMMARY" "$@"
  [ -n "$INPUT_OUTPUT_FORMAT" ] && set -- --output-format "$INPUT_OUTPUT_FORMAT" "$@"
  set -- cfn-guard validate "$@"

  # execute command in place
  printf "...scanning with only guard rule set %s" "$INPUT_RULE_SET"
  echo "Running: $*"
  exec "$@"
else
  echo "Environment variable RULE_SET is not set to an allowed option...Quitting." >&2
  exit 1
fi
