import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/home_controller.dart';

class CreateExpenseIncomePage extends GetView<HomeController> {
  const CreateExpenseIncomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gastos & Ingresos")),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          TextFormField(
            decoration: const InputDecoration(label: Text("Title")),
          ),
          TextFormField(
            decoration: const InputDecoration(label: Text("Money")),
          ),
          Obx(
            () => DropdownButton<String>(
                value: controller.cashflowType.value,
                items: const [
                  DropdownMenuItem(
                    value: "Expense",
                    child: Text("Expense"),
                  ),
                  DropdownMenuItem(
                    value: "Income",
                    child: Text("Income"),
                  )
                ],
                onChanged: (value) {
                  if (value != null) controller.cashflowType.value = value;
                }),
          ),
          Text(DateFormat.yMEd().format(DateTime.now()))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.save),
      ),
    );
  }
}
