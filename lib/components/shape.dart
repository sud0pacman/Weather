import 'package:flutter/material.dart';

class AppGenericShape extends StatelessWidget {
  final double cornerRadius;
  final Widget child;

  const AppGenericShape({super.key, required this.cornerRadius, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _GenericShapeClipper(cornerRadius: cornerRadius),
      child: child,
    );
  }
}

class _GenericShapeClipper extends CustomClipper<Path> {
  final double cornerRadius;

  _GenericShapeClipper({required this.cornerRadius});

  @override
  Path getClip(Size size) {
    final path = Path();

    // Only add curves if the cornerRadius is greater than 0
    if (cornerRadius > 0) {
      path
        ..moveTo(cornerRadius, 0)
        ..quadraticBezierTo(0, 0, 0, cornerRadius) // Top-left curve
        ..lineTo(0, size.height - cornerRadius)
        ..quadraticBezierTo(0, size.height, cornerRadius, size.height) // Bottom-left curve
        ..lineTo(size.width - cornerRadius, size.height)
        ..quadraticBezierTo(size.width, size.height, size.width, size.height - cornerRadius) // Bottom-right curve
        ..lineTo(size.width, cornerRadius)
        ..quadraticBezierTo(size.width, 0, size.width - cornerRadius, 0) // Top-right curve
        ..close();
    } else {
      // If cornerRadius is 0, just use a simple rectangle (no curves)
      path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return oldClipper is _GenericShapeClipper && oldClipper.cornerRadius != cornerRadius;
  }
}