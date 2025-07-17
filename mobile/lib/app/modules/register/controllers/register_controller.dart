import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/app/routes/app_pages.dart';
import 'package:mobile/constant/base_url.dart';

class RegisterController extends GetxController {
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();

  void registerUser() async {
    final url = Uri.parse('$bASEURL/api/auth/register');

    try {
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': nameC.text.trim(),
          'email': emailC.text.trim(),
          'password': passC.text.trim(),
        }),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 201) {
        Get.toNamed(Routes.LOGIN);
        Get.snackbar('Sukses', data['message']);
        // Bisa arahkan ke login
      } else {
        Get.snackbar('Gagal', data['message']);
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }

  @override
  void onClose() {
    nameC.dispose();
    emailC.dispose();
    passC.dispose();
    super.onClose();
  }
}
