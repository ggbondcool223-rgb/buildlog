import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../db/db_manager.dart';
import '../../utils/index.dart';
import '../../utils/photo_helper.dart';

class BuildLogSettingsLogic extends GetxController {
  final DB _db = Get.find<DB>();

  final isClearing = RxBool(false);

  void onClearRecordsPressed() {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Clear'),
        content: const Text(
          'Are you sure you want to clear all log records? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              _clearAllRecords();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Future<void> _clearAllRecords() async {
    try {
      isClearing.value = true;

      final photosDeleted = await PhotoHelper.deleteAllPhotos();
      if (!photosDeleted) {
        print('Warning: Some photos may not be deleted');
      }

      await _db.deleteAllBuildLogs();

      isClearing.value = false;
      successToast('Cleared successfully');
    } catch (e) {
      isClearing.value = false;
      print('Error clearing records: $e');
      errorToast('Clear failed, please try again');
    }
  }
}
