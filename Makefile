PACKAGE := ${shell cat .package-name}
LINE_LENGTH := 80
VENV_DIR := .venv

.PHONY: venv
venv :
	python -m venv ${VENV_DIR}

.PHONY: pip-dev
pip-dev:
	${VENV_DIR}/bin/pip install --requirement dev-requirements.txt

.PHONY: pip-prd
pip-prd:
	${VENV_DIR}/bin/pip install --requirement requirements.txt

.PHONY: typehint
typehint:
	${VENV_DIR}/bin/mypy --ignore-missing-imports ${PACKAGE}

.PHONY: autoflake
autoflake:
	${VENV_DIR}/bin/autoflake --in-place --remove-unused-variables  --remove-all-unused-imports --recursive ${PACKAGE}/ tests/

.PHONY: pylint
pylint:
	${VENV_DIR}/bin/pylint ${PACKAGE}/

.PHONY: radon
radon:
	${VENV_DIR}/bin/radon cc -a -nc ${PACKAGE}/

.PHONY: test
test:
	${VENV_DIR}/bin/pytest --verbose tests/

.PHONY: black
black :
	${VENV_DIR}/bin/black ${PACKAGE} -l ${LINE_LENGTH}

.PHONY: pc-install
pc-install:
	${VENV_DIR}/bin/pre-commit install

.PHONY: package
# purpose: update the parent project package name
# run as: make package name=new_package_name
package:
	@echo -n ${name} > .package-name && mv ${PACKAGE}/ ${name}/

.PHONY: isort
isort:
	${VENV_DIR}/bin/isort ${PACKAGE}/ tests/


.PHONY: clean
clean:
	find . -type f -name "*pyc" | xargs rm -rf
	find . -type d -name __pycache__ | xargs rm -rf
	find . -type d -name ${VENV_DIR} | xargs rm -rf

.PHONY: install
install: venv pip-dev pc-install

.PHONY: cicd
cicd: venv pip-dev typehint pylint test

.PHONY: checklist
checklist: black autoflake isort pylint radon typehint test