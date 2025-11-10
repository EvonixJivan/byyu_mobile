// // import 'dart:io';

// // class CurrentUser {
// //   int? id;
// //   String? name;
// //   String? email;
// //   String? gender;
// //   String? emailVerifiedAt;
// //   String? password;
// //   String? rememberToken;
// //   String? userPhone;
// //   String? countryCode;
// //   String? flagCode; // previously comment code
// //   String? countryCodeFlag;
// //   String? prefixCode;
// //   String? phoneCode;
// //   String? deviceId;
// //   String? userImage;
// //   int? userCity;
// //   int? userArea;
// //   String? otpValue;
// //   int? status;
// //   double? wallet;
// //   int? rewards;
// //   int? isVerified;
// //   int? block;
// //   String? regDate;
// //   int? appUpdate;
// //   String? facebookId;
// //   String? referralCode;
// //   int? membership;
// //   String? memPlanStart;
// //   String? memPlanExpiry;
// //   String? createdAt;
// //   String? updatedAt;
// //   String? token;
// //   String? fbId;
// //   File? userImageFile;
// //   String? appleId;
// //   int? totalOrders;
// //   double? totalSpend;
// //   double? totalSaved;
// //   String? phoneCode1;
// //   String? landmark;
// //   String? building_villa;
// //   String? emirates;
// //   String? street;

// // //  String? gender;

// // //  String? password;
// //   // String? rememberToken;

// //   // String? countryCode;
// //   // String? flagCode;
// //   // String? prefixCode;
// //   // String? phoneCode;

// //   // int? membership;
// //   // String? memPlanStart;
// //   // String? memPlanExpiry;
// //   // String? createdAt;
// //   // String? updatedAt;
// //   // String? token;
// //   // String? fbId;
// //   // File? userImageFile;
// //   // String? appleId;
// //   // int? totalOrders;
// //   // double? totalSpend;
// //   // double? totalSaved;
// //   // String? phoneCode1;
// //   // String? landmark;
// //   // String? building_villa;
// // //  String? emirates;
// // //  String? street;
// //   String? whatsapp_flag;
// //   String? privacy_policy_flag;

// //   String? address;
// //   CurrentUser();

// //   CurrentUser.fromJson(Map<String, dynamic> json) {
// //     try {
// //       id = json['id'];
// //       name = json['name'];
// //       email = json['email'];
// //       emailVerifiedAt = json['email_verified_at'];
// //       password = json['password'];
// //       rememberToken = json['remember_token'];
// //       userPhone = json['user_phone'];
// //       deviceId = json['device_id'];
// //       userImage = json['user_image'];
// //       userCity = json['user_city'];
// //       userArea = json['user_area'];
// //       otpValue = json['otp_value'];
// //       status = json['status'];
// //       print(json['wallet']);
// //       wallet = json['wallet'] != null
// //           ? double.parse(json['wallet'].toString())
// //           : 0.0;
// //       rewards = json['rewards'];
// //       isVerified = json['is_verified'];
// //       block = json['block'];
// //       regDate = json['reg_date'];
// //       appUpdate = json['app_update'];
// //       facebookId = json['facebook_id'];
// //       referralCode = json['referral_code'];
// //       membership = json['membership'];
// //       memPlanStart = json['mem_plan_start'];
// //       memPlanExpiry = json['mem_plan_expiry'];
// //       createdAt = json['created_at'];
// //       updatedAt = json['updated_at'];
// //       token = json['token'];

// //       // totalOrders = json['total_orders'] != null
// //       //     ? int.parse('${json['total_orders']}')
// //       //     : '';
// //       // totalSpend = json['total_spent'] != null ? double.parse('${json['total_spent']}'): '';
// //       // totalSaved = json['total_save'] != null  ? double.parse('${json['total_save']}') : '';
// //       landmark = json['landmark'];
// //       building_villa = json['building_villa'];
// //       street = json['street'];
// //       emirates = json['emirates'];
// //       countryCode = json['country_code'];
// //       flagCode = json['flag_code'];
// //       prefixCode = json['prefix_code'];
// //       whatsapp_flag = json['whatsapp_flag'];
// //       privacy_policy_flag = json['privacy_policy_flag'];
// //       gender = json['user_gender'];
// //     } catch (e) {
// //       print("Exception - userModel.dart - User.fromJson():" + e.toString());
// //     }
// //   }

// //   Map<String, dynamic> toJson() => {
// //         'id': id != null ? id : null,
// //         'name': name != null ? name : null,
// //         'email': email != null ? email : null,
// //         'email_verified_at': emailVerifiedAt != null ? emailVerifiedAt : null,
// //         'password': password != null ? password : null,
// //         'remember_token': rememberToken != null ? rememberToken : null,
// //         'user_phone': userPhone != null ? userPhone : null,
// //         'device_id': deviceId != null ? deviceId : null,
// //         'user_image': userImage != null ? userImage : null,
// //         'user_city': userCity != null ? userCity : null,
// //         'user_area': userArea != null ? userArea : null,
// //         'otp_value': otpValue != null ? otpValue : null,
// //         'status': status != null ? status : null,
// //         'wallet': wallet != null ? wallet : null,
// //         'rewards': rewards != null ? rewards : null,
// //         'is_verified': isVerified != null ? isVerified : null,
// //         'block': block != null ? block : null,
// //         'reg_date': regDate != null ? regDate : null,
// //         'app_update': appUpdate != null ? appUpdate : null,
// //         'facebook_id': facebookId != null ? facebookId : null,
// //         'referral_code': referralCode != null ? referralCode : null,
// //         'membership': membership != null ? membership : null,
// //         'mem_plan_start': memPlanStart != null ? memPlanStart : null,
// //         'mem_plan_expiry': memPlanExpiry != null ? memPlanExpiry : null,
// //         'created_at': createdAt != null ? createdAt : null,
// //         'updated_at': updatedAt != null ? updatedAt : null,
// //         'token': token != null ? token : null,
// //         'landmark': landmark != null ? landmark : null,
// //         'building_villa': building_villa != null ? building_villa : null,
// //         'street': street != null ? street : null,
// //         'emirates': emirates != null ? emirates : null,
// //       };

// //   @override
// //   String toString() {
// //     return 'CurrentUser{id: $id, name: $name, email: $email, emailVerifiedAt: $emailVerifiedAt, password: $password, rememberToken: $rememberToken, userPhone: $userPhone, deviceId: $deviceId, userImage: $userImage, userCity: $userCity, userArea: $userArea, otpValue: $otpValue, status: $status, wallet: $wallet, rewards: $rewards, isVerified: $isVerified, block: $block, regDate: $regDate, appUpdate: $appUpdate, facebookId: $facebookId, referralCode: $referralCode, membership: $membership, memPlanStart: $memPlanStart, memPlanExpiry: $memPlanExpiry, createdAt: $createdAt, updatedAt: $updatedAt, token: $token, fbId: $fbId, userImageFile: $userImageFile, appleId: $appleId, totalOrders: $totalOrders, totalSpend: $totalSpend, totalSaved: $totalSaved, landmark: $landmark, building_villa: $building_villa, street: $street, emirates: $emirates,whatsAppFlag: $whatsapp_flag, privacypolicyflag:$privacy_policy_flag}';
// //   }
// // }

// // class SettingResponse {
// //   String? status;
// //   String? message;
// //   int? lastid;
// //   String? otp;

// //   SettingResponse();
// //   SettingResponse.fromJson(Map<String, dynamic> json) {
// //     try {
// //       status = json['status'] != null ? json['status'] : '';
// //       message = json['message'] != null ? json['message'] : '';
// //       lastid = json['lastid'] != null ? json['lastid'] : '';
// //       otp = json['otp'] != null ? json['otp'] : '';
// //     } catch (e) {
// //       print("Exception - SettingResponse.dart - SettingResponse.fromJson():" +
// //           e.toString());
// //     }
// //   }

// //   Map<String, dynamic> toJson() => {
// //         'status': status != null ? status : null,
// //         'message': message != null ? message : null,
// //         'lastid': lastid != null ? lastid : null,
// //         'otp': otp != null ? otp : null,
// //       };

// //   @override
// //   String toString() {
// //     return 'SettingResponse{status: $status, message: $message, lastid: $lastid, otp: $otp}';
// //   }
// // }

// import 'dart:io';

// class CurrentUser {
//   int? id;
//   String? name;
//   String? email;
//   String? emailVerifiedAt;
//   String? userPhone;
//   String? deviceId;
//   String? userImage;
//   int? userCity;
//   int? userArea;
//   String? otpValue;
//   int? status;
//   double? wallet;
//   int? rewards;
//   int? isVerified;
//   int? block;
//   String? regDate;
//   int? appUpdate;
//   String? facebookId;
//   String? referralCode;
//   String? gender;
//   String? password;
//   String? rememberToken;
//   String? countryCode;
//   String? flagCode;
//   String? prefixCode;
//   String? phoneCode;
//   int? membership;
//   String? memPlanStart;
//   String? memPlanExpiry;
//   String? createdAt;
//   String? updatedAt;
//   String? token;
//   String? fbId;
//   File? userImageFile;
//   String? appleId;
//   int? totalOrders;
//   double? totalSpend;
//   double? totalSaved;
//   String? phoneCode1;
//   String? landmark;
//   String? building_villa;
//   String? emirates;
//   String? street;
//   String? whatsapp_flag;
//   String? privacy_policy_flag;
//   String? address;
//   CurrentUser();
//   CurrentUser.fromJson(Map<String, dynamic> json) {
//     try {
//       id = json['id'];
//       name = json['name'];
//       email = json['email'];
//       emailVerifiedAt = json['email_verified_at'];
//       password = json['password'];
//       rememberToken = json['remember_token'];
//       userPhone = json['user_phone'];
//       deviceId = json['device_id'];
//       userImage = json['user_image'];
//       userCity = json['user_city'];
//       userArea = json['user_area'];
//       otpValue = json['otp_value'];
//       status = json['status'];
//       print(json['wallet']);
//       wallet = json['wallet'] != null
//           ? double.parse(json['wallet'].toString())
//           : 0.0;
//       rewards = json['rewards'];
//       isVerified = json['is_verified'];
//       block = json['block'];
//       regDate = json['reg_date'];
//       appUpdate = json['app_update'];
//       facebookId = json['facebook_id'];
//       referralCode = json['referral_code'];
//       membership = json['membership'];
//       memPlanStart = json['mem_plan_start'];
//       memPlanExpiry = json['mem_plan_expiry'];
//       createdAt = json['created_at'];
//       updatedAt = json['updated_at'];
//       token = json['token'];
//       // totalOrders = json['total_orders'] != null
//       //     ? int.parse('${json['total_orders']}')
//       //     : '';
//       // totalSpend = json['total_spent'] != null ? double.parse('${json['total_spent']}'): '';
//       // totalSaved = json['total_save'] != null  ? double.parse('${json['total_save']}') : '';
//       landmark = json['landmark'];
//       building_villa = json['building_villa'];
//       street = json['street'];
//       emirates = json['emirates'];
//       countryCode = json['country_code'];
//       flagCode = json['flag_code'];
//       prefixCode = json['prefix_code'];
//       whatsapp_flag = json['whatsapp_flag'];
//       privacy_policy_flag = json['privacy_policy_flag'];
//       gender = json['user_gender'];
//     } catch (e) {
//       print("Exception - userModel.dart - User.fromJson():" + e.toString());
//     }
//   }
//   Map<String, dynamic> toJson() => {
//         'id': id != null ? id : null,
//         'name': name != null ? name : null,
//         'email': email != null ? email : null,
//         'email_verified_at': emailVerifiedAt != null ? emailVerifiedAt : null,
//         'password': password != null ? password : null,
//         'remember_token': rememberToken != null ? rememberToken : null,
//         'user_phone': userPhone != null ? userPhone : null,
//         'device_id': deviceId != null ? deviceId : null,
//         'user_image': userImage != null ? userImage : null,
//         'user_city': userCity != null ? userCity : null,
//         'user_area': userArea != null ? userArea : null,
//         'otp_value': otpValue != null ? otpValue : null,
//         'status': status != null ? status : null,
//         'wallet': wallet != null ? wallet : null,
//         'rewards': rewards != null ? rewards : null,
//         'is_verified': isVerified != null ? isVerified : null,
//         'block': block != null ? block : null,
//         'reg_date': regDate != null ? regDate : null,
//         'app_update': appUpdate != null ? appUpdate : null,
//         'facebook_id': facebookId != null ? facebookId : null,
//         'referral_code': referralCode != null ? referralCode : null,
//         'membership': membership != null ? membership : null,
//         'mem_plan_start': memPlanStart != null ? memPlanStart : null,
//         'mem_plan_expiry': memPlanExpiry != null ? memPlanExpiry : null,
//         'created_at': createdAt != null ? createdAt : null,
//         'updated_at': updatedAt != null ? updatedAt : null,
//         'token': token != null ? token : null,
//         'landmark': landmark != null ? landmark : null,
//         'building_villa': building_villa != null ? building_villa : null,
//         'street': street != null ? street : null,
//         'emirates': emirates != null ? emirates : null,
//       };
//   @override
//   String toString() {
//     return 'CurrentUser{id: $id, name: $name, email: $email, emailVerifiedAt: $emailVerifiedAt, password: $password, rememberToken: $rememberToken, userPhone: $userPhone, deviceId: $deviceId, userImage: $userImage, userCity: $userCity, userArea: $userArea, otpValue: $otpValue, status: $status, wallet: $wallet, rewards: $rewards, isVerified: $isVerified, block: $block, regDate: $regDate, appUpdate: $appUpdate, facebookId: $facebookId, referralCode: $referralCode, membership: $membership, memPlanStart: $memPlanStart, memPlanExpiry: $memPlanExpiry, createdAt: $createdAt, updatedAt: $updatedAt, token: $token, fbId: $fbId, userImageFile: $userImageFile, appleId: $appleId, totalOrders: $totalOrders, totalSpend: $totalSpend, totalSaved: $totalSaved, landmark: $landmark, building_villa: $building_villa, street: $street, emirates: $emirates,whatsAppFlag: $whatsapp_flag, privacypolicyflag:$privacy_policy_flag}';
//   }
// }

// class SettingResponse {
//   String? status;
//   String? message;
//   int? lastid;
//   String? otp;
//   SettingResponse();
//   SettingResponse.fromJson(Map<String, dynamic> json) {
//     try {
//       status = json['status'] != null ? json['status'] : '';
//       message = json['message'] != null ? json['message'] : '';
//       lastid = json['lastid'] != null ? json['lastid'] : '';
//       otp = json['otp'] != null ? json['otp'] : '';
//     } catch (e) {
//       print("Exception - SettingResponse.dart - SettingResponse.fromJson():" +
//           e.toString());
//     }
//   }
//   Map<String, dynamic> toJson() => {
//         'status': status != null ? status : null,
//         'message': message != null ? message : null,
//         'lastid': lastid != null ? lastid : null,
//         'otp': otp != null ? otp : null,
//       };
//   @override
//   String toString() {
//     return 'SettingResponse{status: $status, message: $message, lastid: $lastid, otp: $otp}';
//   }
// }

// class UpdateMobileEmailMobel {
//   String? status;
//   String? message;
//   int? lastid;
//   String? otp;
//   String? whatsappFlag;
//   UpdateMobileEmailMobel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     lastid = json['lastid'];
//     otp = json['otp'];
//     whatsappFlag = json['whatsapp_flag'];
//   }
// }

//AAAAAA code new code

import 'dart:io';

class CurrentUser {
  int? id;
  String? name;
  String? email;
  String? dob;
  String? emailVerifiedAt;
  String? userPhone;
  String? deviceId;
  String? userImage;
  int? userCity;
  int? userArea;
  String? otpValue;
  int? status;
  double? wallet;
  int? rewards;
  int? isVerified;
  int? block;
  String? regDate;
  int? appUpdate;
  String? facebookId;
  String? referralCode;

  String? gender;

  String? password;
  String? rememberToken;

  String? countryCode;
  String? flagCode;
  String? prefixCode;
  String? phoneCode;

  int? membership;
  String? memPlanStart;
  String? memPlanExpiry;
  String? createdAt;
  String? updatedAt;
  String? token;
  String? fbId;
  File? userImageFile;
  String? appleId;
  int? totalOrders;
  double? totalSpend;
  double? totalSaved;
  String? phoneCode1;
  String? landmark;
  String? building_villa;
  String? emirates;
  String? street;
  String? whatsapp_flag;
  String? privacy_policy_flag;

  String? address;
  String? tapcustomer_id;
  int? cart_count;
  CurrentUser();

  CurrentUser.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      name = json['name'];
      email = json['email'];
      dob = json['dob'];
      emailVerifiedAt = json['email_verified_at'];
      password = json['password'];
      rememberToken = json['remember_token'];
      userPhone = json['user_phone'];
      deviceId = json['device_id'];
      userImage = json['user_image'];
      userCity = json['user_city'];
      userArea = json['user_area'];
      otpValue = json['otp_value'];
      status = json['status'];
      print(json['wallet']);
      wallet = json['wallet'] != null
          ? double.parse(json['wallet'].toString())
          : 0.0;
      rewards = json['rewards'];
      isVerified = json['is_verified'];
      block = json['block'];
      regDate = json['reg_date'];
      appUpdate = json['app_update'];
      facebookId = json['facebook_id'];
      referralCode = json['referral_code'];
      membership = json['membership'];
      memPlanStart = json['mem_plan_start'];
      memPlanExpiry = json['mem_plan_expiry'];
      createdAt = json['created_at'];
      updatedAt = json['updated_at'];
      token = json['token'];

      // totalOrders = json['total_orders'] != null
      //     ? int.parse('${json['total_orders']}')
      //     : '';
      // totalSpend = json['total_spent'] != null ? double.parse('${json['total_spent']}'): '';
      // totalSaved = json['total_save'] != null  ? double.parse('${json['total_save']}') : '';
      landmark = json['landmark'];
      building_villa = json['building_villa'];
      street = json['street'];
      emirates = json['emirates'];
      countryCode = json['country_code'];
      flagCode = json['flag_code'];
      prefixCode = json['prefix_code'];
      whatsapp_flag = json['whatsapp_flag'];
      privacy_policy_flag = json['privacy_policy_flag'];
      gender = json['user_gender'];
      cart_count = json['cart_count'];
      tapcustomer_id = json['tapcustomer_id'];
    } catch (e) {
      print("Exception - userModel.dart - User.fromJson():" + e.toString());
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id != null ? id : null,
        'name': name != null ? name : null,
        'email': email != null ? email : null,
        'email_verified_at': emailVerifiedAt != null ? emailVerifiedAt : null,
        'password': password != null ? password : null,
        'remember_token': rememberToken != null ? rememberToken : null,
        'user_phone': userPhone != null ? userPhone : null,
        'device_id': deviceId != null ? deviceId : null,
        'user_image': userImage != null ? userImage : null,
        'user_city': userCity != null ? userCity : null,
        'user_area': userArea != null ? userArea : null,
        'otp_value': otpValue != null ? otpValue : null,
        'status': status != null ? status : null,
        'wallet': wallet != null ? wallet : null,
        'rewards': rewards != null ? rewards : null,
        'is_verified': isVerified != null ? isVerified : null,
        'block': block != null ? block : null,
        'reg_date': regDate != null ? regDate : null,
        'app_update': appUpdate != null ? appUpdate : null,
        'facebook_id': facebookId != null ? facebookId : null,
        'referral_code': referralCode != null ? referralCode : null,
        'membership': membership != null ? membership : null,
        'mem_plan_start': memPlanStart != null ? memPlanStart : null,
        'mem_plan_expiry': memPlanExpiry != null ? memPlanExpiry : null,
        'created_at': createdAt != null ? createdAt : null,
        'updated_at': updatedAt != null ? updatedAt : null,
        'token': token != null ? token : null,
        'landmark': landmark != null ? landmark : null,
        'building_villa': building_villa != null ? building_villa : null,
        'street': street != null ? street : null,
        'emirates': emirates != null ? emirates : null,
      };

  @override
  String toString() {
    return 'CurrentUser{id: $id, name: $name, email: $email, emailVerifiedAt: $emailVerifiedAt, password: $password, rememberToken: $rememberToken, userPhone: $userPhone, deviceId: $deviceId, userImage: $userImage, userCity: $userCity, userArea: $userArea, otpValue: $otpValue, status: $status, wallet: $wallet, rewards: $rewards, isVerified: $isVerified, block: $block, regDate: $regDate, appUpdate: $appUpdate, facebookId: $facebookId, referralCode: $referralCode, membership: $membership, memPlanStart: $memPlanStart, memPlanExpiry: $memPlanExpiry, createdAt: $createdAt, updatedAt: $updatedAt, token: $token, fbId: $fbId, userImageFile: $userImageFile, appleId: $appleId, totalOrders: $totalOrders, totalSpend: $totalSpend, totalSaved: $totalSaved, landmark: $landmark, building_villa: $building_villa, street: $street, emirates: $emirates,whatsAppFlag: $whatsapp_flag, privacypolicyflag:$privacy_policy_flag}';
  }
}

class SettingResponse {
  String? status;
  String? message;
  int? lastid;
  String? otp;

  SettingResponse();
  SettingResponse.fromJson(Map<String, dynamic> json) {
    try {
      status = json['status'] != null ? json['status'] : '';
      message = json['message'] != null ? json['message'] : '';
      lastid = json['lastid'] != null ? json['lastid'] : '';
      otp = json['otp'] != null ? json['otp'] : '';
    } catch (e) {
      print("Exception - SettingResponse.dart - SettingResponse.fromJson():" +
          e.toString());
    }
  }

  Map<String, dynamic> toJson() => {
        'status': status != null ? status : null,
        'message': message != null ? message : null,
        'lastid': lastid != null ? lastid : null,
        'otp': otp != null ? otp : null,
      };

  @override
  String toString() {
    return 'SettingResponse{status: $status, message: $message, lastid: $lastid, otp: $otp}';
  }
}

class UpdateMobileEmailMobel {
  String? status;
  String? message;
  int? lastid;
  String? otp;
  String? whatsappFlag;
  UpdateMobileEmailMobel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    lastid = json['lastid'];
    otp = json['otp'];
    whatsappFlag = json['whatsapp_flag'];
  }
}



class GuestUserResponseModel {
  bool? status;
  String? message;
  int? userId;
  int? addressId;
  String? deliveryDate;
  String? timeSlot;

  GuestUserResponseModel(
      {this.status,
      this.message,
      this.userId,
      this.addressId,
      this.deliveryDate,
      this.timeSlot});

  GuestUserResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userId = json['user_id'];
    addressId = json['address_id'];
    deliveryDate = json['delivery_date'];
    timeSlot = json['time_slot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['user_id'] = this.userId;
    data['address_id'] = this.addressId;
    data['delivery_date'] = this.deliveryDate;
    data['time_slot'] = this.timeSlot;
    return data;
  }
}
