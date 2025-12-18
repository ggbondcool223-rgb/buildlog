import 'package:get/get.dart';
import 'build_log_detail_logic.dart';

class BuildLogDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BuildLogDetailLogic());
  }
}
