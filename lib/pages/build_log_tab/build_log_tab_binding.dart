import 'package:get/get.dart';
import 'build_log_tab_logic.dart';
import '../build_log_home/build_log_home_logic.dart';
import '../build_log_settings/build_log_settings_logic.dart';

class BuildLogTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BuildLogTabLogic());
    Get.lazyPut(() => BuildLogHomeLogic());
    Get.lazyPut(() => BuildLogSettingsLogic());
  }
}

