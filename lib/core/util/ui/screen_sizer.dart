import 'package:flutter/material.dart';

mixin ScreenSizer {
  late double height;
  late double width;
  late Orientation orientation;

  void initScreenSizer(BuildContext context) {
    var mediaQueryData = MediaQuery.sizeOf(context);
    width = mediaQueryData.width;
    height = mediaQueryData.height;
    orientation = MediaQuery.orientationOf(context);
  }

  double width10() => width * 10 / 100;

  bool isPortrait() => orientation == Orientation.portrait;

  bool isLandscape() => orientation == Orientation.landscape;

  bool isWebOrDesktopSize() => width >= 1000;

  bool isTabletSize() => width >= 600;

  bool isPassedMinHeight() => height > 500;

  bool isPassedMinSizeForWeb() => isWebOrDesktopSize() && isPassedMinHeight();
}

