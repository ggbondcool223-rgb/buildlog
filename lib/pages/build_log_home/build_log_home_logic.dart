import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../db/db_manager.dart';
import '../../db/build_log_entity.dart';
import '../../utils/index.dart';

class BuildLogHomeLogic extends GetxController {
  final DB _db = Get.find<DB>();

  final month = Rx<String>('');

  final day = Rx<DateTime>(DateTime.now());

  final totalCount = RxInt(0);

  final dailyCount = RxInt(0);

  final dailyRecords = RxList<BuildLogEntity>([]);

  final logDates = RxSet<String>({});

  final dateCountMap = RxMap<String, int>({});

  final isLoading = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    final now = DateTime.now();
    month.value = DateFormat('yyyy-MM').format(now);
    _loadMonthData();
  }

  @override
  void onReady() {
    super.onReady();
    _loadDailyRecords();
  }

  Future<void> _loadMonthData() async {
    try {
      isLoading.value = true;

      final count = await _db.getMonthLogCount(month.value);
      totalCount.value = count;

      final dates = await _db.getLogDatesInMonth(month.value);
      logDates.clear();
      logDates.addAll(dates);

      final countMap = await _db.getLogCountByDateInMonth(month.value);
      dateCountMap.clear();
      dateCountMap.addAll(countMap);

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print('Error loading month data: $e');
      errorToast('Failed to load data');
    }
  }

  Future<void> _loadDailyRecords() async {
    try {
      final dateStr = getDateString(day.value);
      final records = await _db.queryBuildLogsByDate(dateStr);
      dailyRecords.value = records;
      dailyCount.value = records.length;
    } catch (e) {
      print('Error loading daily records: $e');
      errorToast('Failed to load daily records');
    }
  }

  void updateMonth(String newMonth) {
    month.value = newMonth;
    _loadMonthData();
  }

  void updateDay(DateTime newDay) {
    day.value = newDay;
    _loadDailyRecords();
  }

  Future<void> refreshData() async {
    await _loadMonthData();
    await _loadDailyRecords();
  }

  void onLogItemTap(BuildLogEntity log) {
    if (log.id == null) {
      errorToast('Log ID not found');
      return;
    }
    Get.toNamed('/build_log_detail', arguments: {'logId': log.id});
  }
}
