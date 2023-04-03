!/bin/bash
BRANCH=$(git symbolic-ref --short HEAD)
if [ "$BRANCH" != "main" ]; then
  echo "Error: This script should only be run on the main branch."
  exit 1
fi

# Extract the version from package.json
VERSION=$(jq -r '.version' package.json)

if git rev-parse $VERSION >/dev/null 2>&1; then
  echo "Error: Git tag $VERSION already exists, and therefore likely exists on npm also. Are you sure $VERSION is the correct version?"
  exit 1
fi

# Create a new git tag
git tag $VERSION

# Push the new tag to remote
echo "Created git tag $VERSION."
echo "To push the tag to remote, run the following command:"
echo "git push origin $VERSION"
