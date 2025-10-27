# Android Studio Guide

## 🎯 Goal

Open the HeyGen Santa application in Android Studio and run it on an emulator.

## 📋 Prerequisites

Before starting, ensure:

```bash
# 1. Check environment configuration
npm run check-env

# 2. Build the Next.js app
npm run android:build
```

If `check-env` shows errors, fix them before continuing.

## 🚀 Detailed Steps

### Step 1: Open Android Studio Project

#### Method A: Using Command Line (Easiest)

```bash
cd /Volumes/Elements/InteractiveAvatarNextJSDemo
npm run android:open
```

This automatically opens Android Studio and loads the project.

#### Method B: Manual Opening

1. Launch **Android Studio**
2. Click **"Open"** on the welcome screen
3. Navigate to your project directory
4. Select the `/Volumes/Elements/InteractiveAvatarNextJSDemo/android` folder
5. Click the **"Open"** button

### Step 2: Wait for Gradle Sync to Complete

After opening the project, Android Studio will:

- Display a "Gradle Sync" progress bar
- Download necessary dependencies
- Build project indexes

**Important Notes:**

- ⏱️ First time may take **5-15 minutes** (depends on network speed)
- 🔴 Wait for bottom status bar to show **"Gradle sync finished"**
- ⚠️ If errors occur, usually clicking **"Try Again"** works

**Common Gradle Issues:**

- If Android SDK path issues appear, click **"Accept"** to install suggested SDK
- If network is slow, wait or use mirror sources

### Step 3: Create Android Emulator (AVD)

If you don't have an emulator yet, create one.

#### 3.1 Open Device Manager

1. In Android Studio top right, find the **phone icon** (Device Manager)
2. Click to open the **Device Manager** panel

Or through menu:

- `Tools` > `Device Manager`

#### 3.2 Create New Virtual Device

1. Click the **"Create Device"** button

2. **Select device type:**
   - Category: Choose **"Phone"** or **"Tablet"**
   - Recommended: **Pixel 5** or **Pixel 6** (good performance)
   - Click **"Next"**

3. **Select system image:**
   - Choose **API Level 24** or higher (latest recommended)
   - Recommended: **API 33** or **API 34** (Android 13/14)
   - If download needed, click **"Download"** link next to the image
   - After download completes, click **"Next"**

4. **Confirm configuration:**
   - Name the emulator (e.g., "Pixel 5 API 33")
   - Adjust RAM, storage settings if needed (defaults are fine)
   - Click **"Finish"**

#### 3.3 Special Settings for 75-inch Portrait Display (Optional)

If you want to simulate a 75-inch portrait device:

1. On device selection screen, click **"New Hardware Profile"**
2. Set parameters:
   - **Screen size**: 75 inches
   - **Resolution**: 1080 x 1920 (portrait) or higher
   - **Density**: 280-320 dpi (use setup script to configure)
3. Save and use this configuration to create AVD

**Note:** 75-inch emulators use significant resources. Recommended:

- Use regular phone emulator for feature testing first
- Verify on actual 75-inch device for final testing

### Step 4: Launch Emulator

#### 4.1 Start Emulator

In Device Manager:

1. Find your created emulator
2. Click the **▶️ play button** on the right
3. Wait for emulator to start (first start is slow, about 1-3 minutes)

After starting, you'll see the Android system interface.

#### 4.2 Verify Emulator Ready

- ✅ Emulator screen shows Android home screen
- ✅ You can see your emulator in the device dropdown in Android Studio toolbar

### Step 5: Run Application

#### 5.1 Select Device

1. In Android Studio toolbar
2. Find device selection dropdown (next to phone icon)
3. Confirm your emulator is selected (e.g., "Pixel 5 API 33")

#### 5.2 Run Application

Click the **green triangle ▶️ button** in toolbar (Run 'app')

Or:

- Shortcut: `Control + R` (Mac) or `Shift + F10` (Windows/Linux)
- Menu: `Run` > `Run 'app'`

#### 5.3 Wait for Build and Deploy

Android Studio will:

1. 📦 Compile application (first time takes several minutes)
2. 📲 Install APK to emulator
3. 🚀 Auto-launch application

**Progress Display:**

- Bottom **"Build"** tab shows build progress
- Bottom **"Run"** tab shows deployment logs

### Step 6: Test Application

After app launches, you should see:

1. **Initial screen:** HeyGen Avatar configuration interface
2. **Two buttons:**
   - "Start Voice Chat" - Start voice conversation
   - "Start Text Chat" - Start text conversation

#### Test Steps

1. **Click "Start Voice Chat"** or "Start Text Chat"
2. If permission requests appear (camera/microphone), click **"Allow"**
3. Wait for Avatar to load (video display appears)
4. Start conversing with the Avatar!

## 🐛 Common Issues and Solutions

### Issue 1: Gradle Sync Failed

**Error message:** `Gradle sync failed...`

**Solution:**

1. Check network connection
2. Click **"Try Again"**
3. If it persists:
   ```bash
   cd android
   ./gradlew clean
   ./gradlew build
   ```

### Issue 2: Android SDK Not Found

**Error message:** `Android SDK location not found`

**Solution:**

1. Open `Tools` > `SDK Manager`
2. Ensure Android SDK is installed (at least API 24)
3. Set SDK path: `File` > `Project Structure` > `SDK Location`

### Issue 3: Emulator Starts Slowly or Lags

**Cause:** Hardware acceleration not enabled

**Solution (Mac):**

1. Ensure Hypervisor Framework is enabled
2. Go to `Android Studio` > `Settings` > `Tools` > `Emulator`
3. Check **"Launch in a tool window"** and **"Use detected ADB"**

**Solution (Windows):**

- Enable Intel HAXM or AMD Hypervisor
- Enable virtualization in BIOS (VT-x or AMD-V)

### Issue 4: App Crashes or Cannot Connect

**Error:** App crashes immediately after launch

**Checklist:**

1. ✅ `HEYGEN_API_KEY` is configured in `.env` file (server-side only)
2. ✅ Ensure Next.js server is running (required for API routes)
3. ✅ Run `npm run android:build` to rebuild
4. ✅ Check Logcat for error messages

**View logs:**

1. At bottom of Android Studio, click **"Logcat"** tab
2. Set filter to **"Error"**
3. Run app and view error messages

### Issue 5: Camera/Microphone Not Working

**Cause:** Emulator doesn't have real camera/microphone by default

**Solution:**

1. In Device Manager, click emulator's **⚙️ settings icon**
2. Edit AVD
3. In **Camera** section:
   - **Front**: Select **"Webcam0"** (uses your computer camera)
   - **Back**: Select **"Webcam0"** or **"Emulated"**
4. Save and restart emulator

**Test voice features:**

- Speak into your computer microphone
- Emulator uses your computer's microphone

### Issue 6: App Cannot Access Network

**Error:** `Failed to get access token`

**Solution:**

1. Ensure emulator has network connection (usually auto-configured)
2. Check if firewall is blocking emulator
3. Try restarting emulator
4. Verify API Key is correct

## 🔍 Debugging Tips

### Using Logcat to View Logs

1. Click bottom **"Logcat"** tab
2. Enter **"heygen"** or **"santa"** in search box
3. View application log output
4. Filter levels:
   - **Verbose**: All logs
   - **Debug**: Debug information
   - **Info**: General information
   - **Warn**: Warnings
   - **Error**: Errors (recommended to check this)

### Using Chrome DevTools to Debug WebView

1. Ensure `capacitor.config.ts` has:

   ```typescript
   webContentsDebuggingEnabled: true;
   ```

2. In Chrome browser on your computer, visit:

   ```
   chrome://inspect
   ```

3. Under **"Remote Target"** find your application

4. Click **"inspect"** to open DevTools

5. Now you can:
   - View Console logs
   - Check network requests
   - Debug JavaScript
   - Inspect elements

### Rebuild and Sync

If you modified code, rebuild:

```bash
# 1. Build Next.js
npm run build

# 2. Sync to Android
npm run android:sync

# 3. Re-run in Android Studio
# Click green triangle button
```

## 📊 Performance Recommendations

### Emulator Performance Optimization

1. **Allocate More RAM:**
   - Device Manager > Edit AVD > Advanced Settings
   - Set RAM to 4GB or higher

2. **Enable Hardware Acceleration:**
   - Use x86_64 system images (not ARM)
   - Enable Graphics: Hardware - GLES 2.0

3. **Disable Unnecessary Features:**
   - Disable unneeded sensors in AVD settings

### Application Performance Optimization

If app runs slowly on emulator:

1. **Reduce Avatar Quality:**
   In `components/InteractiveAvatar.tsx`:

   ```typescript
   quality: AvatarQuality.Low,  // Change from Medium to Low
   ```

2. **Check Network Speed:**
   - Emulator uses computer's network
   - Ensure stable network connection

## 🎯 Quick Command Reference

```bash
# Check configuration
npm run check-env

# Build and sync
npm run android:build

# Open Android Studio
npm run android:open

# Complete rebuild process
npm run build
npm run android:sync
# Then click run in Android Studio

# Clean and rebuild (if issues occur)
cd android
./gradlew clean
cd ..
npm run android:build
```

## ✅ Signs of Successful Run

When everything works correctly, you should see:

1. ✅ Emulator starts successfully
2. ✅ App installs and opens automatically
3. ✅ See HeyGen Avatar configuration interface
4. ✅ After clicking "Start Voice Chat", Avatar video appears
5. ✅ Can converse with Avatar
6. ✅ No critical errors in Logcat

## 🎓 Next Steps

After successfully running on emulator:

1. **Test on real device** (especially 75-inch device)
2. **Configure Santa Claus Avatar**
3. **Optimize UI for portrait layout**
4. **Test voice recognition and conversation features**

## 📞 Need Help?

If you encounter issues:

1. **Check Logcat** for error messages
2. **Run `npm run check-env`** to verify configuration
3. **See** `ANDROID_BUILD.md` for detailed instructions
4. **Search error messages** on Stack Overflow or HeyGen docs

---

**Happy debugging!** 🎅📱
