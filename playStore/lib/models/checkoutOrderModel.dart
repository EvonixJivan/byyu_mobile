import 'package:byyu/models/orderDetailsModel.dart';

class CheckoutOrder {
  String? status;
  String? message;
  double? totalOrderAmt;
  double? cartPaidByWallet;
  double? deliveryFeeAmt;
  double? totalCouponDiscount;
  String? paymentStatuss;
  List<OrderDetails>? orderDetails;

  CheckoutOrder.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalOrderAmt = double.parse(json['total_order_amt'].toStringAsFixed(2));
    deliveryFeeAmt = double.parse(json['delivery_fee_amt'].toStringAsFixed(2));
    cartPaidByWallet = double.parse(json['cart_paid_by_wallet'].toStringAsFixed(2));
    totalCouponDiscount =
        double.parse(json['total_coupon_discount'].toStringAsFixed(2));
    paymentStatuss = json['payment_statuss'];
    if (json['data'] != null) {
      orderDetails = <OrderDetails>[];
      json['data'].forEach((v) {
        orderDetails!.add(new OrderDetails.fromJson(v));
      });
    }
  }
}
