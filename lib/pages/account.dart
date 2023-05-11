import 'package:flutter/material.dart';
import 'package:google_sign_in/widgets.dart';
import '../controllers/home_controller.dart';
import 'package:get/get.dart';

class AccountPage extends GetView<HomeController> {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Account")),
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
                  ElevatedButton(
                    onPressed: () {
                      controller.googleSignIn.disconnect();
                    },
                    child: const Text('SIGN OUT'),
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('You are not currently signed in.'),
                    // This method is used to separate mobile from web code with conditional exports.
                    // See: src/sign_in_button.dart
                    ElevatedButton(
                      child: const Text("SignIn"),
                      onPressed: () async {
                        await controller.signIn();
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
