#!/usr/bin/env bash

# Ensure build error script is executable
chmod +x builderrors

# Install node packages exactly as-is
npm ci --omit=dev
# Build dependencies
npm run build

# Core packages (from requirements.txt) will raise build errors
python -m venv venv-core
if [[ -f "venv-core/bin/activate" ]]; then
  source "venv-core/bin/activate"
  pip install -r requirements.txt
elif [[ -f "venv-core/Scripts/activate" ]]; then
  source "venv-core/Scripts/activate"
  pip install -r requirements.txt
fi
