import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
      appBar:
          AppBar(title: Text(AppLocalizations.of(context)!.expensesAndIncome)),
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
                    decoration: InputDecoration(
                        label: Text(
                            AppLocalizations.of(context)!.expenseSlashIncome),
                        helperText:
                            AppLocalizations.of(context)!.example_coffe),
                  ),
                  TextFormField(
                    controller: moneyCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context)!.cap_amount),
                      helperText: AppLocalizations.of(context)!.example_35,
                    ),
                  ),
                  DropdownButton<String>(
                      value: controller.cashflowType,
                      items: [
                        DropdownMenuItem(
                          value: "Expense",
                          child:
                              Text(AppLocalizations.of(context)!.cap_expense),
                        ),
                        DropdownMenuItem(
                          value: "Income",
                          child: Text(AppLocalizations.of(context)!.cap_income),
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
