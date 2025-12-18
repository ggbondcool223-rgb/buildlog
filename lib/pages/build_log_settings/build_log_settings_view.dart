import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'build_log_settings_logic.dart';

class BuildLogSettingsView extends GetView<BuildLogSettingsLogic> {
  const BuildLogSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFCCEBFF), Color(0xFFF4F4F4)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 16.h),

              _buildSettingsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingItem(
            'Clear Records',
            onTap: () => controller.onClearRecordsPressed(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Divider(height: 1.h, color: Colors.grey[200]),
          ),
          _buildSettingItem('Version', onTap: () {}, text: '1.0.0'),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    String title, {
    String? text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16.sp, color: Colors.black),
                ),
                text != null
                    ? Text(
                        text,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      )
                    : Icon(
                        Icons.arrow_forward_ios,
                        size: 16.w,
                        color: Colors.grey[400],
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
