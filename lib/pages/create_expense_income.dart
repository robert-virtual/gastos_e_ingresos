import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/home_controller.dart';

class CreateExpenseIncomePage extends GetView<HomeController> {
  const CreateExpenseIncomePage({super.key});
  @override
  Widget build(BuildContext context) {
    TextEditingController titleCtrl = TextEditingController();
    TextEditingController moneyCtrl = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text("Gastos & Ingresos")),
      body: GetBuilder<HomeController>(
        builder: (_) => controller.loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  TextFormField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(
                        label: Text("Gasto/Ingreso"), helperText: "Ej: Caffe"),
                  ),
                  TextFormField(
                    controller: moneyCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      label: Text("Monto"),
                      helperText: "Ej: 35",
                    ),
                  ),
                  DropdownButton<String>(
                      value: controller.cashflowType,
                      items: const [
                        DropdownMenuItem(
                          value: "Expense",
                          child: Text("Gasto"),
                        ),
                        DropdownMenuItem(
                          value: "Income",
                          child: Text("Ingreso"),
                        )
                      ],
                      onChanged: (value) {
                        if (value != null) controller.setCashflowType(value);
                      }),
                  Text(DateFormat.yMEd().format(DateTime.now()))
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          controller.setloading(true);
          await controller.saveCashFlow(
            [
              titleCtrl.text,
              controller.cashflowType,
              moneyCtrl.text,
              DateTime.now().toIso8601String()
            ],
          );
          controller.setloading(false);
          // reload data
          controller.getExpensesAndIncomes();
          // go back to the previous screeen
          Get.back();
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
