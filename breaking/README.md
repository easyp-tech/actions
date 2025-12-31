# easyp-breaking-action

Official GitHub Action for [EasyP](https://github.com/easyp-tech/easyp) breaking change detection from its authors.

The action runs EasyP breaking change detection on protobuf files against a specified Git reference.

## How to use

Add a `.github/workflows/easyp-breaking.yml` file with the following contents:

<details>
<summary>Simple Example</summary>

```yaml
name: easyp-breaking
on:
  pull_request:

permissions:
  contents: read

jobs:
  breaking:
    name: breaking
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - name: easyp-breaking
        uses: easyp-tech/actions/breaking@v1
        with:
          version: v0.12.0
          against: origin/main
```

</details>

<details>
<summary>Against Specific Branch</summary>

```yaml
name: easyp-breaking
on:
  pull_request:

permissions:
  contents: read

jobs:
  breaking:
    name: breaking
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - name: easyp-breaking
        uses: easyp-tech/actions/breaking@v1
        with:
          version: v0.12.0
          against: origin/develop
```

</details>

<details>
<summary>Against Tag</summary>

```yaml
name: easyp-breaking
on:
  pull_request:

permissions:
  contents: read

jobs:
  breaking:
    name: breaking
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - name: easyp-breaking
        uses: easyp-tech/actions/breaking@v1
        with:
          version: v0.12.0
          against: v1.0.0
```

</details>

<details>
<summary>With Config File</summary>

```yaml
name: easyp-breaking
on:
  pull_request:

permissions:
  contents: read

jobs:
  breaking:
    name: breaking
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - name: easyp-breaking
        uses: easyp-tech/actions/breaking@v1
        with:
          version: v0.12.0
          against: origin/main
          config: easyp.yaml
```

</details>

<details>
<summary>Check Specific Directory</summary>

```yaml
name: easyp-breaking
on:
  pull_request:

permissions:
  contents: read

jobs:
  breaking:
    name: breaking
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - name: easyp-breaking
        uses: easyp-tech/actions/breaking@v1
        with:
          version: v0.12.0
          against: origin/main
          directory: proto
```

</details>

> **Note:** The `fetch-depth: 0` option is required for `actions/checkout` to fetch the full Git history, which is necessary for comparing against other branches or tags.

## Options

### `version`

(optional)

The version of EasyP to use (docker image tag).

The default value is `latest`.

```yaml
uses: easyp-tech/actions/breaking@v1
with:
  version: v0.12.0
```

### `against`

(optional)

Git reference to compare against (branch, tag, or commit SHA).

The default value is `origin/main`.

```yaml
uses: easyp-tech/actions/breaking@v1
with:
  against: origin/main
```

Common values:
- `origin/main` — compare against main branch
- `origin/develop` — compare against develop branch
- `v1.0.0` — compare against a tag
- `abc1234` — compare against a specific commit

### `directory`

(optional)

Directory containing protobuf files to check.

The default value is `.` (repository root).

```yaml
uses: easyp-tech/actions/breaking@v1
with:
  directory: proto
```

### `config`

(optional)

Path to the EasyP configuration file.

```yaml
uses: easyp-tech/actions/breaking@v1
with:
  config: easyp.yaml
```

## Annotations

The action parses EasyP JSON output and creates GitHub annotations directly on the lines with breaking changes.

Annotations will appear:
- In the "Files changed" tab of pull requests
- In the Actions workflow summary

Example annotation:
```
::error file=api/llm/v1/llm.proto,line=46,col=1,title=BREAKING_CHECK::Field "4" with name "type" on message "Dialogue" changed type from "DialogueType" to "Agent".
```

## What is Breaking Change Detection?

Breaking change detection helps you ensure backward compatibility of your protobuf APIs. It detects changes like:

- Removing fields or messages
- Changing field numbers
- Changing field types
- Removing enum values
- Renaming packages
- And other changes that could break existing clients

## Performance

The action uses the official EasyP Docker image (`ghcr.io/easyp-tech/easyp`), which ensures:
- Fast startup (no compilation needed)
- Consistent results across runs
- Easy version management

## License

MIT