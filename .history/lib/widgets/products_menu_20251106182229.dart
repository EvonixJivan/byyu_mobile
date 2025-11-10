import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:byyu/constants/analytics_GA4.dart';
import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/constants/image_constants.dart';
import 'package:byyu/controllers/cart_controller.dart';
import 'package:byyu/models/addtocartmessagestatus.dart';
import 'package:byyu/models/businessLayer/apiHelper.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/models/categoryProductModel.dart';
import 'package:byyu/screens/auth/login_screen.dart';
import 'package:byyu/screens/product/product_description_screen.dart';
import 'package:byyu/widgets/bottom_button.dart';
import 'package:byyu/widgets/toastfile.dart';

class PopularProductsMenuItem extends StatefulWidget {
  final int? callId;
  final key;
  final Product? product;
  final dynamic analytics;
  final dynamic observer;
  Function? funOnTap;
  Function()? refreshProductList;
  final String? isHomeSelected;
  bool? isSubCatgoriesScreen;
  final dynamic passdata1;
  final dynamic passdata2;
  final dynamic passdata3;
  final screenName;

  PopularProductsMenuItem(
      {@required this.product,
      this.analytics,
      this.observer,
      this.callId,
      this.key,
      this.funOnTap,
      this.refreshProductList,
      this.isHomeSelected,
      this.passdata1,
      this.passdata2,
      this.passdata3,
      this.isSubCatgoriesScreen,
      this.screenName})
      : super();

  @override
  _PopularProductsMenuItemState createState() => _PopularProductsMenuItemState(
      product: product,
      analytics: analytics,
      observer: observer,
      callId: callId,
      key: key,
      funOnTap: funOnTap,
      refreshProductList: refreshProductList,
      isHomeSelected: isHomeSelected,
      passdata1: passdata1,
      isSubCatgoriesScreen: isSubCatgoriesScreen,
      passdata2: passdata2,
      passdata3: passdata3,
      screenName: screenName);
}

class ProductsMenu extends StatefulWidget {
  final dynamic analytics;
  final dynamic observer;
  final int? callId;
  final List<Product>? categoryProductList;
  Function? funOnTap;
  bool? isSubCatgoriesScreen;
  final String? isHomeSelected;
  final dynamic passdata1;
  final dynamic passdata2;
  final dynamic passdata3;
  final dynamic screenName;
  final Function()? refreshProductList;

  ProductsMenu(
      {this.analytics,
      this.observer,
      this.categoryProductList,
      this.callId,
      this.funOnTap,
      this.isHomeSelected,
      this.refreshProductList,
      this.passdata1,
      this.passdata2,
      this.passdata3,
      this.isSubCatgoriesScreen,
      this.screenName})
      : super();

  @override
  _ProductsMenuState createState() => _ProductsMenuState(
      analytics: analytics,
      observer: observer,
      categoryProductList: categoryProductList,
      callId: callId,
      funOnTap: funOnTap,
      refreshProductList: refreshProductList,
      isHomeSelected: isHomeSelected,
      isSubCatgoriesScreen: isSubCatgoriesScreen,
      passdata1: passdata1,
      passdata2: passdata2,
      passdata3: passdata3,
      screenName: screenName);
}

class _PopularProductsMenuItemState extends State<PopularProductsMenuItem> {
  Product? product;
  dynamic analytics;
  dynamic observer;
  APIHelper apiHelper = APIHelper();
  Key? key;
  int? callId;
  CartController cartController = Get.put(CartController());
  int? _qty;
  Function? funOnTap;
  Function()? refreshProductList;
  List<Product>? categoryProductList;
  String? isHomeSelected;
  final dynamic passdata1;
  final dynamic passdata2;
  final dynamic passdata3;
  dynamic screenName;
  bool? isSubCatgoriesScreen;
  bool _isLoading = false;
  void _imageLoaded(ImageInfo imageInfo, bool synchronousCall) {
    setState(() {
      _isLoading = false;
    });
  }

  _PopularProductsMenuItemState(
      {this.product,
      this.analytics,
      this.observer,
      this.callId,
      this.key,
      this.funOnTap,
      this.categoryProductList,
      this.refreshProductList,
      this.isHomeSelected,
      this.passdata1,
      this.passdata2,
      this.passdata3,
      this.isSubCatgoriesScreen,
      this.screenName});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void setproductmenuState() {
    setState(() {});
  }

  void addToCartRO(int qty) async {
    showOnlyLoaderDialog();
    print("Nikhil ADD TO CART RO");
    try {
      bool isSuccess = false;
      String message = '--';

      await apiHelper
          .addToCart(
              qty: qty,
              varientId: product!.varientId,
              special: 0,
              deliveryDate: "",
              deliveryTime: "",
              repeat_orders: "0")
          .then((result) {
        if (result != null) {
          FirebaseAnalyticsGA4().callAnalyticsAddCart(
              product!.productId!,
              product!.productName!,
              "",
              product!.varientId!,
              '',
              product!.price!,
              qty,
              product!.mrp!,
              false,
              false);
          if (global.cartCount > 0) {
            global.cartCount = global.cartCount - 1;
          } else {
            global.cartCount = 0;
          }

          product!.cartQty = qty;

          _qty = 1;
          hideloadershowing();
          cartController = CartController();
          cartController.getCartList();
          showCartBottomSheet(context, analytics, observer, refreshProductList);
          setState(() {});
        } else {
          isSuccess = false;
          message = 'Something went wrong please try after some time';
        }
      });
      // return ATCMS(isSuccess: isSuccess, message: message);
    } catch (e) {
      print("Exception -  cart_controller.dart - addToCart():" + e.toString());
      return null;
    }
  }

  void hideloadershowing() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    var stock = 0;
    // if (screenName == "facourites") {
    //   // print('product name in card --->$screenName');

    //   stock = product.stock;
    // } else {
    //   stock = product.varient[0].stock;
    // }

    return Container(
      width: MediaQuery.of(context).size.width / 1.9,
      child: GetBuilder<CartController>(
        init: cartController,
        builder: (value) => Card(
          // shadowColor: ColorConstants.greyfaint,
          //margin: EdgeInsets.only(left: 8),
          color: Colors.transparent,
          // shape: RoundedRectangleBorder(
          //   side: BorderSide(
          //     color: ColorConstants.greyfaint,
          //     width: 0.5,
          //   ),
          //   borderRadius: BorderRadius.circular(8.0),
          // ),
          elevation: 0,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width / 2.6,
                    //margin: EdgeInsets.all(1),
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        // CachedNetworkImage(
                        //   // memCacheWidth: 45,
                        //   // memCacheHeight: 60,
                        //   // maxHeightDiskCache: 60,
                        //   // maxWidthDiskCache: 45,
                        //   width: MediaQuery.of(context).size.width / 2.1,
                        //   height: MediaQuery.of(context).size.height,
                        //   fit: BoxFit.cover,
                        //   imageUrl: product.thumbnail != null &&
                        //           product.thumbnail.isNotEmpty &&
                        //           product.thumbnail != "N/A"
                        //       ? global.imageBaseUrl + product.thumbnail
                        //       : global.imageBaseUrl + product.productImage,
                        //   placeholder: (context, url) => Center(
                        //       child: CircularProgressIndicator(
                        //     strokeWidth: 1.0,
                        //   )),
                        //   errorWidget: (context, url, error) => Container(
                        //       height: 180, //50
                        //       width: MediaQuery.of(context).size.width /
                        //           2.2, //55
                        //       child: Image.asset(
                        //         global.noImage,
                        //         fit: BoxFit.cover,
                        //         height: 150,
                        //         width:
                        //             MediaQuery.of(context).size.width / 2.2,
                        //         alignment: Alignment.center,
                        //       )),
                        // ),
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            topRight: Radius.circular(100),
                          ),
                          child: Image.network(
                            global.imageBaseUrl +
                                product!.productImage! +
                                "?width=500&height=500",
                            cacheWidth: 360,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: InkWell(
                              onTap: () async {
                                if (global.currentUser.id == null) {
                                  Future.delayed(Duration.zero, () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen(
                                                a: widget.analytics,
                                                o: widget.observer,
                                              )),
                                    );
                                  });
                                } else {
                                  showOnlyLoaderDialog();
                                  await addRemoveWishList(
                                      product!.varientId!, product!);
                                  // // funOnTap();
                                  // _showToastWishlist(context);
                                  Navigator.pop(context);
                                  setState(() {});
                                }
                              },
                              child: product!.isFavourite == "true"
                                  ? Icon(
                                      MdiIcons.heart,
                                      size: 24,
                                      color: ColorConstants.newHeartFavorite,
                                    )
                                  : Image.asset(
                                      'assets/images/wishlist-icon-without.png',
                                      width: 20,
                                      height: 22,
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: false,
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2.4,
                            height: 200,
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 45,
                                    height: 22,
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(8)),
                                        color: ColorConstants
                                            .ratingContainerColor),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 18,
                                          color: ColorConstants.StarRating,
                                        ),
                                        Text(
                                          "${product!.rating}",
                                          style: TextStyle(
                                              fontFamily:
                                                  global.fontRailwayRegular,
                                              fontWeight: FontWeight.w200,
                                              fontSize: 11,
                                              color: ColorConstants.white),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    //width: 45,
                                    height: 22,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(8)),
                                        color: Colors.black38),
                                    padding: EdgeInsets.only(
                                        bottom: 1, top: 1, left: 6, right: 6),
                                    child: Row(
                                      children: [
                                        Text(
                                            "${product!.countrating} Reviews", //"${product.countrating} Reviews",
                                            style: TextStyle(
                                                fontFamily:
                                                    global.fontRailwayRegular,
                                                fontWeight: FontWeight.w200,
                                                fontSize: 11,
                                                color: ColorConstants.white)),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Visibility(
                        //   visible: product.stock > 0 ? false : true,
                        //   child: Container(
                        //     alignment: Alignment.center,
                        //     // decoration: BoxDecoration(
                        //     //     color: Colors.white.withOpacity(0.6),
                        //     //     borderRadius: BorderRadius.circular(5)),
                        //     padding: const EdgeInsets.all(5),
                        //     child: Center(
                        //       child: Transform.rotate(
                        //         angle: 12,
                        //         child: Text(
                        //           "Currently Product\nis Unavailable",
                        //           // '${AppLocalizations.of(context).txt_out_of_stock}',
                        //           textAlign: TextAlign.center,
                        //           maxLines: 2,
                        //           style: GoogleFonts.poppins(
                        //               fontWeight: FontWeight.w600,
                        //               fontSize: 15,
                        //               color: Colors.red),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Stack(children: [
                    Container(
                      margin: EdgeInsets.only(left: 5, right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 8),
                                  child: Text(
                                    "${product!.productName}",
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: global.fontRalewayMedium,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        overflow: TextOverflow.ellipsis,
                                        color: ColorConstants
                                            .newTextHeadingFooter),
                                  ),
                                ),
                                // product.productName.length < 18
                                //     ? SizedBox(height: 20)
                                //     : Container(),
                                // Container(
                                //   margin: EdgeInsets.only(top: 1, bottom: 1),
                                //   child: Text(
                                //     "${product.productName}",
                                //     maxLines: 1,
                                //     // "${categoryProductList[index].varient[0].description}",
                                //     style: TextStyle(
                                //         fontFamily: global.fontMontserratLight,
                                //         fontSize: 16,
                                //         overflow: TextOverflow.ellipsis,
                                //         color: Colors.black54),
                                //   ),
                                // ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Text(
                                          "AED ",
                                          style: TextStyle(
                                              fontFamily:
                                                  global.fontOufitMedium,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                              color: ColorConstants.pureBlack),
                                        ),
                                      ),
                                      Text(
                                        int.parse(product!.price
                                                    .toString()
                                                    .substring(product!.price
                                                            .toString()
                                                            .indexOf(".") +
                                                        1)) >
                                                0
                                            ? "${product!.price!.toStringAsFixed(2)}"
                                            : "${product!.price.toString().substring(0, product!.price.toString().indexOf("."))}", //"${product.varient[0].buyingPrice}",
                                        style: TextStyle(
                                            fontFamily: global.fontOufitMedium,
                                            fontSize: 15,
                                            color: ColorConstants.pureBlack),
                                      ),
                                      // product!.price! < product!.mrp!
                                      //     ? Stack(children: [
                                      //         Container(
                                      //           margin:
                                      //               EdgeInsets.only(left: 3),
                                      //           padding: EdgeInsets.only(
                                      //               top: 2, bottom: 2),
                                      //           child: Text(
                                      //             int.parse(product!.mrp
                                      //                         .toString()
                                      //                         .substring(product!
                                      //                                 .mrp
                                      //                                 .toString()
                                      //                                 .indexOf(
                                      //                                     ".") +
                                      //                             1)) >
                                      //                     0
                                      //                 ? "( ${product!.mrp!.toStringAsFixed(2)} )"
                                      //                 : "( ${product!.mrp.toString().substring(0, product!.mrp.toString().indexOf("."))} )", //"${product.varient[0].baseMrp}",
                                      //             textAlign: TextAlign.center,
                                      //             style: TextStyle(
                                      //                 fontFamily: global
                                      //                     .fontOufitMedium,
                                      //                 fontWeight:
                                      //                     FontWeight.w200,
                                      //                 fontSize: 15,
                                      //                 color: ColorConstants
                                      //                     .pureBlack),
                                      //           ),
                                      //         ),
                                      //         Container(
                                      //           margin: EdgeInsets.only(
                                      //               left: 8, top: 1),
                                      //           alignment: Alignment.center,
                                      //           // decoration: BoxDecoration(
                                      //           //     color: Colors.white.withOpacity(0.6),
                                      //           //     borderRadius: BorderRadius.circular(5)),
                                      //           //padding: const EdgeInsets.all(5),
                                      //           child: Center(
                                      //             child: Transform.rotate(
                                      //               angle: 0,
                                      //               child: Text(
                                      //                   int.parse(product!.mrp.toString().substring(product!.mrp.toString().indexOf(".") + 1)) >
                                      //                               0 &&
                                      //                           product!.mrp!.toStringAsFixed(2).length ==
                                      //                               6
                                      //                       ? "-----"
                                      //                       : product!.mrp!
                                      //                                   .toString()
                                      //                                   .length ==
                                      //                               5
                                      //                           ? "----"
                                      //                           : product!.mrp!
                                      //                                       .toString()
                                      //                                       .length ==
                                      //                                   4
                                      //                               ? "---"
                                      //                               : product!.mrp!.toString().length ==
                                      //                                       3
                                      //                                   ? "--"
                                      //                                   : "------",
                                      //                   // '${AppLocalizations.of(context).txt_out_of_stock}',
                                      //                   textAlign:
                                      //                       TextAlign.center,
                                      //                   maxLines: 2,
                                      //                   style: TextStyle(
                                      //                       fontFamily: global
                                      //                           .fontRailwayRegular,
                                      //                       fontWeight:
                                      //                           FontWeight.w600,
                                      //                       fontSize: 15,
                                      //                       decoration:
                                      //                           TextDecoration
                                      //                               .lineThrough,
                                      //                       color: ColorConstants
                                      //                           .pureBlack)),
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ])
                                      Container(),
                                      // Container(
                                      //   margin: EdgeInsets.only(left: 3, right: 5),
                                      //   child: Text(
                                      //     product.varient[0].discountper
                                      //             .toString()
                                      //             .startsWith("-")
                                      //         ? "${product.varient[0].discountper.toString().substring(1)}% off"
                                      //         : "${product.varient[0].discountper}% off", //"${product.varient[0].buyingPrice}",
                                      //     style: TextStyle(
                                      //         fontFamily:
                                      //             global.fontRailwayRegular,
                                      //         fontWeight: FontWeight.w200,
                                      //         fontSize: 12,
                                      //         color: ColorConstants.appColor),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),

                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        product!.delivery == "1" ||
                                                product!.delivery == "Today"
                                            ? "Express"
                                            : product!.delivery == "2" ||
                                                    product!.delivery ==
                                                        "Tomorrow"
                                                ? "Today"
                                                : "Scheduled Delivery",
                                        style: TextStyle(
                                            fontFamily:
                                                global.fontRailwayRegular,
                                            fontWeight: FontWeight.w200,
                                            fontSize: 13,
                                            color: ColorConstants.appColor),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                product!.cartQty == 0
                                    ? InkWell(
                                        onTap: () {
                                          print(
                                              "Nikhil-----this is on pressed");

                                          addToCartRO(1);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 2, right: 2),
                                          child: Container(
                                            height: 25,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4.0,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: ColorConstants.appColor,
                                                border: Border.all(
                                                    width: 0.5,
                                                    color: ColorConstants
                                                        .appColor)),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                // product.cartQty != 0
                                                //     ? "GO TO CART"
                                                // :
                                                "ADD TO CART",
                                                style: TextStyle(
                                                    fontFamily:
                                                        global.fontOufitMedium,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    color: ColorConstants.white,
                                                    letterSpacing: 1),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4.0,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                width: 0.5,
                                                color:
                                                    ColorConstants.appColor)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                print("nikhil");
                                                if (product!.cartQty! > 0) {
                                                  addToCartRO(
                                                      product!.cartQty! - 1);
                                                  _qty = _qty! - 1;
                                                }

                                                setState(() {});
                                              },
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(right: 5),
                                                width: 25,
                                                height: 25,
                                                child: product!.cartQty !=
                                                            null &&
                                                        product!.cartQty == 1
                                                    ? Icon(
                                                        FontAwesomeIcons
                                                            .trashCan,
                                                        size: 14.0,
                                                        color: ColorConstants
                                                            .newTextHeadingFooter,
                                                      )
                                                    : Icon(
                                                        MdiIcons.minus,
                                                        size: 14.0,
                                                        color: ColorConstants
                                                            .newTextHeadingFooter,
                                                      ),
                                              ),
                                            ),
                                            Text(
                                              product!.cartQty != 0
                                                  ? "${product!.cartQty}"
                                                  : "${_qty}",
                                              style: TextStyle(
                                                fontFamily:
                                                    global.fontRailwayRegular,
                                                fontWeight: FontWeight.w200,
                                                fontSize: 16,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                if (product!.cartQty != null &&
                                                    product!.cartQty! > 0) {
                                                  _qty = product!.cartQty;
                                                }
                                                if (product!.cartQty != 0) {
                                                  product!.cartQty =
                                                      product!.cartQty! + 1;
                                                }
                                                _qty = _qty! + 1;
                                                addToCartRO(_qty!);
                                                setState(() {});
                                              },
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 5),
                                                width: 25,
                                                height: 25,
                                                child: Icon(
                                                  MdiIcons.plus,
                                                  size: 20,
                                                  color: ColorConstants
                                                      .newTextHeadingFooter,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                // product!.stock! > 0
                                //     ? Container(
                                //         margin: EdgeInsets.only(top: 6),
                                //         child: isSubCatgoriesScreen!?Column(children: [Text(
                                //               "Estimated Delivery:",
                                //               style: TextStyle(
                                //                   fontFamily: global
                                //                       .fontRailwayRegular,
                                //                   fontWeight: FontWeight.w200,
                                //                   fontSize: 10,
                                //                   color:
                                //                       ColorConstants.pureBlack),
                                //             ),
                                //             SizedBox(height: 8,),
                                //             Container(
                                //                 padding: EdgeInsets.only(
                                //                     left: 4,
                                //                     right: 4,
                                //                     top: 5,
                                //                     bottom: 5),
                                //                 decoration: BoxDecoration(
                                //                     borderRadius: BorderRadius.all(
                                //                         Radius.circular(10)),
                                //                     color:
                                //                         Colors.green.shade100),
                                //                 child: product!.delivery !=
                                //                                 null &&
                                //                             product!.delivery ==
                                //                                 "1" ||
                                //                         product!.delivery ==
                                //                             "Today"
                                //                     ? Text(
                                //                         "Express",
                                //                         style: TextStyle(
                                //                             fontFamily: global
                                //                                 .fontRailwayRegular,
                                //                             fontWeight:
                                //                                 FontWeight.w200,
                                //                             fontSize: 10,
                                //                             color:
                                //                                 ColorConstants
                                //                                     .pureBlack),
                                //                       )
                                //                     : product!.delivery !=
                                //                                     null &&
                                //                                 product!.delivery ==
                                //                                     "2" ||
                                //                             product!.delivery ==
                                //                                 "Tomorrow"
                                //                         ? Text(
                                //                             "Today",
                                //                             style: TextStyle(
                                //                                 fontFamily: global
                                //                                     .fontRailwayRegular,
                                //                                 fontWeight:
                                //                                     FontWeight
                                //                                         .w200,
                                //                                 fontSize: 10,
                                //                                 color: ColorConstants
                                //                                     .pureBlack),
                                //                           )
                                //                         : product!.delivery !=
                                //                                     null &&
                                //                                 product!.delivery ==
                                //                                     "3"
                                //                             ? Text(
                                //                                 "Tomorrow",
                                //                                 style: TextStyle(
                                //                                     fontFamily:
                                //                                         global
                                //                                             .fontRailwayRegular,
                                //                                     fontWeight:
                                //                                         FontWeight
                                //                                             .w200,
                                //                                     fontSize:
                                //                                         10,
                                //                                     color: ColorConstants
                                //                                         .pureBlack),
                                //                               )
                                //                             : Text(
                                //                                 product!.delivery ==
                                //                                             null ||
                                //                                         product!.delivery ==
                                //                                             ""
                                //                                     ? "Tomorrow"
                                //                                     : "${int.parse(product!.delivery!) - 2} days",
                                //                                 style: TextStyle(
                                //                                     fontFamily:
                                //                                         global
                                //                                             .fontRailwayRegular,
                                //                                     fontWeight:
                                //                                         FontWeight
                                //                                             .w200,
                                //                                     fontSize:
                                //                                         10,
                                //                                     color: ColorConstants
                                //                                         .pureBlack),
                                //                               )),
                                //          ],): Row(
                                //           mainAxisAlignment:
                                //               MainAxisAlignment.spaceEvenly,
                                //           children: [
                                //             Text(
                                //               "Estimated Delivery:",
                                //               style: TextStyle(
                                //                   fontFamily: global
                                //                       .fontRailwayRegular,
                                //                   fontWeight: FontWeight.w200,
                                //                   fontSize: 10,
                                //                   color:
                                //                       ColorConstants.pureBlack),
                                //             ),
                                //             Container(
                                //                 padding: EdgeInsets.only(
                                //                     left: 4,
                                //                     right: 4,
                                //                     top: 5,
                                //                     bottom: 5),
                                //                 decoration: BoxDecoration(
                                //                     borderRadius: BorderRadius.all(
                                //                         Radius.circular(10)),
                                //                     color:
                                //                         Colors.green.shade100),
                                //                 child: product!.delivery !=
                                //                                 null &&
                                //                             product!.delivery ==
                                //                                 "1" ||
                                //                         product!.delivery ==
                                //                             "Today"
                                //                     ? Text(
                                //                         "Express",
                                //                         style: TextStyle(
                                //                             fontFamily: global
                                //                                 .fontRailwayRegular,
                                //                             fontWeight:
                                //                                 FontWeight.w200,
                                //                             fontSize: 10,
                                //                             color:
                                //                                 ColorConstants
                                //                                     .pureBlack),
                                //                       )
                                //                     : product!.delivery !=
                                //                                     null &&
                                //                                 product!.delivery ==
                                //                                     "2" ||
                                //                             product!.delivery ==
                                //                                 "Tomorrow"
                                //                         ? Text(
                                //                             "Today",
                                //                             style: TextStyle(
                                //                                 fontFamily: global
                                //                                     .fontRailwayRegular,
                                //                                 fontWeight:
                                //                                     FontWeight
                                //                                         .w200,
                                //                                 fontSize: 10,
                                //                                 color: ColorConstants
                                //                                     .pureBlack),
                                //                           )
                                //                         : product!.delivery !=
                                //                                     null &&
                                //                                 product!.delivery ==
                                //                                     "3"
                                //                             ? Text(
                                //                                 "Tomorrow",
                                //                                 style: TextStyle(
                                //                                     fontFamily:
                                //                                         global
                                //                                             .fontRailwayRegular,
                                //                                     fontWeight:
                                //                                         FontWeight
                                //                                             .w200,
                                //                                     fontSize:
                                //                                         10,
                                //                                     color: ColorConstants
                                //                                         .pureBlack),
                                //                               )
                                //                             : Text(
                                //                                 product!.delivery ==
                                //                                             null ||
                                //                                         product!.delivery ==
                                //                                             ""
                                //                                     ? "Tomorrow"
                                //                                     : "${int.parse(product!.delivery!) - 2} days",
                                //                                 style: TextStyle(
                                //                                     fontFamily:
                                //                                         global
                                //                                             .fontRailwayRegular,
                                //                                     fontWeight:
                                //                                         FontWeight
                                //                                             .w200,
                                //                                     fontSize:
                                //                                         10,
                                //                                     color: ColorConstants
                                //                                         .pureBlack),
                                //                               )),
                                //           ],
                                //         ),
                                //       )
                                //     : Container(
                                //         margin: EdgeInsets.only(top: 8),
                                //         child: Text(
                                //           "",
                                //           style: TextStyle(
                                //               fontFamily:
                                //                   global.fontRailwayRegular,
                                //               fontWeight: FontWeight.w200,
                                //               fontSize: 15,
                                //               color: ColorConstants.appColor),
                                //         ),
                                //       ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     Container(
                                //       margin: EdgeInsets.only(top: 5),
                                //       height: 30,
                                //       //width: 62,
                                //       decoration: BoxDecoration(
                                //           borderRadius: BorderRadius.circular(30)),
                                //       child: BottomButton(
                                //           child: Text(
                                //             "Buy now",
                                //             style: TextStyle(
                                //                 fontFamily:
                                //                     global.fontMontserratMedium,
                                //                 fontWeight: FontWeight.w600,
                                //                 fontSize: 16,
                                //                 color: global.white),
                                //           ),
                                //           loadingState: false,
                                //           disabledState: false,
                                //           onPressed: () {}),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ])
                ],
              ),
              product!.stock! > 0
                  ? Container()
                  : Container(
                      // width: 160,
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(
                          color: Colors.white.withOpacity(0.7)),
                    ),
            ],
          ),
        ),
      ),
    );
    // }
  }

  Future<bool> addRemoveWishList(int varientId, Product product) async {
    bool _isAddedSuccesFully = false;
    try {
      await apiHelper.addRemoveWishList(varientId).then((result) async {
        if (result != null) {
          // funOnTap();
          if (result.status == "1" || result.status == "2") {
            _isAddedSuccesFully = true;
            // FirebaseAnalyticsGA4().callAnalyticsAddCart(
            //     product.productId,
            //     product.productName,
            //     '',
            //     product.varientId,
            //     '',
            //     product.price,
            //     product.qty,
            //     product.mrp,
            //     2);
            // product.isFavourite = !product.isFavourite;
            if (result.status == "1") {
              product.isFavourite = 'true';
            } else {
              product.isFavourite = "false";
            }

            setState(() {
              funOnTap!();
            });
          } else {
            _isAddedSuccesFully = false;

            setState(() {});
            showSnackBar(
                snackBarMessage:
                    ''); //'${AppLocalizations.of(context).txt_please_try_again_after_sometime}');
          }
        }
      });
      return _isAddedSuccesFully;
    } catch (e) {
      print("Exception - products_menu.dart - addRemoveWishList():" +
          e.toString());
      return _isAddedSuccesFully;
    }
  }

  void showSnackBar({String? snackBarMessage}) {
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   content: Text(
    //     snackBarMessage,
    //     textAlign: TextAlign.center,
    //   ),
    //   duration: Duration(seconds: 2),
    // ));
    //showToast(snackBarMessage);
  }

  showOnlyLoaderDialog() {
    return showDialog(
      context: context,
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
}

class _ProductsMenuState extends State<ProductsMenu> {
  dynamic analytics;
  dynamic observer;
  int? callId;
  List<Product>? categoryProductList;
  APIHelper apiHelper = APIHelper();
  Function? funOnTap;
  Function()? refreshProductList;
  final String? isHomeSelected;
  final dynamic passdata1;
  final dynamic passdata2;
  final dynamic passdata3;
  final dynamic screenName;
  bool? isSubCatgoriesScreen;

  _ProductsMenuState(
      {this.analytics,
      this.observer,
      this.categoryProductList,
      this.callId,
      this.funOnTap,
      this.refreshProductList,
      this.isHomeSelected,
      this.passdata1,
      this.passdata2,
      this.passdata3,
      this.isSubCatgoriesScreen,
      this.screenName});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 0,
          childAspectRatio: isSubCatgoriesScreen!
              ? (Platform.isIOS && MediaQuery.of(context).size.height < 700
                  ? (MediaQuery.of(context).size.width + 10) /
                      (MediaQuery.of(context).size.height / 0.92)
                  : Platform.isIOS
                      ? (MediaQuery.of(context).size.width + 10) /
                          (MediaQuery.of(context).size.height / 1.2)
                      : (MediaQuery.of(context).size.width + 10) /
                          (MediaQuery.of(context).size.height / 1.2))
              : (Platform.isIOS && MediaQuery.of(context).size.height < 700
                  ? (MediaQuery.of(context).size.width + 10) /
                      (MediaQuery.of(context).size.height / 2.34)
                  : Platform.isIOS
                      ? (MediaQuery.of(context).size.width + 10) /
                          (MediaQuery.of(context).size.height / 2.7)
                      : (MediaQuery.of(context).size.width + 10) /
                          (MediaQuery.of(context).size.height / 2.5))),
      scrollDirection: Axis.vertical,
      itemCount: categoryProductList!.length,
      physics: ScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          //
          child: InkWell(
            onTap: () {
              try {
                if (categoryProductList![index].stock! > 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDescriptionScreen(
                        a: widget.analytics,
                        o: widget.observer,
                        productId: categoryProductList![index].productId,
                        isHomeSelected: "search",
                      ),
                    ),
                  );
                }
              } catch (e) {
                //print(e.printError());
                print(e.toString());
              }
            },
            child: Stack(
              children: [
                PopularProductsMenuItem(
                    key: Key('${categoryProductList!.length}'),
                    product: categoryProductList![index],
                    analytics: widget.analytics,
                    observer: widget.observer,
                    callId: callId,
                    isSubCatgoriesScreen: isSubCatgoriesScreen,
                    screenName: screenName,
                    refreshProductList: refreshProductList),
                categoryProductList![index].stock! > 0
                    ? Positioned(
                        left: 4,
                        top: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(1),
                          child: categoryProductList![index].discount != null &&
                                  categoryProductList![index].discount > 0
                              ? Container(
                                  height: 35,
                                  width: 30,
                                  /*decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    bottomRight: Radius.circular(4),
                                  ),
                                ),*/
                                  decoration: BoxDecoration(
                                    //color: ColorConstants.green,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8)),
                                    image: new DecorationImage(
                                      image: new AssetImage(
                                          'assets/images/discount_label_bg.png'),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${categoryProductList![index].discount}%\nOFF",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 10,
                                          fontFamily: global.fontRailwayRegular,
                                          color: Colors.white),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 1,
                                  width: 1,
                                ),
                        ),
                      )
                    : Positioned(
                        bottom: 15,
                        left: 10,
                        right: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2.2,
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: ColorConstants.grey,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: ColorConstants.allBorderColor)),
                                child: Text(
                                  "Sold Out",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w200,
                                      fontSize: 15,
                                      fontFamily: global.fontRailwayRegular,
                                      color: ColorConstants.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  showOnlyLoaderDialog() {
    return showDialog(
      context: context,
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
}
