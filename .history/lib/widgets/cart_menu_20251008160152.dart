import 'dart:collection';

import 'package:byyu/constants/analytics_GA4.dart';
import 'package:byyu/models/cartModel.dart';
import 'package:byyu/screens/product/product_description_screen.dart';
import 'package:byyu/widgets/toastfile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/constants/image_constants.dart';
import 'package:byyu/controllers/cart_controller.dart';
import 'package:byyu/models/addtocartmessagestatus.dart';
import 'package:byyu/models/businessLayer/apiHelper.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/models/categoryProductModel.dart';
import 'package:byyu/models/varientModel.dart';
import 'package:byyu/utils/size_config.dart';

class CartMenu extends StatefulWidget {
  final CartController? cartController;
  final Function? homeScreenSetState;
  dynamic a, o;
  CartMenu({this.a, this.o, this.cartController, this.homeScreenSetState})
      : super();

  @override
  _CartMenuState createState() => _CartMenuState(
      a: a,
      o: o,
      cartController: cartController,
      homeScreenSetState: homeScreenSetState);
}

class _CartMenuState extends State<CartMenu> {
  CartController? cartController;
  dynamic a, o;
  final Function? homeScreenSetState;

  _CartMenuState(
      {this.a, this.o, this.cartController, this.homeScreenSetState});

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
          _getCartList1();
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

  _getCartList1() async {
    try {
      print("Nikhil----get cart list---");
      await cartController!.getCartList();
      if (cartController!.isDataLoaded.value == true) {
        if (global.cartItemsPresent) {
          hideloader();
          cartItemsPresent = true;
          global.cartItemsPresent = true;
        } else {
          hideloader();
          cartItemsPresent = false;
          global.cartItemsPresent = false;
        }
      } else {
        hideloader();
        cartItemsPresent = false;
        global.cartItemsPresent = false;
      }
      homeScreenSetState!();
      setState(() {});
    } catch (e) {
      hideloader();
      print("Exception - cart_screen.dart - _getCartList123(): $e");
    }
  }

  void hideloader() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: 10),
      shrinkWrap: true,
      itemCount: cartController!.cartItemsList.cartData != null &&
              cartController!.cartItemsList.cartData!.cartProductdata != null
          ? cartController!.cartItemsList.cartData!.cartProductdata!.length
          : 0,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return GetBuilder<CartController>(
          init: cartController,
          builder: (value) => Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) async {
              addToCartRO1(
                cartController!.cartItemsList.cartData!.cartProductdata![index],
                0,
                true,
                "0",
              );
              setState(() {});
            },
            background: _backgroundContainer(context, screenHeight),
            child: InkWell(
              onTap: () {
                if (cartController!.cartItemsList.cartData!
                        .cartProductdata![index].productId !=
                    null) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProductDescriptionScreen(
                            a: a,
                            o: o,
                            productId: cartController!.cartItemsList.cartData!
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
                              cartController!.cartItemsList.cartData!
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
                                    cartController!.cartItemsList.cartData!
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
                                      cartController!.cartItemsList.cartData!
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
                                          if (cartController!
                                                  .cartItemsList
                                                  .cartData!
                                                  .cartProductdata![index]
                                                  .cartQty! >=
                                              1) {
                                            cartController!
                                                .cartItemsList
                                                .cartData!
                                                .cartProductdata![index]
                                                .cartQty = cartController!
                                                    .cartItemsList
                                                    .cartData!
                                                    .cartProductdata![index]
                                                    .cartQty! -
                                                1;
                                            addToCartRO1(
                                              cartController!
                                                  .cartItemsList
                                                  .cartData!
                                                  .cartProductdata![index]!,
                                              cartController!
                                                  .cartItemsList
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
                                            cartController!
                                                        .cartItemsList
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
                                        "${cartController!.cartItemsList.cartData!.cartProductdata![index].cartQty ?? 1}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      InkWell(
                                        onTap: () {
                                          cartController!
                                              .cartItemsList
                                              .cartData!
                                              .cartProductdata![index]
                                              .cartQty = cartController!
                                                  .cartItemsList
                                                  .cartData!
                                                  .cartProductdata![index]
                                                  .cartQty! +
                                              1;
                                          addToCartRO1(
                                            cartController!
                                                .cartItemsList
                                                .cartData!
                                                .cartProductdata![index]!,
                                            cartController!
                                                .cartItemsList
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
                                  "AED ${cartController!.cartItemsList.cartData!.cartProductdata![index].price!.toStringAsFixed(0)}",
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
            ),
          ),
        );
      },
    );
  }

  listSetState() {
    setState(() {});
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

  Widget _backgroundContainer(BuildContext context, double screenHeight) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Wrap(
          children: [
            Container(
              height: 80 * screenHeight / 830,
              color: Theme.of(context).colorScheme.error,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Center(
                    child: Icon(
                      FontAwesomeIcons.trashCan,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 32),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
