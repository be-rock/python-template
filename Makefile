.DEFAULT_GOAL := help
PACKAGE := python_template
TEST_COV_PCT := 100
VENV_DIR := .venv

.PHONY: help
help: ## Show this help message
	@echo -e 'Usage: make [target]\n'
	@echo -e 'Targets:'
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

.PHONY: black
black: ## Run the black formatter
	@echo "\nINFO Run the black formatter..."
	${VENV_DIR}/bin/black src/${PACKAGE}/ tests/

checklist: ## Run the checklist of rules
checklist: black ruff

.PHONY: clean
clean: ## clean up venv and cache
	@echo "\nINFO clean up venv and cache..."
	rm -rf ${VENV_DIR}
	find . -type d -regextype sed -regex ".*/[build|dist|__pycache__|${VENV_DIR}|\.pytest_cache]" -delete
	find . -type f -regextype sed -regex ".*/[*.egg-info|*\.pyc|*\.pyo|*\.egg-link]" -delete

.PHONY: pip-dev
pip-dev: ## Install pip requirements (dev)
	@echo "\nINFO Install pip requirements (dev)..."
	${VENV_DIR}/bin/pip install --upgrade pip --requirement requirements-dev.lock

.PHONY: pip-install
pip-install: ## Install pip requirements (prod)
	@echo "\nINFO Install pip requirements (prod)..."
	${VENV_DIR}/bin/pip install --upgrade pip --requirement requirements.txt

.PHONY: ruff
ruff: ## Run the ruff linter
	@echo "\nINFO Run the ruff linter..."
	${VENV_DIR}/bin/ruff check src/ --select A,B,E,F,I,N,W,PTH --fix

.PHONY: rye-init
rye-init: ## Initialize rye project with `rye init`
	@echo "\nINFO Initialize rye project with 'rye init' and packages in 'requirements.txt'..."
	rye init --dev-requirements requirements-dev.txt --name "${PACKAGE}"
	@echo "\nINFO 'rye sync' the package list"

setup: ## Setup the environment
setup: clean rye-init

.PHONY: test
test: ## Run tests via pytest
	@echo "\nINFO Run tests via pytest..."
	${VENV_DIR}/bin/pytest --cov --cov-report term-missing --cov-fail-under ${TEST_COV_PCT} --verbose

.PHONY: typecheck
typecheck: ## mypy static type-checking 
	@echo "\nINFO mypy static type-checking..."
	${VENV_DIR}/bin/mypy --ignore-missing-imports --explicit-package-bases src/${PACKAGE}/ tests/

.PHONY: venv
venv: ## Create a python virtual environment
	@echo "\nINFO Create a python virtual environment..."
	${VENV_DIR}/bin/mypy --ignore-missing-imports --explicit-package-bases src/${PACKAGE}/ tests/
	python -m venv ${VENV_DIR}

