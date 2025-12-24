NAMESPACE := trivy
RELEASE_NAME := trivy-operator-dashboard
CHART_PATH := ./helm/trivy-operator-dashboard
VALUES_FILE := $(CHART_PATH)/values.yaml

.PHONY: help install upgrade uninstall template dry-run

help:
	@echo "Available targets:"
	@echo "  install    - Install the chart to namespace $(NAMESPACE)"
	@echo "  upgrade    - Upgrade the release in namespace $(NAMESPACE)"
	@echo "  uninstall  - Uninstall the release from namespace $(NAMESPACE)"
	@echo "  template   - Render chart templates locally"
	@echo "  dry-run    - Simulate an install"

install:
	helm install $(RELEASE_NAME) $(CHART_PATH) -n $(NAMESPACE) -f $(VALUES_FILE)

upgrade:
	helm upgrade $(RELEASE_NAME) $(CHART_PATH) -n $(NAMESPACE) -f $(VALUES_FILE)

uninstall:
	helm uninstall $(RELEASE_NAME) -n $(NAMESPACE)

template:
	helm template $(RELEASE_NAME) $(CHART_PATH) -n $(NAMESPACE) -f $(VALUES_FILE)

dry-run:
	helm install $(RELEASE_NAME) $(CHART_PATH) -n $(NAMESPACE) -f $(VALUES_FILE) --dry-run
