import 'package:carrypill/business_logic/provider/order_provider.dart';
import 'package:carrypill/business_logic/provider/patient_provider.dart';
import 'package:carrypill/business_logic/provider/provider_location.dart';
import 'package:carrypill/data/models/order_service.dart';
import 'package:carrypill/data/models/patient_uid.dart';
import 'package:carrypill/constants/supabase_config.dart';
import 'package:carrypill/data/repositories/supabase_repo/auth_repo.dart';
import 'package:carrypill/data/repositories/map_repo/location_repo.dart';
import 'package:carrypill/core/services/notification_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'l10n/l10n.dart';
import 'theme/app_theme.dart';
import 'route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:carrypill/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );
  await NotificationService().initialize();
  Position? position = await LocationRepo().initPosition();
  // print(position);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<ProviderLocation>.value(
      value: ProviderLocation(position: position),
    ),
    StreamProvider<PatientUid?>.value(
      catchError: (_, __) => null,
      value: AuthRepo().patient,
      initialData: null,
    ),
    ChangeNotifierProvider<PatientProvider?>(
      create: (_) => PatientProvider(),
    ),
    ChangeNotifierProvider<OrderProvider?>(
      create: (_) => OrderProvider(orderService: OrderService()),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            supportedLocales: L10n.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            initialRoute: '/',
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        });
  }
}
