import 'dart:math';

import 'package:byyu/constants/analytics_GA4.dart';
import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/controllers/cart_controller.dart';
import 'package:byyu/models/businessLayer/apiHelper.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/models/cartModel.dart';
import 'package:byyu/models/categoryProductModel.dart';
import 'package:byyu/models/orderModel.dart';
import 'package:byyu/models/varientModel.dart';
import 'package:byyu/screens/payment_view/payment_screen%20copy.dart';
import 'package:byyu/screens/payment_view/payment_screen.dart';
import 'package:byyu/screens/product/all_categories_screen.dart';
import 'package:byyu/screens/product/product_description_screen.dart';
import 'package:byyu/widgets/cart_menu_old.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/couponsModel.dart';

import 'package:intl/intl.dart';

class AddOnBottomSheet extends StatefulWidget {
  final bool? fromNavigationBar;
  final dynamic analytics;
  final dynamic observer;
  final Function? callbackHomescreenSetState;
  final CartController? cartController;
  AddOnBottomSheet(
      {this.fromNavigationBar,
      this.analytics,
      this.observer,
      this.cartController,
      this.callbackHomescreenSetState})
      : super();

  @override
  _AddOnBottomSheetState createState() => _AddOnBottomSheetState(
      fromNavigationBar: fromNavigationBar,
      analytics: analytics,
      observer: observer,
      cartController: cartController,
      callbackHomescreenSetState: callbackHomescreenSetState);
}

class _AddOnBottomSheetState extends State<AddOnBottomSheet> {
  bool? fromNavigationBar;
  APIHelper apiHelper = new APIHelper();
  bool? isDataLoaded = false;
  final dynamic analytics;
  final dynamic observer;
  final Function? callbackHomescreenSetState;
  CartController? cartController;
  List<Product> _addOnsproductsList = [];

  Order? orderDetails;
  String? repeatOrders, selectedAddress;

  int? _qty;

  _AddOnBottomSheetState(
      {this.analytics,
      this.observer,
      this.fromNavigationBar,
      this.cartController,
      this.callbackHomescreenSetState});

  @override
  Widget build(BuildContext context) {
    return showBottomSheet();
  }

  @override
  void initState() {
    getAddOnsList();

    super.initState();
  }

  getAddOnsList() async {
    global.cartItemsPresent = false;
    global.globalHomeLoading = false;
    try {
      // isDataLoaded(false);

      // cartItemsList = new Cart();

      await apiHelper.getAddonsList().then((result) async {
        print(result);
        if (result != null) {
          if (result.status == "1") {
            _addOnsproductsList = result.data;
          }
        }
      });

      isDataLoaded = true;

      setState(() {});
    } catch (e) {
      global.globalHomeLoading = true;
      global.cartCount = 0;
      print("Exception -  addons.dart - getAddOnsList():" + e.toString());
    }
  }

  showBottomSheet() {
    return isDataLoaded == true
        ? Container(
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 1),
                //  Header Row
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Cart Subtotal: ",
                            style: TextStyle(
                                fontFamily: global.fontOufitMedium,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: ColorConstants.newTextHeadingFooter),
                          ),
                          Text(
                            "AED " +
                                (cartController!.cartItemsList.cartData!
                                            .totalPrice! -
                                        cartController!.cartItemsList.cartData!
                                            .deliveryCharge!)
                                    .toStringAsFixed(2),
                            style: TextStyle(
                                fontFamily: global.fontOufitMedium,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: ColorConstants.newTextHeadingFooter),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.close,
                          color: ColorConstants.appColor,
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                ),

                // Divider

                //  Add-Ons Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Add-Ons",
                      style: TextStyle(
                          fontFamily: global.fontRailwayRegular,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.newTextHeadingFooter),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  height: 1,
                  color: Colors.grey.shade300,
                ),
                // const SizedBox(height: 35),

                //  Add-Ons List

                Expanded(
                  child: GridView.builder(
                      // padding: const EdgeInsets.all(16),
                      itemCount: _addOnsproductsList.length,
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                        childAspectRatio: 0.76,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Column(
                            children: [
                              // 🟠 Image container with ClipRRect
                              Padding(padding: EdgeInsets.only(top: 10)),
                              Container(
                                height: 100,
                                width: 100,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(100),
                                    topRight: Radius.circular(100),
                                    bottomLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(0),
                                  ),
                                  child: Image.network(
                                    imageBaseUrl +
                                        _addOnsproductsList[index]
                                            .productImage! +
                                        "?width=500&height=500",
                                    cacheWidth: 360,
                                    fit: BoxFit.cover,
                                    width:
                                        MediaQuery.of(context).size.width / 1.5,
                                    height: MediaQuery.of(context).size.height,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 5),

                              //  ADD TO CART button
                              SizedBox(
                                height: 24,
                                width: 80,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorConstants.appColor,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 0, // no shadow
                                    minimumSize: const Size.fromHeight(24),
                                  ),
                                  // onPressed: () {
                                  //   // if (_addOnsproductsList[index].cartQty !=
                                  //   //     0) {
                                  //   //   print("helllooo>>>>>>>>>");
                                  //   //   addToCartRO1(
                                  //   //       _addOnsproductsList[index].varientId!,
                                  //   //       1);
                                  //   // }
                                  //   if (_addOnsproductsList[index].cartQty !=
                                  //       0) {
                                  //     addToCartRO1(
                                  //         _addOnsproductsList[index].varientId!,
                                  //         _addOnsproductsList[index].cartQty! +
                                  //             1);
                                  //   } else {
                                  //     addToCartRO1(
                                  //         _addOnsproductsList[index].varientId!,
                                  //         1);
                                  //   }
                                  // },

                                  onPressed: () {
                                    if (_addOnsproductsList[index].cartQty !=
                                        0) {
                                      addToCartRO1(
                                        _addOnsproductsList[index].varientId!,
                                        _addOnsproductsList[index].cartQty! + 1,
                                      );

                                      Fluttertoast.showToast(
                                        msg: "Product added",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                    } else {
                                      addToCartRO1(
                                        _addOnsproductsList[index].varientId!,
                                        1,
                                      );

                                      Fluttertoast.showToast(
                                        msg: "Product added",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                    }
                                  },

                                  child: Text(
                                    _addOnsproductsList[index].cartQty! > 0
                                        ? "IN CART"
                                        : "ADD",
                                    style: TextStyle(
                                      fontFamily: global.fontOufitMedium,
                                      color: ColorConstants.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 5),

                              // 💰 Price text
                              Text(
                                "AED " +
                                    _addOnsproductsList[index]
                                        .price!
                                        .toStringAsFixed(2),
                                style: TextStyle(
                                  fontFamily: global.fontOufitMedium,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstants.newTextHeadingFooter,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ),

                // const Spacer(),

                //  Bottom Buttons

                Container(
                  margin:
                      EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 1),
                  child: Row(
                    children: [
                      // CONTINUE SHOPPING BUTTON
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AllCategoriesScreen(
                                  a: widget.analytics,
                                  o: widget.observer,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            margin: const EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: ColorConstants.colorHomePageSectiondim,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/iv_con_shopp.png",
                                  fit: BoxFit.contain,
                                  height: 18,
                                  alignment: Alignment.center,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "CONTINUE SHOPPING",
                                  style: TextStyle(
                                    fontFamily: fontMontserratMedium,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: ColorConstants.newTextHeadingFooter,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      // CHECKOUT BUTTON
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentGatewayScreenCopy(
                                  a: widget.analytics,
                                  o: widget.observer,
                                  screenId: 1,
                                  totalAmount: 0,
                                  cartController: cartController,
                                  order: Order(),
                                  repeat_orders: '',
                                  total_delivery_count:
                                      global.total_delivery_count,
                                  selectedDate: DateTime.now(),
                                  selectedTime: "11:00 am - 12:00 pm",
                                  is_subscription: null,
                                  selectedAddressID: 0,
                                  selectedAddress: selectedAddress,
                                  cartPrice: 0,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            margin: const EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: ColorConstants.appColor,
                              border: Border.all(
                                  width: 0.5, color: ColorConstants.appColor),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/iv_cart_check_white.png",
                                  fit: BoxFit.contain,
                                  height: 18,
                                  color: ColorConstants.white,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "CHECKOUT",
                                  style: TextStyle(
                                    fontFamily: fontMontserratMedium,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: ColorConstants.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        : Container(
            height: MediaQuery.of(context).size.height / 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              color: ColorConstants.colorPageBackground,
            ),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }

  void addToCartRO1(int varientId, int cartQty) async {
    showOnlyLoaderDialog();
    print("Nikhil ADD TO CART RO");
    try {
      APIHelper apiHelper = new APIHelper();
      await apiHelper
          .addToCart(
              qty: cartQty,
              varientId: varientId,
              special: 0,
              deliveryDate: "",
              deliveryTime: "",
              repeat_orders: "0")
          .then((result) async {
        if (result != null) {
          await cartController!.getCartList();

          await getAddOnsList();

          setState(() {});
          hideLoader();
        } else {
          Fluttertoast.showToast(
              msg: 'Something went wrong please try after some time');
        }
      });
    } catch (e) {
      print("Exception - cart_controller.dart - addToCart(): $e");
      return null;
    }
  }

  showOnlyLoaderDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Center(
            child: CircularProgressIndicator(strokeWidth: 1),
          ),
        );
      },
    );
  }

  void hideLoader() {
    Navigator.pop(context);
  }
}
