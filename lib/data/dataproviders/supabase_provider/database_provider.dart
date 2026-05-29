import 'package:carrypill/data/models/all_enum.dart';
import 'package:carrypill/data/models/clinic.dart';
import 'package:carrypill/data/models/facility.dart';
import 'package:carrypill/data/models/geo_point.dart';
import 'package:carrypill/data/models/order_service.dart';
import 'package:carrypill/data/models/patient.dart';
import 'package:carrypill/data/models/profile.dart';
import 'package:carrypill/data/models/rider.dart';
import 'package:carrypill/data/models/vehicle.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseProvider {
  final String? uid;
  DatabaseProvider({this.uid});

  SupabaseClient get _client => Supabase.instance.client;

  String? get _effectiveUid => uid ?? _client.auth.currentUser?.id;

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  Map<String, dynamic> _patientToRow(Patient patient, String userId) => {
        'uid': userId,
        'name': patient.name,
        'ic_num': patient.icNum,
        'phone_num': patient.phoneNum,
        'patient_id': patient.patientId,
        'address': patient.address,
        'clinic_list': patient.clinicList.map((e) => e.toMap()).toList(),
        'appointment': patient.appointment?.toIso8601String(),
        'geo_lat': patient.geoPoint?.latitude,
        'geo_lng': patient.geoPoint?.longitude,
        'profile_image_url': patient.profileImageUrl,
      };

  Patient? _patientFromRow(Map<String, dynamic> row) {
    final clinicRaw = row['clinic_list'];
    return Patient(
      name: row['name'] ?? '',
      icNum: row['ic_num'] ?? '',
      phoneNum: row['phone_num'] ?? '',
      patientId: row['patient_id'],
      address: row['address'],
      clinicList: clinicRaw is List
          ? clinicRaw
              .map<Clinic>((item) => Clinic.fromMap(Map<String, dynamic>.from(item)))
              .toList()
          : [],
      appointment: _parseDate(row['appointment']),
      geoPoint: row['geo_lat'] != null && row['geo_lng'] != null
          ? GeoPoint(
              (row['geo_lat'] as num).toDouble(),
              (row['geo_lng'] as num).toDouble(),
            )
          : null,
      profileImageUrl: row['profile_image_url'],
      documentID: row['uid']?.toString(),
    );
  }

  Facility _facilityFromRow(Map<String, dynamic> row) => Facility(
        facilityName: row['facility_name'],
        fullAddress: row['full_address'],
        geoPoint: GeoPoint(
          (row['geo_lat'] as num).toDouble(),
          (row['geo_lng'] as num).toDouble(),
        ),
        documentID: row['id']?.toString(),
      );

  OrderService _orderFromRow(Map<String, dynamic> row) {
    final facilityRaw = row['facility'];
    return OrderService(
      facility: facilityRaw != null
          ? Facility.fromMap(Map<String, dynamic>.from(facilityRaw))
          : null,
      statusOrder: row['status_order'] != null
          ? StatusOrder.values.byName(row['status_order'])
          : StatusOrder.noOrder,
      serviceType: row['service_type'] != null
          ? ServiceType.values.byName(row['service_type'])
          : null,
      paymentMethod: row['payment_type'] != null
          ? PaymentMethod.values.byName(row['payment_type'])
          : null,
      totalPay: (row['total_pay'] as num?)?.toDouble() ?? 0,
      orderDate: _parseDate(row['order_date']),
      orderDateComplete: _parseDate(row['order_date_complete']),
      orderQueryStatus: row['order_query_status'],
      patientRef: row['patient_ref']?.toString(),
      riderRef: row['rider_ref']?.toString(),
      riderCancelId: row['rider_cancel_id'] != null
          ? List<String>.from(row['rider_cancel_id'])
          : null,
      riderPending: row['rider_pending'],
      tokenNum: row['token_num'],
      tokenUrlImage: row['token_url_image'],
      documentID: row['id']?.toString(),
    );
  }

  Map<String, dynamic> _orderToRow(OrderService order) => {
        'facility': order.facility?.toMap(),
        'status_order': order.statusOrder.name,
        'service_type': order.serviceType?.name,
        'payment_type': order.paymentMethod?.name,
        'total_pay': order.totalPay,
        'order_date': order.orderDate?.toIso8601String(),
        'order_date_complete': order.orderDateComplete?.toIso8601String(),
        'order_query_status': order.orderQueryStatus,
        'patient_ref': order.patientRef ?? _effectiveUid,
        'rider_ref': order.riderRef,
        'rider_cancel_id': order.riderCancelId,
        'rider_pending': order.riderPending,
        'token_num': order.tokenNum,
        'token_url_image': order.tokenUrlImage,
      };

  Rider _riderFromRow(Map<String, dynamic> row) => Rider(
        firstName: row['first_name'] ?? '',
        lastName: row['last_name'] ?? '',
        phoneNum: row['phone_num'] ?? '',
        vehicleType: row['vehicle_type'] ?? '',
        workingStatus: row['working_status'] ?? '',
        isWorking: row['is_working'] ?? false,
        autoAccept: row['auto_accept'] ?? false,
        currrentLocation: row['current_lat'] != null && row['current_lng'] != null
            ? GeoPoint(
                (row['current_lat'] as num).toDouble(),
                (row['current_lng'] as num).toDouble(),
              )
            : null,
        isProfileComplete: row['is_profile_complete'],
        startWorkingDate: _parseDate(row['start_working_date']),
        currentOrderId: row['current_order_id']?.toString(),
        orderCancelId: row['order_cancel_id'] != null
            ? List<String>.from(row['order_cancel_id'])
            : null,
        profile: row['profile'] != null
            ? Profile.fromMap(Map<String, dynamic>.from(row['profile']))
            : null,
        vehicle: row['vehicle'] != null
            ? Vehicle.fromMap(Map<String, dynamic>.from(row['vehicle']))
            : null,
        earning: (row['earning'] as num?)?.toDouble() ?? 0,
        documentID: row['id']?.toString(),
      );

  Future updateAllPatientInfoData(Patient patient) async {
    final userId = _effectiveUid;
    if (userId == null) return;
    await _client.from('patients').upsert(_patientToRow(patient, userId));
  }

  Future updatePatientInfoData(
    String name,
    String patientId,
    String icNum,
    String phoneNum,
    String address,
    GeoPoint? geoPoint,
    String? profileImageUrl,
  ) async {
    final userId = _effectiveUid;
    if (userId == null) return;
    await _client.from('patients').update({
      'name': name,
      'phone_num': phoneNum,
      'patient_id': patientId,
      'address': address,
      'geo_lat': geoPoint?.latitude,
      'geo_lng': geoPoint?.longitude,
      'profile_image_url': profileImageUrl,
    }).eq('uid', userId);
  }

  Future updatePatientAppointmentDate(DateTime appointment) async {
    final userId = _effectiveUid;
    if (userId == null) return;
    await _client.from('patients').update({
      'appointment': appointment.toIso8601String(),
    }).eq('uid', userId);
  }

  Future updateClinicList(List<Clinic> clinicList) async {
    final userId = _effectiveUid;
    if (userId == null) return;
    await _client.from('patients').update({
      'clinic_list': clinicList.map((e) => e.toMap()).toList(),
    }).eq('uid', userId);
  }

  Stream<Patient?> get streamPatientInfoData {
    final userId = _effectiveUid;
    if (userId == null) return Stream.value(null);
    return _client
        .from('patients')
        .stream(primaryKey: ['uid'])
        .eq('uid', userId)
        .map((rows) => rows.isEmpty ? null : _patientFromRow(rows.first));
  }

  Future<Patient?> get futurePatientInfoData async {
    final userId = _effectiveUid;
    if (userId == null) return null;
    final row = await _client
        .from('patients')
        .select()
        .eq('uid', userId)
        .maybeSingle();
    if (row == null) return null;
    return _patientFromRow(row);
  }

  Future addFollowUpClinic(Clinic clinic) async {
    // Clinics are stored on the patient profile in Supabase.
  }

  Future addFacility(Facility facility) async {
    await _client.from('healthcare_facilities').insert({
      'facility_name': facility.facilityName,
      'full_address': facility.fullAddress,
      'geo_lat': facility.geoPoint.latitude,
      'geo_lng': facility.geoPoint.longitude,
    });
  }

  Future<List<Facility>> get facilityList async {
    final rows = await _client.from('healthcare_facilities').select();
    return rows.map<Facility>((row) => _facilityFromRow(row)).toList();
  }

  Future<String> addOrderService(OrderService orderService) async {
    final row = await _client
        .from('orders')
        .insert(_orderToRow(orderService))
        .select('id')
        .single();
    return row['id'].toString();
  }

  Future updateOrderStatus(StatusOrder statusOrder, String orderId) async {
    await _client.from('orders').update({
      'status_order': statusOrder.name,
    }).eq('id', orderId);
  }

  Future updateRiderPending(String riderId, String orderId) async {
    await _client.from('riders').update({
      'working_status': 'Pending',
      'current_order_id': orderId,
    }).eq('id', riderId);
    await _client.from('orders').update({
      'rider_pending': true,
    }).eq('id', orderId);
  }

  Future updateOrderDateComplete(DateTime dateTime, String id) async {
    await _client.from('orders').update({
      'order_date_complete': dateTime.toIso8601String(),
    }).eq('id', id);
  }

  Future<OrderService> getOrderService() async {
    final userId = _effectiveUid;
    final rows = await _client
        .from('orders')
        .select()
        .eq('patient_ref', userId!)
        .order('order_date', ascending: false)
        .limit(1);
    return _orderFromRow(rows.first);
  }

  Future updateOrderQueryStatus(String orderQueryStatus, String orderId) async {
    await _client.from('orders').update({
      'order_query_status': orderQueryStatus,
    }).eq('id', orderId);
  }

  Stream<OrderService> streamUserCurrentOrder({bool descending = true}) {
    final userId = _effectiveUid;
    if (userId == null) {
      return Stream.error(StateError('No authenticated user'));
    }
    return _client
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('patient_ref', userId)
        .order('order_date', ascending: !descending)
        .map((rows) {
          if (rows.isEmpty) {
            throw StateError('No orders found');
          }
          return _orderFromRow(rows.first);
        });
  }

  Stream<List<OrderService>> getOrderListStream(bool descending) {
    final userId = _effectiveUid;
    if (userId == null) return Stream.value([]);
    return _client
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('patient_ref', userId)
        .order('order_date', ascending: !descending)
        .map((rows) => rows.map(_orderFromRow).toList());
  }

  Stream<List<OrderService>> getOrderListStreamDelivery(bool descending) {
    final userId = _effectiveUid;
    if (userId == null) return Stream.value([]);
    return _client
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('patient_ref', userId)
        .order('order_date', ascending: !descending)
        .map((rows) => rows
            .where((row) => row['service_type'] == 'requestDelivery')
            .map(_orderFromRow)
            .toList());
  }

  Stream<List<OrderService>> getOrderListStreamPickup(bool descending) {
    final userId = _effectiveUid;
    if (userId == null) return Stream.value([]);
    return _client
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('patient_ref', userId)
        .order('order_date', ascending: !descending)
        .map((rows) => rows
            .where((row) => row['service_type'] == 'requestPickup')
            .map(_orderFromRow)
            .toList());
  }

  Future<List<OrderService>> fetchOrdersByService(
    ServiceType serviceType, {
    bool descending = true,
  }) async {
    final userId = _effectiveUid;
    if (userId == null) return [];
    final rows = await _client
        .from('orders')
        .select()
        .eq('patient_ref', userId)
        .eq('service_type', serviceType.name)
        .order('order_date', ascending: !descending);
    return rows.map(_orderFromRow).toList();
  }

  Future<List<OrderService>> fetchAllOrders({bool descending = true}) async {
    final userId = _effectiveUid;
    if (userId == null) return [];
    final rows = await _client
        .from('orders')
        .select()
        .eq('patient_ref', userId)
        .order('order_date', ascending: !descending);
    return rows.map(_orderFromRow).toList();
  }

  Future<Rider> getCurrentRider(String riderId) async {
    final row =
        await _client.from('riders').select().eq('id', riderId).single();
    return _riderFromRow(row);
  }

  Stream<Rider?> getCurrentRiderStream(String riderId) {
    return _client
        .from('riders')
        .stream(primaryKey: ['id'])
        .eq('id', riderId)
        .map((rows) => rows.isEmpty ? null : _riderFromRow(rows.first));
  }

  Stream<Rider> getRiderAvailable(bool descending) {
    return _client
        .from('riders')
        .stream(primaryKey: ['id'])
        .eq('working_status', 'isWaitingForOrder')
        .order('start_working_date', ascending: !descending)
        .map((rows) => _riderFromRow(rows.first));
  }

  Stream<Rider> getRiderPendingStatus(String riderId) {
    return _client
        .from('riders')
        .stream(primaryKey: ['id'])
        .eq('id', riderId)
        .map((rows) => _riderFromRow(rows.first));
  }

  Stream<List<Rider>?> getRiderListAvailableStream(bool descending) {
    return _client
        .from('riders')
        .stream(primaryKey: ['id'])
        .eq('working_status', 'isWaitingForOrder')
        .order('start_working_date', ascending: !descending)
        .map((rows) => rows.map(_riderFromRow).toList());
  }

  Future updateRiderWorkingStatus(String status) async {
    final userId = _effectiveUid;
    if (userId == null) return;
    await _client.from('riders').update({
      'working_status': status,
    }).eq('id', userId);
  }
}
