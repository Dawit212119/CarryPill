import 'package:carrypill/constants/constant_color.dart';
import 'package:carrypill/core/utils/order_status_utils.dart';
import 'package:carrypill/data/models/geo_point.dart';
import 'package:carrypill/data/models/order_service.dart';
import 'package:carrypill/data/models/rider.dart';
import 'package:carrypill/data/repositories/supabase_repo/database_repo.dart';
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
    final facility = widget.order.facility;
    if (facility == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Live tracking')),
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
        title: const Text('Live tracking'),
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
