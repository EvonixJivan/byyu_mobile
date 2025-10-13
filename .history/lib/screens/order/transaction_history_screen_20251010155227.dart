//import 'dart:math';

import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/screens/home_screen.dart';
import 'package:byyu/screens/search_screen.dart';

import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;

import '../../models/businessLayer/global.dart';
import '../../models/transactionHistoryModel.dart';

class TransactionHistoryScreen extends BaseRoute {
  TransactionHistoryScreen({
    a,
    o,
  }) : super(a: a, o: o, r: 'TransactionHistoryScreen');

  @override
  _TransactionHistoryScreenState createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends BaseRouteState {
  bool _isDataLoaded = false;
  bool _onItemTap = false;

  List<Transactionhistory> transactionhistory = [];
  ScrollController _scrollController = new ScrollController();
  double totalCardTransaction = 0, totalCODTransaction = 0;
  _TransactionHistoryScreenState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: ColorConstants.white,
          centerTitle: false,
          leading: BackButton(
            onPressed: () {
              Navigator.of(context).pop();
              //Navigator.pop(context);
            },
            color: ColorConstants.pureBlack,
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SearchScreen(
                          a: widget.analytics,
                          o: widget.observer,
                        )));
              },
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Image.asset(
                  "assets/images/iv_search.png",
                  fit: BoxFit.contain,
                  height: 25,
                  alignment: Alignment.center,
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Stack(
              children: [
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => HomeScreen(
                                a: widget.analytics,
                                o: widget.observer,
                                selectedIndex: 2,
                              )));
                    },
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      size: 25,
                      color: ColorConstants.allIconsBlack45,
                    ),
                  ),
                ),
                global.cartCount != 0 && global.cartCount <= 100
                    ? new Positioned(
                        right: 1,
                        top: 8,
                        child: new Container(
                          padding: EdgeInsets.all(2),
                          decoration: new BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: Text(
                            '${global.cartCount}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : new Container()
              ],
            ),
            SizedBox(
              width: 8,
            ),
          ],
          elevation: 0,
          title: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HomeScreen(
                        a: widget.analytics,
                        o: widget.observer,
                        selectedIndex: 0,
                      )));
            },
            child: Image.asset(
              "assets/images/new_logo.png",
              fit: BoxFit.contain,
              height: 25,
              alignment: Alignment.center,
            ),
          )),
      body: _isDataLoaded
          ? transactionhistory.length > 0
              ? Container(
                  color: white,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: ScrollPhysics(),
                    child: Column(
                      children: [
                        Divider(
                          height: 1,
                        ),
                        Stack(children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: ColorConstants.appfaintColor,
                            ),
                            padding: EdgeInsets.only(top: 20, bottom: 20),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 12,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Total Payment",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontFamily:
                                              global.fontMontserratLight,
                                          fontWeight: FontWeight.w200,
                                          fontSize: 17,
                                          color: Colors.black),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      "${(totalCardTransaction + totalCODTransaction).toStringAsFixed(2)} AED",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontFamily:
                                              global.fontMontserratLight,
                                          fontWeight: FontWeight.w200,
                                          fontSize: 17,
                                          color: ColorConstants.appColor),
                                    ),
                                  ],
                                ),
                                Expanded(child: Text(" ")),
                                Container(
                                  width: 80,
                                  margin: EdgeInsets.only(right: 10),
                                  //height: MediaQuery.of(context).size.width / 1.3,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Image.asset(
                                      "assets/images/totalpay_icon.png",

                                      width: 60,
                                      //width: double.infinity,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                              ],
                            ),
                          ),
                        ]),
                        // SizedBox(
                        //   height: 8,
                        // ),

                        Container(
                          width: MediaQuery.of(context).size.width,
                          //height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: transactionhistory.length,
                            shrinkWrap: true,
                            // controller: _scrollController,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(bottom: 5),
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Container(
                                  padding: EdgeInsets.only(top: 8, bottom: 8),
                                  color: ColorConstants.appBrownFaintColor,
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          for (int i = 0;
                                              i < transactionhistory.length;
                                              i++) {
                                            if (i == index) {
                                              if (transactionhistory[i]
                                                      .isItemTap ==
                                                  true) {
                                                transactionhistory[i]
                                                    .isItemTap = false;
                                              } else {
                                                transactionhistory[i]
                                                    .isItemTap = true;
                                              }
                                            } else {
                                              transactionhistory[i].isItemTap =
                                                  false;
                                            }
                                          }
                                          setState(() {});
                                        },
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        transactionhistory[index]
                                                                        .paymentMethod ==
                                                                    "CancelCash" ||
                                                                transactionhistory[
                                                                            index]
                                                                        .paymentMethod ==
                                                                    "cancelcash"
                                                            ? Container()
                                                            : Container(
                                                                margin:
                                                                    EdgeInsets
                                                                        .only(
                                                                  top: 8,
                                                                  left: 5,
                                                                ),
                                                                child: Text(
                                                                  "Order Status:",
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        fontRailwayRegular,
                                                                    color: ColorConstants
                                                                        .pureBlack,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w200,
                                                                  ),
                                                                ),
                                                              ),
                                                        transactionhistory[index]
                                                                        .paymentMethod ==
                                                                    "CancelCash" ||
                                                                transactionhistory[
                                                                            index]
                                                                        .paymentMethod ==
                                                                    "cancelcash"
                                                            ? Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    3.2,
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 8,
                                                                        left: 5,
                                                                        right:
                                                                            5),
                                                                child: Text(
                                                                  "Refund Amount",
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        fontRailwayRegular,
                                                                    color: ColorConstants
                                                                        .green,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w200,
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    3.2,
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 8,
                                                                        left: 5,
                                                                        right:
                                                                            5),
                                                                child: Text(
                                                                  transactionhistory[
                                                                              index]
                                                                          .orderStatus!
                                                                          .contains(
                                                                              "_")
                                                                      ? transactionhistory[
                                                                              index]
                                                                          .orderStatus!
                                                                          .replaceAll(
                                                                              "_",
                                                                              " ")
                                                                      : transactionhistory[
                                                                              index]
                                                                          .orderStatus!,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        fontRailwayRegular,
                                                                    color: transactionhistory[index].orderStatus!.toLowerCase() ==
                                                                                "delivered" ||
                                                                            transactionhistory[index].orderStatus!.toLowerCase() ==
                                                                                "completed"
                                                                        ? ColorConstants
                                                                            .green
                                                                        : ColorConstants
                                                                            .appColor,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w200,
                                                                  ),
                                                                ),
                                                              ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 8,
                                                                  left: 5),
                                                          child: Text(
                                                            "Order id:",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  fontRailwayRegular,
                                                              color:
                                                                  ColorConstants
                                                                      .pureBlack,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 8,
                                                                  left: 5,
                                                                  right: 5),
                                                          child: Text(
                                                            "${transactionhistory[index].groupCartId}",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  fontRailwayRegular,
                                                              color:
                                                                  ColorConstants
                                                                      .pureBlack,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: 8, left: 5),
                                                  child: Text(
                                                    "Total Pay",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          fontRailwayRegular,
                                                      color: ColorConstants
                                                          .pureBlack,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w200,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: 8,
                                                      left: 5,
                                                      right: 5),
                                                  child: Text(
                                                    " ${double.parse(transactionhistory[index].amount!).toStringAsFixed(0)} AED",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          fontRailwayRegular,
                                                      color: transactionhistory[
                                                                          index]
                                                                      .paymentMethod ==
                                                                  "CancelCash" ||
                                                              transactionhistory[
                                                                          index]
                                                                      .paymentMethod ==
                                                                  "cancelcash"
                                                          ? ColorConstants.green
                                                          : ColorConstants
                                                              .appColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w200,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              child: Icon(transactionhistory[
                                                              index]
                                                          .isItemTap ==
                                                      true
                                                  ? Icons
                                                      .keyboard_arrow_up_rounded
                                                  : Icons
                                                      .keyboard_arrow_down_rounded),
                                            )
                                          ],
                                        ),
                                      ),
                                      transactionhistory[index].isItemTap!
                                          ? Container(
                                              child: Column(
                                                children: [
                                                  transactionhistory[index]
                                                                  .couponCode !=
                                                              "" &&
                                                          transactionhistory[
                                                                      index]
                                                                  .couponCode !=
                                                              null
                                                      ? Row(
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 8,
                                                                      left: 8),
                                                              child: Text(
                                                                transactionhistory[index].couponCode !=
                                                                            "" &&
                                                                        transactionhistory[index].couponCode !=
                                                                            null
                                                                    ? "Gift card ID:-"
                                                                    : "",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        fontRailwayRegular,
                                                                    color: ColorConstants
                                                                        .pureBlack,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w200,
                                                                    letterSpacing:
                                                                        1),
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 8,
                                                                      left: 8),
                                                              child: Text(
                                                                transactionhistory[index].couponCode !=
                                                                            "" &&
                                                                        transactionhistory[index].couponCode !=
                                                                            null
                                                                    ? "${transactionhistory[index].couponCode}"
                                                                    : "",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        fontRailwayRegular,
                                                                    color: ColorConstants
                                                                        .pureBlack,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w200,
                                                                    letterSpacing:
                                                                        1),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : Container(),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Divider(
                                                    height: 1,
                                                    color:
                                                        ColorConstants.Pending,
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  transactionhistory[index]
                                                                  .paymentMethod ==
                                                              "CancelCash" ||
                                                          transactionhistory[
                                                                      index]
                                                                  .paymentMethod ==
                                                              "cancelcash"
                                                      ? Container()
                                                      : Row(
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 8),
                                                              child: Text(
                                                                "Order date:",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        fontRailwayRegular,
                                                                    color: ColorConstants
                                                                        .pureBlack,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w200,
                                                                    letterSpacing:
                                                                        1),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left: 5,
                                                                        right:
                                                                            5),
                                                                child: Text(
                                                                  "${transactionhistory[index].orderDate}",
                                                                  // textAlign:
                                                                  //     TextAlign
                                                                  //         .right,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          fontRailwayRegular,
                                                                      color: ColorConstants
                                                                          .pureBlack,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w200,
                                                                      letterSpacing:
                                                                          1),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                  transactionhistory[index]
                                                                  .paymentMethod ==
                                                              "CancelCash" ||
                                                          transactionhistory[
                                                                      index]
                                                                  .paymentMethod ==
                                                              "cancelcash"
                                                      ? Container()
                                                      : Row(
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 8,
                                                                      left: 8),
                                                              child: Text(
                                                                "Delivery Date:",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        fontRailwayRegular,
                                                                    color: ColorConstants
                                                                        .pureBlack,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w200,
                                                                    letterSpacing:
                                                                        1),
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 8,
                                                                      left: 8),
                                                              child: Text(
                                                                "${transactionhistory[index].deliveryDate}",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        fontRailwayRegular,
                                                                    color: ColorConstants
                                                                        .pureBlack,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w200,
                                                                    letterSpacing:
                                                                        1),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 8, left: 8),
                                                        child: Text(
                                                          "Payment Method:",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  fontRailwayRegular,
                                                              color:
                                                                  ColorConstants
                                                                      .pureBlack,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200,
                                                              letterSpacing: 1),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 8,
                                                            left: 5,
                                                            right: 5),
                                                        child: Text(
                                                          "${transactionhistory[index].paymentMethod}",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  fontRailwayRegular,
                                                              color:
                                                                  ColorConstants
                                                                      .pureBlack,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200,
                                                              letterSpacing: 1),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          : SizedBox(),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Divider(
                                        height: 1,
                                        color: ColorConstants.appfaintColor,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/login_bg.png"),
                        fit: BoxFit.cover),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Expanded(child: Text("")),
                        Text(
                          "Empty transactions page? \n'Let's write some gifting stories together!'",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: fontMontserratLight,
                              fontSize: 20,
                              fontWeight: FontWeight.w200,
                              color: ColorConstants.guidlinesGolden),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                      a: widget.analytics,
                                      o: widget.observer,
                                      selectedIndex: 0,
                                    )));
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width - 70,
                            decoration: BoxDecoration(
                                color: ColorConstants.appColor,
                                border: Border.all(
                                    color: ColorConstants.appColor, width: 0.5),
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              "GIFT NOW",
                              textAlign: TextAlign.center,
                              // "${AppLocalizations.of(context).tle_add_new_address} ",
                              style: TextStyle(
                                  fontFamily: fontMontserratMedium,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: ColorConstants.white,
                                  letterSpacing: 1),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(""),
                        ),
                      ],
                    ),
                  ),
                )
          : Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(child: CircularProgressIndicator()),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    try {
      _getTransactionsData();
    } catch (e) {
      print("Exception - coupons_screen.dart - _init():" + e.toString());
    }
  }

  _getTransactionsData() async {
    print("Sub Category Product-------------------");
    try {
      await apiHelper.getTransactions().then((result) async {
        if (result != null) {
          if (result.data != null) {
            transactionhistory = result.data;
            for (int i = 0; i < transactionhistory.length; i++) {
              if (transactionhistory[i].paymentMethod!.toLowerCase() ==
                  "card") {
                totalCardTransaction = totalCardTransaction +
                    double.parse(transactionhistory[i].amount!);
              } else if (transactionhistory[i].paymentMethod!.toLowerCase() ==
                  "cod") {
                totalCODTransaction = totalCODTransaction +
                    double.parse(transactionhistory[i].amount!);
              }
            }
            setState(() {
              _isDataLoaded = true;
            });
          }
          // }
          else {
            setState(() {
              _isDataLoaded = true;
            });
          }
        } else {
          _isDataLoaded = true;

          setState(() {});
        }
      });
      // }
    } catch (e) {
      print("Exception - Transaction_history.dart - _getEventProduct():" +
          e.toString());
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
