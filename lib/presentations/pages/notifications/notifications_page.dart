import 'package:carrypill/constants/constant_color.dart';
import 'package:carrypill/core/utils/order_status_utils.dart';
import 'package:carrypill/core/widgets/app_loading_indicator.dart';
import 'package:carrypill/core/widgets/empty_state.dart';
import 'package:carrypill/data/models/order_service.dart';
import 'package:carrypill/data/models/patient_uid.dart';
import 'package:carrypill/data/repositories/supabase_repo/database_repo.dart';
import 'package:carrypill/services/app_notification_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int _refreshTick = 0;

  Future<void> _refresh(String uid) async {
    await DatabaseRepo(uid: uid).fetchAllOrders();
    if (mounted) setState(() => _refreshTick++);
  }

  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<PatientUid?>(context)?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Updates')),
      body: uid == null
          ? const EmptyState(
              icon: Icons.notifications_off_outlined,
              title: 'Not signed in',
              message: 'Sign in to see order updates.',
            )
          : StreamBuilder<List<OrderService>>(
              key: ValueKey(_refreshTick),
              stream: DatabaseRepo(uid: uid).streamListOrder(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const AppLoadingIndicator();
                }

                final items =
                    AppNotificationItem.fromOrders(snapshot.data ?? []);

                if (items.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () => _refresh(uid),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: 60.h),
                        const EmptyState(
                          icon: Icons.notifications_none_outlined,
                          title: 'No updates yet',
                          message:
                              'Order status changes will appear here when you place a booking.',
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => _refresh(uid),
                  child: ListView.separated(
                    padding: EdgeInsets.all(16.w),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => SizedBox(height: 8.h),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _NotificationTile(
                        item: item,
                        onTap: () {
                          final order = snapshot.data?.firstWhere(
                            (o) => o.documentID == item.orderId,
                          );
                          if (order != null) {
                            Navigator.of(context).pushNamed(
                              '/orderdetail',
                              arguments: {'order': order},
                            );
                          }
                        },
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final AppNotificationItem item;
  final VoidCallback onTap;

  const _NotificationTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kcWhite,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Ink(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: kcDivider),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22.r,
                backgroundColor:
                    OrderStatusUtils.color(item.status).withValues(alpha: 0.15),
                child: Icon(
                  OrderStatusUtils.icon(item.status),
                  color: OrderStatusUtils.color(item.status),
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: kctextDark,
                      ),
                    ),
                    Text(
                      item.body,
                      style: TextStyle(fontSize: 13.sp, color: kctextgrey),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      DateFormat('d MMM · h:mm a').format(item.time),
                      style: TextStyle(fontSize: 11.sp, color: kcGreyLabel),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
