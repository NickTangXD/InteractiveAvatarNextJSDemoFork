# Debug Android App with Chrome DevTools

## Step-by-Step Instructions

### 1. Make Sure Your App is Running

- The emulator should be showing the "Loading..." screen
- Keep it open

### 2. Open Chrome on Your Mac

1. Open **Google Chrome** (not Safari, not Firefox)
2. In the address bar, type: `chrome://inspect`
3. Press Enter

### 3. Find Your App

You should see a section called **"Remote Target"** or **"Devices"**

Look for:

- Device name: Your emulator name (e.g., "4k vertical tv API 35")
- Under it, you should see: **"HeyGen Interactive Avatar SDK NextJS Demo"** or similar

### 4. Click "inspect"

Click the blue **"inspect"** link next to your app

### 5. Check the Console Tab

A DevTools window will open. Look at the **Console** tab (top of the window).

**What you're looking for:**

✅ **Success (if working):**

```
Fetching access token from: http://10.0.2.2:3000/api/get-access-token
Access Token retrieved successfully
```

❌ **Failure (if broken):**

```
Fetching access token from: http://10.0.2.2:3000/api/get-access-token
Error fetching access token: TypeError: Failed to fetch
```

OR

```
Fetching access token from: /api/get-access-token
Error fetching access token: ...
```

(Notice the URL is missing the `http://10.0.2.2:3000` part - this means the env var isn't embedded)

### 6. Check the Network Tab

Click the **Network** tab in DevTools

Look for a request to:

- `get-access-token`

Click on it and check:

- **Status**: Should be `200` (success) or `Failed` (network error)
- **Response**: Should show a token string

## Common Issues and Fixes

### Issue 1: Console shows `/api/get-access-token` (without `http://10.0.2.2:3000`)

**Problem:** Environment variable not embedded in build

**Fix:**

```bash
# 1. Clean and rebuild
rm -rf .next out
NEXT_PUBLIC_SERVER_URL="http://10.0.2.2:3000" npm run build

# 2. Verify it's in the build
grep -r "10\.0\.2\.2" out/_next/static/chunks/app/page-*.js

# 3. Sync to Android
npx cap sync android

# 4. Relaunch app in Android Studio
```

### Issue 2: Console shows `Failed to fetch` or `Network request failed`

**Problem:** Emulator can't reach your Mac

**Possible causes:**

1. **Firewall blocking:** Mac firewall is blocking the connection
2. **Dev server not accessible:** Server only listening on localhost
3. **Wrong IP:** `10.0.2.2` doesn't work on your emulator

**Fix A: Check Firewall**

1. System Settings → Network → Firewall
2. Click "Options"
3. Make sure Node.js is allowed
4. Or temporarily disable firewall for testing

**Fix B: Make dev server listen on all interfaces**

```bash
# Stop current dev server (Ctrl+C)
# Start with explicit binding
npm run dev -- -H 0.0.0.0
```

**Fix C: Try your Mac's actual IP instead**

```bash
# Get your Mac's IP
ipconfig getifaddr en0

# Update .env.local with your IP (e.g., 192.168.1.100)
echo "NEXT_PUBLIC_SERVER_URL=http://YOUR_IP:3000" > .env.local

# Rebuild
npm run build
npx cap sync android
```

### Issue 3: Console shows CORS error

**Problem:** Browser security blocking the request

**Fix:** Add CORS headers to your API route (already should be fine, but check)

### Issue 4: No errors in console, just stuck on Loading

**Problem:** JavaScript might not be running at all

**Fix:**

1. Check Console for any red errors
2. Try refreshing the app (swipe up, close, reopen)
3. Clear app data: Settings → Apps → HeyGen Santa → Clear Data

## Screenshot What You See

If you still have issues:

1. Take a screenshot of the Chrome DevTools Console tab
2. Take a screenshot of the Network tab
3. Share them so we can see exactly what's failing

## Quick Test in Chrome DevTools Console

You can also test the fetch directly. In the Console tab, paste this:

```javascript
fetch("http://10.0.2.2:3000/api/get-access-token", { method: "POST" })
  .then((r) => r.text())
  .then((token) => console.log("Token:", token))
  .catch((err) => console.error("Error:", err));
```

Press Enter. This will tell you immediately if the network connection works.

## Alternative: Test in Emulator Browser

1. Open Chrome browser **inside the emulator** (not on your Mac)
2. Navigate to: `http://10.0.2.2:3000`
3. You should see your HeyGen app homepage
4. If you see "This site can't be reached" → network problem
5. If you see the app → network is fine, problem is elsewhere
