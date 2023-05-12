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
        if (controller.user == null) {
          return Center(
            child: InkWell(
              child: Container(
                color: Colors.blue,
                padding: const EdgeInsets.all(2.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/google.jpg',
                        width: 40,
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      const Text(
                        "Iniciar sesion con Google",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ]),
              ),
              onTap: () async {
                await controller.signIn();
              },
            ),
          );
        }
        if (controller.error != null) {
          return const Center(
            child: Text("Ups algo salio mal. Vuelve a Intentar mas tarde"),
          );
        }
        if (controller.expensesAndIncomes != null &&
            controller.expensesAndIncomes!.isEmpty) {
          return const Center(
            child: Text("Agrega un nuevo ingreso/gasto"),
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
                              child: Text("Todo"),
                            ),
                            DropdownMenuItem(
                              value: "this_month",
                              child: Text("Este Mes"),
                            ),
                            DropdownMenuItem(
                              value: "this_week",
                              child: Text("Esta Semana"),
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
                              child: Text("Todo"),
                            ),
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
