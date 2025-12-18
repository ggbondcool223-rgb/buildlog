import 'package:get/get.dart';
import 'build_log_settings_logic.dart';

class BuildLogSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BuildLogSettingsLogic());
  }
}
