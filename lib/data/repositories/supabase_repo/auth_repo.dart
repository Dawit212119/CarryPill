import 'package:carrypill/data/dataproviders/supabase_provider/auth_provider.dart';
import 'package:carrypill/data/models/clinic.dart';
import 'package:carrypill/data/models/patient.dart';
import 'package:carrypill/data/models/patient_uid.dart';
import 'package:carrypill/data/repositories/supabase_repo/database_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepo {
  final SupabaseClient _client = Supabase.instance.client;

  static List<Clinic> defaultClinicList() => [
        Clinic(clinicName: 'MOPD', status: false),
        Clinic(clinicName: 'ORL/ENT', status: false),
        Clinic(clinicName: 'Paediatric', status: false),
        Clinic(clinicName: 'Orthopedik', status: false),
        Clinic(clinicName: 'Skin', status: false),
        Clinic(clinicName: 'Psychiatric', status: false),
        Clinic(clinicName: 'Eye', status: false),
      ];

  PatientUid? _patientFromUser(User? user) {
    if (user == null) return null;
    return PatientUid(uid: user.id);
  }

  Stream<PatientUid?> get patient {
    return _client.auth.onAuthStateChange.map((event) {
      return _patientFromUser(event.session?.user);
    });
  }

  Future<dynamic> register(Patient patient, String email, String password) async {
    final result =
        await SupabaseAuthProvider().registerWithEmailAndPassword(email, password);

    if (result == null || result is String) {
      return result;
    }

    final userId = (result as AuthResponse).user!.id;
    await DatabaseRepo(uid: userId).updateAllPatientData(patient);
    return true;
  }

  Future<dynamic> resetPassword(String email) async {
    return SupabaseAuthProvider().resetPasswordForEmail(email);
  }

  Future<dynamic> login(String email, String password) async {
    final result =
        await SupabaseAuthProvider().signInWithEmailAndPassword(email, password);
    if (result == null || result is String) {
      return result;
    }
    await _ensurePatientProfile(result as User);
    return true;
  }

  Future<void> _ensurePatientProfile(User user) async {
    final existing = await DatabaseRepo(uid: user.id).futurePatient;
    if (existing != null) return;

    final metadata = user.userMetadata ?? {};
    await DatabaseRepo(uid: user.id).updateAllPatientData(
      Patient(
        name: metadata['full_name']?.toString() ??
            user.email?.split('@').first ??
            'Patient',
        icNum: '',
        phoneNum: '',
        clinicList: defaultClinicList(),
      ),
    );
  }

  Future logout() async {
    return SupabaseAuthProvider().signOut();
  }
}
