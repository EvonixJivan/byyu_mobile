import 'package:byyu/models/cartModel.dart';
import 'package:byyu/screens/notification_screen.dart';
import 'package:byyu/screens/product/product_description_screen.dart';
import 'package:byyu/screens/search_screen.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/controllers/cart_controller.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/models/categoryProductModel.dart';
import 'package:byyu/models/homeScreenDataModel.dart';
import 'package:byyu/models/productDetailModel.dart';
import 'package:byyu/models/productFilterModel.dart';
import 'package:byyu/models/timeSlotModel.dart';
import 'package:byyu/screens/auth/login_screen.dart';
import 'package:byyu/screens/product/all_categories_screen.dart';
import 'package:byyu/screens/order/checkout_screen.dart';
import 'package:byyu/screens/home_screen.dart';
import 'package:byyu/widgets/cart_menu_old.dart';

import '../../widgets/bottom_button.dart';

class CartScreen extends BaseRoute {
  @required
  int? isSubscription;
  bool? fromHomeScreen;
  final Function? onAppDrawerButtonPressed;
  dynamic a, o;
  final Function? callbackHomescreenSetState;
  CartScreen(
      {this.a,
      this.o,
      this.fromHomeScreen,
      this.onAppDrawerButtonPressed,
      this.callbackHomescreenSetState})
      : super(a: a, o: o, r: 'CartScreen');

  @override
  _CartScreenState createState() => _CartScreenState(
      a: a,
      o: o,
      fromHomeScreen: fromHomeScreen,
      callbackHomescreenSetState: callbackHomescreenSetState);
}

class _CartScreenState extends BaseRouteState {
  Function? onButtonPressed;
  CartController cartController = Get.put(CartController());
  bool _isDataLoaded = false;
  bool? fromHomeScreen = false;
  bool sun = false,
      mon = false,
      tues = false,
      wed = false,
      thu = false,
      fri = false,
      sat = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Set<String> repeatOrders = Set(); // days in String

  String deliveryCount = '0', deliveryType = '';
  int selectedDeliveryCount = 0;

  bool isDeliverySelected = false;

  String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  bool isDateSelected = false;
  DateTime? selectedDate;
  List<Product> flowerproductListAll = [];
  HomeScreenData? _homeScreenData;
  bool _isLoading = false;
  int? _bannerIndex;
  List<String> bannerimageURL = [];
  ProductDetail _productDetail = new ProductDetail();
  int? productId;
  List<String> _productImages = [];
  List<Product> _productsList = [];
  List<Product> _cartProductList = [];
  List<Map<String, dynamic>>? _productsListLocal;
  bool _isMoreDataLoaded = false;
  bool _isRecordPending = true;
  int? categoryId;
  int page = 1;
  ProductFilter _productFilter = new ProductFilter();
  bool cartItemsPresent = false;
  bool isValidDateTime = true;
  final Function? callbackHomescreenSetState;

  String deliveryTime = DateFormat('hh:mm a').format(DateTime.now());
  bool isTimeSelected = false;

  String status = '1';

  int? _selectedIndex;

  bool isCartSelected = false;

  /// Time Selection
  TimeOfDay selectedTime = TimeOfDay(
    hour: 00,
    minute: 00,
  );
  String _hour = "", _minute = "", _time = "";

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      routeSettings: RouteSettings(arguments: 24),
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        if (_hour.length <= 1) _hour = '0' + _hour;
        if (_minute.length <= 1) _minute = '0' + _minute;

        _time = _hour + ':' + _minute;
        _time =
            DateFormat('hh:mm a').format(DateTime.parse(date + ' ' + _time));
        print("Time " + selectedTime.period.toString());
        print("24 hour format" +
            selectedTime.replacing(hour: selectedTime.hourOfPeriod).toString());
        deliveryTime = _time;
        isTimeSelected = true;
      });
  }

  String selectedTimeSlot = 'Please select time slot';
  int _tabIndex = 0;
  var repeatDay = '';
  bool cartItemPresent = false;
  dynamic a, o;
  ScrollController _scrollController = ScrollController();
  _CartScreenState(
      {this.a,
      this.o,
      this.onButtonPressed,
      this.fromHomeScreen,
      this.callbackHomescreenSetState});
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      // drawerEnableOpenDragGesture: true,
      // drawer: SideDrawer(
      //   analytics: widget.analytics,
      //   observer: widget.observer,
      // ),
      key: _scaffoldKey,
      appBar: AppBar(
        // leading: InkWell(
        //         onTap: () => {
                  
        //           _scaffoldKey.currentState?.openDrawer()
        //         },
        //         child: Container(
        //           margin:
        //               EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
        //           width: MediaQuery.of(context).size.width - 23,
        //           height: MediaQuery.of(context).size.height - 23,
        //           child: Icon(
        //             Icons.menu,
        //             size: 35,
        //           ),
        //         ),
        // ),
        
        automaticallyImplyLeading: false,
        
        backgroundColor: ColorConstants.appBarColorWhite,
        leadingWidth: 46,
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SearchScreen(
                        a: widget.analytics,
                        o: widget.observer,
                        fromBottomNvigation: false,
                      )));
            },
            child:Padding(
                  padding: EdgeInsets.all(18),
                  child: Image.asset(
                  "assets/images/iv_search.png",
                  fit: BoxFit.contain,
                  height: 25,
                  color: ColorConstants.newAppColor,
                  alignment: Alignment.center,
                                ),
                ),
          ),
          SizedBox(
            width: 8,
          ),
          global.currentUser != null && global.currentUser.id != null
              ? InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationScreen(
                                  a: widget.analytics,
                                  o: widget.observer,
                                )));
                  },
                  child: Icon(
                    Icons.notifications_none,
                    size: 25,
                    color: ColorConstants.allIconsBlack45,
                  ),
                )
              : SizedBox(),
          SizedBox(
            width: 8,
          )
        ],
        centerTitle: false,
        title: Text(
          "Cart",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: ColorConstants.newTextHeadingFooter,
              fontFamily: fontRailwayRegular,
              fontWeight: FontWeight.w200),
        ),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          color: ColorConstants.colorPageBackground,
          child: _isDataLoaded
              ? global.cartItemsPresent &&
                      global.cartCount > 0 &&
                      cartController != null &&
                      cartController.cartItemsList.cartData != null &&
                      cartController.cartItemsList.cartData!.cartProductdata !=
                          null
                  ? WillPopScope(
                      onWillPop: () async {
                        return false;
                      },
                      child: GetBuilder<CartController>(
                          init: cartController,
                          builder: (value) => Scaffold(
                                body: SingleChildScrollView(
                                    controller: _scrollController,
                                    physics: BouncingScrollPhysics(),
                                    child:
                                        global.cartItemsPresent &&
                                                cartController
                                                        .cartItemsList
                                                        .cartData!
                                                        .cartProductdata!
                                                        .length >
                                                    0
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 10.0,
                                                      left: 10,
                                                      right: 10,
                                                      bottom: 5,
                                                    ),
                                                    child: InkWell(
                                                      onTap: () {},
                                                      child: CartMenu(
                                                          a: a,
                                                          o: o,
                                                          cartController:
                                                              cartController,
                                                          homeScreenSetState:
                                                              callbackHomescreenSetState),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  // Explore more code
                                                  Center(
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AllCategoriesScreen(
                                                                    a: widget
                                                                        .analytics,
                                                                    o: widget
                                                                        .observer,
                                                                  )),
                                                        );
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          7.0),
                                                                ),
                                                                color: ColorConstants
                                                                    .appColor),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 16,
                                                                vertical: 4),
                                                        child: Text(
                                                          "+ Explore More",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                fontRailwayRegular,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5,
                                                            bottom: 10,
                                                            left: 10,
                                                            right: 10),
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Card(
                                                          elevation: 0,
                                                          color: ColorConstants
                                                              .white,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                          "Price Details",
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              fontFamily: fontRailwayRegular,
                                                                              fontWeight: FontWeight.w600)),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          5),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        "Subtotal ",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                13,
                                                                            fontFamily:
                                                                                fontRailwayRegular,
                                                                            fontWeight:
                                                                                FontWeight.normal),
                                                                      ),
                                                                      Spacer(),

                                                                      // Row(
                                                                      //   children: [
                                                                      //     Container(
                                                                      //       width: 40,
                                                                      //       child: Text("AED", style: TextStyle(fontSize: 13, fontFamily: fontRailwayRegular, color: ColorConstants.appColor, fontWeight: FontWeight.normal)),
                                                                      //     ),
                                                                      //     Container(
                                                                      //       width: 100,
                                                                      //       child: Text("${cartController.cartItemsList.cartData.totalMrp} (+)", textAlign: TextAlign.right, style: TextStyle(fontSize: 13, fontFamily: fontRailwayRegular, color: ColorConstants.appColor, fontWeight: FontWeight.normal)),
                                                                      //     ),
                                                                      //   ],
                                                                      // ),
                                                                      Text(
                                                                          "AED ${cartController.cartItemsList.cartData!.totalPrice! - cartController.cartItemsList.cartData!.deliveryCharge!} (+)",
                                                                          style: TextStyle(
                                                                              fontSize: 13,
                                                                              fontFamily: fontRailwayRegular,
                                                                              color: ColorConstants.appColor,
                                                                              fontWeight: FontWeight.normal))
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          5),
                                                                  (cartController.cartItemsList.cartData!.deliveryCharge != null &&
                                                                              cartController.cartItemsList.cartData!.deliveryCharge! >
                                                                                  0.0) ||
                                                                          (cartController.cartItemsList.cartData!.deliverychargediscount != null &&
                                                                              cartController.cartItemsList.cartData!.deliverychargediscount! > 0.0)
                                                                      ? Row(
                                                                          children: [
                                                                            Text("Delivery Fee",
                                                                                style: TextStyle(fontSize: 13, fontFamily: fontRailwayRegular, fontWeight: FontWeight.normal)),
                                                                            Spacer(),
                                                                            Text(cartController.cartItemsList.cartData!.deliveryCharge == 0.0 ? "AED ${cartController.cartItemsList.cartData!.deliverychargediscount} (+)" : "AED ${cartController.cartItemsList.cartData!.deliveryCharge} (+)",
                                                                                style: TextStyle(fontSize: 13, fontFamily: fontRailwayRegular, fontWeight: FontWeight.normal, color: ColorConstants.appColor))
                                                                          ],
                                                                        )
                                                                      : SizedBox(),
                                                                  SizedBox(
                                                                      height: (cartController.cartItemsList.cartData!.deliveryCharge != null && cartController.cartItemsList.cartData!.deliveryCharge! > 0.0) ||
                                                                              (cartController.cartItemsList.cartData!.deliverychargediscount != null && cartController.cartItemsList.cartData!.deliverychargediscount! > 0.0)
                                                                          ? 5
                                                                          : 0),
                                                                  // Row(
                                                                  //   children: [
                                                                  //     Text(
                                                                  //         "Discount",
                                                                  //         style: TextStyle(
                                                                  //             fontSize: 13,
                                                                  //             fontFamily: fontRailwayRegular,
                                                                  //             fontWeight: FontWeight.normal)),
                                                                  //     Expanded(
                                                                  //       child: Text(
                                                                  //           ""),
                                                                  //     ),
                                                                  //     Text(
                                                                  //         "AED" +
                                                                  //             " ${cartController.cartItemsList.cartData!.discountonmrp} (-)",
                                                                  //         style: TextStyle(
                                                                  //             fontSize: 13,
                                                                  //             fontFamily: fontRailwayRegular,
                                                                  //             color: ColorConstants.green,
                                                                  //             fontWeight: FontWeight.normal))
                                                                  //   ],
                                                                  // ),
                                                                  // SizedBox(
                                                                  //     height:
                                                                  //         5),
                                                                  cartController.cartItemsList.cartData!.deliverychargediscount == 0.0 ||
                                                                          cartController.cartItemsList.cartData!.deliverychargediscount ==
                                                                              0 ||
                                                                          (cartController.cartItemsList.cartData!.deliveryCharge != null &&
                                                                              cartController.cartItemsList.cartData!.deliveryCharge! > 0)
                                                                      ? SizedBox()
                                                                      : Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              "Delivery Fee Discount",
                                                                              style: TextStyle(fontFamily: fontRailwayRegular, fontWeight: FontWeight.w200, fontSize: 13, color: ColorConstants.pureBlack),
                                                                            ),
                                                                            Text(
                                                                              "AED ${(cartController.cartItemsList.cartData!.deliverychargediscount)} (-)",
                                                                              style: TextStyle(fontFamily: fontRailwayRegular, fontWeight: FontWeight.w200, fontSize: 13, color: ColorConstants.green),
                                                                            )
                                                                          ],
                                                                        ),
                                                                  SizedBox(
                                                                      height:
                                                                          5),
                                                                  Divider(),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                          "Total",
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              color: ColorConstants.pureBlack,
                                                                              fontFamily: fontRailwayRegular,
                                                                              fontWeight: FontWeight.bold)),
                                                                      Expanded(
                                                                        child: Text(
                                                                            ""),
                                                                      ),
                                                                      Text(
                                                                          "AED ${cartController.cartItemsList.cartData!.totalPrice}",
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              color: ColorConstants.appColor,
                                                                              fontFamily: fontRailwayRegular,
                                                                              fontWeight: FontWeight.bold))
                                                                    ],
                                                                  ),
                                                                ]),
                                                          ),
                                                        )),
                                                  ),

                                                  cartController
                                                              .cartItemsList
                                                              .simmilarProducts!
                                                              .length >
                                                          0
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 0,
                                                                  bottom: 0,
                                                                  left: 20,
                                                                  right: 10),
                                                          child: Text(
                                                              "Related Products",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      fontRailwayRegular,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        )
                                                      : Container(),
                                                  cartController
                                                              .cartItemsList
                                                              .simmilarProducts!
                                                              .length >
                                                          0
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10,
                                                                  right: 10,
                                                                  bottom: 10),
                                                          child:
                                                              _relatedProducts(
                                                                  textTheme),
                                                        )
                                                      : Container(),
                                                ],
                                              )
                                            : Center(
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height -
                                                      100,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/images/login_bg.png"),
                                                        fit: BoxFit.cover),
                                                  ),
                                                  child: Center(
                                                    child: Column(
                                                      children: [
                                                        Expanded(
                                                          child: Text(""),
                                                        ),
                                                        Text(
                                                          'Your cart is whispering, \n"Fill me up with surprises"',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontFamily: global
                                                                  .fontMontserratLight,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: ColorConstants
                                                                  .guidlinesGolden),
                                                        ),
                                                        SizedBox(
                                                          height: 8,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.of(context).push(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            HomeScreen(
                                                                              a: widget.analytics,
                                                                              o: widget.observer,
                                                                              selectedIndex: 0,
                                                                            )));
                                                          },
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                50,
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    ColorConstants
                                                                        .appColor,
                                                                border: Border.all(
                                                                    color: ColorConstants
                                                                        .appColor,
                                                                    width: 0.5),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            child: Text(
                                                              "GIFT NOW",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      fontMontserratMedium,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16,
                                                                  color:
                                                                      ColorConstants
                                                                          .white,
                                                                  letterSpacing:
                                                                      1),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(""),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )),
                              )))
                  : Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 100,
                        color: ColorConstants.colorPageBackground,
                        child: Center(
                          child: Column(
                            children: [
                              Expanded(
                                child: Text(""),
                              ),
                              Text(
                                'Your cart is whispering, \n"Fill me up with surprises"',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: global.fontMontserratLight,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: ColorConstants.appColor),
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
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  decoration: BoxDecoration(
                                      color: ColorConstants.appColor,
                                      border: Border.all(
                                          color: ColorConstants.appColor,
                                          width: 0.5),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    "GIFT NOW",
                                    textAlign: TextAlign.center,
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
                      ),
                    )
              : Container(
                color: ColorConstants.colorPageBackground,
                child: Center(
                    child: CircularProgressIndicator(),
                  ),
              )),
      bottomNavigationBar: _isDataLoaded
          ? global.cartItemsPresent &&
                  global.cartCount > 0 &&
                  cartController != null &&
                  cartController.cartItemsList.cartData != null &&
                  cartController.cartItemsList.cartData!.cartProductdata !=
                      null &&
                  cartController
                          .cartItemsList.cartData!.cartProductdata!.length >
                      0
              ? Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.fromLTRB(
                    10,
                    10,
                    10,
                    MediaQuery.of(context).viewPadding.bottom + 80, // Prevents bottom overlap
                  ),
                  child: BottomButton(
                    loadingState: false,
                    disabledState: false,
                    onPressed: () {
                      if (global.currentUser.id != null) {
                        isValidDateTime = true;
                        for (int i = 0;
                            i <
                                cartController.cartItemsList.cartData!
                                    .cartProductdata!.length;
                            i++) {
                          if (cartController.cartItemsList.cartData!
                                  .cartProductdata![i].isDeliveryValid ==
                              1) {
                            isValidDateTime = false;
                          }
                          if (cartController.cartItemsList.cartData!
                                  .cartProductdata![i].isTimeValid ==
                              1) {
                            isValidDateTime = false;
                          }
                        }
                        if (isValidDateTime) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => CheckoutScreen(
                                      a: widget.analytics,
                                      o: widget.observer,
                                      cartController: cartController,
                                      fromProfile: false,
                                    )),
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: "Delivery date is invalid", // message
                            toastLength: Toast.LENGTH_SHORT, // length
                            gravity: ToastGravity.CENTER, // location
                            // duration
                          );
                        }
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => LoginScreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                  )),
                        );
                      }
                    },
                    child: Text(
                      'SELECT DELIVERY ADDRESS',
                      style: TextStyle(
                          fontFamily: fontMontserratMedium,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: ColorConstants.white,
                          letterSpacing: 1),
                    ),
                  ),
                )
              : Container(
                  height: 1,
                )
          : Container(
              height: 1,
            ),
    );
  }

  Widget _relatedProducts(TextTheme textTheme) {
    print("G1--->${cartController.cartItemsList}");
    return Container(
      margin: EdgeInsets.only(top: 8, bottom: 10),
      child: SizedBox(
        height: 275,
        child: ListView.builder(
            itemCount: cartController.cartItemsList.simmilarProducts!.length,
            shrinkWrap: false,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  _isDataLoaded = false;
                  global.cartItemsPresent = false;
                  _selectedIndex = index;
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProductDescriptionScreen(
                            isFrom: "cart",
                            a: a,
                            o: o,
                            productId: cartController.cartItemsList
                                .simmilarProducts![index].productId,
                            isHomeSelected: "",
                          )));
                },
                child: Stack(
                  children: [
                    Container(
                        width: 195,
                        child: GetBuilder<CartController>(
                            init: cartController,
                            builder: (value) => Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: BorderSide(
                                        color: ColorConstants.greyfaint,
                                        width: 0.5,
                                      )),
                                  elevation: 0,
                                  child: Stack(
                                    children: [
                                      Column(
                                        children: [
                                          Card(
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Container(
                                              height: 170,
                                              alignment: Alignment.center,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: Stack(children: [
                                                  CachedNetworkImage(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    fit: BoxFit.contain,
                                                    imageUrl: global
                                                            .imageBaseUrl +
                                                        cartController
                                                            .cartItemsList
                                                            .simmilarProducts![
                                                                index]
                                                            .productImage! +
                                                        "?width=500&height=500",
                                                    placeholder: (context,
                                                            url) =>
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
                                                      alignment:
                                                          Alignment.center,
                                                    )),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2.0),
                                                      child: InkWell(
                                                        onTap: () {
                                                          if (global.currentUser
                                                                  .id ==
                                                              null) {
                                                            Future.delayed(
                                                                Duration.zero,
                                                                () {
                                                              Navigator.of(
                                                                      context)
                                                                  .push(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            LoginScreen(
                                                                              a: widget.analytics,
                                                                              o: widget.observer,
                                                                            )),
                                                              );
                                                            });
                                                          } else {
                                                            _addRemoveWishList(
                                                                cartController
                                                                    .cartItemsList
                                                                    .simmilarProducts![
                                                                        index]
                                                                    .varientId!);
                                                            setState(() {});
                                                          }
                                                        },
                                                        child: cartController
                                                                    .cartItemsList
                                                                    .simmilarProducts![
                                                                        index]
                                                                    .isFavourite ==
                                                                "true"
                                                            ? Icon(
                                                                MdiIcons.heart,
                                                                size: 24,
                                                                color:
                                                                    Colors.red,
                                                              )
                                                            : Icon(
                                                                MdiIcons
                                                                    .heartOutline,
                                                                size: 24,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                      ),
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: false,
                                                    child: Container(
                                                      width: 175,
                                                      height: 200,
                                                      child: Align(
                                                        alignment: Alignment
                                                            .bottomLeft,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              width: 45,
                                                              height: 22,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(2),
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.only(
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              8)),
                                                                  color: ColorConstants
                                                                      .ratingContainerColor),
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons.star,
                                                                    size: 18,
                                                                    color: Colors
                                                                        .yellow
                                                                        .shade400,
                                                                  ),
                                                                  Text(
                                                                    "${cartController.cartItemsList.simmilarProducts![index].avgrating}",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            global
                                                                                .fontRailwayRegular,
                                                                        fontSize:
                                                                            11,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w200,
                                                                        color: ColorConstants
                                                                            .white),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              height: 22,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.only(
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              8)),
                                                                  color: Colors
                                                                      .black38),
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom: 5,
                                                                      top: 5,
                                                                      left: 6,
                                                                      right: 6),
                                                              child: Text(
                                                                  "${cartController.cartItemsList.simmilarProducts![index].countrating} Reviews",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          global
                                                                              .fontRailwayRegular,
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w200,
                                                                      color: ColorConstants
                                                                          .white)),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: cartController
                                                                .cartItemsList
                                                                .simmilarProducts![
                                                                    index]
                                                                .stock! >
                                                            0
                                                        ? false
                                                        : true,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: Center(
                                                        child: Transform.rotate(
                                                          angle: 12,
                                                          child: Text(
                                                            "Currently Product\nis Unavailable",
                                                            textAlign: TextAlign
                                                                .center,
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                                fontFamily: global
                                                                    .fontMontserratLight,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w200,
                                                                fontSize: 14,
                                                                color: ColorConstants
                                                                    .appColor),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                            ),
                                          ),
                                          //paste from here
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 8),
                                                        child: Text(
                                                          "${cartController.cartItemsList.simmilarProducts![index].productName}",
                                                          maxLines: 1,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontFamily: global
                                                                  .fontRailwayRegular,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200,
                                                              fontSize: 16,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              color:
                                                                  ColorConstants
                                                                      .pureBlack),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 5),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right: 8),
                                                              child: Text(
                                                                "AED ",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        global
                                                                            .fontRailwayRegular,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w200,
                                                                    fontSize:
                                                                        13,
                                                                    color: ColorConstants
                                                                        .pureBlack),
                                                              ),
                                                            ),
                                                            Text(
                                                              int.parse(cartController
                                                                          .cartItemsList
                                                                          .simmilarProducts![
                                                                              index]
                                                                          .varients![
                                                                              0]
                                                                          .price
                                                                          .toString()) ==
                                                                      0
                                                                  ? "${cartController.cartItemsList.simmilarProducts![index].varients![0].price}"
                                                                  : int.parse(cartController
                                                                              .cartItemsList
                                                                              .simmilarProducts![index]
                                                                              .varients![0]
                                                                              .price
                                                                              .toString()
                                                                              .substring(cartController.cartItemsList.simmilarProducts![index].varients![0].price.toString().indexOf(".") + 1)) >
                                                                          0
                                                                      ? "${cartController.cartItemsList.simmilarProducts![index].varients![0].price!.toStringAsFixed(2)}"
                                                                      : "${cartController.cartItemsList.simmilarProducts![index].varients![0].price.toString().substring(0, cartController.cartItemsList.simmilarProducts![index].varients![0].price.toString().indexOf("."))}",
                                                              style: TextStyle(
                                                                  fontFamily: global
                                                                      .fontRailwayRegular,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 15,
                                                                  color: ColorConstants
                                                                      .pureBlack),
                                                            ),
                                                            cartController
                                                                        .cartItemsList
                                                                        .simmilarProducts![
                                                                            index]
                                                                        .varients![
                                                                            0]
                                                                        .price! <
                                                                    cartController
                                                                        .cartItemsList
                                                                        .simmilarProducts![
                                                                            index]
                                                                        .varients![
                                                                            0]
                                                                        .mrp!
                                                                ? Stack(
                                                                    children: [
                                                                        Container(
                                                                          margin:
                                                                              EdgeInsets.only(left: 5),
                                                                          padding: EdgeInsets.only(
                                                                              top: 2,
                                                                              bottom: 2),
                                                                          child:
                                                                              Text(
                                                                            int.parse(cartController.cartItemsList.simmilarProducts![index].varients![0].mrp.toString().substring(cartController.cartItemsList.simmilarProducts![index].varients![0].mrp.toString().indexOf(".") + 1)) > 0
                                                                                ? "${cartController.cartItemsList.simmilarProducts![index].varients![0].mrp!.toStringAsFixed(2)}"
                                                                                : "${cartController.cartItemsList.simmilarProducts![index].varients![0].mrp.toString().substring(0, cartController.cartItemsList.simmilarProducts![index].varients![0].mrp.toString().indexOf("."))}",
                                                                            style: TextStyle(
                                                                                fontFamily: global.fontRailwayRegular,
                                                                                fontWeight: FontWeight.w200,
                                                                                fontSize: 11,
                                                                                color: Colors.grey),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          margin:
                                                                              EdgeInsets.only(left: 5),
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Transform.rotate(
                                                                              angle: 0,
                                                                              child: Text(
                                                                                "----",
                                                                                textAlign: TextAlign.center,
                                                                                maxLines: 1,
                                                                                style: TextStyle(fontFamily: global.fontRailwayRegular, fontWeight: FontWeight.w200, fontSize: 11, color: Colors.grey),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ])
                                                                : Container(),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          cartController
                                                      .cartItemsList
                                                      .simmilarProducts![index]
                                                      .stock! >
                                                  0
                                              ? Container(
                                                  margin: EdgeInsets.only(
                                                      top: 10,
                                                      left: 3,
                                                      right: 3),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Text(
                                                        "Estimated Delivery:",
                                                        style: TextStyle(
                                                            fontFamily: global
                                                                .fontRailwayRegular,
                                                            fontWeight:
                                                                FontWeight.w200,
                                                            fontSize: 10,
                                                            color:
                                                                ColorConstants
                                                                    .pureBlack),
                                                      ),
                                                      Container(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.all(
                                                                      Radius.circular(
                                                                          10)),
                                                              color: Colors
                                                                  .green
                                                                  .shade100),
                                                          child:
                                                              cartController.cartItemsList.simmilarProducts![index].delivery !=
                                                                              null &&
                                                                          cartController.cartItemsList.simmilarProducts![index].delivery ==
                                                                              "1" ||
                                                                      cartController.cartItemsList.simmilarProducts![index].delivery ==
                                                                          "Today"
                                                                  ? Text(
                                                                      "Express",
                                                                      style: TextStyle(
                                                                          fontFamily: global
                                                                              .fontRailwayRegular,
                                                                          fontWeight: FontWeight
                                                                              .w200,
                                                                          fontSize:
                                                                              10,
                                                                          color:
                                                                              ColorConstants.pureBlack),
                                                                    )
                                                                  : cartController.cartItemsList.simmilarProducts![index].delivery != null && cartController.cartItemsList.simmilarProducts![index].delivery == "2" ||
                                                                          cartController.cartItemsList.simmilarProducts![index].delivery ==
                                                                              "Tomorrow"
                                                                      ? Text(
                                                                          "Today",
                                                                          style: TextStyle(
                                                                              fontFamily: global.fontRailwayRegular,
                                                                              fontWeight: FontWeight.w200,
                                                                              fontSize: 10,
                                                                              color: ColorConstants.pureBlack),
                                                                        )
                                                                      : cartController.cartItemsList.simmilarProducts![index].delivery != null &&
                                                                              cartController.cartItemsList.simmilarProducts![index].delivery == "3"
                                                                          ? Text(
                                                                              "Tomorrow",
                                                                              style: TextStyle(fontFamily: global.fontRailwayRegular, fontWeight: FontWeight.w200, fontSize: 10, color: ColorConstants.pureBlack),
                                                                            )
                                                                          : Text(
                                                                              cartController.cartItemsList.simmilarProducts![index].delivery == null || cartController.cartItemsList.simmilarProducts![index].delivery == "" ? "Tomorrow" : "${int.parse(cartController.cartItemsList.simmilarProducts![index].delivery!) - 2} days",
                                                                              style: TextStyle(fontFamily: global.fontRailwayRegular, fontWeight: FontWeight.w200, fontSize: 10, color: ColorConstants.pureBlack),
                                                                            )),
                                                    ],
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                      cartController
                                                  .cartItemsList
                                                  .simmilarProducts![index]
                                                  .stock! >
                                              0
                                          ? Container()
                                          : Container(
                                              alignment: Alignment.center,
                                              decoration: new BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.7)),
                                            ),
                                    ],
                                  ),
                                ))),
                    cartController
                                .cartItemsList.simmilarProducts![index].stock! >
                            0
                        ? Positioned(
                            left: 4,
                            top: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(1),
                              child: cartController
                                              .cartItemsList
                                              .simmilarProducts![index]
                                              .discountper !=
                                          null &&
                                      cartController
                                              .cartItemsList
                                              .simmilarProducts![index]
                                              .discountper! >
                                          0
                                  ? Container(
                                      height: 35,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8)),
                                        image: new DecorationImage(
                                          image: new AssetImage(
                                              'assets/images/discount_label_bg.png'),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "${cartController.cartItemsList.simmilarProducts![index].discountper}%\nOFF",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w200,
                                              fontSize: 10,
                                              fontFamily:
                                                  global.fontRailwayRegular,
                                              color: Colors.white),
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      height: 1,
                                      width: 1,
                                    ),
                            ),
                          )
                        : Positioned(
                            bottom: 20,
                            child: Padding(
                              padding: const EdgeInsets.all(1),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Center(
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: ColorConstants.grey,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color:
                                                ColorConstants.allBorderColor)),
                                    child: Text(
                                      "Sold Out",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 15,
                                          fontFamily:
                                              global.fontRailwayRegular,
                                          color: ColorConstants.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  _addRemoveWishList(int varientId) async {
    bool _isAddedSuccesFully = false;
    try {
      showOnlyLoaderDialog();
      await apiHelper.addRemoveWishList(varientId).then((result) async {
        if (result != null) {
          if (result.status == "1" || result.status == "2") {
            _isAddedSuccesFully = true;
            hideLoader();
            _init();
          } else {
            _isAddedSuccesFully = false;
            hideLoader();
          }
        }
      });
      return _isAddedSuccesFully;
    } catch (e) {
      hideLoader();
      print("Exception - base.dart - addRemoveWishList():" + e.toString());
      return _isAddedSuccesFully;
    }
  }

  showNetworkErrorSnackBar1(GlobalKey<ScaffoldState> scaffoldKey) {
    try {
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
                  'No internet available',
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
              ;
            }),
        backgroundColor: Colors.grey,
      ));
    } catch (e) {
      print("Exception -  base.dart - showNetworkErrorSnackBar1():" +
          e.toString());
    }
  }

  _onRefresh() async {
    try {
      _isDataLoaded = false;
      setState(() {});
      await _init();
    } catch (e) {
      print("Exception - dashboard_screen.dart - _onRefresh():" + e.toString());
    }
  }

  double setCartPrice() {
    var totalPrice = 0.0;

    return totalPrice;
  }

  @override
  void initState() {
    super.initState();
    _init();

    WidgetsBinding.instance?.addObserver(this);
  }

  _init() async {
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        isCartSelected = true;
        global.cartItemsPresent = false;
        _getCartList();
      } else {
        hideLoader();
        showNetworkErrorSnackBar(_scaffoldKey!);
      }
      setState(() {});
    } catch (e) {
      print("Exception - cartScreen.dart - _init():" + e.toString());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    global.appLifecycleState = state;
    if (global.appLifecycleState == AppLifecycleState.inactive) {}
  }

  _getCartList() async {
    try {
      print("Nikhil----get cart list---");
      cartController = CartController();
      await cartController.getCartList();
      if (cartController.isDataLoaded.value == true) {
        print("Cart Screen Outer IF condition");
        _isDataLoaded = true;
        if (global.cartItemsPresent) {
          print("Inner IF condition");
          cartItemsPresent = true;
          print(cartController
              .cartItemsList.cartData!.cartProductdata![0].deliveryType);
          global.cartItemsPresent = true;
          for (int i = 0;
              i <
                  cartController
                      .cartItemsList.cartData!.cartProductdata!.length;
              i++) {
            if (cartController.cartItemsList.cartData!.cartProductdata![i]
                    .isDeliveryValid ==
                1) {
              isValidDateTime = false;
            }
            if (cartController
                    .cartItemsList.cartData!.cartProductdata![i].isTimeValid ==
                1) {
              isValidDateTime = false;
            }
          }
        } else {
          print("Inner else condition");
          cartItemsPresent = false;
          global.cartItemsPresent = false;
        }
      } else {
        print("outer else condition");
        _isDataLoaded = true;
        cartItemsPresent = false;
        global.cartItemsPresent = false;
      }
      callbackHomescreenSetState!();
      setState(() {});
    } catch (e) {
      print(
          "Exception -  cart_screen.dart - _getCartList()8554:" + e.toString());
    }
  }
}
