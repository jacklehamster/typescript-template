#!/bin/bash

bun run fix-package-name

# Read the package name from ./package.json
MAIN_PACKAGE_NAME=$(jq -r '.name' ./package.json)

if [ -z "$MAIN_PACKAGE_NAME" ] || [ "$MAIN_PACKAGE_NAME" == "null" ]; then
  echo "Error: Could not read 'name' from ./package.json"
  exit 1
fi

# Update the package name in ./docs/package.json
if [ -f "./docs/package.json" ]; then
  jq --arg name "$MAIN_PACKAGE_NAME" '.dependencies["'$MAIN_PACKAGE_NAME'"] = $name' ./docs/package.json > ./docs/package.tmp.json && mv ./docs/package.tmp.json ./docs/package.json
  echo "Updated package name in ./docs/package.json to '$MAIN_PACKAGE_NAME'"
else
  echo "Error: ./docs/package.json not found"
  exit 1
fi
