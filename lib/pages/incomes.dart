import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import 'package:get/get.dart';

class IncomePage extends GetView<HomeController> {
  const IncomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () {
          controller.count += 1;
        },
        child: Center(
          child: Column(
            children: [
              const Text("Income"),
              Text("Count: ${controller.count}"),
            ],
          ),
        ),
      ),
    );
  }
}
