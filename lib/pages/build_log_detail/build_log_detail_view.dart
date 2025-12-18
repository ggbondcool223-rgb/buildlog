import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'build_log_detail_logic.dart';

class BuildLogDetailView extends GetView<BuildLogDetailLogic> {
  const BuildLogDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf7f7f7),
      appBar: AppBar(
        title: Obx(
          () =>
              Text('${controller.date.value} ${controller.projectName.value}'),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: _buildLogTable(),
              ),
            ),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogTable() {
    return Obx(() {
      return Column(
        children: [
          Text(
            'Construction Log',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400, width: 1),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Column(
              children: [
                _buildTableRow(
                  'Unit',
                  controller.unit.value,
                  isFullWidth: true,
                ),
                _buildDivider(),
                _buildTableRow(
                  'Project Name',
                  controller.projectName.value,
                  isFullWidth: true,
                ),
                _buildDivider(),
                _buildTableRow(
                  'Project Supervisor',
                  controller.projectSupervisor.value,
                  isFullWidth: true,
                ),
                _buildDivider(),
                _buildTableRow(
                  'Supervisor',
                  controller.supervisor.value,
                  isFullWidth: true,
                ),
                _buildDivider(),
                _buildTableRow(
                  'Weather',
                  '${controller.weather.value}℃',
                  isFullWidth: true,
                ),
                _buildDivider(),
                _buildTableRow(
                  'Date',
                  controller.date.value,
                  isFullWidth: true,
                ),
                _buildDivider(),
                _buildPhotoRow(),
                _buildDivider(),
                _buildNotesRow(controller.notes.value),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildTableRow(
    String label,
    String value, {
    bool isFullWidth = false,
  }) {
    return Row(
      children: [
        Container(
          width: 104.w,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border(
              right: BorderSide(color: Colors.grey.shade400, width: 1),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoRow() {
    return Obx(() {
      final hasPhoto =
          controller.photoPath.value.isNotEmpty &&
          File(controller.photoPath.value).existsSync();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
            decoration: BoxDecoration(color: Colors.grey.shade100),
            child: Text(
              'Construction Photo',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
            child: Container(
              width: double.infinity,
              height: 180.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4.r),
                image: hasPhoto
                    ? DecorationImage(
                        image: FileImage(File(controller.photoPath.value)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: hasPhoto
                  ? null
                  : Center(
                      child: Text(
                        'No Photo',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildNotesRow(String notes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
          decoration: BoxDecoration(color: Colors.grey.shade100),
          child: Text(
            'Log Notes',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
          child: Text(
            notes,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 1, color: Colors.grey.shade400);
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => controller.onPrintPressed(),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF2196F3), width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.h),
              ),
              child: Text(
                'Print',
                style: TextStyle(
                  color: const Color(0xFF2196F3),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: ElevatedButton(
              onPressed: () => controller.onSavePdfPressed(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                elevation: 0,
              ),
              child: Text(
                'Save PDF',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
