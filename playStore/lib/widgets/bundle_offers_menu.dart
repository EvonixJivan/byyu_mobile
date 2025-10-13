import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
  
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/controllers/cart_controller.dart';
import 'package:byyu/models/addtocartmessagestatus.dart';
import 'package:byyu/models/businessLayer/apiHelper.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/categoryProductModel.dart';
import 'package:byyu/screens/auth/login_screen.dart';
import 'package:byyu/screens/product/product_description_screen.dart';
import 'package:byyu/widgets/bottom_button.dart';
import 'package:byyu/widgets/toastfile.dart';

class BundleOffersMenu extends StatefulWidget {
  final dynamic analytics;
  final dynamic observer;
  final List<Product>? categoryProductList;
  final Function(int)? onSelected;
  final String? isHomeSelected;
  BundleOffersMenu(
      {this.onSelected,
      this.categoryProductList,
      this.analytics,
      this.isHomeSelected,
      this.observer})
      : super();

  @override
  _BundleOffersMenuState createState() => _BundleOffersMenuState(
      onSelected: onSelected,
      categoryProductList: categoryProductList,
      isHomeSelected: isHomeSelected,
      analytics: analytics,
      observer: observer);
}

class BundleOffersMenuItem extends StatefulWidget {
  final Product? product;

  final dynamic analytics;
  final dynamic observer;
  final String? isHomeSelected;

  BundleOffersMenuItem(
      {@required this.product,
      this.isHomeSelected,
      this.analytics,
      this.observer})
      : super();

  @override
  _BundleOffersMenuItemState createState() => _BundleOffersMenuItemState(
      product: product,
      analytics: analytics,
      observer: observer,
      isHomeSelected: isHomeSelected);
}

class _BundleOffersMenuItemState extends State<BundleOffersMenuItem> {
  Product? product;
  dynamic analytics;
  dynamic observer;
  String? isHomeSelected;
  final CartController cartController = Get.put(CartController());

  int? _qty;
  
  _BundleOffersMenuItemState(
      {this.product, this.isHomeSelected, this.analytics, this.observer});

  @override
  Widget build(BuildContext context) {
    print("NIKHIL BUNDLE ---------${product!.productName}------product id-----${product!.productId}");
    return Container(
      width: MediaQuery.of(context).size.width / 1.9,
      //height: 265,
      child: GetBuilder<CartController>(
        init: cartController,
        builder: (value) => Card(
          //margin: EdgeInsets.only(left: 8),

          color: Colors.transparent,
         
          
          elevation: 0,
          child: Stack(
            children: [
              Column(
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    elevation: 0,
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      
                      
                      // side: BorderSide(
                      //   color: ColorConstants.greyfaint,
                      //   width: 0.5,
                      // )
                    ),
                    // color: global.cardColor,
                    child: Container(
                      height: 175,
                      //margin: EdgeInsets.all(10),
                      
                      alignment: Alignment.center,
                      child: Stack(children: [
                        
                        ClipRRect(
                          
                           borderRadius: BorderRadius.only(topLeft:Radius.circular(100),
                      topRight: Radius.circular(100),),
                          child: Image.network(
                            product!.thumbnail != null &&
                                    product!.thumbnail!.isNotEmpty &&
                                    product!.thumbnail! != "N/A"
                                ? global.imageBaseUrl + product!.thumbnail!
                                : global.imageBaseUrl +
                                    product!.productImage! +
                                    "?width=500&height=500",
                            cacheWidth: 360,
                            fit: BoxFit.fitWidth,
                            width: MediaQuery.of(context).size.width ,
                            height: MediaQuery.of(context).size.height,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                  child: Image.asset(
                                global.noImage,
                              ));
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
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
                                      product!.varientId!);
                                  // // funOnTap();
                                  // _showToastWishlist(context);
                                  Navigator.pop(context);
                                  setState(() {});
                                }
                              },
                              child: product!.isFavourite!.toLowerCase() ==
                                      "true"
                                  ? Icon(
                                      MdiIcons.heart,
                                      size: 24,
                                      weight: 10,
                                      color: ColorConstants.newHeartFavorite,
                                    )
                                  : Icon(
                                      MdiIcons.heartOutline,
                                      size: 24,
                                      weight: 10,
                                      color: ColorConstants.newHeartFavorite,
                                    ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: false,
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: 210,
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
                                            bottomLeft: Radius.circular(10),
                                            topRight: Radius.circular(10)),
                                        color: ColorConstants
                                            .ratingContainerColor),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 18,
                                          color: Colors.yellow.shade400,
                                        ),
                                        Text(
                                          "${product!.rating}",
                                          style: TextStyle(
                                              fontFamily: global
                                                  .fontRailwayRegular,
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
                                            bottomRight: Radius.circular(10),
                                            topLeft: Radius.circular(10)),
                                        color: ColorConstants
                                            .ratingContainerColor),
                                    padding: EdgeInsets.only(
                                        bottom: 1, top: 1, left: 6, right: 6),
                                    child: Row(
                                      children: [
                                        Text(
                                            "${product!.countrating} Reviews", //"${product.countrating} Reviews",
                                            style: TextStyle(
                                                fontFamily: global
                                                    .fontRailwayRegular,
                                                fontSize: 11,
                                                color: ColorConstants.white)),
                                      ],
                                    ),
                                  ),
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
                        //               fontSize: 17,
                        //               color: ColorConstants.appColor),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ]),
                    ),
                  ),
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
                                margin: EdgeInsets.only(top: 1),
                                child: Text(
                                  "${product!.productName}",
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: global.fontRalewayMedium,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis,
                                      color: ColorConstants.pureBlack),
                                ),
                              ),
                              // product.productName.length < 18
                              //     ? SizedBox(height: 20)
                              //     : Container(),
                              // Container(
                              //   margin: EdgeInsets.only(top: 5, bottom: 5),
                              //   child: Text(
                              //     "${product.productName}",
                              //     maxLines: 1,
                              //     // "${categoryProductList[index].varient[0].description}",
                              //     style: TextStyle(
                              //         fontFamily: global.fontPhilosopher,
                              //         fontSize: 12,
                              //         overflow: TextOverflow.ellipsis,
                              //         color: ColorConstants.grey),
                              //   ),
                              // ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 8),
                                      child: Text(
                                        "AED",
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
                                                  .substring(product!
                                                          .price
                                                          .toString()
                                                          .indexOf(".") +
                                                      1)) >
                                              0
                                          ? "${product!.price!.toStringAsFixed(2)}"
                                          : "${product!.price.toString().substring(0, product!.price.toString().indexOf("."))}",
                                      //"${product.varient[0].basePrice.toString().substring(0, product.varient[0].basePrice.toString().indexOf("."))}",
                                      style: TextStyle(
                                          fontFamily:
                                              global.fontOufitMedium,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          color: ColorConstants.pureBlack),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    product!.price! <
                                            product!.mrp!
                                        ? Stack(children: [
                                            Container(
                                              margin: EdgeInsets.only(left: 2),
                                              padding: EdgeInsets.only(
                                                  top: 2, bottom: 2),
                                              child: Text(
                                                int.parse(product!
                                                            .mrp
                                                            .toString()
                                                            .substring(product!
                                                                    
                                                                    .mrp
                                                                    .toString()
                                                                    .indexOf(
                                                                        ".") +
                                                                1)) >
                                                        0
                                                    ? "${product!.mrp!.toStringAsFixed(2)}"
                                                    : "${product!.mrp.toString().substring(0, product!.mrp.toString().indexOf("."))}",
                                                //"${product.varient[0].baseMrp.toString().substring(0, product.varient[0].baseMrp.toString().indexOf("."))}",
                                                style: TextStyle(
                                                    fontFamily: global
                                                        .fontRailwayRegular,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w200,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 2),
                                              alignment: Alignment.center,
                                              // decoration: BoxDecoration(
                                              //     color: Colors.white.withOpacity(0.6),
                                              //     borderRadius: BorderRadius.circular(5)),
                                              //padding: const EdgeInsets.all(5),
                                              child: Center(
                                                child: Transform.rotate(
                                                  angle: 0,
                                                  child: Text(
                                                    "-----",
                                                    // '${AppLocalizations.of(context).txt_out_of_stock}',
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontFamily: global
                                                            .fontRailwayRegular,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ])
                                        : SizedBox(),
                                    // product.varient[0].discountper
                                    //                 .toString()
                                    //                 .length >
                                    //             0 &&
                                    //         product.varient[0].baseMrp
                                    //                 .toString()
                                    //                 .length >
                                    //             0
                                    //     ? Container(
                                    //         margin: EdgeInsets.only(left: 2),
                                    //         child: Text(
                                    //           product.varient[0].discountper
                                    //                   .toString()
                                    //                   .startsWith("-")
                                    //               ? "${product.varient[0].discountper.toString().substring(1)}% off"
                                    //               : "${product.varient[0].discountper}% off",
                                    //           style: TextStyle(
                                    //               fontFamily:
                                    //                   global.fontRailwayRegular,
                                    //               fontWeight: FontWeight.w200,
                                    //               fontSize: 12,
                                    //               color: ColorConstants.green),
                                    //         ),
                                    //       )
                                    //     : SizedBox(),
                                  ],
                                ),
                              ),

                              // product!.stock! > 0
                              //     ? Container(
                              //         margin: EdgeInsets.only(
                              //             top: 1, left: 3, right: 3),
                              //         child: Row(
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
                              //                 padding: EdgeInsets.all(5),
                              //                 decoration: BoxDecoration(
                              //                     borderRadius:
                              //                         BorderRadius.all(
                              //                             Radius.circular(10)),
                              //                     color: Colors.green.shade100),
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
                              //                             color: ColorConstants
                              //                                 .pureBlack),
                              //                       )
                              //                     : product!.delivery != null &&
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
                              //                                 fontSize: 11,
                              //                                 color:
                              //                                     ColorConstants
                              //                                         .pureBlack),
                              //                           )
                              //                         : product!.delivery !=
                              //                                     null &&
                              //                                 product!.delivery ==
                              //                                     "3"
                              //                             ? Text(
                              //                                 "Tomorrow",
                              //                                 style: TextStyle(
                              //                                     fontFamily: global
                              //                                         .fontRailwayRegular,
                              //                                     fontWeight:
                              //                                         FontWeight
                              //                                             .w200,
                              //                                     fontSize: 10,
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
                              //                                     fontFamily: global
                              //                                         .fontRailwayRegular,
                              //                                     fontWeight:
                              //                                         FontWeight
                              //                                             .w200,
                              //                                     fontSize: 10,
                              //                                     color: ColorConstants
                              //                                         .pureBlack),
                              //                               )),
                              //           ],
                              //         ),
                              //       )
                              //     : Container(),
                            ],
                          ),
                        ),
                        // Container(
                        //   margin: EdgeInsets.only(left: 5, right: 5),
                        //   color: Colors.black,
                        //   height: 80,
                        //   width: 0.5,
                        // ),
                      ],
                    ),
                  )
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
  }

  showOnlyLoaderDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Center(child: new CircularProgressIndicator()),
        );
      },
    );
  }

  APIHelper apiHelper = APIHelper();
  Future<bool> addRemoveWishList(int varientId) async {
    bool _isAddedSuccesFully = false;
    try {
      showOnlyLoaderDialog();
      await apiHelper.addRemoveWishList(varientId).then((result) async {
        if (result != null) {
          if (result.status == "1" || result.status == "2") {
            if (result.status == "1") {
              product!.isFavourite = "true";
            } else {
              product!.isFavourite = "false";
            }
            _isAddedSuccesFully = true;
            Navigator.pop(context);
          } else {
            _isAddedSuccesFully = false;
            Navigator.pop(context);
            showSnackBar(snackBarMessage: 'Please try again after some time ');
          }
        }
      });
      return _isAddedSuccesFully;
    } catch (e) {
      print("Exception - bundle_offers_menu.dart - addRemoveWishList():" +
          e.toString());
      return _isAddedSuccesFully;
    }
  }

  void showSnackBar({String? snackBarMessage}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        snackBarMessage!,
        textAlign: TextAlign.center,
      ),
      duration: Duration(seconds: 2),
    ));
    showToast(snackBarMessage);
  }
}

class _BundleOffersMenuState extends State<BundleOffersMenu> {
  List<Product>? categoryProductList;
  Function(int)? onSelected;
  dynamic analytics;
  dynamic observer;
  APIHelper apiHelper = APIHelper();
  String? isHomeSelected;

  _BundleOffersMenuState(
      {this.onSelected,
      this.categoryProductList,
      this.isHomeSelected,
      this.analytics,
      this.observer});

  // Future<bool> addRemoveWishList(int varientId) async {
  //   bool _isAddedSuccesFully = false;
  //   try {
  //     showOnlyLoaderDialog();
  //     await apiHelper.addRemoveWishList(varientId).then((result) async {
  //       if (result != null) {
  //         if (result.status == "1" || result.status == "2") {
  //           _isAddedSuccesFully = true;
  //           Navigator.pop(context);
  //         } else {
  //           _isAddedSuccesFully = false;
  //           Navigator.pop(context);
  //           showSnackBar(
  //               snackBarMessage:
  //                   '${AppLocalizations.of(context).txt_please_try_again_after_sometime} ');
  //         }
  //       }
  //     });
  //     return _isAddedSuccesFully;
  //   } catch (e) {
  //     print("Exception - bundle_offers_menu.dart - addRemoveWishList():" +
  //         e.toString());
  //     return _isAddedSuccesFully;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.only(left: 8),
      // height: MediaQuery.of(context).size.width * 1 / 2 / 1,
      //height: MediaQuery.of(context).size.width * 1.2 / 2 / 1,
      child: ListView.builder(
          padding: EdgeInsets.only(bottom: 20),
          // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 2,
          //     crossAxisSpacing: 0.1,
          //     childAspectRatio: 1.36,
          //     mainAxisSpacing: 1.1
          //     ),
          scrollDirection: Axis.horizontal,
          itemCount: categoryProductList!.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                if (categoryProductList![index].stock! > 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDescriptionScreen(
                        a: widget.analytics,
                        o: widget.observer,
                        productId: categoryProductList![index].productId,
                      ),
                    ),
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: "Currently Product Out Of Stock", // message
                    toastLength: Toast.LENGTH_SHORT, // length
                    gravity: ToastGravity.CENTER, // location
                    // duration
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 1),
                child: Stack(
                  children: [
                    BundleOffersMenuItem(
                      product: categoryProductList![index],
                      analytics: widget.analytics,
                      observer: widget.observer,
                    ),
                    categoryProductList![index].stock! > 0
                        ? Positioned(
                            left: 4,
                            top: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(1),
                              child: categoryProductList![index].discount !=
                                          null &&
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
                                              fontFamily:
                                                  global.fontRailwayRegular,
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
                            child: Padding(
                              padding: const EdgeInsets.all(1),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Center(
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: ColorConstants.grey,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color:
                                                ColorConstants.allBorderColor)),
                                    child: Text(
                                      "Sold Out",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 15,
                                          fontFamily:
                                              global.fontRailwayRegular,
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
          }),
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
          child: Center(child: new CircularProgressIndicator()),
        );
      },
    );
  }
}
