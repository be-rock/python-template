MODULE := $(shell cat .package-name)
LINE_LENGTH := 90
VENV_DIR := .venv

#----------------------------------------------------------

.PHONY: check
check : test black venv pip

.PHONY: venv
venv :
	@echo -e '------------'
	@echo -e 'creating virtual environment...'
	@echo -e '------------'
	@python3 -m venv ${VENV_DIR}

.PHONY: pip
pip:
	@echo -e '------------'
	@echo -e 'pip installing packages...'
	@echo -e '------------\n'
	@$(VENV_DIR)/bin/pip install --requirement dev-requirements.txt

.PHONY: test
test :
	@echo
	@echo -e '------------'
	@echo -e 'running tests...'
	@echo -e '------------\n'
	@python -m pytest tests/

.PHONY: black
black :
	@echo -e '------------'
	@echo -e 'running black...'
	@echo -e '------------\n'
	@black $(MODULE) -l $(LINE_LENGTH)

.PHONY: update-package
# run as: make update-package package=new_package_name
update-package :
	@echo -e '------------'
	@echo -e 'updating package...'
	@echo -e '------------\n'
	@echo -n $(package) > .package-name && mv python_template/ $(package)/