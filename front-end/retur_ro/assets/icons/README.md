# Icons Folder

This folder contains icon files for the RetuRO Flutter application.

## App Icon

The main app icon should be placed as `app_icon.png` in this folder. This icon will be used by `flutter_launcher_icons` to generate platform-specific icons.

### Requirements for app_icon.png:

- **Size**: 1024x1024 pixels (recommended)
- **Format**: PNG with transparency support
- **Background**: Should work well on both light and dark backgrounds
- **Design**: Simple, recognizable, and scalable

## Usage

1. Place your `app_icon.png` file in this folder
2. Update the colors in `pubspec.yaml` if needed:
   - `background_color`: For web app background
   - `theme_color`: For web app theme color
3. Run the following command to generate icons:
   ```bash
   flutter pub get
   flutter pub run flutter_launcher_icons:main
   ```

## Generated Icons

After running the command, icons will be generated for:
- Android: Various densities in `android/app/src/main/res/`
- iOS: In `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
- Web: In `web/icons/`
- Windows: In `windows/runner/resources/`
- macOS: In `macos/Runner/Assets.xcassets/AppIcon.appiconset/`

## Customization

You can customize the icon generation by modifying the `flutter_launcher_icons` section in `pubspec.yaml`:

- Change icon names
- Adjust sizes
- Set different colors for web
- Configure platform-specific settings 