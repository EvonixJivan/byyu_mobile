import 'package:byyu/models/categoryProductModel.dart';

class OrderDetailsResponse {
  String? status;
  String? message;
  List<OrderDetails>? orderDetails;

  OrderDetailsResponse({this.status, this.message, this.orderDetails});

  OrderDetailsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      orderDetails = <OrderDetails>[];
      json['data'].forEach((v) {
        orderDetails?.add(new OrderDetails.fromJson(v));
      });
    }
  }
}

class OrderDetails {
  String? userName;
  String? deliveryAddress;
  String? orderStatus;
  String? deliveryDate;
  String? timeSlot;
  String? paymentMethod;
  String? paymentStatus;
  double? paidByWallet;
  String? cartId;
  double? totalPrice;
  double? deliveryCharge;
  double? remPrice;
  double? couponDiscount;
  String? dboyName;
  String? dboyPhone;
  double? priceWithoutDelivery;
  double? avgTaxPer;
  double? totalTaxPrice;
  int? userId;
  double? totalProductsMrp;
  double? discountonmrp;
  String? cancellingReason;
  String? orderDate;
  String? dboyId;
  String? userSignature;
  String? couponId;
  String? dboyIncentive;
  int? totalItems;
  int? isSubscription;
  int? totalDelivery;
  String? repeatOrders;
  String? siSubRefNo;
  String? siOrder;
  String? bankId;
  String? cancelReason;
  String? createdDatetime;
  String? processingDatetime;
  String? readyForPickupDatetime;
  String? outOfDeliveryDatetime;
  String? completeDeliveryDatetime;
  String? refundDatetime;
  String? cancelledDatetime;
  String? actualOrderId;
  Product? product;

  OrderDetails.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];

    deliveryAddress = json['delivery_address'];

    orderStatus = json['order_status'];

    deliveryDate = json['delivery_date'];

    timeSlot = json['time_slot'];

    paymentMethod = json['payment_method'];

    paymentStatus = json['payment_status'];

    paidByWallet = json['paid_by_wallet'] != null
        ? double.parse(json['paid_by_wallet'].toStringAsFixed(2))
        : 0.0;

    cartId = json['cart_id'];
    actualOrderId = json['group_cart_id'];

    totalPrice = json['total_price'] != null
        ? double.parse(json['total_price'].toString())
        : 0.0;

    deliveryCharge = json['delivery_charge'] != null
        ? double.parse(json['delivery_charge'].toString())
        : 0.0;

    remPrice = json['rem_price'] != null
        ? double.parse(json['rem_price'].toString())
        : 0.0;

    couponDiscount = json['coupon_discount'] != null
        ? double.parse(json['coupon_discount'].toString())
        : 0.0;

    dboyName = json['dboy_name'];

    dboyPhone = json['dboy_phone'];

    priceWithoutDelivery = json['price_without_delivery'] != null
        ? double.parse(json['price_without_delivery'].toString())
        : 0.0;

    avgTaxPer = json['avg_tax_per'] != null
        ? double.parse(json['avg_tax_per'].toString())
        : 0.0;

    totalTaxPrice = json['total_tax_price'] != null
        ? double.parse(json['total_tax_price'].toString())
        : 0.0;

    userId = json['user_id'];
    totalProductsMrp = json['total_products_mrp'] != null
        ? double.parse(json['total_products_mrp'].toString())
        : 0.0;
    discountonmrp = json['discountonmrp'] != null
        ? double.parse(json['discountonmrp'].toString())
        : 0.0;

    cancellingReason = json['cancelling_reason'];

    orderDate = json['order_date'];

    dboyId = json['dboy_id'];

    userSignature = json['user_signature'];

    couponId = json['coupon_id'];

    dboyIncentive = json['dboy_incentive'];

    totalItems = json['total_items'];

    isSubscription = json['is_subscription'];

    totalDelivery = json['total_delivery'];

    repeatOrders = json['repeat_orders'];

    siSubRefNo = json['si_sub_ref_no'];

    siOrder = json['si_order'];

    bankId = json['bank_id'];

    cancelReason = json['cancel_reason'];

    createdDatetime = json['created_datetime'];

    processingDatetime = json['processing_datetime'];

    readyForPickupDatetime = json['ready_for_pickup_datetime'];

    outOfDeliveryDatetime = json['out_of_delivery_datetime'];

    completeDeliveryDatetime = json['complete_delivery_datetime'];

    refundDatetime = json['refund_datetime'];
    print(40);
    cancelledDatetime = json['cancelled_datetime'];

    product = json['data'] != null ? new Product.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['delivery_address'] = this.deliveryAddress;
    data['order_status'] = this.orderStatus;
    data['delivery_date'] = this.deliveryDate;
    data['time_slot'] = this.timeSlot;
    data['payment_method'] = this.paymentMethod;
    data['payment_status'] = this.paymentStatus;
    data['paid_by_wallet'] = this.paidByWallet;
    data['cart_id'] = this.cartId;
    data['total_products_mrp'] = this.totalProductsMrp;
    data['total_price'] = this.totalPrice;
    data['delivery_charge'] = this.deliveryCharge;
    data['rem_price'] = this.remPrice;
    data['coupon_discount'] = this.couponDiscount;
    data['dboy_name'] = this.dboyName;
    data['dboy_phone'] = this.dboyPhone;
    data['price_without_delivery'] = this.priceWithoutDelivery;
    data['avg_tax_per'] = this.avgTaxPer;
    data['total_tax_price'] = this.totalTaxPrice;
    data['user_id'] = this.userId;
    data['discountonmrp'] = this.discountonmrp;
    data['cancelling_reason'] = this.cancellingReason;
    data['order_date'] = this.orderDate;
    data['dboy_id'] = this.dboyId;
    data['user_signature'] = this.userSignature;
    data['coupon_id'] = this.couponId;
    data['dboy_incentive'] = this.dboyIncentive;
    data['total_items'] = this.totalItems;
    data['is_subscription'] = this.isSubscription;
    data['total_delivery'] = this.totalDelivery;
    data['repeat_orders'] = this.repeatOrders;
    data['si_sub_ref_no'] = this.siSubRefNo;
    data['si_order'] = this.siOrder;
    data['bank_id'] = this.bankId;
    data['cancel_reason'] = this.cancelReason;
    if (this.product != null) {
      data['data'] = this.product;
    }
    return data;
  }
}

class TrackList {
  String orderStatus;
  String orderstatusDate;
  TrackList(this.orderStatus, this.orderstatusDate);
}
