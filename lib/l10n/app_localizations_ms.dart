// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get language => 'Bahasa Melayu';

  @override
  String get fullNamefield => 'Name Penuh';

  @override
  String get icfield => 'Nombor IC';

  @override
  String get patientIdfield => 'ID Pesakit';

  @override
  String get addressfield => 'Alamat';

  @override
  String get followuptreatment => 'Klinik Rawatan Susulan';

  @override
  String get navHome => 'Utama';

  @override
  String get navOrders => 'Pesanan';

  @override
  String get navProfile => 'Profil';

  @override
  String get homeSubtitle => 'Pengambilan & penghantaran ubat';

  @override
  String get homeAddAddress => 'Tambah alamat untuk penghantaran tepat';

  @override
  String get homeRequestPickup => 'Minta ambil';

  @override
  String get homeRequestPickupSubtitle =>
      'Kami ambil ubat anda dari farmasi hospital.';

  @override
  String get homeRequestDelivery => 'Minta hantar';

  @override
  String get homeRequestDeliverySubtitle =>
      'Ubat dihantar dengan selamat ke rumah anda.';

  @override
  String get orderUpdates => 'Kemas kini pesanan';

  @override
  String get liveTracking => 'Penjejakan langsung';

  @override
  String get etaUnavailable => 'ETA tidak tersedia';

  @override
  String get languageSetting => 'Bahasa';

  @override
  String get selectLanguage => 'Pilih bahasa pilihan anda';

  @override
  String get geocodingFallback =>
      'Alamat tidak dijumpai. Menggunakan lokasi semasa anda.';

  @override
  String get profileTitle => 'Profil';

  @override
  String helloName(String name) {
    return 'Helo, $name';
  }

  @override
  String etaLabel(String eta) {
    return 'Anggaran ketibaan: $eta';
  }

  @override
  String distanceAway(String distance) {
    return '$distance lagi';
  }
}
