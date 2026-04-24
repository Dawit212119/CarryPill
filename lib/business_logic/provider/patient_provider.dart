import 'package:carrypill/data/models/clinic.dart';
import 'package:carrypill/data/models/patient.dart';
import 'package:carrypill/data/repositories/supabase_repo/database_repo.dart';
import 'package:carrypill/data/models/geo_point.dart';
import 'package:flutter/material.dart';

class PatientProvider with ChangeNotifier {
  Patient? patient;
  PatientProvider({
    this.patient,
  });

  void updatePatient(Patient patient) async {
    this.patient = patient;
    notifyListeners();
  }

  // Bulk-updates the in-memory patient from profile form fields and notifies
  // listeners once; null geoPoint/profileImageUrl leave existing values intact.
  void updatePatientInfo({
    required String name,
    required String patientId,
    required String icNum,
    required String phoneNum,
    required String address,
    GeoPoint? geoPoint,
    String? profileImageUrl,
  }) async {
    patient?.name = name;
    patient?.patientId = patientId;
    patient?.icNum = icNum;
    patient?.phoneNum = phoneNum;
    patient?.address = address;
    patient?.profileImageUrl = profileImageUrl;
    notifyListeners();
  }

  void updateClinic(List<Clinic> clinicList) async {
    patient?.clinicList = clinicList;
    notifyListeners();
  }

  void updateAppointment(DateTime dateTime) async {
    patient?.appointment = dateTime;
    notifyListeners();
  }

  Future<void> updatePatientDB(String uid, {required Patient patient}) async {
    await DatabaseRepo(uid: uid).updateAllPatientData(patient);
    this.patient = patient;
    notifyListeners();
  }

  Future<void> updateAppointmentDB(DateTime dateTime, String uid) async {
    await DatabaseRepo(uid: uid).updateAppointment(dateTime);
    patient?.appointment = dateTime;
    notifyListeners();
  }

  Future<void> updateClinicDB(List<Clinic> clinicList, String uid) async {
    await DatabaseRepo(uid: uid).updateClinic(clinicList);
    patient?.clinicList = clinicList;
    notifyListeners();
  }

  Future<void> updateStatus(int index) async {
    patient?.clinicList[index].status = !patient!.clinicList[index].status;
    notifyListeners();
  }
}
