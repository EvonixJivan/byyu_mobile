import 'package:byyu/constants/analytics_GA4.dart';
import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/models/checkoutOrderModel.dart';
import 'package:byyu/models/orderDetailsModel.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/orderModel.dart';
import 'package:byyu/screens/home_screen.dart';
import 'package:flutter/widgets.dart';

class OrderConfirmationScreen extends BaseRoute {
  final int? screenId;
  final int? status;
  String? cartID;
  OrderConfirmationScreen({a, o, this.screenId, this.status, this.cartID})
      : super(a: a, o: o, r: 'OrderConfirmationScreen');
  @override
  _OrderConfirmationScreenState createState() => _OrderConfirmationScreenState(
      screenId: screenId, status: status, cartID: cartID);
}

class _OrderConfirmationScreenState extends BaseRouteState {
  int? screenId;
  int? status;
  String? cartID;
  bool? _isDataLoaded = false;
  CheckoutOrder? checkoutOrderModel;
  List<OrderDetails>? orderDetails = [];
  _OrderConfirmationScreenState({this.screenId, this.status, this.cartID});
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async{
        Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => HomeScreen(
                                            a: widget.analytics,
                                            o: widget.observer,
                                            selectedIndex: 0,
                                          )));
        return false;
      },
      child: Scaffold(
          body: _isDataLoaded!
              ? Container(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Order Placed Successfully",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontFamily: fontMetropolisRegular,
                              fontWeight: FontWeight.bold,
                              color: ColorConstants.pureBlack,
                              fontSize: 16,
                              letterSpacing: 1),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 1, bottom: 10, right: 10),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      children: [],
                                    ),
                                  ],
                                ),
                                Divider(
                                  thickness: 0.5,
                                ),
                                //SizedBox(height: 10),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Shipping Address",
                                          style: TextStyle(
                                              fontFamily: fontMetropolisRegular,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: ColorConstants.pureBlack,
                                              letterSpacing: 1),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Delivery To: ${orderDetails![0].userName}",
                                          style: TextStyle(
                                            fontFamily: fontMetropolisRegular,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            color: ColorConstants.pureBlack,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        "Address: ${orderDetails![0].deliveryAddress}",
                                        maxLines: 5,
                                        style: TextStyle(
                                          fontFamily: fontMetropolisRegular,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: ColorConstants.pureBlack,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Divider(
                                  thickness: 0.5,
                                ),
                                SizedBox(height: 5),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Ordered Items",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontFamily: fontMetropolisRegular,
                                        fontWeight: FontWeight.bold,
                                        color: ColorConstants.pureBlack,
                                        fontSize: 16,
                                        letterSpacing: 1),
                                  ),
                                ),
                                //SizedBox(height: 10),
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  // itemCount: _productDetail
                                  //     .productDetail.varient.length,
                                  itemCount: orderDetails!.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                        margin: EdgeInsets.only(bottom: 5),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 0.5,
                                                color: ColorConstants.greyfaint),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                //MediaQuery.of(context).size.width - 10,
                                                child: CachedNetworkImage(
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                  imageUrl: global.imageBaseUrl +
                                                      orderDetails![index]
                                                          .product!
                                                          .varientImage!,
                                                  placeholder: (context, url) =>
                                                      Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                    strokeWidth: 1.0,
                                                  )),
                                                  errorWidget:
                                                      (context, url, error) =>
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
                                                      "${orderDetails![index].product!.productName}",
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              fontMetropolisRegular,
                                                          letterSpacing: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(
                                                    "Qty: ${orderDetails![index].product!.qty}",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          fontMetropolisRegular,
                                                      fontWeight: FontWeight.w200,
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(
                                                      "Price: ${orderDetails![index].product!.price!.toStringAsFixed(2)} AED",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              fontMetropolisRegular,
                                                          fontWeight:
                                                              FontWeight.w200)),
                                                  Text(
                                                      "Delivery Date: ${orderDetails![index].deliveryDate}",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              fontMetropolisRegular,
                                                          fontWeight:
                                                              FontWeight.w200))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ));
                                  },
                                ),
                                SizedBox(height: 10),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Payment Summary",
                                          style: TextStyle(
                                              fontFamily: fontMetropolisRegular,
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
                                          borderRadius:
                                              BorderRadius.circular(10)),
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
                                                          fontMetropolisRegular,
                                                      letterSpacing: 1,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: ColorConstants
                                                          .pureBlack,
                                                      fontSize: 14),
                                                ),
                                                Expanded(child: Text("")),
                                                Text(
                                                  "${checkoutOrderModel!.paymentStatuss}",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          fontMetropolisRegular,
                                                      letterSpacing: 1,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: ColorConstants
                                                          .pureBlack,
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
                                                          fontMetropolisRegular,
                                                      letterSpacing: 1,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: ColorConstants
                                                          .pureBlack,
                                                      fontSize: 14),
                                                ),
                                                Expanded(child: Text("")),
                                                Text(
                                                  checkoutOrderModel!
                                                              .totalCouponDiscount! >
                                                          0
                                                      ? "${checkoutOrderModel!.totalCouponDiscount!.toStringAsFixed(2)} "
                                                      : "${checkoutOrderModel!.totalCouponDiscount} ",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          fontMetropolisRegular,
                                                      letterSpacing: 1,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: ColorConstants.green,
                                                      fontSize: 14),
                                                )
                                              ],
                                            ),
                                            Visibility(
                                              visible: checkoutOrderModel!.cartPaidByWallet !=null && (checkoutOrderModel!.cartPaidByWallet! >0.0 || checkoutOrderModel!.cartPaidByWallet! <0.0),
      
                                              child: SizedBox(height: 5)),
                                            Visibility(
                                              visible: checkoutOrderModel!.cartPaidByWallet !=null && (checkoutOrderModel!.cartPaidByWallet! >0.0 || checkoutOrderModel!.cartPaidByWallet! <0.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Wallet Discount: ",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            fontMetropolisRegular,
                                                        letterSpacing: 1,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: ColorConstants
                                                            .pureBlack,
                                                        fontSize: 14),
                                                  ),
                                                  Expanded(child: Text("")),
                                                  Text(
                                                     "${checkoutOrderModel!.cartPaidByWallet!.toStringAsFixed(2)} ",
                                                       
                                                    style: TextStyle(
                                                        fontFamily:
                                                            fontMetropolisRegular,
                                                        letterSpacing: 1,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: ColorConstants.green,
                                                        fontSize: 14),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Row(
                                              children: [
                                                Text(
                                                  "Delivery fees: ",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          fontMetropolisRegular,
                                                      letterSpacing: 1,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: ColorConstants
                                                          .pureBlack,
                                                      fontSize: 14),
                                                ),
                                                Expanded(child: Text("")),
                                                Text(
                                                  "${checkoutOrderModel!.deliveryFeeAmt!.toStringAsFixed(2)} ",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          fontMetropolisRegular,
                                                      letterSpacing: 1,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color:
                                                          ColorConstants.appColor,
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
                                                          fontMetropolisRegular,
                                                      letterSpacing: 1,
                                                      fontWeight: FontWeight.bold,
                                                      color: ColorConstants
                                                          .pureBlack,
                                                      fontSize: 16),
                                                ),
                                                Expanded(child: Text("")),
                                                Text(
                                                  "${checkoutOrderModel!.totalOrderAmt!.toStringAsFixed(2)} AED",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          fontMetropolisRegular,
                                                      letterSpacing: 1,
                                                      fontWeight: FontWeight.bold,
                                                      color:
                                                          ColorConstants.appColor,
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
                        SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      ColorConstants.appColor),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32.0),
                                  child: Text("HOME"),
                                ),
                                onPressed: () {
                                  if (screenId != 1 ||
                                      screenId != 0 ||
                                      screenId != 2) {
                                    global.cartCount = 0;
                                  }
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => HomeScreen(
                                            a: widget.analytics,
                                            o: widget.observer,
                                            selectedIndex: 0,
                                          )));
                                  setState(() {});
                                }),
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }

  @override
  void initState() {
    super.initState();
    // if (order.orderStatus == "Cancelled") {
    //   isOrderCancelled = false;
    // }
    getCheckOutOrderDetailsApi();
  }

  getCheckOutOrderDetailsApi() async {
    try {
      print("getOrderDetailsApi CartID ${cartID}");
      await apiHelper.getCheckOutOrderDetails(cartID!).then((result) async {
        if (result != null) {
          if (result.status == "1") {
            print("Niks-----------------<<<<<<<<<<<<<<");
            checkoutOrderModel=result.data;
            print("getOrderDetailsApi ${result.data}");
            
            FirebaseAnalyticsGA4().callAnalyticsCheckOutNew(
              checkoutOrderModel!.orderDetails != null? checkoutOrderModel!.orderDetails!:[],
              0,
              checkoutOrderModel!.orderDetails![0].couponId !=null? checkoutOrderModel!.orderDetails![0].couponId!:"",
              checkoutOrderModel!.totalCouponDiscount !=null?checkoutOrderModel!.totalCouponDiscount!:0,
             checkoutOrderModel!.orderDetails![0].deliveryAddress !=null? checkoutOrderModel!.orderDetails![0].deliveryAddress!:"",
              cartID!=null?cartID!:"");
            checkoutOrderModel = result.data;
            
            orderDetails!.addAll(checkoutOrderModel!.orderDetails!);

            print("getOrderDetailsApi 2 ${orderDetails![0].product}");
            _isDataLoaded = true;
            print("Niks----------------->>>>>>>>>>");
            setState(() {});
          } else {}
        }
      });
    } catch (e) {
      print("Exception -  order_controller.dart - getActiveOrderList()b:" +
          e.toString());
    }
  }
}
