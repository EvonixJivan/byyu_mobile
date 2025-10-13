import 'dart:math';

import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';
import 'package:byyu/controllers/cart_controller.dart';
import 'package:byyu/models/apply_coupon.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/couponsModel.dart';
import 'package:byyu/models/orderModel.dart';
import 'package:byyu/widgets/coupon_card.dart';
import 'package:byyu/widgets/my_text_field.dart';

class CouponsScreen extends BaseRoute {
  final int? screenId;
  final int? screenIdO;
  final String? cartId;
  final CartController? cartController;
  final int? total_delivery;
  bool? fromDrawer = false;

  CouponsScreen(
      {a,
      o,
      this.screenId,
      this.cartId,
      this.cartController,
      this.fromDrawer,
      this.screenIdO,
      this.total_delivery})
      : super(a: a, o: o, r: 'CouponsScreen');

  @override
  _CouponsScreenState createState() => _CouponsScreenState(
      screenId: screenId,
      cartId: cartId,
      cartController: cartController,
      screenIdO: screenIdO,
      fromDrawer: fromDrawer,
      total_delivery: total_delivery);
}

class _CouponsScreenState extends BaseRouteState {
  List<Coupon> _couponList = [];
  bool _isDataLoaded = false;
  CartController? cartController;
  final Color color = const Color(0xffFF0000);
  GlobalKey<ScaffoldState>? _scaffoldKey;
  int? screenId;
  int? screenIdO;
  String? cartId;
  String? _selectedCouponCode;
  bool isTextEnteredCoupon = false;
  Order? order;
  int? total_delivery;
  var _txtApplyCoupan = new TextEditingController();
  FocusNode _fCoupan = new FocusNode();
  GlobalKey<ScaffoldState>? _scaffoldKey1;
  bool? fromDrawer = false;
  List<String> colorCodes = [
    "#ACDDDE",
    "#CAF1DE",
    "#E1F8DC",
    "#FEF8DD",
    "#FFE7C7",
    "#F7D8BA"
  ];
  _CouponsScreenState(
      {this.screenId,
      this.cartId,
      this.cartController,
      this.fromDrawer,
      this.screenIdO,
      this.total_delivery});

  @override
  Widget build(BuildContext context) {
    // print("this is from drawer gggggggggg ${fromDrawer}");
    return Scaffold(
        backgroundColor: ColorConstants.colorPageBackground,
        key: _scaffoldKey1,
        appBar: AppBar(
          backgroundColor: ColorConstants.appBarColorWhite,
          centerTitle: false,
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
          title: Text(
            "My Coupons",
            style: TextStyle(
                fontFamily: global.fontMontserratMedium,
                fontWeight: FontWeight.normal,
                color: ColorConstants.pureBlack),
          ),
        ),
        //mycoupons_logo
        body: SafeArea(
          top: false,
          bottom: true,
          child: Container(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(child: Container()),
                    Container(),
                  ],
                ),
                Column(
                  children: [
                    // Container(
                    //   width: MediaQuery.of(context).size.width - 20,
                    //   child: InkWell(
                    //     onTap: () {
                    //       showModalBottomSheet(
                    //           backgroundColor: Colors.transparent,
                    //           context: context,
                    //           builder: (BuildContext context) {
                    //             return Container(
                    //               height: MediaQuery.of(context).size.width / 2.5,
                    //               decoration: BoxDecoration(
                    //                   color: ColorConstants.white,
                    //                   borderRadius: BorderRadius.only(
                    //                       topLeft: Radius.circular(8),
                    //                       topRight: Radius.circular(8))),
                    //               child: Padding(
                    //                 padding: const EdgeInsets.all(8.0),
                    //                 child: Column(
                    //                   children: [
                    //                     Row(
                    //                       children: [
                    //                         Container(
                    //                             width: MediaQuery.of(context)
                    //                                     .size
                    //                                     .width /
                    //                                 6,
                    //                             height: MediaQuery.of(context)
                    //                                     .size
                    //                                     .width /
                    //                                 9,
                    //                             decoration: BoxDecoration(
                    //                                 gradient: LinearGradient(
                    //                                     begin: Alignment
                    //                                         .bottomCenter,
                    //                                     end: Alignment.topCenter,
                    //                                     colors: [
                    //                                       ColorConstants
                    //                                           .oDGradientbottom,
                    //                                       ColorConstants
                    //                                           .orderDetailGradientTop,
                    //                                     ]),
                    //                                 borderRadius:
                    //                                     BorderRadius.circular(10),
                    //                                 border: Border.all(
                    //                                   width: 2,
                    //                                   color: ColorConstants
                    //                                       .orderDtailBorder,
                    //                                 )),
                    //                             child: Center(
                    //                               child: Image.asset(
                    //                                 'assets/images/green_tick.png',
                    //                                 width: 25,
                    //                                 height: 25,
                    //                               ),
                    //                             )),
                    //                         SizedBox(
                    //                           width: 15,
                    //                         ),
                    //                         Container(
                    //                           width: MediaQuery.of(context)
                    //                                   .size
                    //                                   .width /
                    //                               2,
                    //                           child: Text(
                    //                             "Add Items to your cart and go to checkout screen",
                    //                             // textAlign: TextAlign.center,
                    //                             maxLines: 2,
                    //                             style: TextStyle(
                    //                                 fontFamily:
                    //                                     fontRailwayRegular,
                    //                                 fontSize: 13,
                    //                                 color:
                    //                                     ColorConstants.pureBlack,
                    //                                 fontWeight: FontWeight.bold),
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                     Padding(
                    //                       padding:
                    //                           EdgeInsets.only(top: 5, bottom: 5),
                    //                       child: Text(''),
                    //                     ),
                    //                     Row(
                    //                       children: [
                    //                         Container(
                    //                             width: MediaQuery.of(context)
                    //                                     .size
                    //                                     .width /
                    //                                 6,
                    //                             height: MediaQuery.of(context)
                    //                                     .size
                    //                                     .width /
                    //                                 9,
                    //                             decoration: BoxDecoration(
                    //                                 gradient: LinearGradient(
                    //                                     begin: Alignment
                    //                                         .bottomCenter,
                    //                                     end: Alignment.topCenter,
                    //                                     colors: [
                    //                                       ColorConstants
                    //                                           .oDGradientbottom,
                    //                                       ColorConstants
                    //                                           .orderDetailGradientTop,
                    //                                     ]),
                    //                                 borderRadius:
                    //                                     BorderRadius.circular(10),
                    //                                 border: Border.all(
                    //                                   width: 2,
                    //                                   color: ColorConstants
                    //                                       .orderDtailBorder,
                    //                                 )),
                    //                             child: Center(
                    //                               child: Image.asset(
                    //                                 'assets/images/green_tick.png',
                    //                                 width: 25,
                    //                                 height: 25,
                    //                               ),
                    //                             )),
                    //                         SizedBox(
                    //                           width: 15,
                    //                         ),
                    //                         Container(
                    //                           width: MediaQuery.of(context)
                    //                                   .size
                    //                                   .width /
                    //                               2,
                    //                           child: Text(
                    //                             "On checkout screen you will be able to select coupon which will be added to your order",
                    //                             // textAlign: TextAlign.center,
          
                    //                             style: TextStyle(
                    //                                 fontFamily:
                    //                                     fontRailwayRegular,
                    //                                 fontSize: 13,
                    //                                 color:
                    //                                     ColorConstants.pureBlack,
                    //                                 fontWeight: FontWeight.bold),
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //             );
                    //           });
                    //     },
                    //     child: Text(
                    //       "How To Apply..",
                    //       style: TextStyle(
                    //           fontFamily: global.fontMontserratLight,
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.w200,
                    //           color: ColorConstants.appColor),
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      child: _isDataLoaded
                          ? _couponList.length > 0
                              ? RefreshIndicator(
                                  onRefresh: () async {
                                    await _onRefresh();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 10, right: 10, bottom: 10),
                                    child: ListView.builder(
                                        itemCount: _couponList
                                            .length, //_couponList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          print("hello${_couponList.length}");
                                          print("hello${index}");
                                          print(fromDrawer);
                                          return CouponsCard(
                                            fromDrawer: fromDrawer,
                                            coupon: _couponList[index],
                                            onRedeem: () async {
                                              _selectedCouponCode =
                                                  _couponList[index].couponCode!;
                                              setState(() {});
                                              isTextEnteredCoupon = false;
                                              // if (screenId == 0) {
                                              await _applyCoupon(
                                                  _selectedCouponCode!);
                                            },
                                          );
                                        }),
                                  ),
                                )
                              : Center(
                                  child: Text(
                                  'No Coupons Available',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: global.fontRalewayMedium,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: ColorConstants.newTextHeadingFooter),
                                ))
                          : Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  _alertForCouponCode(String msg) async {
    print('G1--->${msg}');
    try {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(dialogBackgroundColor: Colors.white),
              child: CupertinoAlertDialog(
                content: Text(
                  '${msg} ',
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('OK',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: fontRailwayRegular,
                            fontWeight: FontWeight.w200,
                            color: Colors
                                .blue)), //${AppLocalizations.of(context).btn_ok}'),
                    onPressed: () async {
                      Navigator.of(context).pop(true);
                      // Navigator.popUntil(context, ModalRoute.withName("PaymentGatewayScreen"));
                    },
                  ),
                ],
              ),
            );
          });
    } catch (e) {
      print('Exception - app_menu_screen.dart - exitAppDialog(): ' +
          e.toString());
    }
  }

  _applyCoupon(String couponCode) async {
    showOnlyLoaderDialog();
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        await apiHelper
            .applyCoupon(
                cartId: cartId,
                couponCode: couponCode,
                user_id: global.currentUser.id.toString(),
                total_delivery: global.total_delivery_count)
            .then((result) async {
          if (result != null) {
            if (result.status == "1") {
              print("this is the result data in coupons screen ${result.data}");
              CouponCode couponCode1 = result.data;
              couponCode1.coupon_code = couponCode;
              var discounted_amount = couponCode1.discounted_amount;
              var save_amount = couponCode1.save_amount;
              var coupon_id = couponCode1.coupon_id;
              print(discounted_amount);
              print(save_amount);
              hideLoader();
              // showSnackBar(key: _scaffoldKey, snackBarMessage: result.message);
              // if (!isTextEnteredCoupon) {
              //   Navigator.of(context).pop();
              // }
              Navigator.of(context).pop(couponCode1);
            } else {
              // Navigator.of(context).pop();
              hideLoader();
              order = null;
              // showSnackBar(key: _scaffoldKey, snackBarMessage: result.message);
              _alertForCouponCode(result.message);
              // Navigator.of(context).pop();
            }
          }
        });
      } else {
        hideLoader();
        showNetworkErrorSnackBar(_scaffoldKey!);
      }

      setState(() {});
    } catch (e) {
      hideLoader();
      print("Exception - coupons_screen.dart - _applyCoupon():" + e.toString());
    }
  }

  _getCouponsList() async {
    _couponList.clear();
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        await apiHelper
            .getCoupons(store_id: cartId, total_delivery: total_delivery)
            .then((result) async {
          if (result != null) {
            if (result.status == "1") {
              List<Coupon> cuplist = result.data;
              _couponList.addAll(cuplist);
            }
          }
        });
      } else {
        print("Nikhil---------------------3");
        showNetworkErrorSnackBar(_scaffoldKey!);
      }

      setState(() {});
    } catch (e) {
      print("Nikhil---------------------4");
      print("Exception - coupons_screen.dart - _getCouponsList():" +
          e.toString());
    }
  }

  _init() async {
    try {
      await _getCouponsList();
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - coupons_screen.dart - _init():" + e.toString());
    }
  }

  _onRefresh() async {
    try {
      _isDataLoaded = false;
      setState(() {});
      await _init();
    } catch (e) {
      print("Exception - coupons_screen.dart - _onRefresh():" + e.toString());
    }
  }

  _shimmer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: 4,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.18,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      elevation: 0,
                    ));
              })),
    );
  }
}
