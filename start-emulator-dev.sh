#!/bin/bash

# HeyGen Santa - Emulator Development Setup Script
# This script sets up port forwarding and starts the dev server

set -e

echo "🚀 Starting HeyGen Santa development environment for Android Emulator"
echo ""

# Find adb
ADB_PATH=""
if command -v adb &> /dev/null; then
    ADB_PATH="adb"
elif [ -f "$HOME/Library/Android/sdk/platform-tools/adb" ]; then
    ADB_PATH="$HOME/Library/Android/sdk/platform-tools/adb"
else
    echo "❌ Error: adb not found"
    echo "Please install Android SDK platform-tools"
    exit 1
fi

echo "✅ Found adb at: $ADB_PATH"
echo ""

# Check if emulator is running
echo "Checking for running emulator..."
DEVICES=$($ADB_PATH devices | grep -v "List" | grep "device$" | wc -l)

if [ "$DEVICES" -eq 0 ]; then
    echo "⚠️  No emulator detected"
    echo "Please start your Android emulator first, then run this script again"
    exit 1
fi

echo "✅ Emulator is running"
echo ""

# Set up port forwarding
echo "Setting up port forwarding (emulator localhost:3000 → Mac localhost:3000)..."
$ADB_PATH reverse tcp:3000 tcp:3000

if [ $? -eq 0 ]; then
    echo "✅ Port forwarding active!"
else
    echo "❌ Failed to set up port forwarding"
    exit 1
fi

echo ""
echo "📝 Configuration:"
echo "   - Emulator can access your Mac's dev server at: http://localhost:3000"
echo "   - No need to worry about changing IP addresses!"
echo ""
echo "⚠️  Important: You need to run this script every time you restart the emulator"
echo ""
echo "✅ Setup complete! You can now:"
echo "   1. Make sure 'npm run dev' is running"
echo "   2. Launch your app in the emulator"
echo ""

