import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/businessRule.dart';
import 'package:byyu/models/businessLayer/global.dart';

import 'package:byyu/widgets/my_text_field.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:byyu/models/businessLayer/apiHelper.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/walletModel.dart';

import '../../models/rewardWalletTransactionModel.dart';

class WalletScreen extends BaseRoute {
  final double? totalAmount;
  WalletScreen({a, o, this.totalAmount}) : super(a: a, o: o, r: 'WalletScreen');
  @override
  _WalletScreenState createState() => new _WalletScreenState(totalAmount!);
}

class _WalletScreenState extends BaseRouteState {
  double totalAmount;
  ScrollController _rechargeHistoryScrollController = ScrollController();
  ScrollController _walletSpentScrollController = ScrollController();
  TextEditingController _cAmount = new TextEditingController();
  int rechargeHistoryPage = 1;
  int walletSpentPage = 1;
  bool _isDataLoaded = false;
  bool _isRechargeHistoryPending = true;
  bool _isSpentHistoryPending = true;
  bool _isRechargeHistoryMoreDataLoaded = false;
  bool _isSpentHistoryMoreDataLoaded = false;
  bool _isWalletExpenseSelected = true;
  bool _isWalletRechargeSelected = false;
  bool onRedeemClicked = false;

  var _txtRedeemCode = new TextEditingController();
  FocusNode _fRedeemCode = new FocusNode();

  List<Wallet> _walletRechargeHistoryList = [];
  List<Wallet> _walletSpentHistoryList = [];
  GlobalKey<ScaffoldState>? _scaffoldKey;
  APIHelper apiHelper4 = new APIHelper();
  _WalletScreenState(this.totalAmount) : super();
  TabController? tabController;
  bool _onItemTap = false;

  bool _onAllSelected = true;

  @override
  Widget build(BuildContext context) {
    //TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      color: global.white,
      //   color: Colors.pink,
      child: SafeArea(
        child: DefaultTabController(
          length: 3,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Scaffold(
              backgroundColor: ColorConstants.colorPageBackground,
              appBar: AppBar(
                backgroundColor: ColorConstants.white,
                centerTitle: false,
                title: Text(
                    "Wallet"
                    // "${AppLocalizations.of(context).tle_all_category} "
                    ,
                    style: TextStyle(
                        fontFamily: global.fontRailwayRegular,
                        fontWeight: FontWeight.normal,
                        color: ColorConstants.newTextHeadingFooter) //textTheme.titleLarge,
                    ),
                leading: BackButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  //icon: Icon(Icons.keyboard_arrow_left),
                  color: ColorConstants.pureBlack,
                ),
              ),
              body: _isDataLoaded
                  ? walletTransactionList != null
                      ? SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          physics: ScrollPhysics(),
                          child: Container(
                            color: ColorConstants.colorPageBackground,
                            child: Stack(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 1, left: 1),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 8, right: 8, top: 10),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color:
                                              ColorConstants.colorHomePageSection,
                                          //color: Colors.deepPurpleAccent
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Available Balance",
                                                  style: TextStyle(
                                                    fontFamily: global
                                                        .fontRailwayRegular,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: ColorConstants
                                                        .newTextHeadingFooter,
                                                  ),
                                                ),
                                                Expanded(child: Text("")),
                                                Text(
                                                  "${rewardWalletTransaction!.totalWalletAmount!.toStringAsFixed(2)} AED",
                                                  style: TextStyle(
                                                      fontFamily: global
                                                          .fontOufitMedium,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color:
                                                          ColorConstants.green,
                                                      letterSpacing: 1),
                                                ),
                                              ],
                                            ),
                                            Divider(thickness: 0.5),
                                            Row(
                                              children: [
                                                Text(
                                                  "Wallet ",
                                                  style: TextStyle(
                                                      fontFamily: global
                                                          .fontRailwayRegular,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16,
                                                      color: ColorConstants
                                                          .newTextHeadingFooter,
                                                      letterSpacing: 1),
                                                ),
                                                Expanded(child: Text("")),
                                                Text(
                                                  "${rewardWalletTransaction!.cashWalletAmount!.toStringAsFixed(2)} AED",
                                                  style: TextStyle(
                                                    fontFamily: global
                                                        .fontOufitMedium,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                    color: ColorConstants.grey,
                                                    //color: Colors.pink
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(thickness: 0.5),
                                            Row(
                                              children: [
                                                Text(
                                                  "Gift Voucher ",
                                                  style: TextStyle(
                                                    fontFamily: global
                                                        .fontRailwayRegular,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                    color: ColorConstants
                                                        .newTextHeadingFooter,
                                                  ),
                                                ),
                                                Expanded(child: Text("")),
                                                Text(
                                                  "${rewardWalletTransaction!.rewardWalletAmount!.toStringAsFixed(2)} AED",
                                                  style: TextStyle(
                                                      fontFamily: global
                                                          .fontOufitMedium,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16,
                                                      color:
                                                          ColorConstants.grey,
                                                      letterSpacing: 1),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Row(
                                      //   children: [
                                      //     InkWell(
                                      //       onTap: () {
                                      //         // if (onRedeemClicked) {
                                      //         //   onRedeemClicked = false;
                                      //         // } else {
                                      //         onRedeemClicked = true;
                                      //         // }

                                      //         setState(() {});
                                      //       },
                                      //       child: Container(
                                      //         //   color: Colors.amber,
                                      //         padding: EdgeInsets.only(
                                      //             left: 10, right: 10),
                                      //         child: Row(
                                      //           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //           children: [
                                      //             // Expanded(child: Text(" ")),
                                      //             Container(
                                      //               child: Image.asset(
                                      //                 "assets/images/redeem_icon.png",

                                      //                 width: 60,
                                      //                 //width: double.infinity,
                                      //               ),
                                      //             ),
                                      //             SizedBox(
                                      //               width: 8,
                                      //             ),
                                      //             Container(
                                      //               //  color: Colors.purple,
                                      //               child: Text(
                                      //                 "Redeem Code",
                                      //                 style: TextStyle(
                                      //                     fontFamily: global
                                      //                         .fontRailwayRegular,
                                      //                     fontWeight:
                                      //                         FontWeight.w400,
                                      //                     fontSize: 16,
                                      //                     color: ColorConstants
                                      //                         .appColor),
                                      //               ),
                                      //             ),
                                      //           ],
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     Expanded(child: Text("")),
                                      //     onRedeemClicked == true
                                      //         ? Padding(
                                      //             padding:
                                      //                 const EdgeInsets.only(
                                      //                     right: 5),
                                      //             child: InkWell(
                                      //               onTap: () {
                                      //                 onRedeemClicked = false;

                                      //                 setState(() {});
                                      //               },
                                      //               child: Icon(
                                      //                 Icons.close,
                                      //                 color: ColorConstants
                                      //                     .appColor,
                                      //               ),
                                      //             ),
                                      //           )
                                      //         : Container(),
                                      //   ],
                                      // ),
                                      SizedBox(
                                        height: 15, //d not useful
                                      ),
                                      // onRedeemClicked
                                      //     ? Container(
                                      //         height: 80,
                                      //         child: Padding(
                                      //           padding: const EdgeInsets.only(
                                      //               left: 10,
                                      //               right: 10,
                                      //               top: 10,
                                      //               bottom: 10),
                                      //           child: Container(
                                      //             decoration: BoxDecoration(
                                      //                 color: global.white,
                                      //                 borderRadius:
                                      //                     BorderRadius.all(
                                      //                         Radius.circular(
                                      //                             7.0))),
                                      //             // height: 10,
                                      //             padding: EdgeInsets.only(
                                      //                 left: 5,
                                      //                 bottom: 10,
                                      //                 right: 10,
                                      //                 top: 10),
                                      //             child: Container(
                                      //               // height: 10,
                                      //               //   color: Colors.amber,
                                      //               child: Row(
                                      //                 children: [
                                      //                   Expanded(
                                      //                     child: MyTextField(
                                      //                       suffixIcon: InkWell(
                                      //                           onTap: () {
                                      //                             _txtRedeemCode
                                      //                                 .text = "";
                                      //                             setState(
                                      //                                 () {});
                                      //                           },
                                      //                           child: Icon(
                                      //                             Icons.cancel,
                                      //                             color: ColorConstants
                                      //                                 .pureBlack,
                                      //                             size: 20,
                                      //                           )),
                                      //                       Key('21'),
                                      //                       controller:
                                      //                           _txtRedeemCode,
                                      //                       inputTextFontWeight:
                                      //                           FontWeight.w400,
                                      //                       focusNode:
                                      //                           _fRedeemCode,
                                      //                       textCapitalization:
                                      //                           TextCapitalization
                                      //                               .characters,
                                      //                       hintText:
                                      //                           'Enter Redeem Code',
                                      //                       maxLines: 1,
                                      //                       onFieldSubmitted:
                                      //                           (val) {},
                                      //                     ),
                                      //                   ),
                                      //                   SizedBox(
                                      //                     width: 5,
                                      //                   ),
                                      //                   InkWell(
                                      //                     onTap: () async {
                                      //                       if (_txtRedeemCode !=
                                      //                               null &&
                                      //                           _txtRedeemCode
                                      //                               .text
                                      //                               .isNotEmpty) {
                                      //                         // await _applyCoupon("Breakfast Bonanza 15");
                                      //                         await _getRewardsWalletRedeemList(
                                      //                             _txtRedeemCode
                                      //                                 .text);
                                      //                       } else {
                                      //                         Fluttertoast
                                      //                             .showToast(
                                      //                           msg:
                                      //                               "Please Enter Redeem code", // message
                                      //                           toastLength: Toast
                                      //                               .LENGTH_SHORT, // length
                                      //                           gravity:
                                      //                               ToastGravity
                                      //                                   .CENTER, // location
                                      //                           // duration
                                      //                         );
                                      //                         // showSnackBar(
                                      //                         //     key: _scaffoldKey1,
                                      //                         //     snackBarMessage:
                                      //                         //         'Please Enter Redeem code');
                                      //                       }
                                      //                     },
                                      //                     child: Container(
                                      //                       padding:
                                      //                           EdgeInsets.only(
                                      //                               left: 8,
                                      //                               right: 8,
                                      //                               top: 12,
                                      //                               bottom: 12),
                                      //                       decoration:
                                      //                           BoxDecoration(
                                      //                         borderRadius:
                                      //                             BorderRadius
                                      //                                 .all(
                                      //                           Radius.circular(
                                      //                               5),
                                      //                         ),
                                      //                         color:
                                      //                             ColorConstants
                                      //                                 .appColor,
                                      //                         border: Border.all(
                                      //                             width: 0.5,
                                      //                             color: ColorConstants
                                      //                                 .appGoldenColortint),
                                      //                       ),
                                      //                       child: Container(
                                      //                         child: Text(
                                      //                           "APPLY",
                                      //                           textAlign:
                                      //                               TextAlign
                                      //                                   .center,
                                      //                           style: TextStyle(
                                      //                               fontFamily:
                                      //                                   fontMontserratMedium,
                                      //                               fontWeight:
                                      //                                   FontWeight
                                      //                                       .bold,
                                      //                               fontSize:
                                      //                                   11,
                                      //                               color: ColorConstants
                                      //                                   .white,
                                      //                               letterSpacing:
                                      //                                   1),
                                      //                         ),
                                      //                       ),
                                      //                     ),
                                      //                   )
                                      //                   // TextButton(
                                      //                   //   onPressed: () async {
                                      //                   //     if (_txtRedeemCode !=
                                      //                   //             null &&
                                      //                   //         _txtRedeemCode
                                      //                   //             .text
                                      //                   //             .isNotEmpty) {
                                      //                   //       // await _applyCoupon("Breakfast Bonanza 15");
                                      //                   //       await _getRewardsWalletRedeemList(
                                      //                   //           _txtRedeemCode
                                      //                   //               .text);
                                      //                   //     } else {
                                      //                   //       Fluttertoast
                                      //                   //           .showToast(
                                      //                   //         msg:
                                      //                   //             "Please Enter Redeem code", // message
                                      //                   //         toastLength: Toast
                                      //                   //             .LENGTH_SHORT, // length
                                      //                   //         gravity:
                                      //                   //             ToastGravity
                                      //                   //                 .CENTER, // location
                                      //                   //         // duration
                                      //                   //       );
                                      //                   //       // showSnackBar(
                                      //                   //       //     key: _scaffoldKey1,
                                      //                   //       //     snackBarMessage:
                                      //                   //       //         'Please Enter Redeem code');
                                      //                   //     }
                                      //                   //   },
                                      //                   //   child: Text(
                                      //                   //     'APPLY',
                                      //                   //     textAlign: TextAlign
                                      //                   //         .center,
                                      //                   //     style: TextStyle(
                                      //                   //         fontFamily:
                                      //                   //             fontMontserratMedium,
                                      //                   //         fontWeight:
                                      //                   //             FontWeight
                                      //                   //                 .bold,
                                      //                   //         fontSize: 11,
                                      //                   //         color:
                                      //                   //             ColorConstants
                                      //                   //                 .white,
                                      //                   //         letterSpacing:
                                      //                   //             1),
                                      //                   //   ),
                                      //                   // )
                                      //                 ],
                                      //               ),
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       )
                                      //     : Container(),
                                      // onRedeemClicked
                                      //     ? SizedBox(
                                      //         height: 18,
                                      //       )
                                      //     : SizedBox(),
                                      Container(
                                        //        color: white,
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                _onAllSelected = true;

                                                setState(() {});
                                              },
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 15,
                                                    right: 15,
                                                    top: 5,
                                                    bottom: 5),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: _onAllSelected
                                                          ? ColorConstants
                                                              .appColor
                                                          : Colors.grey,
                                                    ),
                                                    color: _onAllSelected
                                                        ? ColorConstants
                                                            .appColor
                                                        : ColorConstants.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Text(
                                                  "All",
                                                  style: TextStyle(
                                                      fontFamily: global
                                                          .fontRailwayRegular,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 15,
                                                      color: _onAllSelected
                                                          ? Colors.white
                                                          : Colors.black),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                _onAllSelected = false;

                                                setState(() {});
                                              },
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 15,
                                                    right: 15,
                                                    top: 5,
                                                    bottom: 5),
                                                decoration: BoxDecoration(
                                                    color: !_onAllSelected
                                                        ? ColorConstants
                                                            .appColor
                                                        : ColorConstants.white,
                                                    border: Border.all(
                                                      color: !_onAllSelected
                                                          ? ColorConstants
                                                              .appColor
                                                          : ColorConstants.grey,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Text(
                                                  "Pending and Expiring",
                                                  style: TextStyle(
                                                      fontFamily: global
                                                          .fontRailwayRegular,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 15,
                                                      color: !_onAllSelected
                                                          ? ColorConstants.white
                                                          : ColorConstants
                                                              .pureBlack),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      SizedBox(height: 8),
                                      walletTransactionList.length > 0 ||
                                              pendingWalletTransactionList
                                                      .length >
                                                  0
                                          ? _onAllSelected
                                              ? Container(
                                                  color: white,
                                                  margin: EdgeInsets.only(
                                                      left: 5, right: 5),
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  //height: MediaQuery.of(context).size.height,
                                                  child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemCount:
                                                        walletTransactionList
                                                            .length,
                                                    shrinkWrap: true,
                                                    // controller: _scrollController,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return _isWalletExpenseSelected
                                                          ? Container(
                                                              margin: EdgeInsets
                                                                  .only(top: 8),
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 10,
                                                                      bottom:
                                                                          10),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade100,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  border: Border.all(
                                                                      width: 1,
                                                                      color: ColorConstants.colorHomePageSectiondim)),
                                                              child: Column(
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      for (int i =
                                                                              0;
                                                                          i < walletTransactionList.length;
                                                                          i++) {
                                                                        // if (i ==
                                                                        //     index) {
                                                                        //   walletTransactionList[i].onTap =
                                                                        //       true;
                                                                        // } else {
                                                                        //   walletTransactionList[i].onTap =
                                                                        //       false;
                                                                        // }
                                                                        walletTransactionList[i].onTap =
                                                                            true;
                                                                      }

                                                                      setState(
                                                                          () {});
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Container(
                                                                            margin:
                                                                                EdgeInsets.only(left: 10),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                walletTransactionList[index].walletType!.toLowerCase() == "reward wallet" || walletTransactionList[index].walletType!.toLowerCase() == "cash wallet"
                                                                                    ? Container(
                                                                                        width: MediaQuery.of(context).size.width,
                                                                                        child: Text(
                                                                                          "${walletTransactionList[index].walletdisname}",
                                                                                          style: TextStyle(fontFamily: fontRailwayRegular, color: ColorConstants.green, fontSize: 15, fontWeight: FontWeight.w600),
                                                                                        ),
                                                                                      )
                                                                                    : Container(
                                                                                        width: MediaQuery.of(context).size.width,
                                                                                        child: Text(
                                                                                          "${walletTransactionList[index].walletType}",
                                                                                          style: TextStyle(fontFamily: fontRailwayRegular, color: ColorConstants.lightRedVelvet30, fontSize: 15, fontWeight: FontWeight.w600),
                                                                                        ),
                                                                                      ),
                                                                                Row(
                                                                                  children: [
                                                                                    Container(
                                                                                      margin: EdgeInsets.only(top: 8, left: 2),
                                                                                      child: walletTransactionList[index].walletType!.toLowerCase() == "reward wallet"
                                                                                          ? Text(
                                                                                              "Amount:",
                                                                                              style: TextStyle(fontFamily: fontRailwayRegular, color: ColorConstants.pureBlack, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.1),
                                                                                            )
                                                                                          : Text(
                                                                                              // walletTransactionList[index].walletType!.toLowerCase() == "cash wallet" ? "Amount:" : "Total Pay:",
                                                                                              "Amount:",
                                                                                              style: TextStyle(fontFamily: fontRailwayRegular, color: ColorConstants.pureBlack, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.1),
                                                                                            ),
                                                                                    ),
                                                                                    Expanded(child: Text("")),
                                                                                    // old code

                                                                                    // Container(
                                                                                    //   margin: EdgeInsets.only(top: 8, left: 2),
                                                                                    //   child: Text(
                                                                                    //     walletTransactionList[index].walletType!.toLowerCase() == "reward wallet" || walletTransactionList[index].walletType!.toLowerCase() == "cash wallet" ? "Reward amount:" : "Total Pay:",
                                                                                    //     style: TextStyle(fontFamily: fontRailwayRegular, color: ColorConstants.pureBlack, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.1),
                                                                                    //   ),
                                                                                    // ),
                                                                                    Container(
                                                                                      margin: EdgeInsets.only(top: 8, left: 5),
                                                                                      child: Text(
                                                                                        "${walletTransactionList[index].walletAmount!.toStringAsFixed(2)} AED",
                                                                                        style: TextStyle(
                                                                                            fontFamily: fontOufitMedium,
                                                                                            color: walletTransactionList[index].walletType!.toLowerCase() == "reward wallet" || walletTransactionList[index].walletType!.toLowerCase() == "cash wallet"
                                                                                                ? walletTransactionList[index].walletAmount!.toString().contains("-")
                                                                                                    ? ColorConstants.lightRedVelvet30
                                                                                                    : ColorConstants.green
                                                                                                : ColorConstants.lightRedVelvet30,
                                                                                            fontSize: 16,
                                                                                            fontWeight: FontWeight.w400,
                                                                                            letterSpacing: 1),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 8,
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  walletTransactionList[
                                                                              index]
                                                                          .onTap!
                                                                      ? Divider()
                                                                      : Container(),
                                                                  walletTransactionList[
                                                                              index]
                                                                          .onTap!
                                                                      ? Container(
                                                                          padding:
                                                                              EdgeInsets.all(10),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  walletTransactionList[index].walletdisname != null && walletTransactionList[index].walletdisname!.toLowerCase() != "refund"
                                                                                      ? Container(
                                                                                          margin: EdgeInsets.only(top: 1),
                                                                                          child: walletTransactionList[index].walletType!.toLowerCase() == "reward wallet"
                                                                                              ? Text(
                                                                                                  "Wallet Type:",
                                                                                                  style: TextStyle(fontFamily: fontRailwayRegular, color: ColorConstants.pureBlack, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.1),
                                                                                                )
                                                                                              : Text(
                                                                                                  "Wallet Type:", //walletTransactionList[index].walletType!.toLowerCase() == "cash wallet" ? "Amount:" : "Total Pay:",
                                                                                                  style: TextStyle(fontFamily: fontRailwayRegular, color: ColorConstants.pureBlack, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.1),
                                                                                                ),
                                                                                        )
                                                                                      : Container(
                                                                                          child: Text(
                                                                                          "",
                                                                                        )),
                                                                                  walletTransactionList[index].walletType != null && walletTransactionList[index].walletType!.toLowerCase() == "deduction"
                                                                                      ? Container(
                                                                                          margin: EdgeInsets.only(top: 1, left: 2),
                                                                                          child: Text(
                                                                                            "Wallet Type:",
                                                                                            style: TextStyle(fontFamily: fontRailwayRegular, color: ColorConstants.pureBlack, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.1),
                                                                                          ))
                                                                                      : Container(
                                                                                          child: Text(
                                                                                          "",
                                                                                        )),
                                                                                  walletTransactionList[index].walletdisname != null && walletTransactionList[index].walletdisname!.toLowerCase() == "refund"
                                                                                      ? Container(
                                                                                          margin: EdgeInsets.only(top: 1, left: 2),
                                                                                          child: Text(
                                                                                            "Wallet Type:", //"Refund Amount:",
                                                                                            style: TextStyle(fontFamily: fontRailwayRegular, color: ColorConstants.pureBlack, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.1),
                                                                                          ))
                                                                                      : Container(
                                                                                          child: Text(
                                                                                          "",
                                                                                        )),
                                                                                  Container(
                                                                                    margin: EdgeInsets.only(top: 1, left: 5),
                                                                                    child: Text(
                                                                                      "${walletTransactionList[index].walletType}",
                                                                                      style: TextStyle(fontFamily: fontRailwayRegular, color: ColorConstants.newTextHeadingFooter, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 1),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              walletTransactionList[index].walletType!.toLowerCase() == "reward wallet" || walletTransactionList[index].walletType!.toLowerCase() == "cash wallet"
                                                                                  ? SizedBox()
                                                                                  : Row(
                                                                                      children: [
                                                                                        Container(
                                                                                          margin: EdgeInsets.only(top: 8, left: 2),
                                                                                          child: Text(
                                                                                            "Order id:-",
                                                                                            style: TextStyle(
                                                                                              fontFamily: fontRailwayRegular,
                                                                                              color: ColorConstants.pureBlack,
                                                                                              fontSize: 14,
                                                                                              fontWeight: FontWeight.w400,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Container(
                                                                                          margin: EdgeInsets.only(top: 8, left: 5),
                                                                                          child: Text(
                                                                                            "${walletTransactionList[index].cartId}",
                                                                                            style: TextStyle(
                                                                                              fontFamily: fontRailwayRegular,
                                                                                              color: ColorConstants.pureBlack,
                                                                                              fontSize: 14,
                                                                                              fontWeight: FontWeight.w400,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                              walletTransactionList[index].walletType!.toLowerCase() == "reward wallet"
                                                                                  ? Row(
                                                                                      children: [
                                                                                        Container(
                                                                                          margin: EdgeInsets.only(top: 8),
                                                                                          child: Text(
                                                                                            "Expiry Date:",
                                                                                            style: TextStyle(fontFamily: fontRailwayRegular, color: ColorConstants.pureBlack, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.1),
                                                                                          ),
                                                                                        ),
                                                                                        Container(
                                                                                          margin: EdgeInsets.only(top: 8, left: 8),
                                                                                          child: Text(
                                                                                            walletTransactionList[index].walletExpiryDate != null ? "${global.dateOnly.format(DateTime.parse(walletTransactionList[index].walletExpiryDate!))}" : "",
                                                                                            style: TextStyle(fontFamily: fontRailwayRegular, color: ColorConstants.appColor, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 1),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    )
                                                                                  : Container(),
                                                                              Row(
                                                                                children: [
                                                                                  walletTransactionList[index].walletType!.toLowerCase() == "reward wallet"?Container(
                                                                                    margin: EdgeInsets.only(top: 8),
                                                                                    child: Text(
                                                                                      "Reward Date:",
                                                                                      style: TextStyle(fontFamily: fontRailwayRegular, color: ColorConstants.pureBlack, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.1),
                                                                                    ),
                                                                                  ):SizedBox(),
                                                                                  walletTransactionList[index].walletType!.toLowerCase() == "deduction"?Container(
                                                                                    margin: EdgeInsets.only(top: 8),
                                                                                    child: Text(
                                                                                      "Deduction Date:",
                                                                                      style: TextStyle(fontFamily: fontRailwayRegular, color: ColorConstants.pureBlack, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.1),
                                                                                    ),
                                                                                  ):SizedBox(),
                                                                                  walletTransactionList[index].walletdisname !=null && walletTransactionList[index].walletdisname!.toLowerCase() == "refund"?Container(
                                                                                    margin: EdgeInsets.only(top: 8),
                                                                                    child: Text(
                                                                                      "Refund Date:",
                                                                                      style: TextStyle(fontFamily: fontRailwayRegular, color: ColorConstants.pureBlack, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.1),
                                                                                    ),
                                                                                  ):SizedBox(),
                                                                                 walletTransactionList[index].walletdisname !=null && walletTransactionList[index].walletdisname!.toLowerCase() == "referral"?Container(
                                                                                    margin: EdgeInsets.only(top: 8),
                                                                                    child: Text(
                                                                                      "Refer Date:",
                                                                                      style: TextStyle(fontFamily: fontRailwayRegular, color: ColorConstants.pureBlack, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.1),
                                                                                    ),
                                                                                  ):SizedBox(),
                                                                                  walletTransactionList[index].walletdisname !=null && (walletTransactionList[index].walletType!.toLowerCase() != "deduction" && walletTransactionList[index].walletdisname!.toLowerCase() == "refund" && walletTransactionList[index].walletdisname!.toLowerCase() == "referral")?Container(
                                                                                    margin: EdgeInsets.only(top: 8),
                                                                                    child: Text(
                                                                                      "Date:",
                                                                                      style: TextStyle(fontFamily: fontRailwayRegular, color: ColorConstants.pureBlack, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.1),
                                                                                    ),
                                                                                  ):SizedBox(),
                                                                                  walletTransactionList[index].walletdisname !=null && walletTransactionList[index].walletdisname!.toLowerCase() != "referral" && walletTransactionList[index].walletdisname!.toLowerCase() != "refund" && walletTransactionList[index].walletType!.toLowerCase() != "deduction" && walletTransactionList[index].walletType!.toLowerCase() != "reward wallet"?Container(
                                                                                    margin: EdgeInsets.only(top: 8),
                                                                                    child: Text(
                                                                                      "Date:",
                                                                                      style: TextStyle(fontFamily: fontRailwayRegular, color: ColorConstants.pureBlack, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.1),
                                                                                    ),
                                                                                  ):SizedBox(),
                                                                                  Container(
                                                                                    margin: EdgeInsets.only(top: 8, left: 8),
                                                                                    child: Text(
                                                                                      walletTransactionList[index].createdAt != null ? "${dateOnly.format(DateTime.parse((walletTransactionList[index].createdAt!)))}" : "",
                                                                                      style: TextStyle(fontFamily: fontRailwayRegular, color: ColorConstants.pureBlack, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 1),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )
                                                                      : SizedBox(),
                                                                ],
                                                              ),
                                                            )
                                                          : SizedBox();
                                                    },
                                                  ),
                                                )
                                              : Container(
                                                  margin: EdgeInsets.only(
                                                      left: 8, right: 8),
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  //height: MediaQuery.of(context).size.height,
                                                  child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemCount:
                                                        pendingWalletTransactionList
                                                            .length,
                                                    shrinkWrap: true,
                                                    // controller: _scrollController,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return _isWalletExpenseSelected
                                                          ? Container(
                                                              margin: EdgeInsets
                                                                  .only(top: 8),
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 10,
                                                                      bottom:
                                                                          10),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  border: Border.all(
                                                                      width: 1,
                                                                      color: ColorConstants
                                                                          .appfaintColor)),
                                                              child: Column(
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      // for (int i =
                                                                      //         0;
                                                                      //     i < pendingWalletTransactionList.length;
                                                                      //     i++) {
                                                                      //   if (i ==
                                                                      //       index) {
                                                                      //     pendingWalletTransactionList[i].onTap =
                                                                      //         true;
                                                                      //   } else {
                                                                      //     pendingWalletTransactionList[i].onTap =
                                                                      //         false;
                                                                      //   }
                                                                      // }
                                                                      // setState(
                                                                      //     () {});
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Container(
                                                                            margin:
                                                                                EdgeInsets.only(left: 10),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                pendingWalletTransactionList[index].walletType!.toLowerCase() == "reward wallet" || pendingWalletTransactionList[index].walletType!.toLowerCase() == "cash wallet"
                                                                                    ? Container(
                                                                                        width: MediaQuery.of(context).size.width,
                                                                                        child: Text(
                                                                                          "${pendingWalletTransactionList[index].walletName}",
                                                                                          style: TextStyle(fontFamily: fontRailwayRegular, color: ColorConstants.pureBlack, fontSize: 15, fontWeight: FontWeight.w600),
                                                                                        ),
                                                                                      )
                                                                                    : Container(
                                                                                        width: MediaQuery.of(context).size.width,
                                                                                        child: Text(
                                                                                          "${pendingWalletTransactionList[index].walletType}",
                                                                                          style: TextStyle(fontFamily: fontRailwayRegular, color: ColorConstants.pureBlack, fontSize: 15, fontWeight: FontWeight.w600),
                                                                                        ),
                                                                                      ),

                                                                                //old 22 feb by a
                                                                                // Row(
                                                                                //   children: [
                                                                                //     Container(
                                                                                //       margin: EdgeInsets.only(top: 8, left: 2),
                                                                                //       child: Text(
                                                                                //         pendingWalletTransactionList[index].walletType!.toLowerCase() == "reward wallet" || pendingWalletTransactionList[index].walletType!.toLowerCase() == "cash wallet" ? "Reward amount:" : "Total Pay:",
                                                                                //         style: TextStyle(fontFamily: fontRailwayRegular, color: ColorConstants.pureBlack, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.1),
                                                                                //       ),
                                                                                //     ),
                                                                                //     Container(
                                                                                //       margin: EdgeInsets.only(top: 8, left: 5),
                                                                                //       child: Text(
                                                                                //         "${pendingWalletTransactionList[index].walletAmount} AED",
                                                                                //         style: TextStyle(fontFamily: fontRailwayRegular, color: walletTransactionList[index].walletType!.toLowerCase() == "reward wallet" || walletTransactionList[index].walletType!.toLowerCase() == "cash wallet" ? ColorConstants.green : ColorConstants.appColor, fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 1),
                                                                                //       ),
                                                                                //     ),
                                                                                //   ],
                                                                                // ),
                                                                                Row(
                                                                                  children: [
                                                                                    Container(
                                                                                      margin: EdgeInsets.only(top: 8, left: 2),
                                                                                      child: Text(
                                                                                              "Amount: ",
                                                                                              // walletTransactionList[index].walletType!.toLowerCase() == "cash wallet" ? "Amount:" : "Total Pay:",
                                                                                              style: TextStyle(fontFamily: fontRailwayRegular, color: ColorConstants.pureBlack, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.1),
                                                                                            ),
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: Text(""),
                                                                                    ),
                                                                                    Container(
                                                                                      margin: EdgeInsets.only(top: 8, left: 5),
                                                                                      child: Text(
                                                                                        "${pendingWalletTransactionList[index].walletAmount!.toStringAsFixed(2)} AED",
                                                                                        style: TextStyle(fontFamily: fontRailwayRegular, color: walletTransactionList[index].walletType!.toLowerCase() == "reward wallet" || walletTransactionList[index].walletType!.toLowerCase() == "cash wallet" ? ColorConstants.green : ColorConstants.appColor, fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 1),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(width: 8,)
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  pendingWalletTransactionList[
                                                                              index]
                                                                          .onTap!
                                                                      ? Divider()
                                                                      : Container(),
                                                                  pendingWalletTransactionList[
                                                                              index]
                                                                          .onTap!
                                                                      ? Container(
                                                                          padding:
                                                                              EdgeInsets.all(10),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Container(
                                                                                    child: Text(
                                                                                      "Wallet Type:",
                                                                                      style: TextStyle(fontFamily: fontRailwayRegular, color: ColorConstants.pureBlack, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.1),
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    child: Text(
                                                                                      "${pendingWalletTransactionList[index].walletType}",
                                                                                      style: TextStyle(fontFamily: fontRailwayRegular, color: ColorConstants.pureBlack, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 1),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Visibility(
                                                                                    visible:pendingWalletTransactionList[index].cartId !=null &&  pendingWalletTransactionList[index].cartId!.length>0,
                                                                                    child: Row(
                                                                                        children: [
                                                                                          Container(
                                                                                            margin: EdgeInsets.only(top: 8, left: 2),
                                                                                            child: Text(
                                                                                              "Order id:- ",
                                                                                              style: TextStyle(
                                                                                                fontFamily: fontRailwayRegular,
                                                                                                color: ColorConstants.pureBlack,
                                                                                                fontSize: 14,
                                                                                                fontWeight: FontWeight.w400,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Container(
                                                                                            margin: EdgeInsets.only(top: 8, left: 5),
                                                                                            child: Text(
                                                                                              "${pendingWalletTransactionList[index].cartId}",
                                                                                              style: TextStyle(
                                                                                                fontFamily: fontRailwayRegular,
                                                                                                color: ColorConstants.pureBlack,
                                                                                                fontSize: 14,
                                                                                                fontWeight: FontWeight.w400,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                  ),
                                                                              walletTransactionList[index].walletType!.toLowerCase() == "reward wallet" || walletTransactionList[index].walletType!.toLowerCase() == "cash wallet"
                                                                                  ? Row(
                                                                                      children: [
                                                                                        Container(
                                                                                          margin: EdgeInsets.only(top: 8),
                                                                                          child: Text(
                                                                                            "Expiry Date:",
                                                                                            style: TextStyle(fontFamily: fontRailwayRegular, color: ColorConstants.pureBlack, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.1),
                                                                                          ),
                                                                                        ),
                                                                                        Container(
                                                                                          margin: EdgeInsets.only(top: 8, left: 8),
                                                                                          child: Text(
                                                                                            pendingWalletTransactionList[index].walletExpiryDate != null ? "${dateOnly.format(DateTime.parse((pendingWalletTransactionList[index].walletExpiryDate!)))}" : "",
                                                                                            style: TextStyle(fontFamily: fontRailwayRegular, color: ColorConstants.pureBlack, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 1),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    )
                                                                                  : Container(),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      : SizedBox(),
                                                                ],
                                                              ),
                                                            )
                                                          : SizedBox();
                                                    },
                                                  ),
                                                )
                                          : Column(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      1.5,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/images/login_bg.png"),
                                                        fit: BoxFit.cover),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'Wallet feeling light? \n"Time to fill it with gifting perks and surprises!"',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily: global
                                                              .fontRailwayRegular,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: ColorConstants
                                                              .guidlinesGolden),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                      SizedBox(
                                        height: 20,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Center(
                            child: Text(
                              'Wallet feeling light? \n"Time to fill it with gifting perks and surprises!"',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: global.fontRailwayRegular,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  color: ColorConstants.guidlinesGolden),
                            ),
                          ),
                        )
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    //_handlePrfileWallet();

    _init();
  }

  _init() async {
    try {
      _callWalletTransactionAPI();
    } catch (e) {
      print("Exception - wallet_screen.dart - _init():" + e.toString());
    }
  }

  _getRewardsWalletRedeemList(String enteredCode) async {
    try {
      showOnlyLoaderDialog();
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
              hideLoader();
              _callWalletTransactionAPI();
              // List<RewardWalletTransactionList> dataList = result.data;
            } else {
              hideLoader();
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
        hideLoader();
        print("Nikhil---------------------3");
        showNetworkErrorSnackBar(_scaffoldKey!);
      }

      setState(() {});
    } catch (e) {
      hideLoader();
      print("Nikhil---------------------4");
      print(
          "Exception - RewardsWalletRedeem_screen.dart - _getRewardsWalletRedeemList():" +
              e.toString());
    }
  }

  BusinessRule? br;
  RewardWalletTransaction? rewardWalletTransaction;
  List<RewardWalletTransactionList> walletTransactionList = [];
  List<PendingExpiryWalletDetails> pendingWalletTransactionList = [];
  _callWalletTransactionAPI() async {
    _isDataLoaded = false;
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        await apiHelper.getRewardWalletTransactions().then((result) async {
          if (result != null) {
            print("NIkhillllllllllcallWalletTransaction startlllllllllllll");
            rewardWalletTransaction = result.data;
            walletTransactionList.clear();
            pendingWalletTransactionList.clear();
            walletTransactionList
                .addAll(rewardWalletTransaction!.walletDetails!);

            pendingWalletTransactionList
                .addAll(rewardWalletTransaction!.pendingExpiryWalletDetails!);
            setState(() {
              _isDataLoaded = true;
              onRedeemClicked = false;
            });
          } else {
            walletTransactionList != null;
            _isDataLoaded = true;
            onRedeemClicked = false;
          }
        });
      } else {
        Fluttertoast.showToast(
          msg: "Please check your Internet Connection", // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.CENTER, // location
          // duration
        );
        onRedeemClicked = false;
      }
    } catch (e) {
      _isDataLoaded = true;
      onRedeemClicked = false;
      walletTransactionList != null;
      Fluttertoast.showToast(
        msg: "Something went wrong", // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.CENTER, // location
        // duration
      );
      print("Exception - walletScreen.dart - _callWalletTransactionAPI():" +
          e.toString());
    }
  }
}
