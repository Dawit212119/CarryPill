import 'package:carrypill/constants/constant_color.dart';
import 'package:carrypill/core/utils/order_status_utils.dart';
import 'package:carrypill/core/widgets/app_loading_indicator.dart';
import 'package:carrypill/core/widgets/empty_state.dart';
import 'package:carrypill/data/models/all_enum.dart';
import 'package:carrypill/data/models/order_service.dart';
import 'package:carrypill/data/models/patient_uid.dart';
import 'package:carrypill/data/repositories/supabase_repo/database_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderHistoryList extends StatefulWidget {
  final ServiceType serviceType;
  final String emptyTitle;

  const OrderHistoryList({
    super.key,
    required this.serviceType,
    required this.emptyTitle,
  });

  @override
  State<OrderHistoryList> createState() => _OrderHistoryListState();
}

class _OrderHistoryListState extends State<OrderHistoryList> {
  int _refreshTick = 0;

  Stream<List<OrderService>> _stream(String uid) {
    final repo = DatabaseRepo(uid: uid);
    return widget.serviceType == ServiceType.requestDelivery
        ? repo.streamListOrderDelivery()
        : repo.streamListOrderPickup();
  }

  Future<void> _onRefresh(String uid) async {
    await DatabaseRepo(uid: uid).fetchOrdersByService(widget.serviceType);
    if (mounted) setState(() => _refreshTick++);
    await Future<void>.delayed(const Duration(milliseconds: 400));
  }

  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<PatientUid>(context).uid;
    if (uid == null) {
      return const EmptyState(
        icon: Icons.lock_outline,
        title: 'Sign in required',
        message: 'Please sign in to view your orders.',
      );
    }

    return StreamBuilder<List<OrderService>>(
      key: ValueKey(_refreshTick),
      stream: _stream(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const AppLoadingIndicator();
        }

        final orders = snapshot.data ?? [];

        if (orders.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => _onRefresh(uid),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: 80.h),
                EmptyState(
                  icon: Icons.inbox_outlined,
                  title: widget.emptyTitle,
                  message: 'When you book pickup or delivery, orders appear here.',
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _onRefresh(uid),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
            itemCount: orders.length,
            separatorBuilder: (_, __) => SizedBox(height: 10.h),
            itemBuilder: (context, index) {
              return _OrderHistoryTile(order: orders[index]);
            },
          ),
        );
      },
    );
  }
}

class _OrderHistoryTile extends StatelessWidget {
  final OrderService order;

  const _OrderHistoryTile({required this.order});

  @override
  Widget build(BuildContext context) {
    final status = order.statusOrder;
    final date = order.orderDate ?? DateTime.now();

    return Material(
      color: kcWhite,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: () {
          Navigator.of(context).pushNamed(
            '/orderdetail',
            arguments: {'order': order},
          );
        },
        child: Ink(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: kcDivider),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: OrderStatusUtils.color(status).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  OrderStatusUtils.icon(status),
                  color: OrderStatusUtils.color(status),
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.facility?.facilityName ?? 'Order',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: kctextDark,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      OrderStatusUtils.label(status),
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: OrderStatusUtils.color(status),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      DateFormat('d MMM yyyy · h:mm a').format(date),
                      style: TextStyle(fontSize: 12.sp, color: kctextgrey),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'RM ${order.totalPay.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      color: kcOrange,
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: kcGreyLabel, size: 22.sp),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
