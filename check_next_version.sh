#!/bin/bash

set -euo pipefail

# determine/get next version and date
NEXT_VERSION=$1
CURRENT_DATE=$(date +%Y-%m-%d)

# fail if NEXT_VERSION not given
if [[ -z "$NEXT_VERSION" ]]; then
  echo "NEXT_VERSION not set. Must be given as first argument."
  exit 1
fi

# read set up version and date
NEXT_VERSION_NO_PREFIX=${NEXT_VERSION#v}
VERSION_PACKAGE_JSON=$(jq -r '.version' package.json)
read -r LATEST_CHANGELOG_VERSION LATEST_CHANGELOG_DATE <<< "$(grep -m1 '^## v' changelog.md | awk '{print $2, $3}')"

# check if version in package.json is valid
if [[ "$NEXT_VERSION_NO_PREFIX" != "$VERSION_PACKAGE_JSON" ]]; then
  echo "Invalid version in package.json"
  echo "correct version: $NEXT_VERSION_NO_PREFIX"
  echo "version in package.json: $VERSION_PACKAGE_JSON"
  exit 1
fi

# check if version in changelog.md is valid
if [[ "$LATEST_CHANGELOG_VERSION" != "$NEXT_VERSION" ]]; then
  echo "Invalid version in changelog.md"
  echo "correct version: $NEXT_VERSION"
  echo "version in changelog.md: $LATEST_CHANGELOG_VERSION"
  exit 1
fi

# check if date in changelog.md is valid
if [[ "$LATEST_CHANGELOG_DATE" != "$CURRENT_DATE" ]]; then
  echo "Invalid date in changelog.md"
  echo "correct date: $CURRENT_DATE"
  echo "date in changelog.md: $LATEST_CHANGELOG_DATE"
  exit 1
fi

echo "version setup is correct for next release $NEXT_VERSION"
