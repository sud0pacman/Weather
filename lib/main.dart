import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:weather_now/utils/app/app_initializer.dart';
import 'package:weather_now/utils/app_preferences/app_preference.dart';
import 'package:weather_now/utils/extensions/extensions.dart';
import 'package:weather_now/utils/routes/app_routes.dart';
import 'package:weather_now/utils/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await initDependencies();
  await GetStorage().initStorage;
  runApp(AppWidget());
}

class AppWidget extends StatelessWidget {
  final preferences = inject<AppPreferences>();

  AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: preferences.themeListenable(),
      builder: (context, value, child) {
        return ScreenUtilInit(
            useInheritedMediaQuery: false,
            designSize: const Size(375, 812),
            builder: (context, child) {
              return GetMaterialApp(
                title: 'Interview Task for Dynamic Soft',
                debugShowCheckedModeBanner: false,
                themeMode: ThemeMode.dark,
                theme: AppTheme.theme,
                darkTheme: AppTheme.darkTheme,
                initialRoute: AppRoutes.home,
                // initialBinding: AppBindings(),
                getPages: AppRoutes.routes,
                fallbackLocale: const Locale('en', 'EN'),
                locale: Locale(preferences.lang ?? 'en'),
                // translations: AppTranslation(),
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler: const TextScaler.linear(1.0),
                    ),
                    child: child ?? Container(),
                  );
                },
                // home: const HomeScreen(),
              );
            });
      },
    );
  }
}