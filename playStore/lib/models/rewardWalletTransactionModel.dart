// class RewardWalletTransaction {
//   String? status;
//   String? message;
//   int? totalWalletAmount;
//   int? cashWalletAmount;
//   int? rewardWalletAmount;
//   List<RewardWalletTransactionList>? walletDetails;
//   List<PendingExpiryWalletDetails>? pendingExpiryWalletDetails;

//   RewardWalletTransaction(
//       {this.status,
//       this.message,
//       this.totalWalletAmount,
//       this.cashWalletAmount,
//       this.rewardWalletAmount,
//       this.walletDetails});

//   RewardWalletTransaction.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     totalWalletAmount = json['total_wallet_amount'];
//     cashWalletAmount = json['cash_wallet_amount'];
//     rewardWalletAmount = json['reward_wallet_amount'];
//     if (json['all_wallet_details'] != null) {
//       walletDetails = <RewardWalletTransactionList>[];
//       json['all_wallet_details'].forEach((v) {
//         walletDetails!.add(new RewardWalletTransactionList.fromJson(v));
//       });
//     }
//     if (json['pending_expiry_wallet_details'] != null) {
//       pendingExpiryWalletDetails = <PendingExpiryWalletDetails>[];
//       json['pending_expiry_wallet_details'].forEach((v) {
//         pendingExpiryWalletDetails!
//             .add(new PendingExpiryWalletDetails.fromJson(v));
//       });
//     }
//   }
// }

// class RewardWalletTransactionList {
//   int? walletId;

//   String? userId;
//   String? cartId;
//   double? walletAmount;
//   String? addedAt;
//   String? isDelete;
//   String? walletExpiryDate;
//   String? walletDescription;
//   String? walletName;
//   String? walletType;
//   String? walletdisname;
//   String? rewardWalletId;
//   String? usedWalletAmount;
//   String? status;
//   String? createdAt;
//   String? updatedAt;
//   bool onTap = false;

//   RewardWalletTransactionList(
//       {this.walletId,
//       this.userId,
//       this.cartId,
//       this.walletAmount,
//       this.addedAt,
//       this.isDelete,
//       this.walletExpiryDate,
//       this.walletDescription,
//       this.walletName,
//       this.walletType,
//       this.rewardWalletId,
//       this.usedWalletAmount,
//       this.status,
//       this.createdAt,
//       this.updatedAt});

//   RewardWalletTransactionList.fromJson(Map<String, dynamic> json) {
//     walletId = json['wallet_id'];

//     userId = json['user_id'];

//     cartId = json['cart_id'];

//     walletAmount = double.parse(json['wallet_amount'].toString());

//     addedAt = json['added_at'];

//     isDelete = json['is_delete'];

//     walletExpiryDate = json['wallet_expiry_date'];

//     walletDescription = json['wallet_description'];

//     walletName = json['wallet_name'];
//     walletdisname = json['wallet_dis_name'];

//     walletType = json['wallet_type'];

//     rewardWalletId = json['reward_wallet_id'];

//     usedWalletAmount = json['used_wallet_amount'];

//     status = json['status'];

//     createdAt = json['created_at'];

//     updatedAt = json['updated_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['wallet_id'] = this.walletId;
//     data['user_id'] = this.userId;
//     data['cart_id'] = this.cartId;
//     data['wallet_amount'] = this.walletAmount;
//     data['added_at'] = this.addedAt;
//     data['is_delete'] = this.isDelete;
//     data['wallet_expiry_date'] = this.walletExpiryDate;
//     data['wallet_description'] = this.walletDescription;
//     data['wallet_name'] = this.walletName;
//     data['wallet_type'] = this.walletType;
//     data['wallet_dis_name'] = this.walletdisname;
//     data['reward_wallet_id'] = this.rewardWalletId;
//     data['used_wallet_amount'] = this.usedWalletAmount;
//     data['status'] = this.status;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }

// class PendingExpiryWalletDetails {
//   int? walletId;
//   String? userId;
//   String? cartId;
//   double? walletAmount;
//   String? walletExpiryDate;
//   String? walletDescription;
//   String? walletName;
//   String? walletType;
//   String? walletStatus;
//   String? createdAt;
//   bool? onTap = false;

//   PendingExpiryWalletDetails(
//       {this.walletId,
//       this.userId,
//       this.cartId,
//       this.walletAmount,
//       this.walletExpiryDate,
//       this.walletDescription,
//       this.walletName,
//       this.walletType,
//       this.walletStatus,
//       this.createdAt});

//   PendingExpiryWalletDetails.fromJson(Map<String, dynamic> json) {
//     walletId = json['wallet_id'];

//     userId = json['user_id'];

//     cartId = json['cart_id'];

//     walletAmount = double.parse(json['wallet_amount'].toString());

//     walletExpiryDate = json['wallet_expiry_date'];

//     walletDescription = json['wallet_description'];

//     walletName = json['wallet_name'];

//     walletType = json['wallet_type'];

//     walletStatus = json['wallet_status'];

//     createdAt = json['created_at'];
//   }
// }

// //AAA

class RewardWalletTransaction {
  String? status;
  String? message;
  double? totalWalletAmount;
  double? cashWalletAmount;
  double? rewardWalletAmount;
  List<RewardWalletTransactionList>? walletDetails;
  List<PendingExpiryWalletDetails>? pendingExpiryWalletDetails;

  RewardWalletTransaction(
      {this.status,
      this.message,
      this.totalWalletAmount,
      this.cashWalletAmount,
      this.rewardWalletAmount,
      this.walletDetails});

  RewardWalletTransaction.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalWalletAmount = double.parse(json['total_wallet_amount'].toString());
    cashWalletAmount = double.parse(json['cash_wallet_amount'].toString());
    rewardWalletAmount = double.parse(json['reward_wallet_amount'].toString());
    if (json['all_wallet_details'] != null) {
      walletDetails = <RewardWalletTransactionList>[];
      json['all_wallet_details'].forEach((v) {
        walletDetails!.add(new RewardWalletTransactionList.fromJson(v));
      });
    }
    if (json['pending_expiry_wallet_details'] != null) {
      pendingExpiryWalletDetails = <PendingExpiryWalletDetails>[];
      json['pending_expiry_wallet_details'].forEach((v) {
        pendingExpiryWalletDetails!
            .add(new PendingExpiryWalletDetails.fromJson(v));
      });
    }
  }
}

class RewardWalletTransactionList {
  int? walletId;

  String? userId;
  String? cartId;
  double? walletAmount;
  String? addedAt;
  String? isDelete;
  String? walletExpiryDate;
  String? walletDescription;
  String? walletName;
  String? walletType;
  String? walletdisname;
  String? rewardWalletId;
  String? usedWalletAmount;
  String? status;
  String? createdAt;
  String? updatedAt;
  bool? onTap = true;

  RewardWalletTransactionList(
      {this.walletId,
      this.userId,
      this.cartId,
      this.walletAmount,
      this.addedAt,
      this.isDelete,
      this.walletExpiryDate,
      this.walletDescription,
      this.walletName,
      this.walletType,
      this.rewardWalletId,
      this.usedWalletAmount,
      this.status,
      this.createdAt,
      this.updatedAt});

  RewardWalletTransactionList.fromJson(Map<String, dynamic> json) {
    walletId = json['wallet_id'];

    userId = json['user_id'];

    cartId = json['cart_id'];

    walletAmount = double.parse(json['wallet_amount'].toString());

    addedAt = json['added_at'];

    isDelete = json['is_delete'];

    walletExpiryDate = json['wallet_expiry_date'];

    walletDescription = json['wallet_description'];

    walletName = json['wallet_name'];
    walletdisname = json['wallet_dis_name'];

    walletType = json['wallet_type'];

    rewardWalletId = json['reward_wallet_id'];

    usedWalletAmount = json['used_wallet_amount'];

    status = json['status'];

    createdAt = json['created_at'];

    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wallet_id'] = this.walletId;
    data['user_id'] = this.userId;
    data['cart_id'] = this.cartId;
    data['wallet_amount'] = this.walletAmount;
    data['added_at'] = this.addedAt;
    data['is_delete'] = this.isDelete;
    data['wallet_expiry_date'] = this.walletExpiryDate;
    data['wallet_description'] = this.walletDescription;
    data['wallet_name'] = this.walletName;
    data['wallet_type'] = this.walletType;
    data['reward_wallet_id'] = this.rewardWalletId;
    data['used_wallet_amount'] = this.usedWalletAmount;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class PendingExpiryWalletDetails {
  int? walletId;
  String? userId;
  String? cartId;
  double? walletAmount;
  String? walletExpiryDate;
  String? walletDescription;
  String? walletName;
  String? walletType;
  String? walletStatus;
  String? createdAt;
  bool? onTap = true;

  PendingExpiryWalletDetails(
      {this.walletId,
      this.userId,
      this.cartId,
      this.walletAmount,
      this.walletExpiryDate,
      this.walletDescription,
      this.walletName,
      this.walletType,
      this.walletStatus,
      this.createdAt});

  PendingExpiryWalletDetails.fromJson(Map<String, dynamic> json) {
    walletId = json['wallet_id'];

    userId = json['user_id'];

    cartId = json['cart_id'];

    walletAmount = double.parse(json['wallet_amount'].toString());

    walletExpiryDate = json['wallet_expiry_date'];

    walletDescription = json['wallet_description'];

    walletName = json['wallet_name'];

    walletType = json['wallet_type'];

    walletStatus = json['wallet_status'];

    createdAt = json['created_at'];
  }
}
