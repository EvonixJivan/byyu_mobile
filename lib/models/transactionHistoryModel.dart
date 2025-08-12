class TransactionHistoryModel {
  String? status;
  String? message;
  List<Transactionhistory>? transactionhistory;

  TransactionHistoryModel({this.status, this.message, this.transactionhistory});

  TransactionHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      transactionhistory = <Transactionhistory>[];
      json['data'].forEach((v) {
        transactionhistory!.add(new Transactionhistory.fromJson(v));
      });
    }
  }
}

class Transactionhistory {
  int? id;
  String? userId;
  String? bankId;
  String? cartId;
  String? amount;
  String? paymentStatus;
  String? paymentMethod;
  String? groupCartId;
  String? jsonData;
  String? orderStatus;
  String? orderDate;
  String? deliveryDate;
  String? couponCode;
  int? couponDiscount;
  String? createdDate;
  bool? isItemTap = false;

  Transactionhistory(
      {this.id,
      this.userId,
      this.bankId,
      this.cartId,
      this.amount,
      this.paymentStatus,
      this.paymentMethod,
      this.groupCartId,
      this.jsonData,
      this.orderStatus,
      this.orderDate,
      this.deliveryDate,
      this.couponCode,
      this.couponDiscount,
      this.createdDate});

  Transactionhistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    bankId = json['bank_id'];
    cartId = json['cart_id'];
    amount = json['amount'];
    paymentStatus = json['payment_status'];
    paymentMethod = json['payment_method'];
    groupCartId = json['group_cart_id'];
    jsonData = json['json_data'];
    orderStatus = json['order_status'];
    orderDate = json['order_date'];
    deliveryDate = json['delivery_date'];
    couponCode = json['coupon_code'];
    couponDiscount = json['coupon_discount'];
    createdDate = json['created_date'];
  }
}
