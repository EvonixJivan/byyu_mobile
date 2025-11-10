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
    print("Nikhil ADD TO CART RO");
    try {
      bool isSuccess = false;
      String message = '--';
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
          // cartController.getCartList();
          _getCartList1();
          // homeScreenSetState();
          setState(() {});
        } else {
          isSuccess = false;
          message = 'Something went wrong please try after some time';
        }
      });
      // return ATCMS(isSuccess: isSuccess, message: message);
    } catch (e) {
      print("Exception -  cart_controller.dart - addToCart():d" + e.toString());
      return null;
    }
  }

  _getCartList1() async {
    try {
      print("Nikhil----get cart list---");
      await cartController!.getCartList();
      if (cartController!.isDataLoaded.value == true) {
        print("Cart Screen Outer IF condition");

        if (global.cartItemsPresent) {
          print("Inner IF condition");
          hideloader();
          cartItemsPresent = true;
          global.cartItemsPresent = true;
        } else {
          hideloader();
          print("Inner else condition");
          cartItemsPresent = false;
          global.cartItemsPresent = false;
        }
      } else {
        print("outer else condition");
        hideloader();
        cartItemsPresent = false;
        global.cartItemsPresent = false;
      }
      homeScreenSetState!();
      setState(() {
        //hideLoader();
      });
    } catch (e) {
      hideloader();
      print(
          "Exception -  cart_screen.dart - _getCartList123():" + e.toString());
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
              //showOnlyLoaderDialog();
              //ATCMS isSuccess;
              print("Nikhil swipe ");
              addToCartRO1(
                  cartController!
                      .cartItemsList.cartData!.cartProductdata![index],
                  0,
                  true,
                  "0");

              // if (isSuccess.isSuccess != null) {
              //   Navigator.of(context).pop();
              // }

              setState(() {});
            },
            background: _backgroundContainer(context, screenHeight),
            child: InkWell(
              onTap: () {
                if (cartController != null &&
                    cartController!.cartItemsList != null &&
                    cartController!.cartItemsList.cartData != null &&
                    cartController!.cartItemsList.cartData!.cartProductdata !=
                        null &&
                    cartController!.cartItemsList.cartData!
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
              // child: CartMenuItem(
              //   product: cartController!.cartItemsList.cartData!.cartProductdata![index],
              //   cartController: cartController!,
              //   index: index,
              //   cartQty: cartController!
              //       .cartItemsList.cartData!.cartProductdata![index].cartQty!,
              //   homeScreenSetState: homeScreenSetState!,
              //   listSetState: listSetState,
              //   showLoading: showOnlyLoaderDialog,
              //   hideLoading: hideloader,

              // ),
              child:  Container(
      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(width: 0.1)),
      // height: 100 * screenHeight / 800,
      // height:
      //     cartController.cartItemsList.cartList[index].stock == 0 ? 230 : 210,
      // height: 210,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
                color: cartController!.cartItemsList.cartData!.cartProductdata![index]!.isTimeValid == 1
                    ? ColorConstants.appColor
                    : ColorConstants.white)),
        color: ColorConstants.white,
        elevation: 1,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  //MediaQuery.of(context).size.width - 10,
                  child: CachedNetworkImage(
                    width: 130,
                    height: 130,
                    fit: BoxFit.cover,
                    imageUrl: global.imageBaseUrl +
                        cartController!.cartItemsList.cartData!.cartProductdata![index]!.productImage! +
                        "?width=500&height=500",
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      child: Image.asset(
                        global.noImage,
                        fit: BoxFit.fill,
                        width: 175,
                        height: 210,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Flexible(
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          Container(
                            width: (MediaQuery.of(context).size.width / 2) + 10,
                            child: Text(
                              cartController!.cartItemsList.cartData!.cartProductdata![index]!.productName!,
                              //product.productName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontFamily: fontRailwayRegular,
                                  fontWeight: FontWeight.w200,
                                  color: ColorConstants.pureBlack,
                                  fontSize: 16),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "AED ",
                                // "${global.appInfo.currencySign}",
                                //${_productDetail.productDetail.varient[i].quantity} ${_productDetail.productDetail.varient[i].unit} /
                                style: TextStyle(
                                    fontFamily: fontRailwayRegular,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w200,
                                    color: ColorConstants.pureBlack),
                              ),
                              // Text(
                              //   //" 30.00",
                              //   "${product!.price!.toStringAsFixed(2)}",
                              //   style: TextStyle(
                              //       fontFamily: fontMontserratLight,
                              //       fontSize: 16,
                              //       fontWeight: FontWeight.w400,
                              //       color: ColorConstants.pureBlack),
                              // ),
                              Text(
                                //" 30.00",
                                "${cartController!.cartItemsList.cartData!.cartProductdata![index]!.price!.toStringAsFixed(2)}",
                                style: TextStyle(
                                    fontFamily: fontMontserratLight,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: ColorConstants.pureBlack),
                              ),
                              cartController!.cartItemsList.cartData!.cartProductdata![index]!.price! < cartController!.cartItemsList.cartData!.cartProductdata![index]!.mrp!
                                  ? Stack(children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 5),
                                        padding:
                                            EdgeInsets.only(top: 2, bottom: 2),
                                        child: Text(
                                          int.parse(cartController!.cartItemsList.cartData!.cartProductdata![index]!.mrp
                                                      .toString()
                                                      .substring(cartController!.cartItemsList.cartData!.cartProductdata![index]!.mrp
                                                              .toString()
                                                              .indexOf(".") +
                                                          1)) >
                                                  0
                                              ? "${cartController!.cartItemsList.cartData!.cartProductdata![index]!.mrp!.toStringAsFixed(2)}"
                                              : "${cartController!.cartItemsList.cartData!.cartProductdata![index]!.mrp!.toString().substring(0, cartController!.cartItemsList.cartData!.cartProductdata![index]!.mrp.toString().indexOf("."))}",
                                          //"${product.varient[0].baseMrp}",
                                          style: TextStyle(
                                              fontFamily:
                                                  global.fontRailwayRegular,
                                              fontWeight: FontWeight.w200,
                                              fontSize: 13,
                                              color: Colors.grey),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 5),
                                        alignment: Alignment.center,
                                        child: Center(
                                          child: Transform.rotate(
                                            angle: 0,
                                            child: Text(
                                              "----",
                                              // '${AppLocalizations.of(context).txt_out_of_stock}',
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontFamily: global
                                                      .fontRailwayRegular,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ])
                                  : Container(),
                            ],
                          ),
                          SizedBox(height: 8),
                          cartController!.cartItemsList.cartData!.cartProductdata![index]!.eggEggless != null &&
                                  cartController!.cartItemsList.cartData!.cartProductdata![index]!.eggEggless!.length > 0
                              ? Row(
                                  children: [
                                    Text(
                                      "Type : ",
                                      // "${global.appInfo.currencySign}",
                                      //${_productDetail.productDetail.varient[i].quantity} ${_productDetail.productDetail.varient[i].unit} /
                                      style: TextStyle(
                                          fontFamily: fontRailwayRegular,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w200,
                                          color: ColorConstants.pureBlack),
                                    ),
                                    Text(
                                      cartController!.cartItemsList.cartData!.cartProductdata![index]!.eggEggless != null &&
                                              cartController!.cartItemsList.cartData!.cartProductdata![index]!.eggEggless! == "egg"
                                          ? "With Egg"
                                          : cartController!.cartItemsList.cartData!.cartProductdata![index]!.eggEggless != null &&
                                                  cartController!.cartItemsList.cartData!.cartProductdata![index]!.eggEggless! ==
                                                      "eggless"
                                              ? "Eggless"
                                              : "",
                                      style: TextStyle(
                                          fontFamily: fontRailwayRegular,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w200,
                                          color: ColorConstants.pureBlack),
                                    ),
                                  ],
                                )
                              : SizedBox(height: 14),
                          SizedBox(height: 8),
                          cartController!.cartItemsList.cartData!.cartProductdata![index]!.flavour != null &&
                                  cartController!.cartItemsList.cartData!.cartProductdata![index]!.flavour!.trim().length > 0
                              ? Row(
                                  children: [
                                    Text(
                                      "Flavour : ",
                                      // "${global.appInfo.currencySign}",
                                      //${_productDetail.productDetail.varient[i].quantity} ${_productDetail.productDetail.varient[i].unit} /
                                      style: TextStyle(
                                          fontFamily: fontRailwayRegular,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w200,
                                          color: ColorConstants.pureBlack),
                                    ),
                                    // Text(
                                    //   //" 30.00",
                                    //   "${product!.price!.toStringAsFixed(2)}",
                                    //   style: TextStyle(
                                    //       fontFamily: fontMontserratLight,
                                    //       fontSize: 16,
                                    //       fontWeight: FontWeight.w400,
                                    //       color: ColorConstants.pureBlack),
                                    // ),
                                    Text(
                                      //" 30.00",
                                      cartController!.cartItemsList.cartData!.cartProductdata![index]!.flavour != null &&
                                              cartController!.cartItemsList.cartData!.cartProductdata![index]!.flavour!.trim().length >
                                                  0
                                          ? cartController!.cartItemsList.cartData!.cartProductdata![index]!.flavour!.trim()
                                          : "",
                                      style: TextStyle(
                                          fontFamily: fontRailwayRegular,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w200,
                                          color: ColorConstants.pureBlack),
                                    ),
                                  ],
                                )
                              : SizedBox(height: 14),
                          SizedBox(height: 12),
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Quantity:",
                                  style: TextStyle(
                                    fontFamily: global.fontRailwayRegular,
                                    fontWeight: FontWeight.w200,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                InkWell(
                                  onTap: () {
                                    // if (_qty > 1) {
                                    //   _qty = _qty - 1;
                                    // }
                                    // if (cartController!.cartItemsList.cartData!.cartProductdata![index].cartQty! - 1 == 0) {
                                    //   cartController!.cartItemsList.cartData!
                                    //       .cartProductdata!
                                    //       .removeAt(index!);
                                    //   listSetState!();
                                    // }
                                    if (cartController!.cartItemsList.cartData!.cartProductdata![index].cartQty! >= 1) {
                                      cartController!.cartItemsList.cartData!.cartProductdata![index].cartQty = cartController!.cartItemsList.cartData!.cartProductdata![index].cartQty! - 1;

                                      addToCartRO1(
                                          cartController!.cartItemsList.cartData!.cartProductdata![index]!, cartController!.cartItemsList.cartData!.cartProductdata![index].cartQty!, true, "0");
                                    }
                                    setState(() {});
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 5),
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                        color: ColorConstants.appColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Icon(
                                      cartController!.cartItemsList.cartData!.cartProductdata![index].cartQty! > 1
                                          ? MdiIcons.minus
                                          : MdiIcons.trashCan,
                                      size: 20,
                                      color: ColorConstants.white,
                                    ),
                                  ),
                                ),
                                Text(
                                  cartController!.cartItemsList.cartData!.cartProductdata![index].cartQty !=null && cartController!.cartItemsList.cartData!.cartProductdata![index].cartQty!>0?
                                  "${cartController!.cartItemsList.cartData!.cartProductdata![index].cartQty}":"1",
                                  // _qty != null
                                  //     ? "1"
                                  //     : "${product.cartQty}",
                                  style: TextStyle(
                                    fontFamily: global.fontRailwayRegular,
                                    fontWeight: FontWeight.w200,
                                    fontSize: 16,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    cartController!.cartItemsList.cartData!.cartProductdata![index].cartQty = cartController!.cartItemsList.cartData!.cartProductdata![index].cartQty! + 1;
                                    addToCartRO1(
                                        cartController!.cartItemsList.cartData!.cartProductdata![index]!, cartController!.cartItemsList.cartData!.cartProductdata![index].cartQty!, true, "0");

                                    setState(() {});
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: 5),
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                        color: ColorConstants.appColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Icon(
                                      MdiIcons.plus,
                                      size: 20,
                                      color: ColorConstants.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
              child: Divider(thickness: 1),
            ),
            // SizedBox(height: 10),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    cartController!.cartItemsList.cartData!.cartProductdata![index]!.selectedMessage != null
                        ? Container(
                            width: MediaQuery.of(context).size.width - 20,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    "Message:",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontFamily: fontRailwayRegular,
                                        fontWeight: FontWeight.normal,
                                        color: ColorConstants.pureBlack,
                                        fontSize: 12),
                                  ),
                                ),
                                SizedBox(width: 3),
                                Expanded(
                                  child: Text(
                                    // May be usefuk
                                    " ${cartController!.cartItemsList.cartData!.cartProductdata![index]!.selectedMessage}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: fontRailwayRegular,
                                        fontWeight: FontWeight.normal,
                                        color: ColorConstants.pureBlack,
                                        fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                    SizedBox(
                      height: cartController!.cartItemsList.cartData!.cartProductdata![index]!.selectedMessage != null &&
                              cartController!.cartItemsList.cartData!.cartProductdata![index]!.selectedMessage!.length > 0
                          ? 8
                          : 0,
                    ),
                    Text(
                      "Delivery date: ${cartController!.cartItemsList.cartData!.cartProductdata![index]!.delivery_date}",
                      style: TextStyle(
                          fontFamily: fontRailwayRegular,
                          fontWeight: FontWeight.normal,
                          color: cartController!.cartItemsList.cartData!.cartProductdata![index]!.isTimeValid == 1
                              ? ColorConstants.appColor
                              : ColorConstants.pureBlack,
                          fontSize: 12),
                    ),
                    SizedBox(height: 3),
                    Text(
                      cartController!.cartItemsList.cartData!.cartProductdata![index] != null &&
                              cartController!.cartItemsList.cartData!.cartProductdata![index]!.deliveryType != null &&
                              cartController!.cartItemsList.cartData!.cartProductdata![index]!.deliveryType == "1"
                          ? "Delivery within 120 minutes"
                          : "Time: ${cartController!.cartItemsList.cartData!.cartProductdata![index]!.delivery_time}",
                      style: TextStyle(
                          fontFamily: fontRailwayRegular,
                          fontWeight: cartController!.cartItemsList.cartData!.cartProductdata![index] != null &&
                                  cartController!.cartItemsList.cartData!.cartProductdata![index]!.deliveryType != null &&
                                  cartController!.cartItemsList.cartData!.cartProductdata![index]!.deliveryType == "1"
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: ColorConstants.pureBlack,
                          fontSize: 12),
                    ),
                    SizedBox(height: cartController!.cartItemsList.cartData!.cartProductdata![index]!.isTimeValid == 1 ? 5 : 8),
                    Visibility(
                      visible: cartController!.cartItemsList.cartData!.cartProductdata![index]!.isTimeValid == 1,
                      child: Text(
                        "Invalid delivery date click to update",
                        style: TextStyle(
                            fontFamily: fontRailwayRegular,
                            fontWeight: cartController!.cartItemsList.cartData!.cartProductdata![index] != null &&
                                    cartController!.cartItemsList.cartData!.cartProductdata![index]!.deliveryType != null &&
                                    cartController!.cartItemsList.cartData!.cartProductdata![index]!.deliveryType == "1"
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: ColorConstants.appColor,
                            fontSize: 12),
                      ),
                    ),
                    SizedBox(height: cartController!.cartItemsList.cartData!.cartProductdata![index]!.isTimeValid == 1 ? 8 : 0),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    )
 ,
            ),
          ),
        );
      },
    );
  }

  listSetState() {
    // if(showLoading){
    //   showOnlyLoaderDialog();
    // }else{
    //   hideloader();
    // }

    setState(() {});
  }

  showOnlyLoaderDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false, // false
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

  Widget _backgroundContainer(BuildContext context, double screenHeight) {
    return Column(
      children: [
        SizedBox(height: 8),
        Wrap(
          children: [
            Container(
              height: 80 * screenHeight / 830,
              color: Theme.of(context).colorScheme.error,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
