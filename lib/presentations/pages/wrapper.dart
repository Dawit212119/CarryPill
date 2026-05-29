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
  Patient? patient;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadPatient();
  }

  Future<void> _loadPatient() async {
    var profile = await DatabaseRepo(uid: widget.uid).futurePatient;
    if (profile == null) {
      await DatabaseRepo(uid: widget.uid).updateAllPatientData(
        Patient(
          name: 'Patient',
          icNum: '',
          phoneNum: '',
          clinicList: AuthRepo.defaultClinicList(),
        ),
      );
      profile = await DatabaseRepo(uid: widget.uid).futurePatient;
    }
    if (mounted) {
      setState(() {
        patient = profile;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading || patient == null) {
      return Scaffold(
        body: const AppLoadingIndicator(size: 56),
      );
    }
    return HomePage(patient: patient!);
  }
}
