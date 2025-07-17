import 'package:flutter/material.dart';
import 'package:mobile/thema.dart';

class WidgetTextfield extends StatelessWidget {
  final String hintText;
  final TextEditingController controller; // Tambahkan controller
  final IconData icon;
  const WidgetTextfield({
    super.key,
    required this.hintText,
    required this.controller,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 2, color: KCoklatColor),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: KCoklatColor),
          hintText: hintText,
          hintStyle: CokTextStyle,
        ),
      ),
    );
  }
}
