# Re:Earth Proto

Centralized Protocol Buffer definitions for Re:Earth internal APIs.

## Structure

```
cms/v1/          - CMS service proto definitions
visualizer/v1/   - Visualizer service proto definitions
```

## Versioning

### Development
```
v0.1.0-dev.20250706143000
```
- Used for development/staging
- Timestamp-based
- Auto-tagged on push to develop branch

### Production
```
v1.2.3
```
- Semantic versioning
- Manual tagging for releases
- MAJOR.MINOR.PATCH

## Usage

### As Go Module

```bash
go get github.com/eukarya-inc/reearth-proto@v1.0.0
```

### Import in Go

```go
import (
    cmspb "github.com/eukarya-inc/reearth-proto/gen/go/cms/v1"
    vispb "github.com/eukarya-inc/reearth-proto/gen/go/visualizer/v1"
)
```

## Development

```bash
# Generate code
make generate

# Lint proto files
make lint

# Check for breaking changes
make breaking

# Tag development version
make tag-dev

# Tag production version
make tag-prod VERSION=v1.1.0
```

## How Proto Files are Synced

Proto files are automatically synced from the OSS repositories:
- **Source**: `reearth/reearth-cms` and `reearth/reearth-visualizer` (public GitHub repos)
- **Frequency**: Every 6 hours via scheduled workflow
- **Manual sync**: Can be triggered via GitHub Actions UI
- **Auto-tagging**: When changes are detected, a new dev tag is created automatically

## For Service Maintainers

When updating proto files in CMS or Visualizer:

1. Make changes in your service's proto file
2. Test locally: `make grpc && go test ./...`
3. Push to main branch in CMS or Visualizer
4. Wait for auto-sync (or trigger manually in reearth-proto GitHub Actions)
5. For production releases, create a tag: `make tag-prod VERSION=v1.0.0`
