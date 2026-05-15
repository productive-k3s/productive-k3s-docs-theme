PYTHON ?= python3
VENV_DIR ?= .venv
VALIDATION_SITE_CONFIG ?= validation-site/mkdocs.yml

.PHONY: validate check-tree validation-site-build clean tag push-tag release

validate: check-tree validation-site-build

check-tree:
	test -f material-overrides/main.html
	test -f material-overrides/partials/header.html
	test -f material-overrides/partials/footer.html
	test -f material-overrides/partials/logo.html
	test -f material-overrides/partials/toc.html
	test -f material-overrides/assets/stylesheets/extra.css
	test -f material-overrides/assets/images/argentina.png
	test -f material-overrides/assets/images/productive-k3s-icon-square-0.3x.png
	test -f material-overrides/assets/images/favicon.ico
	test -f $(VALIDATION_SITE_CONFIG)

validation-site-build:
	$(PYTHON) -m venv $(VENV_DIR)
	. $(VENV_DIR)/bin/activate && python -m pip install --upgrade pip && python -m pip install -r requirements.txt && mkdocs build --config-file $(VALIDATION_SITE_CONFIG) --strict

clean:
	rm -rf $(VENV_DIR) validation-site/site

tag:
	test -n "$(VERSION)"
	git diff --quiet
	git diff --cached --quiet
	git tag -a "$(VERSION)" -m "Release $(VERSION)"

push-tag:
	test -n "$(VERSION)"
	git push origin "$(VERSION)"

release: validate tag push-tag
