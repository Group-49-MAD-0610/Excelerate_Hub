# 📹 Quick Video Recording Commands

## For Android Device/Emulator

### Using ADB (Android Debug Bridge)
```bash
# Start recording (max 3 minutes)
adb shell screenrecord /sdcard/excelerate_demo.mp4

# Start recording with custom settings
adb shell screenrecord --size 1080x1920 --bit-rate 8000000 /sdcard/excelerate_demo.mp4

# Stop recording (Ctrl+C in terminal)
# Download the video
adb pull /sdcard/excelerate_demo.mp4 ./
```

### Using Android Studio
1. Open Android Studio
2. Start your emulator
3. Click the camera icon in emulator toolbar
4. Select "Record Screen"
5. Choose settings and start recording

## For iOS Device/Simulator

### Using iOS Device
1. Add Screen Recording to Control Center:
   - Settings > Control Center > Customize Controls
   - Add "Screen Recording"
2. Open Control Center and tap record button
3. Start demonstration
4. Stop recording from Control Center

### Using iOS Simulator
```bash
# Using Simulator menu
Device > Record Screen > Save to Desktop
```

### Using QuickTime Player (Mac)
1. Connect iPhone to Mac
2. Open QuickTime Player
3. File > New Movie Recording
4. Click dropdown next to record button
5. Select your iPhone as camera source

## For Desktop Recording

### Using OBS Studio (Free, Cross-platform)
1. Download from https://obsproject.com/
2. Add "Display Capture" source
3. Select your screen/window
4. Configure recording settings
5. Start recording

### Using macOS Built-in
```bash
# Screenshot app with screen recording
Cmd + Shift + 5
# Select record portion/entire screen
```

### Using Windows Built-in
```bash
# Xbox Game Bar
Win + G
# Click record button or Win + Alt + R
```

## Quick Mobile Recording Steps

### 1. Prepare Your Device
- Close unnecessary apps
- Ensure good battery level
- Clean screen for clear visibility
- Set Do Not Disturb mode

### 2. Test Your Flow
```
Login Screen → Enter credentials → Sign In
Home Screen → Explore dashboard → Navigate to Programs
Programs Screen → Browse tabs → Select program
Program Details → Review information → Navigate back
```

### 3. Record in One Take (2-3 minutes)
- Start recording
- Begin at login screen
- Follow the user journey
- Speak clearly if adding narration
- End at home screen or program details

### 4. Quick Upload Options
- **YouTube**: Upload as unlisted
- **Google Drive**: Share with view access
- **Direct file**: Email or cloud storage

## Example Terminal Commands for Android

```bash
# Ensure device is connected
adb devices

# Start high-quality recording
adb shell screenrecord --verbose --size 1080x1920 --bit-rate 12000000 /sdcard/excelerate_week2_demo.mp4

# In another terminal, when done (or Ctrl+C)
adb pull /sdcard/excelerate_week2_demo.mp4 ~/Desktop/

# Clean up device storage
adb shell rm /sdcard/excelerate_week2_demo.mp4
```

## Video Quality Settings

### High Quality
- Resolution: 1080x1920 (portrait) or 1920x1080 (landscape)
- Bitrate: 8-12 Mbps
- Frame rate: 30 FPS
- Format: MP4 (H.264)

### Quick & Easy
- Use device built-in screen recording
- Default settings usually work well
- Focus on smooth demonstration over perfect quality

## Time-Saving Tips

1. **Practice First**: Do a dry run without recording
2. **Script Key Points**: Know what to highlight
3. **Use Built-in Tools**: Device screen recording is easiest
4. **Keep It Simple**: Don't over-edit
5. **Upload Quickly**: Use cloud storage for fast sharing
