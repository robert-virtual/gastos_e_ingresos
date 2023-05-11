import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      getPages: [
        GetPage(name: '/home', page: () => const HomePage()),
        GetPage(name: '/income', page: () => const IncomePage()),
        GetPage(name: '/expense', page: () => const ExpensesPage())
      ],
    );
  }
}
