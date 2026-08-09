#!/usr/bin/env bash
set -e

if [[ ! -d "$UV_PROJECT_ENVIRONMENT" ]]; then
  uv venv $UV_PROJECT_ENVIRONMENT
fi
source $UV_PROJECT_ENVIRONMENT/bin/activate

# UV_OVERRIDE is read by uv natively: version pins in that file override
# requirements.txt pins during resolution (see README "Overriding Packages")
if [[ -n "${UV_OVERRIDE}" && ! -f "${UV_OVERRIDE}" ]]; then
  echo "WARNING: UV_OVERRIDE file not found: ${UV_OVERRIDE} - ignoring"
  unset UV_OVERRIDE
fi

cd $APP_DIR
uv pip install -r requirements.txt

# Install extra packages if specified
if [[ -n "${EXTRA_PACKAGES}" ]]; then
  echo "Installing extra packages: ${EXTRA_PACKAGES}"
  uv pip install ${EXTRA_PACKAGES}
fi

exec uv run --no-config entrypoint.py
