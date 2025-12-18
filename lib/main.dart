import 'package:build_log/pages/build_log_add/build_log_add_binding.dart';
import 'package:build_log/pages/build_log_add/build_log_add_view.dart';
import 'package:build_log/pages/build_log_detail/build_log_detail_binding.dart';
import 'package:build_log/pages/build_log_detail/build_log_detail_view.dart';
import 'package:build_log/pages/build_log_home/build_log_home_binding.dart';
import 'package:build_log/pages/build_log_home/build_log_home_view.dart';
import 'package:build_log/pages/build_log_settings/build_log_settings_binding.dart';
import 'package:build_log/pages/build_log_settings/build_log_settings_view.dart';
import 'package:build_log/pages/build_log_tab/build_log_tab_binding.dart';
import 'package:build_log/pages/build_log_tab/build_log_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'db/db_manager.dart';


Color primaryColor = const Color(0xFF2196F3);
Color bgColor = const Color(0xFFE3F2FD);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Get.putAsync(() => DB().init());

  runApp(const MyApp());
}

List<GetPage<dynamic>> Log = [
  GetPage(
    name: '/build_tab',
    page: () => const BuildLogTabView(),
    binding: BuildLogTabBinding(),
  ),
  GetPage(
    name: '/build_home',
    page: () => const BuildLogHomeView(),
    binding: BuildLogHomeBinding(),
  ),
  GetPage(
    name: '/build_add_log',
    page: () => const BuildLogAddView(),
    binding: BuildLogAddBinding(),
  ),
  GetPage(
    name: '/build_log_detail',
    page: () => const BuildLogDetailView(),
    binding: BuildLogDetailBinding(),
  ),
  GetPage(
    name: '/build_settings',
    page: () => const BuildLogSettingsView(),
    binding: BuildLogSettingsBinding(),
  ),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          getPages: Log,
          initialRoute: '/build_tab',
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: primaryColor,
            scaffoldBackgroundColor: bgColor,
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              surface: Color(0xFFFFFFFF),
            ),
            appBarTheme: const AppBarTheme(
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF0F0F0F),
              ),
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(size: 22, color: Color(0xFF0F0F0F)),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: Color(0xFF2196F3),
              unselectedItemColor: Color(0xFF292929),
              elevation: 0,
              backgroundColor: Color(0xFFFFFFFF),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            dividerTheme: DividerThemeData(
              thickness: 1,
              color: Colors.grey[200],
            ),
          ),
        );
      },
    );
  }
}
