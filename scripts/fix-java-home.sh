#!/usr/bin/env bash

set -euo pipefail

SCRIPT_MARKER_START="# >>> java-home-fix >>>"
SCRIPT_MARKER_END="# <<< java-home-fix <<<"

if ! command -v java >/dev/null 2>&1; then
  echo "java is not installed or not in PATH."
  echo "Rebuild the Devcontainer after pulling the latest Dockerfile:"
  echo "  Dev Containers: Rebuild Container"
  exit 1
fi

JAVA_BIN_PATH="$(readlink -f "$(command -v java)")"
JAVA_HOME_PATH="$(dirname "$(dirname "${JAVA_BIN_PATH}")")"

echo "Detected java binary: ${JAVA_BIN_PATH}"
echo "Detected JAVA_HOME: ${JAVA_HOME_PATH}"

export JAVA_HOME="${JAVA_HOME_PATH}"
export PATH="${JAVA_HOME}/bin:${PATH}"

touch "${HOME}/.bashrc"
if grep -qF "${SCRIPT_MARKER_START}" "${HOME}/.bashrc"; then
  python3 - "${HOME}/.bashrc" "${SCRIPT_MARKER_START}" "${SCRIPT_MARKER_END}" <<'PY'
import pathlib
import re
import sys

path = pathlib.Path(sys.argv[1])
start = re.escape(sys.argv[2])
end = re.escape(sys.argv[3])
pattern = re.compile(rf"\n?{start}.*?{end}\n?", re.S)
content = path.read_text()
path.write_text(pattern.sub("\n", content).rstrip() + "\n")
PY
fi

{
  echo ""
  echo "${SCRIPT_MARKER_START}"
  echo "export JAVA_HOME=\"${JAVA_HOME_PATH}\""
  echo "export PATH=\"\$JAVA_HOME/bin:\$PATH\""
  echo "${SCRIPT_MARKER_END}"
} >> "${HOME}/.bashrc"
echo "Persisted JAVA_HOME to ${HOME}/.bashrc"

echo ""
echo "JAVA_HOME is now set for this shell:"
echo "  JAVA_HOME=${JAVA_HOME}"
java -version

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  echo ""
  echo "Note: script was executed in a subshell."
  echo "Apply to current terminal now with:"
  echo "  source \"${HOME}/.bashrc\""
  echo "or"
  echo "  source ./scripts/fix-java-home.sh"
fi
