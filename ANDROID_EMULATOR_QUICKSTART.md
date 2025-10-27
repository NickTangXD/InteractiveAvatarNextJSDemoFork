# Android Emulator Quick Start - Secure API Setup

## 🎯 Quick Summary

With the new secure API configuration, Android emulator needs special setup to connect to your development server.

**The Issue:** Android emulator can't use `localhost` - it needs `10.0.2.2` to reach your computer.

**The Fix:** 3 simple steps below! 👇

## ⚡ Quick Setup (3 Steps)

### Option 1: Automated Setup (Recommended)

```bash
# Run the setup script and follow prompts
./setup-android-dev.sh

# Start dev server (keep running)
npm run dev

# In new terminal, build and open Android Studio
npm run android:build
npm run android:open
```

### Option 2: Manual Setup

**Step 1:** Create `.env.local` file:

```bash
echo "NEXT_PUBLIC_SERVER_URL=http://10.0.2.2:3000" > .env.local
```

**Step 2:** Start dev server (keep running):

```bash
npm run dev
```

**Step 3:** Build and run:

```bash
# In a new terminal
npm run android:build
npm run android:open

# Then in Android Studio:
# 1. Start emulator
# 2. Click Run (green triangle)
```

## ✅ Verify It Works

### 1. Check Dev Server

You should see: `✓ Ready in Xms`

### 2. Check Android Logcat

In Android Studio > Logcat, you should see:

```
Fetching access token from: http://10.0.2.2:3000/api/get-access-token
Access Token retrieved successfully
```

### 3. Test the App

Click "Start Voice Chat" - avatar should load!

## 🐛 Troubleshooting

### Problem: "Failed to fetch access token"

**Solution 1:** Is dev server running?

```bash
# Should return a token
curl http://localhost:3000/api/get-access-token -X POST
```

**Solution 2:** Did you create `.env.local`?

```bash
# Should show your config
cat .env.local
```

**Solution 3:** Did you rebuild?

```bash
npm run android:build
```

### Problem: App crashes on start

**Check your `.env` file has `HEYGEN_API_KEY`:**

```bash
npm run check-env
```

### Problem: Works in browser but not emulator

**This is expected!** You need the special `.env.local` file for emulator.

See "Quick Setup" above.

## 📱 Different Scenarios

| Scenario                 | Configuration                                     |
| ------------------------ | ------------------------------------------------- |
| **Web Development**      | No extra config needed                            |
| **Android Emulator**     | Create `.env.local` with `http://10.0.2.2:3000`   |
| **Android Device (USB)** | Use your computer's IP: `http://192.168.1.X:3000` |
| **Production**           | Deploy server, use `https://your-domain.com`      |

## 🔒 Why This Change?

**Before:** API key was exposed in client code (security risk)
**Now:** API key stays on server, only access tokens sent to client (secure!)

## 📚 More Information

- **Detailed Guide:** `ANDROID_EMULATOR_SETUP.md`
- **Security Details:** `SECURITY_IMPROVEMENTS.md`
- **Android Build:** `ANDROID_BUILD.md`

## 💡 Pro Tips

1. **Keep dev server running** while testing Android
2. **Use two terminals** - one for dev server, one for Android builds
3. **Check Logcat** for debugging (Android Studio > Logcat)
4. **Restart emulator** if connection issues persist
5. **`.env.local` is gitignored** - won't be committed accidentally

## 🆘 Still Having Issues?

1. Restart dev server: `Ctrl+C` then `npm run dev`
2. Restart emulator
3. Clean rebuild: `npm run android:build`
4. Check firewall isn't blocking port 3000
5. See detailed troubleshooting in `ANDROID_EMULATOR_SETUP.md`

---

**Need Help?** Run the setup script for guided configuration:

```bash
./setup-android-dev.sh
```

**Last Updated:** October 27, 2025
