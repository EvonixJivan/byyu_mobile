import 'dart:math';

import 'package:byyu/constants/analytics_GA4.dart';
import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/apiHelper.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/models/cartModel.dart';
import 'package:byyu/models/varientModel.dart';
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

class CartBottomSheet extends StatefulWidget {
 
  final bool? fromNavigationBar;
  final dynamic analytics;
  final dynamic observer;
  final Function? callbackHomescreenSetState;
  CartBottomSheet({this.fromNavigationBar, this.analytics, 
  this.observer, 
  this.callbackHomescreenSetState}) : super();

  @override
  _CartBottomSheetState createState() => _CartBottomSheetState(
       fromNavigationBar: fromNavigationBar,
        analytics: analytics,observer:  observer,
       callbackHomescreenSetState: callbackHomescreenSetState
       );
}

class _CartBottomSheetState extends State<CartBottomSheet> {

  bool? fromNavigationBar;
  late Cart cartItemsList=new Cart();
  APIHelper apiHelper = new APIHelper();
  bool? isDataLoaded = false;
  final dynamic analytics;
  final dynamic observer;
    final Function? callbackHomescreenSetState;


  _CartBottomSheetState({this.analytics, this.observer, this.fromNavigationBar,this.callbackHomescreenSetState});

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
      isDataLoaded=true;
      callbackHomescreenSetState!();
      setState(() {});
      
    } catch (e) {
      global.globalHomeLoading = true;
      global.cartCount = 0;
      print(
          "Exception -  cart_controller.dart - getCartList():" + e.toString());
    }
  }


  showBottomSheet() {
    return isDataLoaded == true ? Container(
      height: MediaQuery.of(context).size.height/2,
      
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: ColorConstants.colorPageBackground,
        
        
      ),
      child: Column(
        children: [
          Row(
            children: [
              
              Expanded(
                child: Center(
                  child: Text(
                    "My Cart",
                    style: const TextStyle(
                      fontFamily: global.fontRalewayMedium,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: ColorConstants.newTextHeadingFooter,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.black54),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (fromNavigationBar == true) {
                    widget.callbackHomescreenSetState!();
                  }
                },
              ),
              
            ],
          ),
          ListView.builder(shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: cartItemsList.cartData!.cartProductdata!.length,
          itemBuilder: (context, index)  {
            return InkWell(
            onTap: () {
              if ( cartItemsList.cartData!
                      .cartProductdata![index].productId !=
                  null) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProductDescriptionScreen(
                          a: analytics,
                          o: observer,
                          productId: cartItemsList.cartData!
                              .cartProductdata![index].productId,
                          isHomeSelected: "",
                        )));
              }
            },
            // 🌸 NEW UI BELOW 🌸
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: ColorConstants.colorPageBackground,
              elevation: 0.5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Product Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        imageUrl: global.imageBaseUrl +
                             cartItemsList.cartData!
                                .cartProductdata![index]!.productImage! +
                            "?width=300&height=300",
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(strokeWidth: 1.0),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          global.noImage,
                          fit: BoxFit.cover,
                          width: 60,
                          height: 60,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
          
                    // Product Info + Quantity + Price
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Name + Remove (X)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  cartItemsList.cartData!
                                      .cartProductdata![index]!.productName!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: global.fontRalewayMedium,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        ColorConstants.newTextHeadingFooter,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  addToCartRO1(
                                     cartItemsList.cartData!
                                        .cartProductdata![index]!,
                                    0,
                                    true,
                                    "0",
                                  );
                                },
                                // child: const Icon(
                                //   Icons.close,
                                //   size: 18,
                                //   color: Colors.black54,
                                // ),
                                child: Container(
                                  padding: const EdgeInsets.all(
                                      4), // space around icon
                                  decoration: const BoxDecoration(
                                    color:
                                        Colors.white, // 👈 white background
                                    // shape:
                                    //     BoxShape.circle, // 👈 circular shape
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 18,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
          
                          // Quantity Counter + Price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Quantity counter
                              Container(
                                padding: const EdgeInsets.all(
                                    8), // optional padding
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors
                                          .grey.shade300), // grey border
                                  borderRadius: BorderRadius.circular(
                                      5), // rounded corners
                                ),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (cartItemsList
                                                .cartData!
                                                .cartProductdata![index]
                                                .cartQty! >=
                                            1) {
                                          cartItemsList
                                              .cartData!
                                              .cartProductdata![index]
                                              .cartQty = cartItemsList
                                                  .cartData!
                                                  .cartProductdata![index]
                                                  .cartQty! -
                                              1;
                                          addToCartRO1(
                                            cartItemsList
                                                .cartData!
                                                .cartProductdata![index]!,
                                           cartItemsList
                                                .cartData!
                                                .cartProductdata![index]
                                                .cartQty!,
                                            true,
                                            "0",
                                          );
                                          setState(() {});
                                        }
                                      },
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Icon(
                                          cartItemsList
                                                      .cartData!
                                                      .cartProductdata![index]
                                                      .cartQty! >
                                                  1
                                              ? Icons.remove
                                              : Icons.delete_outline,
                                          size: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "${ cartItemsList.cartData!.cartProductdata![index].cartQty ?? 1}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    InkWell(
                                      onTap: () {
                                        cartItemsList
                                            .cartData!
                                            .cartProductdata![index]
                                            .cartQty = cartItemsList
                                                .cartData!
                                                .cartProductdata![index]
                                                .cartQty! +
                                            1;
                                        addToCartRO1(
                                          cartItemsList
                                              .cartData!
                                              .cartProductdata![index]!,
                                          cartItemsList
                                              .cartData!
                                              .cartProductdata![index]
                                              .cartQty!,
                                          true,
                                          "0",
                                        );
                                        setState(() {});
                                      },
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          size: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
          
                              // Price
                              const SizedBox(width: 8),
                              Text(
                                "AED ${ cartItemsList.cartData!.cartProductdata![index].price!.toStringAsFixed(0)}",
                                style: const TextStyle(
                                  fontFamily: "outfit",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
                  
          },
          
          ),
        ],
      ),
    ):Container(
      height: MediaQuery.of(context).size.height/2,
      
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10)
        ),
        color: ColorConstants.colorPageBackground,

      ),
      child: Center(child: CircularProgressIndicator(),),
    );
       
    
  }

   void addToCartRO1(
      CartProduct product, int cartQty, bool isDel, String repeat_orders,
      {Varient? varient, int? varientId, int? callId}) async {
    showOnlyLoaderDialog();
    print("Nikhil add to cart RO");
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
}
