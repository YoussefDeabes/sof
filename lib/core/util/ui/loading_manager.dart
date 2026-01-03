import 'package:flutter/material.dart';
import 'package:sof/core/util/lang/app_localization_keys.dart';
import 'package:sof/core/util/ui/custom_loading_widget.dart';
import 'package:sof/core/util/ui/translator.dart';

mixin LoadingManager {
  void runChangeState();

  Translator provideTranslate();

  late String message;
  bool isLoading = false;
  bool isLoadingWithMessage = false;

  void showLoading() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!isLoading) {
      isLoading = true;
      runChangeState();
    }
  }

  void hideLoading() async {
    if (isLoading) {
      isLoading = false;
      runChangeState();
    }
  }

  void showMessageLoading(String? message) async {
    this.message = message ?? plzWaitMsg();
    if (!isLoadingWithMessage) {
      isLoadingWithMessage = true;
      runChangeState();
    }
  }

  void hideMessageLoading() async {
    if (isLoadingWithMessage) {
      isLoadingWithMessage = false;
      runChangeState();
    }
  }

  Widget loadingManagerWidget() {
    if (isLoading) {
      return customLoadingWidget();
    } else if (isLoadingWithMessage) {
      return customLoadingMessageWidget(message);
    } else {
      return getEmptyWidget();
    }
  }

  Widget customLoadingWidget() => const CustomLoadingWidget();

  Widget customLoadingMessageWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(message),
        ],
      ),
    );
  }

  String plzWaitMsg() => provideTranslate().translate(LangKeys.pleaseWait);
}

Widget getEmptyWidget() {
  return const SizedBox.shrink();
}

