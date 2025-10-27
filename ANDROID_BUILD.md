# HeyGen Santa - Android 构建和部署指南

这份文档将指导你如何在 Android 设备上构建和部署圣诞老人互动应用。

## 前置要求

### 1. 安装 Android Studio

- 下载并安装 [Android Studio](https://developer.android.com/studio)
- 确保安装了 Android SDK (API 级别 24 或更高)
- 配置 Android SDK 路径到环境变量

### 2. 配置环境变量

在项目根目录的 `.env` 文件中配置以下变量：

```bash
# HeyGen API Key (必需 - 仅服务端)
HEYGEN_API_KEY=your_api_key_here

# HeyGen API Base URL
NEXT_PUBLIC_BASE_API_URL=https://api.heygen.com

# OpenAI API Key (可选)
OPENAI_API_KEY=your_openai_key_here
```

**🔒 安全改进**：API 密钥现在仅保存在服务端，永远不会暴露给客户端。

**重要提醒**：这需要 Next.js 服务器运行（不能使用静态导出）。对于 Android 部署，需要部署 Next.js 服务器并让 Android 应用连接到它。

### 3. 获取 HeyGen API Key

1. 登录 [HeyGen](https://app.heygen.com/)
2. 进入设置页面：https://app.heygen.com/settings?nav=Subscriptions%20%26%20API
3. 复制你的 API Key

## 构建步骤

### 第一步：安装依赖

```bash
npm install
```

### 第二步：构建 Next.js 应用

```bash
npm run build
```

这将创建一个静态导出的应用在 `out/` 目录中。

### 第三步：同步到 Android

```bash
npx cap sync android
```

### 第四步：在 Android Studio 中打开项目

```bash
npx cap open android
```

或者手动在 Android Studio 中打开 `/android` 目录。

## 在 Android Studio 中构建 APK

### 方法一：调试版本 (Debug Build)

1. 在 Android Studio 中，点击菜单 `Build` > `Build Bundle(s) / APK(s)` > `Build APK(s)`
2. 等待构建完成
3. 点击通知中的 "locate" 找到生成的 APK
4. APK 位置：`android/app/build/outputs/apk/debug/app-debug.apk`

### 方法二：发布版本 (Release Build)

1. 创建签名密钥（如果没有的话）：

   ```bash
   keytool -genkey -v -keystore my-release-key.keystore -alias my-key-alias -keyalg RSA -keysize 2048 -validity 10000
   ```

2. 在 `android/app/build.gradle` 中配置签名：

   ```gradle
   android {
       ...
       signingConfigs {
           release {
               storeFile file("path/to/my-release-key.keystore")
               storePassword "your-password"
               keyAlias "my-key-alias"
               keyPassword "your-password"
           }
       }
       buildTypes {
           release {
               signingConfig signingConfigs.release
               ...
           }
       }
   }
   ```

3. 在 Android Studio 中，点击菜单 `Build` > `Generate Signed Bundle / APK`
4. 选择 APK，然后按照向导操作
5. APK 位置：`android/app/build/outputs/apk/release/app-release.apk`

## 部署到设备

### 通过 USB 连接部署

1. 在 Android 设备上启用开发者选项和 USB 调试
2. 用 USB 连接设备到电脑
3. 在 Android Studio 中点击运行按钮 (绿色三角形)
4. 选择你的设备

### 通过 ADB 安装 APK

```bash
adb install android/app/build/outputs/apk/debug/app-debug.apk
```

### 直接安装 APK

1. 将 APK 文件复制到 Android 设备
2. 在设备上找到 APK 文件
3. 点击安装（可能需要允许从未知来源安装应用）

## 针对 75 英寸竖屏的优化建议

### 1. 设置为全屏和常亮

在 `android/app/src/main/java/.../MainActivity.java` 中添加：

```java
import android.view.WindowManager;

@Override
public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    // 保持屏幕常亮
    getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);

    // 隐藏状态栏和导航栏（全屏）
    getWindow().setFlags(
        WindowManager.LayoutParams.FLAG_FULLSCREEN,
        WindowManager.LayoutParams.FLAG_FULLSCREEN
    );
}
```

### 2. 锁定竖屏方向

在 `android/app/src/main/AndroidManifest.xml` 的 `<activity>` 标签中添加：

```xml
android:screenOrientation="portrait"
```

### 3. 设置为 Kiosk 模式（可选）

如果需要将设备锁定为只运行这个应用（适合公共展示），可以考虑使用 Android 的 Kiosk 模式或 MDM（移动设备管理）解决方案。

## 配置圣诞老人角色

目前应用使用的是 HeyGen 的默认 Avatar。要使用圣诞老人角色：

### 方法一：使用 HeyGen Labs 创建圣诞老人 Avatar

1. 访问 [HeyGen Labs Interactive Avatar](https://labs.heygen.com/interactive-avatar)
2. 点击 "Create Interactive Avatar" 创建一个圣诞老人角色
3. 获取 Avatar ID
4. 在 `app/lib/constants.ts` 中添加圣诞老人 Avatar：

```typescript
export const AVATARS = [
  {
    avatar_id: "your_santa_avatar_id",
    name: "Santa Claus",
  },
  // ... 其他 avatars
];
```

### 方法二：检查 HeyGen 公开 Avatars

访问 HeyGen Labs 查看是否有公开的圣诞老人 Avatar 可以直接使用。

## 测试应用

### 功能检查清单

- [ ] 应用能正常启动
- [ ] 能够连接到 HeyGen API
- [ ] 摄像头权限已授予
- [ ] 麦克风权限已授予
- [ ] 能够开始语音对话
- [ ] Avatar 视频正常显示
- [ ] 能够进行实时对话
- [ ] 唇形同步正常工作

## 常见问题排查

### 1. "Failed to get access token" 错误

- 检查 `.env` 文件中的 `HEYGEN_API_KEY` 是否正确
- 确保 Next.js 服务器正在运行（API 路由需要服务器端执行）
- 确认 API Key 有效且有足够的配额
- 检查网络连接

### 2. 摄像头或麦克风不工作

- 在设备设置中检查应用权限
- 确认设备有可用的摄像头和麦克风
- 在 Chrome flags 中启用媒体设备（如果使用 WebView）

### 3. Avatar 视频不显示

- 检查网络连接
- 在 Chrome DevTools 中查看 Console 错误（使用 `chrome://inspect` 调试）
- 确认 Avatar ID 正确

### 4. 应用在 Android 设备上很慢

- 考虑降低 Avatar 质量设置（在 `components/InteractiveAvatar.tsx` 中的 `DEFAULT_CONFIG`）
- 确保设备有足够的内存和处理能力
- 检查网络带宽

## 开发调试

### 使用 Chrome DevTools 调试 Android WebView

1. 在 Android 设备上运行应用
2. 在电脑的 Chrome 浏览器中访问 `chrome://inspect`
3. 找到你的应用并点击 "inspect"
4. 使用 DevTools 查看 Console、Network 等

### 查看应用日志

```bash
adb logcat | grep -i "heygen"
```

## 更新应用

当你修改了代码后，需要重新构建和部署：

```bash
# 1. 构建 Next.js
npm run build

# 2. 同步到 Android
npx cap sync android

# 3. 在 Android Studio 中重新构建并运行
```

## 注意事项

### 安全性

- ✅ **安全改进**：API 密钥现在仅保存在服务端，永远不会暴露给客户端
- 这需要部署 Next.js 服务器而不是使用静态导出
- 对于 Android 部署，需要将 Next.js 应用部署到服务器并让 Android 应用连接到它
- 考虑使用 API 限流和监控来防止滥用

### 性能

- 大屏幕设备可能需要更多的内存和处理能力
- 建议在实际设备上进行充分测试
- 可以根据设备性能调整 Avatar 质量设置

### 网络

- 应用需要稳定的网络连接
- 建议使用有线连接或高质量的 WiFi
- 确保防火墙允许 WebRTC 连接

## 联系支持

如果遇到问题：

- HeyGen 文档：https://docs.heygen.com/
- HeyGen SDK Issues：https://github.com/HeyGen-Official/StreamingAvatarSDK/issues
- Capacitor 文档：https://capacitorjs.com/docs

## 项目交付清单

- [ ] APK 文件已构建并测试
- [ ] 在目标设备（75 英寸竖屏）上测试通过
- [ ] 摄像头和麦克风功能正常
- [ ] 圣诞老人角色配置完成
- [ ] 应用在 Kiosk 模式下运行稳定
- [ ] 提供了安装和使用说明
- [ ] 配置了适合小学生的对话内容和语气
