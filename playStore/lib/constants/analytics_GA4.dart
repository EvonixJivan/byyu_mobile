import 'dart:io';

import 'package:byyu/models/cartModel.dart';
import 'package:byyu/models/categoryProductModel.dart';
import 'package:byyu/models/orderDetailsModel.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:byyu/controllers/cart_controller.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;

class FirebaseAnalyticsGA4 {
  static final facebookAppEvents = FacebookAppEvents();
  void callAnalyticsAddCart(
      int itemID,
      String itemName,
      String itemCategory,
      int itemVariant,
      String itemBrand,
      double price,
      int qty,
      double mrp,
      bool isAddCart,
      bool isAddtoWishList) async {
    String currency = 'AED';

    final addItemQty = AnalyticsEventItem(
      itemId: itemID.toString(),
      itemName: itemName,
      itemCategory: itemCategory,
      itemVariant: itemVariant.toString(),
      itemBrand: itemBrand,
      price: price,
      quantity: qty,
    );

    if (isAddCart) {
      await FirebaseAnalytics.instance.logAddToCart(
        currency: currency,
        value: mrp,
        items: [addItemQty],
      );
      facebookAppEvents.logAddToCart(
          id: itemID.toString(),
          type: itemName,
          currency: global.appInfo.currencySign!,
          price: price);
    } else {
      await FirebaseAnalytics.instance.logRemoveFromCart(
        currency: currency,
        value: mrp,
        items: [addItemQty],
      );
    }
    if (isAddtoWishList) {
      facebookAppEvents.logAddToWishlist(
          id: itemID.toString(),
          type: itemName,
          currency: global.appInfo.currencySign!,
          price: price);
      await FirebaseAnalytics.instance.logAddToWishlist(
        currency: currency,
        value: mrp,
        items: [addItemQty],
      );
    }
  }

  void callAnalyticsCheckOut(
      CartController cartController,
      int isAddCart,
      String coupon,
      double couponDiscount,
      String address,
      String orderID) async {
    String currency = 'AED';
    dynamic addItemQty;
    double ntotal = 0;
    if (cartController.cartItemsList.cartData!.cartProductdata!.length > 0) {
      for (CartProduct product
          in cartController.cartItemsList.cartData!.cartProductdata!) {
        var price = product.price;
        var days = product.repeatOrders!.split(',');

        var delivery = global.total_delivery_count;
        var pTotal = ((price! * days.length) * delivery);
        ntotal = ntotal + pTotal;
        addItemQty = AnalyticsEventItem(
            itemId: product.productId.toString(),
            itemName: product.productName,
            itemCategory: '',
            itemVariant: product.varientId.toString(),
            itemBrand: '',
            price: product.price,
            quantity: product.quantity,
            coupon: coupon);
      }
    }
    var total = ntotal - couponDiscount;

    if (isAddCart == 1) {
      await FirebaseAnalytics.instance.logBeginCheckout(
        currency: currency,
        value: total,
        coupon: coupon,
        items: [addItemQty],
      );
    } else {
      await FirebaseAnalytics.instance.logAddShippingInfo(
        currency: currency,
        value: total,
        coupon: coupon,
        shippingTier: address,
        items: [addItemQty],
      );
      await FirebaseAnalytics.instance.logAddPaymentInfo(
        currency: currency,
        value: total,
        coupon: coupon,
        paymentType: "Card",
        items: [addItemQty],
      );

      await FirebaseAnalytics.instance.logPurchase(
        transactionId: orderID,
        affiliation: Platform.isIOS ? 'IOS' : "Android",
        currency: currency,
        value: total,
        shipping: 0.00,
        tax: 0.0,
        coupon: coupon,
        items: [addItemQty],
      );
      facebookAppEvents.logPurchase(amount: total, currency: currency);
    }
  }


void callAnalyticsCheckOutNew(
      List<OrderDetails> products,
      int isAddCart,
      String coupon,
      double couponDiscount,
      String address,
      String orderID) async {
    String currency = 'AED';
    dynamic addItemQty;
    double ntotal = 0;
    if (products.length > 0) {
      for (OrderDetails product
          in products) {
        var price = product.totalPrice;

        var delivery = global.total_delivery_count;
        addItemQty = AnalyticsEventItem(
            itemId: product.product!.productId.toString(),
            itemName: product.product!.productName,
            itemCategory: '',
            itemVariant: product.product!.varientId.toString(),
            itemBrand: '',
            price: product.product!.price,
            quantity: product.product!.quantity,
            coupon: coupon);
      }
    }
    var total = ntotal - couponDiscount;

    if (isAddCart == 1) {
      await FirebaseAnalytics.instance.logBeginCheckout(
        currency: currency,
        value: total,
        coupon: coupon,
        items: [addItemQty],
      );
    } else {
      await FirebaseAnalytics.instance.logAddShippingInfo(
        currency: currency,
        value: total,
        coupon: coupon,
        shippingTier: address,
        items: [addItemQty],
      );
      await FirebaseAnalytics.instance.logAddPaymentInfo(
        currency: currency,
        value: total,
        coupon: coupon,
        paymentType: "Card",
        items: [addItemQty],
      );

      await FirebaseAnalytics.instance.logPurchase(
        transactionId: orderID,
        affiliation: Platform.isIOS ? 'IOS' : "Android",
        currency: currency,
        value: total,
        shipping: 0.00,
        tax: 0.0,
        coupon: coupon,
        items: [addItemQty],
      );
      facebookAppEvents.logPurchase(amount: total, currency: currency);
    }
  }

  void callAnalyticsProductDetail(
    int itemID,
    String itemName,
    String itemCategory,
    int itemVariant,
    String itemBrand,
    double price,
    double mrp,
    int qty,
  ) async {
    String currency = 'AED';
    final addProductDetail = AnalyticsEventItem(
      itemId: itemID.toString(),
      itemName: itemName,
      itemCategory: itemCategory,
      itemVariant: itemVariant.toString(),
      itemBrand: itemBrand,
      price: price,
    );
    await FirebaseAnalytics.instance.logViewItem(
      currency: currency,
      value: mrp,
      items: [addProductDetail],
    );
  }

  Future<void> callAnalyticsRegisterEvents(
    String eventName,
    String name,
    String email,
    String phone,
    String city,
  ) async {
    await FirebaseAnalytics.instance.logEvent(
      name: eventName,
      parameters: <String, Object>{
        'name': name,
        'email': email,
        'phone': phone,
        'city': city,
      },
    );
  }

  Future<void> callSearchEventEvent(
    String searchTerm,
  ) async {
    await FirebaseAnalytics.instance.logSearch(searchTerm: searchTerm);
    final Map<String, dynamic> someMap = {
      "Search": searchTerm,
    };
    facebookAppEvents.logEvent(
        name: "Search", parameters: someMap, valueToSum: 0.0);
  }

   Future<void> callPaymentInitiatedEvent(
    String searchTerm,
  ) async {
    await FirebaseAnalytics.instance.logSearch(searchTerm: searchTerm);
    final Map<String, dynamic> someMap = {
      "Search": searchTerm,
    };
    facebookAppEvents.logEvent(
        name: "Search", parameters: someMap, valueToSum: 0.0);
  }
}
