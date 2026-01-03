import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;

mixin PlatformManager {
  bool isOnWeb() => kIsWeb;

  bool isOnMobile() {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        return true;
      }
    } catch (e) {}
    return false;
  }

  bool isOnDeskTop() {
    try {
      if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
        return true;
      }
    } catch (e) {}
    return false;
  }

  bool isOnAndroid() {
    try {
      if (Platform.isAndroid) {
        return true;
      }
    } catch (e) {}
    return false;
  }

  bool isOnIOS() {
    try {
      if (Platform.isIOS) {
        return true;
      }
    } catch (e) {}
    return false;
  }
}

