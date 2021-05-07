.DEFAULT_GOAL := help
PACKAGE := ${shell cat .package-name}
LINE_LENGTH := 80
VENV_DIR := .venv

.PHONY: venv pip-dev pip-prd typehint autoflake pylint radon test black pc-install package isort clean install cicd checklist

help: ## Show this help message.
	@echo -e 'Usage: make [target] ...\n'
	@echo 'targets:'
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

venv: ## Create a python virtual environment
	python -m venv ${VENV_DIR}

pip-dev: ## Install pip dev requirements
	${VENV_DIR}/bin/pip install --requirement dev-requirements.txt

pip-prd: ## Install pip prod requirements
	${VENV_DIR}/bin/pip install --requirement requirements.txt

typehint: ## Mypy typehints
	${VENV_DIR}/bin/mypy --ignore-missing-imports ${PACKAGE}/ tests/

autoflake: ## autoflake
	${VENV_DIR}/bin/autoflake --in-place --remove-unused-variables  --remove-all-unused-imports --recursive ${PACKAGE}/ tests/

pylint: ## pylint
	${VENV_DIR}/bin/pylint ${PACKAGE}/ tests/

radon: ## radon
	${VENV_DIR}/bin/radon cc -a -nc ${PACKAGE}/ tests/

test: ## Run tests
	${VENV_DIR}/bin/pytest --verbose tests/

black: ## Run the black formatter
	${VENV_DIR}/bin/black ${PACKAGE}/ tests/ -l ${LINE_LENGTH}

pc-install: ## Setup pre-commit
	${VENV_DIR}/bin/pre-commit install

package: ## Update the project package name such as `make package name=new_package_name`
	@echo -n ${name} > .package-name && mv ${PACKAGE}/ ${name}/

isort: ## run isort
	${VENV_DIR}/bin/isort ${PACKAGE}/ tests/


clean: ## clean up venv and cache
	find . -type f -name "*pyc" | xargs rm -rf
	find . -type d -name __pycache__ | xargs rm -rf
	find . -type d -name ${VENV_DIR} | xargs rm -rf

install: ## setup dev environment
	venv pip-dev pc-install

cicd: ## run cicd suite
	venv pip-dev typehint pylint radon

checklist: ## run dev checklist
	black autoflake isort pylint radon typehint test