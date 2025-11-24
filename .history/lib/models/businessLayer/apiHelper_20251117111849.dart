import 'dart:collection';
import 'dart:convert';
import 'dart:core';

import 'dart:io';
import 'package:byyu/constants/analytics_GA4.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/models/checkoutOrderModel.dart';
import 'package:byyu/models/eventsListModel.dart';
import 'package:byyu/models/genderRelationSelectionFilter.dart';
import 'package:byyu/models/orderDetailsModel.dart';
import 'package:byyu/models/relationship_model.dart';
import 'package:byyu/models/rewardWalletTransactionModel.dart';
import 'package:byyu/models/transactionHistoryModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:byyu/models/aboutUsModel.dart';
import 'package:byyu/models/addressModel.dart';
import 'package:byyu/models/appInfoModel.dart';
import 'package:byyu/models/apply_coupon.dart';
import 'package:byyu/models/businessLayer/dioResult.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/cancelOrderStatusModel.dart';
import 'package:byyu/models/cartModel.dart';
import 'package:byyu/models/categoryListModel.dart';
import 'package:byyu/models/categoryProductModel.dart';
import 'package:byyu/models/contactUsDropDown.dart';
import 'package:byyu/models/couponsModel.dart';
import 'package:byyu/models/homeScreenDataModel.dart';
import 'package:byyu/models/nearByStoreModel.dart';
import 'package:byyu/models/notificationModel.dart';
import 'package:byyu/models/orderModel.dart';
import 'package:byyu/models/productDetailModel.dart';
import 'package:byyu/models/productFilterModel.dart';
import 'package:byyu/models/rateModel.dart';
import 'package:byyu/models/recentSearchModel.dart';
import 'package:byyu/models/subCategoryModel.dart';
import 'package:byyu/models/termsOfServicesModel.dart';
import 'package:byyu/models/timeSlotModel.dart';
import 'package:byyu/models/userModel.dart';
import 'package:byyu/models/walletModel.dart';
import 'package:http/http.dart' as http;

import '../CountryCodeList.dart';

class APIHelper {
  late String url;

  Future<dynamic> addAddress(
      Address1 address, String toWhom, String countryFlag) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_id': global.currentUser.id,
        "device_id": "${global.globalDeviceId}",
        "to_name": toWhom,
        'type': address.type.toString(),
        'receiver_name': address.receiverName.toString(),
        'receiver_phone': address.receiverPhone,
        'city_name': address.city.toString(),
        'society_name': address.society.toString(),
        'house_no': address.houseNo.toString(),
        'building_villa': address.building_villa.toString(),
        'cityname': address.cityName.toString(),
        'landmark': address.landmark.toString(),
        "flag_code": countryFlag,
        "country_code": address.countryCode,
        'state': address.state.toString(),
        'pin': "",
        'lat': address.lat != null ? address.lat : '',
        'lng': address.lng != null ? address.lng : '',
      });
      print("########################################################");
      print('${global.baseUrl}add_address');
      print(formData.fields);
      response = await dio.post(
        '${global.baseUrl}add_address',
        data: formData,
      );

      dynamic recordList;
      if (response.statusCode == 200 && response.data['status'] == '1') {
        recordList = true;
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - addAddress(): " + e.toString());
    }
  }

  Future<dynamic> addProductRating(
      int varientId, double rating, String description) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_id': global.currentUser.id,
        'varient_id': varientId,
        'store_id': global.appInfo.store_id,
        'rating': rating,
        'description': description,
      });

      response = await dio.post(
        '${global.baseUrl}add_product_rating',
        queryParameters: {
          'lang': global.languageCode,
        },
        data: formData,
      );
      dynamic recordList;
      if (response.statusCode == 200 && response.data['status'] == '1') {
        recordList = true;
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - addProductRating(): " + e.toString());
    }
  }

  Future<dynamic> addRemoveWishList(int varientId) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_id': global.currentUser.id,
        'varient_id': varientId,
      });
      print(" 'user_id': ${global.currentUser.id},'varient_id': ${varientId}");
      print('${global.baseUrl}add_rem_wishlist');
      response = await dio.post(
        '${global.baseUrl}add_rem_wishlist',
        data: formData,
      );
      dynamic recordList;
      if (response.statusCode == 200 && response.data['status'] == '1') {
        print("wishlist added");
        recordList = true;
        global.wishlistCount = global.wishlistCount + 1;
      } else if (response.statusCode == 200 && response.data['status'] == '2') {
        global.wishlistCount = global.wishlistCount - 1;
        print("wishlist removed");
        recordList = true;
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - addRemoveWishList(): " + e.toString());
    }
  }

  Future<dynamic> addToMultipleCart(
      List<Map<String, dynamic>> sendArray) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({'cart_json': sendArray});
      print('${global.baseUrl}bulk_add_to_cart');
      print("'cart_json': ${sendArray}");
      response = await dio.post(
        '${global.baseUrl}bulk_add_to_cart',
        data: formData,
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = true;
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - bulk_add_to_cart(): " + e.toString());
    }
  }

  Future<dynamic> addToCart(
      {int? qty,
      int? varientId,
      int? special,
      String? repeat_orders,
      String? deliveryDate,
      String? deliveryTime,
      String? userMessage,
      int? deliveryType,
      Product? productData,
      List<PersonalizedTextList>? personalizedText,
      List<PersonalizedImagesList>? perosonalizedImages,
      String? eggEggless,
      String? flavour}) async {
    var repeatDaysOne = "";
    print('repeat_orders--->${repeat_orders}');
    if (repeat_orders != null) {
      final split = repeat_orders.split(',');
      List<String> repeatDays = LinkedHashSet<String>.from(split).toList();
      repeatDaysOne =
          repeatDays.reduce((value, element) => value + ',' + element);
      if (repeatDaysOne[0] == ',') {
        repeatDaysOne = repeatDaysOne.substring(1);
      }
    }
    print("This is the device id ${global.globalDeviceId}");
    List<Map<String, dynamic>> sendImagesList = [];
    List<Map<String, dynamic>> sendTextList = [];

    if (personalizedText != null) {
      for (int i = 0; i < personalizedText.length; i++) {
        var sendTextJson = {
          'name': personalizedText[i].name,
          'value': personalizedText[i].value
        };
        sendTextList.add(sendTextJson);
      }
    }
    if (perosonalizedImages != null && perosonalizedImages.length > 0) {
      print("This is the Nikhil if images ");
      for (int i = 0; i < perosonalizedImages.length; i++) {
        var sendImagesJson = {
          'name': perosonalizedImages[i].name,
          'value': perosonalizedImages[i].value.toString().length > 0
              ? await MultipartFile.fromFile(perosonalizedImages[i].value)
              : ""
        };
        sendImagesList.add(sendImagesJson);
      }
    }

    try {
      Response response;
      var dio = Dio();
      print("This is the nikhil 2 try api helper");
      var formData = FormData.fromMap({
        'user_id': global.currentUser.id != null ? global.currentUser.id : "",
        'qty': qty,
        'varient_id': varientId,
        'special': special,
        "device_id": "${global.globalDeviceId}",
        "platform": Platform.isIOS ? "IOS" : "ANDROID",
        "delivery_date": deliveryDate,
        "delivery_time": deliveryTime,
        "delivery_type": deliveryType,
        "egg_eggless": eggEggless,
        "flavour": flavour,
        "personalized_message": userMessage,
        "personalized_text": sendTextList.length > 0 ? sendTextList : "",
        "personalized_image": sendImagesList.length > 0 ? sendImagesList : ""
      });
      print("########################################################");
      print('${global.baseUrl}add_to_cart');
      print(formData.fields);
      print(sendImagesList);
      print(sendTextList);

      response = await dio.post(
        '${global.baseUrl}add_to_cart',
        data: formData,
      );

      dynamic recordList;
      print(response);
      if (response.statusCode == 200 && response.data['status'] == '1') {
        recordList = AddtoCart.fromJson(response.data["data"]);
      } else if (response.statusCode == 200 && response.data['status'] == '0') {
        recordList = response.data;
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - addToCart(): " + e.toString());
    }
  }

  Future<dynamic> addWishListToCart() async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_id': global.currentUser.id,
      });
      response = await dio.post(
        '${global.baseUrl}wishlist_to_cart',
        queryParameters: {
          'lang': global.languageCode,
        },
        data: formData,
      );
      dynamic recordList;
      if (response.statusCode == 200 && response.data['status'] == '1') {
        recordList = true;
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - addWishListToCart(): " + e.toString());
    }
  }

  Future<dynamic> appPrivacyPolicy() async {
    try {
      Response response;
      var dio = Dio();
      print("${global.baseUrl}appprivacy");
      response = await dio.get(
        '${global.baseUrl}appprivacy',
      );
      dynamic recordList;
      print(response);
      if (response.statusCode == 200 && response.data['status'] == '1') {
        recordList = AboutUs.fromJson(response.data["data"]);
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - appAboutUs(): " + e.toString());
    }
  }

  Future<dynamic> applyCoupon(
      {String? cartId,
      String? couponCode,
      String? user_id,
      int? total_delivery}) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'coupon_code': couponCode,
        'user_id': user_id,
        'total_delivery': total_delivery
      });
      print('${global.baseUrl}apply_coupon');
      print(
          "'store_id': ${cartId}, 'coupon_code': ${couponCode},'user_id': ${user_id}, 'total_delivery': ${total_delivery}");

      response = await dio.post(
        '${global.baseUrl}apply_coupon',
        data: formData,
      );
      print("this is the result data in apiHelper screen ${response.data}");
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = CouponCode.fromJson(response.data["data"]);
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - applyCoupon(): " + e.toString());
    }
  }

  Future<dynamic> appTermsOfService() async {
    try {
      Response response;
      var dio = Dio();
      print('${global.baseUrl}appterms');
      response = await dio.get(
        '${global.baseUrl}appterms',
      );
      dynamic recordList;
      if (response.statusCode == 200 && response.data['status'] == '1') {
        recordList = TermsOfService.fromJson(response.data["data"]);
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - appTermsOfService(): " + e.toString());
    }
  }

  Future<dynamic> barcodeScanResult(String code) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap(
          {'ean_code': code, 'store_id': global.appInfo.store_id});
      response = await dio.post('${global.baseUrl}search',
          data: formData,
          options: Options(
            headers: await global.getApiHeaders(false),
          ));
      dynamic recordList;
      if (response.statusCode == 200 && response.data['status'] == '1') {
        recordList = ProductDetail.fromJson(response.data['data']);
        print("BBBBBBBBBBBBBBBB");
        print(response.data["data"]);
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - barcodeScanResult(): " + e.toString());
    }
  }

  Future<dynamic> buyMembership(String buyStatus, String paymentGateway,
      String transactionId, int planId) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_id': global.currentUser.id,
        'buy_status': buyStatus,
        'payment_gateway': paymentGateway,
        'transaction_id': transactionId,
        'plan_id': planId,
      });

      response = await dio.post(
        '${global.baseUrl}buymember',
        data: formData,
      );
      dynamic recordList;
      if (response.statusCode == 200 && response.data['status'] == '1') {
        recordList = true;
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - buyMembership(): " + e.toString());
    }
  }

  Future<dynamic> calbackRequest(String storeId) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap(
          {'user_id': global.currentUser.id, 'store_id': storeId});
      response = await dio.post(
        '${global.baseUrl}callback_req',
        queryParameters: {
          'lang': global.languageCode,
        },
        data: formData,
      );
      dynamic recordList;
      if (response.statusCode == 200 && response.data['status'] == '1') {
        recordList = true;
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - calbackRequest(): " + e.toString());
    }
  }

  Future<bool> callOnFcmApiSendPushNotifications(
      {List<String>? userToken,
      String? title,
      String? body,
      String? route,
      String? imageUrl,
      String? chatId,
      String? firstName,
      String? lastName,
      String? storeId,
      String? userId,
      String? globalUserToken}) async {
    final data = {
      "registration_ids": userToken,
      "notification": {
        "title": '$title',
        "body": '$body',
        "sound": "default",
        "color": "#ff3296fa",
        "vibrate": "300",
        "priority": 'high',
      },
      "android": {
        "priority": 'high',
        "notification": {
          "sound": 'default',
          "color": '#ff3296fa',
          "clickAction": 'FLUTTER_NOTIFICATION_CLICK',
          "notificationType": '52',
        },
      },
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "storeId": '$storeId',
        "route": '$route',
        "imageUrl": '$imageUrl',
        "chatId": '$chatId',
        "firstName": '$firstName',
        "lastName": '$lastName',
        "userId": '$userId',
        "userToken": globalUserToken
      }
    };
    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=${global.appInfo.userServerKey}' // 'key=YOUR_SERVER_KEY'
    };
    final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);
    if (response.statusCode == 200) {
      // on success do sth
      print('Send');
      return true;
    } else {
      print('Error');
      // on failure do sth
      return false;
    }
  }

  Future<dynamic> changePassword(String phoneNumber, String password) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap(
          {'user_phone': phoneNumber, 'user_password': password});
      response = await dio.post('${global.baseUrl}change_password',
          data: formData,
          options: Options(
            headers: await global.getApiHeaders(false),
          ));
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = true;
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - changePassword(): " + e.toString());
    }
  }

  Future<dynamic> checkout(
      {String? cartId,
      String? paymentStatus,
      String? paymentMethod,
      String? wallet,
      String? paymentId,
      String? paymentGateway,
      int? userid,
      String? delivery_date,
      String? time_slot,
      int? total_delivery,
      String? repeat_orders,
      int? is_subscription,
      int? address_id,
      String? orderid,
      int? store_id,
      String? order_date,
      var coupon_id,
      String? coupon_code,
      var discount_amount,
      int? bankID,
      String? si_sub_ref_no}) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'cart_id': cartId,
        'payment_method': paymentMethod,
        'payment_status': paymentStatus,
        'wallet': wallet,
        'payment_id': paymentId,
        'payment_gateway': paymentGateway,
        "user_id": userid,
        "delivery_date": delivery_date,
        "time_slot": time_slot,
        "total_delivery": total_delivery,
        "repeat_orders": repeat_orders,
        "is_subscription": is_subscription,
        "address_id": address_id,
        "order_id": orderid,
        "store_id": store_id,
        "order_date": order_date,
        'coupon_id': coupon_id,
        'coupon_code': coupon_code,
        'discount_amount': discount_amount,
        'bank_id': bankID,
        'si_sub_ref_no': si_sub_ref_no
      });
      print(
          " 'g1---> 'cart_id': ${cartId},'payment_method': ${paymentMethod},'payment_status': ${paymentStatus},'wallet': ${wallet},'payment_id': ${paymentId}, 'payment_gateway': ${paymentGateway},user_id: ${userid},delivery_date: ${delivery_date}, time_slot: ${time_slot},total_delivery: ${total_delivery},repeat_orders: ${repeat_orders}, is_subscription: ${is_subscription}, address_id: ${address_id}, order_id: ${cartId}, store_id:${store_id}, order_date:${order_date},'coupon_id' :${coupon_id},'coupon_code' :${coupon_code},'discount_amount' : ${discount_amount},'bank_id': ${bankID},'si_sub_ref_no': ${si_sub_ref_no}");
      print('${global.baseUrl}checkout');
      response = await dio.post(
        '${global.baseUrl}checkout',
        data: formData,
      );
      dynamic recordList;
      if ((response.statusCode == 200 && response.data["status"] == '1') ||
          (response.statusCode == 200 && response.data["status"] == '2')) {
        recordList = Order.fromJson(response.data["data"]);
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - checkout(): " + e.toString());
    }
  }

  Future<dynamic> deleteAllNotification() async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_id': global.currentUser.id,
      });

      response = await dio.post(
        '${global.baseUrl}delete_all_notification',
        data: formData,
      );
      dynamic recordList;
      if (response.statusCode == 200 && response.data['status'] == '1') {
        recordList = true;
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - deleteAllNotification(): " + e.toString());
    }
  }

  Future<dynamic> deleteOrder(String cartId, String cancelReason) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'cart_id': cartId,
        'reason': cancelReason,
      });

      response = await dio.post(
        '${global.baseUrl}delete_order',
        data: formData,
      );
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = response;
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - deleteOrder(): " + e.toString());
    }
  }

  Future<dynamic> delFromCart({int? varientId}) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_id': global.currentUser.id,
        'varient_id': varientId,
      });

      response = await dio.post(
        '${global.baseUrl}del_frm_cart',
        data: formData,
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = Cart.fromJson(response.data);
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - delFromCart(): " + e.toString());
    }
  }

  Future<dynamic> editAddress(
      Address1 address, String countryFlag, String toWhom) async {
    try {
      Response response;
      var dio = Dio();

      var formData = FormData.fromMap({
        'address_id': address.addressId,
        'user_id': global.currentUser.id,
        "to_name": toWhom,
        'type': address.type.toString(),
        'receiver_name': address.receiverName.toString(),
        'receiver_phone': address.receiverPhone,
        'city_name': address.city.toString(),
        'society_name': address.society.toString(),
        'house_no': address.houseNo.toString(),
        'building_villa': address.building_villa.toString(),
        'cityname': address.cityName.toString(),
        'landmark': address.landmark.toString(),
        "flag_code": countryFlag,
        "country_code": address.countryCode,
        'state': address.state.toString(),
        'pin': "",
        'lat': address.lat != null ? address.lat : '',
        'lng': address.lng != null ? address.lng : ''
      });
      print("########################################################");
      print('${global.baseUrl}edit_address');

      print(formData.fields);
      response = await dio.post(
        '${global.baseUrl}edit_address',
        data: formData,
      );
      dynamic recordList;
      if (response.statusCode == 200 && response.data['status'] == '1') {
        recordList = true;
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - editAddress(): " + e.toString());
    }
  }

  Future<dynamic> firebaseOTPVerification(String phone, String status) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({'user_phone': phone, 'status': status});
      response = await dio.post(
        '${global.baseUrl}verifyOtpPassfirebase',
        data: formData,
        options: Options(
          headers: await global.getApiHeaders(false),
        ),
      );
      dynamic recordList;
      if (response.statusCode == 200 &&
          response.data['status'].toString() == '1') {
        recordList = true;
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - firebaseOTPVerification(): " + e.toString());
    }
  }

  Future<dynamic> forgotPassword(String userPhone) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({'user_phone': userPhone});
      response = await dio.post('${global.baseUrl}forget_password',
          data: formData,
          options: Options(
            headers: await global.getApiHeaders(false),
          ));
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = true;
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - forgotPassword(): " + e.toString());
    }
  }

  Future<dynamic> getActiveOrders(int page) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_id': global.currentUser.id,
      });
      print(
          "################################################################################");
      print('${global.nodeBaseUrl}my_orders');
      print("user_id: ${global.currentUser.id}");
      response = await dio.post(
        '${global.nodeBaseUrl}my_orders',
        data: {
          'user_id': global.currentUser.id,
        }, //formData,
      );
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = List<Order>.from(
            response.data["data"].map((x) => Order.fromJson(x)));
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getOrderHistory(): " + e.toString());
    }
  }

  Future<dynamic> getOrderDetails(String cartID) async {
    print("AAAAAAAAAAAAAAAA ${cartID} ");
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_id': global.currentUser.id,
        'cart_id': cartID,
      });
      print(
          "#################################################################");
      print('${global.baseUrl}order_details');
      print(formData.fields);

      response = await dio.post(
        '${global.baseUrl}order_details',
        data: formData,
      );
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        print(response.data["data"]);
        recordList = List<OrderDetails>.from(
            response.data["data"].map((x) => OrderDetails.fromJson(x)));
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getOrderHistory()order_details: " + e.toString());
    }
  }

  Future<dynamic> getAddressList() async {
    print(global.currentUser.id);
    // print(global.appInfo.store_id);
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_id': global.currentUser.id,
      });
      print('${global.baseUrl}show_address');
      print('${global.baseUrl}show_address');
      print(" 'user_id': ${global.currentUser.id}");
      response = await dio.post(
        '${global.baseUrl}show_address',
        data: formData,
      );

      dynamic recordList;
      print(response.data.toString());
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = List<Address1>.from(
            response.data["data"].map((x) => Address1.fromJson(x)));
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getAddressList(): " + e.toString());
    }
  }

  Future<dynamic> getAllNotification(int page) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({'user_id': global.currentUser.id});
      print('${global.baseUrl}notificationlist?page=$page');
      print('user_id: ${global.currentUser.id}');
      response = await dio.post(
        '${global.baseUrl}notificationlist?page=$page',
        data: formData,
      );
      dynamic recordList;
      print(response);
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = List<NotificationModel>.from(
            response.data["data"].map((x) => NotificationModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getAllNotification(): " + e.toString());
    }
  }

  Future<dynamic> getAppInfo() async {
    try {
      Response response;
      var dio = Dio();
      var platform;

      if (Platform.isIOS) {
        platform = "ios";
      } else {
        platform = "android";
      }

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;

      var fcmToken = '';

      var formData = FormData.fromMap({
        "app_name": "customer",
        "platform": platform,
        "actual_device_id": "",
        "user_id": global.currentUser.id.toString().length > 0
            ? global.currentUser.id
            : "",
        "fcm_token": global.appDeviceId
      });
      print('${global.baseUrl}app_info');
      print(
          "{'user_id': ${global.currentUser.id}, platform: ${platform}, app_name: customer, 'fcm_token': ${fcmToken},'actual_device_id' : ${global.globalDeviceId},  app_cur_version: ${version}");
      response = await dio.post('${global.baseUrl}app_info',
          data: formData,
          options: Options(
            headers: await global.getApiHeaders(false),
          ));
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = AppInfo.fromJson(response.data);
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getAppInfo(): " + e.toString());
    }
  }

  Future<dynamic> getBannerProductDetail(int varientId) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'varient_id': varientId,
        'store_id': global.appInfo.store_id,
        'user_id': global.currentUser.id,
      });

      response = await dio.post(
        '${global.baseUrl}banner_var',
        data: formData,
      );
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = ProductDetail.fromJson(response.data["data"]);
        print("AAAAAAAAAAAAAAAA");
        print(response.data["data"]);
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getBannerProductDetail(): " + e.toString());
    }
  }

  Future<dynamic> getCategoryList(int page) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({});
      response = await dio.post(
        '${global.baseUrl}catee?page=${page}',
        data: formData,
      );
      print(response);
      dynamic recordList;
      if (response.statusCode == 200 &&
          response.data["message"] == 'data found') {
        recordList = List<CategoryList>.from(
            response.data["data"].map((x) => CategoryList.fromJson(x)));
      } else {
        recordList = null;
      }
      print(recordList);
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getCategoryList(): " + e.toString());
    }
  }

  Future<dynamic> getSubCatList(int parentCatId) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({"cat_id": parentCatId});
      print(
          "#################################################################");
      print('sub cat id${formData.fields}');
      print("${baseUrl}subcatlist");
      response = await dio.post(
        '${global.baseUrl}subcatlist',
        data: formData,
      );

      print(response);
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = List<SubCateeList>.from(
            response.data["data"].map((x) => SubCateeList.fromJson(x)));
        print(recordList);
      } else {
        recordList = null;
      }
      print(recordList);
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getSubCategoryList(): " + e.toString());
    }
  }

  Future<dynamic> getEventMessages() async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({'user_id': currentUser.id});
      print("'user_id': ${currentUser.id}");
      response = await dio.post(
        '${global.baseUrl}getmessages',
        data: formData,
      );
      print(response);
      dynamic recordList;
      if (response.statusCode == 200 &&
          response.data["message"] == 'Message Details') {
        recordList = List<EventsDetail>.from(
            response.data["data"].map((x) => EventsDetail.fromJson(x)));
      } else {
        recordList = null;
      }
      print(recordList);
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getCategoryList(): " + e.toString());
    }
  }

  Future<dynamic> getEventsList() async {
    print('Nikhil in async---------------------');
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({});
      print('Nikhil----------------${global.baseUrl}all_event');
      response = await dio.post('${global.baseUrl}all_event');
      print("getEventsList ## ${response}");
      dynamic recordList;
      if (response.statusCode == 200 &&
          response.data["message"] == 'All event list') {
        recordList = List<EventsData>.from(
            response.data["data"].map((x) => EventsData.fromJson(x)));
      } else {
        recordList = null;
      }
      print(recordList);
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getCategoryList(): " + e.toString());
    }
  }

  Future<dynamic> getCelebrationsList() async {
    print('Nikhil in async---------------------');
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'device_id': "${global.globalDeviceId}",
        'platform': Platform.isIOS ? "IOS" : "ANDROID",
        'version': "${version}"
      });
      print('Nikhil----------------${global.baseUrl}celebration_event');
      response = await dio.post(
        '${global.baseUrl}celebration_event',
        data: formData,
      );
      print("getCelebrationsList${response}");
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = List<Celbrations>.from(
            response.data["data"].map((x) => Celbrations.fromJson(x)));
      } else {
        recordList = null;
      }
      print(recordList);
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getCategoryList(): " + e.toString());
    }
  }

  Future<dynamic> getRelationList() async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({});
      response = await dio.post(
        '${global.baseUrl}userrelation',
        data: formData,
      );
      print("relationship response${response}");
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = List<RelationshipData>.from(
            response.data["data"].map((x) => RelationshipData.fromJson(x)));
      } else {
        recordList = null;
      }
      print(recordList);
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getRelationList(): " + e.toString());
    }
  }

  Future<dynamic> addMember(String fullName, String relation, String celebName,
      String dateDay, String dateMonth, String dateYear) async {
    print('Nikhil in async---------------------');
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        "user_id": global.currentUser.id != null ? global.currentUser.id : "",
        "name": fullName,
        "relation": relation,
        "celebration_name": celebName,
        "date_day": dateDay == null ? DateTime.now().day : dateDay,
        "date_month": dateMonth == null
            ? DateFormat("MMMM").parse(DateTime.now().month.toString())
            : dateMonth,
        "date_year": "",
        'device_id': "${global.globalDeviceId}",
        'platform': Platform.isIOS ? "IOS" : "ANDROID",
        'version': "${version}"
      });
      print(
          "#################################################################");
      print(formData.fields);
      print('Nikhil----------------${global.baseUrl}add_member');
      response = await dio.post(
        '${global.baseUrl}add_member',
        data: formData,
      );
      print("addMember${response}");
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = AddMember.fromJson(response.data);
      } else {
        recordList = null;
      }
      print(recordList);
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getCategoryList(): " + e.toString());
    }
  }

  Future<dynamic> updateMember(int mem_id, String fullName, String relation,
      String celebName, String dateDay, String dateMonth) async {
    print('Nikhil in async---------------------');
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        "mem_id": mem_id,
        "user_id": global.currentUser.id != null ? global.currentUser.id : "",
        "name": fullName,
        "relation": relation,
        "celebration_name": celebName,
        "date_day": dateDay,
        "date_month": dateMonth,
        "date_year": "",
      });
      print(
          "#################################################################");
      print(formData.fields);
      print('Nikhil----------------${global.baseUrl}update_member');
      response = await dio.post('${global.baseUrl}update_member',
          data: formData,
          options: Options(
            headers: await global.getApiHeaders(false),
          ));
      print("updateMember ##${response}");
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = AddMember.fromJson(response.data);
      } else {
        recordList = null;
      }
      print(recordList);
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getCategoryList(): " + e.toString());
    }
  }

  Future<dynamic> getMemberList() async {
    print('Nikhil in async---------------------');
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        "user_id": global.currentUser.id != null ? global.currentUser.id : "",
        'device_id': "${global.globalDeviceId}",
        'platform': Platform.isIOS ? "IOS" : "ANDROID",
        'version': "${version}"
      });
      print('Nikhil----------------${global.baseUrl}show_member');
      response = await dio.post(
        '${global.baseUrl}show_member',
        data: formData,
      );
      print("getMemberList### ${response}");
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = List<AddMemberList>.from(
            response.data["data"].map((x) => AddMemberList.fromJson(x)));
      } else {
        recordList = null;
      }
      print(recordList);
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getCategoryList(): " + e.toString());
    }
  }

  Future<dynamic> getCategoryProducts(int catId, int page,
      ProductFilter productFilter, int isSubscription) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'cat_id': catId,
        'user_id': global.currentUser != null ? global.currentUser.id : "",
        'byname': "", //productFilter.byname,
        'min_price': "", //productFilter.minPrice,
        'max_price': "", //productFilter.maxPrice,
        'stock': "", //productFilter.stock,
        'min_discount': "", // productFilter.minDiscount,
        'max_discount': "", //productFilter.maxDiscount,
        'min_rating': "", //productFilter.minRating,
        'max_rating': "", //productFilter.maxRating,
        "sortid": productFilter != null && productFilter.filterSortID != null
            ? productFilter.filterSortID
            : "",
        "pricesortid":
            productFilter != null && productFilter.filterPriceID != Null
                ? productFilter.filterPriceID
                : "",
        "discountsortid":
            productFilter != null && productFilter.filterDiscountID != null
                ? productFilter.filterDiscountID
                : "",
        "ocassionid":
            productFilter != null && productFilter.filterOcassionID != null
                ? productFilter.filterOcassionID
                : "",
        // "sort": productFilter.sort,
        // "sortname": productFilter.sortName,
        // "sortprice": productFilter.sortprice
      });
      print(formData.fields);
      print(
          "#################################################################");

      print('${global.nodeBaseUrl}cat_product?page=$page');

      response = await dio.post(
          '${global.nodeBaseUrl}cat_product?page=$page', // '${global.baseUrl}cat_product?page=$page',
          data: {
            'page': page,
            'cat_id': catId,
            'user_id': global.currentUser != null ? global.currentUser.id : "",
            'byname': "", //productFilter.byname,
            'min_price': "", //productFilter.minPrice,
            'max_price': "", //productFilter.maxPrice,
            'stock': "", //productFilter.stock,
            'min_discount': "", // productFilter.minDiscount,
            'max_discount': "", //productFilter.maxDiscount,
            'min_rating': "", //productFilter.minRating,
            'max_rating': "", //productFilter.maxRating,
            "sortid":
                productFilter != null && productFilter.filterSortID != null
                    ? productFilter.filterSortID
                    : "",
            "pricesortid":
                productFilter != null && productFilter.filterPriceID != Null
                    ? productFilter.filterPriceID
                    : "",
            "discountsortid":
                productFilter != null && productFilter.filterDiscountID != null
                    ? productFilter.filterDiscountID
                    : "",
            "ocassionid":
                productFilter != null && productFilter.filterOcassionID != null
                    ? productFilter.filterOcassionID
                    : "",
            // "sort": productFilter.sort,
            // "sortname": productFilter.sortName,
            // "sortprice": productFilter.sortprice
          },
          options: Options(
            headers: await global.getApiHeaders(true),
          ));
      dynamic recordList;
      print("n statuscode----------niks------------${response.statusCode}");
      // print("n response data ----------------------${response.data}");
      // print("n data status----------------------${response.data["status"]}");
      if (response.statusCode == 200 && response.data["status"] == "1") {
        print("n1----------------------");
        recordList = List<Product>.from(
            response.data["data"].map((x) => Product.fromJson(x)));
      } else {
        print("n2----------------------");

        recordList = null;
      }

      return getDioResult(response, recordList);
    } catch (e) {
      print(
          "Exception - getCategoryProducts(): Nikhil APIHELPER" + e.toString());
    }
  }

  Future<dynamic> getSubCategoryProducts(int catId, int page,
      ProductFilter productFilter, int isSubscription) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'cat_id': catId,
        'user_id': global.currentUser.id,
        'byname': "",
        'min_price': "",
        'max_price': "",
        'stock': "",
        'min_discount': "",
        'max_discount': "",
        'min_rating': "",
        'max_rating': "",
        "sortid": productFilter != null && productFilter.filterSortID != null
            ? productFilter.filterSortID
            : "",
        "pricesortid":
            productFilter != null && productFilter.filterPriceID != Null
                ? productFilter.filterPriceID
                : "",
        "discountsortid":
            productFilter != null && productFilter.filterDiscountID != null
                ? productFilter.filterDiscountID
                : "",
        "ocassionid":
            productFilter != null && productFilter.filterOcassionID != null
                ? productFilter.filterOcassionID
                : "",
      });
      print(
          "#################################################################");
      print('${global.nodeBaseUrl}sub_cat_product?page=$page');
      print(formData.fields);
      response = await dio.post(
          '${global.nodeBaseUrl}sub_cat_product?page=$page',
          data: {
            'page': page,
            'cat_id': catId,
            "device_id": "${globalDeviceId}",
            "user_id":
                global.currentUser.id != null ? global.currentUser.id : "",
            'byname': "",
            'min_price': "",
            'max_price': "",
            'stock': "",
            'min_discount': "",
            'max_discount': "",
            'min_rating': "",
            'max_rating': "",
            "sortid":
                productFilter != null && productFilter.filterSortID != null
                    ? productFilter.filterSortID
                    : "",
            "pricesortid":
                productFilter != null && productFilter.filterPriceID != Null
                    ? productFilter.filterPriceID
                    : "",
            "discountsortid":
                productFilter != null && productFilter.filterDiscountID != null
                    ? productFilter.filterDiscountID
                    : "",
            "ocassionid":
                productFilter != null && productFilter.filterOcassionID != null
                    ? productFilter.filterOcassionID
                    : "",
          }, // formData,
          options: Options(
            headers: await global.getApiHeaders(false),
          ));
      dynamic recordList;
      print("n statuscode----------------------${response.statusCode}");
      print("n response data ----------------------${response.data}");
      print("n data status--------------1--------${response.data["status"]}");
      if (response.statusCode == 200 && response.data["status"] == "1") {
        print("n1----------------------");
        recordList = List<Product>.from(
            response.data["data"].map((x) => Product.fromJson(x)));
      } else {
        print("n2----------------------");

        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getCategoryProducts(): " + e.toString());
    }
  }

  Future<dynamic> getCompletedOrders(int page) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_id': global.currentUser.id,
      });

      response = await dio.post(
        '${global.baseUrl}completed_orders?page=$page',
        data: formData,
      );
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = List<Order>.from(
            response.data["data"].map((x) => Order.fromJson(x)));
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getCompletedOrders(): " + e.toString());
    }
  }

  Future<dynamic> getCoupons({String? store_id, int? total_delivery}) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_id': global.currentUser.id,
        'store_id': store_id,
        'total_delivery': total_delivery
      });
      print('${global.baseUrl}couponlist');
      print(
          "'user_id': ${global.currentUser.id}, 'store_id': ${store_id}, 'total_delivery':${total_delivery}");
      response = await dio.post(
        '${global.baseUrl}couponlist',
        data: formData,
      );
      dynamic recordList;
      print(response.data.toString());
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = List<Coupon>.from(
            response.data["data"].map((x) => Coupon.fromJson(x)));
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getStoreCoupons(): " + e.toString());
    }
  }

  Future<dynamic> getDealProducts(int page, ProductFilter productFilter) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'store_id': global.appInfo.store_id,
        'user_id': global.currentUser.id,
        'byname': productFilter.byname,
        'min_price': productFilter.minPrice,
        'max_price': productFilter.maxPrice,
        'stock': productFilter.stock,
        'min_discount': productFilter.minDiscount,
        'max_discount': productFilter.maxDiscount,
        'min_rating': productFilter.minRating,
        'max_rating': productFilter.maxRating,
        "sort": productFilter.sort,
        "sortname": productFilter.sortName,
        "sortprice": productFilter.sortprice,
        'cat_id': productFilter.subCatID,
      });
      print(
          "'store_id': ${global.appInfo.store_id}, 'user_id': ${global.currentUser.id},'byname': ${productFilter.byname},'min_price': ${productFilter.minPrice}, 'max_price': ${productFilter.maxPrice},'stock': ${productFilter.stock},'min_discount': ${productFilter.minDiscount}, 'max_discount': ${productFilter.maxDiscount},'min_rating': ${productFilter.minRating},'max_rating': ${productFilter.maxRating}, 'sort': ${productFilter.sort}, 'sortname': ${productFilter.sortName}, 'sortprice': ${productFilter.sortprice}, 'cat_id': ${productFilter.subCatID},");
      print('${global.baseUrl}dealproduct?page=$page');

      response = await dio.post('${global.baseUrl}dealproduct?page=$page',
          data: formData,
          options: Options(
            headers: await global.getApiHeaders(false),
          ));
      dynamic recordList;
      print('G1-->DealProducts-->${response}');

      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = List<Product>.from(
            response.data["data"].map((x) => Product.fromJson(x)));
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getDealProducts(): " + e.toString());
    }
  }

  dynamic getDioResult<T>(final response, T recordList) {
    try {
      dynamic result;
      result = DioResult.fromJson(response, recordList);
      return result;
    } catch (e) {
      print("Exception - getDioResult():" + e.toString());
    }
  }

  dynamic getDioResultExtra<T>(final response, T recordList) {
    try {
      dynamic result;
      result = DioResultExtra.fromJson(response, recordList);
      return result;
    } catch (e) {
      print("Exception - getDioResult():" + e.toString());
    }
  }

  Future<dynamic> getNearbyStore() async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({'lat': global.lat, 'lng': global.lng});
      print('${global.baseUrl}getneareststore');
      print({'lat': global.lat, 'lng': global.lng});
      response = await dio.post('${global.baseUrl}getneareststore',
          queryParameters: {
            'lang': global.languageCode,
          },
          data: formData,
          options: Options(
            headers: await global.getApiHeaders(false),
          ));
      dynamic recordList;
      // print(response.data);
      if (response.statusCode == 200 && '${response.data['status']}' == '1') {
        recordList = NearStoreModel.fromJson(response.data['data']);
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getNearbyStore(): " + e.toString());
    }
  }

  Future<dynamic> getProductDetail(int productId, int isSubscription) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_id': global.currentUser.id != null ? global.currentUser.id : "",
        'product_id': productId,
      });
      print(
          "'user_id': ${global.currentUser.id},'product_id': ${productId},'store_id': ${global.appInfo.store_id},'is_subscription': ${isSubscription}");
      print(
          "##########################################################################################");
      print('${global.baseUrl}product_det');
      response = await dio.post('${global.baseUrl}product_det',
          data: {
            "device_id": "${globalDeviceId}",
            "user_id":
                global.currentUser.id != null ? global.currentUser.id : "",
            'product_id': productId,
          }, //formData,
          options: Options(
            headers: await global.getApiHeaders(false),
          ));
      dynamic recordList;
      print("this is detail without parse${response.data['data']}");
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = ProductDetail.fromJson(response.data["data"]);
        print(response.data["data"]);
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getProductDetail(): " + e.toString());
    }
  }

  Future<dynamic> getproductSearchResult(String keyWord,
      ProductFilter productFilter, String cat_subCat_ID, String catType) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'store_id': "", // global.appInfo.store_id,
        'keyword': keyWord,
        'device_id': "${global.globalDeviceId}",
        "cat_id": cat_subCat_ID,
        "cat_type": catType,
        'user_id': global.currentUser != null ? global.currentUser.id : "",
        'byname': productFilter != null && productFilter.byname != null
            ? productFilter.byname != null
            : "",
        'min_price': productFilter != null && productFilter.minPrice != null
            ? productFilter.minPrice
            : "",
        'max_price': productFilter != null && productFilter.maxPrice != null
            ? productFilter.maxPrice
            : "",
        'stock': productFilter != null && productFilter.stock != null
            ? productFilter.stock
            : "",
        'min_discount':
            productFilter != null && productFilter.minDiscount != null
                ? productFilter.minDiscount
                : "",
        'max_discount':
            productFilter != null && productFilter.maxDiscount != null
                ? productFilter.maxDiscount
                : "",
        'min_rating': productFilter != null && productFilter.minRating != null
            ? productFilter.minRating
            : "",
        'max_rating': productFilter != null && productFilter.maxRating != null
            ? productFilter.maxRating
            : "",

        "sort": productFilter != null && productFilter.sort != null
            ? productFilter.sort
            : "",
        "sortname": productFilter != null && productFilter.sortName != null
            ? productFilter.sortName
            : "",
        "sortprice": productFilter != null && productFilter.sortprice != null
            ? productFilter.sortprice
            : "",
        "sortid": productFilter != null && productFilter.filterSortID != null
            ? productFilter.filterSortID
            : "",
        "pricesortid":
            productFilter != null && productFilter.filterPriceID != null
                ? productFilter.filterPriceID
                : "",
        "discountsortid":
            productFilter != null && productFilter.filterDiscountID != null
                ? productFilter.filterDiscountID
                : "",
        "ocassionid":
            productFilter != null && productFilter.filterOcassionID != null
                ? productFilter.filterOcassionID
                : "",
      });
      print(formData.fields);
      print(
          "##########################################################################################");
      print('${global.nodeBaseUrl}searchbystore');

      response = await dio.post('${global.nodeBaseUrl}searchbystore',
          data: {
            'store_id': "", // global.appInfo.store_id,
            'keyword': keyWord,
            "cat_id": cat_subCat_ID,
            "cat_type": catType,
            'user_id': global.currentUser != null ? global.currentUser.id : "",
            'device_id': "${global.globalDeviceId}",
            'byname': productFilter != null && productFilter.byname != null
                ? productFilter.byname != null
                : "",
            'min_price': productFilter != null && productFilter.minPrice != null
                ? productFilter.minPrice
                : "",
            'max_price': productFilter != null && productFilter.maxPrice != null
                ? productFilter.maxPrice
                : "",
            'stock': productFilter != null && productFilter.stock != null
                ? productFilter.stock
                : "",
            'min_discount':
                productFilter != null && productFilter.minDiscount != null
                    ? productFilter.minDiscount
                    : "",
            'max_discount':
                productFilter != null && productFilter.maxDiscount != null
                    ? productFilter.maxDiscount
                    : "",
            'min_rating':
                productFilter != null && productFilter.minRating != null
                    ? productFilter.minRating
                    : "",
            'max_rating':
                productFilter != null && productFilter.maxRating != null
                    ? productFilter.maxRating
                    : "",
            // "cat_id": productFilter != null && productFilter.subCatID != null
            //     ? productFilter.subCatID
            //     : "",
            "sort": productFilter != null && productFilter.sort != null
                ? productFilter.sort
                : "",
            "sortname": productFilter != null && productFilter.sortName != null
                ? productFilter.sortName
                : "",
            "sortprice":
                productFilter != null && productFilter.sortprice != null
                    ? productFilter.sortprice
                    : "",
            "sortid":
                productFilter != null && productFilter.filterSortID != null
                    ? productFilter.filterSortID
                    : "",
            "pricesortid":
                productFilter != null && productFilter.filterPriceID != null
                    ? productFilter.filterPriceID
                    : "",
            "discountsortid":
                productFilter != null && productFilter.filterDiscountID != null
                    ? productFilter.filterDiscountID
                    : "",
            "ocassionid":
                productFilter != null && productFilter.filterOcassionID != null
                    ? productFilter.filterOcassionID
                    : "",
          },
          // data: formData,
          options: Options(
            headers: await global.getApiHeaders(false),
          ));
      dynamic recordList;
      print(response.data['data']);
      if (response.statusCode == 200 && response.data["status"] == '1') {
        if (keyWord != null && keyWord.length > 0) {
          FirebaseAnalyticsGA4().callSearchEventEvent(keyWord);
        }
        recordList = List<Product>.from(
            response.data["data"].map((x) => Product.fromJson(x)));
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getproductSearchResult(): " + e.toString());
    }
  }

  Future<dynamic> getStoreCoupons() async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_id': global.currentUser.id,
        'store_id': global.appInfo.store_id
      });
      response = await dio.post('${global.baseUrl}storecoupons',
          data: formData,
          options: Options(
            headers: await global.getApiHeaders(false),
          ));
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = List<Coupon>.from(
            response.data["data"].map((x) => Coupon.fromJson(x)));
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getStoreCoupons(): " + e.toString());
    }
  }

  Future<dynamic> getTimeSlot(
      DateTime selectedDate, String selectedDays) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'store_id': global.appInfo.store_id,
        'selected_date': selectedDate,
        'repeated_days': selectedDays
      });
      print(
          "'store_id': ${global.appInfo.store_id},'selected_date': ${selectedDate}");
      print(
          "##########################################################################################");

      print('${global.baseUrl}timeslot');
      response = await dio
          .post('${global.baseUrl}timeslot',
              data: formData,
              options: Options(
                headers: await global.getApiHeaders(true),
              ))
          .timeout(Duration(seconds: 60));
      dynamic recordList;
      print(response.data);
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = List<TimeSlot>.from(
            response.data["data"].map((x) => TimeSlot.fromJson(x)));
      } else {
        recordList = null;
      }
      return getDioResultExtra(response, recordList);
    } catch (e) {
      print("Exception - getTimeSlot(): " + e.toString());
    }
  }

  getWishListProduct(
      int page, ProductFilter productFilter, int is_subscription) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        "user_id": global.currentUser.id != null ? global.currentUser.id : '',
      });
      print(
          "##########################################################################################");
      print("${global.baseUrl}show_wishlist?page=$page");
      response = await dio.post('${global.baseUrl}show_wishlist?page=$page',
          data: {
            'page': page,
            "user_id":
                global.currentUser.id != null ? global.currentUser.id : '',
          }, //formData,
          options: Options(
            headers: await global.getApiHeaders(false),
          ));
      dynamic recordList;
      print("${response.data["data"].toString()}");
      if (response.data['status'] == '1' && response.statusCode == 200) {
        print("G1---> wishlist added");
        recordList = List<Product>.from(
            response.data["data"].map((x) => Product.fromJson(x)));
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getWishListProduct(): " + e.toString());
    }
  }

  Future<dynamic> login(
      String userPhone, String countryCode, int activateAccount) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_phone': userPhone,
        'country_code': countryCode,
        'dialcode': countryCode,
        'reactivate': activateAccount,
        'device_id': "${global.globalDeviceId}",
        "platform": Platform.isIOS ? "IOS" : "ANDROID",
        "app_cur_version": version
      });
      print("###########################################");
      print('${global.baseUrl}login');
      print(formData.fields);
      response = await dio.post('${global.baseUrl}login',
          queryParameters: {
            'lang': global.languageCode,
          },
          data: formData,
          options: Options(
            headers: await global.getApiHeaders(false),
          ));

      dynamic recordList;
      print(response);
      if (response.statusCode == 200 && response.data['status'] == '1') {
        recordList = CurrentUser.fromJson(response.data['data']);

        print(recordList.toString());
      } else if (response.statusCode == 200 && response.data['status'] == '3') {
        recordList = response.data;
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - login(): " + e.toString());
    }
  }

  Future<dynamic> makeOrder(
      {DateTime? selectedDate,
      int? user_id,
      String? selectedTime,
      int? totalDelivery,
      String? repeatOrders,
      String? paymentType,
      String? totalAmount,
      int? selectedAddressID,
      int? bankID,
      String? walletmount,
      String? coupon_code,
      String? coupon_amount,
      String? si_sub_ref_no,
      String? tapcustomer_id,
      String? transaction_status,
      String? message,
      String? description,
      String? charge_id}) async {
    try {
      Response response;
      var dio = Dio();

      var formData = {
        "user_id": user_id,
        "address_id": selectedAddressID,
        "payment_method": paymentType,
        "payment_status": "success",
        "wallet": "no",
        "message": message,
        "payment_id": "",
        "payment_gateway": "",
        "coupon_code": coupon_code != null ? coupon_code : "",
        "coupon_amount": coupon_amount != null ? coupon_amount : 0,
        "wallet_amount": walletmount,
        "total_mrp": totalAmount,
        "tapcustomer_id": tapcustomer_id,
        "transaction_status": transaction_status,
        "charge_id": charge_id,
        "description": description != null ? description : "",
        "platform": Platform.isIOS ? "Ios" : "Android",
      };

      print('${global.baseUrl}payment-request');
      print("G1-----payment-request-------->$formData");
      print("Headers: ${await global.getApiHeaders(false)}");

      response = await dio.post(
        '${global.baseUrl}payment-request', //'${global.baseUrl}payment-request',
        data: formData,
        options: Options(
          headers: {
            ...(await global.getApiHeaders(false)),
            'Content-Type': 'application/json',
          },
          validateStatus: (status) =>
              status != null && status < 500, // for debugging
        ),
      );
      dynamic recordList;
      print("G1---payment-request--->$response");
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = response.data;
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - makeOrder()--------------: " + e.toString());
    }
  }

  Future<dynamic> myProfile() async {
    try {
      Response response;
      var dio = Dio();
      print('${global.baseUrl}myprofile');
      print('user_id: ${global.currentUser.id}');
      var formData = FormData.fromMap({'user_id': global.currentUser.id});
      response = await dio.post(
        '${global.baseUrl}myprofile',
        queryParameters: {
          'lang': global.languageCode,
        },
        data: formData,
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = CurrentUser.fromJson(response.data['data']);
        recordList.token = response.data["token"];
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - myProfile(): " + e.toString());
    }
  }

  Future<dynamic> paymentError(
      String activityName, dynamic description, int? i) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_id': global.currentUser.id,
        'activity_name': activityName,
        'description': description
      });

      // print('${global.baseUrl}payment_logs');
      // print(formData.fields);
      response = await dio.post(
        '${global.baseUrl}payment_logs',
        data: formData,
      );
      dynamic recordList;
      // print("G1--payment_logs--->$response");
      if (response.statusCode == 200 && response.data['status'] == 1) {
        recordList = true;
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - redeemReward(): " + e.toString());
    }
  }

  Future<dynamic> removeAddress(int addressId) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'address_id': addressId,
        'user_id': global.currentUser != null ? global.currentUser.id : ""
      });
      print(
          "#################################################################");
      print('${global.baseUrl}remove_address');
      print(formData.fields);
      response = await dio.post(
        '${global.baseUrl}remove_address',
        data: formData,
      );
      dynamic recordList;
      if (response.statusCode == 200 && response.data['status'] == '1') {
        recordList = true;
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - removeAddress(): " + e.toString());
    }
  }

  Future<dynamic> resendOTP(String userPhone, String countryCode) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;

      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_phone': userPhone,
        'country_code': countryCode,
        "platform": Platform.isIOS ? "IOS" : "ANDROID",
        "app_cur_version": version
      });
      response = await dio.post('${global.baseUrl}resendotp',
          data: formData,
          options: Options(
            headers: await global.getApiHeaders(false),
          ));
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = CurrentUser.fromJson(response.data['data']);
        recordList.token = response.data["token"];
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - resendOTP(): " + e.toString());
    }
  }

  Future<dynamic> selectAddressForCheckout(int addressId) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({'address_id': addressId});

      response = await dio.post(
        '${global.baseUrl}select_address',
        data: formData,
      );
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = response.data;
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - selectAddressForCheckout(): " + e.toString());
    }
  }

  Future<dynamic> sendUserFeedback(
      String feedBackType,
      String name,
      String phoneNo,
      String countryCode,
      String message,
      String filePath) async {
    try {
      Response response;
      var dio = Dio();

      print("${global.baseUrl}contactus");
      var formData = FormData.fromMap({
        'filepath':
            filePath.isNotEmpty ? await MultipartFile.fromFile(filePath) : null,
        'user_id': global.currentUser != null ? global.currentUser.id : "",
        'name': name,
        'phone_no': phoneNo,
        'country_code': countryCode,
        'type': feedBackType,
        'message': message,
      });

      response = await dio.post(
        '${global.baseUrl}contactus',
        data: formData,
      );

      dynamic recordList;
      if (response.statusCode == 200 && response.data['status'] == '1') {
        recordList = true;
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
      // });
    } catch (e) {
      print("Exception - calbackRequest(): " + e.toString());
      throw e;
    }
  }

  Future<dynamic> showCart() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      print(global.currentUser.id);
      print("${global.globalDeviceId}");
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_id': global.currentUser.id != null
            ? global.currentUser.id.toString()
            : "",
        'device_id': "${global.globalDeviceId}",
        "platform": Platform.isIOS ? "IOS" : "ANDROID",
        "app_cur_version": version
      });

      print(global.currentUser.id.toString());
      print(global.globalDeviceId);
      print(
        Platform.isIOS ? "IOS" : "ANDROID",
      );
      print(version);
      print(
          "#################################################################");
      print('${global.baseUrl}show_cart');
      print(formData.fields);
      print(
          "'user_id': ${global.currentUser.id},${version},${global.globalDeviceId} hello");
      print("'app_cur_version':${version}");
      response = await dio.post(
        '${global.baseUrl}show_cart',
        data: formData,
      );

      print("Nikhil1");
      dynamic recordList;
      print("Nikhil This is the response ${response}");
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = Cart.fromJson(response.data);
        print("Nikhil response ${recordList}");
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Nikhil");
      print("Exception API HELPER- showCart(): " + e.toString());
    }
  }

  Future<dynamic> showRecentSearch() async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_id': global.currentUser.id,
      });
      print("'user_id': ${global.currentUser.id}");
      print('${global.baseUrl}recent_search');
      response = await dio.post(
        '${global.baseUrl}recent_search',
        data: formData,
      );
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = List<RecentSearch>.from(
            response.data["data"].map((x) => RecentSearch.fromJson(x)));
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - showRecentSearch(): " + e.toString());
    }
  }

  Future<dynamic> showTrendingSearchProducts() async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'store_id': global.appInfo.store_id,
      });
      print('${global.baseUrl}trendsearchproducts');
      print("'store_id': ${global.appInfo.store_id}");
      response = await dio.post(
        '${global.baseUrl}trendsearchproducts',
        data: formData,
      );
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = List<Product>.from(
            response.data["data"].map((x) => Product.fromJson(x)));
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - showRecentSearch(): " + e.toString());
    }
  }

  Future<dynamic> showTrendingSearchBrand() async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({});
      print('${global.baseUrl}trendsearchproducts_brand');
      print("'store_id': ${global.appInfo.store_id}");
      response = await dio.post(
        '${global.baseUrl}trendsearchproducts_brand',
        data: formData,
      );
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = List<Product>.from(
            response.data["data"].map((x) => Product.fromJson(x)));
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - showRecentSearch(): " + e.toString());
    }
  }

  Future<dynamic> signUp(
      CurrentUser user,
      String countryCode,
      String gender,
      String referralCode,
      int whatsAppFlag,
      int privacyFlag,
      String countryFlag) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;

      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        "user_phone": user.userPhone,
        "user_email": user.email,
        "user_gender": gender,
        "whatsapp_flag": whatsAppFlag,
        "privacy_policy_flag": privacyFlag,
        "password": "",
        "fb_id": 1,
        "user_city": 1,
        "user_area": 1,
        "facebook_id": "",
        "name": user.name,
        "dob": user.dob,
        "referral_code": referralCode,
        "flag_code": countryFlag,
        "user_image": "",
        "dialcode": countryCode,
        'country_code': countryCode,
        "platform": Platform.isIOS ? "IOS" : "ANDROID",
        "app_cur_version": version
      });
      print('${global.baseUrl}register_details');
      print(
          "'name': ${user.name},'country_code':${countryCode},'user_email': ${user.email},'user_phone': ${user.userPhone}, 'password': ${user.password},'fb_id': ${user.fbId}, 'referral_code': ${user.referralCode}");
      response = await dio.post('${global.baseUrl}register_details',
          data: formData,
          options: Options(
            headers: await global.getApiHeaders(false),
          ));
      // print(response.data);
      dynamic recordList;
      if (response.statusCode == 200 && response.data['status'] == '1') {
        recordList = CurrentUser.fromJson(response.data['data']);
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - signUp(): " + e.toString());
    }
  }

  Future<dynamic> socialLogin(
      {String? userEmail,
      String? userName,
      String? facebookId,
      String? type,
      String? appleId}) async {
    print(userEmail);

    try {
      Response response;
      var dio = Dio();

      var formData = FormData.fromMap({
        "email": userEmail,
        "name": userName,
        'device_id': global.globalDeviceId,
        'fcm_token': global.appDeviceId,
        "platform": Platform.isIOS ? "IOS" : "ANDROID",
      });
      print(
          "#################################################################");
      print('${global.baseUrl}socialmedialogin');
      print(formData.fields);
      response = await dio.post(
        '${global.baseUrl}socialmedialogin',
        data: formData,
      );

      dynamic recordList;
      print("this is the social login response${response}");
      if (response.statusCode == 200 && response.data['status'] == '1') {
        recordList = List<CurrentUser>.from(
            response.data["data"].map((x) => CurrentUser.fromJson(x)));
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception -apiHelper socialLogin(): " + e.toString());
    }
  }

  spotLightProduct(int page, ProductFilter productFilter) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'store_id': global.appInfo.store_id,
        "user_id": global.currentUser.id,
        'byname': productFilter.byname,
        'min_price': productFilter.minPrice,
        'max_price': productFilter.maxPrice,
        'stock': productFilter.stock,
        'min_discount': productFilter.minDiscount,
        'max_discount': productFilter.maxDiscount,
        'min_rating': productFilter.minRating,
        'max_rating': productFilter.maxRating,
      });
      response = await dio.post('${global.baseUrl}spotlight?page=$page',
          data: formData,
          options: Options(
            headers: await global.getApiHeaders(false),
          ));
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = List<Product>.from(
            response.data["data"].map((x) => Product.fromJson(x)));
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - spotLightProduct(): " + e.toString());
    }
  }

  Future<dynamic> trackOrder(String cartId) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({'cart_id': cartId});
      print('${global.baseUrl}trackorder');
      print({'cart_id': cartId});
      response = await dio.post(
        '${global.baseUrl}trackorder',
        data: formData,
      );
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = Order.fromJson(response.data["data"]);
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - trackOrder(): " + e.toString());
    }
  }

  Future<dynamic> updateProfile(CurrentUser user) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'name': user.name,
        'email': user.email,
        'user_phone': user.userPhone,
        'referral_code': user.referralCode,
        'user_gender': user.gender,
        'privacy_policy_flag': user.privacy_policy_flag,
        'whatsapp_flag': user.whatsapp_flag,
        'country_code': user.countryCode,
        'user_id': global.currentUser != null ? global.currentUser.id : "",
        "dob": user.dob
      });
      print(
          "#################################################################");
      print('${global.baseUrl}profile_update');
      print(formData.fields);

      print(" 'user_name': ${user.name}, 'user_id': ${global.currentUser.id}");

      response = await dio.post(
        '${global.baseUrl}profile_update',
        data: formData,
      );
      dynamic recordList;

      if (response.statusCode == 200) {
        recordList = CurrentUser.fromJson(response.data['data']);
        recordList.token = response.data["token"];
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - updateProfile(): " + e.toString());
    }
  }

  Future<dynamic> removeProfileImage(CurrentUser user) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_id': global.currentUser.id,
      });

      response = await dio.post(
        '${global.baseUrl}profile_image_remove',
        data: formData,
      );
      dynamic recordList;

      if (response.statusCode == 200) {
        recordList = CurrentUser.fromJson(response.data['data']);
        recordList.token = response.data["token"];
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - updateProfile(): " + e.toString());
    }
  }

  Future<dynamic> verifyOTP(
      String phone, String countryCode, String otp, String referralCode) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;

      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_phone': phone,
        'otp': otp,
        'referral_code': referralCode,
        'device_id': "${global.globalDeviceId}",
        'country_code': countryCode,
        'dialcode': countryCode,
        "platform": Platform.isIOS ? "IOS" : "ANDROID",
        "app_cur_version": version
      });
      print(
          "#################################################################");
      print(formData.fields);
      response = await dio.post('${global.baseUrl}verify_phone',
          data: formData,
          options: Options(
            headers: await global.getApiHeaders(false),
          ));
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = CurrentUser.fromJson(response.data['data']);
        recordList.token = response.data["token"];
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - verifyOTP(): " + e.toString());
    }
  }

  Future<dynamic> verifyUpdateOTP(String lastID, String OTP) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;

      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        "lastid": lastID,
        "otp": OTP,
        "platform": Platform.isIOS ? "IOS" : "ANDROID",
        "app_cur_version": version
      });
      print(
          "#################################################################");
      print('${global.baseUrl}verify_otp_update');
      print(formData.fields);
      response = await dio.post('${global.baseUrl}verify_otp_update',
          data: formData,
          options: Options(
            headers: await global.getApiHeaders(false),
          ));
      dynamic recordList;
      print(response);
      if (response.statusCode == 200 && response.data["status"] == '1') {
        print("this is test1");
        // recordList = CurrentUser.fromJson(response.data['data']);
        print("this is test1");
        recordList = response.data;
        print("this is test1");
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - verifyUpdateOTP(): " + e.toString());
    }
  }

  Future<dynamic> verifyPhone(
      String phone, String otp, String countryCode, String referralCode) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_phone': phone,
        'otp': otp,
        'referral_code': referralCode,
        'device_id': "${global.globalDeviceId}",
        'country_code': countryCode,
        'dialcode': countryCode,
        "platform": Platform.isIOS ? "IOS" : "ANDROID",
        "app_cur_version": version,
        'fcm_token': "${global.appDeviceId}",
      });
      print('${global.baseUrl}verify_phone');
      print(
          "S>>>'user_phone': ${phone.toString()}, 'otp': ${otp.toString()}, 'referral_code': ${referralCode.toString()}, 'device_id': ${global.appDeviceId.toString()},");
      response = await dio.post('${global.baseUrl}verify_phone',
          data: formData,
          options: Options(
            headers: await global.getApiHeaders(false),
          ));

      dynamic recordList;
      print(response);
      if (response.statusCode == 200 && response.data['status'] == "1") {
        print("hello verify phone responce 200");
        recordList = CurrentUser.fromJson(response.data['data']);
        recordList.token = response.data["token"];
      } else if (response.data['status'] == "0") {
        recordList = response;
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - verifyPhone()12345: " + e.toString());
    }
  }

  Future<dynamic> verifyViaFirebase(
      String phone, String status, String referralCode) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_phone': phone,
        'status': status,
        'referral_code': referralCode,
        'device_id': global.appDeviceId
      });
      response = await dio.post('${global.baseUrl}verify_via_firebase',
          data: formData,
          options: Options(
            headers: await global.getApiHeaders(false),
          ));
      dynamic recordList;
      if (response.statusCode == 200 &&
          response.data["status"].toString() == "1") {
        recordList = CurrentUser.fromJson(response.data["data"]);

        recordList.token = response.data["token"];
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - verifyViaFirebase(): " + e.toString());
    }
  }

  whatsnewProduct(int page, ProductFilter productFilter) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'store_id': global.appInfo.store_id,
        "user_id": global.currentUser.id,
        'byname': productFilter.byname,
        'min_price': productFilter.minPrice,
        'max_price': productFilter.maxPrice,
        'stock': productFilter.stock,
        'min_discount': productFilter.minDiscount,
        'max_discount': productFilter.maxDiscount,
        'min_rating': productFilter.minRating,
        'max_rating': productFilter.maxRating,
        "sort": productFilter.sort,
        "sortname": productFilter.sortName,
        "sortprice": productFilter.sortprice,
        'cat_id': productFilter.subCatID,
      });
      print(
          " 'store_id': ${global.appInfo.store_id},user_id: ${global.currentUser.id}, 'byname': ${productFilter.byname},  'min_price': ${productFilter.minPrice},'max_price': ${productFilter.maxPrice}, 'stock': ${productFilter.stock}, 'min_discount': ${productFilter.minDiscount},'max_discount': ${productFilter.maxDiscount}, 'min_rating': ${productFilter.minRating},'max_rating': ${productFilter.maxRating}, 'sort': ${productFilter.sort},'sortname': ${productFilter.sortName}, 'sortprice': ${productFilter.sortprice}, 'cat_id': ${productFilter.subCatID},");
      print('${global.baseUrl}whatsnew?page=$page');
      response = await dio.post('${global.baseUrl}whatsnew?page=$page',
          data: formData,
          options: Options(
            headers: await global.getApiHeaders(false),
          ));
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = List<Product>.from(
            response.data["data"].map((x) => Product.fromJson(x)));
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - whatsnewProduct(): " + e.toString());
    }
  }

  Future<dynamic> getProductRating(int page, int varientId) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'store_id': global.appInfo.store_id,
        'varient_id': varientId,
      });
      response =
          await dio.post('${global.baseUrl}get_product_rating?page=$page',
              data: formData,
              options: Options(
                headers: await global.getApiHeaders(true),
              ));
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList =
            List<Rate>.from(response.data["data"].map((x) => Rate.fromJson(x)));
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getProductRating(): " + e.toString());
    }
  }

  Future<dynamic> getSubscriptionOrders(int page) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_id': global.currentUser.id,
      });
      print("'user_id': ${global.currentUser.id}");
      print('${global.baseUrl}my_orders_subscription?page=$page');
      response =
          await dio.post('${global.baseUrl}my_orders_subscription?page=$page',
              data: formData,
              options: Options(
                headers: await global.getApiHeaders(true),
              ));
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = List<Order>.from(
            response.data["data"].map((x) => Order.fromJson(x)));
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getOrderHistory(): " + e.toString());
    }
  }

  Future<dynamic> getTotalNumberOffDeliveries() async {
    try {
      Response response;
      var dio = Dio();
      print('${global.baseUrl}total_deliveries');

      response = await dio.post(
        '${global.baseUrl}total_deliveries',
      );
      //dynamic recordList;
      dynamic totalDeliveries;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        print("totalDeliveries:- ${response.data}");
        totalDeliveries = response.data;
      } else {
        totalDeliveries = null;
      }

      return getDioResult(response, totalDeliveries);
    } catch (e) {
      print("Exception - getOrderHistory(): " + e.toString());
    }
  }

  Future<dynamic> updateFCMToken(String deviceid) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_id': global.currentUser.id,
        "device_id": deviceid,
        "type": "customer"
      });
      print(
          "#################################################################");
      print(formData.fields);
      print('${global.baseUrl}update_fcm_token');
      response = await dio.post('${global.baseUrl}update_fcm_token',
          data: formData,
          options: Options(
            headers: await global.getApiHeaders(true),
          ));
      // print(response.data);
      dynamic recordList;
      print('${global.baseUrl}update_fcm_token');
      print(response.data);
      if (response.statusCode == 200 && response.data['status'] == '1') {
        recordList = true;
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - update_fcm_token(): " + e.toString());
    }
  }

  Future<dynamic> getCountryCode() async {
    try {
      Response response;
      var dio = Dio();
      print('${global.baseUrl}country_code_list');
      var formData = FormData.fromMap({
        'platform': Platform.isIOS ? "IOS" : "ANDROID",
      });
      response = await dio.post(
        '${global.baseUrl}countrycode',
        data: formData,
      );
      dynamic countryCodeList;

      if (response.statusCode == 200 && response.data["status"] == '1') {
        countryCodeList = List<CountryCodeList>.from(
            response.data["data"].map((x) => CountryCodeList.fromJson(x)));
        print("CountryCodeAPI:- ${countryCodeList}");
      } else {
        countryCodeList = null;
      }
      return getDioResult(response, countryCodeList);
    } catch (e) {
      print("Exception - getCountryCode(): " + e.toString());
    }
  }

  Future<dynamic> deactivatedAcount() async {
    try {
      Response response;
      var dio = Dio();
      print("This is deacticvate user id ${global.currentUser.id}");
      var formData = FormData.fromMap({
        'user_id': global.currentUser.id,
        "deactivate_by": "Customer",
        "activate_deactivate_status": "deactivate",
      });
      print(
          "#################################################################");
      print(formData.fields);
      print('${global.baseUrl}user_deactivate');
      response = await dio.post('${global.baseUrl}user_deactivate',
          data: formData,
          options: Options(
            headers: await global.getApiHeaders(true),
          ));
      dynamic recordList;

      if (response.statusCode == 200) {
        recordList = CurrentUser.fromJson(response.data['data']);
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - user_deactivate : " + e.toString());
    }
  }

  Future<dynamic> getproductSearchbySubCategory(
      String keyWord, ProductFilter productFilter) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'store_id': global.appInfo.store_id,
        'keyword': keyWord,
        'user_id': global.currentUser.id,
        'byname': productFilter.byname,
        "sub_cat_id": productFilter.subCatID
      });
      print(
          "'store_id': ${global.appInfo.store_id},'keyword': ${keyWord},'user_id': ${global.currentUser.id},'byname': ${productFilter.byname},'subCatID': ${productFilter.subCatID}");
      print('${global.baseUrl}searchbystoreproduct');
      response = await dio.post(
        '${global.baseUrl}searchbystoreproduct',
        data: formData,
      );
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = List<Product>.from(
            response.data["data"].map((x) => Product.fromJson(x)));
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getproductSearchResult(): " + e.toString());
    }
  }

  Future<dynamic> trendSearchProductsBrand_sub(int category_id) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap(
          {'store_id': global.appInfo.store_id, 'category_id': category_id});
      print('${global.baseUrl}trendsearchproducts_brand_sub');
      print(
          "'store_id': ${global.appInfo.store_id},  'category_id': ${category_id}");
      response =
          await dio.post('${global.baseUrl}trendsearchproducts_brand_sub',
              data: formData,
              options: Options(
                headers: await global.getApiHeaders(true),
              ));
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = List<Product>.from(
            response.data["data"].map((x) => Product.fromJson(x)));
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - showRecentSearch(): " + e.toString());
    }
  }

  Future<dynamic> addbankCard(
    String b_address,
    String b_city,
    String b_country,
    String s_address,
    String s_city,
    String s_country,
    String card_type,
    String bank_name,
    String holder_name,
    String card_number,
    String card_expired_date,
  ) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_id': global.currentUser.id,
        "b_address": b_address,
        "b_city": b_city,
        "b_country": b_country,
        "s_address": s_address,
        "s_city": s_city,
        "s_country": s_country,
        "card_type": card_type,
        "bank_name": bank_name,
        "holder_name": holder_name,
        "card_number": card_number,
        "card_expired_date": card_expired_date
      });
      print(
          "'user_id': ${global.currentUser.id},'b_address':${b_address},'b_city':${b_city}, 'b_country':${b_country}, 's_address':${s_address}, 's_city':${s_city}, 's_country':${s_country}, 'card_type':${card_type}, 'bank_name':${bank_name},'holder_name':${holder_name},'card_number':${card_number},'card_expired_date':${card_expired_date}");
      print('${global.baseUrl}add_bank_details');
      response = await dio.post(
        '${global.baseUrl}add_bank_details',
        data: formData,
      );
      dynamic recordList;
      print(response.data);
      if (response.statusCode == 200) {
        recordList = CurrentUser.fromJson(response.data['data']);
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - APi helper addbankCard : " + e.toString());
    }
  }

  Future<dynamic> addSIStatusBankCard(
    String SIID,
  ) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_id': global.currentUser.id,
        "si_sub_ref_no": SIID,
      });
      print("'user_id': ${global.currentUser.id},'si_sub_ref_no':${SIID}");
      print('${global.baseUrl}si_status');
      response = await dio.post(
        '${global.baseUrl}si_status',
        data: formData,
      );
      dynamic recordList;
      print(response.data);
      if (response.statusCode == 200) {
        recordList = CurrentUser.fromJson(response.data['data']);
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - api helper addSIStatusBankCard : " + e.toString());
    }
  }

  Future<dynamic> cancelOrder(
      {var cart_id, var store_order_id, var cancel_reason}) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        "user_id": global.currentUser.id,
        'cart_id': cart_id,
        'cancel_reason': cancel_reason
      });
      print(
          "'user_id': ${global.currentUser.id},'cart_id': ${cart_id}, 'store_order_id': ${store_order_id}, 'cancel_reason': $cancel_reason");
      print('${global.baseUrl}cancelledproductorder');
      response = await dio.post(
        '${global.baseUrl}cancelledproductorder',
        data: formData,
      );
      dynamic pauseMessage;
      print("cancelOrder:- ${response}");
      if (response.statusCode == 200 && response.data["status"] == '1') {
        print("cancelOrder:- ${response.data}");
        pauseMessage = response.data['message'];
      } else {
        pauseMessage = null;
      }
      return getDioResult(response, pauseMessage);
    } catch (e) {
      print("Exception - cancelOrder(): " + e.toString());
    }
  }

  Future<dynamic> updatePhoneNumberandEmail(String newInfo, String changeType,
      String country_code, String flag_code) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_id': global.currentUser.id,
        "new_info": newInfo,
        "change_type": changeType,
        "country_code": country_code,
        "flag_code": flag_code
      });
      print('${global.baseUrl}send_otp');
      print(
          "'new_info': ${newInfo},'change_type': ${changeType}, 'user_id': ${global.currentUser.id}");
      response = await dio.post(
        '${global.baseUrl}send_otp',
        data: formData,
      );
      dynamic recordList;

      if (response.statusCode == 200) {
        recordList = SettingResponse.fromJson(response.data);
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - updateProfile(): " + e.toString());
    }
  }

  Future<dynamic> veryfyPhoneandEmail(String otp, int lastid) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({"otp": otp, "lastid": lastid});

      print('${global.baseUrl}verify_otp_update');
      print("'otp': ${otp},'lastid': ${lastid}");
      response = await dio.post(
        '${global.baseUrl}verify_otp_update',
        data: formData,
      );
      dynamic recordList;

      if (response.statusCode == 200) {
        print('G1---->${response.toString()}');

        recordList = response.data;
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - updateProfile(): " + e.toString());
    }
  }

  Future<dynamic> getproductSearchbyUniversalSearch(
      String keyWord, int page, ProductFilter productFilter) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'store_id': "",
        'keyword': keyWord,
        'user_id': global.currentUser.id,
        'byname': "",
        "sub_cat_id": productFilter.subCatID,
        'min_price': productFilter.minPrice,
        'max_price': productFilter.maxPrice,
        'stock': productFilter.stock,
        'min_discount': productFilter.minDiscount,
        'max_discount': productFilter.maxDiscount,
        'min_rating': productFilter.minRating,
        'max_rating': productFilter.maxRating,
        "sort": productFilter.sort,
        "sortname": productFilter.sortName,
        "sortprice": productFilter.sortprice
      });

      print(
          "'store_id': ${global.appInfo.store_id},'keyword': ${keyWord},'user_id': ${global.currentUser.id},'byname': '','subCatID': '', ,'byname': ${productFilter.byname},'min_price': ${productFilter.minPrice},'max_price': ${productFilter.maxPrice},'stock': ${productFilter.stock},'min_discount': ${productFilter.minDiscount},'max_discount': ${productFilter.maxDiscount},'min_rating': ${productFilter.minRating},'max_rating': ${productFilter.maxRating},'sort':${productFilter.sort}, 'sortname': ${productFilter.sortName}  'sortprice':${productFilter.sortprice}");
      print('${global.baseUrl}universal_search?page=$page');
      response = await dio.post(
        '${global.baseUrl}universal_search?page=$page',
        data: formData,
      );
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = List<Product>.from(
            response.data["data"].map((x) => Product.fromJson(x)));
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getproductSearchResult(): " + e.toString());
    }
  }

  Future<dynamic> getHomeBeanData(String platform) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;

      Response response;
      var dio = Dio();
      print("User Id------${global.currentUser.id}");

      var formData = FormData.fromMap({
        'user_id': global.currentUser.id != null ? global.currentUser.id : "",
        'version_code': '',
        'device_id': "${global.globalDeviceId}",
        "platform": Platform.isIOS ? "IOS" : "ANDROID",
        "app_cur_version": version
      });
      print("########################################################");
      print(formData.fields);
      print('${global.nodeBaseUrl}oneapi');
//
      response = await dio.post(
        '${global.nodeBaseUrl}oneapi', // '${global.baseUrl}oneapi',//
        data: {
          'user_id': global.currentUser.id != null ? global.currentUser.id : "",
          'version_code': '',
          'device_id': "${global.globalDeviceId}",
          "platform": Platform.isIOS ? "IOS" : "ANDROID",
          "app_cur_version": version
        }, //formData,
      );
      dynamic recordList;
      print(response.data.toString());
      if (response.statusCode == 200 && response.data['status'] == "1") {
        recordList = HomeScreenData.fromJson(response.data);
      } else {
        recordList = null;
      }

      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getHomeScreenData(): " + e.toString());
    }
  }

  Future<dynamic> getEventFilteredProducts(int eventID, int page, String catID,
      String catType, ProductFilter filter) async {
    print('Nikhil in getEventFilteredProducts---------${eventID}------------');

    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_id': global.currentUser != null ? global.currentUser.id : "",
        "device_id": "${globalDeviceId}",
        'event_id': eventID,
        "cat_id": catID,
        "page": page,
        "cat_type": catType,
        "sortid": filter != null && filter.filterSortID != null
            ? filter.filterSortID
            : "",
        "pricesortid": filter != null && filter.filterPriceID != null
            ? filter.filterPriceID
            : "",
        "discountsortid": filter != null && filter.filterDiscountID != null
            ? filter.filterDiscountID
            : "",
        "ocassionid": filter != null && filter.filterOcassionID != null
            ? filter.filterOcassionID
            : "",
      });
      print("########################################################");
      print(formData.fields);
      print('${global.nodeBaseUrl}event_details?');
      response = await dio.post('${global.nodeBaseUrl}event_details', data: {
        "device_id": "${globalDeviceId}",
        "user_id": global.currentUser.id != null ? global.currentUser.id : "",
        'event_id': eventID,
        "cat_id": catID,
        "cat_type": catType,
        "page": page,
        "sortid": filter != null && filter.filterSortID != null
            ? filter.filterSortID
            : "",
        "pricesortid": filter != null && filter.filterPriceID != null
            ? filter.filterPriceID
            : "",
        "discountsortid": filter != null && filter.filterDiscountID != null
            ? filter.filterDiscountID
            : "",
        "ocassionid": filter != null && filter.filterOcassionID != null
            ? filter.filterOcassionID
            : "",
      } //formData,
          );
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = List<Product>.from(
            response.data["productlist"].map((x) => Product.fromJson(x)));
      } else if (response.statusCode == 200 && response.data["status"] == '0') {
        recordList = null;
      } else {
        recordList = null;
      }
      print(recordList);
      return getDioResult(response, recordList);
    } catch (e) {
      print(
          "Exception -APIHELPER  getEventFilteredProducts(): " + e.toString());
    }
  }

  Future<dynamic> getProductswithOffers(ProductFilter _filters) async {
    print('Nikhil in getProductswithOffers---------------------');
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        "sortid": _filters != null && _filters.filterSortID != null
            ? _filters.filterSortID
            : "",
        "pricesortid": _filters != null && _filters.filterPriceID != null
            ? _filters.filterPriceID
            : "",
        "discountsortid": _filters != null && _filters.filterDiscountID != null
            ? _filters.filterDiscountID
            : "",
        "ocassionid": _filters != null && _filters.filterOcassionID != null
            ? _filters.filterOcassionID
            : "",
      });
      print("########################################################");
      print('Nikhil----------------${global.baseUrl}offers');
      print(formData.fields);
      response = await dio.post(
        '${global.baseUrl}offers',
        data: formData,
      );
      print("offers response${response}");
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = List<Product>.from(
            response.data["data"].map((x) => Product.fromJson(x)));
        print("record list data parsed${recordList}");
      } else {
        recordList = null;
      }
      print(recordList);
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception -APIHELPER  getProductswithOffers(): " + e.toString());
    }
  }

  Future<dynamic> getTransactions() async {
    print('Nikhil in getTransactions---------------------');
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_id': global.currentUser.id,
      });
      print('Nikhil----------------${global.baseUrl}payment_history');
      response = await dio.post(
        '${global.baseUrl}payment_history',
        data: formData,
      );
      print("getTransactions ## ${response}");
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = List<Transactionhistory>.from(
            response.data["data"].map((x) => Transactionhistory.fromJson(x)));
        ;
        print("record list data parsed${recordList}");
      } else {
        recordList = null;
      }
      print(recordList);
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception -APIHELPER   getTransactions(): " + e.toString());
    }
  }

  Future<dynamic> getRewardWalletTransactions() async {
    print('Nikhil in getRewardWalletTransactions---------------------');
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_id': global.currentUser.id,
      });
      print("########################################################");
      print(formData.fields);
      print('${global.baseUrl}cash_reward_wallet_history');
      response = await dio.post(
        '${global.baseUrl}cash_reward_wallet_history',
        data: formData,
      );
      print("getRewardWalletTransactions response${response}");
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = RewardWalletTransaction.fromJson(response.data);

        print("getRewardWalletTransactions parsed${recordList}");
      } else {
        recordList = null;
      }
      print(recordList);
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception -APIHELPER  getRewardWalletTransactions()a: " +
          e.toString());
    }
  }

  Future<dynamic> redeemRewardWallet(String redeemCode) async {
    print('Nikhil in getRewardWalletTransactions---------------------');
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_id': global.currentUser.id,
        "reward_code": redeemCode,
        "device_id": "${globalDeviceId}"
      });
      print('Nikhil----------------${global.baseUrl}  ');
      response = await dio.post(
        '${global.baseUrl}reward_wallet',
        data: formData,
      );
      print("getRewardWalletTransactions response${response}");
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = response.data["status"];

        print("getRewardWalletTransactions parsed${recordList}");
      } else {
        recordList = null;
      }
      print(recordList);
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception -APIHELPER  getRewardWalletTransactions()b: " +
          e.toString());
    }
  }

  Future<dynamic> getCheckOutOrderDetails(String cartID) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_id': global.currentUser.id,
        'group_cart_id': cartID,
      });
      print('${global.baseUrl}checkout_order_details');
      print("'user_id': ${global.currentUser.id},'group_cart_id:'${cartID}");
      response = await dio.post(
        '${global.baseUrl}checkout_order_details',
        data: formData,
      );
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        print(response.data["data"]);
        recordList = CheckoutOrder.fromJson(response.data);
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getOrderHistory(): " + e.toString());
    }
  }

  Future<dynamic> apiDeleteMyAccount() async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_id': global.currentUser.id,
        "activate_deactivate_status": "deactivate",
        "deactivate_by": "Customer"
      });
      print("########################################################");
      print('${global.baseUrl}user_deactivate');
      print(formData.fields);
      response = await dio.post('${global.baseUrl}user_deactivate',
          data: formData,
          options: Options(
            headers: await global.getApiHeaders(false),
          ));
      dynamic recordList;
      print(response);
      if (response.statusCode == 200) {
        recordList = DeleteMyAccount.fromJson(response.data);
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception -apiHelper apiDeleteMyAccount(): " + e.toString());
    }
  }

  Future<dynamic> getCancelOrderResons() async {
    try {
      Response response;
      var dio = Dio();
      print('${global.baseUrl}cancelling_reasons');
      response = await dio.get('${global.baseUrl}cancelling_reasons',
          options: Options(
            headers: await global.getApiHeaders(false),
          ));
      dynamic recordList;
      if (response.statusCode == 200 && response.data['status'] == '1') {
        recordList = List<CancelStatusListModel>.from(response.data["data"]
            .map((x) => CancelStatusListModel.fromJson(x)));
      } else {
        recordList = null;
      }

      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - APIHelper getCancelOrderStatus(): " + e.toString());
    }
  }

  Future<dynamic> getContactUsDropDown() async {
    try {
      Response response;
      var dio = Dio();
      print('${global.baseUrl}callback_type');
      response = await dio.get(
        '${global.baseUrl}callback_type',
      );
      dynamic recordList;
      if (response.statusCode == 200 && response.data['status'] == '1') {
        recordList = List<ContactUsDropDownList>.from(response.data["data"]
            .map((x) => ContactUsDropDownList.fromJson(x)));
      } else {
        recordList = null;
      }

      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - APIHelper getContactUsDropDown(): " + e.toString());
    }
  }

  Future<dynamic> getFiltersRelations() async {
    try {
      Response response;
      var dio = Dio();
      print('${global.baseUrl}searchfilters');
      response = await dio.get('${global.baseUrl}searchfilters',
          options: Options(
            headers: await global.getApiHeaders(false),
          ));
      dynamic recordList;
      if (response.statusCode == 200 && response.data['status'] == '1') {
        recordList = SelectionData.fromJson(response.data["data"]);
      } else {
        recordList = null;
      }

      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - APIHelper getFiltersRelations(): " + e.toString());
    }
  }

  Future<dynamic> getFilteredProducts(
      int minAge,
      int maxAge,
      int genderID,
      int occassionID,
      int relationID,
      int page,
      ProductFilter productFilter,
      String cat_subCat_ID,
      String catType) async {
    print(
        " getFilteredProducts  getFilteredProducts  getFilteredProducts -- 3");
    try {
      print(" getFilteredProducts  getFilteredProducts --2 ");
      Response response;
      var dio = Dio();

      var formData = FormData.fromMap({
        "device_id": "${globalDeviceId}",
        "user_id": global.currentUser.id != null ? global.currentUser.id : "",
        'gender_id': "gender-${genderID}",
        'occasion_id': "occasion-${occassionID}",
        'relationship_id': "relationship-${relationID}",
        "min_age": minAge,
        "max_age": maxAge,
        "cat_id": cat_subCat_ID,
        "cat_type": catType,
        "sortid": productFilter != null && productFilter.filterSortID != null
            ? productFilter.filterSortID
            : "",
        "pricesortid":
            productFilter != null && productFilter.filterPriceID != null
                ? productFilter.filterPriceID
                : "",
        "discountsortid":
            productFilter != null && productFilter.filterDiscountID != null
                ? productFilter.filterDiscountID
                : "",
        "ocassionid":
            productFilter != null && productFilter.filterOcassionID != null
                ? productFilter.filterOcassionID
                : "",
      });
      print("#######################################################");
      print(formData.fields);
      print('${global.nodeBaseUrl}productfilters');
      response = await dio.post('${global.nodeBaseUrl}productfilter',
          data: {
            "device_id": "${globalDeviceId}",
            "user_id":
                global.currentUser.id != null ? global.currentUser.id : "",
            'gender_id': "gender-${genderID}",
            'occasion_id': "occasion-${occassionID}",
            'relationship_id': "relationship-${relationID}",
            "min_age": minAge,
            "max_age": maxAge,
            "page": page,
            "cat_id": cat_subCat_ID,
            "cat_type": catType,
            "sortid":
                productFilter != null && productFilter.filterSortID != null
                    ? productFilter.filterSortID
                    : "",
            "pricesortid":
                productFilter != null && productFilter.filterPriceID != null
                    ? productFilter.filterPriceID
                    : "",
            "discountsortid":
                productFilter != null && productFilter.filterDiscountID != null
                    ? productFilter.filterDiscountID
                    : "",
            "ocassionid":
                productFilter != null && productFilter.filterOcassionID != null
                    ? productFilter.filterOcassionID
                    : "",
          }, //formData,
          options: Options(
            headers: await global.getApiHeaders(false),
          ));
      dynamic recordList;
      print("n statuscode----------------------${response.statusCode}");
      print("n response data ----------------------${response.data}");
      print("n data status----------------------${response.data["status"]}");
      if (response.statusCode == 200 && response.data["status"] == "1") {
        print("n1----------------------");
        recordList = List<Product>.from(
            response.data["data"].map((x) => Product.fromJson(x)));
      } else {
        print("n2----------------------");

        recordList = null;
      }

      return getDioResult(response, recordList);
    } catch (e) {
      print(
          "Exception - getCategoryProducts(): Nikhil APIHELPER" + e.toString());
    }
  }

  Future<dynamic> deleteMemberAPI(int memberID) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'mem_id': "${memberID}",
        'user_id': "${global.currentUser.id}",
      });
      print("########################################################");
      print(formData.fields);
      print('${global.baseUrl}delete_member');
      response = await dio.post('${global.baseUrl}delete_member',
          data: formData,
          options: Options(
            headers: await global.getApiHeaders(false),
          ));
      dynamic recordList;
      if (response.statusCode == 200 && response.data['status'] == '1') {
        recordList = response.data['status'];
      } else {
        recordList = null;
      }

      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - APIHelper getFiltersRelations(): " + e.toString());
    }
  }

  Future<dynamic> updateMobileEmail(String change_type, String new_info,
      String country_code, String flag_code) async {
    try {
      print(global.currentUser.id);
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_id': "${global.currentUser.id}",
        'change_type': change_type,
        'new_info': new_info,
        'country_code': country_code,
        'flag_code': flag_code,
      });
      print("########################################################");
      print(formData.fields);
      print('${global.baseUrl}send_otp');
      response = await dio.post('${global.baseUrl}send_otp',
          data: formData,
          options: Options(
            headers: await global.getApiHeaders(false),
          ));
      dynamic recordList;
      if (response.statusCode == 200 && response.data['status'] == '1') {
        recordList = UpdateMobileEmailMobel.fromJson(response.data);
      } else {
        recordList = null;
      }

      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - APIHelper updateMobileEmail: " + e.toString());
    }
  }

  Future<dynamic> updateMobileEmailOTP(int memberID) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'mem_id': "${memberID}",
        'user_id': "${global.currentUser.id}",
      });
      print("########################################################");
      print(formData.fields);
      print('${global.baseUrl}verify_otp_update');
      response = await dio.post('${global.baseUrl}verify_otp_update',
          data: formData,
          options: Options(
            headers: await global.getApiHeaders(false),
          ));
      dynamic recordList;
      print("This is the api response ${response}");
      if (response.statusCode == 200 && response.data['status'] == '1') {
        recordList = response.data['status'];
        print("This is the api recordlist ${recordList}");
      } else {
        recordList = null;
      }

      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - APIHelper getFiltersRelations(): " + e.toString());
    }
  }

  Future<dynamic> addMobileNumberSocialMedia(String userID, String phoneNO,
      String countryCode, String flagCode) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_id': userID,
        'phoneno': phoneNO,
        'country_code': countryCode.contains("+")
            ? countryCode.replaceFirst("+", "")
            : countryCode,
        'flag_code': flagCode
      });
      print("########################################################");
      print(formData.fields);
      print('${global.baseUrl}socialmediaaddmobileno');
      response = await dio.post('${global.baseUrl}socialmediaaddmobileno',
          data: formData,
          options: Options(
            headers: await global.getApiHeaders(false),
          ));

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = response.data['status'];
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - addMobileNumberSocialMedia(): " + e.toString());
    }
  }

  Future<dynamic> verifyAddMobileOTP(
      String userID, String OTP, String phoneNo) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;

      Response response;
      var dio = Dio();
      var formData =
          FormData.fromMap({"user_id": userID, "otp": OTP, "phoneno": phoneNo});
      print("########################################################");
      print(global.baseUrl + "verifyOtpphone");
      print(formData.fields);
      response = await dio.post('${global.baseUrl}verifyOtpphone',
          data: formData,
          options: Options(
            headers: await global.getApiHeaders(false),
          ));
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = CurrentUser.fromJson(response.data['data']);
        recordList.token = response.data["token"];
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - verifyOTP(): " + e.toString());
    }
  }

  Future<dynamic> getShowFiltersData() async {
    try {
      Response response;
      var dio = Dio();
      print('${global.baseUrl}sortfillter');
      response = await dio.post('${global.baseUrl}sortfillter',
          options: Options(headers: await global.getApiHeaders(false)));
      dynamic recordList;
      print(response);
      if (response.statusCode == 200 && response.data['status'] == '1') {
        print(recordList);
        recordList = ShowFilters.fromJson(response.data);
        print(recordList);
      } else {
        recordList = null;
      }

      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - APIHelper getShowFiltersData(): " + e.toString());
    }
  }

  Future<dynamic> getTimeSlots(int productID, String selectedDate) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'product_id': productID,
        'date': selectedDate,
        // 'latest': categoryFilter.latest,
      });
      print("########################################################");
      print(formData.fields);
      print('${global.baseUrl}get_daytimeslot');
      response = await dio.post(
        '${global.baseUrl}get_daytimeslot',
        data: formData,
      );
      print(response);
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = List<TimeSlotsDetails>.from(
            response.data["data"].map((x) => TimeSlotsDetails.fromJson(x)));
      } else {
        recordList = null;
      }
      print(recordList);
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getTimeSlots(): " + e.toString());
    }
  }

  Future<dynamic> sendSEODeeplinkData() async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        "utm_source": global.utmSource,
        "utm_campaign": global.utmCampaign,
        "utm_network": global.utmNetwork,
        "utm_medium": global.utmMedium,
        "utm_keyword": global.utmKeyword,
        "placement": global.placement,
        "user_id": global.currentUser != null && global.currentUser.id != null
            ? global.currentUser.id
            : "",
        'device_id': "${global.globalDeviceId}",
        "platform": Platform.isIOS ? "IOS" : "ANDROID",
        "fcm_token": global.appDeviceId,
      });
      print("########################################################");
      print(formData.fields);
      print('${global.baseUrl}seoAnalyticsData');
      response = await dio.post(
        '${global.baseUrl}seoAnalyticsData',
        data: formData,
      );
      print(response);
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = response.data;
      } else {
        recordList = null;
      }
      print(recordList);
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getTimeSlots(): " + e.toString());
    }
  }

  Future<dynamic> corporateContactUS(String firstName, String lastName,
      String emailID, String mobileNo, String message) async {
    print('Nikhil in getRewardWalletTransactions---------------------');
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        "firstname": firstName,
        "lastname": lastName,
        "email": emailID,
        "mobileno": mobileNo,
        "message": message
      });
      print("########################################################");
      print('Nikhil----------------${global.baseUrl}contactus_submit ');
      print(formData.fields);
      response = await dio.post('${global.baseUrl}contactus_submit',
          data: formData,
          options: Options(
            headers: await global.getApiHeaders(false),
            validateStatus: (statusCode) {
              if (statusCode == null) {
                return false;
              }
              if (statusCode == 422) {
                // your http status code
                return true;
              } else {
                return statusCode >= 200 && statusCode < 300;
              }
            },
          ));
      print("corporateContactUS response${response}");
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = response.data;

        print("corporateContactUS parsed${recordList}");
      } else {
        recordList = null;
      }
      print(recordList);
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception -APIHELPER  corporateContactUS()b: " + e.toString());
    }
  }

  // ////////// new added api for add user when guest
  Future<dynamic> SaveGuestUserAddress(
      {String? contact_name,
      String? contact_phone,
      String? contact_email,
      String? receiver_name,
      String? receiver_phone,
      String? city,
      String? delivery_date,
      String? time_slot}) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        "contact_name": contact_name,
        "contact_phone": contact_phone,
        "contact_email": contact_email,
        "receiver_name": receiver_name,
        "receiver_phone": receiver_phone,
        "city": city,
        'device_id': "${global.globalDeviceId}",
        "delivery_date": delivery_date,
        "time_slot": time_slot,
      });
      print("########################################################");
      print(formData.fields);
      print('${global.baseUrl}saveuseraddress');
      response = await dio.post(
        '${global.baseUrl}saveuseraddress',
        data: formData,
      );
      print(response.data);
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = response.data;
      } else {
        recordList = null;
      }
      print(recordList);
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getTimeSlots(): " + e.toString());
    }
  }

  Future<dynamic> UpdateDateTime({
    String? deliveryDate,
    String? deliveryTime,
    int? userId,
  }) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        "user_id": global.currentUser.id != null ? global.currentUser.id : "",
        "delivery_date": deliveryDate,
        "time_slot": deliveryTime,
      });
      print("###########################################################");
      print(formData.fields);
      print('${global.baseUrl}updateorderdates');
      print("###########################################################");

      response = await dio.post(
        '${global.baseUrl}updateorderdates',
        data: formData,
      );
      print("G1---updateorderdates---->${response.data}");
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = response.data;
      } else {
        recordList = null;
      }
      print(recordList);
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getTimeSlots(): " + e.toString());
    }
  }

  Future<dynamic> UpdateUserPhoneName({
    String? user_phone,
    String? name,
  }) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        "user_id": global.currentUser.id != null ? global.currentUser.id : "",
        "user_phone": user_phone,
        "name": name,
      });
      print("###########################################################");
      print(formData.fields);
      print('${global.baseUrl}updateuser');
      print("###########################################################");

      response = await dio.post(
        '${global.baseUrl}updateuser',
        data: formData,
      );
      print(response.data);
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == 1) {
        recordList = response.data;
      } else {
        recordList = null;
      }
      print(recordList);
      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception - getTimeSlots(): " + e.toString());
    }
  }

  Future<dynamic> getAddonsList() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      print("${global.globalDeviceId}");
      Response response;
      var dio = Dio();
      var formData = global.currentUser.id != null
          ? {
              'user_id': global.currentUser.id.toString(),
              'user_type': "user",
              // "platform": Platform.isIOS ? "IOS" : "ANDROID",
              "platform": "app",
              "limit": 5
            }
          : {
              'user_type': "guest",
              'device_id': "${global.globalDeviceId}",
              // "platform": Platform.isIOS ? "IOS" : "ANDROID",
              "platform": "app",
              "limit": 20
            };
      print(
          "#################################################################");
      print('${global.nodeBaseUrl}addon_products');
      print(formData);

      response = await dio.post('${global.nodeBaseUrl}addon_products',
          data: formData,
          options: Options(
            headers: await global.getApiHeaders(false),
            validateStatus: (status) {
              return status != null &&
                  status < 500; // Allow 400-level responses
            },
          ));

      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == '1') {
        recordList = List<Product>.from(
            response.data["data"].map((x) => Product.fromJson(x)));
      } else {
        recordList = null;
      }

      return getDioResult(response, recordList);
    } catch (e) {
      print("Exception API HELPER- addons(): " + e.toString());
    }
  }
}

// API CALLS ABHISHEK >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

// Future<dynamic> oneAPI(
//       String userPhone, String countryCode, int activateAccount) async {
//     PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     String version = packageInfo.version;

//     try {
//       Response response;
//       var dio = Dio();
//       var formData = FormData.fromMap({
//         'user_phone': userPhone,
//         'country_code': countryCode,
//         'dialcode': countryCode,
//         'reactivate': activateAccount,
//         'device_id': "${global.globalDeviceId}",
//         "platform": Platform.isIOS ? "IOS" : "ANDROID",
//         "app_cur_version": version
//       });
//       print("###########################################");
//       print('${global.baseUrl}login');
//       print(formData.fields);
//       response = await dio.post('${global.baseUrl}login',
//           queryParameters: {
//             'lang': global.languageCode,
//           },
//           data: formData,
//           options: Options(
//             headers: await global.getApiHeaders(false),
//           ));

//       dynamic recordList;
//       print(response);
//       if (response.statusCode == 200 && response.data['status'] == '1') {
//         recordList = CurrentUser.fromJson(response.data['data']);

//         print(recordList.toString());
//       } else if (response.statusCode == 200 && response.data['status'] == '3') {
//         recordList = response.data;
//       } else {
//         recordList = null;
//       }
//       return getDioResult(response, recordList);
//     } catch (e) {
//       print("Exception - login(): " + e.toString());
//     }
//   }

class EmailExist {
  String? id;
  bool? isEMailExist;
  EmailExist({this.id, this.isEMailExist});
}
