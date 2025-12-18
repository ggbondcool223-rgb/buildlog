import 'package:get/get.dart';
import 'build_log_home_logic.dart';

class BuildLogHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BuildLogHomeLogic());
  }
}
