import 'package:flutter/material.dart';
import 'package:sof/core/util/lang/app_localization.dart';

/// Always keep in mind that mixin is not multiple inheritance instead
/// they are just a way to reuse our code from a class in multiple hierarchies
/// without needing to extend them.
/// Its like being able to use other people assets without being their children.

mixin Translator {
  late AppLocalizations appLocal;

  void initTranslator(BuildContext context) {
    appLocal = AppLocalizations.of(context);
  }

  String translate(String key) {
    return appLocal.translate(key);
  }
}

