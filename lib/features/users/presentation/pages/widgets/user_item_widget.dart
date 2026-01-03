import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sof/core/res/const_text_styles.dart';
import 'package:sof/core/util/lang/app_localization_keys.dart';
import 'package:sof/core/widgets/base_stateless_widget.dart';
import 'package:sof/features/common/text_widget.dart';
import 'package:sof/features/users/data/models/user_wrapper.dart';

class UserItemWidget extends BaseStatelessWidget {
  final UserWrapper user;
  final VoidCallback onTap;
  final VoidCallback onBookmarkTap;
  final bool isBookmarked;

  UserItemWidget({
    super.key,
    required this.user,
    required this.onTap,
    required this.onBookmarkTap,
    required this.isBookmarked,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              if (user.profileImage != null)
                CircleAvatar(
                  radius: 30.r,
                  backgroundImage: NetworkImage(user.profileImage!),
                )
              else
                CircleAvatar(
                  radius: 30.r,
                  child: const Icon(Icons.person),
                ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: user.displayName ?? translate(LangKeys.unknown),
                      textStyle: getSemiBoldStyle(fontSize: FontSize.medium),
                    ),
                    SizedBox(height: 4.h),
                    TextWidget(
                      text:
                          '${translate(LangKeys.reputation)}: ${user.reputation ?? 0}',
                      textStyle: getRegularStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: isBookmarked
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
                onPressed: onBookmarkTap,
                tooltip: isBookmarked
                    ? translate(LangKeys.removeBookmark)
                    : translate(LangKeys.addBookmark),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
