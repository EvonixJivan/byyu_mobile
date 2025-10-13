class CouponCode {
  int? coupon_id;
  double? cart_amount;
  double? discounted_amount;
  double? save_amount;
  String? coupon_code;
  CouponCode();
  CouponCode.fromJson(Map<String, dynamic> json) {
    try {
      coupon_id = (json['coupon_id'] != null
          ? int.parse('${json['coupon_id']}')
          : '') as int?;
      cart_amount = (json['cart_amount'] != null
          ? double.parse('${json['cart_amount']}')
          : '') as double?;
      discounted_amount = (json['discounted_amount'] != null
          ? double.parse('${json['discounted_amount']}')
          : '') as double?;
      save_amount = (json['save_amount'] != null
          ? double.parse('${json['save_amount']}')
          : '') as double?;
      coupon_code =
          json['coupon_code'] != null ? json['coupon_code'].toString() : '';
    } catch (e) {
      print("Exception - userModel.dart - User.fromJson():" + e.toString());
    }
  }
  Map<String, dynamic> toJson() => {
        'coupon_id': coupon_id != null ? coupon_id : null,
        'cart_amount': cart_amount != null ? cart_amount : null,
        'discounted_amount':
            discounted_amount != null ? discounted_amount : null,
        'save_amount': save_amount != null ? save_amount : null,
        'coupon_code': coupon_code != null ? coupon_code : null,
      };
  @override
  String toString() {
    return 'CurrentUser{coupon_id: $coupon_id, cart_amount: $cart_amount,coupon_code: $coupon_code, discounted_amount: $discounted_amount, save_amount: $save_amount}';
  }
}
