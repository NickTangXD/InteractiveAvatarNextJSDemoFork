#!/bin/bash

# Android Development Environment Setup Script
# This script helps configure your environment for Android emulator testing

set -e

echo "🔧 Android Development Environment Setup"
echo "========================================"
echo ""

# Check if .env file exists
if [ ! -f .env ]; then
    echo "❌ .env file not found!"
    echo "   Please create .env file with HEYGEN_API_KEY first."
    echo "   You can copy from .env.example:"
    echo "   cp .env.example .env"
    exit 1
fi

# Check if HEYGEN_API_KEY is set in .env
if ! grep -q "HEYGEN_API_KEY=.*[^=]" .env; then
    echo "⚠️  HEYGEN_API_KEY not set in .env file"
    echo "   Please add your HeyGen API key to .env"
    exit 1
fi

echo "✅ .env file found with HEYGEN_API_KEY"
echo ""

# Ask user what they're setting up for
echo "What are you setting up for?"
echo "1) Android Emulator (use 10.0.2.2)"
echo "2) Android Device on same network (use computer's IP)"
echo "3) Production (use custom URL)"
echo "4) Skip (web development only)"
echo ""
read -p "Enter choice (1-4): " choice

case $choice in
    1)
        SERVER_URL="http://10.0.2.2:3000"
        echo ""
        echo "📱 Configuring for Android Emulator"
        ;;
    2)
        # Try to detect IP address
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            IP=$(ipconfig getifaddr en0 2>/dev/null || echo "")
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            # Linux
            IP=$(hostname -I | awk '{print $1}')
        else
            IP=""
        fi

        if [ -n "$IP" ]; then
            echo ""
            echo "Detected IP address: $IP"
            read -p "Use this IP? (y/n): " use_detected
            if [ "$use_detected" = "y" ]; then
                SERVER_URL="http://$IP:3000"
            else
                read -p "Enter your computer's IP address: " custom_ip
                SERVER_URL="http://$custom_ip:3000"
            fi
        else
            echo ""
            read -p "Enter your computer's IP address: " custom_ip
            SERVER_URL="http://$custom_ip:3000"
        fi

        echo ""
        echo "📱 Configuring for Android Device"
        ;;
    3)
        echo ""
        read -p "Enter your production server URL (e.g., https://your-domain.com): " SERVER_URL
        echo ""
        echo "🌍 Configuring for Production"
        ;;
    4)
        echo ""
        echo "⏭️  Skipping Android configuration"
        echo "   Your app will work for web development only."
        exit 0
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

# Create or update .env.local
echo "NEXT_PUBLIC_SERVER_URL=$SERVER_URL" > .env.local

echo "✅ Created .env.local with:"
echo "NEXT_PUBLIC_SERVER_URL=$SERVER_URL"
echo ""

# Verify the configuration
echo "🔍 Verifying configuration..."
echo ""

if npm run check-env > /dev/null 2>&1; then
    echo "✅ Environment configuration is valid"
else
    echo "⚠️  Environment check warnings (see above)"
fi

echo ""
echo "📋 Next Steps:"
echo ""
echo "1. Start development server (keep this running):"
echo "   npm run dev"
echo ""
echo "2. In a new terminal, build for Android:"
echo "   npm run android:build"
echo ""
echo "3. Open in Android Studio:"
echo "   npm run android:open"
echo ""
echo "4. Run the app on your emulator/device"
echo ""
echo "💡 Tips:"
echo "   - Make sure dev server is running before testing Android app"
echo "   - Check Android Studio Logcat for debugging"
echo "   - See ANDROID_EMULATOR_SETUP.md for detailed troubleshooting"
echo ""
echo "✨ Setup complete!"

