.PHONY: generate lint breaking tag-dev tag-prod push

# Generate Go code from proto files
generate:
	@echo "Generating Go code from proto files..."
	@buf generate

# Lint proto files
lint:
	@echo "Linting proto files..."
	@buf lint

# Check for breaking changes against main branch
breaking:
	@echo "Checking for breaking changes..."
	@buf breaking --against '.git#branch=main'

# Tag development version with timestamp
tag-dev:
	@VERSION=$$(git describe --tags --abbrev=0 --match="v[0-9]*.[0-9]*.[0-9]" 2>/dev/null || echo "v0.1.0"); \
	TIMESTAMP=$$(date +%Y%m%d%H%M%S); \
	TAG="$${VERSION}-dev.$${TIMESTAMP}"; \
	echo "Creating development tag: $${TAG}"; \
	git tag -a "$${TAG}" -m "Development release $${TIMESTAMP}"; \
	git push origin "$${TAG}"; \
	echo "✅ Tagged: $${TAG}"

# Tag production version (requires VERSION parameter)
# Usage: make tag-prod VERSION=v1.2.3
tag-prod:
	@if [ -z "$(VERSION)" ]; then \
		echo "❌ Error: VERSION parameter required"; \
		echo "Usage: make tag-prod VERSION=v1.2.3"; \
		exit 1; \
	fi; \
	echo "Creating production tag: $(VERSION)"; \
	git tag -a "$(VERSION)" -m "Production release $(VERSION)"; \
	git push origin "$(VERSION)"; \
	echo "✅ Tagged: $(VERSION)"

# Push all commits and tags
push:
	@echo "Pushing commits and tags..."
	@git push origin main --tags
	@echo "✅ Pushed to origin"

# Show changes since last production tag
changes:
	@LAST_TAG=$$(git describe --tags --abbrev=0 --match="v[0-9]*.[0-9]*.[0-9]*" 2>/dev/null || echo "v0.1.0"); \
	echo "Changes since last production tag ($${LAST_TAG}):"; \
	echo ""; \
	git log $${LAST_TAG}..HEAD --oneline --decorate

# List all production tags
list-tags:
	@echo "Production tags:"; \
	git tag -l "v[0-9]*.[0-9]*.[0-9]*" --sort=-version:refname | head -10
