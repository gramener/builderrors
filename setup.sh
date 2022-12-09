# Install node packages exactly as-is
npm ci --omit=dev

# Extra packages (from requirements-extra.txt) will be run via flake8, but not raise build erros
python -m venv venv-extra
if [[ -f "venv-extra/bin/activate" ]]; then
  source "venv-extra/bin/activate"
  pip install -r requirements-extra.txt
elif [[ -f "venv-extra/Scripts/activate" ]]; then
  source "venv-extra/Scripts/activate"
  pip install -r requirements-extra.txt
fi

# Core packages (from requirements.txt) will raise build errors
python -m venv venv-core
if [[ -f "venv-core/bin/activate" ]]; then
  source "venv-core/bin/activate"
  pip install -r requirements.txt
elif [[ -f "venv-core/Scripts/activate" ]]; then
  source "venv-core/Scripts/activate"
  pip install -r requirements.txt
fi
