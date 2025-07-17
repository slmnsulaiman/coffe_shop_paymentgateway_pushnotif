// // import 'dart:convert';
// // import 'package:get/get.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:mobile/constant/base_url.dart';
// // import '../../../data/models/transaksi_model.dart';

// // class KasirHomeController extends GetxController {
// //   var isLoading = false.obs;
// //   var transaksiList = <TransaksiModel>[].obs;

// //   Future<void> fetchHariIni() async {
// //     isLoading.value = true;

// //     try {
// //       final res = await http.get(
// //         Uri.parse('$bASEURL/api/checkout'), // ganti jika pakai ngrok
// //         headers: {'Content-Type': 'application/json'},
// //       );

// //       if (res.statusCode == 200) {
// //         final List data = json.decode(res.body);
// //         final today = DateTime.now();

// //         final filtered = data
// //             .where((item) {
// //               final createdAt = DateTime.parse(item['createdAt']);
// //               return createdAt.year == today.year &&
// //                   createdAt.month == today.month &&
// //                   createdAt.day == today.day;
// //             })
// //             .map((e) => TransaksiModel.fromJson(e))
// //             .toList();

// //         transaksiList.assignAll(filtered);
// //       } else {
// //         print('Gagal ambil data: ${res.statusCode}');
// //       }
// //     } catch (e) {
// //       print('Error fetchHariIni: $e');
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }

// //   @override
// //   void onInit() {
// //     super.onInit();
// //     fetchHariIni();
// //   }
// // }
// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:mobile/constant/base_url.dart';
// import '../../../data/models/transaksi_model.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// class KasirHomeController extends GetxController {
//   var isLoading = false.obs;
//   var transaksiList = <TransaksiModel>[].obs;

//   Future<void> fetchHariIni() async {
//     isLoading.value = true;

//     try {
//       final res = await http.get(
//         Uri.parse('$bASEURL/api/checkout'),
//         headers: {'Content-Type': 'application/json'},
//       );

//       if (res.statusCode == 200) {
//         final List data = json.decode(res.body);
//         final today = DateTime.now();

//         final filtered = data
//             .where((item) {
//               final createdAt = DateTime.parse(item['createdAt']);
//               return createdAt.year == today.year &&
//                   createdAt.month == today.month &&
//                   createdAt.day == today.day;
//             })
//             .map((e) => TransaksiModel.fromJson(e))
//             .toList();

//         transaksiList.assignAll(filtered);
//       } else {
//         print('Gagal ambil data: ${res.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetchHariIni: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> updateProses(String id) async {
//     try {
//       final res = await http.put(
//         Uri.parse('$bASEURL/api/checkout/$id/proses'),
//         headers: {'Content-Type': 'application/json'},
//       );

//       final data = jsonDecode(res.body);

//       if (res.statusCode == 200) {
//         Get.snackbar('Sukses', 'Pesanan ditandai selesai');
//         fetchHariIni(); // refresh ulang data
//       } else {
//         Get.snackbar('Gagal', data['message'] ?? 'Update gagal');
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Terjadi kesalahan: $e');
//     }
//   }

//   void listenFCMForRefresh() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('📥 Notifikasi masuk: ${message.notification?.title}');
//       print('📦 Data: ${message.data}');
//       if (message.data['type'] == 'new_order') {
//         fetchHariIni(); // ⬅️ Real-time refresh pesanan kasir
//       }
//     });
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     listenFCMForRefresh();
//     fetchHariIni();
//   }
// }

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/constant/base_url.dart';
import '../../../data/models/transaksi_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class KasirHomeController extends GetxController {
  var isLoading = false.obs;
  var transaksiList = <TransaksiModel>[].obs;

  final box = GetStorage();

  Future<void> fetchHariIni() async {
    isLoading.value = true;

    try {
      final res = await http.get(
        Uri.parse('$bASEURL/api/checkout'),
        headers: {'Content-Type': 'application/json'},
      );

      if (res.statusCode == 200) {
        final List data = json.decode(res.body);
        final today = DateTime.now();

        final filtered = data
            .where((item) {
              final createdAt = DateTime.parse(item['createdAt']);
              return createdAt.year == today.year &&
                  createdAt.month == today.month &&
                  createdAt.day == today.day;
            })
            .map((e) => TransaksiModel.fromJson(e))
            .toList();

        transaksiList.assignAll(filtered);
      } else {
        print('Gagal ambil data: ${res.statusCode}');
      }
    } catch (e) {
      print('Error fetchHariIni: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProses(String id) async {
    try {
      final res = await http.put(
        Uri.parse('$bASEURL/api/checkout/$id/proses'),
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        Get.snackbar('Sukses', 'Pesanan ditandai selesai');
        fetchHariIni(); // refresh ulang data
      } else {
        Get.snackbar('Gagal', data['message'] ?? 'Update gagal');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }

  void listenFCMForRefresh() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📥 Notifikasi masuk: ${message.notification?.title}');
      print('📦 Data: ${message.data}');
      if (message.data['type'] == 'new_order') {
        fetchHariIni(); // ⬅️ Real-time refresh pesanan kasir
      }
    });
  }

  // ✅ Tambahan: simpan token FCM kasir
  void getFcmToken() async {
    final fcm = FirebaseMessaging.instance;
    final token = await fcm.getToken();

    print("✅ [KASIR] FCM Token: $token");

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
        print('✅ [KASIR] FCM token berhasil dikirim ke backend');
      } else {
        print('❌ [KASIR] Gagal kirim token: ${res.body}');
      }
    } catch (e) {
      print('❌ [KASIR] Error kirim token: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    getFcmToken(); // ⬅️ WAJIB panggil di awal
    listenFCMForRefresh();
    fetchHariIni();
  }
}
