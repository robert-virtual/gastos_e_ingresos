import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gastos & Ingresos")),
      body: GetBuilder<HomeController>(builder: (_) {
        if (controller.error != null) {
          return const Center(
            child: Text("Ups something went wrong. Try again"),
          );
        }
        if (controller.expensesAndIncomes != null) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                primary: false,
                automaticallyImplyLeading: false,
                title: Text("${controller.expensesAndIncomes!.length} items"),
                actions: [
                  Wrap(
                    spacing: 2.0,
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.timeFilter,
                          items: const [
                            DropdownMenuItem(
                              value: "all",
                              child: Text("All"),
                            ),
                            DropdownMenuItem(
                              value: "this_month",
                              child: Text("This month"),
                            ),
                            DropdownMenuItem(
                              value: "this_week",
                              child: Text("This week"),
                            )
                          ],
                          onChanged: (value) {
                            if (value != null) controller.setTimeFilter(value);
                          },
                        ),
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.typeFilter,
                          items: const [
                            DropdownMenuItem(
                              value: "all",
                              child: Text("All"),
                            ),
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
                            if (value != null) controller.setTypeFilter(value);
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: controller.expensesAndIncomes!.length,
                      (context, idx) {
                List<dynamic> item = controller.expensesAndIncomes![idx];
                return Card(
                  child: ListTile(
                    title: Text(item[0]),
                    subtitle: Text(timeago.format(DateTime.parse(item[3]))),
                    trailing: Text(
                      "L.${item[2]}",
                      style: TextStyle(
                          color: item[1] == "Expense"
                              ? const Color(0xFFe74c3c)
                              : const Color(0xFF27ae60)),
                    ),
                  ),
                );
              }))
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed("/create-expense-income");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
