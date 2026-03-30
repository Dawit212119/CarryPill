import 'package:carrypill/data/models/all_enum.dart';
import 'package:carrypill/data/models/facility.dart';

class OrderService {
  Facility? facility;
  StatusOrder statusOrder;
  ServiceType? serviceType;
  PaymentMethod? paymentMethod;
  double totalPay;
  DateTime? orderDate;
  DateTime? orderDateComplete;
  String? orderQueryStatus;
  String? patientRef;
  String? riderRef;
  List<String>? riderCancelId;
  bool? riderPending;
  int? tokenNum;
  String? tokenUrlImage;
  String? documentID;

  OrderService({
    this.facility,
    this.statusOrder = StatusOrder.noOrder,
    this.serviceType,
    this.paymentMethod,
    this.totalPay = 0,
    this.orderDate,
    this.orderDateComplete,
    this.orderQueryStatus,
    this.patientRef,
    this.riderRef,
    this.riderCancelId,
    this.riderPending,
    this.tokenNum,
    this.tokenUrlImage,
    this.documentID,
  });

  factory OrderService.fromMap(Map<String, dynamic> map) {
    return OrderService(
      facility: map['facility'] != null
          ? Facility.fromMap(Map<String, dynamic>.from(map['facility']))
          : null,
      statusOrder: map['statusOrder'] != null || map['status_order'] != null
          ? StatusOrder.values
              .byName(map['statusOrder'] ?? map['status_order'])
          : StatusOrder.noOrder,
      serviceType: map['serviceType'] != null || map['service_type'] != null
          ? ServiceType.values
              .byName(map['serviceType'] ?? map['service_type'])
          : null,
      paymentMethod: map['paymentMethod'] != null ||
              map['paymentType'] != null ||
              map['payment_type'] != null
          ? PaymentMethod.values.byName(map['paymentMethod'] ??
              map['paymentType'] ??
              map['payment_type'])
          : null,
      totalPay: (map['totalPay'] ?? map['total_pay'] ?? 0).toDouble(),
      orderDate: _parseDate(map['orderDate'] ?? map['order_date']),
      orderDateComplete:
          _parseDate(map['orderDateComplete'] ?? map['order_date_complete']),
      orderQueryStatus: map['orderQueryStatus'] ?? map['order_query_status'],
      patientRef: map['patientRef'] ?? map['patient_ref']?.toString(),
      riderRef: map['riderRef'] ?? map['rider_ref']?.toString(),
      riderCancelId: map['riderCancelId'] != null || map['rider_cancel_id'] != null
          ? List<String>.from(map['riderCancelId'] ?? map['rider_cancel_id'])
          : null,
      riderPending: map['riderPending'] ?? map['rider_pending'],
      tokenNum: map['tokenNum'] ?? map['token_num'],
      tokenUrlImage: map['tokenUrlImage'] ?? map['token_url_image'],
      documentID: map['documentID'] ?? map['id']?.toString(),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  Map<String, dynamic> toMap() => {
        'facility': facility?.toMap(),
        'statusOrder': statusOrder.name,
        'serviceType': serviceType?.name,
        'paymentType': paymentMethod?.name,
        'totalPay': totalPay,
        'orderDate': orderDate?.toIso8601String(),
        'orderDateComplete': orderDateComplete?.toIso8601String(),
        'orderQueryStatus': orderQueryStatus,
        'patientRef': patientRef,
        'riderRef': riderRef,
        'riderCancelId': riderCancelId,
        'riderPending': riderPending,
        'tokenNum': tokenNum,
        'tokenUrlImage': tokenUrlImage,
      };

  @override
  String toString() {
    return '{${statusOrder.toString()}, ${orderDate.toString()}, ${orderDateComplete.toString()},${totalPay.toString()},${paymentMethod.toString()},${orderDate.toString()},${serviceType.toString()},${patientRef.toString()} ';
  }

  @override
  bool operator ==(other) =>
      other is OrderService && documentID == other.documentID;

  @override
  int get hashCode => documentID.hashCode;
}
