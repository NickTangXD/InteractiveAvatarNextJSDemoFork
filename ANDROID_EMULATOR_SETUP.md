# Android Emulator Setup - Secure API Configuration

## Overview

With the new secure API key configuration, the Android app needs to connect to your Next.js server to fetch access tokens. This guide explains how to set this up for Android emulator testing.

## The Problem

When you run the app in Android emulator:

- The emulator is like a separate device
- `localhost` in the emulator refers to the **emulator itself**, not your computer
- The app can't reach your Next.js server at `localhost:3000`

## The Solution

Android emulator provides a special IP address to access your host machine.

## Setup Steps

### Step 1: Start Your Next.js Development Server

```bash
npm run dev
```

This starts the server at `http://localhost:3000` on your computer.

### Step 2: Configure Server URL for Android

You have **two options**:

#### Option A: Use Android Emulator Special Address (Recommended)

Create/edit `.env.local` file:

```bash
# For Android Emulator - special address to reach host machine
NEXT_PUBLIC_SERVER_URL=http://10.0.2.2:3000
```

**Note:** `10.0.2.2` is the special address Android emulator uses for the host machine.

#### Option B: Use Your Computer's Local IP Address

1. Find your computer's IP address:

```bash
# On Mac
ipconfig getifaddr en0

# On Linux
hostname -I | awk '{print $1}'

# On Windows
ipconfig | findstr /i "IPv4"
```

2. Create/edit `.env.local`:

```bash
# Replace with your actual IP address
NEXT_PUBLIC_SERVER_URL=http://192.168.1.XXX:3000
```

### Step 3: Rebuild and Sync

```bash
# Build with new configuration
npm run build

# Sync to Android
npm run android:sync
```

### Step 4: Run in Android Studio

1. Open Android Studio: `npm run android:open`
2. Start emulator
3. Click Run (green triangle)

## Environment File Priority

The app checks for `NEXT_PUBLIC_SERVER_URL` in this order:

1. `.env.local` (not committed to git - use for local development)
2. `.env` (committed to git - don't put emulator config here)

**Best Practice:** Use `.env.local` for emulator configuration so it doesn't affect other developers.

## Testing Different Configurations

### For Web Development (Browser)

```bash
# No NEXT_PUBLIC_SERVER_URL needed
npm run dev
# Visit http://localhost:3000
```

### For Android Emulator

```bash
# In .env.local
NEXT_PUBLIC_SERVER_URL=http://10.0.2.2:3000

# Then
npm run dev          # In one terminal
npm run android:build && npm run android:open  # In another
```

### For Real Android Device (Same Network)

```bash
# In .env.local - use your computer's IP
NEXT_PUBLIC_SERVER_URL=http://192.168.1.XXX:3000

npm run dev          # Make sure to note the IP shown
npm run android:build
# Install APK on device via USB or ADB
```

## Verification Steps

### 1. Check Server is Running

```bash
# Should show "Ready" message
npm run dev
```

### 2. Check Emulator Can Reach Server

In Android emulator, open Chrome browser and try:

```
http://10.0.2.2:3000
```

You should see your Next.js app.

### 3. Check App Logs

1. In Android Studio, open **Logcat** (bottom panel)
2. Filter by "heygen" or search for "Fetching access token"
3. You should see: `Fetching access token from: http://10.0.2.2:3000/api/get-access-token`
4. Followed by: `Access Token retrieved successfully`

## Troubleshooting

### Error: "Failed to fetch access token"

**Check 1: Is the server running?**

```bash
# Should show running server
curl http://localhost:3000/api/get-access-token -X POST
```

**Check 2: Can emulator reach it?**

```bash
# In Android Studio > Tools > Device Manager > Run emulator
# Then in terminal:
adb shell curl http://10.0.2.2:3000/api/get-access-token -X POST
```

**Check 3: Is NEXT_PUBLIC_SERVER_URL correct?**

- Check `.env.local` file
- Rebuild after changing it: `npm run android:build`

### Error: "Network request failed"

**Possible causes:**

1. Next.js server not running
2. Firewall blocking connection
3. Wrong IP address in configuration

**Solutions:**

```bash
# 1. Restart dev server
npm run dev

# 2. Check firewall allows connections on port 3000

# 3. Verify IP address
# On Mac: ipconfig getifaddr en0
# Try using 10.0.2.2 instead
```

### App works in browser but not emulator

This is expected! The configuration is different:

- **Browser**: Uses relative path `/api/get-access-token`
- **Emulator**: Uses full URL with `10.0.2.2`

Make sure you've set `NEXT_PUBLIC_SERVER_URL` in `.env.local`.

### Emulator browser can reach server, but app can't

**Check the app logs:**

1. Open Logcat in Android Studio
2. Look for "Fetching access token from: ..."
3. Confirm the URL is correct

**Rebuild the app:**

```bash
npm run android:build
# Make sure Gradle sync completes
# Then run from Android Studio
```

## Production Deployment

For production, you'll need to:

### Option 1: Deploy Next.js Server

```bash
# Deploy to Vercel, AWS, Railway, etc.
# Then in production .env:
NEXT_PUBLIC_SERVER_URL=https://your-domain.com
```

### Option 2: Use a Separate Backend

```bash
# Deploy a backend service that proxies HeyGen API
# Point both web and Android to it
NEXT_PUBLIC_SERVER_URL=https://api.your-domain.com
```

## Quick Reference

| Environment          | Configuration | NEXT_PUBLIC_SERVER_URL      |
| -------------------- | ------------- | --------------------------- |
| Web (browser)        | Default       | Not needed                  |
| Android Emulator     | `.env.local`  | `http://10.0.2.2:3000`      |
| Android Device (USB) | `.env.local`  | `http://192.168.1.XXX:3000` |
| Production           | `.env`        | `https://your-domain.com`   |

## Complete Workflow Example

```bash
# 1. Set up environment for emulator
echo "NEXT_PUBLIC_SERVER_URL=http://10.0.2.2:3000" > .env.local

# 2. Start dev server (keep this running)
npm run dev

# 3. In a new terminal, build and run Android
npm run android:build
npm run android:open

# 4. In Android Studio:
#    - Start emulator
#    - Click Run
#    - Check Logcat for "Access Token retrieved successfully"
```

## Security Note

- `NEXT_PUBLIC_SERVER_URL` is safe to expose (it's just a URL)
- `HEYGEN_API_KEY` stays secure on your server
- Never commit `.env.local` to git (it's already in `.gitignore`)

---

**Need Help?** Check that:

1. ✅ `npm run dev` is running
2. ✅ `.env.local` has `NEXT_PUBLIC_SERVER_URL=http://10.0.2.2:3000`
3. ✅ You rebuilt after adding config: `npm run android:build`
4. ✅ Logcat shows the correct URL being fetched

**Last Updated:** October 27, 2025
