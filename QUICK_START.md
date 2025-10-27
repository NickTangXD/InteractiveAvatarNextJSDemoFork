# HeyGen Santa - Quick Start Guide

This is a HeyGen Interactive Avatar application customized for Sha Tin Wai Dr. Catherine F. Woo Memorial School, designed for a 75-inch portrait Android device.

## 🎯 Project Goals

Create a Santa Claus interactive application that can have real-time English conversations with elementary school students.

## 📋 Technology Stack

- **Frontend Framework:** Next.js 15 + React 19
- **Avatar SDK:** HeyGen Streaming Avatar SDK
- **Mobile Packaging:** Capacitor (packages web app as Android APK)
- **Deployment Target:** 75-inch portrait Android advertising display

## 🚀 Quick Start

### 1. Environment Preparation

Ensure you have installed:

- Node.js (v18 or higher)
- npm or pnpm
- Android Studio (for building Android app)

### 2. Clone and Install

```bash
# Navigate to project directory
cd /Volumes/Elements/InteractiveAvatarNextJSDemo

# Install dependencies
npm install
```

### 3. Configure Environment Variables

Create or edit `.env` file in project root:

```bash
# Required: HeyGen API Key (server-side only, secure)
HEYGEN_API_KEY=your_heygen_api_key

# Optional: HeyGen API Base URL
NEXT_PUBLIC_BASE_API_URL=https://api.heygen.com

# Optional: OpenAI API Key
OPENAI_API_KEY=your_openai_api_key
```

**🔒 Security Note:** The API key is now kept server-side only and never exposed to the client. This requires running the Next.js app as a server (not static export).

**Get HeyGen API Key:**

1. Log in to https://app.heygen.com/
2. Visit: https://app.heygen.com/settings?nav=Subscriptions%20%26%20API
3. Copy your API Key

### 4. Local Development Testing

```bash
# Start development server
npm run dev

# Open in browser
# http://localhost:3000
```

### 5. Build Android Application

```bash
# One-command build and sync to Android
npm run android:build

# Configure AVD with correct DPI (IMPORTANT!)
./setup-avd.sh your_avd_name

# Open Android Studio
npm run android:open
```

In Android Studio:

1. Wait for Gradle sync to complete
2. Connect Android device or launch emulator
3. Click run button (green triangle)

## 📱 Building APK Directly

If you only need the APK file:

```bash
# 1. Build and sync
npm run android:build

# 2. In Android Studio
# Build > Build Bundle(s) / APK(s) > Build APK(s)

# 3. APK output location
# android/app/build/outputs/apk/debug/app-debug.apk
```

## 🎅 Configuring Santa Claus Character

### Current Status

Currently, the application uses HeyGen's default public Avatar.

### Configuration Steps

#### Method 1: Create Santa Claus in HeyGen Labs

1. Visit https://labs.heygen.com/interactive-avatar
2. Click "Create Interactive Avatar"
3. Upload or select Santa Claus image
4. Train and get Avatar ID
5. Add to `app/lib/constants.ts`:

```typescript
export const AVATARS = [
  {
    avatar_id: "your_santa_avatar_id",
    name: "Santa Claus",
  },
  // ... others
];
```

#### Method 2: Use Public Santa Claus Avatar

Check if HeyGen provides public Santa Claus Avatar (search in HeyGen Labs).

### Configure Avatar Features

Adjust default configuration in `components/InteractiveAvatar.tsx`:

```typescript
const DEFAULT_CONFIG: StartAvatarRequest = {
  quality: AvatarQuality.Low, // Can change to Medium or High
  avatarName: "your_santa_avatar_id", // Change to Santa Claus ID
  knowledgeId: undefined, // Can add Knowledge Base ID
  voice: {
    rate: 1.5, // Speech rate
    emotion: VoiceEmotion.EXCITED, // Emotion: can change to FRIENDLY
    model: ElevenLabsModel.eleven_flash_v2_5,
  },
  language: "en", // English
  // ... other configurations
};
```

## 🎯 Special Configuration for School Requirements

### 1. Set Avatar Position (Suitable for Elementary Student Height)

Adjust Avatar's vertical position in `components/AvatarSession/AvatarVideo.tsx` or related CSS to display in lower half of screen.

### 2. Configure Conversation System

If using Knowledge Base:

1. Create Knowledge Base in HeyGen backend
2. Add Santa Claus related conversation content
3. Emphasize encouraging language, motivate students to speak more English
4. Add `knowledgeId` to configuration

### 3. Set Kiosk Mode (Lock Application)

Add to `android/app/src/main/java/.../MainActivity.java`:

```java
import android.view.WindowManager;

@Override
public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    // Keep screen always on
    getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);

    // Full screen mode
    getWindow().setFlags(
        WindowManager.LayoutParams.FLAG_FULLSCREEN,
        WindowManager.LayoutParams.FLAG_FULLSCREEN
    );
}
```

Lock portrait orientation in `AndroidManifest.xml`:

```xml
android:screenOrientation="portrait"
```

## 🛠️ Development Tool Commands

```bash
# Web Development
npm run dev          # Start development server
npm run build        # Build production version
npm run start        # Start production server

# Android Development
npm run check-env           # Check environment
npm run android:build       # Build and sync to Android
npm run android:open        # Open Android Studio
npm run android:sync        # Sync web resources to Android
npm run android:run         # Build and run on device

# AVD Configuration
./setup-avd.sh              # List AVDs
./setup-avd.sh <avd-name>   # Configure specific AVD
./reset-avd-dpi.sh          # Fix display on running emulator
```

## 📱 Deploy to 75-inch Device

### Method 1: USB Installation (Recommended for Initial Deployment)

1. Enable developer mode and USB debugging on device
2. Connect device to computer via USB
3. Run: `npm run android:run`

### Method 2: Direct APK Installation

1. Build APK (see instructions above)
2. Copy APK to USB drive
3. Install APK on device (need to allow unknown sources)

### Method 3: ADB Wireless Installation

```bash
# Ensure device and computer are on same network
adb connect <device_IP>:5555
adb install android/app/build/outputs/apk/debug/app-debug.apk
```

## ✅ Testing Checklist

Before deployment, confirm:

- [ ] Application starts normally
- [ ] HeyGen API connection successful
- [ ] Camera and microphone permissions granted
- [ ] Avatar video displays normally
- [ ] Voice recognition works (can recognize student speech)
- [ ] Avatar responds normally
- [ ] Lip sync is accurate
- [ ] Application displays correctly in portrait mode
- [ ] Avatar position suitable for elementary student height
- [ ] Full screen mode works
- [ ] Application runs stably for extended periods

## 🎓 Project Milestones

### Phase 1: MVP (By Mid-November)

- [x] Configure Android build environment
- [ ] Create or configure Santa Claus Avatar
- [ ] Configure conversation system suitable for elementary students
- [ ] Test on actual device
- [ ] Optimize UI for portrait large screen
- [ ] Performance optimization

### Phase 2: Official Deployment (By December 10)

- [ ] Final testing and debugging
- [ ] On-site deployment at school
- [ ] Train school personnel
- [ ] Monitoring and maintenance plan

## 🐛 Common Issues

### Issue 1: Cannot Get Access Token

**Cause:** API Key configuration error or network issue
**Solution:**

- Check `HEYGEN_API_KEY` in `.env` file
- Confirm API Key is valid and has quota
- Check device network connection
- Ensure Next.js server is running (API routes require server-side execution)

### Issue 2: Camera or Microphone Not Working

**Cause:** Permission not granted or device doesn't support
**Solution:**

- Check application permissions in device settings
- Manually grant camera and microphone permissions
- Confirm device hardware is functional

### Issue 3: Avatar Display Blurry or Laggy

**Cause:** Insufficient network bandwidth or device performance issues
**Solution:**

- Reduce Avatar quality (change to Low)
- Use wired network connection
- Check device CPU and memory usage

### Issue 4: Application Crashes

**Cause:** Insufficient memory or compatibility issues
**Solution:**

- View logcat: `adb logcat | grep -E "AndroidRuntime|FATAL"`
- Check device Android version (requires API 24+)
- Restart device

## 📚 Related Documentation

- [Detailed Android Build Guide](./ANDROID_BUILD.md)
- [Android AVD Setup Guide](./ANDROID_AVD_SETUP.md)
- [Team Onboarding Guide](./TEAM_ONBOARDING.md)
- [HeyGen Official Docs](https://docs.heygen.com/)
- [HeyGen SDK GitHub](https://github.com/HeyGen-Official/StreamingAvatarSDK)
- [Capacitor Docs](https://capacitorjs.com/docs)

## 📞 Technical Support

For help, contact:

- HeyGen Support: https://help.heygen.com/
- Project Issues: Check GitHub Issues

## 🎉 Get Started

You're ready now! Run these commands to begin:

```bash
# 1. Configure .env file (add your API Key)

# 2. Test web version
npm run dev

# 3. Build Android version
npm run android:build
./setup-avd.sh your_avd_name
npm run android:open

# 4. Run on device in Android Studio
```

Good luck with your project! 🎅🎄
