import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthProvider {
  final SupabaseClient _client = Supabase.instance.client;

  Future<dynamic> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      if (response.user == null) {
        return 'Register failed. Please try again.';
      }
      return response;
    } on AuthException catch (e) {
      return _mapAuthError(e.message);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<dynamic> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user;
    } on AuthException catch (e) {
      return _mapAuthError(e.message);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<dynamic> resetPasswordForEmail(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      return true;
    } on AuthException catch (e) {
      return _mapAuthError(e.message);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<dynamic> signOut() async {
    try {
      await _client.auth.signOut();
      return true;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  String _mapAuthError(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('already registered') ||
        lower.contains('already in use')) {
      return 'Email already used';
    }
    if (lower.contains('invalid login credentials') ||
        lower.contains('wrong password')) {
      return 'Wrong email/password combination.';
    }
    if (lower.contains('user not found')) {
      return 'No user found with this email.';
    }
    if (lower.contains('invalid email')) {
      return 'Email address is invalid.';
    }
    return message.isNotEmpty ? message : 'Authentication failed. Please try again.';
  }
}
