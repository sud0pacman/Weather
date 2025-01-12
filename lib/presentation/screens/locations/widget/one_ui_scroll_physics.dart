import 'package:flutter/cupertino.dart';

class OneUiScrollPhysics extends ScrollPhysics {
  final double expendedHeight;

  const OneUiScrollPhysics(this.expendedHeight, {ScrollPhysics? parent})
      : super(parent: parent);

  @override
  ScrollPhysics applyTo(ScrollPhysics? ancestor) {
    assert(ancestor != null);
    return OneUiScrollPhysics(expendedHeight, parent: buildParent(ancestor));
  }

  @override
  createBallisticSimulation(ScrollMetrics position, double velocity) {
    if (velocity == 0.0 ||
        (velocity > 0.0 && position.pixels >= position.maxScrollExtent) ||
        (velocity < 0.0 && position.pixels <= position.minScrollExtent)) {
      return null;
    }

    return OneUiScrollSimulation(position.pixels, velocity, expandedHeight: expendedHeight);
  }
}

class OneUiScrollSimulation extends ClampingScrollSimulation {
  final double expandedHeight;

  OneUiScrollSimulation(double position, double velocity,
      {required this.expandedHeight,
      double friction = 0.015,
      Tolerance tolerance = Tolerance.defaultTolerance})
      : super(
            position: position,
            velocity: velocity,
            tolerance: tolerance,
            friction: friction) {
    assert(expandedHeight >= 0);
  }

  @override
  double x(double time) {
    final double x = super.x(time);

    return x < 0.0 ? 0.0 : (x > expandedHeight ? expandedHeight : x);
  }

  @override
  bool isDone(double time) => super.isDone(time) || position >= expandedHeight;
}
