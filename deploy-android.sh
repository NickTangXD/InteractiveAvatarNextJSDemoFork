#!/bin/bash

# HeyGen Santa Android 部署脚本
# 一键构建并部署到 Android 设备

set -e  # 遇到错误立即退出

echo "🎅 HeyGen Santa - Android 部署脚本"
echo "======================================"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 1. 检查环境配置
echo "1️⃣  检查环境配置..."
if ! npm run check-env; then
    echo ""
    echo -e "${RED}❌ 环境配置检查失败！${NC}"
    echo -e "${YELLOW}请先修复配置问题，然后重新运行此脚本。${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ 环境配置检查通过${NC}"
echo ""

# 2. 构建 Next.js 应用
echo "2️⃣  构建 Next.js 应用..."
npm run build

if [ ! -d "out" ]; then
    echo -e "${RED}❌ 构建失败：out 目录不存在${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Next.js 构建完成${NC}"
echo ""

# 3. 同步到 Android
echo "3️⃣  同步到 Android 平台..."
npx cap sync android

echo -e "${GREEN}✅ 同步完成${NC}"
echo ""

# 4. 检查是否有连接的设备
echo "4️⃣  检查 Android 设备..."
if command -v adb &> /dev/null; then
    DEVICES=$(adb devices | grep -w "device" | wc -l)
    if [ $DEVICES -gt 0 ]; then
        echo -e "${GREEN}✅ 检测到 $DEVICES 个 Android 设备${NC}"
        echo ""
        echo "设备列表："
        adb devices
        echo ""
        
        # 询问是否直接安装
        read -p "是否直接安装到设备？(y/N) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "5️⃣  安装到设备..."
            cd android
            ./gradlew installDebug
            echo ""
            echo -e "${GREEN}✅ 应用已安装到设备${NC}"
            exit 0
        fi
    else
        echo -e "${YELLOW}⚠️  未检测到连接的 Android 设备${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  未找到 adb 命令${NC}"
    echo -e "${YELLOW}   请确保 Android SDK 已正确安装${NC}"
fi

echo ""
echo "======================================"
echo -e "${GREEN}✅ 构建完成！${NC}"
echo ""
echo "下一步："
echo "  1. 打开 Android Studio:"
echo "     npm run android:open"
echo ""
echo "  2. 在 Android Studio 中："
echo "     - 等待 Gradle 同步完成"
echo "     - 连接 Android 设备或启动模拟器"
echo "     - 点击运行按钮（绿色三角形）"
echo ""
echo "  3. 或者使用命令行运行："
echo "     cd android && ./gradlew installDebug"
echo ""

