#!/bin/bash

################################################################################
# HeyGen Santa - Reset AVD DPI Override
# 
# This script resets the DPI override on a running Android emulator.
# Use this if the emulator is already running and the DPI looks incorrect.
#
# Usage:
#   ./reset-avd-dpi.sh
################################################################################

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo ""
echo "=========================================="
echo "  Reset AVD DPI Override"
echo "=========================================="
echo ""

# Find adb
ADB_PATH="$HOME/Library/Android/sdk/platform-tools/adb"

if [ ! -f "$ADB_PATH" ]; then
    echo -e "${RED}❌ Error: adb not found${NC}"
    echo "   Expected location: $ADB_PATH"
    echo ""
    echo "   Please ensure Android SDK is installed."
    exit 1
fi

# Check for running emulators
DEVICES=$("$ADB_PATH" devices | grep "emulator" | wc -l | tr -d ' ')

if [ "$DEVICES" -eq 0 ]; then
    echo -e "${YELLOW}⚠️  No running emulators found${NC}"
    echo ""
    echo "Please start an emulator first:"
    echo "  1. Open Android Studio"
    echo "  2. Open Device Manager"
    echo "  3. Click the play button next to your AVD"
    echo ""
    exit 0
fi

echo -e "${GREEN}Found $DEVICES running emulator(s)${NC}"
echo ""

# Check current DPI
echo "📊 Current DPI settings:"
"$ADB_PATH" shell wm density
echo ""

# Reset DPI override
echo "🔄 Resetting DPI override..."
"$ADB_PATH" shell wm density reset

echo ""
echo "📊 Updated DPI settings:"
"$ADB_PATH" shell wm density
echo ""

echo "=========================================="
echo -e "${GREEN}✅ DPI Override Reset Complete!${NC}"
echo "=========================================="
echo ""
echo "The display should update immediately."
echo "If not, try:"
echo "  1. Restart the emulator"
echo "  2. Run: ./setup-avd.sh <avd-name>"
echo ""

