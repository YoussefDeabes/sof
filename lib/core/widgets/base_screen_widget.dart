import 'package:flutter/material.dart';
import 'package:sof/core/widgets/base_stateful_widget.dart';

/// BaseState screenCreateState();
abstract class BaseScreenWidget extends BaseStatefulWidget {
  const BaseScreenWidget({super.key, super.backGroundColor});

  @override
  BaseState baseCreateState() => screenCreateState();

  BaseState screenCreateState();
}

/// buildScreenWidget
abstract class BaseScreenState<W extends BaseScreenWidget>
    extends BaseState<W> {
  @override
  Widget baseBuild(BuildContext context) {
    return buildScreenWidget(context);
  }

  Widget buildScreenWidget(BuildContext context);
}
