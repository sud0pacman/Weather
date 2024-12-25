import 'package:flutter/material.dart';

import 'colors.dart';

ButtonStyle kButtonTransparentStyle = const ButtonStyle(
  backgroundColor: WidgetStatePropertyAll(AppColors.transparent),
  shape: WidgetStatePropertyAll(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
    ),
  ),
  // overlayColor: WidgetStatePropertyAll(AppColors.overlay),
);
