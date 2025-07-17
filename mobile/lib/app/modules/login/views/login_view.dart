import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/app/routes/app_pages.dart';
import 'package:mobile/thema.dart';
import 'package:mobile/widgets/tetxtfieldwidget.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KCoklatColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 🟤 Logo
                Image.asset(
                  'assets/luruh.png',
                  width: 100,
                  height: 100,
                  color: Colors.white,
                ),

                const SizedBox(height: 8),

                // 🟤 Brand
                Text(
                  'LURUH',
                  style: WhiteTextStyle.copyWith(
                    fontSize: 32,
                    fontWeight: bold,
                    letterSpacing: 4,
                  ),
                ),
                Text(
                  'Coffee & Matcha',
                  style: WhiteTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: light,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 40),

                // 🟤 Form Container
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Masuk ke akun',
                        style: CokTextStyle.copyWith(
                          fontSize: 18,
                          fontWeight: bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      WidgetTextfield(
                        controller: controller.emailC,
                        hintText: 'Email',
                        icon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 16),
                      WidgetTextfield(
                        controller: controller.passC,
                        hintText: 'Kata Sandi',
                        icon: Icons.lock_outline,
                      ),
                      const SizedBox(height: 24),

                      // 🟤 Tombol Login
                      GestureDetector(
                        onTap: controller.loginUser,
                        child: Container(
                          width: double.infinity,
                          height: 48,
                          decoration: BoxDecoration(
                            color: KCoklatColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'LOGIN',
                              style: WhiteTextStyle.copyWith(
                                fontSize: 16,
                                fontWeight: bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Belum punya akun?',
                            style: CokTextStyle.copyWith(fontSize: 13),
                          ),
                          TextButton(
                            onPressed: () => Get.toNamed(Routes.REGISTER),
                            child: Text(
                              'Daftar',
                              style: CokTextStyle.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
