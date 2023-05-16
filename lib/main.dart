import 'package:flutter/material.dart';
import 'package:gastos_e_ingresos/pages/account.dart';
import 'package:gastos_e_ingresos/pages/create_expense_income.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      initialRoute: '/nav',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      darkTheme: ThemeData.dark(),
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
