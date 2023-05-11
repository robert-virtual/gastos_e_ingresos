import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import 'package:get/get.dart';

class ExpensesPage extends GetView<HomeController> {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () {
          controller.count++;
        },
        child: Center(
          child: Column(
            children: [
              const Text("Expenses"),
              Text("Count: ${controller.count}"),
            ],
          ),
        ),
      ),
    );
  }
}
