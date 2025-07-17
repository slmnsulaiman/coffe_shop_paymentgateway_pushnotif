import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mobile/thema.dart';
import 'package:mobile/widgets/tetxtfieldwidget.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 60),
        children: [
          Column(
            children: [
              Text(
                'REGISTER',
                style: CokTextStyle.copyWith(fontSize: 35, fontWeight: bold),
              ),
              Divider(color: KCoklatColor),
              const SizedBox(height: 20),
              WidgetTextfield(
                controller: controller.nameC,
                hintText: 'Nama',
                icon: Icons.person,
              ),
              const SizedBox(height: 20),
              WidgetTextfield(
                controller: controller.emailC,
                hintText: 'Email',
                icon: Icons.email,
              ),
              const SizedBox(height: 20),
              WidgetTextfield(
                controller: controller.passC,
                hintText: 'Password',
                icon: Icons.lock,
              ),

              const SizedBox(height: 20),
              GestureDetector(
                onTap: controller.registerUser,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: KCoklatColor,
                  ),
                  child: Center(
                    child: Text(
                      'REGISTER',
                      style: WhiteTextStyle.copyWith(
                        fontSize: 25,
                        fontWeight: bold,
                      ),
                    ),
                  ),
                ),
              ),
              // ElevatedButton(
              //   onPressed: controller.registerUser,
              //   child: const Text('Register'),
              // ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Sudah punya akun?', style: BlackTextStyle),
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text('Login', style: CokTextStyle),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
