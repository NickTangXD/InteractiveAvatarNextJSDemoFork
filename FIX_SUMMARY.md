# Android Emulator Connectivity Issue - FIXED ✅

## Problem

The Android emulator was stuck on "Loading..." screen because the environment variable `NEXT_PUBLIC_SERVER_URL=http://10.0.2.2:3000` was **not being embedded** in the static build.

## Root Cause

The `next.config.js` file was missing the `output: 'export'` configuration, so Next.js was building in server mode instead of static export mode. This prevented the `out/` directory from being created and environment variables from being properly embedded.

## Solution Applied

### 1. Fixed `next.config.js`

```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: "export", // ← Added this
  images: {
    unoptimized: true,
  },
};

module.exports = nextConfig;
```

### 2. Rebuilt with Environment Variables

```bash
NEXT_PUBLIC_SERVER_URL="http://10.0.2.2:3000" \
NEXT_PUBLIC_BASE_API_URL="https://api.heygen.com" \
npm run build
```

### 3. Synced to Android

```bash
npx cap sync android
```

## Verification

✅ Environment variable `10.0.2.2` is now embedded in:

- `out/_next/static/chunks/app/page-1aeb6251a4e0dd96.js`
- `android/app/src/main/assets/public/_next/static/chunks/app/page-*.js`

## Next Steps

### 1. Relaunch the App in Android Studio

The app should now be able to fetch the access token from your dev server.

### 2. Check Logcat

In Android Studio > Logcat, you should now see:

```
Fetching access token from: http://10.0.2.2:3000/api/get-access-token
Access Token retrieved successfully
```

### 3. If Still Having Issues

**Enable Chrome DevTools Debugging:**

1. Open Chrome on your Mac
2. Navigate to: `chrome://inspect`
3. Find "HeyGen Santa" WebView
4. Click "inspect"
5. Check Console and Network tabs for errors

**Check Network Connectivity:**

```bash
# From your Mac terminal
adb shell
curl http://10.0.2.2:3000/api/get-access-token -X POST
```

## Important Notes

### Environment Variables Must Be Set at Build Time

Next.js replaces `process.env.NEXT_PUBLIC_*` with actual values during build. If you change `.env` or `.env.local`, you MUST rebuild:

```bash
# Quick rebuild and sync
npm run android:build
```

### For Future Builds

The correct workflow is:

```bash
# 1. Ensure .env has your API key
cat .env
# Should show: HEYGEN_API_KEY=...

# 2. Ensure .env.local has the emulator URL
cat .env.local
# Should show: NEXT_PUBLIC_SERVER_URL=http://10.0.2.2:3000

# 3. Build (env vars are read automatically)
npm run build

# 4. Sync to Android
npx cap sync android

# 5. Open in Android Studio
npx cap open android
```

Or use the combined command:

```bash
npm run android:build  # Does build + sync
npm run android:open   # Opens Android Studio
```

## Files Modified

- `next.config.js` - Added `output: 'export'` configuration
- `.env.local` - Cleaned up (only has NEXT_PUBLIC_SERVER_URL now)

## Environment Configuration

### `.env` (Server-side secrets + public vars)

```
NEXT_PUBLIC_SERVER_URL=http://10.0.2.2:3000
NEXT_PUBLIC_BASE_API_URL=https://api.heygen.com
HEYGEN_API_KEY="sk_V2_..."
```

### `.env.local` (Local overrides, not committed to git)

```
NEXT_PUBLIC_SERVER_URL=http://10.0.2.2:3000
```

## Troubleshooting Reference

### Issue: "Could not find the web assets directory: ./out"

**Cause:** `next.config.js` missing `output: 'export'`  
**Fix:** Add the export configuration (already done)

### Issue: Environment variable not in build

**Cause:** Built before setting env vars  
**Fix:** Rebuild with `npm run build`

### Issue: Changes not reflected in emulator

**Cause:** Forgot to sync after rebuild  
**Fix:** Run `npx cap sync android`

### Issue: Dev server not running

**Cause:** Forgot to start the server  
**Fix:** Run `npm run dev` in a separate terminal (keep it running)

## Success Criteria

✅ `npm run build` creates `out/` directory  
✅ `out/_next/static/chunks/app/page-*.js` contains "10.0.2.2"  
✅ `npx cap sync android` completes successfully  
✅ Dev server running on port 3000  
✅ Emulator can reach `http://10.0.2.2:3000`  
✅ App loads and shows avatar (not stuck on "Loading...")
