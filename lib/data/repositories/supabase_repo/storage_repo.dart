import 'package:carrypill/data/dataproviders/supabase_provider/storage_provider.dart';

class StorageRepo {
  final String? uid;

  StorageRepo({this.uid});

  Future<String?> uploadPatientProfileImage(
      String filePath, String fileName) async {
    if (uid == null) return null;
    return SupabaseStorageProvider().uploadPatientProfileImage(filePath, uid!);
  }

  Future<String?> uploadOrderTokenImage(String filePath, String fileName) async {
    if (uid == null) return null;
    return SupabaseStorageProvider()
        .uploadOrderTokenImage(filePath, uid!, fileName);
  }

  Future<String?> uploadRiderDriverLicenseImage(
      dynamic file, String fileName) async {
    return null;
  }
}
