.DEFAULT_GOAL := help
PACKAGE := python_template
OLD_PACKAGE := ${shell find . -maxdepth 2 -name __init__.py | grep -v tests | cut -d'/' -f2}
VENV_DIR := ~/.venv/${PACKAGE}

.PHONY: docs-new docs-serve docs-deploy venv pip-dev pip-prd typehint autoflake pylint radon test black pc-install package isort clean setup checklist

help: ## Show this help message.
	@echo -e 'Usage: make [target] ...\n'
	@echo 'targets:'
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

black: ## Run the black formatter
	${VENV_DIR}/bin/black src/${PACKAGE}/ tests/

clean: ## clean up venv and cache
	find . -type f -name "*pyc" | xargs rm -rf
	find . -type d -name __pycache__ | xargs rm -rf
	find ${VENV_DIR} -type d | xargs rm -rf

docs-deploy: ## deploy docs to github
	${VENV_DIR}/bin/mkdocs gh-deploy

docs-new: ## create documentation library
	${VENV_DIR}/bin/mkdocs new .

docs-serve: ## spin up local web server to serve up docs on localhost
	${VENV_DIR}/bin/mkdocs serve

package: ## Update the project package name according to whats defined in the Makefile `PACKAGE` variable
	mv src/${OLD_PACKAGE} src/${PACKAGE}

pc-install: ## Setup pre-commit
	${VENV_DIR}/bin/pre-commit install

pip-dev: ## Install pip dev (for local development) requirements
	${VENV_DIR}/bin/pip install --upgrade pip --requirement dev-requirements.txt

pip-prd: ## Install pip prod requirements
	${VENV_DIR}/bin/pip install --upgrade pip --requirement requirements.txt

radon: ## radon
	${VENV_DIR}/bin/radon cc --average -nc src/${PACKAGE}/ tests/
	${VENV_DIR}/bin/radon mi src/${PACKAGE}/ tests/

ruff: ## ruff linting
	${VENV_DIR}/bin/ruff --show-files src/${PACKAGE}/ tests/

test: ## Run tests
	${VENV_DIR}/bin/pytest -s --verbose tests/

typecheck: ## mypy static type-checking
	${VENV_DIR}/bin/mypy --ignore-missing-imports --explicit-package-bases src/${PACKAGE}/ tests/

venv: ## Create a python virtual environment
	python -m venv ${VENV_DIR}

setup: venv pip-dev pc-install

checklist: black ruff radon
