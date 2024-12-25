import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../components/shape.dart';

class HomeShimmers {
  static Widget mainIconShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.1),
      highlightColor: Colors.grey,
      child: AppGenericShape(
        cornerRadius: 25,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
    );
  }

  static hourlyForecastShimmer() {
    return SizedBox(
      height: 80,
      child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return AppGenericShape(
                cornerRadius: 25,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(0.3),
                  highlightColor: Colors.grey,
                  child: Container(
                    width: 150,
                    height: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ));
          },
          separatorBuilder: (context, index) {
            return const SizedBox(width: 12);
          },
          itemCount: 5),
    );
  }

  static dailyForecastShimmer() {
    return ListView.separated(
        padding: const EdgeInsets.only(top: 16),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: AppGenericShape(
                cornerRadius: 20,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(0.4),
                  highlightColor: Colors.grey,
                  child: Container(
                      height: 100,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1)),
                      child: const SizedBox()
                  ),
                )),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 12);
        },
        itemCount: 3
    );
  }
}