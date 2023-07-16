.DEFAULT_GOAL := help
PACKAGE := python_template
OLD_PACKAGE := ${shell find . -maxdepth 2 -name __init__.py | grep -v tests | cut -d'/' -f2}
VENV_DIR := .venv

help: ## Show this help message.
	@echo -e 'Usage: make [target] ...\n'
	@echo 'targets:'
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

.PHONY: black
black: ## Run the black formatter
	${VENV_DIR}/bin/black src/${PACKAGE}/ tests/

.PHONY: clean
clean: ## clean up venv and cache
	find . -type d -regextype sed -regex ".*/[build|dist|__pycache__|${VENV_DIR}|\.pytest_cache]" -delete
	find . -type f -regextype sed -regex ".*/[*.egg-info|*\.pyc|*\.pyo|*\.egg-link]" -delete

.PHONY: pip-install
pip-install: ## Install pip requirements
	${VENV_DIR}/bin/pip install --upgrade pip --requirement requirements.txt

.PHONY: ruff
ruff: ## ruff linting
	${VENV_DIR}/bin/ruff check src/ --select "A", "B", "E", "F", "I", "N", "W", "PTH" --fix

.PHONY: rye-add
rye-add: ## `rye add` for each item in the `requirements.txt`
	cat requirements.txt | while read package; do rye add ${package}; done

.PHONY: rye-init
rye-init: ## Initialize rye project with `rye init`
	rye init --name "${PACKAGE}"

.PHONY: test
test: ## Run tests via pytest
	${VENV_DIR}/bin/pytest --cov --cov-report term-missing --cov-fail-under 95 --verbose

.PHONY: typecheck
typecheck: ## mypy static type-checking (options are defined in pyproject.toml)
	${VENV_DIR}/bin/mypy --ignore-missing-imports --explicit-package-bases src/${PACKAGE}/ tests/

.PHONY: venv
venv: ## Create a python virtual environment
	python -m venv ${VENV_DIR}

setup: clean venv install

checklist: black ruff

