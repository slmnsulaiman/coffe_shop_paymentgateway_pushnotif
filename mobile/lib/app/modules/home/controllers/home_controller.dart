// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'package:http/http.dart' as http;
// import 'package:mobile/constant/base_url.dart';
// import 'dart:convert';
// import '../../../data/models/produk_model.dart';
// import 'package:get_storage/get_storage.dart';

// class HomeController extends GetxController {
//   final searchController = TextEditingController();
//   final box = GetStorage();

//   final name = ''.obs;
//   final email = ''.obs;

//   var isLoading = false.obs;
//   var products = <ProdukModel>[].obs;
//   var filteredProducts = <ProdukModel>[].obs;
//   var searchText = ''.obs;

//   @override
//   void onInit() {
//     name.value = box.read('name') ?? 'Guest';
//     email.value = box.read('email') ?? '-';
//     fetchProduk(); // ✅ penting
//     debounce(
//       searchText,
//       (_) => filterProduk(),
//       time: const Duration(milliseconds: 300),
//     );
//     super.onInit();
//   }

//   Future<void> fetchProduk() async {
//     isLoading.value = true;
//     final token = box.read('token');
//     print("TOKEN FLUTTER: $token");
//     try {
//       final response = await http.get(
//         Uri.parse('$bASEURL/api/products'),
//         headers: {'Authorization': 'Bearer $token'},
//       );
//       if (response.statusCode == 200) {
//         final List data = jsonDecode(response.body)['products'];
//         products.value = data.map((e) => ProdukModel.fromJson(e)).toList();
//         filteredProducts.assignAll(products); // ✅ Tambahkan baris ini di sinil
//       } else {
//         Get.snackbar('Gagal', 'Gagal ambil produk: ${response.body}');
//       }
//     } catch (e) {
//       Get.snackbar('Error', e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void filterProduk() {
//     final query = searchText.value.toLowerCase();
//     if (query.isEmpty) {
//       filteredProducts.assignAll(products);
//     } else {
//       filteredProducts.assignAll(
//         products.where((produk) => produk.name.toLowerCase().contains(query)),
//       );
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/constant/base_url.dart';
import 'dart:convert';
import '../../../data/models/produk_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomeController extends GetxController {
  final searchController = TextEditingController();
  RxInt currentIndex = 0.obs;

  final box = GetStorage();

  final name = ''.obs;
  final email = ''.obs;

  var isLoading = false.obs;
  var products = <ProdukModel>[].obs;
  var filteredProducts = <ProdukModel>[].obs;
  var searchText = ''.obs;

  @override
  void onInit() {
    name.value = box.read('name') ?? 'Guest';
    email.value = box.read('email') ?? '-';
    fetchProduk();
    getFcmToken(); // ✅ ambil token
    // listenToFCM(); // ✅ dengarkan notifikasi

    debounce(
      searchText,
      (_) => filterProduk(),
      time: const Duration(milliseconds: 300),
    );
    super.onInit();
  }

  Future<void> fetchProduk() async {
    isLoading.value = true;
    final token = box.read('token');
    print("TOKEN FLUTTER: $token");

    try {
      final response = await http.get(
        Uri.parse('$bASEURL/api/products'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body)['products'];
        products.value = data.map((e) => ProdukModel.fromJson(e)).toList();
        filteredProducts.assignAll(products);
      } else {
        Get.snackbar('Gagal', 'Gagal ambil produk: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void filterProduk() {
    final query = searchText.value.toLowerCase();
    if (query.isEmpty) {
      filteredProducts.assignAll(products);
    } else {
      filteredProducts.assignAll(
        products.where((produk) => produk.name.toLowerCase().contains(query)),
      );
    }
  }

  // ✅ Ambil FCM Token
  void getFcmToken() async {
    final fcm = FirebaseMessaging.instance;
    final token = await fcm.getToken();

    print("✅ FCM Token: $token");

    final box = GetStorage();
    final email = box.read('email');
    final bearer = box.read('token');

    try {
      final res = await http.post(
        Uri.parse('$bASEURL/api/auth/save-token'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearer',
        },
        body: jsonEncode({'token': token, 'email': email}),
      );

      if (res.statusCode == 200) {
        print('✅ FCM token berhasil dikirim ke backend');
      } else {
        print('❌ Gagal kirim token: ${res.body}');
      }
    } catch (e) {
      print('❌ Error kirim token: $e');
    }
  }

  // ✅ Dengarkan notifikasi masuk saat app dibuka
  // void listenToFCM() {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     final notif = message.notification;
  //     if (notif != null) {
  //       Get.snackbar(
  //         notif.title ?? "Notifikasi",
  //         notif.body ?? "Pesan baru",
  //         snackPosition: SnackPosition.TOP,
  //         duration: const Duration(seconds: 4),
  //       );
  //     }
  //   });
  // }
}
