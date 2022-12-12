.DEFAULT_GOAL := help
PACKAGE := python_template
OLD_PACKAGE := ${shell find . -maxdepth 2 -name __init__.py | grep -v tests | cut -d'/' -f2}
LINE_LENGTH := 80
VENV_DIR := ~/.venv/${PACKAGE}

.PHONY: docs-new docs-serve docs-deploy venv pip-dev pip-prd typehint autoflake pylint radon test black pc-install package isort clean setup checklist

help: ## Show this help message.
	@echo -e 'Usage: make [target] ...\n'
	@echo 'targets:'
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

autoflake: ## autoflake
	${VENV_DIR}/bin/autoflake --in-place --remove-unused-variables  --remove-all-unused-imports --recursive src/${PACKAGE}/ tests/

black: ## Run the black formatter
	${VENV_DIR}/bin/black src/${PACKAGE}/ tests/ -l ${LINE_LENGTH}

clean: ## clean up venv and cache
	find . -type f -name "*pyc" | xargs rm -rf
	find . -type d -name __pycache__ | xargs rm -rf
	find . -type d -name ${VENV_DIR} | xargs rm -rf

docs-deploy: ## deploy docs to github
	${VENV_DIR}/bin/mkdocs gh-deploy

docs-new: ## create documentation library
	${VENV_DIR}/bin/mkdocs new .

docs-serve: ## spin up local web server to serve up docs on localhost
	${VENV_DIR}/bin/mkdocs serve

isort: ## run isort
	${VENV_DIR}/bin/isort src/${PACKAGE}/ tests/

package: ## Update the project package name according to whats defined in the Makefile `PACKAGE` variable
	mv src/${OLD_PACKAGE} src/${PACKAGE}

pc-install: ## Setup pre-commit
	${VENV_DIR}/bin/pre-commit install

pip-dev: ## Install pip dev (for local development) requirements
	${VENV_DIR}/bin/pip install --upgrade pip --requirement dev-requirements.txt

pip-prd: ## Install pip prod requirements
	${VENV_DIR}/bin/pip install --upgrade pip --requirement requirements.txt

pylint: ## pylint
	${VENV_DIR}/bin/pylint --exit-zero src/${PACKAGE}/ tests/

radon: ## radon
	${VENV_DIR}/bin/radon cc -a -nc src/${PACKAGE}/ tests/

test: ## Run tests
	${VENV_DIR}/bin/pytest -s --verbose tests/

typehint: ## Mypy typehints
	${VENV_DIR}/bin/mypy --ignore-missing-imports src/${PACKAGE}/ tests/

venv: ## Create a python virtual environment
	python -m venv ${VENV_DIR}

setup: venv pip-dev pc-install

checklist: black autoflake isort pylint
