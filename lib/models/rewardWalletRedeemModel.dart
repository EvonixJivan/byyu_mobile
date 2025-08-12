class RewardWalletRedeemResponse {
  String? status;
  String? message;
  List<RewardWalletRedeemResponse>? redeemList;
  int? wallet;

  RewardWalletRedeemResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      redeemList = <RewardWalletRedeemResponse>[];
      json['data'].forEach((v) {
        redeemList!.add(new RewardWalletRedeemResponse.fromJson(v));
      });
    }
    // wallet = double.parse(json['wallet'].toString());
    wallet = json['wallet'];
  }
}

class RewardWalletRedeemList {
  int? rewardId;
  String? userId;
  String? rewardName;
  String? couponCode;
  String? image;
  String? expiryDays;
  String? expiryDate;
  String? expiryTime;
  String? rewardAmount;
  String? rewardDescription;
  String? status;
  String? createdAt;
  String? updatedAt;

  RewardWalletRedeemList.fromJson(Map<String, dynamic> json) {
    rewardId = json['reward_id'];
    userId = json['user_id'];
    rewardName = json['reward_name'];
    couponCode = json['coupon_code'];
    image = json['image'];
    expiryDays = json['expiry_days'];
    expiryDate = json['expiry_date'];
    expiryTime = json['expiry_time'];
    rewardAmount = json['reward_amount'];
    rewardDescription = json['reward_description'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
