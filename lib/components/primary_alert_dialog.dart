import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_now/utils/theme/app_text_styles.dart';
import 'package:weather_now/utils/theme/colors.dart';

class PrimaryAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onTapOk;

  const PrimaryAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onTapOk,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: AlertDialog(
        backgroundColor: AppColors.dialog,
        title: Text(
          title,
          style: sfbold.copyWith(color: AppColors.secondaryText, fontSize: 24),
        ),
        content: Text(
          content,
          style:
              sfmedium.copyWith(color: AppColors.secondaryText, fontSize: 16),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              "Cancel",
              style: sfsemiBold.copyWith(color: AppColors.white, fontSize: 16),
            ),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            onPressed: onTapOk,
            child: Text(
              "Ok",
              style: sfsemiBold.copyWith(color: AppColors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
