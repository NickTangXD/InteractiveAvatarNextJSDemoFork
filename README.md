# HeyGen Interactive Avatar NextJS Demo

![HeyGen Interactive Avatar NextJS Demo Screenshot](./public/demo.png)

This is a sample project and was bootstrapped using [NextJS](https://nextjs.org/).
Feel free to play around with the existing code and please leave any feedback for the SDK [here](https://github.com/HeyGen-Official/StreamingAvatarSDK/discussions).

## 🤖 Android Support

This project has been configured to build as an Android APK using [Capacitor](https://capacitorjs.com/).

**📖 Documentation:**

- 🚀 **[Android AVD Setup Guide](./ANDROID_AVD_SETUP.md)** - START HERE for AVD configuration
- 📱 [Quick Start Guide](./QUICK_START.md) - Complete setup guide
- 📗 [Android Build Guide](./ANDROID_BUILD.md) - Detailed Android build instructions
- 🎯 [Android Studio Guide](./ANDROID_STUDIO_GUIDE.md) - How to run in Android Studio
- 📊 [Project Status](./PROJECT_STATUS.md) - Current project status and roadmap
- 👥 [Team Onboarding](./TEAM_ONBOARDING.md) - Guide for new team members

**⚡ Quick Setup:**

```bash
# 1. Check environment
npm run check-env

# 2. Build and sync to Android
npm run android:build

# 3. Configure AVD (IMPORTANT - fixes DPI issues for 75" displays)
./setup-avd.sh your_avd_name

# 4. Open in Android Studio
npm run android:open
```

**🔧 Automated Scripts:**

```bash
# List and configure AVD with correct DPI
./setup-avd.sh                    # List all AVDs
./setup-avd.sh 4k_vertical_tv    # Configure specific AVD

# Reset DPI on running emulator (instant fix)
./reset-avd-dpi.sh

# One-line deploy
./deploy-android.sh
```

## Getting Started FAQ

### Setting up the demo

1. Clone this repo

2. Navigate to the repo folder in your terminal

3. Run `npm install` (assuming you have npm installed. If not, please follow these instructions: https://docs.npmjs.com/downloading-and-installing-node-js-and-npm/)

4. Enter your HeyGen Enterprise API Token in the `.env` file. Set `HEYGEN_API_KEY` with your API key. This will allow the server to generate secure Access Tokens with which to create interactive sessions. **Important:** The API key is kept server-side only and never exposed to the client.

   You can retrieve the API Key by logging in to HeyGen and navigating to this page in your settings: [https://app.heygen.com/settings?from=&nav=Subscriptions%20%26%20API].

   **For Android Emulator Testing:** Run `./setup-android-dev.sh` to configure the connection to your local development server.

5. (Optional) If you would like to use the OpenAI features, enter your OpenAI Api Key in the `.env` file.

6. Run `npm run dev`

### Starting sessions

NOTE: Make sure you have enter your token into the `.env` file and run `npm run dev`.

To start your 'session' with a Interactive Avatar, first click the 'start' button. If your HeyGen API key is entered into the Server's .env file, then you should see our demo Interactive Avatar appear.

If you want to see a different Avatar or try a different voice, you can close the session and enter the IDs and then 'start' the session again. Please see below for information on where to retrieve different Avatar and voice IDs that you can use.

### Which Avatars can I use with this project?

By default, there are several Public Avatars that can be used in Interactive Avatar. (AKA Interactive Avatars.) You can find the Avatar IDs for these Public Avatars by navigating to [labs.heygen.com/interactive-avatar](https://labs.heygen.com/interactive-avatar) and clicking 'Select Avatar' and copying the avatar id.

You can create your own custom Interactive Avatars at labs.heygen.com/interactive-avatar by clicking 'create interactive avatar' on the top-left of the screen.

### Where can I read more about enterprise-level usage of the Interactive Avatar API?

Please read our Interactive Avatar 101 article for more information on pricing: https://help.heygen.com/en/articles/9182113-interactive-avatar-101-your-ultimate-guide
