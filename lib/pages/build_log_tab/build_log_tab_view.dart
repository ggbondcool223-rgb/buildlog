import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'build_log_tab_logic.dart';
import '../build_log_home/build_log_home_view.dart';
import '../build_log_settings/build_log_settings_view.dart';

class BuildLogTabView extends GetView<BuildLogTabLogic> {
  const BuildLogTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pages = [
      const BuildLogHomeView(),
      Container(),
      const BuildLogSettingsView(),
    ];

    return Obx(() {
      return Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      );
    });
  }

  Widget _buildBottomNavigationBar() {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60.h,
            child: Row(
              children: [
                _buildTabItem(
                  index: 0,
                  label: 'Home',
                  currentIndex: controller.currentIndex.value,
                  onTap: () => controller.changePage(0),
                ),
                _buildTabItem(
                  index: 1,
                  label: 'Add Log',
                  currentIndex: controller.currentIndex.value,
                  onTap: () {
                    Get.toNamed('/build_add_log')?.then((result) {
                      if (result == true) {
                        controller.refreshHomeData();
                      }
                    });
                  },
                ),
                _buildTabItem(
                  index: 2,
                  label: 'Settings',
                  currentIndex: controller.currentIndex.value,
                  onTap: () => controller.changePage(2),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTabItem({
    required int index,
    required String label,
    required int currentIndex,
    required VoidCallback onTap,
  }) {
    final isSelected = currentIndex == index;

    IconData icon;
    if (index == 0) {
      icon = isSelected ? Icons.home : Icons.home_outlined;
    } else if (index == 1) {
      icon = Icons.add_circle;
    } else {
      icon = isSelected ? Icons.settings : Icons.settings_outlined;
    }

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: index == 1 ? 32.sp : 24.sp,
              color: isSelected || index == 1
                  ? const Color(0xFF2196F3)
                  : Colors.grey.shade400,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: isSelected || index == 1
                    ? const Color(0xFF2196F3)
                    : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
