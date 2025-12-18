import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:intl/intl.dart';
import 'build_log_home_logic.dart';

class BuildLogHomeView extends GetView<BuildLogHomeLogic> {
  const BuildLogHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Construction Log'),
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildCalendarCard(),
                      SizedBox(height: 16.h),
                      _buildDailyRecords(),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          SizedBox(height: 4.h),
          _buildMonthSelector(),
          SizedBox(height: 12.h),
          Divider(color: Colors.grey.shade200, height: 1.h),
          SizedBox(height: 12.h),
          _buildCalendar(),
        ],
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Obx(() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                final current = DateFormat(
                  'yyyy-MM',
                ).parse(controller.month.value);
                final previous = DateTime(current.year, current.month - 1, 1);
                controller.updateMonth(DateFormat('yyyy-MM').format(previous));
              },
              child: Container(
                width: 30.w,
                height: 30.h,
                decoration: BoxDecoration(color: Colors.transparent),
                child: Center(
                  child: Image.asset(
                    'assets/icon_chevron_left.png',
                    width: 8.w,
                    height: 14.h,
                  ),
                ),
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: controller.month.value,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: '   Total ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: '${controller.totalCount.value}',
                    style: TextStyle(
                      color: const Color(0xFF2196F3),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: ' Items',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                final current = DateFormat(
                  'yyyy-MM',
                ).parse(controller.month.value);
                final next = DateTime(current.year, current.month + 1, 1);
                controller.updateMonth(DateFormat('yyyy-MM').format(next));
              },
              child: Container(
                width: 30.w,
                height: 30.h,
                decoration: BoxDecoration(color: Colors.transparent),
                child: Center(
                  child: Image.asset(
                    'assets/icon_chevron_right.png',
                    width: 8.w,
                    height: 14.h,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCalendar() {
    return Obx(() {
      final currentDate = DateFormat('yyyy-MM').parse(controller.month.value);

      final Map<DateTime, List<Event>> markedDates = {};
      controller.dateCountMap.forEach((dateStr, count) {
        try {
          final date = DateFormat('yyyy-MM-dd').parse(dateStr);
          markedDates[date] = [Event(date: date, title: count.toString())];
        } catch (e) {
          print('Error parsing date: $dateStr');
        }
      });

      return GestureDetector(
        onHorizontalDragUpdate: (_) {},
        child: CalendarCarousel<Event>(
          onDayPressed: (DateTime date, List<Event> events) {
            controller.updateDay(date);
          },
          weekendTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          thisMonthDayBorderColor: Colors.transparent,
          weekDayFormat: WeekdayFormat.short,
          height: 280.h,
          selectedDateTime: controller.day.value,
          targetDateTime: currentDate,
          daysHaveCircularBorder: true,
          selectedDayBorderColor: Colors.transparent,
          selectedDayButtonColor: const Color(0xFF2196F3),
          selectedDayTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
          todayButtonColor: Colors.transparent,
          todayBorderColor: Colors.transparent,
          todayTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          daysTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          weekdayTextStyle: TextStyle(
            color: Colors.grey,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
          prevDaysTextStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
          nextDaysTextStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
          headerTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
          showHeader: false,
          markedDatesMap: EventList<Event>(events: markedDates),
          markedDateShowIcon: true,
          markedDateIconMaxShown: 1,
          markedDateMoreShowTotal: false,
          markedDateCustomTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
          ),
          markedDateWidget: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -2.h,
                right: -2.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFA726),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          markedDateIconBuilder: (event) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -10.h,
                  right: -10.w,
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFA726),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        event.title ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    });
  }

  Widget _buildDailyRecords() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            return RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Daily Records ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: '${controller.dailyCount.value}',
                    style: TextStyle(
                      color: const Color(0xFF2196F3),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: ' Items',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: 16.h),
          Obx(() {
            if (controller.dailyRecords.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 32.h),
                child: Center(
                  child: Text(
                    'No records',
                    style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                  ),
                ),
              );
            }

            return Column(
              children: List.generate(controller.dailyRecords.length * 2 - 1, (
                index,
              ) {
                if (index.isEven) {
                  final recordIndex = index ~/ 2;
                  final record = controller.dailyRecords[recordIndex];
                  return _buildRecordItem(record);
                } else {
                  return Divider(color: Colors.grey.shade200, height: 1.h);
                }
              }),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRecordItem(dynamic record) {
    return GestureDetector(
      onTap: () {
        controller.onLogItemTap(record);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(color: Colors.transparent),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Project Name',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    record.projectName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Project Supervisor',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _maskSupervisor(record.projectSupervisor),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Image.asset(
              'assets/icon_arrow_right.png',
              width: 20.w,
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }

  String _maskSupervisor(String name) {
    if (name.length <= 2) return name;
    return 'x' * name.length;
  }
}
