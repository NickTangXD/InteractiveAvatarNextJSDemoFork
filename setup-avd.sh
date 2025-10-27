#!/bin/bash

################################################################################
# HeyGen Santa - Android AVD Setup Script
# 
# This script automatically configures Android Virtual Devices (AVDs) with
# the correct DPI settings for 75-inch vertical displays.
#
# Usage:
#   ./setup-avd.sh [avd-name]
#
# If no AVD name is provided, it will list all available AVDs.
################################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
TARGET_DPI=320
AVD_DIR="$HOME/.android/avd"

echo ""
echo "=========================================="
echo "  HeyGen Santa - AVD DPI Configuration"
echo "=========================================="
echo ""

# Check if AVD directory exists
if [ ! -d "$AVD_DIR" ]; then
    echo -e "${RED}❌ Error: AVD directory not found at $AVD_DIR${NC}"
    echo "   Please create an AVD in Android Studio first."
    exit 1
fi

# Function to list all AVDs
list_avds() {
    echo -e "${BLUE}Available AVDs:${NC}"
    echo ""
    local count=0
    for avd_config in "$AVD_DIR"/*.ini; do
        if [ -f "$avd_config" ]; then
            avd_name=$(basename "$avd_config" .ini)
            avd_path="$AVD_DIR/$avd_name.avd"
            if [ -d "$avd_path" ]; then
                count=$((count + 1))
                current_dpi=$(grep "hw.lcd.density" "$avd_path/config.ini" 2>/dev/null | cut -d'=' -f2)
                echo -e "  ${count}. ${GREEN}${avd_name}${NC} (current DPI: ${current_dpi:-unknown})"
            fi
        fi
    done
    
    if [ $count -eq 0 ]; then
        echo -e "${YELLOW}  No AVDs found.${NC}"
        echo "  Please create one in Android Studio first."
    fi
    echo ""
}

# Function to configure AVD
configure_avd() {
    local avd_name=$1
    local avd_path="$AVD_DIR/${avd_name}.avd"
    local config_file="$avd_path/config.ini"
    
    echo -e "${BLUE}📱 Configuring AVD: ${GREEN}${avd_name}${NC}"
    echo ""
    
    # Check if AVD exists
    if [ ! -d "$avd_path" ]; then
        echo -e "${RED}❌ Error: AVD '${avd_name}' not found${NC}"
        echo ""
        list_avds
        exit 1
    fi
    
    # Check if config file exists
    if [ ! -f "$config_file" ]; then
        echo -e "${RED}❌ Error: Config file not found for AVD '${avd_name}'${NC}"
        exit 1
    fi
    
    # Get current DPI
    current_dpi=$(grep "hw.lcd.density" "$config_file" | cut -d'=' -f2)
    echo -e "Current DPI: ${YELLOW}${current_dpi}${NC}"
    echo -e "Target DPI:  ${GREEN}${TARGET_DPI}${NC}"
    echo ""
    
    if [ "$current_dpi" = "$TARGET_DPI" ]; then
        echo -e "${GREEN}✅ DPI is already set to ${TARGET_DPI}${NC}"
        echo ""
        echo "Checking for other optimizations..."
    else
        # Backup config file
        echo "📦 Creating backup..."
        cp "$config_file" "$config_file.backup.$(date +%Y%m%d_%H%M%S)"
        
        # Update DPI
        echo "🔧 Updating DPI to ${TARGET_DPI}..."
        sed -i '' "s/hw.lcd.density=.*/hw.lcd.density=${TARGET_DPI}/" "$config_file"
        echo -e "${GREEN}✅ DPI updated successfully${NC}"
    fi
    
    echo ""
    echo "🧹 Cleaning up snapshots and cache..."
    
    # Remove snapshots (they cache old DPI settings)
    if [ -d "$avd_path/snapshots" ]; then
        rm -rf "$avd_path/snapshots/"*
        echo -e "${GREEN}✅ Snapshots cleared${NC}"
    fi
    
    # Configure cold boot (ensures fresh start)
    echo ""
    echo "⚙️  Configuring boot settings..."
    
    # Remove existing boot settings
    sed -i '' '/fastboot.chosenSnapshotFile/d' "$config_file"
    sed -i '' '/fastboot.forceChosenSnapshotBoot/d' "$config_file"
    sed -i '' '/fastboot.forceColdBoot/d' "$config_file"
    
    # Add new boot settings
    cat >> "$config_file" << EOF
fastboot.chosenSnapshotFile=
fastboot.forceChosenSnapshotBoot=no
fastboot.forceColdBoot=yes
EOF
    
    echo -e "${GREEN}✅ Boot settings configured for cold start${NC}"
    
    # Display device info
    echo ""
    echo "📊 Device Configuration:"
    echo "   Resolution: $(grep "hw.lcd.width" "$config_file" | cut -d'=' -f2) x $(grep "hw.lcd.height" "$config_file" | cut -d'=' -f2)"
    echo "   DPI: ${TARGET_DPI}"
    echo "   RAM: $(grep "hw.ramSize" "$config_file" | cut -d'=' -f2) MB"
    
    echo ""
    echo "=========================================="
    echo -e "${GREEN}✅ Configuration Complete!${NC}"
    echo "=========================================="
    echo ""
    echo "Next steps:"
    echo "  1. Close Android Studio if it's running"
    echo "  2. Reopen Android Studio"
    echo "  3. Launch the AVD from Device Manager"
    echo "  4. If DPI still looks wrong, run: ./reset-avd-dpi.sh ${avd_name}"
    echo ""
}

# Function to reset DPI override in running emulator
reset_runtime_dpi() {
    local adb_path="$HOME/Library/Android/sdk/platform-tools/adb"
    
    if [ ! -f "$adb_path" ]; then
        echo -e "${YELLOW}⚠️  Warning: adb not found at $adb_path${NC}"
        return
    fi
    
    # Check if emulator is running
    local devices=$("$adb_path" devices | grep "emulator" | wc -l)
    
    if [ $devices -gt 0 ]; then
        echo ""
        echo "🔄 Resetting DPI override on running emulator..."
        "$adb_path" shell wm density reset 2>/dev/null
        echo -e "${GREEN}✅ Runtime DPI reset${NC}"
        echo "   The display should update immediately."
    fi
}

# Main script logic
main() {
    if [ $# -eq 0 ]; then
        echo "Usage: $0 <avd-name>"
        echo ""
        list_avds
        echo "Example: $0 4k_vertical_tv"
        echo ""
        exit 0
    fi
    
    local avd_name=$1
    
    # Check if Android Studio is running
    if pgrep -f "Android Studio" > /dev/null; then
        echo -e "${YELLOW}⚠️  Warning: Android Studio is currently running${NC}"
        echo "For best results, please close Android Studio first."
        echo ""
        read -p "Continue anyway? (y/N) " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Aborted."
            exit 0
        fi
    fi
    
    configure_avd "$avd_name"
    reset_runtime_dpi
}

# Run main function
main "$@"

