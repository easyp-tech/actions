# EasyP GitHub Actions

Official GitHub Actions for [EasyP](https://github.com/easyp-tech/easyp) — a linter and toolkit for Protocol Buffers.

## Available Actions

| Action | Description |
|--------|-------------|
| [lint](./lint) | Run EasyP linter on protobuf files |
| [breaking](./breaking) | Detect breaking changes in protobuf files |

## Quick Start

### Linting

```yaml
name: easyp-lint
on: [push, pull_request]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: easyp-tech/actions/lint@v1
        with:
          version: v0.12.2
```

### Breaking Change Detection

```yaml
name: easyp-breaking
on: [pull_request]

jobs:
  breaking:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - uses: easyp-tech/actions/breaking@v1
        with:
          version: v0.12.2
          against: origin/main
```

### Combined Workflow

```yaml
name: easyp
on:
  push:
    branches: [main, master]
  pull_request:

permissions:
  contents: read

jobs:
  lint:
    name: Lint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: easyp-tech/actions/lint@v1
        with:
          version: v0.12.2

  breaking:
    name: Breaking Changes
    runs-on: ubuntu-latest
    if: github.event_name == 'pull_request'
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - uses: easyp-tech/actions/breaking@v1
        with:
          version: v0.12.2
          against: origin/main
```

## Documentation

- [Lint Action](./lint/README.md) — detailed documentation for linting
- [Breaking Action](./breaking/README.md) — detailed documentation for breaking change detection
- [EasyP Documentation](https://github.com/easyp-tech/easyp) — main EasyP repository

## Features

- 🚀 **Fast** — uses pre-built Docker images, no compilation needed
- 📝 **GitHub Annotations** — errors appear directly on PR lines
- 🔧 **Configurable** — supports custom config files
- 🏷️ **Version Pinning** — pin to specific EasyP versions

## Requirements

- GitHub-hosted runners (Linux)
- Docker support

## License

MIT
