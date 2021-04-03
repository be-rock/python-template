MODULE := $(shell cat .package-name)
LINE_LENGTH := 90
NO_COLOR := \e[39m
BLUE := \e[34m
GREEN := \e[32m
VENV_DIR := ./.venv/app

#----------------------------------------------------------

.PHONY: check
check : unit-tests black-format success venv pip-install

.PHONY: venv
venv :
	@echo
	@echo -e '$(BLUE)creating virtual environment...'
	@python3 -m venv ${VENV_DIR}

.PHONY: pip-install
pip-install :
	@echo
	@echo -e '$(BLUE)pip installing packages...'
	@/bin/pip install --requirement dev-requirements.txt

.PHONY: unit-tests
unit-tests :
	@echo
	@echo -e '$(BLUE)unit-tests'
	@echo -e        '----------$(NO_COLOR)'
	@python3 -m pytest tests/

.PHONY: type-check
type-check :
	@echo
	@echo -e '$(BLUE)type-check'
	@echo -e 		'----------$(NO_COLOR)'
	@mypy ./*/*.py

.PHONY: black-format
black-format :
	@echo
	@echo -e '$(BLUE)black-format'
	@echo -e 		'------------$(NO_COLOR)'
	@black $(MODULE) -l $(LINE_LENGTH)

.PHONY: success
success :
	@echo
	@echo -e '$(GREEN)ALL CHECKS COMPLETED SUCCESSFULLY$(NO_COLOR)'
