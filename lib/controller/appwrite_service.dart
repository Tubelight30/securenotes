import 'package:appwrite/appwrite.dart';
import 'package:securenotes/constants/secrets.dart';

class AppwriteService {
  final Client client = Client();
  late final Account account;
  late final Databases database;

  AppwriteService() {
    client
        .setEndpoint(Secrets.endpoint) // Your API Endpoint
        .setProject(Secrets.projId); // Your project ID

    account = Account(client);
    database = Databases(client);
  }
}
