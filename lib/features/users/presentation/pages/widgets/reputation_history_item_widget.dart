import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sof/core/res/const_text_styles.dart';
import 'package:sof/core/util/bloc/language/language_cubit.dart';
import 'package:sof/core/util/lang/app_localization_keys.dart';
import 'package:sof/core/widgets/base_stateless_widget.dart';
import 'package:sof/features/common/text_widget.dart';
import 'package:sof/features/users/data/models/reputation_history_item.dart';

class ReputationHistoryItemWidget extends BaseStatelessWidget {
  final ReputationHistoryItem item;

  ReputationHistoryItemWidget({super.key, required this.item});

  @override
  Widget baseBuild(BuildContext context) {
    final isArabic = context.read<LanguageCubit>().state.languageCode == "ar";
    final dateFormat = DateFormat(
      isArabic ? "dd MMMM yyyy، HH:mm a" : "dd MMMM yyyy, HH:mm a",
      isArabic ? 'ar' : 'en',
    );
    final dateString = item.creationDate != null
        ? dateFormat.format(
            DateTime.fromMillisecondsSinceEpoch(item.creationDate!.toInt() * 1000))
        : translate(LangKeys.unknown);

    final changeValue = item.reputationChange ?? 0;
    final changeText = changeValue >= 0
        ? '+${changeValue.toString()}'
        : changeValue.toString();

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextWidget(
                    text: item.reputationHistoryType ?? translate(LangKeys.unknown),
                    textStyle: getSemiBoldStyle(fontSize: FontSize.medium),
                  ),
                ),
                TextWidget(
                  text: changeText,
                  textStyle: getBoldStyle(
                    fontSize: FontSize.medium,
                    color: changeValue >= 0
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                TextWidget(
                  text: '${translate(LangKeys.createdAt)}: ',
                  textStyle: getRegularStyle(
                    fontSize: FontSize.smallText,
                  ),
                ),
                Expanded(
                  child: TextWidget(
                    text: dateString,
                    textStyle: getRegularStyle(
                      fontSize: FontSize.smallText,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
            if (item.postId != null) ...[
              SizedBox(height: 4.h),
              Row(
                children: [
                  TextWidget(
                    text: '${translate(LangKeys.postId)}: ',
                    textStyle: getRegularStyle(
                      fontSize: FontSize.smallText,
                    ),
                  ),
                  TextWidget(
                    text: item.postId.toString(),
                    textStyle: getRegularStyle(
                      fontSize: FontSize.smallText,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

