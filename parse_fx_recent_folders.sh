#!/bin/bash

# Script Name: Recent Folders Parser
# Description: This script parses the FXRecentFolders from the Finder preferences plist
#              and displays the file-bookmark for each entry.
# Author: Paul Goffar (@n3tl0kr)
# Date Created: 01.22.2025
# Last Modified: TBD
#
# Usage: ./parse_fx_recent_folders.sh
# Comments: last tested on macOS 15.2
# Dependencies: PlistBuddy

# Function to find the Finder plist path
find_plist_path() {
    local user_home
    user_home=$(eval echo ~$SUDO_USER)
    echo "$user_home/Library/Preferences/com.apple.finder.plist"
}

# Get the plist path
PLIST_PATH=$(find_plist_path)

# Verify the plist exists
if [[ ! -f "$PLIST_PATH" ]]; then
    echo "Plist file not found at: $PLIST_PATH"
    exit 1
fi

# Count the number of entries in FXRecentFolders
count=$(/usr/libexec/PlistBuddy -c "Print :FXRecentFolders" "$PLIST_PATH" 2>/dev/null | grep -c "Dict")

if [[ $count -eq 0 ]]; then
    echo "No recent folders found in FXRecentFolders."
    exit 0
fi

echo "Parsing $count bookmarks from FXRecentFolders:"
echo "-------------------------------------------"

# Loop through each entry and extract the file-bookmark
for ((i=0; i<count; i++)); do
    echo "Entry $i:"
    /usr/libexec/PlistBuddy -c "Print :FXRecentFolders:$i:file-bookmark" "$PLIST_PATH" || echo "No file-bookmark found for entry $i"
    echo "-------------------------------------------"
done

