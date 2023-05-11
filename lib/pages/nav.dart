import 'package:flutter/material.dart';
import 'package:gastos_e_ingresos/pages/account.dart';
import 'package:gastos_e_ingresos/pages/home.dart';
import '../controllers/home_controller.dart';
import 'package:get/get.dart';

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
          currentIndex: controller.pageIndex.value,
          onTap: (index) {
            controller.pageIndex.value = index;
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.money_off),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
