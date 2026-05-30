import 'package:carrypill/constants/constant_color.dart';
import 'package:carrypill/core/utils/delivery_eta_utils.dart';
import 'package:carrypill/core/utils/order_status_utils.dart';
import 'package:carrypill/data/models/geo_point.dart';
import 'package:carrypill/data/models/order_service.dart';
import 'package:carrypill/data/models/rider.dart';
import 'package:carrypill/data/repositories/supabase_repo/database_repo.dart';
import 'package:carrypill/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

class OrderTrackingPage extends StatefulWidget {
  final OrderService order;
  final GeoPoint? patientLocation;

  const OrderTrackingPage({
    super.key,
    required this.order,
    this.patientLocation,
  });

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final facility = widget.order.facility;
    if (facility == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.liveTracking)),
        body: const Center(child: Text('Facility information unavailable')),
      );
    }

    final facilityPoint = LatLng(
      facility.geoPoint.latitude,
      facility.geoPoint.longitude,
    );
    final patientPoint = widget.patientLocation != null
        ? LatLng(
            widget.patientLocation!.latitude,
            widget.patientLocation!.longitude,
          )
        : null;

    final riderId = widget.order.riderRef;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.liveTracking),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: Center(
              child: Text(
                OrderStatusUtils.label(widget.order.statusOrder),
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: riderId == null
                ? _buildMap(
                    center: patientPoint ?? facilityPoint,
                    facility: facilityPoint,
                    patient: patientPoint,
                    rider: null,
                  )
                : StreamBuilder<Rider?>(
                    stream: DatabaseRepo().getRiderStream(riderId),
                    builder: (context, snapshot) {
                      LatLng? riderPoint;
                      final rider = snapshot.data;
                      if (rider?.currrentLocation != null) {
                        riderPoint = LatLng(
                          rider!.currrentLocation!.latitude,
                          rider.currrentLocation!.longitude,
                        );
                      }
                      final center = riderPoint ??
                          patientPoint ??
                          facilityPoint;
                      return _buildMap(
                        center: center,
                        facility: facilityPoint,
                        patient: patientPoint,
                        rider: riderPoint,
                      );
                    },
                  ),
          ),
          _EtaBar(
            facility: facilityPoint,
            patient: patientPoint,
            riderId: riderId,
          ),
          _LegendBar(hasRider: riderId != null),
        ],
      ),
    );
  }

  Widget _buildMap({
    required LatLng center,
    required LatLng facility,
    LatLng? patient,
    LatLng? rider,
  }) {
    final markers = <Marker>[
      Marker(
        point: facility,
        width: 40,
        height: 40,
        child: const _MapPin(icon: Icons.local_hospital_rounded, color: kcPrimary),
      ),
      if (patient != null)
        Marker(
          point: patient,
          width: 40,
          height: 40,
          child: const _MapPin(icon: Icons.home_rounded, color: kcOrange),
        ),
      if (rider != null)
        Marker(
          point: rider,
          width: 40,
          height: 40,
          child: const _MapPin(icon: Icons.two_wheeler_rounded, color: Color(0xFF2E7D6B)),
        ),
    ];

    return FlutterMap(
      options: MapOptions(
        initialCenter: center,
        initialZoom: 13,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.carrypill',
        ),
        MarkerLayer(markers: markers),
      ],
    );
  }
}

class _EtaBar extends StatelessWidget {
  final LatLng facility;
  final LatLng? patient;
  final String? riderId;

  const _EtaBar({
    required this.facility,
    required this.patient,
    required this.riderId,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (riderId == null) {
      return _buildStaticEta(context, l10n, from: facility, to: patient);
    }

    return StreamBuilder<Rider?>(
      stream: DatabaseRepo().getRiderStream(riderId!),
      builder: (context, snapshot) {
        final rider = snapshot.data?.currrentLocation;
        if (rider == null) {
          return _buildStaticEta(context, l10n, from: facility, to: patient);
        }

        final riderPoint = LatLng(rider.latitude, rider.longitude);
        final destination = patient ?? facility;
        return _buildEtaContent(
          context,
          l10n,
          fromLat: riderPoint.latitude,
          fromLon: riderPoint.longitude,
          toLat: destination.latitude,
          toLon: destination.longitude,
        );
      },
    );
  }

  Widget _buildStaticEta(
    BuildContext context,
    AppLocalizations l10n, {
    required LatLng from,
    LatLng? to,
  }) {
    if (to == null) {
      return _buildUnavailable(context, l10n);
    }

    return _buildEtaContent(
      context,
      l10n,
      fromLat: from.latitude,
      fromLon: from.longitude,
      toLat: to.latitude,
      toLon: to.longitude,
    );
  }

  Widget _buildUnavailable(BuildContext context, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      color: kcBgHome1,
      child: Row(
        children: [
          Icon(Icons.schedule_rounded, color: kctextgrey, size: 18.sp),
          SizedBox(width: 8.w),
          Text(
            l10n.etaUnavailable,
            style: TextStyle(fontSize: 13.sp, color: kctextgrey),
          ),
        ],
      ),
    );
  }

  Widget _buildEtaContent(
    BuildContext context,
    AppLocalizations l10n, {
    required double fromLat,
    required double fromLon,
    required double toLat,
    required double toLon,
  }) {
    final distanceKm =
        DeliveryEtaUtils.distanceKm(fromLat, fromLon, toLat, toLon);
    final minutes = DeliveryEtaUtils.estimateMinutes(distanceKm);
    final eta = DeliveryEtaUtils.formatDuration(minutes);
    final distance = DeliveryEtaUtils.formatDistance(distanceKm);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: kcPrimary.withValues(alpha: 0.08),
        border: Border(top: BorderSide(color: kcPrimary.withValues(alpha: 0.15))),
      ),
      child: Row(
        children: [
          Icon(Icons.access_time_filled_rounded, color: kcPrimary, size: 22.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.etaLabel(eta),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: kcPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  l10n.distanceAway(distance),
                  style: TextStyle(fontSize: 12.sp, color: kctextgrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _MapPin({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }
}

class _LegendBar extends StatelessWidget {
  final bool hasRider;

  const _LegendBar({required this.hasRider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: kcWhite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _legend(Icons.local_hospital_rounded, 'Hospital', kcPrimary),
          _legend(Icons.home_rounded, 'You', kcOrange),
          if (hasRider) _legend(Icons.two_wheeler_rounded, 'Rider', const Color(0xFF2E7D6B)),
        ],
      ),
    );
  }

  Widget _legend(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 18),
        SizedBox(width: 4.w),
        Text(label, style: TextStyle(fontSize: 12.sp, color: kctextgrey)),
      ],
    );
  }
}
