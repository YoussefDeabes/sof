import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sof/core/res/const_colors.dart';
import 'package:sof/core/res/const_text_styles.dart';
import 'package:sof/core/util/bloc/language/language_cubit.dart';
import 'package:sof/core/widgets/base_stateless_widget.dart';
import 'package:sof/features/common/text_widget.dart';

/// choose the language button and it's popUps
/// ignore: must_be_immutable
class ChooseLanguageWidget extends BaseStatelessWidget {
  final void Function()? onLanguageChanged;

  ChooseLanguageWidget({this.onLanguageChanged, super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return BlocConsumer<LanguageCubit, Locale>(
      listener: (context, state) {
        if (onLanguageChanged != null) {
          onLanguageChanged!();
        }
      },
      builder: (context, state) {
        LanguageCubit languageCubit = context.watch<LanguageCubit>();
        return TextButton(
          onPressed: () {
            languageCubit.switchLanguage();
          },
          child: TextWidget(
            text: _getCurrentLanguageUserChoose(
              languageCubit.state.languageCode,
            ),
            textStyle: getSemiBoldStyle(
              fontSize: FontSize.medium,
              color: ConstColors.app,
            ),
          ),
        );
      },
    );
  }

  String _getCurrentLanguageUserChoose(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return "English";
      case 'en':
        return "العربية";
      default:
        return "English";
    }
  }
}
