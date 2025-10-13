import 'dart:math';

import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/models/rewardWalletRedeemModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
  
import 'package:intl/intl.dart';

class RewardsWalletRedeemCard extends StatefulWidget {
  final RewardWalletRedeemList? rewardWalletRedeem;
  final Function? onRedeem;

  RewardsWalletRedeemCard({
    this.rewardWalletRedeem,
    this.onRedeem,
  }) : super();

  @override
  _RewardsWalletRedeemCardState createState() => _RewardsWalletRedeemCardState(
        rewardWalletRedeem: rewardWalletRedeem!,
        onRedeem: onRedeem!,
      );
}

class _RewardsWalletRedeemCardState extends State<RewardsWalletRedeemCard> {
  RewardWalletRedeemList? rewardWalletRedeem;
  Function? onRedeem;
  String? colorCode;

  final Color color = const Color(0xffFF0000);
  final double height = Get.height;
  final double width = Get.width;
  bool _showTC = false;
  bool? fromDrawer;

  _RewardsWalletRedeemCardState({this.rewardWalletRedeem, this.onRedeem});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(left: 10),
          padding: EdgeInsets.only(left: 55),
          child: Card(
            child: Container(
              // height: height * 0.24,
              width: width,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 40.0, right: 10, top: 8, bottom: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: width - 160,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          Container(
                            // width: MediaQuery.of(context).size.width / 3.1,
                            child: Text(
                                "${rewardWalletRedeem!.rewardName}", //coupon.couponName,
                                maxLines: 2,
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: ColorConstants.pureBlack,
                                    fontFamily: global.fontRailwayRegular,
                                    fontWeight: FontWeight.w200,
                                    fontSize: 14)),
                          ),
                          // coupon.userUses == coupon.usesRestriction
                          //     ? SizedBox()
                          //     : InkWell(
                          //         //onTap: () => onRedeem(),
                          //         child: Container(
                          //           height: 25, // height * 0.044,
                          //           width: width * 0.23,
                          //           child: Center(
                          //               child: Text('Apply',
                          //                   style: GoogleFonts.poppins(
                          //                       fontWeight: FontWeight.w600,
                          //                       fontSize: 14,
                          //                       color:
                          //                           global.indigoColor))),
                          //           decoration: BoxDecoration(
                          //             borderRadius: BorderRadius.all(
                          //               Radius.circular(5),
                          //             ),
                          //             border: Border.all(
                          //                 width: 0.5,
                          //                 color: ColorConstants.appColor),
                          //           ),
                          //         ),
                          //       ),
                          //   ],
                          // ),
                          SizedBox(
                            height: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 5, right: 5, top: 5, bottom: 5),
                                    //height: height * 0.040,
                                    child: Text(
                                      "${rewardWalletRedeem!.rewardDescription}", //"${coupon.couponCode}",

                                      style: TextStyle(
                                          color: ColorConstants.pureBlack,
                                          fontSize: 12,
                                          fontFamily:
                                              global.fontRailwayRegular,
                                          fontWeight: FontWeight.w200),
                                    ),
                                  ),
                                  Expanded(child: Text('')),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                //height: 50,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (_showTC) {
                                          _showTC = false;
                                        } else {
                                          _showTC = true;
                                        }
                                        setState(() {});
                                      },
                                      child: Container(
                                        child: Text(
                                          "Terms & conditions :", //'${coupon.couponDescription}',
                                          style: TextStyle(
                                              color: ColorConstants.appColor,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                    _showTC
                                        ? Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                        top: 8,
                                                      ),
                                                      child: Text(
                                                        "Expiry date:",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                fontRailwayRegular,
                                                            color:
                                                                ColorConstants
                                                                    .pureBlack,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w200,
                                                            letterSpacing: 1),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 8, left: 8),
                                                      child: Text(
                                                        "${rewardWalletRedeem!.expiryDate}",
                                                        //"${DateTime.parse(coupon.endDate.toString())}",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                fontRailwayRegular,
                                                            color:
                                                                ColorConstants
                                                                    .pureBlack,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w200,
                                                            letterSpacing: 1),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                    top: 8,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "Reward Amount :",
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                fontRailwayRegular,
                                                            color:
                                                                ColorConstants
                                                                    .pureBlack,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w200,
                                                            letterSpacing: 1),
                                                      ),
                                                      Text(
                                                        " ${rewardWalletRedeem!.rewardAmount}",
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                fontRailwayRegular,
                                                            color:
                                                                ColorConstants
                                                                    .green,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w200,
                                                            letterSpacing: 1),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : SizedBox(height: 20)
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Row(
                          //   children: [
                          //     LinearPercentIndicator(
                          //       width: 100,
                          //       lineHeight: 5.0,
                          //       percent: (coupon.userUses / coupon.usesRestriction) * 0.1,
                          //       backgroundColor: Colors.grey.withOpacity(0.3),
                          //       progressColor: const Color(0xffFF0000),
                          //       fillColor: Theme.of(context).primaryColor,
                          //     ),
                          //     Row(
                          //       children: [
                          //         Text(
                          //           '   ${coupon.userUses} / ${coupon.usesRestriction} ${AppLocalizations.of(context).btn_uses}',
                          //           style: TextStyle(fontWeight: FontWeight.bold),
                          //         ),
                          //       ],
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          width: 120,
          height: 120,
          child: Stack(
            children: [
              Container(
                height: 120,
                width: 120,
                // child: Image.asset(
                //   'assets/images/myRewardsWalletRedeem_logo.png',
                //   width: 22,
                //   height: 22,
                //   fit: BoxFit.fill,
                //   //color: ColorConstants.goldernBrown,
                // ),
              ),
              Container(
                width: 120,
                height: 120,
                padding: EdgeInsets.all(12),
                child: CachedNetworkImage(
                  imageUrl: global.imageBaseUrl +
                      "${rewardWalletRedeem!.image}", //coupon.couponImage

                  imageBuilder: (context, imageProvider) => Container(
                    child: Container(
                      margin: EdgeInsets.only(top: 12, bottom: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover)),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                      margin: EdgeInsets.only(top: 12, bottom: 12),
                      width: 60,
                      child: Center(child: CircularProgressIndicator())),
                  errorWidget: (context, url, error) => Container(
                    margin: EdgeInsets.only(top: 12, bottom: 12),
                    width: 60,
                    child: Icon(
                      Icons.image,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
