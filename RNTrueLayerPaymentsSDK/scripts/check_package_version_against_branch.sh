#!/bin/bash
set -e

# Extract the version from package.json
PACKAGE_VERSION=$(jq -r '.version' RNTrueLayerPaymentsSDK/package.json)
# Extract the version from the branch name
BRANCH_VERSION=$(echo $CIRCLE_BRANCH | sed 's/^release\///')

# Compare the versions and exit with an error code if they don't match
if [ "$PACKAGE_VERSION" != "$BRANCH_VERSION" ]; then
  echo "Error: Version in package.json ($PACKAGE_VERSION) does not match the branch release version ($BRANCH_VERSION)"
  exit 1
else
  echo "Version in package.json matches the branch release version"
fi
