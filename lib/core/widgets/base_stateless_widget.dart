import 'package:flutter/material.dart';
import 'package:sof/core/util/ui/platform_manager.dart';
import 'package:sof/core/util/ui/screen_sizer.dart';
import 'package:sof/core/util/ui/themer.dart';
import 'package:sof/core/util/ui/translator.dart';

// ignore: must_be_immutable
abstract class BaseStatelessWidget extends StatelessWidget
    with Translator, ScreenSizer, Themer, PlatformManager {
  BaseStatelessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    initTranslator(context);
    initScreenSizer(context);
    initThemer(context);
    return baseBuild(context);
  }

  Widget baseBuild(BuildContext context);
}
