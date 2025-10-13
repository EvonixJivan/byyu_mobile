//import 'dart:io';

import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/screens/order/order_details_screen.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:byyu/controllers/order_controller.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/orderModel.dart';
import 'package:byyu/screens/cart_screen/cart_screen.dart';
import 'package:byyu/screens/home_screen.dart';
import 'package:byyu/screens/order/order_summary_screen.dart';
import 'package:byyu/utils/navigation_utils.dart';

import 'package:shimmer/shimmer.dart';

class OrderHistoryScreen extends BaseRoute {
  OrderHistoryScreen({a, o}) : super(a: a, o: o, r: 'OrderHistoryScreen');

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends BaseRouteState {
  // private variable to switch tabs between orders
  int _tabIndex = 0;
  bool _isDataLoaded = false;
  OrderController orderController = Get.put(OrderController());

  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController1 = ScrollController();

  GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int activeOrderPage = 1;
  int pastOrderPage = 1;
  List<Order> activeOrderListRL = [];

  String? selectCardOrderId, selectCardSiId;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return WillPopScope(
      onWillPop: () async {
        return true;
        // return null;
      },
      child: Scaffold(
          key: _globalKey,
          
          appBar: AppBar(
            backgroundColor: ColorConstants.appBarColorWhite,
            leading: BackButton(
              onPressed: () {
                print("Go back");
                Navigator.pop(context);
              },
              color: ColorConstants.pureBlack,
            ),
            centerTitle: false,
            title: Text("Your Orders",
                style: TextStyle(
                    fontFamily: fontRailwayRegular,
                    color: ColorConstants.pureBlack,
                    fontWeight: FontWeight.w200) //textTheme.titleLarge,
                ),
          ),
          backgroundColor: ColorConstants.colorPageBackground,
          body: _isDataLoaded
              ? activeOrderList.length > 0
                  ? SafeArea(
                    top: false,
                    bottom: true,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: global.currentUser != null &&
                                global.currentUser.id != null
                            ? Container(
                                child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    itemCount: activeOrderList.length,
                                    padding: const EdgeInsets.only(top: 1.0),
                                    itemBuilder: (context, index) {
                                      
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 5),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(
                                                  NavigationUtils
                                                      .createAnimatedRoute(
                                                          1.0,
                                                          OrderDetailsScreen(
                                                            a: widget.analytics,
                                                            o: widget.observer,
                                                            orderController:
                                                                orderController,
                                                            cartID:
                                                                activeOrderList[
                                                                        index]
                                                                    .cartid,
                                                          )),
                                                )
                                                .then((value) => {
                                                      _isDataLoaded = false,
                                                      _getOrderHistory(),
                                                      setState(() {}),
                                                    });
                                          },
                                          child: Card(
                                            elevation: 1,
                                            color: ColorConstants.colorHomePageSectiondim,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
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
                                                    imageUrl:
                                                        global.imageBaseUrl +
                                                            activeOrderList[index]
                                                                .productList![0]
                                                                .varientImage!,
                                                    placeholder: (context, url) =>
                                                        Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                      strokeWidth: 1.0,
                                                    )),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        Container(
                                                            child: Image.asset(
                                                      global.noImage,
                                                      fit: BoxFit.fill,
                                                      width: 175,
                                                      height: 210,
                                                      alignment: Alignment.center,
                                                    )),
                                                  ),
                                                  // child: Image.asset(
                                                  //   'assets/images/iv_home_main.png',
                                                  //   fit: BoxFit.fill,
                                                  //   height: 100,
                                                  //   width: 100,
                                                  // ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            "Order Status:",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    fontRailwayRegular,
                                                                fontSize: 13),
                                                          ),
                                                        ),
                                                        SizedBox(width: 8),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              3,
                                                          child:  activeOrderList[
                                                                          index]
                                                                      .productList![
                                                                          0]
                                                                      .order_status_delivery!
                                                                      .toLowerCase() !=
                                                                  "pending"
                                                              ? Text(
                                                                  activeOrderList[
                                                                              index]
                                                                          .productList![
                                                                              0]
                                                                          .order_status_delivery!
                                                                          .contains(
                                                                              "_")
                                                                      ? "${activeOrderList[index].productList![0].order_status_delivery!.replaceAll("_", " ")}"
                                                                      : "${activeOrderList[index].productList![0].order_status_delivery}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      fontFamily:
                                                                          fontRailwayRegular,
                                                                      color: activeOrderList[index].productList![0].order_status_delivery!.toLowerCase() ==
                                                                                  "completed" ||
                                                                              activeOrderList[index].productList![0].order_status_delivery!.toLowerCase() ==
                                                                                  "delivered"
                                                                          ? ColorConstants
                                                                              .green
                                                                          : ColorConstants
                                                                              .appColor),
                                                                )
                                                              : Text(
                                                                  "Placed",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      fontFamily:
                                                                          fontRailwayRegular,
                                                                      color: ColorConstants
                                                                          .green),
                                                                ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 8),
                                                    // Expanded(child: Text("")),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            "Delivery Date:",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    fontRailwayRegular,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w200),
                                                          ),
                                                        ),
                                                        SizedBox(width: 8),
                                                        Container(
                                                          child: Text(
                                                            "${activeOrderList[index].deliveryDate}",
                                                            style: TextStyle(
                                                                color:
                                                                    ColorConstants
                                                                        .newTextHeadingFooter,
                                                                fontFamily:
                                                                    fontRailwayRegular,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w200),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 8),
                                                    // Expanded(child: Text("")),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            "Time:",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    fontRailwayRegular,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w200),
                                                          ),
                                                        ),
                                                        SizedBox(width: 8),
                                                        Container(
                                                          child: Text(
                                                            "${activeOrderList[index].timeSlot}",
                                                            style: TextStyle(
                                                                color:
                                                                    ColorConstants
                                                                        .newTextHeadingFooter,
                                                                fontFamily:
                                                                    fontRailwayRegular,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w200),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 8),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            "Order ID: ",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    fontRailwayRegular,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900),
                                                          ),
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                            "${activeOrderList[index].orderid}",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    fontRailwayRegular,
                                                                    color: ColorConstants.newTextHeadingFooter,
                                                                fontSize: 13)),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }))
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: Center(
                                  child: Text(
                                    global.pleaseLogin,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: global.fontMontserratLight,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w200,
                                        color: ColorConstants.grey),
                                  ),
                                ),
                              )),
                  )
                  : Center(
                      child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/login_bg.png"),
                            fit: BoxFit.cover),
                      ),
                      margin: EdgeInsets.only(left: 8, right: 8),
                      child: Center(
                        child: Column(
                          children: [
                            Expanded(child: Text("")),
                            Text(
                              'A blank canvas for gifting greatness.\n "Start your masterpiece!"',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: global.fontMontserratLight,
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
                                width: MediaQuery.of(context).size.width - 50,
                                decoration: BoxDecoration(
                                    color: ColorConstants.appColor,
                                    border: Border.all(
                                        color: ColorConstants.appColor,
                                        width: 0.5),
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
                    ))
              : Center(child: CircularProgressIndicator())),
    );
  }

  Widget _orderListCard(
      Order order, OrderController orderController, int index) {
    List<String> _productName = [];
    if (order.productList != null) {
      for (int i = 0; i < order.productList!.length; i++) {
        _productName.add(order.productList![i].productName!);
      }
      _productName = _productName.toSet().toList();
    }
    return GetBuilder<OrderController>(
      init: orderController,
      builder: (orderController) => InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderSummaryScreen(
                        a: widget.analytics,
                        o: widget.observer,
                        order: order,
                        orderController: orderController,
                      )));
        },
        child: Card(
          color: global.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.0),
          ),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('EE, dd MMMM').format(DateTime.parse(
                          (order.productList![0].orderDate).toString())),
                      style: TextStyle(
                          fontFamily: global.fontRailwayRegular,
                          fontSize: 12,
                          fontWeight: FontWeight.w200,
                          color: ColorConstants.appColor),
                    ),
                    Text(
                      "AED ${(order.priceWithoutDelivery! - order.couponDiscount!).toStringAsFixed(2)} >",
                      style: TextStyle(
                          fontFamily: global.fontRailwayRegular,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: ColorConstants.grey),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 8,
                  ),
                  child: Text(
                    "Order ID: ${order.cartid}",
                    style: TextStyle(
                        fontFamily: global.fontRailwayRegular,
                        fontSize: 14,
                        fontWeight: FontWeight.w200,
                        color: ColorConstants.grey),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible:
                          order.si_order!.toLowerCase() == "yes" ? true : false,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              global.bgCompletedColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          String? sino;
                          if (activeOrderListRL.length > 0) {
                            for (Order model in activeOrderListRL) {
                              if (order.orderid == model.orderid) {
                                sino = model.si_sub_ref_no!;
                                break;
                              }
                            }
                          } else {
                            sino = order.si_sub_ref_no!;
                          }
                          if (sino!.isEmpty) {
                            sino = order.si_sub_ref_no!;
                          }
                        },
                        child: Text(
                          "Change Card",
                          //textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: global.fontRailwayRegular,
                              fontSize: 14,
                              fontWeight: FontWeight.w200,
                              color: ColorConstants.grey),
                        ),
                      ),
                    ),
                    Expanded(child: Text('')),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(global.bgCompletedColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        _repeatOrderDialog(0, "", order);
                        // _repeatOrder();
                      },
                      child: Text(
                        "Repeat Order",
                        //textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: global.fontRailwayRegular,
                            fontSize: 14,
                            fontWeight: FontWeight.w200,
                            color: ColorConstants.grey),
                      ),
                    ),
                  ],
                ),

                // Padding(
                //   padding: const EdgeInsets.only(top: 8.0),
                //   child: _orderStatusNotifier(order, textTheme),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateUI() {
    setState(() {
      getApicall();
    });
  }

  _repeatOrderDialog(int error, String msg, Order order) async {
    try {
      showCupertinoDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(dialogBackgroundColor: Colors.white),
              child: CupertinoAlertDialog(
                title: Text(
                  global.appName,
                ),
                content: error == 0
                    ? Text(
                        global.appInfo.repeated_order_message!,
                      )
                    : Text(
                        msg,
                      ),
                actions: <Widget>[
                  if (error == 0)
                    CupertinoDialogAction(
                      child: Text('Replace Order',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: fontRailwayRegular,
                              fontWeight: FontWeight.w200,
                              color: ColorConstants.appColor)
                          // style: TextStyle(color: Colors.red),
                          ),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                        // _repeatOrder(0, order);
                      },
                    ),
                  CupertinoDialogAction(
                    child: error == 0 ? Text('Add this order',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: fontRailwayRegular,
                                fontWeight: FontWeight.w200,
                                color: Colors.blue)) : Text('OK',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: fontRailwayRegular,
                                fontWeight: FontWeight.w200,
                                color: Colors.blue)),
                    onPressed: () async {
                      Navigator.of(context).pop(false);
                      if (error == 0) {
                        // _repeatOrder(1, order);
                      }
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


  @override
  void initState() {
    //_isDataLoaded = true;
    // orderController.getActiveOrderList();
    _getOrderHistory();
    super.initState();
  }

  void _scrollListener() {
    if (_scrollController1.position.atEdge) {
      bool isTop = _scrollController1.position.pixels == 0;
      if (isTop) {
        print('At the top');
      } else {
        print('At the bottom');
        _getOrderHistory();
      }
    }
  }

  void getApicall() async {
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        _getOrderHistory();
      } else {
        showNetworkErrorSnackBar1(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - dashboard_screen.dart - _getHomeScreenData():" +
          e.toString());
    }
  }

  Widget _emptyOrderListWidget() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 25),
        color: Color(0xfffdfdfd),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              Text(
                "No orders found",
                style: TextStyle(
                    fontFamily: fontAdelia,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size.fromWidth(350.0),
                    minimumSize: Size.fromHeight(40),
                    //    primary: global.indigoColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(
                          a: widget.analytics,
                          o: widget.observer,
                          selectedIndex: 0,
                        ),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: Text(
                    "Shop something",
                    // "${AppLocalizations.of(context).lbl_let_shop} ",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Order> activeOrderList = [];
  var page1 = 1.obs;
  var isMoreDataLoaded1 = false.obs;
  var isRecordPending1 = true.obs;
  _getOrderHistory() async {
    print("Nikhil get order");
    try {
      activeOrderList.clear();
      await apiHelper.getActiveOrders(page1.value).then((result) async {
        if (result != null) {
          if (result.status == "1") {
            List<Order> _tList = result.data;
            if (_tList.isEmpty) {
              isRecordPending1(false);
            }
            print("Nikhil Active order list2---->${_tList.length}");

            activeOrderList.addAll(_tList);
            print("Nikhil Active order list21---->${activeOrderList.length}");
            _isDataLoaded = true;
            isMoreDataLoaded1(false);
          } else {
            _isDataLoaded = false;
            activeOrderList = activeOrderList;
            Fluttertoast.showToast(
              msg: result.message, // message
              toastLength: Toast.LENGTH_SHORT, // length
              gravity: ToastGravity.CENTER, // location
              // duration
            );
          }
        }
      });
    } catch (e) {
      print("Exception -  order_controller.dart - getActiveOrderList()xyz:" +
          e.toString());
    }

    setState(() {
      _isDataLoaded = true;
    });
  }

  _onRefresh() async {
    try {
      _isDataLoaded = false;
      setState(() {});
      // _getOrderHistory();
      getApicall();
    } catch (e) {
      print("Exception - order_history_screen.dart - _onRefresh():" +
          e.toString());
    }
  }

  _shimmer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 50,
                          width: 139,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          )),
                      SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                          height: 50,
                          width: 160,
                          child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)))),
                    ],
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: 3,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                          height: 230,
                          width: MediaQuery.of(context).size.width,
                          child: Card());
                    }),
              ],
            ),
          )),
    );
  }

  showNetworkErrorSnackBar1(GlobalKey<ScaffoldState> scaffoldKey) {
    try {
      // bool isConnected;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(days: 1),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.signal_wifi_off,
              color: Colors.white,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                ),
                child: Text(
                  'No internet-------------available',
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
            textColor: Colors.white,
            label: 'RETRY',
            onPressed: () {
              _onRefresh();
            }),
        backgroundColor: Colors.grey,
      ));
    } catch (e) {
      print("Exception -  base.dart - showNetworkErrorSnackBar1():" +
          e.toString());
    }
  }

  getActiveOrderListReload() async {
    try {
      await apiHelper
          .getActiveOrders(orderController.page.value)
          .then((result) async {
        if (result != null) {
          if (result.status == "1") {
            print(result.toString());
            List<Order> _tList = result.data;
            print(_tList.length);
            if (_tList.isEmpty) {
            } else {
              orderController.activeOrderList.clear();
              print(orderController.activeOrderList.length);

              orderController.activeOrderList = _tList;
              print(orderController.activeOrderList.length);

              setState(() {});
            }
          }
        }
      });
    } catch (e) {
      print("Exception -  order_controller.dart - getActiveOrderList():" +
          e.toString());
    }
  }
}
