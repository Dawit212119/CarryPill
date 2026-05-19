import 'dart:async';

import 'package:carrypill/constants/constant_color.dart';
import 'package:carrypill/constants/constant_string.dart';
import 'package:carrypill/constants/constant_widget.dart';
import 'package:carrypill/data/models/order_service.dart';
import 'package:carrypill/data/models/patient.dart';
import 'package:carrypill/data/models/all_enum.dart';
import 'package:carrypill/data/models/patient_uid.dart';
import 'package:carrypill/data/models/rider.dart';
import 'package:carrypill/data/repositories/supabase_repo/auth_repo.dart';
import 'package:carrypill/data/repositories/supabase_repo/database_repo.dart';
import 'package:carrypill/presentations/custom_widgets/dash_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FinishedTab extends StatefulWidget {
  const FinishedTab({Key? key}) : super(key: key);

  @override
  _FinishedTabState createState() => _FinishedTabState();
}

class _FinishedTabState extends State<FinishedTab> {
  Rider? currentRider;
  Widget statusWidget = kwOrderReceivedStatusWidget;
  String textOrange = 'Congratulation!';
  String description = ksorderReceived;
  late Widget cardBottomWidget;
  bool selectingRider = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectRider(Rider rider, String orderId) async {
    setState(() => selectingRider = true);
    try {
      await DatabaseRepo().updateRiderPending(rider.documentID!, orderId);
      // Directly mark rider as accepted and assign to order
      await DatabaseRepo().updateStatusOrder(StatusOrder.driverFound, orderId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to assign rider: $e')),
      );
    }
    setState(() => selectingRider = false);
  }

  @override
  Widget build(BuildContext context) {
    PatientUid useraccount = Provider.of<PatientUid>(context);
    return StreamBuilder<OrderService>(
        stream: DatabaseRepo().streamCurrentOrder(),
        builder: (_, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            OrderService orderService = snapshot.data;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.w),
                child: Builder(builder: (context) {
                  if (orderService.riderRef == null) {
                    if (orderService.statusOrder == StatusOrder.findingDriver) {
                      if (orderService.orderQueryStatus == null) {
                        Future.microtask(() async {
                          await DatabaseRepo().updateOrderQueryStatus(
                              'findingDriver', orderService.documentID!);
                        });
                      }
                      // Show available riders list
                      return Column(
                        children: [
                          SizedBox(height: 60.h),
                          // Status header
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(24.w),
                            decoration: BoxDecoration(
                              color: kcWhite,
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: [
                                BoxShadow(
                                  color: kcCardShadow,
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.delivery_dining_rounded,
                                  size: 48.sp,
                                  color: kcOrange,
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  'Choose a Rider',
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w800,
                                    color: kcOrange,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Select an available rider to deliver your medication',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: kctextgrey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),
                          // Available riders list
                          StreamBuilder<List<Rider>?>(
                            stream: DatabaseRepo().streamFindRidersAvailable(),
                            builder: (_, riderSnapshot) {
                              if (riderSnapshot.hasData &&
                                  riderSnapshot.data != null &&
                                  riderSnapshot.data!.isNotEmpty) {
                                final riders = riderSnapshot.data!;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${riders.length} rider${riders.length > 1 ? 's' : ''} available',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: kctextDark,
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    ...riders.map((rider) => _RiderCard(
                                          rider: rider,
                                          isSelecting: selectingRider,
                                          onSelect: () => _selectRider(
                                              rider, orderService.documentID!),
                                        )),
                                  ],
                                );
                              } else if (riderSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 40.h),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                        color: kcPrimary),
                                  ),
                                );
                              } else {
                                return Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(32.w),
                                  decoration: BoxDecoration(
                                    color: kcWhite,
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(Icons.search_off_rounded,
                                          size: 48.sp, color: kcGreyLabel),
                                      SizedBox(height: 12.h),
                                      Text(
                                        'No riders available',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: kctextDark,
                                        ),
                                      ),
                                      SizedBox(height: 6.h),
                                      Text(
                                        'Please wait, riders will appear here when they come online.',
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: kctextgrey,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                          // Order summary
                          SizedBox(height: 16.h),
                          deliveryServiceStatusWidget(orderService),
                          SizedBox(height: 30.h),
                        ],
                      );
                    }
                    cardBottomWidget = deliveryServiceStatusWidget(orderService);
                    return Column(
                      children: [
                        gaphr(h: 120),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            color: kcWhite,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: orderStatusWidget(
                                statusWidget, textOrange, description),
                          ),
                        ),
                        cardBottomWidget,
                        gaphr(h: 23),
                      ],
                    );
                  } else {
                    return StreamBuilder(
                      stream: DatabaseRepo()
                          .getRiderStream(orderService.riderRef!),
                      builder: (_, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          Rider rider = snapshot.data;
                          switch (orderService.statusOrder) {
                            case StatusOrder.driverFound:
                              textOrange = 'Driver Found!';
                              description = ksorderReceived;
                              statusWidget = driverfoundStatusWidget(
                                ("${rider.firstName} ${rider.lastName}"),
                                rider.vehicleType,
                                rider.phoneNum,
                                4.5,
                                orderService.riderRef!,
                              );
                              cardBottomWidget =
                                  deliveryServiceStatusWidget(orderService);
                              break;
                            case StatusOrder.driverToHospital:
                              textOrange = 'On it!';
                              description = ksdriverToHospital;
                              statusWidget = kwdriverToHospitalStatusWidget;
                              cardBottomWidget = driverInfoStatusWidget(
                                driverInfoWidget(rider),
                                orderService,
                                useraccount.uid,
                                rider,
                              );
                              break;
                            case StatusOrder.driverQueue:
                              textOrange = 'Queueing';
                              description = ksdriverQueue;
                              statusWidget = kwdriverQueueStatusWidget;
                              cardBottomWidget = driverInfoStatusWidget(
                                driverInfoWidget(rider),
                                orderService,
                                useraccount.uid,
                                rider,
                              );
                              break;
                            case StatusOrder.orderPreparing:
                              textOrange = 'Order Preparing';
                              description = ksorderPreparing;
                              statusWidget = kworderPreparingStatusWidget;
                              cardBottomWidget = driverInfoStatusWidget(
                                driverInfoWidget(rider),
                                orderService,
                                useraccount.uid,
                                rider,
                              );
                              break;
                            case StatusOrder.outForDelivery:
                              textOrange = 'Out for Delivery!';
                              description = ksoutForDelivery;
                              statusWidget = kwOutForDeliveryStatusWidget;
                              cardBottomWidget = driverInfoStatusWidget(
                                driverInfoWidget(rider),
                                orderService,
                                useraccount.uid,
                                rider,
                              );
                              break;
                            case StatusOrder.orderArrived:
                              textOrange = orderService.serviceType ==
                                      ServiceType.requestDelivery
                                  ? 'Arrived!'
                                  : 'Finished!';
                              description = orderService.serviceType ==
                                      ServiceType.requestDelivery
                                  ? ksorderArrived
                                  : ksorderFinished2;
                              statusWidget = orderService.serviceType ==
                                      ServiceType.requestDelivery
                                  ? kworderArrivedStatusWidget
                                  : kworderFinishedStatusWidget(
                                      orderService.tokenUrlImage!);
                              cardBottomWidget = driverInfoStatusWidget(
                                  driverInfoWidget(rider),
                                  orderService,
                                  useraccount.uid,
                                  rider,
                                  arrived: true);
                              break;
                            default:
                              textOrange = 'Order Error ';
                              description =
                                  'system error for the current order';
                              statusWidget = gapw(w: 0);
                              cardBottomWidget = gapw(w: 0);
                              break;
                          }
                          return Column(
                            children: [
                              gaphr(h: 120),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r),
                                  color: kcWhite,
                                ),
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.w),
                                  child: orderStatusWidget(
                                      statusWidget, textOrange, description),
                                ),
                              ),
                              cardBottomWidget,
                              gaphr(h: 23),
                            ],
                          );
                        } else {
                          return Center(
                            child: SizedBox(
                              width: double.infinity,
                              height: 200,
                              child: Center(
                                child: loadingPillriveR(100),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  }
                }),
              ),
            );
          } else {
            return Center(
              child: SizedBox(
                width: double.infinity,
                height: 200,
                child: Center(
                  child: loadingPillriveR(100),
                ),
              ),
            );
          }
        });
  }

  Widget driverInfoStatusWidget(Widget driverInfo, OrderService orderService,
      String patientUid, Rider rider,
      {bool arrived = false}) {
    return Column(
      children: [
        gaphr(h: 16.5),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: kcWhite,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                gaphr(h: 19),
                driverInfo,
                gaphr(h: 10),
                kwDivider,
                gaphr(h: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Charge',
                      style: kwtextStyleRD(
                        c: kctextTitle,
                        fs: 15,
                        fw: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                gaphr(h: 12),
                Text(
                  DateFormat('dd/MM/yyyy')
                      .format(orderService.orderDate ?? DateTime.now()),
                  style: kwtextStyleRD(
                    c: kcGreyLabel,
                    fs: 15,
                  ),
                ),
                gaphr(h: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Service Charge',
                      style: kwtextStyleRD(
                        c: kctextTitle,
                        fs: 15,
                        fw: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'RM ${orderService.totalPay.toStringAsFixed(2)}',
                      style: kwtextStyleRD(
                        c: kcprimarySwatch,
                        fs: 15,
                        fw: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                gaphr(h: 15),
              ],
            ),
          ),
        ),
        gaphr(h: arrived ? 26.h : 8.5),
        arrived
            ? MaterialButton(
                color: kcPrimary,
                height: 44.h,
                minWidth: double.infinity,
                shape: cornerR(r: 8),
                child: Text(
                  'Continue',
                  style: kwtextStyleRD(
                    fs: 17,
                    c: kcWhite,
                    fw: FontWeight.w500,
                  ),
                ),
                onPressed: () async {
                  OrderService orderService =
                      await DatabaseRepo(uid: patientUid).getOrderService();
                  String? uid = orderService.documentID;

                  if (uid != null &&
                      orderService.statusOrder == StatusOrder.orderArrived) {
                    DatabaseRepo().updateOrderDateComplete(DateTime.now(), uid);
                    Navigator.of(context).pop();
                  }
                },
              )
            : Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                        shape: cornerR(r: 25),
                        height: 38.h,
                        color: kcWhite,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/icons/call_icon.png',
                              height: 13,
                            ),
                            gapwr(w: 10),
                            Text(
                              'Call',
                              style: kwtextStyleRD(
                                fs: 10,
                                c: kcPrimary,
                                fw: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        onPressed: () async {
                          final Uri callLaunchUrl = Uri(
                            scheme: 'tel',
                            path: rider.phoneNum,
                          );
                          try {
                            await launchUrl(callLaunchUrl);
                          } on Exception catch (e) {
                            print(e);
                          }
                        }),
                  ),
                  gapwr(w: 10),
                  Expanded(
                    child: MaterialButton(
                        shape: cornerR(r: 25),
                        color: kcPrimary,
                        height: 38.h,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset('assets/icons/chat_icon.png',
                                height: 13),
                            gapwr(w: 10),
                            Text(
                              'Message',
                              style: kwtextStyleRD(
                                fs: 10,
                                c: kcWhite,
                                fw: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        onPressed: () async {
                          final Uri smsLaunchUri = Uri(
                            scheme: 'sms',
                            path: rider.phoneNum,
                            queryParameters: <String, String>{
                              'body': Uri.encodeComponent('hello'),
                            },
                          );
                          if (await canLaunchUrl(smsLaunchUri)) {
                            await launchUrl(smsLaunchUri);
                          }
                        }),
                  )
                ],
              ),
      ],
    );
  }

  Widget deliveryServiceStatusWidget(OrderService orderService) {
    return Column(
      children: [
        gaphr(h: 30.5),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: kcWhite,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                gaphr(h: 15),
                Row(
                  children: [
                    Container(
                      height: 66.h,
                      width: 114.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: kcServiceBg,
                        image: DecorationImage(
                          image:
                              AssetImage('assets/images/request_delivery.png'),
                        ),
                      ),
                    ),
                    gapwr(w: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            orderService.serviceType ==
                                    ServiceType.requestDelivery
                                ? 'Delivery'
                                : 'Pickup',
                            style: kwtextStyleRD(
                              c: kctextTitle,
                              fs: 15,
                              fw: FontWeight.w600,
                            ),
                          ),
                          gaphr(h: 8),
                          Text(
                            orderService.facility?.facilityName ?? '',
                            style: kwtextStyleRD(
                              c: kcSubtitleService.withOpacity(0.56),
                              fs: 12,
                              fw: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                gaphr(h: 15),
                kwDivider,
                gaphr(h: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Charge',
                      style: kwtextStyleRD(
                        c: kctextTitle,
                        fs: 15,
                        fw: FontWeight.w600,
                      ),
                    ),
                    gapw(w: 0),
                  ],
                ),
                gaphr(h: 12),
                Text(
                  dateformatNumSlashI(DateTime.now()),
                  style: kwtextStyleRD(
                    c: kcGreyLabel,
                    fs: 15,
                  ),
                ),
                gaphr(h: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Service Charge',
                      style: kwtextStyleRD(
                        c: kctextTitle,
                        fs: 15,
                        fw: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'RM ${orderService.totalPay.toStringAsFixed(2)}',
                      style: kwtextStyleRD(
                        c: kcprimarySwatch,
                        fs: 15,
                        fw: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                gaphr(h: 15),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: const MySeparator(
            color: kcGreyLabel,
            width: 4,
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: kcWhite,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              children: [
                gaphr(h: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Pay',
                      style: kwtextStyleRD(
                        c: kctextTitle,
                        fs: 17,
                        fw: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'RM ${orderService.totalPay.toStringAsFixed(2)}',
                      style: kwtextStyleRD(
                        c: kcOrange,
                        fs: 17,
                        fw: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                gaphr(h: 15),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column orderStatusWidget(
      Widget statusWidget, String textOrange, String description) {
    return Column(
      children: [
        statusWidget,
        Text(
          textOrange,
          style: kwtextStyleRD(
            ff: 'SF UI Text',
            fs: 32,
            c: kcOrange,
            fw: FontWeight.w500,
          ),
        ),
        gaphr(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Text(
            description,
            style: kwtextStyleRD(fs: 15, c: kctextgrey, fw: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ),
        gaphr(h: 49.5),
      ],
    );
  }

  Widget driverfoundStatusWidget(String name, String vehicleName,
      String vehiclePlateNum, double rate, String riderId) {
    return Column(
      children: [
        gaphr(h: 63.5),
        FutureBuilder(
            future: DatabaseRepo().getRider(riderId),
            builder: (_, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                Rider rider = snapshot.data;
                return driverInfoWidget(rider);
              } else {
                return Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: Center(
                      child: loadingPillriveR(100),
                    ),
                  ),
                );
              }
            }),
        gaphr(h: 42)
      ],
    );
  }

  Widget driverInfoWidget(Rider rider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 54.h,
          height: 54.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kcPrimary.withValues(alpha: 0.1),
          ),
          child: Center(
            child: Text(
              rider.firstName.isNotEmpty ? rider.firstName[0].toUpperCase() : 'R',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: kcPrimary,
              ),
            ),
          ),
        ),
        gapwr(w: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${rider.firstName} ${rider.lastName}',
              style: kwtextStyleRD(
                fs: 14,
                c: kcPrimary,
                fw: FontWeight.w600,
              ),
            ),
            Text(
              rider.vehicleType,
              style: kwtextStyleRD(
                fs: 14,
                c: kcsubtitleListTile1,
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _RiderCard extends StatelessWidget {
  final Rider rider;
  final bool isSelecting;
  final VoidCallback onSelect;

  const _RiderCard({
    required this.rider,
    required this.isSelecting,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: kcWhite,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: kcCardShadow,
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              color: kcPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Center(
              child: Text(
                rider.firstName.isNotEmpty
                    ? rider.firstName[0].toUpperCase()
                    : 'R',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: kcPrimary,
                ),
              ),
            ),
          ),
          SizedBox(width: 14.w),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${rider.firstName} ${rider.lastName}',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: kctextDark,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.two_wheeler_rounded,
                        size: 16.sp, color: kctextgrey),
                    SizedBox(width: 4.w),
                    Text(
                      rider.vehicleType,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: kctextgrey,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Icon(Icons.phone_outlined,
                        size: 14.sp, color: kctextgrey),
                    SizedBox(width: 4.w),
                    Text(
                      rider.phoneNum,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: kctextgrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Select button
          GestureDetector(
            onTap: isSelecting ? null : onSelect,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F4C75), Color(0xFF3282B8)],
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: isSelecting
                  ? SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: const CircularProgressIndicator(
                        color: kcWhite,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Select',
                      style: TextStyle(
                        color: kcWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.sp,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
