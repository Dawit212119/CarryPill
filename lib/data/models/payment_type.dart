import 'package:carrypill/data/models/all_enum.dart';

// View model pairing a PaymentMethod with its display name and icon asset
// for rendering the payment option list.
class PaymentType {
  String imgPath;
  String paymentName;
  PaymentMethod paymentMethod;

  PaymentType(
      {required this.imgPath,
      required this.paymentName,
      required this.paymentMethod});
}
