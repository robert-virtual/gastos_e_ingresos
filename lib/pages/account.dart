import 'package:flutter/material.dart';
import 'package:google_sign_in/widgets.dart';
import '../controllers/home_controller.dart';
import 'package:get/get.dart';

class AccountPage extends GetView<HomeController> {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cuenta")),
      body: GetBuilder<HomeController>(
        builder: (_) => controller.user != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ListTile(
                    leading: GoogleUserCircleAvatar(
                      identity: controller.user!,
                    ),
                    title: Text(controller.user!.displayName ?? ''),
                    subtitle: Text(controller.user!.email),
                  ),
                  InkWell(
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
                              "Cerrar Sesion",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ]),
                    ),
                    onTap: () async {
                      await controller.signOut();
                    },
                  ),
                ],
              )
            : Center(
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
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
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
              ),
      ),
    );
  }
}
