import 'package:carrypill/data/models/patient.dart';

class PatientProfileUtils {
  PatientProfileUtils._();

  static bool isComplete(Patient patient) {
    return missingFields(patient).isEmpty;
  }

  // Single source of truth for what "complete" means; the order screen gates
  // checkout on this list being empty. 'Patient' is the unset default name.
  static List<String> missingFields(Patient patient) {
    final missing = <String>[];
    if (patient.name.trim().isEmpty || patient.name.trim() == 'Patient') {
      missing.add('Full name');
    }
    if (patient.phoneNum.trim().isEmpty) missing.add('Phone number');
    if (patient.address == null || patient.address!.trim().isEmpty) {
      missing.add('Home address');
    }
    return missing;
  }

  static int completionPercent(Patient patient) {
    const total = 3;
    var done = 0;
    if (patient.name.trim().isNotEmpty && patient.name.trim() != 'Patient') done++;
    if (patient.phoneNum.trim().isNotEmpty) done++;
    if (patient.address != null && patient.address!.trim().isNotEmpty) done++;
    return ((done / total) * 100).round().clamp(0, 100);
  }
}
