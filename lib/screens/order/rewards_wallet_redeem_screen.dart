//import 'dart:math';

import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/models/rewardWalletRedeemModel.dart';

import 'package:byyu/widgets/reward_wallet_redeem_card.dart';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:shimmer/shimmer.dart';

import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/orderModel.dart';

import 'package:byyu/widgets/my_text_field.dart';

class RewardsWalletRedeemScreen extends BaseRoute {
  RewardsWalletRedeemScreen({
    a,
    o,
  }) : super(a: a, o: o, r: 'RewardsWalletRedeemScreen');

  @override
  _RewardsWalletRedeemScreenState createState() =>
      _RewardsWalletRedeemScreenState();
}

class _RewardsWalletRedeemScreenState extends BaseRouteState {
  List<RewardWalletRedeemList> _couponList = [];
  bool _isDataLoaded = false;

  final Color color = const Color(0xffFF0000);
  GlobalKey<ScaffoldState>? _scaffoldKey;
  int? screenId;
  int? screenIdO;
  String? cartId;
  String? _selectedCouponCode;
  Order? order;
  int? total_delivery;
  var _txtRedeemCode = new TextEditingController();
  FocusNode _fRedeemCode = new FocusNode();
  GlobalKey<ScaffoldState>? _scaffoldKey1;

  _RewardsWalletRedeemScreenState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey1,
        appBar: AppBar(
          backgroundColor: ColorConstants.appBrownFaintColor,
          centerTitle: true,
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
          title: Text(
            "Redeem Code",
            style: TextStyle(
                fontFamily: global.fontMontserratMedium,
                fontWeight: FontWeight.normal,
                color: ColorConstants.pureBlack),
          ),
        ),
        body: Container(
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    color: global.textGrey,
                    height: 90,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: global.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0))),
                        height: 20,
                        padding: EdgeInsets.only(left: 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: MyTextField(
                                Key('21'),
                                controller: _txtRedeemCode,
                                focusNode: _fRedeemCode,
                                textCapitalization:
                                    TextCapitalization.characters,
                                hintText: 'Enter Redeem code',
                                maxLines: 1,
                                onFieldSubmitted: (val) {},
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                if (_txtRedeemCode != null &&
                                    _txtRedeemCode.text.isNotEmpty) {
                                  // await _applyCoupon("Breakfast Bonanza 15");
                                  await _getRewardsWalletRedeemList(
                                      _txtRedeemCode.text);
                                } else {
                                  showSnackBar(
                                      key: _scaffoldKey1,
                                      snackBarMessage:
                                          'Please Enter Redeem code');
                                }
                              },
                              child: Text(
                                'Apply',
                                style: TextStyle(
                                    color: ColorConstants.pureBlack,
                                    fontFamily: fontMetropolisRegular,
                                    fontWeight: FontWeight.w200),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: _isDataLoaded
                        ? _couponList != null && _couponList.length > 0
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 10, right: 10, bottom: 10),
                                child: ListView.builder(
                                    itemCount: _couponList
                                        .length, //_couponList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return RewardsWalletRedeemCard(
                                        rewardWalletRedeem: _couponList[index],
                                        onRedeem: () async {
                                          setState(() {});
                                        },
                                      );
                                    }),
                              )
                            : Center(
                                child: Text(
                                  'Redeemed and accessed! \n"Your gifting data is now available for your delight."',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: global.fontMontserratLight,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w200,
                                      color: ColorConstants.grey),
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

  _getRewardsWalletRedeemList(String enteredCode) async {
    _couponList.clear();
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        await apiHelper.redeemRewardWallet(enteredCode).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              //_couponList = result.data;
              print("Nikhil---------------------1");
              Fluttertoast.showToast(
                msg: "${result.message}", // message
                toastLength: Toast.LENGTH_SHORT, // length
                gravity: ToastGravity.CENTER, // location
                // duration
              );
              Navigator.pop(context);
              // List<RewardWalletTransactionList> dataList = result.data;
            } else {
              Fluttertoast.showToast(
                msg: "${result.message}", // message
                toastLength: Toast.LENGTH_SHORT, // length
                gravity: ToastGravity.CENTER, // location
                // duration
              );
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
      print(
          "Exception - RewardsWalletRedeem_screen.dart - _getRewardsWalletRedeemList():" +
              e.toString());
    }
  }

  _init() async {
    try {
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - RewardsWalletRedeem_screen.dart - _init():" +
          e.toString());
    }
  }

  _onRefresh() async {
    try {
      _isDataLoaded = false;
      setState(() {});
      await _init();
    } catch (e) {
      print("Exception - RewardsWalletRedeem_screen.dart - _onRefresh():" +
          e.toString());
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
