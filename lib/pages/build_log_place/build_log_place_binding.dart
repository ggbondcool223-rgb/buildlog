import 'package:get/get.dart';

import 'build_log_place_logic.dart';

class BuildLogPlaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      BuildLogPlaceLogic(),
      permanent: true,
    );
  }
}
