import 'dart:math';

import 'package:byyu/constants/analytics_GA4.dart';
import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/controllers/cart_controller.dart';
import 'package:byyu/models/businessLayer/apiHelper.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/models/cartModel.dart';
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
  final CartController? cartController ;
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
  late Cart cartItemsList = new Cart();
  APIHelper apiHelper = new APIHelper();
  bool? isDataLoaded = false;
  final dynamic analytics;
  final dynamic observer;
  final Function? callbackHomescreenSetState;
  CartController? cartController ;

     Order? orderDetails;
     String? repeatOrders, selectedAddress;

     final List<Map<String, dynamic>> addOns = [
    {
      'image': 'assets/images/iv_cakes_card.png',
      'price': 'AED 150',
    },
    {
      'image': 'assets/images/iv_cakes_card.png',
      'price': 'AED 180',
    },
  ];


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
    getCartList();
    
    super.initState();
  }

  getCartList() async {
    global.cartItemsPresent = false;
    global.globalHomeLoading = false;
    try {
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
      
      isDataLoaded = true;
      if (fromNavigationBar!) {
        callbackHomescreenSetState!();
      }
      setState(() {});
      
    } catch (e) {
      global.globalHomeLoading = true;
      global.cartCount = 0;
      print(
          "Exception -  cart_controller.dart - getCartList():" + e.toString());
    }
  }

  showBottomSheet() {
    return isDataLoaded == true
        ? Container(
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 15),
          //  Header Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
                          fontWeight: FontWeight.w300,
                          color: ColorConstants.newTextHeadingFooter),
                    ),
                    Text(
                      " AED 1500",
                      style: TextStyle(
                          fontFamily: global.fontOufitMedium,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: ColorConstants.pureBlack),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close,
                    color: ColorConstants.pureBlack,
                    size: 26,
                  ),
                ),
              ],
            ),
          ),

          // Divider

          const SizedBox(height: 10),

          //  Add-Ons Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Add-Ons",
                style: TextStyle(
                    fontFamily: global.fontOufitMedium,
                    fontSize: 24,
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
          const SizedBox(height: 35),

          //  Add-Ons List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: addOns.map((item) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Column(
                      children: [
                        // 🟠 Image container with ClipRRect
                        Container(
                          height: 150,
                          width: 120,
                          
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(100),
                              topRight: Radius.circular(100),
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(0),
                            ),
                            child: Image.asset(
                              item['image'], // local asset path
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        const SizedBox(height: 5),

                        //  Add To Cart button
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
                            onPressed: () {

                            },
                            child: Text(
                              "Add To Cart",
                              style: TextStyle(
                                fontFamily: global.fontOufitMedium,
                                color: ColorConstants.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 5),

                        // 💰 Price text
                        Text(
                          item['price'],
                          style: TextStyle(
                            fontFamily: global.fontOufitMedium,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: ColorConstants.newAppColor,
                          ),
                        ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const Spacer(),

          //  Bottom Buttons
          
       
        Container(
                  margin: EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => AllCategoriesScreen(
                                              a: widget.analytics,
                                              o: widget.observer,
                                            )),
                                  );
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 10,right: 10,bottom: 12,top: 12),
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
                                SizedBox(
                                  width: 10,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    // _productDetail.productDetail.cartQty != 0
                                    //     ? "GO TO CART"
                                    // :
                                    "Continue Shopping",
                                    style: TextStyle(
                                        fontFamily: fontMontserratMedium,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: ColorConstants.newTextHeadingFooter,
                                        letterSpacing: 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                    InkWell(
                      onTap: () {
                        print("on click called");
                         Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>   PaymentGatewayScreenCopy(

                                      a: widget.analytics,
                                      o: widget.observer,
                                      screenId: 1,
                                      totalAmount: 0,
                                      cartController: cartController,
                                      order: new Order(),
                                      repeat_orders: '',
                                      total_delivery_count: global.total_delivery_count,
                                      selectedDate: DateTime.now(),
                                      selectedTime:
                                          "11:00 am - 12:00 pm", //selectedTimeSlot.timeslot,
                                      is_subscription: null,
                                      selectedAddressID:0,
                                      selectedAddress: selectedAddress,
                                      cartPrice: 0,
                                    )));
                        
                       
                      },
                      child: Container(
                          padding: EdgeInsets.only(left: 10,right: 10,bottom: 12,top: 12),
                          decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: ColorConstants.appColor,
                                      border: Border.all(
                                          width: 0.5,
                                          color: ColorConstants.appColor)),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/iv_cart_check_white.png",
                                fit: BoxFit.contain,
                                height: 18,
                                alignment: Alignment.center,
                                color: ColorConstants.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  // _productDetail.productDetail.cartQty != 0
                                  //     ? "GO TO CART"
                                  // :
                                  "Checkout",
                                  style: TextStyle(
                                      fontFamily: fontMontserratMedium,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: ColorConstants.white,
                                      letterSpacing: 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                    )
                 
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

  void addToCartRO1(
      CartProduct product, int cartQty, bool isDel, String repeat_orders,
      {Varient? varient, int? varientId, int? callId}) async {
    showOnlyLoaderDialog();
    print("Nikhil Add To Cart RO");
    try {
      APIHelper apiHelper = new APIHelper();
      await apiHelper
          .addToCart(
              qty: cartQty,
              varientId: product.varientId,
              special: 0,
              deliveryDate: product.delivery_date,
              deliveryTime: product.delivery_time,
              repeat_orders: "0")
          .then((result) {
        if (result != null) {
          FirebaseAnalyticsGA4().callAnalyticsAddCart(
              product.productId!,
              product.productName!,
              "",
              product.varientId!,
              '',
              product.price!,
              cartQty,
              product.mrp!,
              cartQty == 0 ? false : true,
              false);

          getCartList();

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
