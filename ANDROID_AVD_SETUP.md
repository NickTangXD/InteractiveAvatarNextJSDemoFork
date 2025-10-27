# Android AVD Setup Guide

## Problem

When creating a 75-inch Android Virtual Device (AVD) for this project, the default DPI settings make everything (fonts, icons, UI elements) appear extremely small, even after adjusting system settings to maximum.

## Solution

We've created automated scripts to configure AVDs with the correct DPI settings (320 dpi) for 75-inch displays.

## Quick Start

### For New Team Members

1. **Install Android Studio and SDK** (if not already installed)
   - Download from: https://developer.android.com/studio
   - Follow the installation wizard

2. **Create an AVD** (one-time setup):

   ```bash
   # Open Android Studio
   npm run android:open

   # In Android Studio:
   # - Click Device Manager (phone icon)
   # - Click "Create Device"
   # - Select device or create custom 75" profile
   # - Choose system image (API 33 recommended)
   # - Finish creation
   ```

3. **Configure the AVD** (automated):

   ```bash
   # List available AVDs
   ./setup-avd.sh

   # Configure your AVD (replace with actual name)
   ./setup-avd.sh 4k_vertical_tv
   ```

4. **Launch the emulator** from Android Studio Device Manager

That's it! The display should now show properly sized text and icons.

## Scripts Overview

### `setup-avd.sh` - Main Configuration Script

Automatically configures an AVD with optimal settings for 75-inch displays.

**What it does:**

- ✅ Sets DPI to 320 (optimal for 75-inch 4K displays)
- ✅ Clears cached snapshots (they store old settings)
- ✅ Configures cold boot (ensures fresh start)
- ✅ Creates backup of original settings
- ✅ Displays configuration summary

**Usage:**

```bash
# List all AVDs
./setup-avd.sh

# Configure specific AVD
./setup-avd.sh <avd-name>

# Example
./setup-avd.sh 4k_vertical_tv
```

**When to use:**

- After creating a new AVD
- When display looks too small
- When sharing AVD configuration with team

### `reset-avd-dpi.sh` - Runtime DPI Reset

Resets DPI override on a running emulator (instant fix without restart).

**What it does:**

- ✅ Connects to running emulator
- ✅ Resets any DPI overrides
- ✅ Shows current DPI settings
- ✅ Takes effect immediately

**Usage:**

```bash
# Make sure emulator is running first
./reset-avd-dpi.sh
```

**When to use:**

- Emulator is already running but display looks wrong
- After adjusting "Display size" in Android settings
- Quick fix without restarting emulator

## Detailed Workflow

### Scenario 1: Setting Up a New AVD

```bash
# Step 1: Create AVD in Android Studio
npm run android:open
# Use Device Manager to create AVD

# Step 2: Configure DPI
./setup-avd.sh my_avd_name

# Step 3: Close Android Studio (important!)
# Press Cmd+Q

# Step 4: Reopen and launch
npm run android:open
# Launch AVD from Device Manager
```

### Scenario 2: Display Looks Wrong on Running Emulator

```bash
# Quick fix (no restart needed)
./reset-avd-dpi.sh
```

### Scenario 3: Sharing AVD Configuration

```bash
# Configure AVD on your machine
./setup-avd.sh my_avd_name

# Commit AVD configuration (optional)
# AVDs are stored in ~/.android/avd/
# Team members can use the same script to configure their AVDs
```

## Recommended AVD Configurations

### Option 1: Full HD Portrait (Recommended for Development)

**Best for:** Daily development, fast iteration

```
Device Name: 75" School Display (Portrait)
Screen size: 75.0 inches
Resolution: 1080 x 1920 (portrait)
Density: 280 dpi (will be set to 320 by script)
RAM: 4096 MB
API Level: 33 (Android 13)
```

**Why:**

- Fast and responsive
- Low resource usage
- Good enough for UI testing
- Quick startup time

### Option 2: 4K Portrait (For Final Testing)

**Best for:** Final validation, demo preparation

```
Device Name: 75" School Display 4K
Screen size: 75.0 inches
Resolution: 2160 x 3840 (portrait)
Density: 160 dpi (will be set to 320 by script)
RAM: 6144 MB (6GB)
API Level: 33 (Android 13)
```

**Why:**

- Closest to actual device
- Best video quality
- True 4K rendering

**Note:** Requires powerful computer (16GB+ RAM recommended)

## Troubleshooting

### Issue: "AVD not found"

**Solution:**

```bash
# List all AVDs to see exact names
./setup-avd.sh

# Use exact name (case-sensitive)
./setup-avd.sh "Pixel_5_API_33"
```

### Issue: "adb not found"

**Solution:**

```bash
# Add adb to PATH
echo 'export PATH="$HOME/Library/Android/sdk/platform-tools:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

Or use full path:

```bash
~/Library/Android/sdk/platform-tools/adb devices
```

### Issue: Display still looks wrong after configuration

**Try these steps:**

1. **Make sure Android Studio is closed:**

   ```bash
   # Close completely with Cmd+Q
   # Then run script again
   ./setup-avd.sh your_avd_name
   ```

2. **Reset runtime DPI:**

   ```bash
   # Launch emulator first
   ./reset-avd-dpi.sh
   ```

3. **Check actual DPI:**

   ```bash
   ~/Library/Android/sdk/platform-tools/adb shell wm density
   # Should show: Physical density: 320
   ```

4. **Delete and recreate AVD:**
   - Sometimes easier to start fresh
   - Use Device Manager to delete
   - Create new AVD with correct settings
   - Run setup script

### Issue: Emulator is very slow

**Solutions:**

1. **Use smaller resolution:**
   - Create Full HD (1080x1920) instead of 4K
   - Much faster with similar testing value

2. **Allocate more RAM:**
   - Edit AVD in Device Manager
   - Increase RAM to 6GB+
   - Increase VM Heap to 768MB

3. **Enable hardware acceleration:**
   - Use x86_64 system images (not ARM)
   - Enable Graphics: Hardware - GLES 2.0

4. **Close other applications:**
   - Emulator needs significant resources
   - Close Chrome, IDE, etc. during testing

## DPI Reference Table

| Screen Size     | Resolution    | Recommended DPI | Use Case              |
| --------------- | ------------- | --------------- | --------------------- |
| 5-6" Phone      | 1080x1920     | 420-480         | Mobile apps           |
| 10" Tablet      | 1200x1920     | 240             | Tablet apps           |
| 32" Display     | 1080x1920     | 200-240         | Desktop apps          |
| 55" TV          | 1080x1920     | 240-280         | TV apps               |
| **75" Display** | **1080x1920** | **280-320**     | **Large displays**    |
| **75" 4K**      | **2160x3840** | **320**         | **High-end displays** |

## npm Scripts

We've added convenient npm scripts for Android development:

```bash
# Check environment configuration
npm run check-env

# Build and sync to Android
npm run android:build

# Open Android Studio
npm run android:open

# Build and run on device
npm run android:run

# Sync web assets only
npm run android:sync
```

## Best Practices

### For Team Members

1. **Always use the setup script** for AVD configuration
2. **Don't manually edit AVD settings** in Android Studio (it may revert)
3. **Document your AVD name** in team wiki/README
4. **Share scripts** with new team members

### For Project Leads

1. **Create a standard AVD configuration** and document it
2. **Add AVD setup to onboarding** checklist
3. **Keep scripts in version control**
4. **Update scripts** as requirements change

## Technical Details

### Why DPI Matters

DPI (Dots Per Inch) determines how Android renders UI elements:

- **Too Low** (120 dpi): Everything appears tiny
- **Too High** (560 dpi): Everything appears huge
- **Correct** (320 dpi for 75"): Perfect balance

### What the Script Modifies

The script modifies these files:

```
~/.android/avd/<avd-name>.avd/config.ini
~/.android/avd/<avd-name>.avd/snapshots/
```

Specifically:

- `hw.lcd.density=320` - Sets physical DPI
- `fastboot.forceColdBoot=yes` - Ensures fresh start
- Deletes snapshot cache

### Why Snapshots Must Be Cleared

Android Emulator snapshots cache:

- Screen configuration
- DPI settings
- System state

If not cleared, emulator loads old settings from snapshot, ignoring config file changes.

## FAQ

**Q: Do I need to run the script every time?**
A: No, only once per AVD. The settings persist.

**Q: Can I use the same AVD for different projects?**
A: Yes, but be careful with app data. Consider creating project-specific AVDs.

**Q: What if I accidentally mess up the configuration?**
A: The script creates backups. Look for `config.ini.backup.*` files.

**Q: Do these scripts work on Windows/Linux?**
A: Currently Mac-only. Windows/Linux versions coming soon. (Paths differ)

**Q: Can I change the DPI to something other than 320?**
A: Yes, edit `TARGET_DPI=320` in `setup-avd.sh` to your preferred value.

**Q: How do I test on a real 75-inch device?**
A: Use USB debugging or WiFi ADB. Run `npm run android:run` with device connected.

## Support

If you encounter issues:

1. Check this documentation
2. Run `npm run check-env` to verify setup
3. Check Android Studio logs (bottom panel)
4. Try deleting and recreating AVD
5. Ask team lead for help

## Additional Resources

- [Android Studio Documentation](https://developer.android.com/studio)
- [Android Emulator Guide](https://developer.android.com/studio/run/emulator)
- [Managing AVDs](https://developer.android.com/studio/run/managing-avds)
- [Capacitor Android Guide](https://capacitorjs.com/docs/android)

---

**Script Version:** 1.0  
**Last Updated:** October 2025  
**Maintained by:** Development Team
