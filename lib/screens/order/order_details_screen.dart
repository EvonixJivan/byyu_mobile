import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/models/orderDetailsModel.dart';
import 'package:byyu/screens/home_screen.dart';
import 'package:byyu/screens/order/cancel_product_order.dart';
import 'package:byyu/screens/order/rate_order_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:byyu/controllers/order_controller.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/orderModel.dart';

import 'package:byyu/models/businessLayer/global.dart' as global;

class OrderDetailsScreen extends BaseRoute {
  final Order? order;
  final OrderController? orderController;
  String? cartID;
  OrderDetailsScreen({a, o, this.order, this.cartID, this.orderController})
      : super(a: a, o: o, r: 'OrderSummaryScreen');
  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState(
      orderController: orderController, cartID: cartID);
}

class _OrderDetailsScreenState extends BaseRouteState {
  OrderDetails? orderDetails;
  int? screenId;
  bool isOrderCancelled = true;
  OrderController? orderController;
  GlobalKey<ScaffoldState>? _scaffoldKey;
  bool _isDataLoaded = false;
  String? cartID;
  _OrderDetailsScreenState({this.orderController, this.cartID});
  final statuses = List.generate(
    4,
    (index) => SizedBox.square(
      dimension: 32,
      child: Center(child: Text('$index')),
    ),
  );
  int curIndex = -1;
  int lastIndex = -1;
  int? orderStatusActiveIndex;
  bool isCancelled = false;
  bool isReturned = false;
  List<TrackList> trackList = [];
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    print("cartId = $cartID");
    return Scaffold(
        backgroundColor: ColorConstants.colorPageBackground,
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: ColorConstants.appBarColorWhite,
          centerTitle: false,
          title: Text(
            "Tracking Details",
            style: TextStyle(
                fontFamily: fontRailwayRegular,
                color: ColorConstants.newTextHeadingFooter), //textTheme.titleLarge,
          ),
          leading: BackButton(
                //iconSize: 30,

                onPressed: () {
                  
                    print("NIkhil 5");
                    global.routingProductID = 0;
                    Navigator.pop(context);
                
                },
                // icon: Icon(
                //   MdiIcons.arrowLeftBoldOutline,
                // ),
                color: ColorConstants.appColor),
           
        ),
        body: _isDataLoaded
            ? SafeArea(
              top: false,
              bottom: true,
              child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, top: 10, bottom: 10, right: 10),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width /
                                            1.1,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Order Status:",
                                              style: TextStyle(
                                                  fontFamily:
                                                      fontRailwayRegular,
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorConstants.newTextHeadingFooter,
                                                  fontSize: 16,
                                                  ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            orderDetails!.orderStatus!
                                                        .toLowerCase() !=
                                                    "pending"
                                                ? Text(
                                                    orderDetails!.orderStatus!
                                                            .contains("_")
                                                        ? "${orderDetails!.orderStatus!.replaceAll("_", " ")}"
                                                        : orderDetails!
                                                            .orderStatus!,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            fontRailwayRegular,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: orderDetails!
                                                                        .orderStatus!
                                                                        .toLowerCase()
                                                                        .trim() ==
                                                                    "cancelled" ||
                                                                orderDetails!
                                                                        .orderStatus!
                                                                        .toLowerCase()
                                                                        .trim() ==
                                                                    "completed"
                                                            ? ColorConstants.green
                                                            : ColorConstants
                                                                .appColor,
                                                        fontSize: 16,
                                                        letterSpacing: 1),
                                                  )
                                                : Text(
                                                    "Placed",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            fontRailwayRegular,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            ColorConstants.green,
                                                        fontSize: 16,
                                                        letterSpacing: 1),
                                                  ),
                                          ],
                                        ),
                                      ),
                                      orderDetails!.orderStatus!
                                                  .toLowerCase()
                                                  .trim() !=
                                              "cancelled"
                                          ? SizedBox(height: 8)
                                          : Container(),
                                      orderDetails!.orderStatus!
                                                  .toLowerCase()
                                                  .trim() !=
                                              "cancelled"
                                          ? Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.1,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    orderDetails!.orderStatus!
                                                                    .toLowerCase()
                                                                    .trim() ==
                                                                "completed" ||
                                                            orderDetails!
                                                                    .orderStatus!
                                                                    .toLowerCase()
                                                                    .trim() ==
                                                                "refund"
                                                        ? "Delivered on:"
                                                        : "Expected by: ",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            fontRailwayRegular,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: ColorConstants
                                                            .pureBlack,
                                                        fontSize: 14,
                                                        letterSpacing: 1),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    orderDetails!
                                                                .completeDeliveryDatetime ==
                                                            null
                                                        ? "${orderDetails!.deliveryDate}"
                                                        : "${getFormattedDate(orderDetails!.completeDeliveryDatetime!)}",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            fontRailwayRegular,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            ColorConstants.newTextHeadingFooter,
                                                        fontSize: 14,
                                                        letterSpacing: 1),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      orderDetails!.orderStatus!
                                                  .toLowerCase()
                                                  .trim() ==
                                              "refund"
                                          ? SizedBox(height: 8)
                                          : Container(),
                                      orderDetails!.orderStatus!
                                                  .toLowerCase()
                                                  .trim() ==
                                              "refund"
                                          ? Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.1,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Refund on:",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            fontRailwayRegular,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: ColorConstants
                                                            .newTextHeadingFooter,
                                                        fontSize: 14,
                                                        letterSpacing: 1),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "${getFormattedDate(orderDetails!.refundDatetime!)}",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            fontRailwayRegular,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            ColorConstants.newTextHeadingFooter,
                                                        fontSize: 14,
                                                        letterSpacing: 1),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ],
                              ),
                              Divider(
                                thickness: 0.5,
                              ),
                              SizedBox(height: 5),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Shipping Address",
                                        style: TextStyle(
                                            fontFamily: fontRailwayRegular,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: ColorConstants.newTextHeadingFooter,
                                            ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Delivery To: ",
                                        style: TextStyle(
                                          fontFamily: fontRailwayRegular,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                          color: ColorConstants.pureBlack,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "${orderDetails!.userName}",
                                        style: TextStyle(
                                          fontFamily: fontRailwayRegular,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: ColorConstants.newTextHeadingFooter,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      "Address: ${orderDetails!.deliveryAddress}",
                                      maxLines: 5,
                                      style: TextStyle(
                                        fontFamily: fontRailwayRegular,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: ColorConstants.pureBlack,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                thickness: 0.5,
                              ),
                              SizedBox(height: 5),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  "Order Track",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontFamily: fontRailwayRegular,
                                      fontWeight: FontWeight.bold,
                                      color: ColorConstants.newTextHeadingFooter,
                                      fontSize: 16,
                                      letterSpacing: 1),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20, bottom: 20),
                                // height:
                                //     (MediaQuery.of(context).size.width / 4),
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemCount:
                                        trackList.length, //_couponList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      5,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      8,
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                          begin: Alignment
                                                              .bottomCenter,
                                                          end:
                                                              Alignment.topCenter,
                                                          colors: [
                                                            index <=
                                                                    orderStatusActiveIndex!
                                                                ? ColorConstants
                                                                    .colorHomePageSection
                                                                : ColorConstants
                                                                    .oDGradientDisableBottom,
                                                            index <=
                                                                    orderStatusActiveIndex!
                                                                ? ColorConstants
                                                                    .colorHomePageSectiondim
                                                                : ColorConstants
                                                                    .oDGradientDisabledTop,
                                                          ]),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                        width: 2,
                                                        color: index <=
                                                                orderStatusActiveIndex!
                                                            ? ColorConstants
                                                                .appColor
                                                            : ColorConstants
                                                                .greyfaint,
                                                      )),
                                                  child: Center(
                                                    child: Image.asset(
                                                      index <=
                                                              orderStatusActiveIndex!
                                                          ? 'assets/images/green_tick.png'
                                                          : 'assets/images/grey_tick.png',
                                                      width: 25,
                                                      height: 25,
                                                    ),
                                                  )),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: 5),
                                                  Container(
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2,
                                                    child: Text(
                                                      "${trackList[index].orderStatus}",
                                                      // textAlign: TextAlign.center,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              fontRailwayRegular,
                                                          letterSpacing: 1,
                                                          fontSize: 16,
                                                          color: index ==
                                                                  orderStatusActiveIndex
                                                              ? ColorConstants
                                                                  .green
                                                              : ColorConstants
                                                                  .pureBlack,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(
                                                    "${trackList[index].orderstatusDate}",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          fontRailwayRegular,
                                                      fontWeight: FontWeight.w200,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          index < (trackList.length - 1)
                                              ? Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      5,
                                                  height: 20,
                                                  child: Center(
                                                    child: Container(
                                                      // margin: EdgeInsets.only(
                                                      //     top: 20),
                                                      width: 5,
                                                      // height: 5,
                                                      color: index <=
                                                              orderStatusActiveIndex!
                                                          ? ColorConstants
                                                              .orderDtailBorder
                                                          : ColorConstants
                                                              .greyfaint,
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      );
                                    }),
                              ),
                              Divider(
                                thickness: 0.5,
                              ),
                              SizedBox(height: 5),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  "Ordered Item",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontFamily: fontRailwayRegular,
                                      fontWeight: FontWeight.bold,
                                      color: ColorConstants.newTextHeadingFooter,
                                      fontSize: 16,
                                      letterSpacing: 1),
                                ),
                              ),
                              SizedBox(height: 5),
                              Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 0.5,
                                          color: ColorConstants.greyfaint),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          //MediaQuery.of(context).size.width - 10,
                                          child: CachedNetworkImage(
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            imageUrl: global.imageBaseUrl +
                                                orderDetails!
                                                    .product!.varientImage!,
                                            placeholder: (context, url) => Center(
                                                child: CircularProgressIndicator(
                                              strokeWidth: 1.0,
                                            )),
                                            errorWidget: (context, url, error) =>
                                                Container(
                                                    child: Image.asset(
                                              global.noImage,
                                              fit: BoxFit.fill,
                                              width: 100,
                                              height: 100,
                                              alignment: Alignment.center,
                                            )),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              child: Text(
                                                "${orderDetails!.product!.productName}",
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontFamily:
                                                        fontRailwayRegular,
                                                    letterSpacing: 1,

                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              "Qty: ${orderDetails!.product!.qty}",
                                              style: TextStyle(
                                                fontFamily: fontRailwayRegular,
                                                fontWeight: FontWeight.w200,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                                "AED ${(orderDetails!.product!.qty! * orderDetails!.product!.price!).toStringAsFixed(2)}",
                                                style: TextStyle(
                                                    fontFamily:
                                                        fontOufitMedium,
                                                    fontWeight: FontWeight.w200))
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                              SizedBox(height: 10),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Order Details",
                                        style: TextStyle(
                                            fontFamily: fontRailwayRegular,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: ColorConstants.newTextHeadingFooter),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5,
                                            color: ColorConstants.greyfaint),
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Order date",
                                                style: TextStyle(
                                                    fontFamily:
                                                        fontRailwayRegular,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.normal,
                                                    letterSpacing: 1),
                                              ),
                                              Expanded(child: Text("")),
                                              Text(
                                                "${getFormattedDate(orderDetails!.product!.orderDate!)}",
                                                style: TextStyle(
                                                    fontFamily:
                                                        fontRailwayRegular,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.normal,
                                                    letterSpacing: 1),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Text(
                                                "Order ID",
                                                style: TextStyle(
                                                    fontFamily:
                                                        fontRailwayRegular,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.normal,
                                                    letterSpacing: 1),
                                              ),
                                              Expanded(child: Text("")),
                                              Text(
                                                "${orderDetails!.actualOrderId}",
                                                style: TextStyle(
                                                    fontFamily:
                                                        fontRailwayRegular,
                                                    fontSize: 14,
                                                    color: ColorConstants.newTextHeadingFooter,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 1),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Text(
                                                "Order total",
                                                style: TextStyle(
                                                    fontFamily:
                                                        fontRailwayRegular,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.normal,
                                                    letterSpacing: 1),
                                              ),
                                              Expanded(child: Text("")),
                                              Text(
                                                "AED ${orderDetails!.totalProductsMrp!.toStringAsFixed(2)} ",
                                                style: TextStyle(
                                                    fontFamily:
                                                        fontOufitMedium,
                                                    fontSize: 14,
                                                    color: ColorConstants.newTextHeadingFooter,
                                                    fontWeight: FontWeight.normal,
                                                    letterSpacing: 1),
                                              ),
                                            ],
                                          ),
                                          //SizedBox(height: 5),
              
                                          orderDetails!.orderStatus!
                                                          .toLowerCase() ==
                                                      "cancelled" ||
                                                  orderDetails!.orderStatus!
                                                          .toLowerCase() ==
                                                      "pending" ||
                                                  orderDetails!.orderStatus!
                                                          .toLowerCase() !=
                                                      "completed"
                                              ? Divider(
                                                  thickness: 1,
                                                )
                                              : SizedBox(),
                                          orderDetails!.orderStatus!
                                                          .toLowerCase() ==
                                                      "cancelled" ||
                                                  orderDetails!.orderStatus!
                                                          .toLowerCase() ==
                                                      "pending" ||
                                                  orderDetails!.orderStatus!
                                                          .toLowerCase() !=
                                                      "completed"
                                              ? SizedBox(height: 5)
                                              : SizedBox(),
              
                                          
                                          SizedBox(height: 5),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        "Payment Summary",
                                        style: TextStyle(
                                            fontFamily: fontRailwayRegular,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1,
                                            fontSize: 16,
                                            color: ColorConstants.pureBlack),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5,
                                            color: ColorConstants.greyfaint),
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Payment Method: ",
                                                style: TextStyle(
                                                    fontFamily:
                                                        fontRailwayRegular,
                                                    letterSpacing: 1,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        ColorConstants.pureBlack,
                                                    fontSize: 14),
                                              ),
                                              Expanded(child: Text("")),
                                              Text(
                                                "${orderDetails!.paymentMethod}",
                                                style: TextStyle(
                                                    fontFamily:
                                                        fontOufitMedium,
                                                    
                                                    fontWeight: FontWeight.bold,
                                                    
                                                    color:
                                                        ColorConstants.newTextHeadingFooter,
                                                    fontSize: 14),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Text(
                                                "Discount price: ",
                                                style: TextStyle(
                                                    fontFamily:
                                                        fontRailwayRegular,
                                                    letterSpacing: 1,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        ColorConstants.pureBlack,
                                                    fontSize: 14),
                                              ),
                                              Expanded(child: Text("")),
                                              Text(
                                                orderDetails!.discountonmrp! > 0
                                                    ? "${orderDetails!.discountonmrp!.toStringAsFixed(2)} AED"
                                                    : "${orderDetails!.discountonmrp} AED",
                                                style: TextStyle(
                                                    fontFamily:
                                                        fontOufitMedium,
                                                    letterSpacing: 1,
                                                    fontWeight: FontWeight.bold,
                                                    color: ColorConstants.green,
                                                    fontSize: 14),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Text(
                                                "Coupon Discount: ",
                                                style: TextStyle(
                                                    fontFamily:
                                                        fontRailwayRegular,
                                                    letterSpacing: 1,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        ColorConstants.pureBlack,
                                                    fontSize: 14),
                                              ),
                                              Expanded(child: Text("")),
                                              Text(
                                                orderDetails!.couponDiscount! > 0
                                                    ? "${orderDetails!.couponDiscount!.toStringAsFixed(2)} AED"
                                                    : "${orderDetails!.couponDiscount} AED",
                                                style: TextStyle(
                                                    fontFamily:
                                                        fontOufitMedium,
                                                    letterSpacing: 1,
                                                    fontWeight: FontWeight.bold,
                                                    color: ColorConstants.green,
                                                    fontSize: 14),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Visibility
                                          (
                                            visible: orderDetails!.paidByWallet!=null && (orderDetails!.paidByWallet! >0.0 || orderDetails!.paidByWallet! <0.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Wallet Discount: ",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          fontRailwayRegular,
                                                      letterSpacing: 1,
                                                      fontWeight: FontWeight.bold,
                                                      color:
                                                          ColorConstants.pureBlack,
                                                      fontSize: 14),
                                                ),
                                                Expanded(child: Text("")),
                                                Text(
                                                  orderDetails!.couponDiscount! > 0
                                                      ? "${orderDetails!.paidByWallet!.toStringAsFixed(2)} AED"
                                                      : "${orderDetails!.paidByWallet} AED",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          fontOufitMedium,
                                                      letterSpacing: 1,
                                                      fontWeight: FontWeight.bold,
                                                      color: ColorConstants.green,
                                                      fontSize: 14),
                                                )
                                              ],
                                            ),
                                          ),
                                          orderDetails!.paidByWallet!=null && (orderDetails!.paidByWallet! >0.0 || orderDetails!.paidByWallet! <0.0)?SizedBox(height: 5):SizedBox(),
                                          Row(
                                            children: [
                                              Text(
                                                "Delivery fees: ",
                                                style: TextStyle(
                                                    fontFamily:
                                                        fontRailwayRegular,
                                                    letterSpacing: 1,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        ColorConstants.pureBlack,
                                                    fontSize: 14),
                                              ),
                                              Expanded(child: Text("")),
                                              Text(
                                                orderDetails!.deliveryCharge! > 0
                                                    ? "${orderDetails!.deliveryCharge!.toStringAsFixed(2)} AED"
                                                    : "${orderDetails!.deliveryCharge!} AED",
                                                style: TextStyle(
                                                    fontFamily:
                                                        fontOufitMedium,
                                                    letterSpacing: 1,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        ColorConstants.newTextHeadingFooter,
                                                    fontSize: 14),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Text(
                                                "Total: ",
                                                style: TextStyle(
                                                    fontFamily:
                                                        fontRailwayRegular,
                                                    letterSpacing: 1,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        ColorConstants.pureBlack,
                                                    fontSize: 16),
                                              ),
                                              Expanded(child: Text("")),
                                              Text(
                                                "${orderDetails!.totalProductsMrp!.toStringAsFixed(2)} AED",
                                                style: TextStyle(
                                                    fontFamily:
                                                        fontOufitMedium,
                                                    letterSpacing: 1,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        ColorConstants.newTextHeadingFooter,
                                                    fontSize: 16),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      orderDetails!.orderStatus!.toLowerCase() == "completed"
                          ? SizedBox(height: 30)
                          : SizedBox(height: 10),
                    ],
                  ),
                ),
            )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  @override
  void initState() {
    super.initState();
    // if (order.orderStatus == "Cancelled") {
    //   isOrderCancelled = false;
    // }
    getOrderDetailsApi();
  }

  getOrderDetailsApi() async {
    // yes working
    try {
      print("AAAAAAAAAAAAAAAAAAAAAAAAAAAA");
      //yes working

      print("getOrderDetailsApi CartID ${cartID}");
      await apiHelper.getOrderDetails(cartID!).then((result) async {
        if (result != null) {
          if (result.status == "1") {
            print("getOrderDetailsApi ${result.data}");
            orderDetails = null;
            orderDetails = result.data[0];
            if (orderDetails!.orderStatus!.toLowerCase() == "cancelled") {
              orderStatusActiveIndex = 1;
              trackList.add(new TrackList("Order Placed",
                  global.getFormattedDate(orderDetails!.createdDatetime!)));
              trackList.add(new TrackList(
                  "Cancelled",
                  orderDetails!.cancelledDatetime != null
                      ? global
                          .getFormattedDate(orderDetails!.cancelledDatetime!)
                      : ""));
              isCancelled = true;

              // _stepperDataAddCancelledStatus();
            }
            if (orderDetails!.orderStatus!.toLowerCase() == "pending") {
              orderStatusActiveIndex = 0;
              trackList.add(new TrackList("Order Placed",
                  global.getFormattedDate(orderDetails!.createdDatetime!)));
              trackList.add(new TrackList(
                  "Processing",
                  orderDetails!.processingDatetime != null
                      ? global
                          .getFormattedDate(orderDetails!.processingDatetime!)
                      : ""));
              trackList.add(new TrackList(
                  "Ready for PickUp",
                  orderDetails!.readyForPickupDatetime != null
                      ? global.getFormattedDate(
                          orderDetails!.readyForPickupDatetime!)
                      : ""));
              trackList.add(new TrackList(
                  "Out For Delivery",
                  orderDetails!.outOfDeliveryDatetime != null
                      ? global.getFormattedDate(
                          orderDetails!.outOfDeliveryDatetime!)
                      : ""));
              trackList.add(new TrackList(
                  "Completed",
                  orderDetails!.completeDeliveryDatetime != null
                      ? global.getFormattedDate(
                          orderDetails!.completeDeliveryDatetime!)
                      : "Estimated date: ${orderDetails!.deliveryDate}"));
              isCancelled = false;
              // _stepperDataAddOtherStatus(1);
            }
            if (orderDetails!.orderStatus!.toLowerCase() == "processing") {
              orderStatusActiveIndex = 1;
              trackList.add(new TrackList("Order Placed",
                  global.getFormattedDate(orderDetails!.createdDatetime!)));
              trackList.add(new TrackList(
                  "Processing",
                  orderDetails!.processingDatetime != null
                      ? global
                          .getFormattedDate(orderDetails!.processingDatetime!)
                      : ""));
              trackList.add(new TrackList(
                  "Ready for PickUp",
                  orderDetails!.readyForPickupDatetime != null
                      ? global.getFormattedDate(
                          orderDetails!.readyForPickupDatetime!)
                      : ""));
              trackList.add(new TrackList(
                  "Out For Delivery",
                  orderDetails!.outOfDeliveryDatetime != null
                      ? global.getFormattedDate(
                          orderDetails!.outOfDeliveryDatetime!)
                      : ""));
              trackList.add(new TrackList(
                  "Completed",
                  orderDetails!.completeDeliveryDatetime != null
                      ? global.getFormattedDate(
                          orderDetails!.completeDeliveryDatetime!)
                      : ""));
              isCancelled = false;
              // _stepperDataAddOtherStatus(2);
            }
            if (orderDetails!.orderStatus!.toLowerCase() ==
                "ready_for_pickup") {
              orderStatusActiveIndex = 2;
              trackList.add(new TrackList("Order Placed",
                  global.getFormattedDate(orderDetails!.createdDatetime!)));
              trackList.add(new TrackList(
                  "Processing",
                  orderDetails!.processingDatetime != null
                      ? global
                          .getFormattedDate(orderDetails!.processingDatetime!)
                      : ""));
              trackList.add(new TrackList(
                  "Ready for PickUp",
                  orderDetails!.readyForPickupDatetime != null
                      ? global.getFormattedDate(
                          orderDetails!.readyForPickupDatetime!)
                      : ""));
              trackList.add(new TrackList(
                  "Out For Delivery",
                  orderDetails!.outOfDeliveryDatetime != null
                      ? global.getFormattedDate(
                          orderDetails!.outOfDeliveryDatetime!)
                      : ""));
              trackList.add(new TrackList(
                  "Completed",
                  orderDetails!.completeDeliveryDatetime != null
                      ? global.getFormattedDate(
                          orderDetails!.completeDeliveryDatetime!)
                      : ""));
              isCancelled = false;
              // _stepperDataAddOtherStatus(3);
            }
            if (orderDetails!.orderStatus!.toLowerCase() ==
                "out_for_delivery") {
              orderStatusActiveIndex = 3;
              trackList.add(new TrackList("Order Placed",
                  global.getFormattedDate(orderDetails!.createdDatetime!)));
              trackList.add(new TrackList(
                  "Processing",
                  orderDetails!.processingDatetime != null
                      ? global
                          .getFormattedDate(orderDetails!.processingDatetime!)
                      : ""));
              trackList.add(new TrackList(
                  "Ready for PickUp",
                  orderDetails!.readyForPickupDatetime != null
                      ? global.getFormattedDate(
                          orderDetails!.readyForPickupDatetime!)
                      : ""));
              trackList.add(new TrackList(
                  "Out For Delivery",
                  orderDetails!.outOfDeliveryDatetime != null
                      ? global.getFormattedDate(
                          orderDetails!.outOfDeliveryDatetime!)
                      : ""));
              trackList.add(new TrackList(
                  "Completed",
                  orderDetails!.completeDeliveryDatetime != null
                      ? global.getFormattedDate(
                          orderDetails!.completeDeliveryDatetime!)
                      : ""));
              isCancelled = false;
              // _stepperDataAddOtherStatus(4);
            }
            if (orderDetails!.orderStatus!.toLowerCase() == "completed") {
              orderStatusActiveIndex = 4;
              trackList.add(new TrackList("Order Placed",
                  global.getFormattedDate(orderDetails!.createdDatetime!)));
              trackList.add(new TrackList(
                  "Processing",
                  orderDetails!.processingDatetime != null
                      ? global
                          .getFormattedDate(orderDetails!.processingDatetime!)
                      : ""));
              trackList.add(new TrackList(
                  "Ready for PickUp",
                  orderDetails!.readyForPickupDatetime != null
                      ? global.getFormattedDate(
                          orderDetails!.readyForPickupDatetime!)
                      : ""));
              trackList.add(new TrackList(
                  "Out For Delivery",
                  orderDetails!.outOfDeliveryDatetime != null
                      ? global.getFormattedDate(
                          orderDetails!.outOfDeliveryDatetime!)
                      : ""));
              trackList.add(new TrackList(
                  "Completed",
                  orderDetails!.completeDeliveryDatetime != null
                      ? global.getFormattedDate(
                          orderDetails!.completeDeliveryDatetime!)
                      : ""));
              isCancelled = false;
              // _stepperDataAddOtherStatus(5);
            }
            if (orderDetails!.orderStatus!.toLowerCase() == "refund") {
              orderStatusActiveIndex = 5;
              trackList.add(new TrackList("Order Placed",
                  global.getFormattedDate(orderDetails!.createdDatetime!)));
              trackList.add(new TrackList(
                  "Processing",
                  orderDetails!.processingDatetime != null
                      ? global
                          .getFormattedDate(orderDetails!.processingDatetime!)
                      : ""));
              trackList.add(new TrackList(
                  "Ready for PickUp",
                  orderDetails!.readyForPickupDatetime != null
                      ? global.getFormattedDate(
                          orderDetails!.readyForPickupDatetime!)
                      : ""));
              trackList.add(new TrackList(
                  "Out For Delivery",
                  orderDetails!.outOfDeliveryDatetime != null
                      ? global.getFormattedDate(
                          orderDetails!.outOfDeliveryDatetime!)
                      : ""));
              trackList.add(new TrackList(
                  "Completed",
                  orderDetails!.completeDeliveryDatetime != null
                      ? global.getFormattedDate(
                          orderDetails!.completeDeliveryDatetime!)
                      : ""));
              trackList.add(new TrackList(
                  "Returned",
                  orderDetails!.refundDatetime != null
                      ? global.getFormattedDate(orderDetails!.refundDatetime!)
                      : ""));
              isCancelled = false;
              isReturned = true;
              // _stepperDataAddRefundStatus(6);
            }
            print("getOrderDetailsApi 2 ${orderDetails!.product}");
            _isDataLoaded = true;
            setState(() {});
          } else {}
        }
      });
    } catch (e) {
      print("Exception -  order_controller.dart - getActiveOrderList()c:" +
          e.toString());
    }
  }
}
