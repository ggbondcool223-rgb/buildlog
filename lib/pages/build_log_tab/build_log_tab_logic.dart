import 'package:get/get.dart';
import '../build_log_home/build_log_home_logic.dart';

class BuildLogTabLogic extends GetxController {
  final currentIndex = RxInt(0);

  void changePage(int index) {
    currentIndex.value = index;
  }

  void refreshHomeData() {
    try {
      final homeLogic = Get.find<BuildLogHomeLogic>();
      homeLogic.refreshData();
    } catch (e) {
      print('Error refreshing home data: $e');
    }
  }
}
