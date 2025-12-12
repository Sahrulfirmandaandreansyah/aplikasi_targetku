import 'dart:io' if (dart.library.html) 'package:universal_html/html.dart' as html;

bool fileExistsSync(String? path) {
  if (path == null) {
    return false;
  }
  // For non-web platforms, use dart:io
  if (identical(0, 0.0)) { // This check is always true for Dart VM (non-web)
    return File(path).existsSync();
  } else {
    // For web, we can't directly check file system existence.
    // If the path is a URL, it might be valid. If it's a local path, it won't exist.
    // For simplicity, we assume if it's not a web library, it's a local file.
    // If _selectedImagePath is a web URL, existsSync() on web should always return true
    // as it's an external resource. If it's a local path from a picked file,
    // it will be a blob URL or similar, which cannot be checked with existsSync.
    // So, for web, if path is not null, we assume it's "accessible" or a valid reference.
    return path.isNotEmpty;
  }
}
