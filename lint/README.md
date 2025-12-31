# easyp-lint-action

Official GitHub Action for [EasyP](https://github.com/easyp-tech/easyp) linter from its authors.

The action runs EasyP linter and reports issues from protobuf files.

## How to use

Add a `.github/workflows/easyp-lint.yml` file with the following contents:

<details>
<summary>Simple Example</summary>

```yaml
name: easyp-lint
on:
  push:
    branches:
      - main
      - master
  pull_request:

permissions:
  contents: read

jobs:
  lint:
    name: lint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: easyp-lint
        uses: easyp-tech/actions/lint@v1
        with:
          version: v0.12.0
```

</details>

<details>
<summary>With Config File</summary>

```yaml
name: easyp-lint
on:
  push:
    branches:
      - main
      - master
  pull_request:

permissions:
  contents: read

jobs:
  lint:
    name: lint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: easyp-lint
        uses: easyp-tech/actions/lint@v1
        with:
          version: v0.12.0
          config: easyp.yaml
```

</details>

<details>
<summary>Lint Specific Directory</summary>

```yaml
name: easyp-lint
on:
  push:
    branches:
      - main
      - master
  pull_request:

permissions:
  contents: read

jobs:
  lint:
    name: lint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: easyp-lint
        uses: easyp-tech/actions/lint@v1
        with:
          version: v0.12.0
          directory: proto
```

</details>

<details>
<summary>Multiple Directories (Matrix)</summary>

```yaml
name: easyp-lint
on:
  push:
    branches:
      - main
      - master
  pull_request:

permissions:
  contents: read

jobs:
  lint:
    name: lint
    runs-on: ubuntu-latest
    strategy:
      matrix:
        directory: [api/v1, api/v2, proto]
    steps:
      - uses: actions/checkout@v4
      - name: easyp-lint
        uses: easyp-tech/actions/lint@v1
        with:
          version: v0.12.0
          directory: ${{ matrix.directory }}
```

</details>

## Options

### `version`

(optional)

The version of EasyP to use (docker image tag).

The default value is `latest`.

```yaml
uses: easyp-tech/actions/lint@v1
with:
  version: v0.12.0
```

### `directory`

(optional)

Directory containing protobuf files to lint.

The default value is `.` (repository root).

```yaml
uses: easyp-tech/actions/lint@v1
with:
  directory: proto
```

### `config`

(optional)

Path to the EasyP configuration file.

```yaml
uses: easyp-tech/actions/lint@v1
with:
  config: easyp.yaml
```

## Annotations

The action parses EasyP output and creates GitHub annotations directly on the lines with issues.

Annotations will appear:
- In the "Files changed" tab of pull requests
- In the Actions workflow summary

## Performance

The action uses the official EasyP Docker image (`ghcr.io/easyp-tech/easyp`), which ensures:
- Fast startup (no compilation needed)
- Consistent results across runs
- Easy version management

## License

MIT