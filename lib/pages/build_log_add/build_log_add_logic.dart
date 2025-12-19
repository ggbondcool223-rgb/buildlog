import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../db/db_manager.dart';
import '../../db/build_log_entity.dart';
import '../../utils/index.dart';
import '../../utils/photo_helper.dart';

class BuildLogAddLogic extends GetxController {
  final DB _db = Get.find<DB>();

  final unit = RxString('');
  final projectName = RxString('');
  final projectSupervisor = RxString('');
  final supervisor = RxString('');
  final weather = RxInt(0);
  final notes = RxString('');
  final photoPath = RxString('');

  final isSaving = RxBool(false);

  void onCameraButtonPressed() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: Color(0xFF2196F3)),
                title: Text('Take Photo'),
                onTap: () {
                  Get.back();
                  _pickFromCamera();
                },
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.photo_library, color: Color(0xFF2196F3)),
                title: Text('Choose from Gallery'),
                onTap: () {
                  Get.back();
                  _pickFromGallery();
                },
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.close, color: Colors.grey),
                title: Text('Cancel'),
                onTap: () => Get.back(),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> _pickFromCamera() async {
    try {
      final status = await Permission.camera.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        errorToast('Please enable camera permission in settings');
        return;
      }

      final path = await PhotoHelper.pickFromCamera();
      if (path != null) {
        photoPath.value = path;
        successToast('Photo added');
      }
    } catch (e) {
      print('Error picking from camera: $e');
      errorToast('Photo loading failed, please try again');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final status = await Permission.photos.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        errorToast('Please enable photo library permission in settings');
        return;
      }

      final path = await PhotoHelper.pickFromGallery();
      if (path != null) {
        photoPath.value = path;
        successToast('Photo added');
      }
    } catch (e) {
      print('Error picking from gallery: $e');
      errorToast('Photo loading failed, please try again');
    }
  }

  Future<void> onAddButtonPressed() async {
    if (unit.value.trim().isEmpty) {
      errorToast('Please fill in Unit');
      return;
    }
    if (projectName.value.trim().isEmpty) {
      errorToast('Please fill in Project Name');
      return;
    }
    if (projectSupervisor.value.trim().isEmpty) {
      errorToast('Please fill in Project Supervisor');
      return;
    }
    if (supervisor.value.trim().isEmpty) {
      errorToast('Please fill in Supervisor');
      return;
    }

    try {
      isSaving.value = true;

      final now = DateTime.now();
      final log = BuildLogEntity(
        unit: unit.value.trim(),
        projectName: projectName.value.trim(),
        projectSupervisor: projectSupervisor.value.trim(),
        supervisor: supervisor.value.trim(),
        weather: weather.value,
        photoPath: photoPath.value,
        notes: notes.value.trim(),
        date: getDateString(now),
        createTime: now.millisecondsSinceEpoch,
      );

      await _db.insertBuildLog(log);

      isSaving.value = false;
      successToast('Log added successfully');

      Get.back(result: true);
    } catch (e) {
      isSaving.value = false;
      print('Error saving log: $e');
      errorToast('Save failed, please try again');
    }
  }

  @override
  void onClose() {
    unit.value = '';
    projectName.value = '';
    projectSupervisor.value = '';
    supervisor.value = '';
    weather.value = 0;
    notes.value = '';
    photoPath.value = '';
    super.onClose();
  }
}
