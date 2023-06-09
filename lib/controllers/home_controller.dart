import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

class HomeController extends GetxController {
  var pageIndex = 0.obs;
  String spreadsheetId = "";
  bool loading = false;
  String cashflowType = "Income";
  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      "email",
      "https://www.googleapis.com/auth/drive",
      "https://www.googleapis.com/auth/spreadsheets"
    ],
  );
  GoogleSignInAccount? user;

  String timeFilter = "today";
  String typeFilter = "all";
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
      return;
    }
    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;
    List<dynamic> files = (data["files"] as List<dynamic>);
    if (files.isEmpty) {
      // create that file which will be our database
      await createSpreadSheet();
      return;
    }
    Map<String, dynamic> file = files[0];
    spreadsheetId = file["id"];
  }

  double getBalance() {
    return expensesAndIncomes != null && expensesAndIncomes!.isNotEmpty
        ? expensesAndIncomes!
            .map((e) => double.parse(e[2]))
            .reduce((prev, current) => prev + current)
        : 0;
  }

  Future<void> createSpreadSheet() async {
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
      return;
    }
    Map<String, dynamic> data = jsonDecode(response.body);
    spreadsheetId = data["spreadsheetId"];
  }

  List<dynamic>? expensesAndIncomes;
  List<dynamic>? expensesAndIncomesCopy;
  String? error;
  Future<void> getExpensesAndIncomes() async {
    final http.Response response = await http.get(
      Uri.parse(
          "https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/A:D"),
      headers: await user!.authHeaders,
    );
    if (response.statusCode != 200) {
      error = "${response.statusCode}";
      update();
    }
    print(response.body);
    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;
    if (data.containsKey("values")) {
      expensesAndIncomes = (data["values"] as List<dynamic>);
      expensesAndIncomes!
          .sort((a, b) => DateTime.parse(b[3]).compareTo(DateTime.parse(a[3])));
      expensesAndIncomesCopy = expensesAndIncomes;
      // apply default filters
      setFilters(time: timeFilter, type: typeFilter);
    } else {
      expensesAndIncomes = List.empty();
      expensesAndIncomesCopy = List.empty();
    }
    update();
  }

  Future<void> saveCashFlow(List<dynamic> dataToInsert) async {
    final http.Response response = await http.post(
        Uri.parse(
            "https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/A:D:append?valueInputOption=RAW"),
        headers: await user!.authHeaders,
        body: jsonEncode({
          "values": [dataToInsert]
        }));
    if (response.statusCode != 200) {
      return;
    }
  }

  void setCashflowType(String value) {
    cashflowType = value;
    update();
  }

  void setloading(bool value) {
    loading = value;
    update();
  }

  Future<void> signOut() async {
    spreadsheetId = "";
    await googleSignIn.disconnect();
  }

  Map<String, DateTime> opts = {
    "this_week": DateTime.now().subtract(const Duration(days: 7)),
    "this_month": DateTime.now().subtract(const Duration(days: 30)),
    "today": DateTime.now().subtract(const Duration(days: 1)),
  };
  void setFilters({String? type, String? time}) {
    timeFilter = time ?? timeFilter;
    typeFilter = type ?? typeFilter;
    expensesAndIncomes = expensesAndIncomesCopy!
        .where((element) =>
            (timeFilter != "all"
                ? DateTime.parse(element[3]).isAfter(opts[timeFilter]!)
                : true) &&
            (typeFilter != "all" ? element[1] == typeFilter : true))
        .toList();

    update();
  }
}
