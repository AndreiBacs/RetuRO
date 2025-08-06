# Assets Folder

This folder contains all the static assets used in the RetuRO Flutter application.

## Folder Structure

- `images/` - Contains image files (PNG, JPG, SVG, etc.)
- `icons/` - Contains icon files and app icons
- `fonts/` - Contains custom font files (TTF, OTF)

## Usage

To use assets in your Flutter code:

1. Place your asset files in the appropriate subfolder
2. Update `pubspec.yaml` to include the assets
3. Reference assets in your code using the asset path

### Example

```dart
// For images
Image.asset('assets/images/logo.png')

// For icons
Icon(Icons.custom_icon)

// For fonts (after adding to pubspec.yaml)
Text(
  'Hello World',
  style: TextStyle(fontFamily: 'CustomFont'),
)
```

## Adding New Assets

1. Place your asset file in the appropriate subfolder
2. Update the `pubspec.yaml` file to include the new asset
3. Run `flutter pub get` to update the project
4. Use the asset in your code

## Supported Formats

- **Images**: PNG, JPG, JPEG, GIF, WebP, SVG
- **Icons**: PNG, SVG
- **Fonts**: TTF, OTF 