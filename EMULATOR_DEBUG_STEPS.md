# Android Emulator Connectivity Debug Steps

## Current Status

✅ Dev server running on port 3000
✅ API endpoint working: `curl http://localhost:3000/api/get-access-token` returns token
✅ Environment variables configured in `.env` and `.env.local`
✅ Android manifest has INTERNET permission
✅ All required keys present (HEYGEN_API_KEY, NEXT_PUBLIC_BASE_API_URL, NEXT_PUBLIC_SERVER_URL)

## Issue

App shows "Loading..." indefinitely in emulator, likely unable to fetch access token from `http://10.0.2.2:3000/api/get-access-token`

## Debug Steps

### 1. Check Android Logcat for Network Errors

In Android Studio, open **Logcat** and filter for your app:

```
package:com.school.heygensanta
```

Look for these log messages:

- `Fetching access token from: http://10.0.2.2:3000/api/get-access-token`
- `Access Token retrieved successfully` (success)
- `Error fetching access token:` (failure)

### 2. Test Emulator Network Connectivity

**Option A: Use Emulator Browser**

1. Open Chrome in the emulator
2. Navigate to: `http://10.0.2.2:3000`
3. You should see the HeyGen app homepage
4. Try: `http://10.0.2.2:3000/api/get-access-token` (POST not possible in browser, but should show error not timeout)

**Option B: Use ADB Shell**

```bash
adb shell
curl http://10.0.2.2:3000/api/get-access-token -X POST
```

If this times out, the emulator cannot reach your host machine.

### 3. Verify Environment Variables are Baked In

The environment variables must be embedded during build time:

```bash
# Rebuild with fresh env
npm run android:build

# Check what's in the Android assets
cat android/app/src/main/assets/capacitor.config.json

# Verify the built files contain the env var
grep -r "10.0.2.2" out/ | head -3
```

### 4. Common Fixes

#### Fix 1: Rebuild After Env Changes

Environment variables are baked into the static build. After changing `.env` or `.env.local`:

```bash
npm run android:build
# Then relaunch in Android Studio
```

#### Fix 2: Check Firewall

Your Mac's firewall might be blocking the emulator:

1. System Settings → Network → Firewall
2. Ensure Node.js/npm is allowed
3. Or temporarily disable firewall for testing

#### Fix 3: Use Alternative Address

If `10.0.2.2` doesn't work, try your Mac's actual IP:

```bash
# Get your Mac's IP
ipconfig getifaddr en0

# Update .env.local
echo "NEXT_PUBLIC_SERVER_URL=http://YOUR_IP:3000" > .env.local

# Rebuild
npm run android:build
```

#### Fix 4: Check Next.js Server Binding

Ensure the dev server binds to all interfaces:

```bash
# In package.json, use:
"dev": "next dev -H 0.0.0.0"

# Restart server
npm run dev
```

### 5. Enable Web Debugging

Since `webContentsDebuggingEnabled: true` is set, you can use Chrome DevTools:

1. Open Chrome on your Mac
2. Navigate to: `chrome://inspect`
3. Find your app's WebView
4. Click "inspect"
5. Check Console for JavaScript errors
6. Check Network tab for failed requests

### 6. Test with Simple Fetch

Add a test button to verify basic connectivity. Create a simple test in the browser console:

```javascript
fetch("http://10.0.2.2:3000/api/get-access-token", { method: "POST" })
  .then((r) => r.text())
  .then(console.log)
  .catch(console.error);
```

## Expected Logcat Output (Success)

```
Fetching access token from: http://10.0.2.2:3000/api/get-access-token
Access Token retrieved successfully
>>>>> Stream ready: [object Object]
```

## Expected Logcat Output (Failure)

```
Fetching access token from: http://10.0.2.2:3000/api/get-access-token
Error fetching access token: TypeError: Failed to fetch
```

## Next Steps

1. **Check Logcat first** - this will tell you exactly what's failing
2. **Test emulator browser** - confirms network connectivity
3. **Use Chrome DevTools** - inspect the WebView directly
4. **Try your Mac's IP** - if 10.0.2.2 doesn't work

## Quick Test Command

```bash
# From your Mac terminal
adb logcat | grep -E "(Fetching access token|Error fetching|Access Token retrieved)"
```

This will show you exactly what the app is trying to do and where it fails.
