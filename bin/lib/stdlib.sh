#!/usr/bin/env bash
# stdlib.sh - Shared utilities for claude-team scripts
#
# Provides formatted output and dependency management.
# Extracted from claude-utils/bin/lib/stdlib.sh (only functions
# that claude-team actually uses).

# ANSI color codes
ANSI_RED="\033[0;31m"
ANSI_GREEN="\033[0;32m"
ANSI_BLUE="\033[0;34m"
ANSI_DARK_YELLOW="\033[0;33m"
ANSI_ORANGE="\033[38;5;208m"
ANSI_RESET="\033[0m"

error() {
  echo -e "${ANSI_RED}ERROR: $1${ANSI_RESET}" >&2
}

warn() {
  exec 1>&1
  echo -e "${ANSI_ORANGE}$1${ANSI_RESET}" >&2
}

fatal() {
  error "$1"
  exit 1
}

hint() {
  echo -e "${ANSI_DARK_YELLOW}  hint| $1${ANSI_RESET}"
}

success() {
  echo -e "${ANSI_GREEN}$1${ANSI_RESET}"
}

info() {
  echo -e "${ANSI_BLUE}[INFO]${ANSI_RESET} $1"
}

# Check for a command and install via Homebrew if missing
# NOTE: doesn't work when the tool name differs from the brew formula name
check_and_install() {
  local cmd="$1"
  if ! command -v "$cmd" &>/dev/null; then
    if command -v brew &>/dev/null; then
      echo "$cmd not found, installing via Homebrew..."
      if command -v gum &>/dev/null; then
        gum spin --spinner dot --title "Installing tool from brew - $cmd" -- bash -c "brew install $cmd || fatal 'Failed to install $cmd'"
      else
        brew install "$cmd" || fatal "Failed to install $cmd"
      fi
      echo "✅ installed $cmd"
    else
      fatal "$cmd not found and Homebrew is not installed. Exiting."
    fi
  fi
}
