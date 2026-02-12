#!/usr/bin/env bash
set -e

if [[ ! -d "$UV_PROJECT_ENVIRONMENT" ]]; then
  uv venv $UV_PROJECT_ENVIRONMENT
fi
source $UV_PROJECT_ENVIRONMENT/bin/activate

cd $APP_DIR
uv pip install -r requirements.txt
uv pip install "transformers==5.0.0"
uv run --no-config entrypoint.py
