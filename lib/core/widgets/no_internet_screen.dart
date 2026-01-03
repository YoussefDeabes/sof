import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sof/core/res/const_colors.dart';
import 'package:sof/core/res/const_text_styles.dart';
import 'package:sof/core/util/lang/app_localization.dart';
import 'package:sof/core/util/lang/app_localization_keys.dart';
import 'package:sof/features/common/text_widget.dart';

/// Full-screen blocking screen shown when there's no internet connection.
/// This screen replaces the entire app and blocks all user interaction.
class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Icon(
                  Icons.wifi_off_rounded,
                  size: 120.sp,
                  color: ConstColors.error,
                ),
                SizedBox(height: 32.h),

                // Title
                TextWidget(
                  text: AppLocalizations.of(context)
                      .translate(LangKeys.noInternetConnection),
                  textStyle: getBoldStyle(
                    fontSize: FontSize.title,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),

                // Description
                TextWidget(
                  text: AppLocalizations.of(context)
                      .translate(LangKeys.youAreCurrentlyOffline),
                  textStyle: getRegularStyle(
                    fontSize: FontSize.medium,
                    color: Theme.of(context).colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

