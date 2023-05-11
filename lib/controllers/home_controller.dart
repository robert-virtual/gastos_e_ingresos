import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

class HomeController extends GetxController {
  var pageIndex = 0.obs;
  String spreadsheetId = "";
  var cashflowType = "Income".obs;
  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      "email",
      "https://www.googleapis.com/auth/drive",
      "https://www.googleapis.com/auth/spreadsheets"
    ],
  );
  GoogleSignInAccount? user;
  signIn() async {
    user = await googleSignIn.signIn();
    update();
  }

  @override
  void onInit() {
    super.onInit();
    googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      // In mobile, being authenticated means being authorized...
      user = account;
      update();

      // Now that we know that the user can access the required scopes, the app
      // can call the REST API.
      if (account != null) {
        await findSpreadSheetFile();
        getExpensesAndIncomes();
      }
    });
    googleSignIn.signInSilently();
  }

  Future<void> findSpreadSheetFile() async {
    final http.Response response = await http.get(
      Uri.parse(
          "https://www.googleapis.com/drive/v3/files?q=mimeType='application/vnd.google-apps.spreadsheet' and name = 'expenses_and_income_app'"), // initially will not exist
      headers: await user!.authHeaders,
    );
    if (response.statusCode != 200) {
      print(response.body);
      return;
    }
    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;
    List<dynamic> files = (data["files"] as List<dynamic>);
    if (files.isEmpty) {
      print("no spreadsheet with that name found");
      // create that file which will be our database
      createSpreadSheet();
      return;
    }
    Map<String, dynamic> file = files[0];
    spreadsheetId = file["id"];
    print("spreadsheetId = $spreadsheetId");
  }

  void createSpreadSheet() async {
    final http.Response response = await http.post(
        Uri.parse("https://sheets.googleapis.com/v4/spreadsheets"),
        headers: await user!.authHeaders,
        body: jsonEncode({
          "properties": {"title": "expenses_and_income_app"},
          "sheets": [
            {
              "properties": {"title": "ExpensesAndIncome"}
            }
          ]
        }));
    if (response.statusCode != 200) {
      print(response.body);
      return;
    }
    Map<String, dynamic> data = jsonDecode(response.body);
    spreadsheetId = data["spreadsheetId"];
    print("spreadsheetId = $spreadsheetId");
  }

  List<dynamic>? expensesAndIncomes;
  String? error;
  Future<void> getExpensesAndIncomes() async {
    final http.Response response = await http.get(
      Uri.parse(
          "https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/A:D"),
      headers: await user!.authHeaders,
    );
    if (response.statusCode != 200) {
      print(response.body);
      error = "${response.statusCode}";
      update();
    }
    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;
    print(response.body);
    expensesAndIncomes = data["values"];
    update();
  }
}
