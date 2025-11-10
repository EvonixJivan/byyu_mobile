class AppInfo {
  String? status;
  String? message;
  int? lastLoc;
  int? phoneNumberLength;
  String? appName;
  String? appLogo;
  String? firebase;
  int? countryCode;
  String? firebaseIso;
  String? sms;
  String? currencySign;
  String? refertext;
  int? totalItems;
  String? androidAppLink;
  String? paymentCurrency;
  String? iosAppLink;
  String? imageUrl;
  String? referralScreenImageUrl;
  int? wishlistCount;
  double? userwallet;
  String? userServerKey;
  String? storeServerKey;
  String? driverServerKey;
  int? liveChat;
  String? phone;
  String? email;
  int? calendar_t_value;
  String? app_link;
  String? version;
  String? platform;
  int? forcefully_update;
  String? repeated_order_message;
  String? map_api_key;
  String? notice, whatsapp_link;
  int? notice_status;
  int? app_version_status;
  String? app_version_messgae;
  String? popupdata_home;
  double? maxPrice;
  int? store_id;
  String? userStatus;
  double? myReferralAmount;
  double? referedtoAmount;
  int? myReferralsCount;
  double? myReferralsEarned;
  

  int? codEnabled;
  int? cardEnabled;
  int? cartitem;
  int? wishListCount;
  bool? openPaymentSDK;
  String? contactEmail;
  String? contactPhone;
  String? contactWhatsApp;
  String? tapcustomer_id;

  int? hamburgerEnabled;

  AppInfo();
  AppInfo.fromJson(Map<String, dynamic> json) {
    try {
      status = json["status"] != null ? json["status"] : null;
      message = json["message"] != null ? json["message"] : null;
      lastLoc =
          json["last_loc"] != null ? int.parse('${json["last_loc"]}') : null;
      phoneNumberLength = json["phone_number_length"] != null
          ? int.parse('${json["phone_number_length"]}')
          : null;
      appName = json["app_name"] != null ? json["app_name"] : null;
      appLogo = json["app_logo"] != null ? json["app_logo"] : null;
      firebase = json["firebase"] != null ? json["firebase"] : null;
      countryCode = json["country_code"] != null
          ? int.parse('${json["country_code"]}')
          : null;
      firebaseIso = json["firebase_iso"] != null ? json["firebase_iso"] : null;
      sms = json["sms"] != null ? json["sms"] : null;
      currencySign =
          json["currency_sign"] != null ? json["currency_sign"] : null;
      refertext = json["refertext"] != null ? json["refertext"] : null;
      totalItems = json["total_items"] != null
          ? int.parse('${json["total_items"]}')
          : null;
      androidAppLink =
          json["android_app_link"] != null ? json["android_app_link"] : null;
      paymentCurrency =
          json["payment_currency"] != null ? json["payment_currency"] : null;
      iosAppLink = json["ios_app_link"] != null ? json["ios_app_link"] : null;
      imageUrl = json["image_url"] != null ? json["image_url"] : null;
      referralScreenImageUrl = json["referralScreenImageUrl"] != null ? json["referralScreenImageUrl"] : null;
      wishlistCount = json["wishlist_count"] != null
          ? int.parse('${json["wishlist_count"]}')
          : null;
      userwallet = json["userwallet"] != null
          ? double.parse('${json["userwallet"]}')
          : null;
      liveChat =
          json['live_chat'] != null ? int.parse('${json['live_chat']}') : null;
      userServerKey =
          json['user_server_key'] != null ? json['user_server_key'] : null;
      storeServerKey =
          json['store_server_key'] != null ? json['store_server_key'] : null;
      driverServerKey =
          json['driver_server_key'] != null ? json['driver_server_key'] : null;
      phone = json['phone'] != null
          ? json['phone']
          : null; 
      openPaymentSDK = json['openPaymentSDK'] != null
          ? json['openPaymentSDK']
          : true; 
      email = json['email'] != null ? json['email'] : null;
      calendar_t_value = json['calendar_t_value'] != null
          ? int.parse('${json['calendar_t_value']}')
          : null;
      app_link = json['app_link'] != null ? json['app_link'] : null;
      version = json['version'] != null ? json['version'] : null;
      platform = json['platform'] != null ? json['platform'] : null;
      forcefully_update = json['forcefully_update'] != null
          ? int.parse('${json['forcefully_update']}')
          : null;
      repeated_order_message = json['repeated_order_message'] != null
          ? json['repeated_order_message']
          : null;
      map_api_key = json["map_api_key"] != null ? json["map_api_key"] : null;
      notice = json["notice"] != null ? json["notice"] : null;
      notice_status = json['notice_status'] != null
          ? int.parse('${json['notice_status']}')
          : null;
      whatsapp_link =
          json["whatsapp_link"] != null ? json["whatsapp_link"] : null;
      app_version_status = json['app_version_status'] != null
          ? int.parse('${json['app_version_status']}')
          : null;
      app_version_messgae = json['app_version_messgae'] != null
          ? json['app_version_messgae']
          : null;
      popupdata_home =
          json['popupdata_home'] != null ? json['popupdata_home'] : '';
      maxPrice =
          json["maxPrice"] != null ? double.parse('${json["maxPrice"]}') : null;
      store_id = json['store_id'] != null ? json['store_id'] : null;

      contactEmail = json['email'] != null ? json['email'] : null;
      tapcustomer_id =
          json['tapcustomer_id'] != null ? json['tapcustomer_id'] : null;
      contactPhone = json['phone'] != null ? json['phone'] : null;
      contactWhatsApp = json['whatsapp'] != null ? json['whatsapp'] : null;
      userStatus = json['activate_deactivate_status'] != null
          ? json['activate_deactivate_status']
          : null;
      codEnabled =
          json['cod_enabled'] != null ? json['cod_enabled'] : null;; 
      cardEnabled = json['card_enabled'] != null ? json['card_enabled'] : null;
      cartitem = json['cartitem'] != null ? json['cartitem'] : null;
      wishListCount =
          json['wishlist_count '] != null ? json['wishlist_count '] : null;
      myReferralAmount = json['referral_return_amount'].toString() != null
          ? double.parse(json['referral_return_amount'].toString())
          : 0.0;
      referedtoAmount = json['referral_amount'].toString() != null
          ? double.parse(json['referral_amount'].toString())
          : 0.0;
      myReferralsCount = json['referral_count'].toString() != null
          ? int.parse(json['referral_count'].toString())
          : 0;
      myReferralsEarned = json['referral_earned'].toString() != null
          ? double.parse(json['referral_earned'].toString())
          : 0.0;
      hamburgerEnabled = json['hamburger_enabled'].toString() != null
          ? int.parse(json['hamburger_enabled'].toString())
          : 0;    
    } catch (e) {
      print(
          "Exception - appInfoModel.dart - AppInfo.fromJson():model class" + e.toString());
    }
  }
}
