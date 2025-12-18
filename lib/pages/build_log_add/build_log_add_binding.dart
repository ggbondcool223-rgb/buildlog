import 'package:get/get.dart';
import 'build_log_add_logic.dart';

class BuildLogAddBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BuildLogAddLogic());
  }
}
