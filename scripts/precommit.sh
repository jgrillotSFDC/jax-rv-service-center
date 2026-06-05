#!/usr/bin/env bash

set -euo pipefail

if command -v java >/dev/null 2>&1; then
  JAVA_BIN_PATH="$(readlink -f "$(command -v java)")"
  export JAVA_HOME="$(dirname "$(dirname "${JAVA_BIN_PATH}")")"
  export PATH="${JAVA_HOME}/bin:${PATH}"
  echo "Using JAVA_HOME=${JAVA_HOME}"
else
  echo "Warning: java command not found. prettier-plugin-apex may fail."
fi

npx lint-staged "$@"
