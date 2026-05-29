import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageProvider {
  final SupabaseClient _client = Supabase.instance.client;
  static const patientBucket = 'patient-profiles';
  static const orderTokenBucket = 'order-tokens';

  // Stores at a fixed `<uid>/profilepic` path with upsert so each user keeps
  // a single profile image that overwrites in place.
  Future<String?> uploadPatientProfileImage(
      String filePath, String uid) async {
    try {
      final file = File(filePath);
      final path = '$uid/profilepic';
      await _client.storage.from(patientBucket).upload(
            path,
            file,
            fileOptions: const FileOptions(upsert: true),
          );
      return _client.storage.from(patientBucket).getPublicUrl(path);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> uploadOrderTokenImage(
    String filePath,
    String uid,
    String fileName,
  ) async {
    try {
      final file = File(filePath);
      final path = '$uid/$fileName';
      await _client.storage.from(orderTokenBucket).upload(
            path,
            file,
            fileOptions: const FileOptions(upsert: true),
          );
      return _client.storage.from(orderTokenBucket).getPublicUrl(path);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
