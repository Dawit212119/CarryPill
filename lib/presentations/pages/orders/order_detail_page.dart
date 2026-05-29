import 'package:carrypill/business_logic/provider/patient_provider.dart';
import 'package:carrypill/constants/constant_color.dart';
import 'package:carrypill/core/utils/order_status_utils.dart';
import 'package:carrypill/core/widgets/order_timeline_widget.dart';
import 'package:carrypill/data/models/all_enum.dart';
import 'package:carrypill/data/models/geo_point.dart';
import 'package:carrypill/data/models/order_service.dart';
import 'package:carrypill/data/repositories/supabase_repo/database_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderDetailPage extends StatefulWidget {
  final OrderService order;

  const OrderDetailPage({super.key, required this.order});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late OrderService _order;
  bool _cancelling = false;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
  }

  Future<void> _confirmCancel() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel order?'),
        content: const Text(
          'This can only be done before a rider is assigned. You can place a new order anytime.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Keep')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFE53935)),
            child: const Text('Cancel order'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final orderId = _order.documentID;
    if (orderId == null) return;

    setState(() => _cancelling = true);
    try {
      await DatabaseRepo().cancelOrder(orderId);
      if (!mounted) return;
      setState(() {
        _order.statusOrder = StatusOrder.orderCancelled;
        _cancelling = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order cancelled')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _cancelling = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not cancel: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _order.statusOrder;
    final canCancel = OrderStatusUtils.canCancel(status);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order details'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20.w),
        children: [
          _StatusHeader(status: status),
          SizedBox(height: 20.h),
          OrderTimelineWidget(currentStatus: status),
          if (OrderStatusUtils.isActive(status)) ...[
            SizedBox(height: 16.h),
            FilledButton.icon(
              onPressed: () {
                GeoPoint? patientLoc =
                    Provider.of<PatientProvider>(context, listen: false)
                        .patient
                        ?.geoPoint;
                Navigator.of(context).pushNamed(
                  '/trackorder',
                  arguments: {
                    'order': _order,
                    'patientLocation': patientLoc,
                  },
                );
              },
              icon: const Icon(Icons.map_outlined),
              label: const Text('Live map tracking'),
              style: FilledButton.styleFrom(
                minimumSize: Size(double.infinity, 48.h),
              ),
            ),
          ],
          SizedBox(height: 20.h),
          if (_order.tokenUrlImage != null &&
              _order.tokenUrlImage!.isNotEmpty) ...[
            Text(
              'Token slip',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: kcPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                _order.tokenUrlImage!,
                height: 160.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16.h),
          ],
          _Section(
            title: 'Facility',
            children: [
              _Row(label: 'Hospital', value: _order.facility?.facilityName ?? '—'),
              _Row(label: 'Address', value: _order.facility?.fullAddress ?? '—'),
            ],
          ),
          SizedBox(height: 16.h),
          _Section(
            title: 'Order info',
            children: [
              _Row(
                label: 'Service',
                value: _order.serviceType == ServiceType.requestDelivery
                    ? 'Home delivery'
                    : 'Pharmacy pickup',
              ),
              _Row(
                label: 'Payment',
                value: _order.paymentMethod?.name.toUpperCase() ?? '—',
              ),
              _Row(
                label: 'Total',
                value: 'RM ${_order.totalPay.toStringAsFixed(2)}',
              ),
              if (_order.orderDate != null)
                _Row(
                  label: 'Placed',
                  value: DateFormat('d MMM yyyy, h:mm a').format(_order.orderDate!),
                ),
              if (_order.tokenNum != null)
                _Row(label: 'Queue token', value: '${_order.tokenNum}'),
            ],
          ),
          if (canCancel) ...[
            SizedBox(height: 28.h),
            OutlinedButton.icon(
              onPressed: _cancelling ? null : _confirmCancel,
              icon: _cancelling
                  ? SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cancel_outlined),
              label: const Text('Cancel this order'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFE53935),
                side: const BorderSide(color: Color(0xFFE53935)),
                minimumSize: Size(double.infinity, 48.h),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusHeader extends StatelessWidget {
  final StatusOrder status;

  const _StatusHeader({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: OrderStatusUtils.color(status).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: OrderStatusUtils.color(status).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            OrderStatusUtils.icon(status),
            size: 40.sp,
            color: OrderStatusUtils.color(status),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status',
                  style: TextStyle(fontSize: 12.sp, color: kctextgrey),
                ),
                Text(
                  OrderStatusUtils.label(status),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: OrderStatusUtils.color(status),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
            color: kcPrimary,
          ),
        ),
        SizedBox(height: 10.h),
        ...children,
      ],
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;

  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(label, style: TextStyle(fontSize: 13.sp, color: kctextgrey)),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: kctextDark),
            ),
          ),
        ],
      ),
    );
  }
}
