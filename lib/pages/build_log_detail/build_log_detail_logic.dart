import 'dart:io';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../db/db_manager.dart';
import '../../db/build_log_entity.dart';
import '../../utils/index.dart';

class BuildLogDetailLogic extends GetxController {
  final DB _db = Get.find<DB>();

  final log = Rx<BuildLogEntity?>(null);
  final date = ''.obs;
  final projectName = ''.obs;
  final unit = ''.obs;
  final projectSupervisor = ''.obs;
  final supervisor = ''.obs;
  final weather = 0.obs;
  final notes = ''.obs;
  final photoPath = ''.obs;

  final isLoading = RxBool(false);
  final isSavingPdf = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    _loadLogData();
  }

  Future<void> _loadLogData() async {
    try {
      isLoading.value = true;

      final arguments = Get.arguments as Map<String, dynamic>?;
      final logId = arguments?['logId'] as int?;

      if (logId == null) {
        errorToast('Log not found');
        Get.back();
        return;
      }

      final logData = await _db.queryBuildLogById(logId);
      if (logData == null) {
        errorToast('Log not found');
        Get.back();
        return;
      }

      log.value = logData;
      date.value = logData.date;
      projectName.value = logData.projectName;
      unit.value = logData.unit;
      projectSupervisor.value = logData.projectSupervisor;
      supervisor.value = logData.supervisor;
      weather.value = logData.weather ?? 0;
      notes.value = logData.notes ?? '';
      photoPath.value = logData.photoPath ?? '';

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print('Error loading log data: $e');
      errorToast('Failed to load log data');
      Get.back();
    }
  }

  Future<pw.Document> _generatePdf() async {
    final pdf = pw.Document();

    pw.MemoryImage? photoImage;
    if (photoPath.value.isNotEmpty && File(photoPath.value).existsSync()) {
      try {
        final imageBytes = File(photoPath.value).readAsBytesSync();
        photoImage = pw.MemoryImage(imageBytes);
      } catch (e) {
        print('Error loading photo for PDF: $e');
      }
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  'Construction Log',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),

              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  _buildPdfTableRow('Unit', unit.value),
                  _buildPdfTableRow('Project Name', projectName.value),
                  _buildPdfTableRow(
                    'Project Supervisor',
                    projectSupervisor.value,
                  ),
                  _buildPdfTableRow('Supervisor', supervisor.value),
                  _buildPdfDoubleRow(
                    'Weather',
                    weather.value.toString(),
                    'Date',
                    date.value,
                  ),
                ],
              ),

              pw.SizedBox(height: 20),

              if (photoImage != null) ...[
                pw.Text(
                  'Construction Photo',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Container(
                  width: 300,
                  height: 300,
                  child: pw.Image(photoImage, fit: pw.BoxFit.contain),
                ),
                pw.SizedBox(height: 20),
              ],

              if (notes.value.isNotEmpty) ...[
                pw.Text(
                  'Log Notes',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(notes.value, style: const pw.TextStyle(fontSize: 12)),
              ],
            ],
          );
        },
      ),
    );

    return pdf;
  }

  pw.TableRow _buildPdfTableRow(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          color: PdfColors.grey300,
          child: pw.Text(label, style: pw.TextStyle(fontSize: 12)),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(value, style: const pw.TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  pw.TableRow _buildPdfDoubleRow(
    String label1,
    String value1,
    String label2,
    String value2,
  ) {
    return pw.TableRow(
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          color: PdfColors.grey300,
          child: pw.Text(label1, style: pw.TextStyle(fontSize: 12)),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(value1, style: const pw.TextStyle(fontSize: 12)),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          color: PdfColors.grey300,
          child: pw.Text(label2, style: pw.TextStyle(fontSize: 12)),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(value2, style: const pw.TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  Future<void> onPrintPressed() async {
    try {
      final pdf = await _generatePdf();
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      print('Error printing: $e');
      errorToast('Print failed, please try again');
    }
  }

  Future<void> onSavePdfPressed() async {
    try {
      isSavingPdf.value = true;

      final pdf = await _generatePdf();

      final Directory? directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception('Cannot access storage');
      }

      final fileName = 'BuildLog_${date.value}_${projectName.value}.pdf';
      final filePath = path.join(directory.path, fileName);

      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      isSavingPdf.value = false;
      successToast('PDF saved successfully');

      await Printing.sharePdf(bytes: await pdf.save(), filename: fileName);
    } catch (e) {
      isSavingPdf.value = false;
      print('Error saving PDF: $e');
      errorToast('Save failed, please try again');
    }
  }
}
