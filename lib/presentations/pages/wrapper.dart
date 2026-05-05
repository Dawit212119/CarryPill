import 'package:carrypill/core/services/notification_service.dart';
import 'package:carrypill/core/widgets/app_loading_indicator.dart';
import 'package:carrypill/data/models/patient.dart';
import 'package:carrypill/data/models/patient_uid.dart';
import 'package:carrypill/data/repositories/supabase_repo/auth_repo.dart';
import 'package:carrypill/data/repositories/supabase_repo/database_repo.dart';
import 'package:provider/provider.dart';

import 'authenticate/authenticate.dart';
import 'homepage/homepage.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final patientuid = Provider.of<PatientUid?>(context);
    if (patientuid != null) {
      return _PatientLoader(uid: patientuid.uid!);
    }
    return const Authenticate();
  }
}

class _PatientLoader extends StatefulWidget {
  final String uid;

  const _PatientLoader({required this.uid});

  @override
  State<_PatientLoader> createState() => _PatientLoaderState();
}

class _PatientLoaderState extends State<_PatientLoader> {
  bool _ensured = false;

  @override
  void initState() {
    super.initState();
    NotificationService().startListening(widget.uid);
    _ensureProfile();
  }

  @override
  void dispose() {
    NotificationService().stopListening();
    super.dispose();
  }

  Future<void> _ensureProfile() async {
    final existing = await DatabaseRepo(uid: widget.uid).futurePatient;
    if (existing == null) {
      await DatabaseRepo(uid: widget.uid).updateAllPatientData(
        Patient(
          name: 'Patient',
          icNum: '',
          phoneNum: '',
          clinicList: AuthRepo.defaultClinicList(),
        ),
      );
    }
    if (mounted) setState(() => _ensured = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_ensured) {
      return const Scaffold(body: AppLoadingIndicator(size: 56));
    }

    return StreamBuilder<Patient?>(
      stream: DatabaseRepo(uid: widget.uid).streamPatient,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Scaffold(body: AppLoadingIndicator(size: 56));
        }

        final patient = snapshot.data;
        if (patient == null) {
          return const Scaffold(body: AppLoadingIndicator(size: 56));
        }

        return HomePage(patient: patient);
      },
    );
  }
}
