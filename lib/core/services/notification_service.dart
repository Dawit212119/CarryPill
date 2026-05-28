import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  RealtimeChannel? _channel;
  bool _initialized = false;

  // Idempotent: safe to call on every app start; the guard prevents
  // re-registering platform channels on hot restart.
  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(initSettings);
    _initialized = true;
  }

  void startListening(String userId) {
    _channel?.unsubscribe();

    _channel = Supabase.instance.client
        .channel('order-notifications')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'orders',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'patient_ref',
            value: userId,
          ),
          callback: (payload) {
            final newRecord = payload.newRecord;
            final oldRecord = payload.oldRecord;

            final newStatus = newRecord['status_order'] as String?;
            final oldStatus = oldRecord['status_order'] as String?;

            if (newStatus != null && newStatus != oldStatus) {
              _showOrderNotification(newStatus);
            }
          },
        )
        .subscribe();
  }

  void _showOrderNotification(String status) {
    final info = _statusInfo(status);

    const androidDetails = AndroidNotificationDetails(
      'order_updates',
      'Order Updates',
      channelDescription: 'Notifications for medication order status changes',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      info['title']!,
      info['body']!,
      details,
    );
  }

  Map<String, String> _statusInfo(String status) {
    switch (status) {
      case 'findingDriver':
        return {
          'title': 'Looking for a rider',
          'body': 'We\'re finding a rider for your medication.',
        };
      case 'driverFound':
        return {
          'title': 'Rider assigned!',
          'body': 'A rider has accepted your order.',
        };
      case 'driverToHospital':
        return {
          'title': 'Rider on the way',
          'body': 'Your rider is heading to the hospital.',
        };
      case 'driverQueue':
        return {
          'title': 'Rider at pharmacy',
          'body': 'Your rider is queuing at the pharmacy.',
        };
      case 'orderPreparing':
        return {
          'title': 'Order preparing',
          'body': 'Your medication is being prepared.',
        };
      case 'outForDelivery':
        return {
          'title': 'Out for delivery',
          'body': 'Your medication is on the way to you!',
        };
      case 'orderArrived':
        return {
          'title': 'Order arrived!',
          'body': 'Your medication has arrived. Please collect it.',
        };
      case 'orderCancelled':
        return {
          'title': 'Order cancelled',
          'body': 'Your order has been cancelled.',
        };
      default:
        return {
          'title': 'Order update',
          'body': 'Your order status has changed.',
        };
    }
  }

  void stopListening() {
    _channel?.unsubscribe();
    _channel = null;
  }
}
