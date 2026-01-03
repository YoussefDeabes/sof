import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sof/core/res/const_colors.dart';
import 'package:sof/core/res/const_text_styles.dart';
import 'package:sof/core/util/helpers/route_manager.dart';
import 'package:sof/features/common/text_widget.dart';

void showToast(String message, {bool? success}) {
  final overlay = navigatorKey.currentState?.overlay;
  if (overlay == null) return;

  HapticFeedback.heavyImpact();

  final entry = OverlayEntry(
    builder: (_) => Positioned(
      top: 60,
      left: 20,
      right: 20,
      child: Material(
        color: ConstColors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: ConstColors.white,
            border: Border.all(
              color: success == true ? ConstColors.success : ConstColors.error,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                success == true ? Icons.check_circle : Icons.error_outline,
                color: success == true
                    ? ConstColors.success
                    : ConstColors.error,
                size: 22.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: TextWidget(
                  text: message,
                  textStyle: getSemiBoldStyle(
                    fontSize: FontSize.kindaSmall,
                    color: success == true
                        ? ConstColors.success
                        : ConstColors.error,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  overlay.insert(entry);
  Future.delayed(const Duration(seconds: 5)).then((_) => entry.remove());
}
