import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import "package:http/http.dart" as http;

import '../province_model.dart';
import '../city_model.dart';
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
          Provinsi(),
          Obx(
            () => controller.hiddenKota.isTrue
                ? SizedBox()
                : Kota(provId: controller.provId.value),
          ),
        ],
      ),
    );
  }
}

class Provinsi extends GetView<HomeController> {
  const Provinsi({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: DropdownSearch<Province>(
        showClearButton: true,
        label: "Provinsi",
        onFind: (String filter) async {
          final Uri url =
              Uri.parse("https://api.rajaongkir.com/starter/province");

          try {
            final response = await http.get(url, headers: {
              "key": "b0c6d61e27e64814c1f55f44b2cef2a3",
            });

            var data = json.decode(response.body) as Map<String, dynamic>;

            var statusCode = data["rajaongkir"]["status"]["code"];
            if (statusCode != 200) {
              throw data["rajaongkir"]["status"]["description"];
            }

            var models = Province.fromJsonList(
                data["rajaongkir"]["results"] as List<dynamic>);
            return models;
          } catch (e) {
            print(e);
            return List<Province>.empty();
          }
        },
        onChanged: (prov) {
          if (prov != null) {
            controller.hiddenKota.value = false;
            controller.provId.value = int.parse(prov.provinceId!);
          } else {
            controller.hiddenKota.value = true;
            controller.provId.value = 0;
          }
        },
        popupItemBuilder: (context, item, isSelected) {
          return Container(
            padding: EdgeInsets.all(20),
            child: Text("${item.province}"),
          );
        },
        itemAsString: (item) => item.province!,
        showSearchBox: true,
        searchBoxDecoration: InputDecoration(hintText: "cari provinsi..."),
      ),
    );
  }
}

class Kota extends StatelessWidget {
  const Kota({
    Key? key,
    required this.provId,
  }) : super(key: key);

  final int provId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: DropdownSearch<City>(
        showClearButton: true,
        label: "Kota / Kabupaten",
        onFind: (String filter) async {
          final Uri url = Uri.parse(
              "https://api.rajaongkir.com/starter/city?province=$provId");

          try {
            final response = await http.get(url, headers: {
              "key": "b0c6d61e27e64814c1f55f44b2cef2a3",
            });

            var data = json.decode(response.body) as Map<String, dynamic>;

            var statusCode = data["rajaongkir"]["status"]["code"];
            if (statusCode != 200) {
              throw data["rajaongkir"]["status"]["description"];
            }

            var models = City.fromJsonList(
                data["rajaongkir"]["results"] as List<dynamic>);
            return models;
          } catch (e) {
            print(e);
            return List<City>.empty();
          }
        },
        onChanged: (kota) {
          if (kota != null) {
            print(kota.cityName);
          } else {
            print("tidak memilih kota apapun");
          }
        },
        popupItemBuilder: (context, item, isSelected) {
          return Container(
            padding: EdgeInsets.all(20),
            child: Text("${item.type} ${item.cityName}"),
          );
        },
        itemAsString: (item) => "${item.type} ${item.cityName}",
        showSearchBox: true,
        searchBoxDecoration:
            InputDecoration(hintText: "cari kota/kabupaten..."),
      ),
    );
  }
}
