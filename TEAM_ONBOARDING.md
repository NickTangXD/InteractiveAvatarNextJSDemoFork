# Team Onboarding - HeyGen Santa Project

## Welcome! 🎅

This is a quick start guide to get you up and running with the HeyGen Santa Android project.

## Prerequisites

- Mac computer (scripts are Mac-specific)
- Basic command line knowledge
- Android Studio installed (we'll guide you)

## One-Time Setup (30-45 minutes)

### Step 1: Install Android Studio

1. Download from: https://developer.android.com/studio
2. Follow installation wizard
3. When prompted, install Android SDK (API 33 recommended)

### Step 2: Clone and Install

```bash
# Clone the repository
git clone <repository-url>
cd InteractiveAvatarNextJSDemo

# Install dependencies
npm install
```

### Step 3: Configure Environment

```bash
# Create .env file with API keys
cp .env.example .env

# Edit .env and add your HeyGen API key
# HEYGEN_API_KEY=your_key_here
```

**🔒 Security:** API key is server-side only and never exposed to client.

Get your API key from: https://app.heygen.com/settings?nav=Subscriptions%20%26%20API

### Step 4: Verify Setup

```bash
# This checks if everything is configured correctly
npm run check-env
```

Fix any errors before continuing.

### Step 5: Create Android Emulator (AVD)

```bash
# Open Android Studio
npm run android:open

# In Android Studio:
# 1. Click the phone icon (Device Manager)
# 2. Click "Create Device"
# 3. Select "Pixel 5" or "Pixel 6"
# 4. Click "Next"
# 5. Select "Tiramisu" (API 33) - click "Download" if needed
# 6. Click "Next", then "Finish"
# 7. Name it something memorable (e.g., "dev_emulator")
```

### Step 6: Configure AVD for 75" Display

**This is crucial** - without this, the display will be too small:

```bash
# List your AVDs
./setup-avd.sh

# Configure your AVD (use the name from above)
./setup-avd.sh dev_emulator

# Close Android Studio (Cmd+Q)
# Then reopen it
npm run android:open
```

## Daily Development Workflow

### Starting Development

```bash
# 1. Check environment (optional, good habit)
npm run check-env

# 2. Start web development server (for testing)
npm run dev
# Visit http://localhost:3000

# 3. Or build for Android
npm run android:build

# 4. Open Android Studio and launch emulator
npm run android:open
```

### Making Changes

```bash
# 1. Make code changes

# 2. Build and sync
npm run android:build

# 3. Run on emulator (it will rebuild and install)
# Click the green play button in Android Studio
```

### Testing

```bash
# Test web version first (faster)
npm run dev

# Test Android version
# Launch emulator and run from Android Studio
```

## Common Commands

```bash
# Development
npm run dev                  # Web development server
npm run build               # Build Next.js static export

# Android
npm run check-env           # Verify configuration
npm run android:build       # Build and sync to Android
npm run android:open        # Open Android Studio
npm run android:run         # Build and run on device

# AVD Configuration
./setup-avd.sh              # List AVDs
./setup-avd.sh <name>       # Configure specific AVD
./reset-avd-dpi.sh          # Fix display on running emulator
```

## Troubleshooting

### Display looks too small in emulator

```bash
# Fix it instantly (emulator must be running)
./reset-avd-dpi.sh

# Or reconfigure AVD
./setup-avd.sh your_avd_name
```

### "Environment check failed"

```bash
npm run check-env

# Read the errors and fix them
# Most common: missing HEYGEN_API_KEY in .env
```

### "adb not found"

```bash
# Add to PATH (one-time setup)
echo 'export PATH="$HOME/Library/Android/sdk/platform-tools:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Emulator is very slow

- Use Pixel 5 instead of 4K TV for daily development
- Allocate more RAM to emulator (edit in Device Manager)
- Close other applications
- Consider using a real Android device

### App crashes on launch

```bash
# 1. Check Logcat in Android Studio (bottom panel)
# 2. Verify .env configuration
# 3. Rebuild
npm run android:build
# 4. Reinstall app
```

## Important Notes

### For Developers

- **Always run `setup-avd.sh`** after creating a new AVD
- **Don't commit `.env`** - it contains secrets
- **Test on web first** - it's faster than Android
- **Use Logcat** for debugging Android issues

### For Code Reviews

- Verify code works on both web and Android
- Test on emulator before approving
- Check that no secrets are committed

### For Deployment

- Only the tech lead should build release APKs
- Release builds require signing keys
- See `ANDROID_BUILD.md` for details

## Project Structure

```
InteractiveAvatarNextJSDemo/
├── app/                    # Next.js app (main code)
├── components/            # React components
├── android/              # Android project (auto-generated)
├── out/                  # Build output
├── .env                  # Environment variables (DO NOT COMMIT)
├── setup-avd.sh         # AVD configuration script
├── reset-avd-dpi.sh     # Runtime DPI fix
└── README.md            # Main documentation
```

## Getting Help

1. **Read the docs:**
   - `ANDROID_AVD_SETUP.md` - AVD configuration
   - `ANDROID_BUILD.md` - Detailed build instructions
   - `快速开始.md` - Chinese quick start

2. **Check common issues:**
   - Run `npm run check-env`
   - Read error messages carefully
   - Check Logcat for Android errors

3. **Ask the team:**
   - Team lead
   - Other developers
   - Project documentation

## Resources

- [HeyGen Docs](https://docs.heygen.com/)
- [HeyGen SDK](https://github.com/HeyGen-Official/StreamingAvatarSDK)
- [Android Studio Guide](https://developer.android.com/studio)
- [Capacitor Docs](https://capacitorjs.com/docs)
- [Next.js Docs](https://nextjs.org/docs)

## Quick Reference Card

**First Time Setup:**

```bash
npm install
cp .env.example .env        # Then add API keys
npm run check-env
npm run android:open        # Create AVD
./setup-avd.sh <avd-name>
```

**Daily Development:**

```bash
npm run dev                 # Test in browser
npm run android:build       # Build for Android
npm run android:open        # Launch emulator
```

**Fix Display Issues:**

```bash
./reset-avd-dpi.sh         # Quick fix
./setup-avd.sh <avd-name>  # Full reconfigure
```

---

**Welcome to the team! Let's build something great! 🚀**

_Questions? Ask your team lead or check the documentation._
