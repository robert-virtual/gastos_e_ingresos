import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final formater = NumberFormat("#,##0.00", locale.toString());
    return Scaffold(
      appBar:
          AppBar(title: Text(AppLocalizations.of(context)!.expensesAndIncome)),
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
                    Text(
                      AppLocalizations.of(context)!.signInWithGoogle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              onTap: () async {
                await controller.signIn();
              },
            ),
          );
        }
        if (controller.error != null) {
          return Center(
            child: Text(AppLocalizations.of(context)!.somethingWentWrong),
          );
        }
        if (controller.expensesAndIncomes != null) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                primary: false,
                pinned: true,
                automaticallyImplyLeading: false,
                actions: [
                  Wrap(
                    spacing: 2.0,
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.timeFilter,
                          items: [
                            DropdownMenuItem(
                              value: "all",
                              child:
                                  Text(AppLocalizations.of(context)!.cap_all),
                            ),
                            DropdownMenuItem(
                              value: "today",
                              child:
                                  Text(AppLocalizations.of(context)!.cap_today),
                            ),
                            DropdownMenuItem(
                              value: "this_month",
                              child: Text(
                                  AppLocalizations.of(context)!.this_month),
                            ),
                            DropdownMenuItem(
                              value: "this_week",
                              child:
                                  Text(AppLocalizations.of(context)!.this_week),
                            )
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              controller.setFilters(time: value);
                            }
                          },
                        ),
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.typeFilter,
                          items: [
                            DropdownMenuItem(
                              value: "all",
                              child:
                                  Text(AppLocalizations.of(context)!.cap_all),
                            ),
                            DropdownMenuItem(
                              value: "Expense",
                              child: Text(
                                  AppLocalizations.of(context)!.cap_expense),
                            ),
                            DropdownMenuItem(
                              value: "Income",
                              child: Text(
                                  AppLocalizations.of(context)!.cap_income),
                            )
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              controller.setFilters(type: value);
                            }
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.cap_balance}: ",
                          style: const TextStyle(
                            fontSize: 30.0,
                          ),
                        ),
                        Text(
                          "${formater.currencySymbol}. ${formater.format(controller.getBalance())}",
                          style: TextStyle(
                              fontSize: 30.0,
                              color: controller.getBalance() < 0
                                  ? Colors.red
                                  : Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              controller.expensesAndIncomes!.isNotEmpty
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: controller.expensesAndIncomes!.length,
                        (context, idx) {
                          List<dynamic> item =
                              controller.expensesAndIncomes![idx];
                          return Card(
                            child: ListTile(
                              title: Text(
                                item[0],
                              ),
                              subtitle: Text(
                                timeago.format(DateTime.parse(item[3]),
                                    locale: locale.toString()),
                              ),
                              trailing: Text(
                                "${formater.currencySymbol}. ${formater.format(double.parse(item[2]))}",
                                style: TextStyle(
                                  color: item[1] == "Expense"
                                      ? const Color(0xFFe74c3c)
                                      : const Color(0xFF27ae60),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          const SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            AppLocalizations.of(context)!.cap_empty,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      }),
      floatingActionButton: GetBuilder<HomeController>(
        builder: (_) => Visibility(
          visible: controller.user != null,
          child: FloatingActionButton(
            onPressed: () {
              Get.toNamed("/create-expense-income");
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
