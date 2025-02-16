#!/bin/bash

# Fetch latest release from original repo
LATEST_VERSION=$(curl -s https://api.github.com/repos/ungoogled-software/ungoogled-chromium/releases/latest | jq -r .tag_name)

# Check if we already have this version
LOCAL_VERSION=$(curl -s https://api.github.com/repos/siliconuy/ungoogled-chromium/releases/latest | jq -r .tag_name || echo "none")

if [ "$LATEST_VERSION" != "$LOCAL_VERSION" ]; then
    echo "::set-output name=new_version::true"
    echo "::set-output name=version::$LATEST_VERSION"
else
    echo "::set-output name=new_version::false"
fi 