////###################################################skip update dialog
// _updateDialog(String msg) async {
//     try {
//       showCupertinoDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (BuildContext context) {
//             return Theme(
//               data: ThemeData(dialogBackgroundColor: Colors.white),
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: Text(""),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: ColorConstants.dialogBackground,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       children: [
//                         Image.asset(
//                           'assets/images/gift_rocket.png',
//                           width: MediaQuery.of(context).size.width / 1.5,
//                           height: MediaQuery.of(context).size.width / 1.5,
//                           fit: BoxFit.contain,
//                         ),

//                         Container(
//                           margin: EdgeInsets.only(top: 10),
//                           padding: EdgeInsets.only(left: 10, right: 10),
//                           child: Container(
//                             child: Column(
//                               children: [
//                                 SizedBox(
//                                   height: 15,
//                                 ),
//                                 Text(
//                                   'App update Required!',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       fontFamily: fontMetropolisRegular,
//                                       fontWeight: FontWeight.w200,
//                                       color: ColorConstants.pureBlack),
//                                 ),
//                                 SizedBox(
//                                   height: 15,
//                                 ),
//                                 Text(
//                                   '${msg}',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       fontFamily: fontMetropolisRegular,
//                                       fontWeight: FontWeight.w200,
//                                       color: ColorConstants.pureBlack),
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 Container(
//                                   height: 1,
//                                   width:
//                                       MediaQuery.of(context).size.width - 100,
//                                   color: ColorConstants.grey,
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 Container(
//                                   width:
//                                       MediaQuery.of(context).size.width - 100,
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceAround,
//                                     children: [
//                                       Expanded(
//                                         child: GestureDetector(
//                                           onTap: () async {
//                                             // Navigator.of(context).pop();
//                                             // _updateDialog(msg);
//                                             global.isSplashSelected = false;
//                                             bool isConnected =
//                                                 await br.checkConnectivity();
//                                             showOnlyLoaderDialog();
//                                             if (isConnected) {
//                                               if (global.sp.getString(
//                                                       'currentUser') !=
//                                                   null) {
//                                                 global.currentUser = CurrentUser
//                                                     .fromJson(json.decode(
//                                                         global.sp.getString(
//                                                             "currentUser")));

//                                                 if (global.sp.getString(
//                                                         global.appLoadString) !=
//                                                     null) {
//                                                   Navigator.of(context).push(
//                                                       MaterialPageRoute(
//                                                           builder: (context) =>
//                                                               HomeScreen(
//                                                                 a: widget
//                                                                     .analytics,
//                                                                 o: widget
//                                                                     .observer,
//                                                                 selectedIndex:
//                                                                     0,
//                                                               )));
//                                                 } else {
//                                                   Navigator.of(context).push(
//                                                       MaterialPageRoute(
//                                                           builder: (context) =>
//                                                               IntroSliderScreen(
//                                                                 a: widget
//                                                                     .analytics,
//                                                                 o: widget
//                                                                     .observer,
//                                                               )));
//                                                 }
//                                                 // await _getAppNotice();
//                                               } else {
//                                                 if (global.sp.getString(
//                                                         global.appLoadString) !=
//                                                     null) {
//                                                   Navigator.of(context).push(
//                                                       MaterialPageRoute(
//                                                           builder: (context) =>
//                                                               HomeScreen(
//                                                                 a: widget
//                                                                     .analytics,
//                                                                 o: widget
//                                                                     .observer,
//                                                                 selectedIndex:
//                                                                     0,
//                                                               )));
//                                                 } else {
//                                                   Navigator.of(context).push(
//                                                       MaterialPageRoute(
//                                                           builder: (context) =>
//                                                               IntroSliderScreen(
//                                                                 a: widget
//                                                                     .analytics,
//                                                                 o: widget
//                                                                     .observer,
//                                                               )));
//                                                 }
//                                               }
//                                             } else {
//                                               showNetworkErrorSnackBar(
//                                                   _scaffoldKey);
//                                             }
//                                           },
//                                           child: Text('Skip',
//                                               textAlign: TextAlign.center,
//                                               style: TextStyle(
//                                                   fontSize: 16,
//                                                   fontFamily:
//                                                       fontMetropolisRegular,
//                                                   fontWeight: FontWeight.w200,
//                                                   color:
//                                                       ColorConstants.appColor)),
//                                         ),
//                                       ),
//                                       Container(
//                                         height: 20,
//                                         width: 1,
//                                         color: ColorConstants.grey,
//                                       ),
//                                       Expanded(
//                                         child: GestureDetector(
//                                           onTap: () async {
//                                             global.sp
//                                                 .setBool("UpdateClicked", true);
//                                             Navigator.of(context).pop();
//                                             print(global.appInfo.app_link);
//                                             var url =
//                                                 "${global.appInfo.app_link}";
//                                             if (await canLaunch(url))
//                                               await launch(url);
//                                             else
//                                               // can't launch url, there is some error
//                                               throw "Could not launch $url";
//                                           },
//                                           child: Text('Update',
//                                               textAlign: TextAlign.center,
//                                               style: TextStyle(
//                                                   fontSize: 16,
//                                                   fontFamily:
//                                                       fontMetropolisRegular,
//                                                   fontWeight: FontWeight.w200,
//                                                   color: Colors.blue.shade300)),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),

//                         // CupertinoAlertDialog(
//                         //   title: Text(
//                         //     '',
//                         //   ),
//                         //   content: Text(
//                         //     '${msg}',
//                         //     style: TextStyle(
//                         //       fontSize: 14,
//                         //       fontFamily: fontMetropolisRegular,
//                         //       fontWeight: FontWeight.w200,
//                         //     ),
//                         //   ),
//                         //   actions: <Widget>[
//                         //     CupertinoDialogAction(
//                         //       child: Text('Update',
//                         //           style: TextStyle(
//                         //             fontSize: 16,
//                         //             fontFamily: fontMetropolisRegular,
//                         //             fontWeight: FontWeight.w200,
//                         //           )),
//                         //       onPressed: () async {
//                         //         Navigator.of(context).pop();
//                         //         _updateForcefullyDialog(msg);
//                         //         // global.sp.setBool("UpdateClicked", true);
//                         //         // Navigator.of(context).pop();
//                         //         // print(global.appInfo.app_link);
//                         //         // var url = "${global.appInfo.app_link}";
//                         //         // if (await canLaunch(url))
//                         //         //   await launch(url);
//                         //         // else
//                         //         //   // can't launch url, there is some error
//                         //         //   throw "Could not launch $url";
//                         //       },
//                         //     ),
//                         //   ],
//                         // ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: Text(""),
//                   ),
//                 ],
//               ),
//             );
//           });

//       // showCupertinoDialog(
//       //     context: context,
//       //     barrierDismissible: false,
//       //     builder: (BuildContext context) {
//       //       return Theme(
//       //         data: ThemeData(dialogBackgroundColor: Colors.white),
//       //         child: CupertinoAlertDialog(
//       //           title: Image.asset(
//       //             'assets/images/gift_rocket.png',
//       //             width: 20,
//       //             height: 20,
//       //             fit: BoxFit.fill,
//       //             color: ColorConstants.grey,
//       //           ),
//       //           content: Text(
//       //             '${msg}',
//       //             style: TextStyle(
//       //                 fontSize: 14,
//       //                 fontFamily: fontMetropolisRegular,
//       //                 fontWeight: FontWeight.w200,
//       //                 color: ColorConstants.pureBlack),
//       //           ),
//       //           actions: <Widget>[
//       //             CupertinoDialogAction(
//       //               child: Text('Skip',
//       //                   style: TextStyle(
//       //                       fontSize: 16,
//       //                       fontFamily: fontMetropolisRegular,
//       //                       fontWeight: FontWeight.w200,
//       //                       color: ColorConstants.appColor)),
//       //               onPressed: () async {
//       //                 global.isSplashSelected = false;
//       //                 bool isConnected = await br.checkConnectivity();
//       //                 showOnlyLoaderDialog();
//       //                 if (isConnected) {
//       //                   if (global.sp.getString('currentUser') != null) {
//       //                     global.currentUser = CurrentUser.fromJson(
//       //                         json.decode(global.sp.getString("currentUser")));

//       //                     if (global.sp.getString(global.appLoadString) !=
//       //                         null) {
//       //                       Navigator.of(context).push(MaterialPageRoute(
//       //                           builder: (context) => HomeScreen(
//       //                                 a: widget.analytics,
//       //                                 o: widget.observer,
//       //                                 selectedIndex: 0,
//       //                               )));
//       //                     } else {
//       //                       Navigator.of(context).push(MaterialPageRoute(
//       //                           builder: (context) => IntroSliderScreen(
//       //                                 a: widget.analytics,
//       //                                 o: widget.observer,
//       //                               )));
//       //                     }
//       //                     // await _getAppNotice();
//       //                   } else {
//       //                     if (global.sp.getString(global.appLoadString) !=
//       //                         null) {
//       //                       Navigator.of(context).push(MaterialPageRoute(
//       //                           builder: (context) => HomeScreen(
//       //                                 a: widget.analytics,
//       //                                 o: widget.observer,
//       //                                 selectedIndex: 0,
//       //                               )));
//       //                     } else {
//       //                       Navigator.of(context).push(MaterialPageRoute(
//       //                           builder: (context) => IntroSliderScreen(
//       //                                 a: widget.analytics,
//       //                                 o: widget.observer,
//       //                               )));
//       //                     }
//       //                   }
//       //                 } else {
//       //                   showNetworkErrorSnackBar(_scaffoldKey);
//       //                 }
//       //               },
//       //             ),
//       //             CupertinoDialogAction(
//       //               child: Text(
//       //                 'Update',
//       //                 style: TextStyle(
//       //                   fontSize: 16,
//       //                   fontFamily: fontMetropolisRegular,
//       //                   fontWeight: FontWeight.w200,
//       //                 ),
//       //               ),
//       //               onPressed: () async {
//       //                 global.sp.setBool("UpdateClicked", true);
//       //                 Navigator.of(context).pop();
//       //                 print(global.appInfo.app_link);
//       //                 var url = "${global.appInfo.app_link}";
//       //                 if (await canLaunch(url))
//       //                   await launch(url);
//       //                 else
//       //                   // can't launch url, there is some error
//       //                   throw "Could not launch $url";
//       //               },
//       //             ),
//       //           ],
//       //         ),
//       //       );
//       //     });
//     } catch (e) {
//       print('Exception - app_menu_screen.dart - exitAppDialog(): ' +
//           e.toString());
//     }
//   }

///############################################################ForceUpdate Dialog
//  _updateForcefullyDialog(String msg) async {
//     try {
//       showCupertinoDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (BuildContext context) {
//             return Theme(
//               data: ThemeData(dialogBackgroundColor: Colors.white),
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: Text(""),
//                   ),
//                   Stack(
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(""),
//                           ),
//                           Container(
//                             margin: EdgeInsets.only(top: 75),
//                             decoration: BoxDecoration(
//                               color: ColorConstants.dialogBackground,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             padding: EdgeInsets.only(
//                                 top: MediaQuery.of(context).size.width / 3.5,
//                                 left: 10,
//                                 right: 10),
//                             child: Column(
//                               children: [
//                                 SizedBox(
//                                   height: 15,
//                                 ),
//                                 Text(
//                                   '${msg}',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       fontFamily: fontMetropolisRegular,
//                                       fontWeight: FontWeight.w200,
//                                       color: ColorConstants.pureBlack),
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 Container(
//                                   height: 1,
//                                   width:
//                                       MediaQuery.of(context).size.width - 100,
//                                   color: ColorConstants.grey,
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 Container(
//                                   child: GestureDetector(
//                                     onTap: () async {
//                                       global.sp.setBool("UpdateClicked", true);
//                                       Navigator.of(context).pop();
//                                       print(global.appInfo.app_link);
//                                       var url = "${global.appInfo.app_link}";
//                                       if (await canLaunch(url))
//                                         await launch(url);
//                                       else
//                                         // can't launch url, there is some error
//                                         throw "Could not launch $url";
//                                     },
//                                     child: Text('Update',
//                                         style: TextStyle(
//                                             fontSize: 16,
//                                             fontFamily: fontMetropolisRegular,
//                                             fontWeight: FontWeight.w200,
//                                             color: Colors.blue.shade300)),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Expanded(
//                             child: Text(""),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(""),
//                           ),
//                           Image.asset(
//                             'assets/images/gift_rocket.png',
//                             width: MediaQuery.of(context).size.width / 2,
//                             height: MediaQuery.of(context).size.width / 2,
//                             fit: BoxFit.contain,
//                           ),
//                           Expanded(
//                             child: Text(""),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   // CupertinoAlertDialog(
//                   //   title: Text(
//                   //     '',
//                   //   ),
//                   //   content: Text(
//                   //     '${msg}',
//                   //     style: TextStyle(
//                   //       fontSize: 14,
//                   //       fontFamily: fontMetropolisRegular,
//                   //       fontWeight: FontWeight.w200,
//                   //     ),
//                   //   ),
//                   //   actions: <Widget>[
//                   //     CupertinoDialogAction(
//                   //       child: Text('Update',
//                   //           style: TextStyle(
//                   //             fontSize: 16,
//                   //             fontFamily: fontMetropolisRegular,
//                   //             fontWeight: FontWeight.w200,
//                   //           )),
//                   //       onPressed: () async {
//                   //         Navigator.of(context).pop();
//                   //         _updateForcefullyDialog(msg);
//                   //         // global.sp.setBool("UpdateClicked", true);
//                   //         // Navigator.of(context).pop();
//                   //         // print(global.appInfo.app_link);
//                   //         // var url = "${global.appInfo.app_link}";
//                   //         // if (await canLaunch(url))
//                   //         //   await launch(url);
//                   //         // else
//                   //         //   // can't launch url, there is some error
//                   //         //   throw "Could not launch $url";
//                   //       },
//                   //     ),
//                   //   ],
//                   // ),

//                   Expanded(
//                     child: Text(""),
//                   ),
//                 ],
//               ),
//             );
//           });
//     } catch (e) {
//       print('Exception - app_menu_screen.dart - exitAppDialog(): ' +
//           e.toString());
//     }
//   }



//############################Coupon screen TextField design#########################

// !fromDrawer
//                       ? Container(
//                           color: global.textGrey,
//                           height: 90,
//                           child: Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 10, right: 10, top: 10, bottom: 10),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                   color: global.white,
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(7.0))),
//                               height: 20,
//                               padding: EdgeInsets.only(left: 5),
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     child: MyTextField(
//                                       Key('21'),
//                                       textCapitalization:
//                                           TextCapitalization.characters,
//                                       controller: _txtApplyCoupan,
//                                       focusNode: _fCoupan,
//                                       hintText: 'Enter coupon code',
//                                       maxLines: 1,
//                                       onFieldSubmitted: (val) {},
//                                     ),
//                                   ),
//                                   TextButton(
//                                     onPressed: () async {
//                                       if (_txtApplyCoupan != null &&
//                                           _txtApplyCoupan.text.isNotEmpty) {
//                                         // await _applyCoupon("Breakfast Bonanza 15");
//                                         isTextEnteredCoupon = true;
//                                         await _applyCoupon(
//                                             _txtApplyCoupan.text);
//                                       } else {
//                                         showSnackBar(
//                                             key: _scaffoldKey1,
//                                             snackBarMessage:
//                                                 'Please enter coupon code');
//                                       }
//                                     },
//                                     child: Text(
//                                       'Apply',
//                                       style: TextStyle(
//                                           color: ColorConstants.pureBlack,
//                                           fontFamily: fontMetropolisRegular,
//                                           fontWeight: FontWeight.w200),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                       : SizedBox(),

/// this is the payment screen redeem code design
// Container(
                    //   margin: EdgeInsets.only(left: 0, right: 0, top: 10),
                    //   decoration: BoxDecoration(
                    //     color: ColorConstants.white,
                    //   ),
                    //   child: Visibility(
                    //     visible: false,
                    //     child: Align(
                    //       alignment: Alignment.centerLeft,
                    //       child: Padding(
                    //         padding: const EdgeInsets.only(
                    //             left: 16, top: 10, bottom: 10),
                    //         child: Row(
                    //           // mainAxisAlignment:
                    //           //     MainAxisAlignment.spaceAround,
                    //           children: [
                    //             SizedBox(
                    //               width: 8,
                    //             ),
                    //             Icon(
                    //               Icons.wallet_giftcard,
                    //               color: ColorConstants.pureBlack,
                    //             ),
                    //             SizedBox(
                    //               width: 16,
                    //             ),
                    //             Expanded(
                    //               child: Text(
                    //                 "Have a Gift code?",
                    //                 style: TextStyle(
                    //                     color: ColorConstants.pureBlack,
                    //                     fontFamily:
                    //                         global.fontMetropolisRegular,
                    //                     fontSize: 15,
                    //                     fontWeight: FontWeight.w200),
                    //               ),
                    //             ),
                    //             InkWell(
                    //               onTap: () {
                    //                 if (showGiftField) {
                    //                   showGiftField = false;
                    //                 } else {
                    //                   showGiftField = true;
                    //                 }
                    //                 setState(() {});
                    //               },
                    //               child: Container(
                    //                 width: 80,
                    //                 padding: EdgeInsets.only(top: 5, bottom: 5),
                    //                 decoration: BoxDecoration(
                    //                   border: Border.all(
                    //                       width: 0.5,
                    //                       color: ColorConstants.appColor),
                    //                   borderRadius: BorderRadius.circular(8),
                    //                 ),
                    //                 child: Text(
                    //                   showGiftField ? "Cancel" : "Redeem",
                    //                   textAlign: TextAlign.center,
                    //                   style: TextStyle(
                    //                       color: ColorConstants.appColor,
                    //                       fontFamily:
                    //                           global.fontMetropolisRegular,
                    //                       fontSize: 13,
                    //                       fontWeight: FontWeight.w200),
                    //                 ),
                    //               ),
                    //             ),
                    //             SizedBox(
                    //               width: 16,
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    // Visibility(
                    //   visible: showGiftField,
                    //   child: Container(
                    //     height: 45,
                    //     child: Padding(
                    //       padding: const EdgeInsets.only(
                    //         left: 10,
                    //         right: 10,
                    //       ),
                    //       child: Container(
                    //         decoration: BoxDecoration(
                    //             color: global.white,
                    //             borderRadius:
                    //                 BorderRadius.all(Radius.circular(7.0))),
                    //         padding: EdgeInsets.only(left: 5),
                    //         height: 5,
                    //         child: Row(
                    //           children: [
                    //             Expanded(
                    //               child: Container(
                    //                 height: 40,
                    //                 child: MyTextField(
                    //                   Key('21'),
                    //                   textCapitalization:
                    //                       TextCapitalization.characters,
                    //                   controller: _txtApplyCoupan,
                    //                   focusNode: _fCoupan,
                    //                   hintText: 'Enter Redeem code',
                    //                   maxLines: 1,
                    //                   onFieldSubmitted: (val) {},
                    //                 ),
                    //               ),
                    //             ),
                    //             SizedBox(
                    //               width: 5,
                    //             ),
                    //             InkWell(
                    //               onTap: () async {
                    //                 setState(() {});
                    //               },
                    //               child: Container(
                    //                 padding: EdgeInsets.only(
                    //                     left: 8, right: 8, top: 12, bottom: 12),
                    //                 decoration: BoxDecoration(
                    //                   borderRadius: BorderRadius.all(
                    //                     Radius.circular(5),
                    //                   ),
                    //                   color: ColorConstants.appColor,
                    //                   border: Border.all(
                    //                       width: 0.5,
                    //                       color: ColorConstants
                    //                           .appGoldenColortint),
                    //                 ),
                    //                 child: Text(
                    //                   "REDEEM",
                    //                   textAlign: TextAlign.center,
                    //                   style: TextStyle(
                    //                       fontFamily: fontMontserratMedium,
                    //                       fontWeight: FontWeight.bold,
                    //                       fontSize: 11,
                    //                       color: ColorConstants.white,
                    //                       letterSpacing: 1),
                    //                 ),
                    //               ),
                    //             )
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),



///////// This is the OLD Wallet Apply Remove Function 
// walletAppliedRemoved() {
//     print(isWalletSelected);
//     print(couponDiscount);
//     print(totalWalletSpendings);
//     print(totalWalletbalance);
//     print(totalOrderPrice);
//     if (isWalletSelected) {
//       if (totalWalletAmount >
//           double.parse(
//               (cartController.cartItemsList.cartData!.totalPrice).toString())) {
//         print(" nikhil------1");
//         totalWalletSpendings = double.parse(
//                 (cartController.cartItemsList.cartData!.totalPrice)
//                     .toString()) -
//             couponDiscount;
//         totalWalletbalance = totalWalletAmount - totalWalletSpendings;
//         totalOrderPrice = 0.0;
//       } else if (totalWalletAmount + couponDiscount >
//           double.parse(
//               (cartController.cartItemsList.cartData!.totalPrice).toString())) {
//         print(" nikhil------2");
//         if (totalWalletAmount > couponDiscount) {
//           totalOrderPrice = double.parse(
//                   (cartController.cartItemsList.cartData!.totalPrice)
//                       .toString()) -
//               couponDiscount;
//           if (totalWalletAmount > totalOrderPrice) {
//             totalWalletSpendings = totalWalletAmount - totalOrderPrice;
//           } else {
//             totalWalletSpendings = totalWalletAmount;
//           }
//           totalWalletbalance = totalWalletAmount - totalWalletSpendings;
//           totalOrderPrice = 0.0;
//         } else {
//           print(" nikhil------22");
//           totalOrderPrice = double.parse(
//                   (cartController.cartItemsList.cartData!.totalPrice)
//                       .toString()) -
//               couponDiscount;
//           if (totalWalletAmount > totalOrderPrice) {
//             print(" nikhil------21");
//             totalWalletSpendings = totalOrderPrice;
//           } else {
//             print(" nikhil------23");
//             totalWalletSpendings = totalWalletAmount;
//           }
//           totalWalletbalance = totalWalletAmount - totalWalletSpendings;
//           totalOrderPrice = 0.0;
//         }
//       } else {
//         print(" nikhil------3");
//         totalWalletSpendings = totalWalletAmount;
//         totalWalletbalance = 0.0;
//         totalOrderPrice = double.parse(
//                 (cartController.cartItemsList.cartData!.totalPrice)
//                     .toString()) -
//             totalWalletSpendings -
//             couponDiscount;
//       }
//     } else {
//       //////#####################this is wallet removed
//       print(" nikhil------01");

//       print(" nikhil------011");
//       totalWalletSpendings = 0.0;
//       totalWalletbalance = totalWalletAmount;
//       totalOrderPrice = double.parse(
//               (cartController.cartItemsList.cartData!.totalPrice).toString()) -
//           couponDiscount;
//     }
//   }


//////////////////////////deducted price varient product details

// _productDetail.productDetail!
//                                                   .varient![index].basePrice! <
//                                               _productDetail.productDetail!
//                                                   .varient![index].baseMrp!
//                                           ? Stack(children: [
//                                               Container(
//                                                 margin:
//                                                     EdgeInsets.only(left: 3),
//                                                 padding: EdgeInsets.only(
//                                                     top: 2, bottom: 2),
//                                                 child: Text(
//                                                   int.parse(_productDetail
//                                                               .productDetail!
//                                                               .varient![index]
//                                                               .baseMrp
//                                                               .toString()
//                                                               .substring(_productDetail
//                                                                       .productDetail!
//                                                                       .varient![
//                                                                           index]
//                                                                       .baseMrp
//                                                                       .toString()
//                                                                       .indexOf(
//                                                                           ".") +
//                                                                   1)) >
//                                                           0
//                                                       ? "${_productDetail.productDetail!.varient![index].baseMrp!.toStringAsFixed(2)}"
//                                                       : "${_productDetail.productDetail!.varient![index].baseMrp.toString().substring(0, _productDetail.productDetail!.varient![index].baseMrp.toString().indexOf("."))}", //"${product.varient[0].baseMrp}",
//                                                   textAlign: TextAlign.center,
//                                                   style: TextStyle(
//                                                       fontFamily: global
//                                                           .fontMetropolisRegular,
//                                                       fontWeight:
//                                                           FontWeight.w200,
//                                                       fontSize: 11,
//                                                       color: Colors.grey),
//                                                 ),
//                                               ),
//                                               Container(
//                                                 margin: EdgeInsets.only(
//                                                     left: 3, top: 1),
//                                                 alignment: Alignment.center,
//                                                 // decoration: BoxDecoration(
//                                                 //     color: Colors.white.withOpacity(0.6),
//                                                 //     borderRadius: BorderRadius.circular(5)),
//                                                 //padding: const EdgeInsets.all(5),
//                                                 child: Center(
//                                                   child: Transform.rotate(
//                                                     angle: 0,
//                                                     child: Text(
//                                                         _productDetail
//                                                                     .productDetail!
//                                                                     .varient![
//                                                                         index]
//                                                                     .baseMrp
//                                                                     .toString()
//                                                                     .length ==
//                                                                 3
//                                                             ? "----"
//                                                             : "-----",
//                                                         // '${AppLocalizations.of(context).txt_out_of_stock}',
//                                                         textAlign: TextAlign
//                                                             .center,
//                                                         maxLines: 2,
//                                                         style: TextStyle(
//                                                             fontFamily:
//                                                                 global
//                                                                     .fontMetropolisRegular,
//                                                             fontWeight:
//                                                                 FontWeight.w600,
//                                                             fontSize: 11,
//                                                             decoration:
//                                                                 TextDecoration
//                                                                     .lineThrough,
//                                                             color:
//                                                                 Colors.grey)),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ])
//                                           : Container(),



////////###############Search screen Filter UI design
// _isFilterApplied
//                                                     ? Container(
//                                                         height: 60,
//                                                         color: ColorConstants
//                                                             .appBrownFaintColor,
//                                                         padding:
//                                                             EdgeInsets.only(
//                                                                 bottom: 5,
//                                                                 left: 10,
//                                                                 right: 10),
//                                                         width: MediaQuery.of(
//                                                                 context)
//                                                             .size
//                                                             .width,
//                                                         child: Row(
//                                                           children: [
//                                                             Container(
//                                                               width: MediaQuery.of(
//                                                                           context)
//                                                                       .size
//                                                                       .width -
//                                                                   80,
//                                                               height: 30,
//                                                               child: ListView
//                                                                   .builder(
//                                                                       controller:
//                                                                           _scrollController,
//                                                                       physics:
//                                                                           AlwaysScrollableScrollPhysics(),
//                                                                       itemCount:
//                                                                           appliedFilter
//                                                                               .length,
//                                                                       scrollDirection:
//                                                                           Axis
//                                                                               .horizontal,
//                                                                       itemBuilder: (context,
//                                                                               index) =>
//                                                                           Container(
//                                                                             padding: EdgeInsets.only(
//                                                                                 top: 5,
//                                                                                 bottom: 5,
//                                                                                 left: 8,
//                                                                                 right: 8),
//                                                                             margin:
//                                                                                 EdgeInsets.only(right: 10),
//                                                                             decoration:
//                                                                                 BoxDecoration(border: Border.all(color: ColorConstants.grey, width: 0.5), borderRadius: BorderRadius.circular(8)),
//                                                                             child:
//                                                                                 Row(
//                                                                               children: [
//                                                                                 Align(
//                                                                                   alignment: Alignment.center,
//                                                                                   child: Text(
//                                                                                     appliedFilter[index].name!,
//                                                                                     style: TextStyle(fontFamily: global.fontMetropolisRegular, fontWeight: FontWeight.w200, fontSize: 13, color: ColorConstants.pureBlack),
//                                                                                   ),
//                                                                                 ),
//                                                                                 SizedBox(
//                                                                                   width: 8,
//                                                                                 ),
//                                                                                 InkWell(
//                                                                                   onTap: () {
//                                                                                     if (appliedFilter[index].type == "1") {
//                                                                                       _productFilter.filterPriceID = "";
//                                                                                     }
//                                                                                     if (appliedFilter[index].type == "2") {
//                                                                                       _productFilter.filterDiscountID = "";
//                                                                                     }
//                                                                                     if (appliedFilter[index].type == "3") {
//                                                                                       _productFilter.filterSortID = "";
//                                                                                     }
//                                                                                     if (_productSearchResult != null && _productSearchResult.length > 0) {
//                                                                                       _productSearchResult.clear();
//                                                                                       _isDataLoaded = false;
//                                                                                     }
//                                                                                     appliedFilter.removeAt(index);
//                                                                                     if (appliedFilter.length == 0) {
//                                                                                       _isFilterApplied = false;
//                                                                                       setState(() {});
//                                                                                     }
//                                                                                     // if (!global.isEventProduct) {
//                                                                                     if (_productSearchResult != null && _productSearchResult.length > 0) {
//                                                                                       _productSearchResult.clear();
//                                                                                       _isDataLoaded = false;
//                                                                                     }
//                                                                                     _getProductSearchResult();
//                                                                                     setState(() {});
//                                                                                   },
//                                                                                   child: Icon(
//                                                                                     Icons.cancel,
//                                                                                     size: 20,
//                                                                                     color: ColorConstants.pureBlack,
//                                                                                   ),
//                                                                                 ),
//                                                                               ],
//                                                                             ),
//                                                                           )),
//                                                             ),
//                                                             Expanded(
//                                                                 child:
//                                                                     Text("")),
//                                                             InkWell(
//                                                               onTap: () {
//                                                                 updateData();
//                                                               },
//                                                               child: Icon(
//                                                                 Icons.close,
//                                                                 color:
//                                                                     ColorConstants
//                                                                         .appColor,
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       )
//                                                     : SizedBox(),      
//


///////###############################Referral screen old design

// Column(
//               children: [
//                 SizedBox(
//                   height: 8,
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   height: 280,
//                   child: Center(
//                     child: Container(
//                       height: 280,
//                       width: MediaQuery.of(context).size.width,
//                       child: Image.asset(
//                         'assets/images/refer_earn.png',
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                   ),
//                 ),

                
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   margin: EdgeInsets.only(left: 8, right: 8),
//                   child: Text(
//                     "Refer and enjoy rewards together!",
//                     textAlign: TextAlign.start,
//                     style: TextStyle(
//                         fontFamily: fontMontserratLight,
//                         fontSize: 18,
//                         // fontWeight: FontWeight.w500,
//                         letterSpacing: 0.1,
//                         color: ColorConstants.pureBlack),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Align(
//                   alignment: Alignment.center,
//                   child: Padding(
//                     padding: EdgeInsets.only(left: 10, right: 10),
//                     child: Text(
//                       "Gift joy with every referral! Invite friends to byyu and earn AED ${appInfo.myReferralAmount!.toStringAsFixed(2)} as a thank you. Your friends receive a warm welcome with AED ${appInfo.referedtoAmount!.toStringAsFixed(2)} off their first cherished order. Spread the delight with byyu!",
//                       textAlign: TextAlign.start,
//                       style: TextStyle(
//                           fontFamily: fontMetropolisRegular,
//                           fontSize: 15,
//                           fontWeight: FontWeight.w200,
//                           letterSpacing: 0.1,
//                           color: ColorConstants.pureBlack),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   padding: EdgeInsets.only(top: 8, bottom: 8),
//                   margin: EdgeInsets.only(left: 8, right: 8),
//                   decoration: BoxDecoration(
//                       color: Colors.green.shade50,
//                       border: Border.all(
//                         color: ColorConstants.allBorderColor,
//                       ),
//                       borderRadius: BorderRadius.circular(8)),
//                   child: Text(
//                     "Refer code: ${global.currentUser.referralCode}",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                         fontFamily: fontMontserratLight,
//                         fontSize: 15,
//                         letterSpacing: 0.5,
//                         // fontWeight: FontWeight.w600,
//                         color: ColorConstants.pureBlack),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(left: 8, right: 8),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         width: MediaQuery.of(context).size.width / 2.2,
//                         padding: EdgeInsets.only(
//                             top: 8, bottom: 8, right: 5, left: 5),
//                         decoration: BoxDecoration(
//                             border: Border.all(
//                                 color: ColorConstants.allBorderColor),
//                             borderRadius: BorderRadius.circular(8),
//                             color: ColorConstants.greyfaint),
//                         child: Column(
//                           children: [
//                             Text(
//                               "${appInfo.myReferralsCount!}",
//                               textAlign: TextAlign.center,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                   fontFamily: fontMontserratLight,
//                                   fontSize: 15,
//                                   // fontWeight: FontWeight.w600,
//                                   letterSpacing: 1,
//                                   color: ColorConstants.pureBlack),
//                             ),
//                             SizedBox(
//                               height: 8,
//                             ),
//                             Text(
//                               "Referrals",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                   fontFamily: fontMetropolisRegular,
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w200,
//                                   color: ColorConstants.pureBlack),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         width: MediaQuery.of(context).size.width / 2.2,
//                         padding: EdgeInsets.only(
//                             top: 8, bottom: 8, right: 5, left: 5),
//                         decoration: BoxDecoration(
//                             border: Border.all(
//                                 color: ColorConstants.allBorderColor),
//                             borderRadius: BorderRadius.circular(8),
//                             color: ColorConstants.greyfaint),
//                         child: Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "AED",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       fontFamily: fontMontserratLight,
//                                       fontSize: 10,
//                                       // fontWeight: FontWeight.w600,
//                                       color: ColorConstants.pureBlack),
//                                 ),
//                                 SizedBox(width: 5),
//                                 Flexible(
//                                   child: Text(
//                                     appInfo.myReferralsEarned != null
//                                         ? "${appInfo.myReferralsEarned}"
//                                         : "0",
//                                     textAlign: TextAlign.center,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(
//                                         fontFamily: fontMontserratLight,
//                                         fontSize: 15,
//                                         // fontWeight: FontWeight.w600,
//                                         color: ColorConstants.pureBlack),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: 8,
//                             ),
//                             Text(
//                               "Earned",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                   fontFamily: fontMetropolisRegular,
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w200,
//                                   color: ColorConstants.pureBlack),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

                

//                 SizedBox(
//                   height: 20,
//                 ),
               

//                 InkWell(
//                   onTap: () async {
//                     final result = await Share.shareWithResult(
//                         "Hey there! Your friend thinks you'll love byyu as much as they do. Click http://www.byyu.com/sharing/referral?code=${global.currentUser.referralCode} to explore what we have in store for you, and enjoy a special welcome gift from us. Let's do something amazing together. Welcome to the byyu.");

//                     if (result.status == ShareResultStatus.success) {
//                       print('Thank you for referring');
//                     }
//                   },
//                   child: Container(
//                     margin: EdgeInsets.only(left: 10, right: 10),
//                     width: MediaQuery.of(context).size.width,
//                     padding: EdgeInsets.only(top: 10, bottom: 10),
//                     decoration: BoxDecoration(
//                         color: ColorConstants.appColor,
//                         border: Border.all(
//                             color: ColorConstants.appColor, width: 0.5),
//                         borderRadius: BorderRadius.circular(10)),
//                     child: Text(
//                       "REFER A FRIEND",
//                       textAlign: TextAlign.center,
//                       // "${AppLocalizations.of(context).tle_add_new_address} ",
//                       style: TextStyle(
//                           fontFamily: fontMontserratMedium,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                           color: ColorConstants.white,
//                           letterSpacing: 1),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
      