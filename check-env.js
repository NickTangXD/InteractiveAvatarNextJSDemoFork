#!/usr/bin/env node

/**
 * 环境配置检查脚本
 * 用于验证 Android 构建所需的所有配置是否正确
 */

const fs = require("fs");
const path = require("path");

console.log("🔍 检查 HeyGen Santa 环境配置...\n");

let hasErrors = false;
let hasWarnings = false;

// 1. 检查 .env 文件
console.log("1️⃣  检查 .env 文件...");
const envPath = path.join(__dirname, ".env");
if (!fs.existsSync(envPath)) {
  console.log("   ❌ .env 文件不存在！");
  console.log("   💡 请创建 .env 文件并添加必要的环境变量");
  hasErrors = true;
} else {
  const envContent = fs.readFileSync(envPath, "utf-8");

  // 检查必需的环境变量
  const requiredVars = ["HEYGEN_API_KEY"];

  const optionalVars = ["NEXT_PUBLIC_BASE_API_URL", "OPENAI_API_KEY"];

  requiredVars.forEach((varName) => {
    const regex = new RegExp(`${varName}=(.+)`);
    const match = envContent.match(regex);
    if (
      !match ||
      match[1].trim() === "" ||
      match[1].includes("your_") ||
      match[1].includes("here")
    ) {
      console.log(`   ❌ ${varName} 未配置或使用了占位符`);
      hasErrors = true;
    } else {
      console.log(`   ✅ ${varName} 已配置`);
    }
  });

  optionalVars.forEach((varName) => {
    const regex = new RegExp(`${varName}=(.+)`);
    const match = envContent.match(regex);
    if (!match || match[1].trim() === "") {
      console.log(`   ⚠️  ${varName} 未配置（可选）`);
      hasWarnings = true;
    } else {
      console.log(`   ✅ ${varName} 已配置`);
    }
  });
}

// 2. 检查 node_modules
console.log("\n2️⃣  检查依赖包...");
const nodeModulesPath = path.join(__dirname, "node_modules");
if (!fs.existsSync(nodeModulesPath)) {
  console.log("   ❌ node_modules 不存在！");
  console.log("   💡 请运行: npm install");
  hasErrors = true;
} else {
  const capacitorCorePath = path.join(nodeModulesPath, "@capacitor", "core");
  const capacitorAndroidPath = path.join(
    nodeModulesPath,
    "@capacitor",
    "android"
  );

  if (!fs.existsSync(capacitorCorePath)) {
    console.log("   ❌ @capacitor/core 未安装");
    hasErrors = true;
  } else {
    console.log("   ✅ @capacitor/core 已安装");
  }

  if (!fs.existsSync(capacitorAndroidPath)) {
    console.log("   ❌ @capacitor/android 未安装");
    hasErrors = true;
  } else {
    console.log("   ✅ @capacitor/android 已安装");
  }
}

// 3. 检查 Capacitor 配置
console.log("\n3️⃣  检查 Capacitor 配置...");
const capacitorConfigPath = path.join(__dirname, "capacitor.config.ts");
if (!fs.existsSync(capacitorConfigPath)) {
  console.log("   ❌ capacitor.config.ts 不存在！");
  console.log("   💡 请运行: npx cap init");
  hasErrors = true;
} else {
  console.log("   ✅ capacitor.config.ts 已存在");
}

// 4. 检查 Android 平台
console.log("\n4️⃣  检查 Android 平台...");
const androidPath = path.join(__dirname, "android");
if (!fs.existsSync(androidPath)) {
  console.log("   ❌ android 目录不存在！");
  console.log("   💡 请运行: npx cap add android");
  hasErrors = true;
} else {
  console.log("   ✅ Android 平台已添加");

  const manifestPath = path.join(
    androidPath,
    "app",
    "src",
    "main",
    "AndroidManifest.xml"
  );
  if (fs.existsSync(manifestPath)) {
    const manifestContent = fs.readFileSync(manifestPath, "utf-8");

    // 检查权限
    const permissions = [
      "android.permission.CAMERA",
      "android.permission.RECORD_AUDIO",
    ];

    permissions.forEach((permission) => {
      if (manifestContent.includes(permission)) {
        console.log(`   ✅ ${permission} 权限已配置`);
      } else {
        console.log(`   ⚠️  ${permission} 权限未配置`);
        hasWarnings = true;
      }
    });
  }
}

// 5. 检查构建输出
console.log("\n5️⃣  检查构建输出...");
const outPath = path.join(__dirname, "out");
if (!fs.existsSync(outPath)) {
  console.log("   ⚠️  out 目录不存在（尚未构建）");
  console.log("   💡 请运行: npm run build");
  hasWarnings = true;
} else {
  const indexPath = path.join(outPath, "index.html");
  if (fs.existsSync(indexPath)) {
    console.log("   ✅ 构建输出存在");
  } else {
    console.log("   ⚠️  构建输出不完整");
    hasWarnings = true;
  }
}

// 6. 检查 Next.js 配置
console.log("\n6️⃣  检查 Next.js 配置...");
const nextConfigPath = path.join(__dirname, "next.config.js");
if (!fs.existsSync(nextConfigPath)) {
  console.log("   ❌ next.config.js 不存在！");
  hasErrors = true;
} else {
  const nextConfig = fs.readFileSync(nextConfigPath, "utf-8");
  if (nextConfig.includes("output: 'export'")) {
    console.log("   ✅ Next.js 静态导出已配置");
  } else {
    console.log("   ⚠️  Next.js 未配置为静态导出模式");
    hasWarnings = true;
  }
}

// 总结
console.log("\n" + "=".repeat(50));
if (hasErrors) {
  console.log("❌ 发现配置错误！请修复上述问题后再继续。\n");
  process.exit(1);
} else if (hasWarnings) {
  console.log("⚠️  配置基本正确，但有一些警告。\n");
  console.log("建议的下一步：");
  console.log("  1. npm run build          # 构建应用");
  console.log("  2. npm run android:sync   # 同步到 Android");
  console.log("  3. npm run android:open   # 打开 Android Studio\n");
} else {
  console.log("✅ 所有配置检查通过！\n");
  console.log("可以开始构建 Android 应用：");
  console.log("  npm run android:build");
  console.log("  npm run android:open\n");
}
