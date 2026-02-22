# node-check-version

Checks if node package version in package.json and changelog.md matches provided version. \
Also checks if date in changelog.md matches current date. \

Might be a little opinionated.

## Usage

Here's an example, using get-next-version to determine next release version. \
It fails if version or date does not match.
```yaml
on:
  push:
    branches:
      - 'main'

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Determine next version
        id: get_next_version
        uses: thenativeweb/get-next-version@2.7.1
        with:
          prefix: 'v'

      - name: Fail if no next release version
        if: steps.get_next_version.outputs.hasNextVersion != 'true'
        run: |
          echo "There is no next release version."
          exit 1

      - name: Check version setup
        uses: johanna-herrmann/node-check-version@v2
        with:
          next_version: ${{ steps.get_next_version.outputs.version }}
```

## Checks
This action checks the following:
* provided version (`next_version`) (see last line of example workflow above)
  matches version in package.json
  (without `v` prefix)
* provided version matches version in changelog.md (with `v` prefix)
* date in changelog.md matches current date (in format: YYYY-mm-dd)

Exits with exit code 1, if one of these checks fails.

### Example
* next_version: v10.1.3
* version in package.json: 10.1.3
* changelog.md looks like:
  ```md
  # Changelog
  
  ## v10.1.13 2026-01-13
  
  ...
  ```
* current date is: 2026-02-12

In this example the action will exit with exit code 1, printing:
```plain
Invalid date in changelog.md
correct date: 2026-02-12
date in changelog.md: 2026-01-13
```

## Caveats
* Version (`next_version`) should be provided with `v` prefix.
* It's highly recommended to use `get-next-version` action, to determine
  next version, by analyzing commit messages since last version tag. \
  At the moment of writing this (2026-02-22), `get-next-version`
  will state version `v1.0.0`, if:
  * current version is `0.*` and
  * at least one of the commits since last version tag contains exclamation mark
    (`feat!: ...` for example).

## License
This project is licensed under the [MIT License](./LICENSE.txt)
