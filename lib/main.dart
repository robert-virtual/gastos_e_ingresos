import 'package:flutter/material.dart';
import 'package:gastos_e_ingresos/pages/account.dart';
import 'package:gastos_e_ingresos/pages/create_expense_income.dart';
import 'package:get/get.dart';

import 'controllers/home_binding.dart';
import 'pages/nav.dart';
import 'pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/nav',
      getPages: [
        GetPage(
          name: '/nav',
          page: () => const NavPage(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: '/home',
          page: () => const HomePage(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: '/account',
          page: () => const AccountPage(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: '/create-expense-income',
          page: () => const CreateExpenseIncomePage(),
          binding: HomeBinding(),
        )
      ],
    );
  }
}
