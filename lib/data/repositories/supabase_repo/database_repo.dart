import 'package:carrypill/data/dataproviders/supabase_provider/database_provider.dart';
import 'package:carrypill/data/models/all_enum.dart';
import 'package:carrypill/data/models/clinic.dart';
import 'package:carrypill/data/models/facility.dart';
import 'package:carrypill/data/models/geo_point.dart';
import 'package:carrypill/data/models/order_service.dart';
import 'package:carrypill/data/models/patient.dart';
import 'package:carrypill/data/models/rider.dart';

class DatabaseRepo {
  final String? uid;
  DatabaseRepo({this.uid});

  Future updateAllPatientData(Patient patient) async {
    await DatabaseProvider(uid: uid).updateAllPatientInfoData(patient);
  }

  Future updatePatientInfo({
    required String name,
    required String patientId,
    required String icNum,
    required String phoneNum,
    required String address,
    GeoPoint? geoPoint,
    String? profileImageUrl,
  }) async {
    await DatabaseProvider(uid: uid).updatePatientInfoData(
      name,
      patientId,
      icNum,
      phoneNum,
      address,
      geoPoint,
      profileImageUrl,
    );
  }

  Future updateAppointment(DateTime dateTime) async {
    await DatabaseProvider(uid: uid).updatePatientAppointmentDate(dateTime);
  }

  Future updateClinic(List<Clinic> clinicList) async {
    await DatabaseProvider(uid: uid).updateClinicList(clinicList);
  }

  Stream<Patient?> get streamPatient {
    return DatabaseProvider(uid: uid).streamPatientInfoData;
  }

  Future<Patient?> get futurePatient {
    return DatabaseProvider(uid: uid).futurePatientInfoData;
  }

  Future addClinic(Clinic clinic) async {
    return DatabaseProvider(uid: uid).addFollowUpClinic(clinic);
  }

  Future<List<Facility>> get facilityList async {
    return DatabaseProvider().facilityList;
  }

  Future<String> addOrder(OrderService orderService) async {
    return DatabaseProvider(uid: uid).addOrderService(orderService);
  }

  Future updateStatusOrder(StatusOrder statusOrder, String orderId) async {
    return DatabaseProvider().updateOrderStatus(statusOrder, orderId);
  }

  Future<void> cancelOrder(String orderId) async {
    await DatabaseProvider().updateOrderStatus(
      StatusOrder.orderCancelled,
      orderId,
    );
  }

  Future<List<OrderService>> fetchOrdersByService(
    ServiceType serviceType, {
    bool descending = true,
  }) {
    return DatabaseProvider(uid: uid)
        .fetchOrdersByService(serviceType, descending: descending);
  }

  Future<List<OrderService>> fetchAllOrders({bool descending = true}) {
    return DatabaseProvider(uid: uid).fetchAllOrders(descending: descending);
  }

  Future updateOrderDateComplete(DateTime dateTime, String id) async {
    return DatabaseProvider().updateOrderDateComplete(dateTime, id);
  }

  Future getOrderService() async {
    return DatabaseProvider(uid: uid).getOrderService();
  }

  Future updateOrderQueryStatus(String orderQueryStatus, String orderId) async {
    return DatabaseProvider().updateOrderQueryStatus(orderQueryStatus, orderId);
  }

  Stream<OrderService> streamCurrentOrder({bool descending = true}) {
    return DatabaseProvider(uid: uid).streamUserCurrentOrder(descending: descending);
  }

  Stream<List<OrderService>> streamListOrder({bool descending = true}) {
    return DatabaseProvider(uid: uid).getOrderListStream(descending);
  }

  Stream<List<OrderService>> streamListOrderDelivery({bool descending = true}) {
    return DatabaseProvider(uid: uid).getOrderListStreamDelivery(descending);
  }

  Stream<List<OrderService>> streamListOrderPickup({bool descending = true}) {
    return DatabaseProvider(uid: uid).getOrderListStreamPickup(descending);
  }

  Future getRider(String riderId) async {
    return DatabaseProvider().getCurrentRider(riderId);
  }

  Stream<Rider?> getRiderStream(String riderId) {
    return DatabaseProvider().getCurrentRiderStream(riderId);
  }

  Future updateRiderPending(String riderId, String orderId) async {
    return DatabaseProvider(uid: uid).updateRiderPending(riderId, orderId);
  }

  Future updateRiderWorkingStatus(String status) async {
    return DatabaseProvider(uid: uid).updateRiderWorkingStatus(status);
  }

  Stream<Rider> streamRiderPendingStatus(String riderId) {
    return DatabaseProvider().getRiderPendingStatus(riderId);
  }

  Stream<Rider> streamFindRiderAvailable({bool descending = true}) {
    return DatabaseProvider().getRiderAvailable(descending);
  }

  Stream<List<Rider>?> streamFindRidersAvailable({bool descending = true}) {
    return DatabaseProvider().getRiderListAvailableStream(descending);
  }
}
