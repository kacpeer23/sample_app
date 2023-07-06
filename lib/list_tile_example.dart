import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListTileExample extends StatelessWidget {
  const ListTileExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(
        left: 5.3,
        right: 5.3,
        top: 4.3,
        bottom: 8.3,
      ),
      height: 70,
      width: Get.width,
      child: Container(),
    );
  }
}
