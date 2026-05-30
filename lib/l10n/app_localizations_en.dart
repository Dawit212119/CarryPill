// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'English';

  @override
  String get fullNamefield => 'Full Name';

  @override
  String get icfield => 'IC Number';

  @override
  String get patientIdfield => 'Patient ID';

  @override
  String get addressfield => 'Address';

  @override
  String get followuptreatment => 'Follow-up Treatment Clinic';

  @override
  String get navHome => 'Home';

  @override
  String get navOrders => 'Orders';

  @override
  String get navProfile => 'Profile';

  @override
  String get homeSubtitle => 'Medication pickup & delivery';

  @override
  String get homeAddAddress => 'Add your address for accurate delivery';

  @override
  String get homeRequestPickup => 'Request pickup';

  @override
  String get homeRequestPickupSubtitle =>
      'We collect your medication from the hospital pharmacy.';

  @override
  String get homeRequestDelivery => 'Request delivery';

  @override
  String get homeRequestDeliverySubtitle =>
      'Medication delivered safely to your home.';

  @override
  String get orderUpdates => 'Order updates';

  @override
  String get liveTracking => 'Live tracking';

  @override
  String get etaUnavailable => 'ETA unavailable';

  @override
  String get languageSetting => 'Language';

  @override
  String get selectLanguage => 'Choose your preferred language';

  @override
  String get geocodingFallback =>
      'Could not find that address. Using your current location.';

  @override
  String get profileTitle => 'Profile';

  @override
  String helloName(String name) {
    return 'Hello, $name';
  }

  @override
  String etaLabel(String eta) {
    return 'Estimated arrival: $eta';
  }

  @override
  String distanceAway(String distance) {
    return '$distance away';
  }
}
