import 'package:carrypill/data/models/patient.dart';

/// Profile readiness for placing medication orders.
class PatientProfileUtils {
  PatientProfileUtils._();

  static bool isComplete(Patient patient) {
    return missingFields(patient).isEmpty;
  }

  static List<String> missingFields(Patient patient) {
    final missing = <String>[];
    if (patient.name.trim().isEmpty || patient.name.trim() == 'Patient') {
      missing.add('Full name');
    }
    if (patient.icNum.trim().isEmpty) missing.add('IC / ID number');
    if (patient.phoneNum.trim().isEmpty) missing.add('Phone number');
    if (patient.address == null || patient.address!.trim().isEmpty) {
      missing.add('Home address');
    }
    if (patient.geoPoint == null) missing.add('Location on map');
    if (patient.appointment == null) missing.add('Next appointment date');
    return missing;
  }

  static int completionPercent(Patient patient) {
    const total = 5;
    var done = 0;
    if (patient.name.trim().isNotEmpty && patient.name.trim() != 'Patient') {
      done++;
    }
    if (patient.icNum.trim().isNotEmpty) done++;
    if (patient.phoneNum.trim().isNotEmpty) done++;
    if (patient.address != null && patient.address!.trim().isNotEmpty) {
      done++;
    }
    if (patient.geoPoint != null) done++;
    return ((done / total) * 100).round().clamp(0, 100);
  }
}
