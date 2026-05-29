import 'package:carrypill/constants/constant_color.dart';
import 'package:carrypill/core/utils/order_status_utils.dart';
import 'package:carrypill/core/utils/order_timeline.dart';
import 'package:carrypill/data/models/all_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderTimelineWidget extends StatelessWidget {
  final StatusOrder currentStatus;

  const OrderTimelineWidget({super.key, required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    final steps = OrderTimeline.build(currentStatus);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order progress',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
            color: kcPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        ...steps.asMap().entries.map((entry) {
          final i = entry.key;
          final step = entry.value;
          final isLast = i == steps.length - 1;
          return _TimelineRow(step: step, drawLine: !isLast);
        }),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final OrderTimelineStep step;
  final bool drawLine;

  const _TimelineRow({required this.step, required this.drawLine});

  @override
  Widget build(BuildContext context) {
    final color = step.isComplete
        ? OrderStatusUtils.color(step.status)
        : kcGreyLabel.withValues(alpha: 0.4);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: step.isCurrent
                      ? color.withValues(alpha: 0.15)
                      : step.isComplete
                          ? color.withValues(alpha: 0.12)
                          : kcBgHome2,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: step.isComplete ? color : kcGreyLabel,
                    width: step.isCurrent ? 2 : 1,
                  ),
                ),
                child: Icon(
                  step.isComplete ? Icons.check_rounded : Icons.circle,
                  size: step.isComplete ? 16.sp : 8.sp,
                  color: step.isComplete ? color : kcGreyLabel,
                ),
              ),
              if (drawLine)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                    color: step.isComplete
                        ? color.withValues(alpha: 0.5)
                        : kcDivider,
                  ),
                ),
            ],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: drawLine ? 16.h : 0),
              child: Text(
                step.label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: step.isCurrent ? FontWeight.w700 : FontWeight.w500,
                  color: step.isCurrent ? kctextDark : kctextgrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
