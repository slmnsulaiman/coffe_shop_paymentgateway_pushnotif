import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/app/modules/keranjang/controllers/keranjang_controller.dart';
import 'package:mobile/constant/base_url.dart';

import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final box = GetStorage();

  void loginUser() async {
    final email = emailC.text.trim();
    final password = passC.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Email dan password harus diisi');
      return;
    }

    final url = Uri.parse('$bASEURL/api/auth/login');

    try {
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        // ✅ Simpan token & info user
        box.write('token', data['token']);
        box.write('name', data['user']['name']);
        box.write('email', data['user']['email']);
        box.write('role', data['user']['role']);

        final keranjangC = Get.find<KeranjangController>();
        keranjangC.loadKeranjang();

        Get.snackbar('Sukses', data['message']);

        // ✅ Arahkan berdasarkan role
        if (data['user']['role'] == 'kasir') {
          Get.offAllNamed(
            Routes.KASIR_HOME,
          ); // ⬅️ pastikan route ini sudah terdaftar
        } else {
          Get.offAllNamed(Routes.HOME); // User biasa ke Home
        }
      } else {
        Get.snackbar('Gagal', data['message']);
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal login: $e');
    }
  }

  @override
  void onClose() {
    emailC.dispose();
    passC.dispose();
    super.onClose();
  }
}
