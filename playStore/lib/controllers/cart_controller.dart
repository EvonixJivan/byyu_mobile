import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:byyu/constants/analytics_GA4.dart';
import 'package:byyu/models/addtocartmessagestatus.dart';
import 'package:byyu/models/businessLayer/apiHelper.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/cartModel.dart';
import 'package:byyu/models/categoryProductModel.dart';
import 'package:byyu/models/varientModel.dart';

class CartController extends GetxController {
  late Cart cartItemsList=new Cart();
  late List<FrequentlyboughttogetherProduct> simillarProductsList;
  APIHelper apiHelper = new APIHelper();
  var isDataLoaded = false.obs;
  var isReorderDataLoaded = false.obs;
  var isReOrderSuccess = false.obs;

  Future<ATCMS?> addToCart(Product product, int cartQty, bool isDel,
      String repeat_orders, int isAddCart,
      {Varient? varient, int? varientId, int? callId}) async {
    try {
      bool isSuccess = false;
      String message = '--';
      int vId;
      if (varient != null) {
        vId = varient.varientId!;
      } else {
        vId = varientId!;
      }

      await apiHelper
          .addToCart(
              qty: cartQty,
              varientId: vId,
              special: 0,
              repeat_orders: repeat_orders,
              productData: product,
              deliveryDate: DateTime.now()
                  .toString()
                  .substring(0, DateTime.now().toString().indexOf(" ")),
              deliveryTime: DateTime.now()
                  .toString()
                  .substring(DateTime.now().toString().indexOf(" ") + 1),
              userMessage: "")
          .then((result) {
        if (result != null) {
          getCartList();
          if (result.status == '1') {
            message = '${result.message}';
            cartItemsList = result.data;
            FirebaseAnalyticsGA4().callAnalyticsAddCart(
                product.productId!,
                product.productName!,
                '',
                product.varientId!,
                '',
                product.price!,
                cartQty,
                product.mrp!,
                cartQty == 0 ? false : true,
                false);
            isSuccess = true;
            if (callId == 0) {
              if (isDel) {
                if (product.cartQty != null && product.cartQty == 1) {
                  product.cartQty = 0;

                  global.cartCount -= 1;
                } else {
                  product.cartQty = (product.cartQty! - 1);
                }
              } else {
                if (product.cartQty == null || product.cartQty == 0) {
                  product.cartQty = 1;

                  global.cartCount += 1;
                } else {
                  product.cartQty = (product.cartQty! + 1);
                }
              }
            } else {
              if (product.varientId == varient!.varientId) {
                if (isDel) {
                  if (product.cartQty != null && product.cartQty == 1) {
                    product.cartQty = 0;
                    varient.cartQty = 0;
                    global.cartCount -= 1;
                  } else {
                    product.cartQty = (product.cartQty! - 1);

                    varient.cartQty = (varient.cartQty! - 1);
                  }
                } else {
                  if (product.cartQty == null || product.cartQty == 0) {
                    product.cartQty = 1;
                    varient.cartQty = 1;
                    global.cartCount += 1;
                  } else {
                    product.cartQty = 1;
                    varient.cartQty = (varient.cartQty! + 1);
                  }
                }
              } else {
                if (isDel) {
                  if (varient.cartQty != null && varient.cartQty == 1) {
                    varient.cartQty = 0;
                    global.cartCount -= 1;
                  } else {
                    varient.cartQty = (varient.cartQty! - 1);
                  }
                } else {
                  if (varient.cartQty == null || varient.cartQty == 0) {
                    varient.cartQty = 1;
                    global.cartCount += 1;
                  } else {
                    varient.cartQty = (varient.cartQty! + 1);
                  }
                }
              }
            }
          } else {
            message = '${result.message}';
          }
        } else {
          isSuccess = false;

          message = 'Something went wrong please try after some time';
        }
      });

      update();
      return ATCMS(isSuccess: isSuccess, message: message);
    } catch (e) {
      print("Exception -  cart_controller.dart - addToCart():a" + e.toString());
      return null;
    }
  }

  getCartList() async {
    global.cartItemsPresent = false;
    global.globalHomeLoading = false;
    try {
      if(cartItemsList!=null && cartItemsList.cartData!=null && cartItemsList.cartData!.cartProductdata!=null && cartItemsList.cartData!.cartProductdata!.length>0){
        isDataLoaded(true);
      }else{
        isDataLoaded(false);
      }
      // isDataLoaded(false);

      // cartItemsList = new Cart();

      await apiHelper.showCart().then((result) async {
        global.globalHomeLoading = true;
        if (result != null) {
          if (result.status == "1") {
            cartItemsList = result.data;

            if (cartItemsList.cartData != null &&
                cartItemsList.cartData!.cartProductdata != null &&
                cartItemsList.cartData!.cartProductdata!.length > 0) {
              global.cartCount =
                  cartItemsList.cartData!.cartProductdata!.length;
              global.cartItemsPresent = true;
              global.globalHomeLoading = true;
            } else {
              global.cartItemsPresent = false;
              global.globalHomeLoading = true;
              global.cartCount = 0;
              
            }
            print("NIKHIL cart qty----${cartItemsList}-----------------");
            global.globalHomeLoading = true;
          } else {
            global.cartItemsPresent = false;
            global.globalHomeLoading = true;
            print(
                "NIKHIL else part-----items present-------${global.cartItemsPresent}-----");
            global.cartCount = 0;
          }
        }
      });
      isDataLoaded(true);
      update();
    } catch (e) {
      global.globalHomeLoading = true;
      global.cartCount = 0;
      print(
          "Exception -  cart_controller.dart - getCartList():" + e.toString());
    }
  }

  getCartListwithContext(context) async {
    showOnlyLoaderDialog(context);
    global.cartItemsPresent = false;
    global.globalHomeLoading = false;
    try {
      isDataLoaded(false);

      cartItemsList = new Cart();

      await apiHelper.showCart().then((result) async {
        global.globalHomeLoading = true;
        if (result != null) {
          if (result.status == "1") {
            cartItemsList = result.data;

            if (cartItemsList.cartData != null &&
                cartItemsList.cartData!.cartProductdata != null &&
                cartItemsList.cartData!.cartProductdata!.length > 0) {
              global.cartCount =
                  cartItemsList.cartData!.cartProductdata!.length;
              global.cartItemsPresent = true;
              global.globalHomeLoading = true;
            } else {
              global.cartItemsPresent = false;
              global.globalHomeLoading = true;
              global.cartCount = 0;
              
            }
            print("NIKHIL cart qty----${cartItemsList}-----------------");
            global.globalHomeLoading = true;
            hideloader(context);
          } else {
            global.cartItemsPresent = false;
            global.globalHomeLoading = true;
            print(
                "NIKHIL else part-----items present1-------${global.cartItemsPresent}-----");
            global.cartCount = 0;
          }
        }
      });
      isDataLoaded(true);
      update();
    } catch (e) {
      global.globalHomeLoading = true;
      global.cartCount = 0;
      print(
          "Exception -  cart_controller.dart - getCartList():" + e.toString());
    }
  }

  showOnlyLoaderDialog(BuildContext context1) {
    return showDialog(
      context: context1,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Center(
              child: new CircularProgressIndicator(
            strokeWidth: 1,
          )),
        );
      },
    );
  }

  void hideloader(BuildContext context1) {
    Navigator.pop(context1);
  }

  void addMultipleToCart(List<Map<String, dynamic>> sendArray) async {
    try {
      bool isSuccess = false;
      String message = '--';
      int vId;

      APIHelper apiHelper = new APIHelper();

      await apiHelper.addToMultipleCart(sendArray).then((result) {
        if (result != null) {
          getCartList();
        } else {
          isSuccess = false;
          message = 'Something went wrong please try after some time';
        }
      });
    } catch (e) {
      print("Exception -  cart_controller.dart - addToCart():b" + e.toString());
      return null;
    }
  }
}
