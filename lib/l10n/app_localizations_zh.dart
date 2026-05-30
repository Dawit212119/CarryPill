// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get language => '中文';

  @override
  String get fullNamefield => '全名';

  @override
  String get icfield => '身份证号码';

  @override
  String get patientIdfield => '病人编号';

  @override
  String get addressfield => '地址';

  @override
  String get followuptreatment => '后续治疗门诊';

  @override
  String get navHome => '首页';

  @override
  String get navOrders => '订单';

  @override
  String get navProfile => '个人资料';

  @override
  String get homeSubtitle => '药物取药与配送';

  @override
  String get homeAddAddress => '添加地址以获得准确配送';

  @override
  String get homeRequestPickup => '请求取药';

  @override
  String get homeRequestPickupSubtitle => '我们从医院药房为您取药。';

  @override
  String get homeRequestDelivery => '请求配送';

  @override
  String get homeRequestDeliverySubtitle => '药物安全送达您的家。';

  @override
  String get orderUpdates => '订单更新';

  @override
  String get liveTracking => '实时追踪';

  @override
  String get etaUnavailable => '预计到达时间不可用';

  @override
  String get languageSetting => '语言';

  @override
  String get selectLanguage => '选择您的首选语言';

  @override
  String get geocodingFallback => '找不到该地址，将使用您当前的位置。';

  @override
  String get profileTitle => '个人资料';

  @override
  String helloName(String name) => '您好，$name';

  @override
  String etaLabel(String eta) => '预计到达：$eta';

  @override
  String distanceAway(String distance) => '距离 $distance';
}
