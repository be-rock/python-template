MODULE := $(shell cat .package-name)
LINE_LENGTH := 80
VENV_DIR := .venv

.PHONY: venv
venv :
	python -m venv ${VENV_DIR}

.PHONY: pip
pip:
	$(VENV_DIR)/bin/pip install --requirement dev-requirements.txt

.PHONY: typehint
typehint:
	$(VENV_DIR)/bin/mypy --ignore-missing-imports ${MODULE}

.PHONY: test
test :
	$(VENV_DIR)/bin/pytest tests/

.PHONY: black
black :
	$(VENV_DIR)/bin/black $(MODULE) -l $(LINE_LENGTH)

.PHONY: pc-install
pc-install:
	${VENV_DIR}/bin/pre-commit install


.PHONY: package
# purpose: update the parent project package name
# run as: make package name=new_package_name
package:
	@echo -n $(name) > .package-name && mv python_template/ $(name)/

.PHONY: clean
clean:
	find . -type f -name "*pyc" | xargs rm -rf
	find . -type d -name __pycache__ | xargs rm -rf
	find . -type d -name ${VENV_DIR} | xargs rm -rf

.PHONY: install
install: venv pip pc-install

.PHONY: checklist
checklist: black test