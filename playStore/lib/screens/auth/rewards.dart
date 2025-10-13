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

class RewardsScreen extends BaseRoute {
  RewardsScreen({
    a,
    o,
  }) : super(a: a, o: o, r: 'CouponsScreen');

  @override
  _RewardsScreenState createState() => _RewardsScreenState();
}

class _RewardsScreenState extends BaseRouteState {
  List<Coupon>? _couponList = [];
  bool? _isDataLoaded = false;
  CartController? cartController;
  final Color color = const Color(0xffFF0000);
  GlobalKey<ScaffoldState>? _scaffoldKey;
  int? screenId;
  int? screenIdO;
  String? cartId;
  String? _selectedCouponCode;
  Order? order;
  int? total_delivery;
  var _txtApplyCoupan = new TextEditingController();
  FocusNode _fCoupan = new FocusNode();
  GlobalKey<ScaffoldState>? _scaffoldKey1;
  bool fromDrawer = false;
  List<String> colorCodes = [
    "#ACDDDE",
    "#CAF1DE",
    "#E1F8DC",
    "#FEF8DD",
    "#FFE7C7",
    "#F7D8BA"
  ];

  @override
  Widget build(BuildContext context) {
    // print("this is fromdrawer ${fromDrawer}");
    return Scaffold(
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
            "Rewards",
            style: TextStyle(
                fontFamily: global.fontMontserratMedium,
                fontWeight: FontWeight.normal,
                color: ColorConstants.pureBlack),
          ),
        ),
        //mycoupons_logo
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/login_background.png"),
                  fit: BoxFit.cover)),
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
                  Expanded(
                    child: _isDataLoaded!
                        ? _couponList != null && _couponList!.length > 0
                            ? RefreshIndicator(
                                onRefresh: () async {
                                  await _onRefresh();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, top: 10, right: 10, bottom: 10),
                                  child: ListView.builder(
                                      itemCount: 6, //_couponList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          padding: const EdgeInsets.all(0.0),
                                          height: 100,
                                          width: 500.0,
                                          // alignment: FractionalOffset.center,
                                          child: new Stack(
                                            //alignment:new Alignment(x, y)
                                            children: <Widget>[
                                              new Positioned(
                                                left: 20.0,
                                                child: Card(
                                                  elevation: 1,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color: ColorConstants
                                                          .appfaintColor,
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 5,
                                                                  left: 60),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Reward points",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        fontRailwayRegular,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 5,
                                                                  left: 60),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "3x points",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        fontRailwayRegular,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    color: ColorConstants
                                                                        .appColor),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 10,
                                                                  left: 60),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Expiry: OCT 30 2023",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        fontRailwayRegular,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    color:
                                                                        ColorConstants
                                                                            .grey,
                                                                    fontSize:
                                                                        10),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    height: 80,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            60,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 20,
                                                left: 0,
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(top: 0),
                                                  height:
                                                      50, //MediaQuery.of(context).size.height / 4.46,
                                                  width:
                                                      50, //MediaQuery.of(context).size.width / 1.96,
                                                  child: Image.asset(
                                                    'assets/images/trophy.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                              )
                            : Center(
                                child: Text(
                                  'No Coupons Available',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: global.fontMontserratLight,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w200,
                                      color: ColorConstants.guidlinesGolden),
                                ),
                              )
                        : _shimmer(),
                  ),
                ],
              ),
            ],
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
                title: Text(
                  'byyu',
                ),
                content: Text(
                  '${msg} ',
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(
                        // '${AppLocalizations.of(context).btn_ok}'
                        "OK",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: fontRailwayRegular,
                            fontWeight: FontWeight.w200,
                            color: Colors.blue)),
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
              CouponCode couponCode = result.data;
              var discounted_amount = couponCode.discounted_amount;
              var save_amount = couponCode.save_amount;
              var coupon_id = couponCode.coupon_id;
              print(discounted_amount);
              print(save_amount);
              showSnackBar(key: _scaffoldKey, snackBarMessage: result.message);
              Navigator.of(context).pop(couponCode);
            } else {
              // Navigator.of(context).pop();
              order = null;
              // showSnackBar(key: _scaffoldKey, snackBarMessage: result.message);
              _alertForCouponCode(result.message);
              // Navigator.of(context).pop();
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey!);
      }

      setState(() {});
    } catch (e) {
      print("Exception - coupons_screen.dart - _applyCoupon():" + e.toString());
    }
  }

  _getCouponsList() async {
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        if (screenId == 0) {
          await apiHelper
              .getCoupons(store_id: cartId, total_delivery: total_delivery)
              .then((result) async {
            if (result != null) {
              if (result.status == "1") {
                //_couponList = result.data;
                print("Nikhil---------------------1");
                Coupon coupon = new Coupon();
                coupon.couponId = 1;
                coupon.couponCode = "123";
                coupon.couponDescription =
                    "This coupun is for Flowers which gives more 15% disscount.This coupon can be used once within 10 days which";
                _couponList!.add(coupon);
              }
            }
          });
        } else {
          await apiHelper.getStoreCoupons().then((result) async {
            if (result != null) {
              print("Nikhil---------------------2");
              if (result.status == "1") {
                //_couponList = result.data;
                Coupon coupon = new Coupon();
                coupon.couponId = 1;
                coupon.couponCode = "123";
                coupon.couponDescription =
                    "This coupun is for Flowers which gives more 15% disscount.This coupon can be used once within 10 days which";
                _couponList!.add(coupon);
              }
            }
          });
        }
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
