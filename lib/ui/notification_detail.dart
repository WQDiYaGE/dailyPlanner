import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daily_planner/ui/theme.dart';

class NotificationDetailPage extends StatelessWidget {
  final String? label;
  const NotificationDetailPage({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back_ios)),
        title: const Text("Remainder"),
      ),
      body: Center(
          child: Column(children: [
        const SizedBox(height: 30),
        Text(
          label.toString().split("|")[0],
          style: taskTitleStyle,
        ),
        const SizedBox(height: 30),
        Text(label.toString().split("|")[1], style: subHeadingStyle)
      ])),
    );
  }
}
