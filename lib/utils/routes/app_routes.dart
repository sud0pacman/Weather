import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_now/presentation/screens/locations/locations_screen.dart';

import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/search/search_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String search = '/search';
  static String locations = '/locations';

  static List<GetPage> routes = [
    GetPage(
      name: home,
      page: () => HomeScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: search,
      page: () => const SearchScreen(),
      customTransition: CustomSearchTransition(),
    ),
    GetPage(
      name: locations,
      page: () => const LocationsScreen(),
      customTransition: CustomSearchTransition(),
    ),
  ];
}


class CustomSearchTransition extends CustomTransition {
  @override
  Widget buildTransition(
      BuildContext context,
      Curve? curve,
      Alignment? alignment,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: curve ?? Curves.easeInOut,
        ),
      ),
      child: child,
    );
  }
}
