import 'package:flutter/material.dart';
import 'package:sof/core/util/ui/loading_manager.dart';
import 'package:sof/core/util/ui/platform_manager.dart';
import 'package:sof/core/util/ui/screen_sizer.dart';
import 'package:sof/core/util/ui/themer.dart';
import 'package:sof/core/util/ui/translator.dart';

abstract class BaseStatefulWidget extends StatefulWidget {
  final Color? backGroundColor;

  const BaseStatefulWidget({
    this.backGroundColor,
    super.key,
  });

  @override
  BaseState createState() {
    return baseCreateState();
  }

  BaseState baseCreateState();
}

abstract class BaseState<W extends BaseStatefulWidget> extends State<W>
    with Translator, ScreenSizer, Themer, LoadingManager, PlatformManager {
  @override
  Widget build(BuildContext context) {
    initTranslator(context);
    initScreenSizer(context);
    initThemer(context);
    return baseWidget();
  }

  Widget baseWidget() {
    return Material(
      color: widget.backGroundColor,
      child: Stack(
        children: [baseBuild(context), loadingManagerWidget()],
      ),
    );
  }

  void changeState() {
    setState(() {});
  }

  @override
  void runChangeState() {
    changeState();
  }

  @override
  BaseState provideTranslate() {
    return this;
  }

  Widget baseBuild(BuildContext context);
}

