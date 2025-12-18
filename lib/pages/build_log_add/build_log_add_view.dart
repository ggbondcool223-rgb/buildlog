import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../components/text_field.dart';
import 'build_log_add_logic.dart';

class BuildLogAddView extends GetView<BuildLogAddLogic> {
  const BuildLogAddView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Add Log'),
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
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPhotoSection(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Divider(color: Color(0xFFEFEFEF), height: 1.h),
                    ),
                    _buildInputSection(),
                  ],
                ),
              ),
            ),
            _buildAddButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Construction Photo',
            style: TextStyle(
              color: const Color(0xFF999999),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 12.h),
          Obx(() {
            final hasPhoto = controller.photoPath.value.isNotEmpty;
            return GestureDetector(
              onTap: () => controller.onCameraButtonPressed(),
              child: Container(
                width: 90.w,
                height: 90.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8.r),
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
                        child: Image.asset(
                          'assets/icon_camera.png',
                          width: 36.w,
                          height: 36.h,
                        ),
                      ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildInputRow('Unit', controller.unit),
          _buildDivider(),
          _buildInputRow('Project Name', controller.projectName),
          _buildDivider(),
          _buildInputRow('Project Supervisor', controller.projectSupervisor),
          _buildDivider(),
          _buildInputRow('Supervisor', controller.supervisor),
          _buildDivider(),
          _buildWeatherRow(controller.weather),
          _buildDivider(),
          _buildNotesField(controller.notes),
        ],
      ),
    );
  }

  Widget _buildInputRow(String label, RxString value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Obx(
              () => MyTextField(
                value: value.value,
                onChange: (text) => value.value = text,
                hintText: 'Input',
                textAlign: TextAlign.right,
                padding: EdgeInsets.only(left: 16.w),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherRow(RxInt value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      child: Row(
        children: [
          Text(
            'Weather',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Obx(
              () => MyTextField(
                value: value.value == 0 ? '' : value.value.toString(),
                onChange: (text) {
                  final intValue = int.tryParse(text);
                  if (intValue != null) {
                    value.value = intValue;
                  } else if (text.isEmpty) {
                    value.value = 0;
                  }
                },
                hintText: 'Input',
                textAlign: TextAlign.right,
                padding: EdgeInsets.only(left: 16.w),
                isInteger: true,
                keyboardType: TextInputType.number,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesField(RxString value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Log Notes',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12.h),
          Obx(
            () => MyTextField(
              value: value.value,
              onChange: (text) => value.value = text,
              hintText: 'Input',
              maxLines: 6,
              minLines: 6,
              padding: EdgeInsets.all(12.w),
              bgColor: const Color(0xFFF5F5F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w),
      child: Divider(
        height: 1.h,
        thickness: 1.h,
        color: const Color(0xFFEFEFEF),
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      color: Colors.white,
      child: ElevatedButton(
        onPressed: () => controller.onAddButtonPressed(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2196F3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.h),
          elevation: 0,
        ),
        child: Text(
          'Add',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
