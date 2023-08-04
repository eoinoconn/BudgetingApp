import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'views/setup.dart';
import 'package:http/http.dart' as http;

String budgetSheetPattern = "Track2Travel - Trip:";

// Function to establish an authenticated http cient.
Future<AuthClient> establishClient() async {
  GoogleSignInAccount user = googleSignIn.currentUser!;

  var userAuth = await user.authentication;
  var token = userAuth.accessToken;
  if (token == null) {
    throw Exception('Access token is null');
  }
  var expiry = DateTime.now().add(const Duration(days: 10)).toUtc();
  var accessToken = AccessToken('Bearer', token, expiry);

  var access = AccessCredentials(accessToken, null, scopes);

  return authenticatedClient(http.Client(), access);
}

// Function to get files from Google Drive.
Future<FileList> getFiles() async {
  var client = await establishClient();
  var drive = DriveApi(client);
  return await drive.files.list();
}

// Function to return list of Budget Sheets.
Future<List<File>> getBudgetSheets() async {
  var files = await getFiles();
  var budgetSheets = <File>[];
  for (var file in files.files!) {
    if (file.name!.startsWith(budgetSheetPattern)) {
      budgetSheets.add(file);
    }
  }
  return budgetSheets;
}

// TODO validate budget sheet

// Function to create a new budget sheet.
Future<File> createBudgetSheet(String tripName) async {
  var client = await establishClient();
  var drive = DriveApi(client);
  var budgetSheetName = budgetSheetPattern + tripName;
  var budgetSheet = File();
  budgetSheet.name = budgetSheetName;
  budgetSheet.mimeType = 'application/vnd.google-apps.spreadsheet';
  return await drive.files.create(budgetSheet);
}
