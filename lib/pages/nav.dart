import 'package:flutter/material.dart';
import 'package:gastos_e_ingresos/pages/account.dart';
import 'package:gastos_e_ingresos/pages/home.dart';
import '../controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NavPage extends GetView<HomeController> {
  const NavPage({super.key});
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [const HomePage(), const AccountPage()];
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.pageIndex.value,
          children: pages,
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: controller.pageIndex.value,
          onTap: (index) {
            controller.pageIndex.value = index;
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.attach_money),
              label: AppLocalizations.of(context)!.cap_home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: AppLocalizations.of(context)!.cap_account,
            ),
          ],
        ),
      ),
    );
  }
}
