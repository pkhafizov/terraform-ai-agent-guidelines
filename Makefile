.PHONY: init validate fmt-check lint security-scan terratest docs infracost

init:
	@./scripts/init.sh $(dir)

validate:
	@./scripts/validate.sh $(dir)

fmt-check:
	@./scripts/fmt-check.sh

lint:
	@./scripts/lint.sh

security-scan:
	@./scripts/security-scan.sh $(dir)

terratest:
	@./scripts/terratest.sh

docs:
	@./scripts/docs.sh $(dir)

infracost:
	@./scripts/infracost.sh $(dir)
