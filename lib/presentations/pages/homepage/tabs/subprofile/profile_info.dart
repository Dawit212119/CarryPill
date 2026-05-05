import 'dart:io';
import 'package:carrypill/business_logic/provider/patient_provider.dart';
import 'package:carrypill/constants/constant_color.dart';
import 'package:carrypill/data/models/patient.dart';
import 'package:carrypill/data/models/patient_uid.dart';
import 'package:carrypill/data/repositories/supabase_repo/database_repo.dart';
import 'package:carrypill/data/repositories/supabase_repo/storage_repo.dart';
import 'package:carrypill/data/models/geo_point.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;
import 'package:url_launcher/url_launcher.dart';

class ProfileInfo extends StatefulWidget {
  Map<String, dynamic>? arg = {};
  ProfileInfo({Key? key, required this.arg}) : super(key: key);
  @override
  _ProfileInfoState createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  late TextEditingController namecon, icNumcon, phoneNumcon, patientIdcon, addresscon;
  String? filePath, fileName;
  File? file;
  bool loading = false;
  double? lat, lng;

  @override
  void initState() {
    final p = widget.arg!['patient'] as Patient?;
    namecon = TextEditingController(text: p?.name ?? '');
    icNumcon = TextEditingController(text: p?.icNum ?? '');
    phoneNumcon = TextEditingController(text: p?.phoneNum ?? '');
    patientIdcon = TextEditingController(text: p?.patientId ?? '');
    addresscon = TextEditingController(text: p?.address ?? '');
    lat = p?.geoPoint?.latitude;
    lng = p?.geoPoint?.longitude;
    super.initState();
  }

  void _msg(String t) { setState(() => loading = false); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t))); }

  Future<void> _openMap() async {
    final la = lat ?? 9.0192, lo = lng ?? 38.7525;
    final uri = Platform.isIOS ? Uri.parse('https://maps.apple.com/?q=$la,$lo') : Uri.parse('geo:$la,$lo?q=$la,$lo');
    final fb = Uri.parse('https://www.google.com/maps/search/?api=1&query=$la,$lo');
    if (await canLaunchUrl(uri)) { await launchUrl(uri); }
    else if (await canLaunchUrl(fb)) { await launchUrl(fb, mode: LaunchMode.externalApplication); }
  }

  Future<void> _useGps() async {
    setState(() => loading = true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) { _msg('Enable location'); return; }
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) { perm = await Geolocator.requestPermission(); }
      if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) { _msg('Permission denied'); return; }
      final pos = await Geolocator.getCurrentPosition();
      setState(() { lat = pos.latitude; lng = pos.longitude; loading = false; });
      _msg('Location set');
    } catch (_) { _msg('GPS failed'); }
  }

  Future<void> _save() async {
    final acc = Provider.of<PatientUid>(context, listen: false);
    final p = widget.arg!['patient'] as Patient?;
    setState(() => loading = true);
    try {
      final geo = (lat != null && lng != null) ? GeoPoint(lat!, lng!) : GeoPoint(9.0192, 38.7525);
      String? url = p?.profileImageUrl;
      if (filePath != null) url = await StorageRepo(uid: acc.uid).uploadPatientProfileImage(filePath!, fileName!);
      Provider.of<PatientProvider>(context, listen: false).updatePatientInfo(
        name: namecon.text, icNum: icNumcon.text, phoneNum: phoneNumcon.text,
        address: addresscon.text, patientId: patientIdcon.text, geoPoint: geo, profileImageUrl: url);
      await DatabaseRepo(uid: acc.uid).updatePatientInfo(
        name: namecon.text, icNum: icNumcon.text, phoneNum: phoneNumcon.text,
        address: addresscon.text, patientId: patientIdcon.text, geoPoint: geo, profileImageUrl: url);
      _msg('Saved');
    } catch (e) { _msg('Failed: $e'); }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.arg!['patient'] as Patient?;
    return Stack(children: [
      Scaffold(
        backgroundColor: kcBgDark,
        appBar: AppBar(backgroundColor: kcBgDark, elevation: 0, scrolledUnderElevation: 0, foregroundColor: kctextDark,
          title: Text('Edit Profile', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700)),
          actions: [
            TextButton(onPressed: _save, child: Text('Save', style: TextStyle(color: kcAccent, fontWeight: FontWeight.w700, fontSize: 14.sp))),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: 8.h),
            // Avatar
            Center(child: Stack(children: [
              Container(width: 90.w, height: 90.w, decoration: BoxDecoration(
                shape: BoxShape.circle, border: Border.all(color: kcAccent, width: 2),
                image: DecorationImage(fit: BoxFit.cover,
                  image: (p?.profileImageUrl != null && file == null) ? NetworkImage(p!.profileImageUrl!)
                    : file != null ? FileImage(file!) : const AssetImage('assets/images/profile.png') as ImageProvider),
              )),
              Positioned(bottom: 0, right: 0, child: GestureDetector(
                onTap: () async {
                  setState(() => loading = true);
                  final r = await FilePicker.pickFiles(allowMultiple: false, type: FileType.image);
                  if (r != null) {
                    final path = r.files.single.path!;
                    final im = img.decodeImage(await File(path).readAsBytes());
                    final o = img.bakeOrientation(im!);
                    final nf = await File(path).writeAsBytes(img.encodeJpg(o));
                    setState(() { file = nf; filePath = path; fileName = r.files.single.name; loading = false; });
                  } else { setState(() => loading = false); }
                },
                child: Container(width: 30.w, height: 30.w, decoration: BoxDecoration(color: kcAccent, shape: BoxShape.circle, border: Border.all(color: kcBgDark, width: 2)),
                  child: Icon(Icons.camera_alt_rounded, color: kcBgDark, size: 14.sp)),
              )),
            ])),

            SizedBox(height: 28.h),
            _Lbl('Personal'),
            SizedBox(height: 12.h),
            _F(con: namecon, label: 'Full Name', icon: Icons.person_outline),
            _F(con: patientIdcon, label: 'Patient ID', icon: Icons.badge_outlined),
            _F(con: icNumcon, label: 'IC Number', icon: Icons.credit_card_outlined),
            _F(con: phoneNumcon, label: 'Phone', icon: Icons.phone_outlined, type: TextInputType.phone),

            SizedBox(height: 20.h),
            _Lbl('Address & Location'),
            SizedBox(height: 12.h),
            _F(con: addresscon, label: 'Home address', icon: Icons.home_outlined, lines: 2),
            SizedBox(height: 10.h),

            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(color: kcCardDark, borderRadius: BorderRadius.circular(14.r)),
              child: Column(children: [
                if (lat != null && lng != null) Padding(padding: EdgeInsets.only(bottom: 12.h), child: Row(children: [
                  Icon(Icons.location_on_rounded, color: kcAccent, size: 17.sp), SizedBox(width: 8.w),
                  Text('${lat!.toStringAsFixed(4)}, ${lng!.toStringAsFixed(4)}', style: TextStyle(fontSize: 13.sp, color: kctextDark)),
                ])),
                Row(children: [
                  Expanded(child: _Btn(icon: Icons.map_outlined, label: 'Map', color: kcPurple, onTap: _openMap)),
                  SizedBox(width: 10.w),
                  Expanded(child: _Btn(icon: Icons.my_location_rounded, label: 'GPS', color: kcAccent, onTap: _useGps)),
                ]),
              ]),
            ),
            SizedBox(height: 32.h),
          ]),
        ),
      ),
      if (loading) Container(color: Colors.black45, child: const Center(child: CircularProgressIndicator(color: kcAccent, strokeWidth: 3))),
    ]);
  }
}

class _Lbl extends StatelessWidget {
  final String t;
  const _Lbl(this.t);
  @override Widget build(BuildContext context) => Text(t, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: kctextDark));
}

class _F extends StatelessWidget {
  final TextEditingController con;
  final String label;
  final IconData icon;
  final TextInputType? type;
  final int lines;
  const _F({required this.con, required this.label, required this.icon, this.type, this.lines = 1});
  @override Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(bottom: 10.h), child: TextField(
      controller: con, keyboardType: type, maxLines: lines,
      style: TextStyle(fontSize: 14.sp, color: kctextDark, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: kcGreyLabel, size: 20.sp),
        labelText: label, labelStyle: TextStyle(color: kcGreyLabel, fontSize: 13.sp),
        floatingLabelStyle: TextStyle(color: kcAccent, fontWeight: FontWeight.w600, fontSize: 13.sp),
        filled: true, fillColor: kcCardDark,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14.r), borderSide: BorderSide(color: kcBorder)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14.r), borderSide: BorderSide(color: kcBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14.r), borderSide: BorderSide(color: kcAccent, width: 1.5)),
      ),
    ));
  }
}

class _Btn extends StatelessWidget {
  final IconData icon; final String label; final Color color; final VoidCallback onTap;
  const _Btn({required this.icon, required this.label, required this.color, required this.onTap});
  @override Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: Container(
      padding: EdgeInsets.symmetric(vertical: 11.h),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10.r)),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, color: color, size: 17.sp), SizedBox(width: 6.w),
        Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13.sp)),
      ]),
    ));
  }
}
