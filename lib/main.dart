import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/home_binding.dart';
import 'pages/home.dart';
import 'pages/expenses.dart';
import 'pages/incomes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      getPages: [
        GetPage(
          name: '/home',
          page: () => const HomePage(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: '/income',
          page: () => const IncomePage(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: '/expense',
          page: () => const ExpensesPage(),
          binding: HomeBinding(),
        )
      ],
    );
  }
}
