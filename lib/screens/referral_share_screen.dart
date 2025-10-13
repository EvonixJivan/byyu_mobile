import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';

import '../models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;

class ReferralShareScreen extends BaseRoute {
  ReferralShareScreen({a, o}) : super(a: a, o: o, r: 'WalletScreen');
  @override
  _ReferralShareScreenState createState() => new _ReferralShareScreenState();
}

class _ReferralShareScreenState extends BaseRouteState {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      if (global.currentUser != null && global.currentUser.id != null) {
        _getAppInfo();
      }
    });
  }

  _getAppInfo() async {
    showOnlyLoaderDialog();
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        await apiHelper.getAppInfo().then((result) async {
          if (result != null) {
            if (result.status == "1") {
              global.appInfo = result.data;
              print(global.appInfo.userwallet);
              hideLoader();
              setState(() {});
            } else {}
          } else {
            hideLoader();
          }
        });
      }
    } catch (e) {
      hideLoader();
      print("Exception - PaymentScreen.dart - _getAppInfo():" + e.toString());
    }
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

  void hideLoader() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.colorPageBackground,
      appBar: AppBar(
        backgroundColor: ColorConstants.appBarColorWhite,
        title: Text(
          "Refer & Earn",
          style: TextStyle(
              color: ColorConstants.pureBlack,
              fontFamily: fontRailwayRegular,
              fontWeight: FontWeight.w200), //textTheme.titleLarge,
        ),
        centerTitle: false,
        leading: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: ColorConstants.newAppColor),
        
      ),

      // body: Container(
      //   height: MediaQuery.of(context).size.height,
      //   width: MediaQuery.of(context).size.width,
      //   decoration: BoxDecoration(
      //     color: ColorConstants.greyDull,
      //     // image: DecorationImage(
      //     //     image: AssetImage("assets/images/login_bg.png"),
      //     //     fit: BoxFit.cover)
      //   ),
      //   child: Container(
      //     margin: EdgeInsets.only(left: 5, right: 5),
      //     child: SingleChildScrollView(
      //       scrollDirection: Axis.vertical,
      //       child: Column(
      //         children: [
      //           SizedBox(
      //             height: 8,
      //           ),
      //           Container(
      //             width: MediaQuery.of(context).size.width,
      //             height: 280,
      //             child: Center(
      //               child: Container(
      //                 height: 280,
      //                 width: MediaQuery.of(context).size.width,
      //                 child: Image.asset(
      //                   'assets/images/refer_earn.png',
      //                   fit: BoxFit.contain,
      //                 ),
      //               ),
      //             ),
      //           ),
      //           SizedBox(
      //             height: 20,
      //           ),
      //           Container(
      //             width: MediaQuery.of(context).size.width,
      //             margin: EdgeInsets.only(left: 8, right: 8),
      //             child: Text(
      //               "Refer and enjoy rewards together!",
      //               textAlign: TextAlign.start,
      //               style: TextStyle(
      //                   fontFamily: fontMontserratLight,
      //                   fontSize: 18,
      //                   // fontWeight: FontWeight.w500,
      //                   letterSpacing: 0.1,
      //                   color: ColorConstants.pureBlack),
      //             ),
      //           ),
      //           SizedBox(
      //             height: 10,
      //           ),
      //           Align(
      //             alignment: Alignment.center,
      //             child: Padding(
      //               padding: EdgeInsets.only(left: 10, right: 10),
      //               child: Text(
      //                 "Gift joy with every referral! Invite friends to byyu and earn AED ${appInfo.myReferralAmount!.toStringAsFixed(2)} as a thank you. Your friends receive a warm welcome with AED ${appInfo.referedtoAmount!.toStringAsFixed(2)} off their first cherished order. Spread the delight with byyu!",
      //                 textAlign: TextAlign.start,
      //                 style: TextStyle(
      //                     fontFamily: fontRailwayRegular,
      //                     fontSize: 15,
      //                     fontWeight: FontWeight.w200,
      //                     letterSpacing: 0.1,
      //                     color: ColorConstants.pureBlack),
      //               ),
      //             ),
      //           ),
      //           SizedBox(
      //             height: 10,
      //           ),
      //           Container(
      //             width: MediaQuery.of(context).size.width,
      //             padding: EdgeInsets.only(top: 8, bottom: 8),
      //             margin: EdgeInsets.only(left: 8, right: 8),
      //             decoration: BoxDecoration(
      //                 color: Colors.green.shade50,
      //                 border: Border.all(
      //                   color: ColorConstants.allBorderColor,
      //                 ),
      //                 borderRadius: BorderRadius.circular(8)),
      //             child: Text(
      //               "Refer code: ${global.currentUser.referralCode}",
      //               textAlign: TextAlign.center,
      //               style: TextStyle(
      //                   fontFamily: fontMontserratLight,
      //                   fontSize: 15,
      //                   letterSpacing: 0.5,
      //                   // fontWeight: FontWeight.w600,
      //                   color: ColorConstants.pureBlack),
      //             ),
      //           ),
      //           SizedBox(
      //             height: 15,
      //           ),
      //           Container(
      //             margin: EdgeInsets.only(left: 8, right: 8),
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 Container(
      //                   width: MediaQuery.of(context).size.width / 2.2,
      //                   padding: EdgeInsets.only(
      //                       top: 8, bottom: 8, right: 5, left: 5),
      //                   decoration: BoxDecoration(
      //                       border: Border.all(
      //                           color: ColorConstants.allBorderColor),
      //                       borderRadius: BorderRadius.circular(8),
      //                       color: ColorConstants.greyfaint),
      //                   child: Column(
      //                     children: [
      //                       Text(
      //                         "${appInfo.myReferralsCount!}",
      //                         textAlign: TextAlign.center,
      //                         overflow: TextOverflow.ellipsis,
      //                         style: TextStyle(
      //                             fontFamily: fontMontserratLight,
      //                             fontSize: 15,
      //                             // fontWeight: FontWeight.w600,
      //                             letterSpacing: 1,
      //                             color: ColorConstants.pureBlack),
      //                       ),
      //                       SizedBox(
      //                         height: 8,
      //                       ),
      //                       Text(
      //                         "Referrals",
      //                         textAlign: TextAlign.center,
      //                         style: TextStyle(
      //                             fontFamily: fontRailwayRegular,
      //                             fontSize: 13,
      //                             fontWeight: FontWeight.w200,
      //                             color: ColorConstants.pureBlack),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //                 Container(
      //                   width: MediaQuery.of(context).size.width / 2.2,
      //                   padding: EdgeInsets.only(
      //                       top: 8, bottom: 8, right: 5, left: 5),
      //                   decoration: BoxDecoration(
      //                       border: Border.all(
      //                           color: ColorConstants.allBorderColor),
      //                       borderRadius: BorderRadius.circular(8),
      //                       color: ColorConstants.greyfaint),
      //                   child: Column(
      //                     children: [
      //                       Row(
      //                         mainAxisAlignment: MainAxisAlignment.center,
      //                         crossAxisAlignment: CrossAxisAlignment.center,
      //                         children: [
      //                           Text(
      //                             "AED",
      //                             textAlign: TextAlign.center,
      //                             style: TextStyle(
      //                                 fontFamily: fontMontserratLight,
      //                                 fontSize: 10,
      //                                 // fontWeight: FontWeight.w600,
      //                                 color: ColorConstants.pureBlack),
      //                           ),
      //                           SizedBox(width: 5),
      //                           Flexible(
      //                             child: Text(
      //                               appInfo.myReferralsEarned != null
      //                                   ? "${appInfo.myReferralsEarned}"
      //                                   : "0",
      //                               textAlign: TextAlign.center,
      //                               overflow: TextOverflow.ellipsis,
      //                               style: TextStyle(
      //                                   fontFamily: fontMontserratLight,
      //                                   fontSize: 15,
      //                                   // fontWeight: FontWeight.w600,
      //                                   color: ColorConstants.pureBlack),
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                       SizedBox(
      //                         height: 8,
      //                       ),
      //                       Text(
      //                         "Earned",
      //                         textAlign: TextAlign.center,
      //                         style: TextStyle(
      //                             fontFamily: fontRailwayRegular,
      //                             fontSize: 13,
      //                             fontWeight: FontWeight.w200,
      //                             color: ColorConstants.pureBlack),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //           SizedBox(
      //             height: 20,
      //           ),
      //           InkWell(
      //             onTap: () async {
      //               final result = await Share.shareWithResult(
      //                   "Hey there! Your friend thinks you'll love byyu as much as they do. Click http://www.byyu.com/sharing/referral?code=${global.currentUser.referralCode} to explore what we have in store for you, and enjoy a special welcome gift from us. Let's do something amazing together. Welcome to the byyu.");

      //               if (result.status == ShareResultStatus.success) {
      //                 print('Thank you for referring');
      //               }
      //             },
      //             child: Container(
      //               margin: EdgeInsets.only(left: 10, right: 10),
      //               width: MediaQuery.of(context).size.width,
      //               padding: EdgeInsets.only(top: 10, bottom: 10),
      //               decoration: BoxDecoration(
      //                   color: ColorConstants.appColor,
      //                   border: Border.all(
      //                       color: ColorConstants.appColor, width: 0.5),
      //                   borderRadius: BorderRadius.circular(10)),
      //               child: Text(
      //                 "REFER A FRIEND",
      //                 textAlign: TextAlign.center,
      //                 // "${AppLocalizations.of(context).tle_add_new_address} ",
      //                 style: TextStyle(
      //                     fontFamily: fontMontserratMedium,
      //                     fontWeight: FontWeight.bold,
      //                     fontSize: 16,
      //                     color: ColorConstants.white,
      //                     letterSpacing: 1),
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //),),),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 18,
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(bottom: 10),
              height: 120,
              child: Center(
                child: CachedNetworkImage(
                  height: 110,
                  fit: BoxFit.contain,
                  width: 110,
                  imageUrl: global.imageBaseUrl +
                      global.appInfo.referralScreenImageUrl!,
                  imageBuilder: (context, imageProvider) => Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Container(
                    width: 70.0,
                    height: 70.0,
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: AssetImage(global.catNoImage),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // SizedBox(
            //   height: 18,
            // ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 8, right: 8),
              child: Text(
                "REFER NOW AND EARN",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: fontRailwayRegular,
                    fontWeight: FontWeight.w200,
                    fontSize: 18,
                    // fontWeight: FontWeight.w500,
                    color: ColorConstants.pureBlack),
              ),
            ),

            RichText(
              text: TextSpan(
                text: 'AED ${appInfo.myReferralAmount!.toStringAsFixed(2)} ',
                style: TextStyle(
                  color: ColorConstants.appColor,
                  fontSize: 17,
                  fontFamily: fontOufitMedium,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: ' for each referral ',
                      style: TextStyle(
                          color: ColorConstants.pureBlack,
                          fontSize: 17,
                          fontFamily: fontRailwayRegular,
                          fontWeight: FontWeight.w200)),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding:
                      EdgeInsets.only(left: 8, right: 8, top: 15, bottom: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ColorConstants.white,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        width: 50,
                        height: 50,
                        'assets/images/referral_first.png',
                        fit: BoxFit.contain,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Invite your friends to byyu's",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontFamily: fontRailwayRegular,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                
                                  // fontWeight: FontWeight.w600,
                                  color: ColorConstants.newTextHeadingFooter),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              child: Text(
                                "(Send a referral link to your friend via SMS/ Email/ WhatsApp)",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    height: 1.4,
                                    fontFamily: fontRailwayRegular,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.2,
                                    color: ColorConstants.appColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ///////////////////////////////////////////////////////
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding:
                      EdgeInsets.only(left: 8, right: 8, top: 15, bottom: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ColorConstants.white,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        width: 50,
                        height: 50,
                        'assets/images/referral_second.png',
                        fit: BoxFit.contain,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Your friends receive ",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontFamily: fontRailwayRegular,
                                  fontWeight: FontWeight.w200,
                                  fontSize: 15,
                                  color: ColorConstants.pureBlack),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            RichText(
                              text: TextSpan(
                                text:
                                    'AED ${appInfo.referedtoAmount!.toStringAsFixed(2)} ',
                                style: TextStyle(
                                  color: ColorConstants.appColor,
                                  fontSize: 16,
                                  fontFamily: fontOufitMedium,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'off their initial purchase.',
                                      style: TextStyle(
                                        color: ColorConstants.pureBlack,
                                        fontSize: 15,
                                        fontFamily: fontRailwayRegular,
                                        fontWeight: FontWeight.w200,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            /////////////////////////////////////////////////////////////////////////////
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding:
                      EdgeInsets.only(left: 8, right: 8, top: 15, bottom: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ColorConstants.white,
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.red, //Colors.grey.withOpacity(0.5),
                    //     blurRadius: 15.0,
                    //     offset: Offset(0.0, 0.55), // changes position of shadow
                    //   ),
                    // ],
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        width: 50,
                        height: 50,
                        'assets/images/referral_third.png',
                        fit: BoxFit.contain,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'You get ',
                                style: TextStyle(
                                  color: ColorConstants.pureBlack,
                                  fontSize: 15,
                                  fontFamily: fontRailwayRegular,
                                  fontWeight: FontWeight.w200,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          ' AED ${appInfo.myReferralAmount!.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: ColorConstants.appColor,
                                        fontSize: 16,
                                        fontFamily: fontOufitMedium,
                                      )),
                                  TextSpan(
                                      text:
                                          ' for every friend that makes purchase.',
                                      style: TextStyle(
                                        height: 1.2,
                                        color: ColorConstants.pureBlack,
                                        fontSize: 15,
                                        fontFamily: fontRailwayRegular,
                                        fontWeight: FontWeight.w400,
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 18, bottom: 18),
              margin: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                  color: ColorConstants.colorHomePageSectiondim,
                  border: Border.all(
                    color: Colors.green.shade50,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                "Referral code: ${global.currentUser.referralCode}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: fontRalewayMedium,
                    fontSize: 15,
                    letterSpacing: 0.5,
                    // fontWeight: FontWeight.w600,
                    color: ColorConstants.pureBlack),
              ),
            ),

            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2.2,
                    padding:
                        EdgeInsets.only(top: 8, bottom: 8, right: 5, left: 5),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: ColorConstants.appColor),
                        borderRadius: BorderRadius.circular(8),
                        color: ColorConstants.colorHomePageSectiondim),
                    child: Column(
                      children: [
                        Text(
                          "${appInfo.myReferralsCount!}",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: fontRailwayRegular,
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                              color: ColorConstants.newTextHeadingFooter),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Referrals",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: fontRailwayRegular,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: ColorConstants.pureBlack),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.2,
                    padding:
                        EdgeInsets.only(top: 8, bottom: 8, right: 5, left: 5),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: ColorConstants.appColor),
                        borderRadius: BorderRadius.circular(8),
                        color: ColorConstants.colorHomePageSectiondim),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "AED",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: fontOufitMedium,
                                  fontSize: 15,
                                  // fontWeight: FontWeight.w600,
                                  color: ColorConstants.pureBlack),
                            ),
                            SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                appInfo.myReferralsEarned != null
                                    ? "${appInfo.myReferralsEarned}"
                                    : "0",
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: fontOufitMedium,
                                    fontSize: 15,
                                    // fontWeight: FontWeight.w600,
                                    color: ColorConstants.pureBlack),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Earned",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: fontRailwayRegular,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: ColorConstants.pureBlack),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () async {
                final result = await Share.shareWithResult(
                    "Hey there! Your friend thinks you'll love byyu as much as they do. Click http://www.byyu.com/sharing/referral?code=${global.currentUser.referralCode} to explore what we have in store for you, and enjoy a special welcome gift from us. Let's do something amazing together. Welcome to the byyu.");

                if (result.status == ShareResultStatus.success) {
                  print('Thank you for referring');
                }
              },
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                    color: ColorConstants.appColor,
                    border:
                        Border.all(color: ColorConstants.appColor, width: 0.5),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "REFER A FRIEND",
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
            SizedBox(
              height: 18,
            ),
          ],
        ),
      ),

      // bottomNavigationBar: Padding(
      //   padding: EdgeInsets.all(Platform.isIOS ? 20 : 10),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children: [
      //       InkWell(
      //         onTap: () async {
      //           final result = await Share.shareWithResult(
      //               "Hey there! 🌈 Your friend thinks you'll love byyu as much as they do. Click http://byyu.com/referCode?code=${global.currentUser.referralCode} to explore what we have in store for you, and enjoy a special welcome gift from us. Let's do something amazing together. Welcome to the byyu.");

      //           if (result.status == ShareResultStatus.success) {
      //             print('Thank you for referring');
      //           }
      //         },
      //         child: Container(
      //           margin: EdgeInsets.only(left: 10, right: 10),
      //           width: MediaQuery.of(context).size.width / 1.3,
      //           padding: EdgeInsets.only(top: 10, bottom: 10),
      //           decoration: BoxDecoration(
      //               color: ColorConstants.appColor,
      //               border:
      //                   Border.all(color: ColorConstants.appColor, width: 0.5),
      //               borderRadius: BorderRadius.circular(10)),
      //           child: Text(
      //             "SHARE INVITE",
      //             textAlign: TextAlign.center,
      //             // "${AppLocalizations.of(context).tle_add_new_address} ",
      //             style: TextStyle(
      //                 fontFamily: fontMontserratMedium,
      //                 fontWeight: FontWeight.bold,
      //                 fontSize: 16,
      //                 color: ColorConstants.white,
      //                 letterSpacing: 1),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
