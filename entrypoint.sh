#!/usr/bin/env bash
set -e

if [[ ! -d "$UV_PROJECT_ENVIRONMENT" ]]; then
  uv venv $UV_PROJECT_ENVIRONMENT
fi
source $UV_PROJECT_ENVIRONMENT/bin/activate

cd $APP_DIR
uv pip install -r requirements.txt

# Install extra requirements from file if specified and file exists
if [[ -n "${EXTRA_REQUIREMENTS}" ]]; then
  if [[ -f "${EXTRA_REQUIREMENTS}" ]]; then
    echo "Installing extra requirements from ${EXTRA_REQUIREMENTS}..."
    uv pip install -r "${EXTRA_REQUIREMENTS}"
  else
    echo "WARNING: EXTRA_REQUIREMENTS file not found: ${EXTRA_REQUIREMENTS} - skipping"
  fi
fi

# Install extra packages if specified
if [[ -n "${EXTRA_PACKAGES}" ]]; then
  echo "Installing extra packages: ${EXTRA_PACKAGES}"
  uv pip install ${EXTRA_PACKAGES}
fi

uv run --no-config entrypoint.py
