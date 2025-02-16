#!/bin/bash

# Check if we should force the build
FORCE=${1:-false}

echo "Checking for new version of Ungoogled Chromium..."
echo "Force build: $FORCE"

# Fetch latest release from original repo
LATEST_VERSION=$(curl -s https://api.github.com/repos/ungoogled-software/ungoogled-chromium/releases/latest | jq -r .tag_name)
echo "Latest version found: $LATEST_VERSION"

# Check if we already have this version
LOCAL_VERSION=$(curl -s https://api.github.com/repos/siliconuy/ungoogled-chromium/releases/latest | jq -r .tag_name || echo "none")
echo "Local version found: $LOCAL_VERSION"

if [ "$FORCE" = "true" ] || [ "$LATEST_VERSION" != "$LOCAL_VERSION" ]; then
    echo "Build required: Force=$FORCE or new version detected"
    echo "new_version=true" >> $GITHUB_OUTPUT
    echo "version=$LATEST_VERSION" >> $GITHUB_OUTPUT
else
    echo "No build required: Version is current and no force flag"
    echo "new_version=false" >> $GITHUB_OUTPUT
fi 