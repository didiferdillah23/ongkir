import 'dart:convert';

// import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
// import "package:http/http.dart" as http;

import './widget/province_widget.dart';
import './widget/city_widget.dart';
import './widget/berat.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CEK ONGKIR'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Provinsi(tipe: "asal"),
          Obx(
            () => controller.hiddenKotaAsal.isTrue
                ? SizedBox()
                : Kota(provId: controller.provAsalId.value, tipe: "asal"),
          ),
          Container(
            height: .4,
            color: Colors.grey,
            width: double.infinity,
            padding: EdgeInsets.all(20),
          ),
          SizedBox(height: 20),
          Provinsi(tipe: "tujuan"),
          Obx(
            () => controller.hiddenKotaTujuan.isTrue
                ? SizedBox()
                : Kota(provId: controller.provTujuanId.value, tipe: "tujuan"),
          ),
          BeratBarang(),
        ],
      ),
    );
  }
}
