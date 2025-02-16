#!/bin/bash

# Check if we should force the build
FORCE=${1:-false}

echo "Checking for new version of Ungoogled Chromium..."
echo "Force build: $FORCE"

# Fetch latest release from original repo
RESPONSE=$(curl -s https://api.github.com/repos/ungoogled-software/ungoogled-chromium/releases/latest)
if [ $? -ne 0 ]; then
    echo "Error: Failed to fetch latest version from API"
    exit 1
fi

LATEST_VERSION=$(echo "$RESPONSE" | jq -r '.tag_name')
if [ "$LATEST_VERSION" = "null" ] || [ -z "$LATEST_VERSION" ]; then
    echo "Error: Could not determine latest version"
    echo "API Response: $RESPONSE"
    exit 1
fi
echo "Latest version found: $LATEST_VERSION"

# Check if we already have this version
LOCAL_RESPONSE=$(curl -s https://api.github.com/repos/siliconuy/ungoogled-chromium/releases/latest)
LOCAL_VERSION=$(echo "$LOCAL_RESPONSE" | jq -r '.tag_name // "none"')
echo "Local version found: $LOCAL_VERSION"

if [ "$FORCE" = "true" ] || [ "$LATEST_VERSION" != "$LOCAL_VERSION" ]; then
    echo "Build required: Force=$FORCE or new version detected"
    echo "new_version=true" >> $GITHUB_OUTPUT
    echo "version=$LATEST_VERSION" >> $GITHUB_OUTPUT
else
    echo "No build required: Version is current and no force flag"
    echo "new_version=false" >> $GITHUB_OUTPUT
fi 