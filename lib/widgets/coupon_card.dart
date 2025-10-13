import 'dart:math';

import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:get/get.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/couponsModel.dart';
  
import 'package:intl/intl.dart';

class CouponsCard extends StatefulWidget {
  final Coupon? coupon;
  final Function? onRedeem;
  bool? fromDrawer;

  CouponsCard({this.coupon, this.onRedeem, this.fromDrawer}) : super();

  @override
  _CouponsCardState createState() => _CouponsCardState(
      coupon: coupon, onRedeem: onRedeem, fromDrawer: fromDrawer);
}

class _CouponsCardState extends State<CouponsCard> {
  Coupon? coupon;
  Function? onRedeem;

  final Color color = const Color(0xffFF0000);
  // final double height = Get.height;
  // final double width = Get.width;
  //  bool _showTC = false;
  //  bool fromDrawer;

  bool _showTC = false;
  bool? fromDrawer;

  _CouponsCardState({this.coupon, this.onRedeem, this.fromDrawer});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(
          left: 8,
          right: 8,
        ),
        child: InkWell(
          onTap: () {
            if (!fromDrawer!) {
              onRedeem!();
            }
          },
          child: Container(
            // color: Colors.amber,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width / 3,
            //   color: Colors.red,

            decoration: BoxDecoration(
              // color: Colors.amber,
              image: DecorationImage(
                image: AssetImage("assets/images/bg_iv_coupon_new.png"),
                fit: BoxFit.contain,
              ),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width / 1.5,
              child: Row(
                children: [
                  Expanded(child: Text("")),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          coupon!.couponName!,
                          maxLines: 1,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: ColorConstants.newTextHeadingFooter,
                              fontFamily: global.fontRailwayRegular,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 30,
                          child: Text(
                            "${coupon!.couponDescription!}",
                            maxLines: 2,
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: ColorConstants.grey,
                                fontFamily: global.fontRailwayRegular,
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                          ),
                        ),
                        Expanded(
                          child: Text(""),
                        ),
                        Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                showBottomSheet();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  "T&C*",
                                  maxLines: 2,
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: ColorConstants.appColor,
                                      fontFamily: global.fontRailwayRegular,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(""),
                        ),
                        Row(
                          children: [
                            Text(
                              "Expiry Date: ",
                              maxLines: 1,
                              style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: ColorConstants.pureBlack,
                                  fontFamily: global.fontOufitMedium,
                                  fontWeight: FontWeight.w200,
                                  fontSize: 11),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              global.monthInIntFormt.format(coupon!.endDate!),
                              maxLines: 1,
                              style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: ColorConstants.pureBlack,
                                  fontFamily: global.fontOufitMedium,
                                  fontWeight: FontWeight.w200,
                                  fontSize: 11),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Text(""),
                        ),
                        SizedBox(
                          height: 2,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
            ),

            // child: CachedNetworkImage(
            //   imageUrl: global.imageBaseUrl +
            //       "${coupon!.couponImage}", //coupon.couponImage

            //   imageBuilder: (context, imageProvider) => Container(
            //     child: Container(
            //       decoration: BoxDecoration(
            //           image: DecorationImage(
            //               image: imageProvider, fit: BoxFit.contain)),
            //     ),
            //   ),
            //   placeholder: (context, url) => Container(
            //       width: 60, child: Center(child: CircularProgressIndicator())),
            //   errorWidget: (context, url, error) => Container(
            //     width: 60,
            //     child: Icon(
            //       Icons.image,
            //       color: Colors.grey[500],
            //     ),
            //   ),
            // ),
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
  }

  showBottomSheet() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              // height: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: ColorConstants.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      topLeft: Radius.circular(25))),
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text("${coupon!.couponName}", //coupon.couponName,
                          maxLines: 1,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: ColorConstants.newTextHeadingFooter,
                              fontFamily: global.fontRailwayRegular,
                              fontWeight: FontWeight.w600,
                              fontSize: 16)),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    coupon!.couponDescription != null &&
                            coupon!.couponDescription!.length > 0
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "${coupon!.couponDescription}", //"${coupon.couponCode}",
                              maxLines: 4,

                              style: TextStyle(
                                  color: ColorConstants.appColor,
                                  fontSize: 14,
                                  fontFamily: global.fontRailwayRegular,
                                  fontWeight: FontWeight.w200),
                            ),
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Container(
                          // padding: EdgeInsets.only(
                          //     left: 15,
                          //     top: 5,
                          //     bottom: 5),

                          child: Text(
                            "Expiry date:-",
                            style: TextStyle(
                              fontFamily: fontRailwayRegular,
                              color: ColorConstants.pureBlack,
                              fontSize: 12,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Text(
                            "${global.getFormattedDate(coupon!.endDate.toString().substring(0, 16))}",

                            //"${DateTime.parse(coupon.endDate.toString())}",
                            style: TextStyle(
                              fontFamily: fontRailwayRegular,
                              color: ColorConstants.pureBlack,
                              fontSize: 12,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                      ],
                    ),
                    coupon!.term_and_conditions != null
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            // alignment: Alignment.topLeft,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Html(
                                data: "${coupon!.term_and_conditions}",
                                style: {
                                  "body": Style(
                                      fontFamily: fontRailwayRegular,
                                      fontWeight: FontWeight.w300,
                                      fontSize: FontSize.medium,
                                      color: ColorConstants.pureBlack)
                                  // Style(color: Theme.of(context).textTheme.bodyText1.color),
                                },
                              ),
                            ),
                          )
                        : Container(),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: !fromDrawer!
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    height: 25, // height * 0.044,
                                    width:
                                        MediaQuery.of(context).size.width / 2.2,
                                    margin: EdgeInsets.only(bottom: 8, top: 5),
                                    child: Center(
                                        child: Text('CLOSE',
                                            style: TextStyle(
                fontFamily: global.fontMontserratLight,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: ColorConstants.pureBlack))),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                      border: Border.all(
                                          width: 0.5,
                                          color: ColorConstants.grey),
                                    ),
                                  ),
                                ),
                                coupon!.userUses == coupon!.usesRestriction
                                    ? SizedBox()
                                    : InkWell(
                                        onTap: () => {
                                          Navigator.of(context).pop(),
                                          onRedeem!(),
                                        },
                                        child: Container(
                                          height: 25, // height * 0.044,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.2,
                                          margin: EdgeInsets.only(
                                              bottom: 8, top: 5),
                                          child: Center(
                                              child: Text('APPLY',
                                                  style: TextStyle(
                fontFamily: global.fontMontserratLight,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: ColorConstants.pureBlack))),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                            border: Border.all(
                                                width: 0.5,
                                                color: ColorConstants.appColor),
                                          ),
                                        ),
                                      ),
                              ],
                            )
                          : SizedBox(
                              height: 8,
                            ),
                    ),
                    // : SizedBox(height: 0)
                    SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
    setState(() {});
  }
}
