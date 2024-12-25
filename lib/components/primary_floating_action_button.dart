import 'package:flutter/material.dart';
import 'package:weather_now/utils/theme/colors.dart';

import '../utils/theme/app_button_style.dart';

class PrimaryFloatingActionButton extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final bool isVisible;
  final Duration duration;
  const PrimaryFloatingActionButton({super.key, this.onTap, required this.icon, required this.isVisible, required this.duration});

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: duration,
      offset: isVisible ? Offset.zero : const Offset(0, 2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(27),
        child: IconButton(
          style: kButtonTransparentStyle.copyWith(
            padding: const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.zero),
          ),
          onPressed: onTap,
          icon: Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent.withOpacity(0.95),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.white,),
          ),
        ),
      ),
    );
  }
}
