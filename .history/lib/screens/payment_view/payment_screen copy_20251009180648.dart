import 'dart:async';
import 'dart:io';
import 'package:byyu/constants/analytics_GA4.dart';
import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/screens/notification_screen.dart';
import 'package:byyu/screens/payment_view/add_message_screen.dart';
import 'package:byyu/screens/payment_view/wallet_screen.dart';
import 'package:byyu/screens/search_screen.dart';
import 'package:byyu/widgets/cart_menu.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:byyu/widgets/side_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:go_sell_sdk_flutter/go_sell_sdk_flutter.dart';
import 'package:go_sell_sdk_flutter/model/models.dart';
import 'package:http/http.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';

import 'package:byyu/controllers/cart_controller.dart';

import 'package:byyu/models/apply_coupon.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/orderModel.dart';
import 'package:byyu/screens/cart_screen/cart_screen.dart';
import 'package:byyu/screens/order/coupons_screen.dart';
import 'package:byyu/screens/home_screen.dart';
import 'package:byyu/screens/order/order_confirmation_screen.dart';
import 'package:byyu/screens/web_view/web_view.dart';
import 'package:byyu/utils/navigation_utils.dart';

import '../../widgets/my_text_field.dart';
import '../auth/profile_edit_screen.dart';

class PaymentGatewayScreenCopy extends BaseRoute {
  final int? screenId;
  final double? totalAmount;
  final double? cartPrice;
  final Order? order;
  final CartController? cartController;
  final String? repeat_orders;
  final int? total_delivery_count;
  final String? selectedTime;
  final int? is_subscription;
  final int? selectedAddressID;
  String? selectedAddress;
  DateTime? selectedDate;
  final Function? callbackHomescreenSetState;
  PaymentGatewayScreenCopy(
      {a,
      o,
      this.screenId,
      this.totalAmount,
      this.order,
      this.cartController,
      this.repeat_orders,
      this.total_delivery_count,
      this.selectedTime,
      this.is_subscription,
      this.selectedAddressID,
      this.selectedAddress,
      this.selectedDate,
      this.callbackHomescreenSetState,
      this.cartPrice})
      : super(a: a, o: o, r: 'PaymentGatewayScreen');
  @override
  _PaymentGatewayScreenState createState() => new _PaymentGatewayScreenState(
        screenId!,
        totalAmount!,
        cartController!,
        total_delivery_count!,
        selectedTime!,
        is_subscription,
        selectedAddressID!,
        selectedDate!,
        cartPrice!,
        callbackHomescreenSetState,
      );
}

class _PaymentGatewayScreenState extends BaseRouteState
    with WidgetsBindingObserver {
  int screenId;
  CartController cartController;
  double totalAmount;
  double cartPrice;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int total_delivery_count;
  bool _isDataLoaded = false;

  TextEditingController _txtApplyCoupan = new TextEditingController();
  TextEditingController _txtWalletAmount = new TextEditingController();
  FocusNode _fCoupan = new FocusNode();
  FocusNode _fWalletAmount = new FocusNode();

  String? number;

  int? _isCOD;
  double radioListTileHeight = 40;

  bool isWalletSelected = false;
  bool isCouponApplied = false;
  bool isCODSelected = false;
  String selectedPaymentType = "Wallet";
  String cardWithOtherPay = "";

  bool isLoading = false;
  bool isAlertVisible = false;
  double addAmount = 0.0;
  String selectedTime;
  int? is_subscription;
  int selectedAddressID;
  DateTime selectedDate;
  double couponDiscount = 0.0;
  bool isCouponCodeVisible = false;
  bool isDiscountCodeVisible = true;
  bool isBankSelected = true;
  bool isBankVisible = false;
  double? cartItemPrice;
  String? couponCodeStr = "", bankCardName = "", si_sub_ref_no;
  int couponid = 0, bankCardID = 0;

  double totalWalletAmount = 0.00;
  double totalWalletSpendings = 0.00;
  double totalWalletbalance = 0.00;
  double totalOrderPrice = 0.00;
  double? totalDeliveryCharge;
  double totalItemPrice = 0.00;
  double totalDiscountToTapPay = 0.00;
  ScrollController scrollController = ScrollController();
  ScrollController eventScrollController = ScrollController();
  ScrollController eventMsgScrollController = ScrollController();
  String message = "";

  Map<dynamic, dynamic>? tapSDKResult;
  String responseID = "";
  String sdkStatus = "";
  String sdkErrorCode = "";
  String sdkErrorMessage = "";
  String sdkErrorDescription = "";
  bool showCouponField = true;
  bool showGiftField = false;
  var selectedOccasionString = new TextEditingController();
  int eventListSelectedIndex = 0;
  int? messageListSeletedIndex;
  bool showPaymentError = false;
  bool? showWaletSelection;
  String paymentErrorMSG = "";
  double priceDetailsLabelFontSize = 13;
  double priceDetailsLValueFontSize = 13;

//VARIABLES TO HOLD GUEST USER CONTACT FORM

  String guestEmail = "";
  String guestName = "";
  String guestContactNumber = "";
  String guestDeliveryName = "";
  String guestDeliveryContact = "";
  String guestDeliveryEmail = "";
  String guestDeliveryDate = "";
  String guestDeliveryTimeSlot = "";
  String guestAddress = "";

  //CONTACT FORM TEXTFIELDS DECORATION CODE>>>>>>>>>>>>>>>>>>>>>>
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 13,
        color: Color(0xFF9E9E9E),
        fontFamily: global.fontRalewayMedium,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      filled: true,
      fillColor: const Color(0xFFffffff),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
            color: Color.fromARGB(255, 232, 228, 228), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF8B4B2C), width: 1),
      ),
    );
  }

  String btnProceedName = "PROCEED TO PAYMENT";
  final Function? callbackHomescreenSetState;

  bool boolCouponCodeError = false;
  bool boolWalletAmountError = false;
  String strWalletAmountError = "";
  String strCouponCodeError = "";

  _PaymentGatewayScreenState(
    this.screenId,
    this.totalAmount,
    this.cartController,
    this.total_delivery_count,
    this.selectedTime,
    this.is_subscription,
    this.selectedAddressID,
    this.selectedDate,
    this.cartPrice,
    this.callbackHomescreenSetState,
  ) : super();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exitAppDialog();
        return false;
      },
      child: Scaffold(
        // drawerEnableOpenDragGesture: true,
        // drawer: SideDrawer(
        //   analytics: widget.analytics,
        //   observer: widget.observer,
        // ),
        key: _scaffoldKey,

        backgroundColor: ColorConstants.colorPageBackground,
        // body: GestureDetector(
        //   onTap: () {
        //     // Dismiss the keyboard
        //     FocusScope.of(context).unfocus();
        //   },
        // ),
        appBar: AppBar(
            backgroundColor: ColorConstants.appBarColorWhite,
            leadingWidth: 46,
            automaticallyImplyLeading: false, // use for back button remover
            centerTitle: true, // place logo in center
            leading: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
                width: MediaQuery.of(context).size.width - 23,
                height: MediaQuery.of(context).size.height - 23,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  // child: Image.asset(
                  //   "assets/images/iv_search.png",
                  //   fit: BoxFit.contain,
                  //   height: 25,
                  //   alignment: Alignment.center,
                  // ),
                ),
              ),
              // onTap: () {

              // },
            ),
            actions: [
              InkWell(
                onTap: () {
                  // randomSearchProductId = _homeScreenData!
                  //     .topselling![
                  //         Random().nextInt(_homeScreenData!.topselling!.length)]
                  //     .productId!;
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SearchScreen(
                            a: widget.analytics,
                            o: widget.observer,
                            searchProductId: 1!,
                          )));
                },
                child: Icon(
                  Icons.search,
                  size: 25,
                  color: Colors.black45,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              // global.currentUser.id != null
              global.currentUser != null && global.currentUser.id != null //AA
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
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        child: Icon(
                          Icons.notifications_none,
                          size: 25,
                          color: Colors.black45,
                        ),
                      ),
                    )
                  : SizedBox(),

              SizedBox(
                width: 8,
              )
            ],
            title: Image.asset(
              "assets/images/new_logo.png",
              fit: BoxFit.contain,
              height: 25,
              alignment: Alignment.center,
            )),
        body: _isDataLoaded && getInfoCall
            ? SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    Container(
                      color: ColorConstants.colorPageBackground,
                    ),
                    SizedBox(
                      height: 8,
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 20),

                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: InkWell(
                        onTap: () {},
                        child: CartMenu(
                          a: widget.analytics,
                          o: widget.observer,
                          cartController: cartController,
                          homeScreenSetState: callbackHomescreenSetState,
                        ),
                      ),
                    ),
                    // ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Messages",
                          style: TextStyle(
                            color: ColorConstants.newTextHeadingFooter,
                            fontFamily: global.fontRalewayMedium,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Container(
                      margin: EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      width: double.infinity,
                      height: 100, // 👈 Increased height for a bigger box
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          message.isEmpty ? "Any special requests?" : message,
                          style: TextStyle(
                            color: Colors.brown.shade600,
                            fontFamily: global.fontRalewayMedium,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 8,
                    ),

                    screenId > 1
                        ? SizedBox()
                        : Container(
                            margin: EdgeInsets.only(left: 0, right: 0, top: 8),
                            decoration: BoxDecoration(
                              color: ColorConstants.white,
                            ),
                            child: Visibility(
                              visible: false,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, top: 10, bottom: 10),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Icon(
                                        Icons.local_offer_outlined,
                                        color: ColorConstants.pureBlack,
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "Have a coupon code?",
                                          style: TextStyle(
                                              color: ColorConstants.pureBlack,
                                              fontFamily:
                                                  global.fontRailwayRegular,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w200),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (showCouponField) {
                                            showCouponField = false;
                                          } else {
                                            showCouponField = true;
                                          }

                                          setState(() {});
                                        },
                                        child: Container(
                                          width: 80,
                                          padding: EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 0.5,
                                                color: ColorConstants.appColor),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            showCouponField
                                                ? "Cancel"
                                                : "Apply",
                                            style: TextStyle(
                                                color: ColorConstants.appColor,
                                                fontFamily:
                                                    global.fontRailwayRegular,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w200),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                    Visibility(
                      visible: isCouponCodeVisible,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.only(left: 0, right: 0, top: 10),
                          decoration: BoxDecoration(
                            color: ColorConstants.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "'${couponCodeStr}'applied\n ${couponDiscount.toStringAsFixed(2)} AED Coupon Savings",
                                      style: TextStyle(
                                          color: ColorConstants.pureBlack,
                                          fontFamily: global.fontRailwayRegular,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w200),
                                    ),
                                  ],
                                ),
                                Expanded(child: Text('')),
                                InkWell(
                                  onTap: () {
                                    isCouponCodeVisible = false;
                                    showCouponField = false;
                                    couponDiscount = 0.0;
                                    couponCodeStr = "";

                                    isDiscountCodeVisible = true;
                                    var tamount = totalAmount - couponDiscount;
                                    walletAppliedRemoved();

                                    if ((addAmount - couponDiscount)
                                                .toStringAsFixed(2) ==
                                            "0.00" ||
                                        (addAmount - couponDiscount)
                                                .toStringAsFixed(2) ==
                                            "-0.00" ||
                                        (addAmount - couponDiscount)
                                                .toStringAsFixed(2) ==
                                            "0.0") {
                                      isAlertVisible = false;
                                    } else {
                                      isAlertVisible = true;
                                    }

                                    setState(() {});
                                  },
                                  child: Text("Remove",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 211, 129, 23),
                                          fontFamily: global.fontRailwayRegular,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w200)),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    showCouponField
                        ? SizedBox(
                            height: 8,
                          )
                        : SizedBox(),
                    Visibility(
                        visible: !isCouponCodeVisible,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: ColorConstants.colorPageBackground,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7.0)),
                                  border: Border.all(
                                    color: ColorConstants.appColor
                                        .withOpacity(0.5), // border color
                                    width: 0.3, // border width
                                  ),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 20, right: 10),
                                    child: Column(
                                      children: [
                                        // Apply Coupon Code Row (your existing code)
                                        Container(
                                          decoration: BoxDecoration(
                                            // color: global.white,
                                            color: ColorConstants
                                                .colorPageBackground,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7.0)),
                                          ),
                                          padding: EdgeInsets.only(left: 5),
                                          height: 40,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    // color: global.white,
                                                    color: ColorConstants.white,
                                                  ),
                                                  height: 40,
                                                  child: MyTextField(
                                                    Key('21'),
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .characters,
                                                    controller: _txtApplyCoupan,
                                                    focusNode: _fCoupan,
                                                    hintText:
                                                        'Apply coupon code',
                                                    maxLines: 1,
                                                    onChanged: (p0) {
                                                      if (p0.length > 0) {
                                                        boolCouponCodeError =
                                                            false;
                                                        setState(() {});
                                                      }
                                                    },
                                                    onFieldSubmitted: (val) {},
                                                    suffixIcon: InkWell(
                                                      onTap: () {
                                                        _txtApplyCoupan.text =
                                                            "";
                                                      },
                                                      child: Icon(
                                                        Icons.cancel,
                                                        size: 20,
                                                        color: ColorConstants
                                                            .pureBlack,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              InkWell(
                                                onTap: () async {
                                                  if (_txtApplyCoupan
                                                      .text.isNotEmpty) {
                                                    boolCouponCodeError = false;
                                                    setState(() {});
                                                    await _applyCoupon(
                                                        _txtApplyCoupan.text);
                                                  } else {
                                                    _fCoupan.requestFocus();
                                                    boolCouponCodeError = true;
                                                    strCouponCodeError =
                                                        'Please enter coupon code';
                                                    setState(() {});
                                                  }
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      4.2,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 12),
                                                  decoration: BoxDecoration(
                                                    color: ColorConstants
                                                        .appColor
                                                        .withOpacity(0.5),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    border: Border.all(
                                                      width: 0.5,
                                                      color: ColorConstants
                                                          .appColor,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "APPLY",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          fontMontserratMedium,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14,
                                                      color:
                                                          ColorConstants.white,
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        //Coupon Discount is valid only for Card Payments
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          // margin: EdgeInsets.only(left: 10),
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.zero,
                                            activeColor:
                                                ColorConstants.appColor,
                                            title: Transform.translate(
                                              offset: const Offset(-15, 0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text("Wallet",
                                                          style: TextStyle(
                                                            color:
                                                                ColorConstants
                                                                    .pureBlack,
                                                            fontSize: 15,
                                                            fontFamily:
                                                                fontRailwayRegular,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          )),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Visibility(
                                                        visible: true,
                                                        child: Container(
                                                            child: Row(
                                                          children: [
                                                            RichText(
                                                              text: TextSpan(
                                                                text:
                                                                    'Available Balance: ',
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      ColorConstants
                                                                          .grey,
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      fontRailwayRegular,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w200,
                                                                ),
                                                                children: <TextSpan>[
                                                                  TextSpan(
                                                                      text: totalWalletbalance >
                                                                              0
                                                                          ? 'AED ${totalWalletbalance.toStringAsFixed(2)}'
                                                                          : 'AED ${totalWalletAmount.toStringAsFixed(2)}',
                                                                      style:
                                                                          TextStyle(
                                                                        color: ColorConstants
                                                                            .green,
                                                                        fontSize:
                                                                            14,
                                                                        fontFamily:
                                                                            global.fontOufitMedium,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      )),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                          ],
                                                        )),
                                                      ),
                                                    ],
                                                  ),
                                                  Expanded(child: Text("")),
                                                  Image.asset(
                                                    "assets/images/wallet_red.png",
                                                    color: ColorConstants
                                                        .pureBlack,
                                                    height: 35,
                                                    width: 35,
                                                  ),
                                                  SizedBox(),
                                                ],
                                              ),
                                            ),
                                            value: isWalletSelected,
                                            onChanged: (newValue) {
                                              if (totalWalletAmount > 0.0) {
                                                if (totalOrderPrice > 0.0) {
                                                  totalWalletSpendings = 0.0;
                                                  totalOrderPrice =
                                                      double.parse(
                                                              cartController
                                                                  .cartItemsList
                                                                  .cartData!
                                                                  .totalPrice
                                                                  .toString()) -
                                                          couponDiscount;
                                                  isWalletSelected = newValue!;
                                                  if (!isWalletSelected) {
                                                    boolWalletAmountError =
                                                        false;
                                                    _txtWalletAmount.text = "";
                                                    totalWalletbalance = global
                                                        .appInfo.userwallet!;
                                                  }
                                                  setState(() {});
                                                } else {
                                                  boolWalletAmountError = true;
                                                  strWalletAmountError =
                                                      "You cannot use the wallet for an order with zero price due to the applied coupon.";
                                                  setState(() {});
                                                }
                                              }
                                            },
                                            controlAffinity: ListTileControlAffinity
                                                .leading, //  <-- leading Checkbox
                                          ),
                                        ),

                                        Visibility(
                                          visible: isWalletSelected &&
                                              totalWalletSpendings == 0.0,
                                          child: Container(
                                            height: 45,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 0,
                                                right: 0,
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: ColorConstants
                                                        .colorPageBackground,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                7.0))),
                                                padding:
                                                    EdgeInsets.only(left: 5),
                                                height: 5,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        height: 40,
                                                        child: Container(
                                                          color: Colors
                                                              .white, // White background
                                                          child: MyTextField(
                                                            Key('21'),
                                                            keyboardType:
                                                                TextInputType
                                                                    .numberWithOptions(
                                                                        decimal:
                                                                            true),
                                                            textCapitalization:
                                                                TextCapitalization
                                                                    .none,
                                                            controller:
                                                                _txtWalletAmount,
                                                            focusNode:
                                                                _fWalletAmount,
                                                            hintText:
                                                                'Use Wallet Amount',
                                                            maxLines: 1,
                                                            onFieldSubmitted:
                                                                (val) {},
                                                            suffixIcon: InkWell(
                                                              onTap: () {
                                                                _txtWalletAmount
                                                                    .text = "";
                                                              },
                                                              child: Icon(
                                                                Icons.cancel,
                                                                size: 20,
                                                                color: ColorConstants
                                                                    .pureBlack,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        if (_txtWalletAmount !=
                                                                null &&
                                                            _txtWalletAmount
                                                                .text
                                                                .isNotEmpty) {
                                                          if (double.parse(
                                                                  _txtWalletAmount
                                                                      .text) >
                                                              totalWalletAmount) {
                                                            boolWalletAmountError =
                                                                true;
                                                            strWalletAmountError =
                                                                "Amount greater than the available balance";
                                                            setState(() {});
                                                          } else if (double.parse(
                                                                  _txtWalletAmount
                                                                      .text) >
                                                              double.parse(
                                                                  (totalOrderPrice)
                                                                      .toStringAsFixed(
                                                                          2))) {
                                                            boolWalletAmountError =
                                                                true;
                                                            strWalletAmountError =
                                                                "Amount greater than the total order price";
                                                            setState(() {});
                                                          } else if (totalOrderPrice ==
                                                              0.0) {
                                                            boolWalletAmountError =
                                                                false;
                                                            totalOrderPrice = double
                                                                .parse(cartController
                                                                    .cartItemsList
                                                                    .cartData!
                                                                    .totalPrice
                                                                    .toString());
                                                            totalWalletSpendings =
                                                                double.parse(
                                                                    _txtWalletAmount
                                                                        .text);
                                                            walletAppliedRemoved();
                                                            _txtWalletAmount
                                                                .text = "";
                                                            setState(() {});
                                                          } else {
                                                            boolWalletAmountError =
                                                                false;
                                                            totalWalletSpendings =
                                                                double.parse(
                                                                    _txtWalletAmount
                                                                        .text);
                                                            walletAppliedRemoved();
                                                            _txtWalletAmount
                                                                .text = "";
                                                            setState(() {});
                                                          }
                                                        } else {
                                                          boolWalletAmountError =
                                                              true;
                                                          strWalletAmountError =
                                                              "Enter Wallet Amount to use";
                                                          setState(() {});
                                                        }
                                                      },
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            4.2,
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 8,
                                                                right: 8,
                                                                top: 12,
                                                                bottom: 12),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(5),
                                                          ),
                                                          border: Border.all(
                                                              width: 0.5,
                                                              color:
                                                                  ColorConstants
                                                                      .appColor),
                                                        ),
                                                        child: Container(
                                                          child: Text(
                                                            "USE",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    fontMontserratMedium,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 11,
                                                                color:
                                                                    ColorConstants
                                                                        .appColor,
                                                                letterSpacing:
                                                                    1),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                            visible: boolWalletAmountError,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, right: 8.0),
                                              child: Text(
                                                strWalletAmountError,
                                                style: TextStyle(
                                                    fontFamily:
                                                        fontMontserratMedium,
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 10,
                                                    color:
                                                        ColorConstants.appColor,
                                                    letterSpacing: 1),
                                              ),
                                            )),

                                        //Coupon Discount is valid only for Card Payments

                                        Visibility(
                                          visible: false,
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  140,
                                              margin:
                                                  EdgeInsets.only(bottom: 10),
                                              child: Row(
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                      text:
                                                          'Available Balance :- ',
                                                      style: TextStyle(
                                                        color:
                                                            ColorConstants.grey,
                                                        fontSize: 14,
                                                        fontFamily:
                                                            fontRailwayRegular,
                                                        fontWeight:
                                                            FontWeight.w200,
                                                      ),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text:
                                                                ' AED ${global.appInfo.userwallet!} ',
                                                            style: TextStyle(
                                                              color:
                                                                  ColorConstants
                                                                      .green,
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  fontRailwayRegular,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                        global.appInfo.userwallet! > 0.0
                                            ? SizedBox(
                                                height: 12,
                                              )
                                            : SizedBox(),

                                        SizedBox(
                                          height: 8,
                                        ),

                                        SizedBox(
                                            height:
                                                10), // spacing before price details

                                        // Price Details Section (Subtotal, Delivery Fee, Coupon Discount, Total)
                                        Container(
                                          decoration: BoxDecoration(
                                            color: ColorConstants
                                                .colorPageBackground,
                                          ),
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              // Subtotal
                                              screenId > 1
                                                  ? SizedBox()
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Subtotal",
                                                          style: TextStyle(
                                                              fontFamily: global
                                                                  .fontOufitMedium,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize:
                                                                  priceDetailsLabelFontSize,
                                                              color:
                                                                  ColorConstants
                                                                      .pureBlack),
                                                        ),
                                                        Text(
                                                          "AED ${cartItemPrice!.toStringAsFixed(2)} (+)",
                                                          style: TextStyle(
                                                              fontFamily: global
                                                                  .fontOufitMedium,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize:
                                                                  priceDetailsLValueFontSize,
                                                              color:
                                                                  ColorConstants
                                                                      .appColor),
                                                        ),
                                                      ],
                                                    ),
                                              SizedBox(height: 3),

                                              // Delivery Fee
                                              Visibility(
                                                visible: (cartController
                                                                .cartItemsList
                                                                .cartData!
                                                                .deliveryCharge !=
                                                            null &&
                                                        cartController
                                                                .cartItemsList
                                                                .cartData!
                                                                .deliveryCharge! >
                                                            0.0) ||
                                                    (cartController
                                                                .cartItemsList
                                                                .cartData!
                                                                .deliverychargediscount !=
                                                            null &&
                                                        cartController
                                                                .cartItemsList
                                                                .cartData!
                                                                .deliverychargediscount! >
                                                            0.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Delivery Fee",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              fontRalewayMedium,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize:
                                                              priceDetailsLabelFontSize,
                                                          color: ColorConstants
                                                              .pureBlack),
                                                    ),
                                                    Text(
                                                      cartController
                                                                  .cartItemsList
                                                                  .cartData!
                                                                  .deliveryCharge ==
                                                              0.0
                                                          ? "AED ${(cartController.cartItemsList.cartData!.deliverychargediscount!.toStringAsFixed(2))} (+)"
                                                          : "AED ${(cartController.cartItemsList.cartData!.deliveryCharge!.toStringAsFixed(2))} (+)",
                                                      style: TextStyle(
                                                          fontFamily: global
                                                              .fontOufitMedium,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize:
                                                              priceDetailsLValueFontSize,
                                                          color: ColorConstants
                                                              .appColor),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 3),
// WALLET AMOUNT
                                              Visibility(
                                                // visible: (cartController
                                                //                 .cartItemsList
                                                //                 .cartData!
                                                //                 .deliveryCharge !=
                                                //             null &&
                                                //         cartController
                                                //                 .cartItemsList
                                                //                 .cartData!
                                                //                 .deliveryCharge! >
                                                //             0.0) ||
                                                //     (cartController
                                                //                 .cartItemsList
                                                //                 .cartData!
                                                //                 .deliverychargediscount !=
                                                //             null &&
                                                //         cartController
                                                //                 .cartItemsList
                                                //                 .cartData!
                                                //                 .deliverychargediscount! >
                                                //             0.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  // children: [
                                                  //   Text(
                                                  //     "Wallet Amount",
                                                  //     style: TextStyle(
                                                  //         fontFamily:
                                                  //             fontRalewayMedium,
                                                  //         fontWeight:
                                                  //             FontWeight.w600,
                                                  //         fontSize:
                                                  //             priceDetailsLabelFontSize,
                                                  //         color: ColorConstants
                                                  //             .pureBlack),
                                                  //   ),
                                                  //   Text(
                                                  //     cartController
                                                  //                 .cartItemsList
                                                  //                 .cartData!
                                                  //                 .deliveryCharge ==
                                                  //             0.0
                                                  //         ? "AED ${(cartController.cartItemsList.cartData!.deliverychargediscount!.toStringAsFixed(2))} (+)"
                                                  //         : "AED ${(cartController.cartItemsList.cartData!.deliveryCharge!.toStringAsFixed(2))} (+)",
                                                  //     style: TextStyle(
                                                  //         fontFamily:
                                                  //             fontRailwayRegular,
                                                  //         fontWeight:
                                                  //             FontWeight.w200,
                                                  //         fontSize:
                                                  //             priceDetailsLValueFontSize,
                                                  //         color: ColorConstants
                                                  //             .appColor),
                                                  //   ),
                                                  // ],
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              // Coupon Discount
                                              couponDiscount == 0.0
                                                  ? SizedBox()
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              1.7,
                                                          child: Text(
                                                            couponCodeStr !=
                                                                        null &&
                                                                    couponCodeStr!
                                                                        .isNotEmpty
                                                                ? "Coupon Discount (${couponCodeStr})"
                                                                : "Coupon Discount",
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontFamily: global
                                                                    .fontOufitMedium,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize:
                                                                    priceDetailsLabelFontSize,
                                                                color: ColorConstants
                                                                    .pureBlack),
                                                          ),
                                                        ),
                                                        Text(
                                                          "AED ${couponDiscount.toStringAsFixed(2)} (-)",
                                                          style: TextStyle(
                                                              fontFamily: global
                                                                  .fontOufitMedium,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize:
                                                                  priceDetailsLValueFontSize,
                                                              color:
                                                                  ColorConstants
                                                                      .green),
                                                        ),
                                                      ],
                                                    ),
                                              // SizedBox(height: 8),

                                              // Wallet Amount
                                              isWalletSelected &&
                                                      totalWalletSpendings > 0.0
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Wallet Amount",
                                                          style: TextStyle(
                                                              fontFamily: global
                                                                  .fontOufitMedium,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize:
                                                                  priceDetailsLabelFontSize,
                                                              color:
                                                                  ColorConstants
                                                                      .pureBlack),
                                                        ),
                                                        Text(
                                                          "AED ${totalWalletSpendings.toStringAsFixed(2)} (-)",
                                                          style: TextStyle(
                                                              fontFamily: global
                                                                  .fontOufitMedium,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize:
                                                                  priceDetailsLValueFontSize,
                                                              color:
                                                                  ColorConstants
                                                                      .green),
                                                        ),
                                                      ],
                                                    )
                                                  : SizedBox(),
                                              // SizedBox(height: 8),
                                              SizedBox(height: 3),
                                              // Delivery Fee Discount
                                              cartController
                                                              .cartItemsList
                                                              .cartData!
                                                              .deliverychargediscount ==
                                                          0.0 ||
                                                      (cartController
                                                                  .cartItemsList
                                                                  .cartData!
                                                                  .deliveryCharge !=
                                                              null &&
                                                          cartController
                                                                  .cartItemsList
                                                                  .cartData!
                                                                  .deliveryCharge! >
                                                              0)
                                                  ? SizedBox()
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Delivery Fee Discount",
                                                          style: TextStyle(
                                                              fontFamily: global
                                                                  .fontOufitMedium,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize:
                                                                  priceDetailsLabelFontSize,
                                                              color:
                                                                  ColorConstants
                                                                      .pureBlack),
                                                        ),
                                                        Text(
                                                          "AED ${(cartController.cartItemsList.cartData!.deliverychargediscount!.toStringAsFixed(2))} (-)",
                                                          style: TextStyle(
                                                              fontFamily: global
                                                                  .fontOufitMedium,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize:
                                                                  priceDetailsLValueFontSize,
                                                              color:
                                                                  ColorConstants
                                                                      .green),
                                                        ),
                                                      ],
                                                    ),
                                              SizedBox(height: 20),
                                              // Divider(
                                              //   color: ColorConstants
                                              //       .appfaintColor,
                                              //   thickness: 1,
                                              // ),
                                              // SizedBox(height: 4),

                                              // Total Amount
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Total amount:",
                                                    style: TextStyle(
                                                        fontFamily: global
                                                            .fontOufitMedium,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 22,
                                                        color: ColorConstants
                                                            .pureBlack),
                                                  ),
                                                  Text(
                                                    "AED ${(totalOrderPrice).toStringAsFixed(2)}",
                                                    style: TextStyle(
                                                        fontFamily: global
                                                            .fontOufitMedium,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 22,
                                                        color: ColorConstants
                                                            .appColor),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        )),
                    SizedBox(height: 10),

                    Visibility(
                      visible: boolCouponCodeError,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 20,
                        child: Text(strCouponCodeError,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: global.fontRailwayRegular,
                                fontWeight: FontWeight.w200,
                                fontSize: 11,
                                color: ColorConstants.appColor)),
                      ),
                    ),

                    Visibility(
                        visible: !isCouponCodeVisible,
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          width: MediaQuery.of(context).size.width,
                          color: ColorConstants.colorPageBackground,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(
                                    NavigationUtils.createAnimatedRoute(
                                      1.0,
                                      CouponsScreen(
                                        a: widget.analytics,
                                        o: widget.observer,
                                        screenId: 0,
                                        fromDrawer: false,
                                        screenIdO: screenId,
                                        cartId: cartController
                                            .cartItemsList
                                            .cartData!
                                            .cartProductdata![0]
                                            .storeId
                                            .toString(),
                                        total_delivery:
                                            global.total_delivery_count,
                                        cartController: cartController,
                                      ),
                                    ),
                                  )
                                  .then((value) => {
                                        setState(() {
                                          if (value != null) {
                                            showCouponField = false;
                                            boolCouponCodeError = false;
                                            CouponCode couponCode = value;
                                            double percentCalOfCoupon = 0;
                                            couponDiscount = 0.0;

                                            couponDiscount = couponCode != null
                                                ? couponCode.save_amount!
                                                : 0.0;
                                            couponCodeStr = couponCode != null
                                                ? couponCode.coupon_code
                                                : "";
                                            couponid = couponCode != null
                                                ? couponCode.coupon_id!
                                                : 0;
                                            if (couponDiscount > 0) {
                                              isCouponCodeVisible = true;
                                              isDiscountCodeVisible = false;
                                            } else {
                                              isCouponCodeVisible = false;
                                              isDiscountCodeVisible = true;
                                            }
                                            _isCOD = 0;
                                            selectedPaymentType = "Wallet";

                                            if ((addAmount - couponDiscount)
                                                        .toStringAsFixed(2) ==
                                                    "0.00" ||
                                                (addAmount - couponDiscount)
                                                        .toStringAsFixed(2) ==
                                                    "-0.00" ||
                                                (addAmount - couponDiscount)
                                                        .toStringAsFixed(2) ==
                                                    "0.0") {
                                              isAlertVisible = false;
                                            }
                                          }
                                        }),
                                        walletAppliedRemoved(),
                                      });
                              setState(() {});
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(
                                  top: 8, bottom: 8, left: 5, right: 5),
                              // child: Text(
                              //   "View Coupons",
                              //   textAlign: TextAlign.start,
                              //   style: TextStyle(
                              //     fontFamily: fontRailwayRegular,
                              //     color: ColorConstants.appColor,
                              //     fontWeight: FontWeight.w600,
                              //     fontSize: 11,
                              //   ),
                              // ),
                            ),
                          ),
                        )),

                    Visibility(
                      visible: global.appInfo.codEnabled == 1 &&
                          isCouponCodeVisible &&
                          _isCOD == 1,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 20,
                        child: Text(
                            "Coupon Discount is valid only for Card Payments",
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: global.fontRailwayRegular,
                                fontWeight: FontWeight.w200,
                                fontSize: 11,
                                color: ColorConstants.appColor)),
                      ),
                    ),

// CONTACT US FORM CODE >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

                    // if (global.currentUser == null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20), // 👈 Added left & right padding
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🔸 Contact Section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Contact",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: global.fontRalewayMedium,
                                  ),
                                ),
                                OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.login,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    "Sign In",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: global.fontRalewayMedium,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: const Color(0xFF8B4B2C),
                                    foregroundColor: Colors.white,
                                    side: const BorderSide(
                                        color: Color(0xFFFFFFFF)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    textStyle: const TextStyle(fontSize: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const Divider(
                              color: Color(0xFFE0E0E0),
                              thickness: 1,
                            ),
                            const SizedBox(height: 10),

                            TextField(
                              decoration: _inputDecoration("Email ID"),
                              onChanged: (value) {
                                setState(() {
                                  guestEmail = value;
                                });
                              },
                            ),
                            const SizedBox(height: 10),

                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration: _inputDecoration("Your Name"),
                                    onChanged: (value) {
                                      setState(() {
                                        guestName = value;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    decoration:
                                        _inputDecoration("Phone Number"),
                                    onChanged: (value) {
                                      setState(() {
                                        guestContactNumber = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 25),

                            // 🔸 Delivery Address Section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Delivery Address",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.add, size: 16),
                                  label: const Text("Add Address"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF8B4B2C),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    textStyle: const TextStyle(fontSize: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const Divider(
                              color: Color(0xFFE0E0E0),
                              thickness: 1,
                            ),
                            const SizedBox(height: 10),

                            TextField(
                              decoration: _inputDecoration("Name"),
                              onChanged: (value) {
                                setState(() {
                                  guestDeliveryName = value;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              decoration: _inputDecoration("Mobile"),
                              onChanged: (value) {
                                setState(() {
                                  guestDeliveryContact = value;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              decoration: _inputDecoration("Email ID"),
                              onChanged: (value) {
                                setState(() {
                                  guestDeliveryEmail = value;
                                });
                              },
                            ),
                            const SizedBox(height: 10),

                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration:
                                        _inputDecoration("Delivery Date"),
                                    onChanged: (value) {
                                      setState(() {
                                        guestDeliveryDate = value;
                                      });
                                    },
                                    readOnly: true,
                                    onTap: () {},
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    decoration: _inputDecoration("Time Slot"),
                                    items: const [
                                      DropdownMenuItem(
                                          value: "10-12",
                                          child: Text("10:00 - 12:00")),
                                      DropdownMenuItem(
                                          value: "12-2",
                                          child: Text("12:00 - 2:00")),
                                      DropdownMenuItem(
                                          value: "2-4",
                                          child: Text("2:00 - 4:00")),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        guestDeliveryTimeSlot = value!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),
                            TextField(
                              decoration: _inputDecoration("Address"),
                              onChanged: (value) {
                                setState(() {
                                  guestAddress = value;
                                });
                              },
                              // maxLines: 2,
                            ),
                            const SizedBox(height: 10),

                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.location_on_outlined,
                                color: ColorConstants.newAppColor,
                                size: 18,
                              ),
                              label: const Text(
                                "Select Map",
                                style: TextStyle(
                                  color: ColorConstants.newAppColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                backgroundColor:
                                    ColorConstants.colorHomePageSectiondim,
                                foregroundColor: Colors.white,
                                side: BorderSide.none,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                minimumSize: const Size(0, 32),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),

                            const SizedBox(height: 45),

                            // 🔸 Payment Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.credit_card),
                                    label: const Text(
                                      "CARD PAYMENT",
                                      style: TextStyle(
                                        fontSize: 13, // 👈 set font size here
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF8B4B2C),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                    child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon:
                                      const Icon(Icons.local_shipping_outlined),
                                  label: const Text(
                                    "CASH ON DELIVERY",
                                    style: TextStyle(
                                      fontSize: 13, // 👈 set font size here
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF8B4B2C)
                                        .withOpacity(0.4),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                  ),
                                )),
                              ],
                            ),

                            const SizedBox(height: 60),

                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Payment",
                                  style: TextStyle(
                                    color: ColorConstants.newTextHeadingFooter,
                                    fontFamily: global.fontRalewayMedium,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),

                            const Divider(
                              color: Color(0xFFE0E0E0),
                              thickness: 1,
                            ),

                            Container(
                              height: radioListTileHeight,
                              margin:
                                  EdgeInsets.only(left: 0, right: 0, top: 1),
                              decoration: BoxDecoration(
                                color: ColorConstants.white,
                              ),
                              child: RadioListTile(
                                  activeColor: ColorConstants.appColor,
                                  value: 1, //isWalletSelected,
                                  groupValue: _isCOD,
                                  title: Text(
                                    "Card Payment",
                                    style: TextStyle(
                                        fontFamily: fontRailwayRegular,
                                        fontWeight: FontWeight.w200,
                                        fontSize: 15,
                                        color: selectedPaymentType == "Card" &&
                                                cardWithOtherPay == "Card"
                                            ? ColorConstants.appColor
                                            : ColorConstants.pureBlack),
                                  ),
                                  secondary: Image.asset(
                                    "assets/images/card_icon.png",
                                    height: 35,
                                    width: 35,
                                  ),
                                  selected: false,
                                  onChanged: (val) async {
                                    if (isWalletSelected &&
                                        totalOrderPrice == 0) {
                                      showPaymentError = true;
                                      paymentErrorMSG =
                                          "Sufficient amount in wallet to place this order";
                                      setState(() {});
                                    } else if (isCouponCodeVisible &&
                                        totalOrderPrice == 0) {
                                      showPaymentError = true;
                                      paymentErrorMSG =
                                          "Sufficient amount in coupon discount to place this order";
                                      setState(() {});
                                    } else {
                                      isCODSelected = false;
                                      print(
                                          "This is the card on pressed fun${val}");
                                      selectedPaymentType = "Card";
                                      cardWithOtherPay = "Card";
                                      _isCOD = val;
                                      setState(() {});
                                    }
                                  }),
                            ),

                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: radioListTileHeight,
                              margin:
                                  EdgeInsets.only(left: 0, right: 0, top: 1),
                              decoration: BoxDecoration(
                                color: ColorConstants.white,
                              ),
                              child: RadioListTile(
                                  activeColor: ColorConstants.appColor,
                                  value: 1, //isWalletSelected,
                                  groupValue: _isCOD,
                                  title: Text(
                                    "Card Payment",
                                    style: TextStyle(
                                        fontFamily: fontRailwayRegular,
                                        fontWeight: FontWeight.w200,
                                        fontSize: 15,
                                        color: selectedPaymentType == "Card" &&
                                                cardWithOtherPay == "Card"
                                            ? ColorConstants.appColor
                                            : ColorConstants.pureBlack),
                                  ),
                                  secondary: Image.asset(
                                    "assets/images/card_icon.png",
                                    height: 35,
                                    width: 35,
                                  ),
                                  selected: false,
                                  onChanged: (val) async {
                                    if (isWalletSelected &&
                                        totalOrderPrice == 0) {
                                      showPaymentError = true;
                                      paymentErrorMSG =
                                          "Sufficient amount in wallet to place this order";
                                      setState(() {});
                                    } else if (isCouponCodeVisible &&
                                        totalOrderPrice == 0) {
                                      showPaymentError = true;
                                      paymentErrorMSG =
                                          "Sufficient amount in coupon discount to place this order";
                                      setState(() {});
                                    } else {
                                      isCODSelected = false;
                                      print(
                                          "This is the card on pressed fun${val}");
                                      selectedPaymentType = "Card";
                                      cardWithOtherPay = "Card";
                                      _isCOD = val;
                                      setState(() {});
                                    }
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Container(
                    //   width: MediaQuery.of(context).size.width - 20,
                    //   child: Text("Select Payment Method",
                    //       maxLines: 1,
                    //       textAlign: TextAlign.start,
                    //       style: TextStyle(
                    //           fontFamily: global.fontMontserratLight,
                    //           fontWeight: FontWeight.w200,
                    //           fontSize: 15,
                    //           color: Colors.black)),
                    // ),
                    SizedBox(
                      height: 8,
                    ),
                    Visibility(
                        visible: showPaymentError,
                        child: Container(
                          width: MediaQuery.of(context).size.width - 20,
                          child: Text(
                            paymentErrorMSG,
                            style: TextStyle(
                                color: ColorConstants.appColor,
                                fontSize: 12,
                                fontFamily: global.fontRailwayRegular,
                                fontWeight: FontWeight.w200),
                          ),
                        )),
                    SizedBox(
                      height: 3,
                    ),

                    SizedBox(
                      height: 1,
                    ),

                    Visibility(
                      visible: global.appInfo.codEnabled == 1,
                      child: Container(
                        height: radioListTileHeight,
                        margin: EdgeInsets.only(left: 0, right: 0, top: 1),
                        decoration: BoxDecoration(
                          color: ColorConstants.white,
                        ),
                        child: RadioListTile(
                            activeColor: ColorConstants.appColor,
                            value: 2, //isWalletSelected,
                            groupValue: _isCOD,
                            title: Text(
                              "Cash on delivery",
                              style: TextStyle(
                                  fontFamily: fontRailwayRegular,
                                  fontWeight: FontWeight.w200,
                                  fontSize: 15,
                                  color: selectedPaymentType == "COD" &&
                                          cardWithOtherPay == "COD"
                                      ? ColorConstants.appColor
                                      : ColorConstants.pureBlack),
                            ),
                            secondary: Image.asset(
                              "assets/images/iv_cod.png",
                              height: 30,
                              width: 30,
                            ),
                            // card_icon
                            selected: false,
                            onChanged: (val) async {
                              if (isWalletSelected && totalOrderPrice == 0) {
                                showPaymentError = true;
                                paymentErrorMSG =
                                    "Sufficient amount in wallet to place this order";
                                setState(() {});
                              } else if (isCouponCodeVisible &&
                                  totalOrderPrice == 0) {
                                showPaymentError = true;
                                paymentErrorMSG =
                                    "Sufficient amount in coupon discount to place this order";
                                setState(() {});
                              } else {
                                isCODSelected = true;
                                print("This is the card on pressed fun${val}");
                                selectedPaymentType = "COD";
                                // cardWithOtherPay = "COD";
                                _isCOD = val;
                                setState(() {});
                              }
                            }),
                      ),
                    ),

                    SizedBox(
                      height: 8,
                    ),

                    // Container(
                    //   height: radioListTileHeight,
                    //   margin: EdgeInsets.only(left: 0, right: 0, top: 1),
                    //   decoration: BoxDecoration(
                    //     color: ColorConstants.white,
                    //     // border: Border.all(
                    //     //   color: ColorConstants.appfaintColor,
                    //     //   width: 1,
                    //     // ),
                    //   ),
                    //   child: RadioListTile(
                    //       activeColor: ColorConstants.appColor,
                    //       value: 3, //isWalletSelected,
                    //       groupValue: _isCOD,
                    //       title: Text(
                    //         "G Pay",
                    //         style: TextStyle(
                    //             fontFamily: fontRailwayRegular,
                    //             fontWeight: FontWeight.w200,
                    //             fontSize: 15,
                    //             color: cardWithOtherPay == "gpay"
                    //                 ? ColorConstants.appColor
                    //                 : ColorConstants.pureBlack),
                    //       ),
                    //       secondary: Image.asset(
                    //         "assets/images/g_pay_logo.png",
                    //         height: 40,
                    //         width: 40,
                    //       ),
                    //       // card_icon
                    //       selected: false,
                    //       onChanged: (val) async {
                    //         if (isWalletSelected && totalOrderPrice == 0) {
                    //           Fluttertoast.showToast(
                    //             msg:
                    //                 "Sufficient amount in wallet to place this order", // message
                    //             toastLength: Toast.LENGTH_SHORT, // length
                    //             gravity: ToastGravity.CENTER, // location
                    //             // duration
                    //           );
                    //         } else if (isCouponCodeVisible &&
                    //             totalOrderPrice == 0) {
                    //           Fluttertoast.showToast(
                    //             msg:
                    //                 "Sufficient amount in coupon discount to place this order", // message
                    //             toastLength: Toast.LENGTH_SHORT, // length
                    //             gravity: ToastGravity.CENTER, // location
                    //             // duration
                    //           );
                    //         } else {
                    //           isCODSelected = false;
                    //           print("This is the card on pressed fun${val}");
                    //           selectedPaymentType = "Card";
                    //           cardWithOtherPay = "gpay";
                    //           _isCOD = val;
                    //           setState(() {});
                    //         }
                    //       }),
                    // ),
                    // SizedBox(
                    //   height: 3,
                    // ),
                    // Platform.isIOS
                    //     ? Container(
                    //         height: radioListTileHeight,
                    //         margin: EdgeInsets.only(left: 0, right: 0, top: 1),
                    //         decoration: BoxDecoration(
                    //           color: ColorConstants.white,
                    //           // border: Border.all(
                    //           //   color: ColorConstants.appfaintColor,
                    //           //   width: 1,
                    //           // ),
                    //         ),
                    //         child: RadioListTile(
                    //             activeColor: ColorConstants.appColor,
                    //             value: 4, //isWalletSelected,
                    //             groupValue: _isCOD,
                    //             title: Text(
                    //               "Apple Pay",
                    //               style: TextStyle(
                    //                   fontFamily: fontRailwayRegular,
                    //                   fontWeight: FontWeight.w200,
                    //                   fontSize: 15,
                    //                   color: cardWithOtherPay == "apple"
                    //                       ? ColorConstants.appColor
                    //                       : ColorConstants.pureBlack),
                    //             ),
                    //             secondary: Image.asset(
                    //               "assets/images/apply_pay_logo.png",
                    //               height: 35,
                    //               width: 35,
                    //             ),
                    //             // card_icon
                    //             selected: false,
                    //             onChanged: (val) async {
                    //               if (isWalletSelected &&
                    //                   totalOrderPrice == 0) {
                    //                 Fluttertoast.showToast(
                    //                   msg:
                    //                       "Sufficient amount in wallet to place this order", // message
                    //                   toastLength: Toast.LENGTH_SHORT, // length
                    //                   gravity: ToastGravity.CENTER, // location
                    //                   // duration
                    //                 );
                    //               } else if (isCouponCodeVisible &&
                    //                   totalOrderPrice == 0) {
                    //                 Fluttertoast.showToast(
                    //                   msg:
                    //                       "Sufficient amount in coupon discount to place this order", // message
                    //                   toastLength: Toast.LENGTH_SHORT, // length
                    //                   gravity: ToastGravity.CENTER, // location
                    //                   // duration
                    //                 );
                    //               } else {
                    //                 isCODSelected = false;
                    //                 print(
                    //                     "This is the card on pressed fun${val}");
                    //                 selectedPaymentType = "Card";
                    //                 cardWithOtherPay = "apple";
                    //                 _isCOD = val;
                    //                 setState(() {});
                    //               }
                    //             }),
                    //       )
                    //     : SizedBox(),

                    // SizedBox(
                    //   height: 3,
                    // ),
                    // Container(
                    //   height: radioListTileHeight,
                    //   margin: EdgeInsets.only(left: 0, right: 0, top: 1),
                    //   decoration: BoxDecoration(
                    //     color: ColorConstants.white,
                    //     // border: Border.all(
                    //     //   color: ColorConstants.appfaintColor,
                    //     //   width: 1,
                    //     // ),
                    //   ),
                    //   child: RadioListTile(
                    //       activeColor: ColorConstants.appColor,
                    //       value: 5, //isWalletSelected,
                    //       groupValue: _isCOD,
                    //       title: Text(
                    //         "Careem Pay",
                    //         style: TextStyle(
                    //             fontFamily: fontRailwayRegular,
                    //             fontWeight: FontWeight.w200,
                    //             fontSize: 15,
                    //             color: cardWithOtherPay == "careem"
                    //                 ? ColorConstants.appColor
                    //                 : ColorConstants.pureBlack),
                    //       ),
                    //       secondary: Image.asset(
                    //         "assets/images/careem_pay_logo.png",
                    //         height: 40,
                    //         width: 40,
                    //       ),
                    //       // card_icon
                    //       selected: false,
                    //       onChanged: (val) async {
                    //         if (isWalletSelected && totalOrderPrice == 0) {
                    //           Fluttertoast.showToast(
                    //             msg:
                    //                 "Sufficient amount in wallet to place this order", // message
                    //             toastLength: Toast.LENGTH_SHORT, // length
                    //             gravity: ToastGravity.CENTER, // location
                    //             // duration
                    //           );
                    //         } else if (isCouponCodeVisible &&
                    //             totalOrderPrice == 0) {
                    //           Fluttertoast.showToast(
                    //             msg:
                    //                 "Sufficient amount in coupon discount to place this order", // message
                    //             toastLength: Toast.LENGTH_SHORT, // length
                    //             gravity: ToastGravity.CENTER, // location
                    //             // duration
                    //           );
                    //         } else {
                    //           isCODSelected = false;
                    //           print("This is the card on pressed fun${val}");
                    //           selectedPaymentType = "Card";
                    //           cardWithOtherPay = "careem";
                    //           _isCOD = val;
                    //           setState(() {});
                    //         }
                    //       }),
                    // ),
                    // SizedBox(
                    //   height: 3,
                    // ),
                    // Container(
                    //   height: radioListTileHeight,
                    //   margin: EdgeInsets.only(left: 0, right: 0, top: 1),
                    //   decoration: BoxDecoration(
                    //     color: ColorConstants.white,
                    //     // border: Border.all(
                    //     //   color: ColorConstants.appfaintColor,
                    //     //   width: 1,
                    //     // ),
                    //   ),
                    //   child: RadioListTile(
                    //       activeColor: ColorConstants.appColor,
                    //       value: 6, //isWalletSelected,
                    //       groupValue: _isCOD,
                    //       title: Text(
                    //         "Tabby",
                    //         style: TextStyle(
                    //             fontFamily: fontRailwayRegular,
                    //             fontWeight: FontWeight.w200,
                    //             fontSize: 15,
                    //             color: cardWithOtherPay == "tabby"
                    //                 ? ColorConstants.appColor
                    //                 : ColorConstants.pureBlack),
                    //       ),
                    //       secondary: Image.asset(
                    //         "assets/images/tabby_pay_logo.png",
                    //         height: 40,
                    //         width: 40,
                    //       ),
                    //       // card_icon
                    //       selected: false,
                    //       onChanged: (val) async {
                    //         if (isWalletSelected && totalOrderPrice == 0) {
                    //           Fluttertoast.showToast(
                    //             msg:
                    //                 "Sufficient amount in wallet to place this order", // message
                    //             toastLength: Toast.LENGTH_SHORT, // length
                    //             gravity: ToastGravity.CENTER, // location
                    //             // duration
                    //           );
                    //         } else if (isCouponCodeVisible &&
                    //             totalOrderPrice == 0) {
                    //           Fluttertoast.showToast(
                    //             msg:
                    //                 "Sufficient amount in coupon discount to place this order", // message
                    //             toastLength: Toast.LENGTH_SHORT, // length
                    //             gravity: ToastGravity.CENTER, // location
                    //             // duration
                    //           );
                    //         } else {
                    //           isCODSelected = false;
                    //           print("This is the card on pressed fun${val}");
                    //           selectedPaymentType = "Card";
                    //           cardWithOtherPay = "tabby";
                    //           _isCOD = val;
                    //           setState(() {});
                    //         }
                    //       }),
                    // ),
                    // SizedBox(
                    //   height: 3,
                    // ),
                    // Container(
                    //   height: radioListTileHeight,
                    //   decoration: BoxDecoration(
                    //     color: ColorConstants.white,
                    //     // border: Border.all(
                    //     //   color: ColorConstants.appfaintColor,
                    //     //   width: 1,
                    //     // ),
                    //   ),
                    //   child: RadioListTile(
                    //       activeColor: ColorConstants.appColor,
                    //       value: 7, //isWalletSelected,
                    //       groupValue: _isCOD,
                    //       title: Text(
                    //         "Benefit Pay",
                    //         style: TextStyle(
                    //             fontFamily: fontRailwayRegular,
                    //             fontWeight: FontWeight.w200,
                    //             fontSize: 15,
                    //             color: cardWithOtherPay == "benefit"
                    //                 ? ColorConstants.appColor
                    //                 : ColorConstants.pureBlack),
                    //       ),
                    //       secondary: Image.asset(
                    //         "assets/images/benefit_pay.png",
                    //         height: 40,
                    //         width: 40,
                    //       ),
                    //       // card_icon
                    //       selected: false,
                    //       onChanged: (val) async {
                    //         if (isWalletSelected && totalOrderPrice == 0) {
                    //           Fluttertoast.showToast(
                    //             msg:
                    //                 "Sufficient amount in wallet to place this order", // message
                    //             toastLength: Toast.LENGTH_SHORT, // length
                    //             gravity: ToastGravity.CENTER, // location
                    //             // duration
                    //           );
                    //         } else if (isCouponCodeVisible &&
                    //             totalOrderPrice == 0) {
                    //           Fluttertoast.showToast(
                    //             msg:
                    //                 "Sufficient amount in coupon discount to place this order", // message
                    //             toastLength: Toast.LENGTH_SHORT, // length
                    //             gravity: ToastGravity.CENTER, // location
                    //             // duration
                    //           );
                    //         } else {
                    //           isCODSelected = false;
                    //           print("This is the card on pressed fun${val}");
                    //           selectedPaymentType = "Card";
                    //           cardWithOtherPay = "benefit";
                    //           _isCOD = val;
                    //           setState(() {});
                    //         }
                    //       }),
                    // ),
                    // SizedBox(
                    //   height: 8,
                    // ),
                    // Container(
                    //   height: radioListTileHeight,
                    //   decoration: BoxDecoration(
                    //     color: ColorConstants.white,
                    //     // border: Border.all(
                    //     //   color: ColorConstants.appfaintColor,
                    //     //   width: 1,
                    //     // ),
                    //   ),
                    //   child: RadioListTile(
                    //       activeColor: ColorConstants.appColor,
                    //       value: 8, //isWalletSelected,
                    //       groupValue: _isCOD,
                    //       title: Text(
                    //         "PayPal",
                    //         style: TextStyle(
                    //             fontFamily: fontRailwayRegular,
                    //             fontWeight: FontWeight.w200,
                    //             fontSize: 15,
                    //             color: cardWithOtherPay == "paypal"
                    //                 ? ColorConstants.appColor
                    //                 : ColorConstants.pureBlack),
                    //       ),
                    //       secondary: Image.asset(
                    //         "assets/images/paypal_logo.png",
                    //         height: 40,
                    //         width: 40,
                    //       ),
                    //       // card_icon
                    //       selected: false,
                    //       onChanged: (val) async {
                    //         if (isWalletSelected && totalOrderPrice == 0) {
                    //           Fluttertoast.showToast(
                    //             msg:
                    //                 "Sufficient amount in wallet to place this order", // message
                    //             toastLength: Toast.LENGTH_SHORT, // length
                    //             gravity: ToastGravity.CENTER, // location
                    //             // duration
                    //           );
                    //         } else if (isCouponCodeVisible &&
                    //             totalOrderPrice == 0) {
                    //           Fluttertoast.showToast(
                    //             msg:
                    //                 "Sufficient amount in coupon discount to place this order", // message
                    //             toastLength: Toast.LENGTH_SHORT, // length
                    //             gravity: ToastGravity.CENTER, // location
                    //             // duration
                    //           );
                    //         } else {
                    //           isCODSelected = false;
                    //           print("This is the card on pressed fun${val}");
                    //           selectedPaymentType = "Card";
                    //           cardWithOtherPay = "paypal";
                    //           _isCOD = val;
                    //           setState(() {});
                    //         }
                    //       }),
                    // ),
                    // SizedBox(
                    //   height: 8,
                    // ),
                    // Container(
                    //   height: radioListTileHeight,
                    //   decoration: BoxDecoration(
                    //     color: ColorConstants.white,
                    //     // border: Border.all(
                    //     //   color: ColorConstants.appfaintColor,
                    //     //   width: 1,
                    //     // ),
                    //   ),
                    //   child: RadioListTile(
                    //       activeColor: ColorConstants.appColor,
                    //       value: 9, //isWalletSelected,
                    //       groupValue: _isCOD,
                    //       title: Text(
                    //         "Knet",
                    //         style: TextStyle(
                    //             fontFamily: fontRailwayRegular,
                    //             fontWeight: FontWeight.w200,
                    //             fontSize: 15,
                    //             color: cardWithOtherPay == "knet"
                    //                 ? ColorConstants.appColor
                    //                 : ColorConstants.pureBlack),
                    //       ),
                    //       secondary: Image.asset(
                    //         "assets/images/knet_pay_logo.png",
                    //         height: 40,
                    //         width: 40,
                    //       ),
                    //       // card_icon
                    //       selected: false,
                    //       onChanged: (val) async {
                    //         if (isWalletSelected && totalOrderPrice == 0) {
                    //           Fluttertoast.showToast(
                    //             msg:
                    //                 "Sufficient amount in wallet to place this order", // message
                    //             toastLength: Toast.LENGTH_SHORT, // length
                    //             gravity: ToastGravity.CENTER, // location
                    //             // duration
                    //           );
                    //         } else if (isCouponCodeVisible &&
                    //             totalOrderPrice == 0) {
                    //           Fluttertoast.showToast(
                    //             msg:
                    //                 "Sufficient amount in coupon discount to place this order", // message
                    //             toastLength: Toast.LENGTH_SHORT, // length
                    //             gravity: ToastGravity.CENTER, // location
                    //             // duration
                    //           );
                    //         } else {
                    //           isCODSelected = false;
                    //           print("This is the card on pressed fun${val}");
                    //           selectedPaymentType = "Card";
                    //           cardWithOtherPay = "knet";
                    //           _isCOD = val;
                    //           setState(() {});
                    //         }
                    //       }),
                    // ),

                    SizedBox(
                      height: 8,
                    ),

                    SizedBox(height: 20.0),
                  ],
                ),
              )
            : _productShimmer(),

        bottomNavigationBar: BottomAppBar(
          height: 70,
          color: ColorConstants.white,
          elevation: 8,
          child: InkWell(
            onTap: () {
              _makeOrder();
            },
            child: Container(
              decoration: BoxDecoration(
                color: ColorConstants.appColor,
                border: Border.all(
                  color: ColorConstants.appColor,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(
                  left: 20, right: 20, top: 5, bottom: 15),
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //  Wallet Image
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Image.asset(
                        "assets/images/wallet_red.png",
                        color: ColorConstants.white,
                        height: 30,
                        width: 30,
                      ),
                    ),

                    // 📝 Center Text
                    Expanded(
                      child: Center(
                        child: Text(
                          btnProceedName,
                          style: TextStyle(
                            fontFamily: global.fontOufitMedium,
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                            color: ColorConstants.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),

                    // 💰 Price Text
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        "AED ${(totalOrderPrice).toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontFamily: global.fontOufitMedium,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('G1--->API call1');
    if (state == AppLifecycleState.resumed) {
      setState(() {
        print('G1--->API call');
      });
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

  _applyCoupon(String couponCode) async {
    showOnlyLoaderDialog();
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        await apiHelper
            .applyCoupon(
                cartId: cartController
                    .cartItemsList.cartData!.cartProductdata![0].storeId
                    .toString(),
                couponCode: couponCode,
                user_id: global.currentUser != null
                    ? global.currentUser.id.toString()
                    : "",
                total_delivery: global.total_delivery_count)
            .then((result) async {
          if (result != null) {
            if (result.status == "1") {
              print("this is the result data in coupons screen ${result.data}");
              _txtApplyCoupan.clear();
              showCouponField = false;
              CouponCode couponCode1 = result.data;
              couponCode1.coupon_code = couponCode;
              var discounted_amount = couponCode1.discounted_amount;
              var save_amount = couponCode1.save_amount;
              var coupon_id = couponCode1.coupon_id;
              print(discounted_amount);
              print(save_amount);
              couponDiscount =
                  (couponCode1 != null ? couponCode1.save_amount : 0.0)!;
              couponCodeStr =
                  couponCode1 != null ? couponCode1.coupon_code : "";
              couponid = (couponCode1 != null ? couponCode1.coupon_id : 0)!;
              if (couponDiscount > 0) {
                isCouponCodeVisible = true;
                isDiscountCodeVisible = false;
              } else {
                isCouponCodeVisible = false;
                isDiscountCodeVisible = true;
              }
              _isCOD = 0;
              selectedPaymentType = "Wallet";
              if (couponDiscount == totalOrderPrice) {
                selectedPaymentType = "Wallet";
              }
              walletAppliedRemoved();
              hideLoader();
              setState(() {});
            } else {
              hideLoader();
              boolCouponCodeError = true;
              strCouponCodeError = result.message;
              setState(() {});
            }
          }
        });
      } else {
        hideLoader();
        boolCouponCodeError = true;
        strCouponCodeError = "Something went wrong";
        setState(() {});
      }

      setState(() {});
    } catch (e) {
      hideLoader();
      print("Exception - coupons_screen.dart - _applyCoupon():" + e.toString());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
    //_razorpay.clear();
  }

  @override
  void initState() {
    //  print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    super.initState();
    _getAppInfo();
    _init();

    WidgetsBinding.instance.addObserver(this);

    totalOrderPrice = double.parse(
        cartController.cartItemsList.cartData!.totalPrice.toString());
    totalDeliveryCharge = double.parse(
        cartController.cartItemsList.cartData!.deliveryCharge.toString());
    print(
        "delivery change--->${cartController.cartItemsList.cartData!.deliveryCharge}");
    cartItemPrice = double.parse(
        (cartController.cartItemsList.cartData!.totalPrice! -
                cartController.cartItemsList.cartData!.deliveryCharge!)
            .toString());
  }

  _makeOrder() async {
    // itemsToOrder.clear();
    print("Make order");
    try {
      bool isConnected = await br!.checkConnectivity();
      print("Make order1");
      if (global.currentUser == null ||
          global.currentUser.email == null ||
          (global.currentUser.email != null &&
              global.currentUser.email!.isEmpty) ||
          global.currentUser.userPhone == null ||
          (global.currentUser.userPhone != null &&
              global.currentUser.userPhone!.isEmpty)) {
        Navigator.of(context).push(
          NavigationUtils.createAnimatedRoute(
              1.0,
              ProfileEditScreen(
                a: widget.analytics,
                o: widget.observer,
              )),
        );
      } else {
        if (isCouponCodeVisible && selectedPaymentType == "COD") {
          Fluttertoast.showToast(
            msg: "Coupon Discount is valid only for Card Payments", // message
            toastLength: Toast.LENGTH_SHORT, // length
            gravity: ToastGravity.CENTER, // location
            // duration
          );
        } else if (isWalletSelected &&
            (totalOrderPrice != 0 || totalOrderPrice != 0.0) &&
            selectedPaymentType.toLowerCase() == "wallet") {
          showPaymentError = true;
          paymentErrorMSG =
              "Select Payment Method As Your Wallet Has Low Amount";
          setState(() {});
        } else if (isConnected) {
          print("Make order");
          if (isWalletSelected &&
              selectedPaymentType.toLowerCase() == "wallet" &&
              global.currentUser != null &&
              (totalOrderPrice == 0 || totalOrderPrice == 0.0)) {
            showOnlyLoaderDialog();
            await apiHelper
                .makeOrder(
                    selectedDate: selectedDate,
                    selectedTime: selectedTime,
                    paymentType: selectedPaymentType,
                    description: "",
                    totalAmount: (totalOrderPrice + totalDeliveryCharge!)
                        .toStringAsFixed(2),
                    totalDelivery: global.total_delivery_count,
                    // repeatOrders: repeat_orders,
                    selectedAddressID: selectedAddressID,
                    coupon_code: couponCodeStr,
                    walletmount:
                        !isWalletSelected ? "0.0" : "${totalWalletSpendings}",
                    message: message != null ? message : "",
                    coupon_amount: couponDiscount.toString(),
                    si_sub_ref_no: si_sub_ref_no)
                .then((result) async {
              print(result.toString());
              if (result != null) {
                if (result.status == "1") {
                  //order = result.data;
                  // hideLoader();
                  print('G11--->Checkout call${result.data}');
                  hideloadershowing();
                  FirebaseAnalyticsGA4().callAnalyticsCheckOut(
                      cartController,
                      0,
                      couponCodeStr!,
                      couponDiscount,
                      selectedAddressID.toString(),
                      result.data['order_id']);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderConfirmationScreen(
                                a: widget.analytics,
                                o: widget.observer,
                                // order: order,
                                screenId: 1,
                                cartID: result.data['order_id'],
                              )));

                  //
                  //_orderCheckOut1('success', 'COD', null, null);
                } else if (result.status == "2") {
                  print('G12--->${result.message}');
                  hideloadershowing();
                  showPaymentError = true;
                  paymentErrorMSG = result.message;
                  btnProceedName = "RETRY";
                  setState(() {});
                } else {
                  print('G11--->${result.message}');

                  hideloadershowing();
                  showPaymentError = true;
                  paymentErrorMSG = result.message;
                  btnProceedName = "RETRY";
                  setState(() {});
                }
              } else {
                hideloadershowing();
                paymentErrorMSG = "Something went wrong. Please try again";
                showPaymentError = true;
                btnProceedName = "RETRY";

                setState(() {});
              }
            });
          } else if (!isWalletSelected &&
              isCouponCodeVisible &&
              selectedPaymentType.toLowerCase() == "wallet" &&
              (totalOrderPrice == 0 || totalOrderPrice == 0.0)) {
            showOnlyLoaderDialog();
            await apiHelper
                .makeOrder(
                    selectedDate: selectedDate,
                    selectedTime: selectedTime,
                    paymentType: selectedPaymentType,
                    description: "",
                    totalAmount: (totalOrderPrice + totalDeliveryCharge!)
                        .toStringAsFixed(2),
                    totalDelivery: global.total_delivery_count,
                    // repeatOrders: repeat_orders,
                    selectedAddressID: selectedAddressID,
                    coupon_code: couponCodeStr,
                    walletmount:
                        !isWalletSelected ? "0.0" : "${totalWalletSpendings}",
                    message: message != null ? message : "",
                    coupon_amount: couponDiscount.toString(),
                    si_sub_ref_no: si_sub_ref_no)
                .then((result) async {
              print(result.toString());
              if (result != null) {
                if (result.status == "1") {
                  //order = result.data;
                  // hideLoader();
                  print('G11--->Checkout call${result.data}');
                  hideloadershowing();
                  FirebaseAnalyticsGA4().callAnalyticsCheckOut(
                      cartController,
                      0,
                      couponCodeStr!,
                      couponDiscount,
                      selectedAddressID.toString(),
                      result.data['order_id']);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderConfirmationScreen(
                                a: widget.analytics,
                                o: widget.observer,
                                // order: order,
                                screenId: 1,
                                cartID: result.data['order_id'],
                              )));

                  //
                  //_orderCheckOut1('success', 'COD', null, null);
                } else if (result.status == "2") {
                  print('G12--->${result.message}');
                  hideloadershowing();
                  showPaymentError = true;
                  paymentErrorMSG = result.message;
                  btnProceedName = "RETRY";
                  setState(() {});
                } else {
                  print('G11--->${result.message}');

                  hideloadershowing();
                  showPaymentError = true;
                  paymentErrorMSG = result.message;
                  btnProceedName = "RETRY";
                  setState(() {});
                }
              } else {
                hideloadershowing();
                paymentErrorMSG = "Something went wrong. Please try again";
                showPaymentError = true;
                btnProceedName = "RETRY";
                setState(() {});
              }
            });
          } else {
            if (selectedPaymentType == "Card") {
              if (appInfo.openPaymentSDK != null && appInfo.openPaymentSDK!) {
                initGoSellSdk(); ////Mark error
              } else {
                callWebViewPayment();
              }

              // callWebViewPayment();
            }
            // else if (selectedPaymentType == "tabby") {
            //   if ((totalOrderPrice + totalDeliveryCharge!) > 10) {
            //     callWebViewPayment();
            //   } else {
            //     paymentErrorMSG =
            //         "Your total order amount is less to perform Tabby pay";
            //     showPaymentError = true;

            //     setState(() {});
            //   }
            // }
            else if (selectedPaymentType == "COD") {
              showOnlyLoaderDialog();
              await apiHelper
                  .makeOrder(
                      selectedDate: selectedDate,
                      selectedTime: selectedTime,
                      paymentType: selectedPaymentType,
                      totalAmount: (totalOrderPrice + totalDeliveryCharge!)
                          .toStringAsFixed(2),
                      totalDelivery: global.total_delivery_count,
                      // repeatOrders: repeat_orders,
                      selectedAddressID: selectedAddressID,
                      coupon_code: couponCodeStr,
                      description: "",
                      walletmount:
                          !isWalletSelected ? "0.0" : "${totalWalletSpendings}",
                      message: message != null ? message : "",
                      coupon_amount: couponDiscount.toString(),
                      si_sub_ref_no: si_sub_ref_no)
                  .then((result) async {
                print(result.toString());
                if (result != null) {
                  if (result.status == "1") {
                    //order = result.data;
                    // hideLoader();
                    print('G11--->Checkout call${result.data}');
                    hideloadershowing();
                    FirebaseAnalyticsGA4().callAnalyticsCheckOut(
                        cartController,
                        0,
                        couponCodeStr!,
                        couponDiscount,
                        selectedAddressID.toString(),
                        result.data['order_id']);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderConfirmationScreen(
                          a: widget.analytics,
                          o: widget.observer,
                          // order: order,
                          screenId: 1,
                          cartID: result.data['order_id'],
                        ),
                      ),
                    );

                    //
                    //_orderCheckOut1('success', 'COD', null, null);
                  } else if (result.status == "2") {
                    print('G12--->${result.message}');
                    hideloadershowing();
                    showPaymentError = true;
                    paymentErrorMSG = result.message;
                    setState(() {});
                    // _alertMsg(result.message, 1);
                  } else {
                    print('G11--->${result.message}');

                    hideloadershowing();
                    showPaymentError = true;
                    paymentErrorMSG = result.message;
                    setState(() {});
                    // _alertMsg(result.message, 0);
                  }
                } else {
                  hideloadershowing();
                  showPaymentError = true;
                  paymentErrorMSG = "Something went wrong! Please try again";
                  setState(() {});

                  // _alertMsg("Something went wrong. Please try again", 0);
                }
              });
            } else {
              // Fluttertoast.showToast(
              //   msg: "Choose Payment Method", // message
              //   toastLength: Toast.LENGTH_SHORT, // length
              //   gravity: ToastGravity.CENTER, // location
              //   // duration
              // );
              showPaymentError = true;
              paymentErrorMSG = "Choose Payment Method";
              setState(() {});
            }
          }
        } else {
          hideloadershowing();
          showNetworkErrorSnackBar(_scaffoldKey!);
        }
      }
    } catch (e) {
      print("Exception - checkout_screen.dart - _makeOrder():" + e.toString());
    }
  }

  void hideloadershowing() {
    Navigator.pop(context);
  }

  _alertMsg(String msg, int goCart) async {
    try {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(dialogBackgroundColor: Colors.white),
              child: CupertinoAlertDialog(
                title: Text(
                  'byyu',
                ),
                content: Text(
                  msg,
                ),
                actions: <Widget>[
                  goCart == 1
                      ? CupertinoDialogAction(
                          child: Text(
                            'Go to Cart',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: fontRailwayRegular,
                                fontWeight: FontWeight.w200,
                                color: Colors.blue),
                          ),
                          onPressed: () {
                            // Navigator.of(context).pop(false);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CartScreen(
                                          a: widget.analytics,
                                          o: widget.observer,
                                          fromHomeScreen: false,
                                        )));
                          },
                        )
                      : CupertinoDialogAction(
                          child: Text('OK',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: fontRailwayRegular,
                                  fontWeight: FontWeight.w200,
                                  color: Colors.blue)),
                          onPressed: () {
                            return Navigator.of(context).pop(false);
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

  bool getInfoCall = false;
  _getAppInfo() async {
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        await apiHelper.getAppInfo().then((result) async {
          if (result != null) {
            if (result.status == "1") {
              global.appInfo = result.data;
              print(global.appInfo.userwallet);
              setState(() {
                global.currentUser.wallet = global.appInfo.userwallet;
                totalWalletAmount = global.currentUser.wallet!;
                // if (global.currentUser.wallet! > 0) {
                //   showWaletSelection = true;
                // } else {
                //   showWaletSelection = false;
                // }
                //global.currentUser.wallet = global.appInfo.userwallet;
                getInfoCall = true;
                // if (global.currentUser.wallet != 0) {
                //   isWalletSelected = true;
                //   if (cartController.cartItemsList.cartData!.totalPrice! >
                //       totalWalletAmount) {
                //     totalWalletSpendings = global.currentUser.wallet!;
                //     totalOrderPrice = totalOrderPrice - totalWalletSpendings;
                //     totalWalletbalance = 0;
                //     totalDiscountToTapPay = totalWalletSpendings;
                //   } else {
                //     totalWalletSpendings =
                //         double.parse(totalOrderPrice.toString());
                //     totalOrderPrice = totalOrderPrice - totalWalletSpendings;
                //     totalWalletbalance =
                //         totalWalletAmount - totalWalletSpendings;
                //     totalDiscountToTapPay = totalWalletSpendings;
                //   }
                // } else {
                //   isWalletSelected = false;
                // }
                _isDataLoaded = true;
                print('G1');
              });
            }
          }
        });
      }
    } catch (e) {
      print("Exception - PaymentScreen.dart - _getAppInfo():" + e.toString());
    } finally {}
  }

  _init() async {
    try {
      setState(() {});
    } catch (e) {
      print("Exception - paymentGatewaysScreen.dart.dart - _init():" +
          e.toString());
    }
  }

  Widget _productShimmer() {
    try {
      return ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: Card(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      print("Exception - productDetailScreen.dart - _productShimmer():" +
          e.toString());
      return SizedBox();
    }
  }

  walletAppliedRemoved() {
    if (isWalletSelected) {
////##################### condition if wallet+coupon amount is greater than order and return the amount to wallet
      if (totalWalletSpendings + couponDiscount >
          double.parse(
              cartController.cartItemsList.cartData!.totalPrice.toString())) {
////##################### condition if coupon amount is greater than wallet amount
        if (couponDiscount ==
            double.parse(
                cartController.cartItemsList.cartData!.totalPrice.toString())) {
          totalWalletSpendings = 0.0;
          totalOrderPrice = 0.0;
          totalWalletbalance = global.appInfo.userwallet!;
          isWalletSelected = false;
        } else {
          totalWalletSpendings = double.parse(cartController
                  .cartItemsList.cartData!.totalPrice
                  .toString()) -
              couponDiscount;
          totalWalletbalance =
              global.appInfo.userwallet! - totalWalletSpendings;
          totalOrderPrice = 0.0;
        }
      } else {
////##################### condition if wallet+coupon amount is smaller than order

        totalWalletbalance = global.appInfo.userwallet! - totalWalletSpendings;
        totalOrderPrice = double.parse(
                cartController.cartItemsList.cartData!.totalPrice.toString()) -
            (totalWalletSpendings + couponDiscount);
      }

      if (totalOrderPrice == 0.0) {
        _isCOD = 0;
        selectedPaymentType = "Wallet";
        setState(() {});
      }
    } else {
      //////#####################this is wallet removed

      totalWalletSpendings = 0.0;
      totalWalletbalance = global.appInfo.userwallet!;
      totalOrderPrice = double.parse(
              (cartController.cartItemsList.cartData!.totalPrice).toString()) -
          couponDiscount;
    }
  }

  void initGoSellSdk() {
    print("Make order go sell sdk");
    GoSellSdkFlutter.configureApp(
        bundleId: "com.byyu",
        lang: "en",
        productionSecretKey: tapPayMobileLiveSecretKey,
        sandBoxSecretKey: tapPayMobileSecretKey);
    Platform.isAndroid ? setupSDKSession() : setUpIosSdkSession();
  }

  Future<void> setUpIosSdkSession() async {
    try {
      GoSellSdkFlutter.sessionConfigurations(
        trxMode: TransactionMode.PURCHASE,
        transactionCurrency: "AED",
        amount: totalOrderPrice,
        customer: Customer(
          // customerId: "",
          customerId:
              global.appInfo != null && global.appInfo.tapcustomer_id != null
                  ? global.appInfo.tapcustomer_id!
                  : "",
          // global.currentUser.id.toString(),
          // customer id is important to retrieve cards saved for this customer
          email: global.currentUser.email!,
          isdNumber: "", //global.currentUser.countryCode,
          number: global.currentUser.userPhone!,
          firstName: global.currentUser.name!,
          middleName: "",
          lastName: "",
          metaData: null,
        ),
        paymentItems: <PaymentItem>[
          PaymentItem(
              name: "item1",
              amountPerUnit: double.parse(totalOrderPrice.toStringAsFixed(2)),
              quantity: Quantity(value: 1),
              description: cartController
                  .cartItemsList.cartData!.cartProductdata![0].productName,
              totalAmount:
                  0 //int.parse(totalOrderPrice.roundToDouble().toString()),
              ),
        ],
        //itemsToOrder,

        // List of shipping

        postURL: "https://tap.company",
        // Payment description
        paymentDescription: "Secure Payment",
        // Payment Metadata
        paymentMetaData: {
          "a": "a meta",
          "b": "b meta",
        },
        // Payment Reference
        paymentReference: Reference(
            acquirer: "acquirer",
            gateway: "gateway",
            payment: "payment",
            track: "track",
            transaction: "trans_910101",
            order: global.currentUser.id.toString() + global.currentUser.name!),
        // payment Descriptor
        paymentStatementDescriptor: "paymentStatementDescriptor",
        // Save Card Switch
        isUserAllowedToSaveCard: true,
        // Enable/Disable 3DSecure
        isRequires3DSecure: true,
        // Receipt SMS/Email
        receipt: Receipt(true, false),
        // Authorize Action [Capture - Void]
        authorizeAction:
            AuthorizeAction(type: AuthorizeActionType.CAPTURE, timeInHours: 1),
        // Destinations
        destinations: null,
        // merchant id
        merchantID: "",
        // Allowed cards
        allowedCadTypes: CardType.ALL,
        applePayMerchantID: "merchant.com.byyuone",
        allowsToSaveSameCardMoreThanOnce: true,
        // pass the card holder name to the SDK
        cardHolderName: "Name",
        // disable changing the card holder name by the user
        allowsToEditCardHolderName: true,
        // select payments you need to show [Default is all, and you can choose between WEB-CARD-APPLEPAY ]
        paymentType: PaymentType.ALL,
        // Supported payment methods List
        // supportedPaymentMethods: [
        //   "knet",
        //   "visa",
        //   "mastercard",
        //   "gpay",
        //   "tabby"
        // ],

        // // Transaction mode
        sdkMode: global.baseUrl.contains("adminDev")
            ? SDKMode.Sandbox
            : SDKMode.Production,
        // sdkMode:SDKMode.Sandbox,
        // sdkMode: SDKMode.Production,
        taxes: [],
        shippings: [],
        // appearanceMode: SDKAppearanceMode.fullscreen,
      );
    } on PlatformException {
      // platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) {
      print("Nikhil not mounted");
      // hideLoader();
      callPaymentFailureAPI("TapPayment_Mounted", "Mounting failure");
      return;
    } else {
      callPaymentFailureAPI("TapPayment_Mounted", "Mount");

      print("Nikhil mounted");
      startSDK();
    }

    setState(() {
      tapSDKResult = {};
    });
  }

  Future<void> setupSDKSession() async {
    try {
      GoSellSdkFlutter.sessionConfigurations(
        trxMode: TransactionMode.PURCHASE,
        transactionCurrency: "AED",
        amount:
            double.parse(totalOrderPrice.toStringAsFixed(2)), //totalOrderPrice,
        googlePayWalletMode: global.baseUrl.contains("adminDev")
            ? GooglePayWalletMode.ENVIRONMENT_TEST
            : GooglePayWalletMode.ENVIRONMENT_PRODUCTION,
        customer: Customer(
          // customerId: "",
          customerId:
              global.appInfo != null && global.appInfo.tapcustomer_id != null
                  ? global.appInfo.tapcustomer_id!
                  : "",
          // global.currentUser.id.toString(),
          // customer id is important to retrieve cards saved for this customer
          email: global.currentUser.email!,
          isdNumber: "", //global.currentUser.countryCode,
          number: global.currentUser.userPhone!,
          firstName: global.currentUser.name!,
          middleName: "",
          lastName: "",
          metaData: null,
        ),
        paymentItems: <PaymentItem>[
          PaymentItem(
              name: "item1",
              amountPerUnit: double.parse(totalOrderPrice.toStringAsFixed(2)),
              quantity: Quantity(value: 1),
              description: cartController
                  .cartItemsList.cartData!.cartProductdata![0].productName,
              totalAmount:
                  0 //int.parse(totalOrderPrice.roundToDouble().toString()),
              ),
        ],
        //itemsToOrder,

        // List of shipping

        postURL: "https://tap.company",
        // Payment description
        paymentDescription: "Secure Payment",
        // Payment Metadata
        paymentMetaData: {
          "a": "a meta",
          "b": "b meta",
        },
        // Payment Reference
        paymentReference: Reference(
            acquirer: "acquirer",
            gateway: "gateway",
            payment: "payment",
            track: "track",
            transaction: "trans_910101",
            order: global.currentUser.id.toString() + global.currentUser.name!),
        // payment Descriptor
        paymentStatementDescriptor: "paymentStatementDescriptor",
        // Save Card Switch
        isUserAllowedToSaveCard: true,
        // Enable/Disable 3DSecure
        isRequires3DSecure: true,
        // Receipt SMS/Email
        receipt: Receipt(true, false),
        // Authorize Action [Capture - Void]
        authorizeAction:
            AuthorizeAction(type: AuthorizeActionType.CAPTURE, timeInHours: 1),
        // Destinations
        destinations: null,
        // merchant id
        merchantID: "",
        // Allowed cards
        allowedCadTypes: CardType.ALL,
        applePayMerchantID: "merchant.com.byyu",
        allowsToSaveSameCardMoreThanOnce: true,
        // pass the card holder name to the SDK
        cardHolderName: "Name",
        // disable changing the card holder name by the user
        allowsToEditCardHolderName: true,
        // select payments you need to show [Default is all, and you can choose between WEB-CARD-APPLEPAY ]
        paymentType: PaymentType.ALL,
        // Supported payment methods List
        // supportedPaymentMethods: [
        //   "knet",
        //   "visa",
        //   "mastercard",
        //   "gpay",
        //   "tabby"
        // ],

        // // Transaction mode
        sdkMode: global.baseUrl.contains("adminDev")
            ? SDKMode.Sandbox
            : SDKMode.Production,
        // sdkMode:SDKMode.Sandbox,
        // sdkMode: SDKMode.Production,
        taxes: [],
        shippings: [],
        // appearanceMode: SDKAppearanceMode.fullscreen,
      );
    } on PlatformException {
      // platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) {
      print("Nikhil not mounted");
      // hideLoader();
      callPaymentFailureAPI("Android_TapPayment_Mounted", "Mounting failure");
      return;
    } else {
      callPaymentFailureAPI("TapPayment_Mounted", "Mount");
      // hideLoader();
      print("Nikhil mounted");
      startSDK();
    }

    setState(() {
      tapSDKResult = {};
    });
  }

  Future<void> startSDK() async {
    setState(() {
      showOnlyLoaderDialog();
    });
    try {
      tapSDKResult = await GoSellSdkFlutter.startPaymentSDK;
    } catch (e) {
      GoSellSdkFlutter.terminateSession;
      showPaymentError = true;
      paymentErrorMSG = "Something went wrong please try again";
      callPaymentFailureAPI(
          "TapPayment_catch", "Catch called due to exception ${e.toString()}");
    }

    if (tapSDKResult != null && tapSDKResult!['sdk_result'] == null) {
      // GoSellSdkFlutter.terminateSession;
      btnProceedName = "RETRY";
      callPaymentFailureAPI("TapPayment_resultNull",
          "The Tap sdk resulted to null value in return");
    }
    if (tapSDKResult != null) {
      setState(() {
        switch (tapSDKResult!['sdk_result']) {
          case "SUCCESS":
            sdkStatus = "SUCCESS";
            handleSDKResult();
            break;
          case "FAILED":
            hideLoader();
            sdkStatus = "FAILED";
            GoSellSdkFlutter.terminateSession;
            btnProceedName = "RETRY";
            showPaymentError = true;
            paymentErrorMSG = tapSDKResult!['sdk_error_message'];
            callPaymentFailureAPI(
                "TapPayment_FAILED", tapSDKResult!['sdk_error_description']);

            handleSDKResult();
            break;
          case "SDK_ERROR":
            hideLoader();
            print('sdk error............');
            print(tapSDKResult!['sdk_error_code']);
            print(tapSDKResult!['sdk_error_message']);
            print(tapSDKResult!['sdk_error_description']);
            print('sdk error............');
            showPaymentError = true;
            paymentErrorMSG = tapSDKResult!['sdk_error_message'];
            GoSellSdkFlutter.terminateSession;
            callPaymentFailureAPI("TapPayment_SDK_ERROR",
                "${tapSDKResult!['sdk_error_message']}----${tapSDKResult!['sdk_error_description']}");
            btnProceedName = "RETRY";
            setState(() {});
            break;

          case "NOT_IMPLEMENTED":
            hideLoader();
            sdkStatus = "NOT_IMPLEMENTED";
            GoSellSdkFlutter.terminateSession;
            showPaymentError = true;
            print(
                "This is not implemented codition description ${tapSDKResult!['sdk_error_description']}");
            paymentErrorMSG = "Something went wrong please try again";
            btnProceedName = "RETRY";
            callPaymentFailureAPI(
                "TapPayment_NOT_IMPLEMENTED", "Failed to load SDK");
            setState(() {});
            break;
          case "CANCELLED":
            hideLoader();
            print(
                "This is CANCELLED codition message ${tapSDKResult!['sdk_error_message']}");

            showPaymentError = true;
            btnProceedName = "RETRY";
            callPaymentFailureAPI("TapPayment_CANCELLED", "Cancelled By User");
            paymentErrorMSG = "Please make payment to place the order";
            setState(() {});
            GoSellSdkFlutter.terminateSession;
            break;
          default:
            callPaymentFailureAPI("TapPayment_Default",
                "Start SDK Default case -----${tapSDKResult!['sdk_result']} ");
            break;
        }
      });
    } else {
      GoSellSdkFlutter.terminateSession;
      showPaymentError = true;
      paymentErrorMSG = "Something went wrong please try again";
      callPaymentFailureAPI("TapPayment", "Tap SDK result NULL");
      btnProceedName = "RETRY";
      setState(() {});
    }
  }

  void handleSDKResult() {
    print('SDK Result>>>> $tapSDKResult');

    print('Transaction mode>>>> ${tapSDKResult!['trx_mode']}');

    switch (tapSDKResult!['trx_mode']) {
      case "CHARGE":
        printSDKResult('Charge');
        break;

      case "AUTHORIZE":
        printSDKResult('Authorize');
        break;

      case "SAVE_CARD":
        printSDKResult('Save Card');
        break;

      case "TOKENIZE":
        print('TOKENIZE token : ${tapSDKResult!['token']}');
        print('TOKENIZE token_currency  : ${tapSDKResult!['token_currency']}');
        print('TOKENIZE card_first_six : ${tapSDKResult!['card_first_six']}');
        print('TOKENIZE card_last_four : ${tapSDKResult!['card_last_four']}');
        print('TOKENIZE card_object  : ${tapSDKResult!['card_object']}');
        print('TOKENIZE card_exp_month : ${tapSDKResult!['card_exp_month']}');
        print('TOKENIZE card_exp_year    : ${tapSDKResult!['card_exp_year']}');
        print('TOKENIZE issuer_id    : ${tapSDKResult!['issuer_id']}');
        print('TOKENIZE issuer_bank    : ${tapSDKResult!['issuer_bank']}');
        print(
            'TOKENIZE issuer_country    : ${tapSDKResult!['issuer_country']}');
        responseID = tapSDKResult!['token'];
        break;
      default:
        callPaymentFailureAPI(
            "TapPayment_Default", "handel SDK result Default case ");
        break;
    }
  }

  void printSDKResult(String trxMode) async {
    print('$trxMode status                : ${tapSDKResult!['status']}');
    if (trxMode == "Authorize") {
      print('$trxMode id              : ${tapSDKResult!['authorize_id']}');
    } else {
      print('$trxMode id               : ${tapSDKResult!['charge_id']}');
    }
    print('$trxMode  description        : ${tapSDKResult!['description']}');
    print('$trxMode  message           : ${tapSDKResult!['message']}');
    print('$trxMode  card_first_six : ${tapSDKResult!['card_first_six']}');
    print('$trxMode  card_last_four   : ${tapSDKResult!['card_last_four']}');
    print('$trxMode  card_object         : ${tapSDKResult!['card_object']}');
    print('$trxMode  card_id         : ${tapSDKResult!['card_id']}');
    print('$trxMode  card_brand          : ${tapSDKResult!['card_brand']}');
    print('$trxMode  card_exp_month  : ${tapSDKResult!['card_exp_month']}');
    print('$trxMode  card_exp_year: ${tapSDKResult!['card_exp_year']}');
    print('$trxMode  acquirer_id  : ${tapSDKResult!['acquirer_id']}');
    print(
        '$trxMode  acquirer_response_code : ${tapSDKResult!['acquirer_response_code']}');
    print(
        '$trxMode  acquirer_response_message: ${tapSDKResult!['acquirer_response_message']}');
    print('$trxMode  source_id: ${tapSDKResult!['source_id']}');
    print('$trxMode  source_channel     : ${tapSDKResult!['source_channel']}');
    print('$trxMode  source_object      : ${tapSDKResult!['source_object']}');
    print(
        '$trxMode source_payment_type : ${tapSDKResult!['source_payment_type']}');

    if (trxMode == "Authorize") {
      responseID = tapSDKResult!['authorize_id'];
    } else {
      responseID = tapSDKResult!['charge_id'];
    }
    print("inside of if and api call");
    String tapcustomer_id, transaction_status, charge_id;
    tapcustomer_id = tapSDKResult!['customer_id'];
    transaction_status = tapSDKResult!['sdk_result'];
    charge_id = tapSDKResult!['charge_id'];
    print("inside of if and api call${tapSDKResult!['sdk_result']}");
    if (transaction_status == "Success" ||
        transaction_status.toLowerCase() == "success") {
      print("inside of if and api call${tapSDKResult!['sdk_result']}");
      await apiHelper
          .makeOrder(
              selectedDate: selectedDate,
              selectedTime: selectedTime,
              paymentType: "Paid",
              totalAmount:
                  (totalOrderPrice + totalDeliveryCharge!).toStringAsFixed(2),
              totalDelivery: global.total_delivery_count,
              // repeatOrders: repeat_orders,
              selectedAddressID: selectedAddressID,
              coupon_code: couponCodeStr,
              walletmount:
                  !isWalletSelected ? "0.0" : "${totalWalletSpendings}",
              coupon_amount: couponDiscount.toString(),
              si_sub_ref_no: si_sub_ref_no,
              tapcustomer_id: tapcustomer_id,
              transaction_status: transaction_status,
              message: message != null ? message : "",
              description: tapSDKResult!.toString(),
              charge_id: charge_id)
          .then((result) async {
        print(result.toString());
        if (result != null) {
          if (result.status == "1") {
            //order = result.data;
            // hideLoader();
            print('G11--->Checkout call${result.data}');
            hideloadershowing();
            FirebaseAnalyticsGA4().callAnalyticsCheckOut(
                cartController,
                0,
                couponCodeStr!,
                couponDiscount,
                selectedAddressID.toString(),
                result.data['order_id']);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderConfirmationScreen(
                  a: widget.analytics,
                  o: widget.observer,
                  // order: order,
                  screenId: 1,
                  cartID: result.data['order_id'],
                ),
              ),
            );

            //
            //_orderCheckOut1('success', 'COD', null, null);
          } else if (result.status == "2") {
            print('G12--->${result.message}');
            hideloadershowing();
            showPaymentError = true;
            paymentErrorMSG = result.message;
            setState(() {});
            // _alertMsg(result.message, 1);
          } else {
            print('G11--->${result.message}');

            hideloadershowing();
            showPaymentError = true;
            paymentErrorMSG = result.message;
            setState(() {});

            // _alertMsg(result.message, 0);
          }
        } else {
          hideloadershowing();
          paymentErrorMSG = "Something went wrong1. Please try again";
          showPaymentError = true;

          setState(() {});
        }
      });
    } else {
      callPaymentFailureAPI(
          "TapPayment_OrderPlaceApiError", tapSDKResult!.toString());
    }
  }

  callPaymentFailureAPI(String activity, dynamic description) async {
    showOnlyLoaderDialog();
    try {
      await apiHelper.paymentError(activity, description).then(
        (result) async {
          if (result.status == "1") {
            hideLoader();
          } else {
            hideLoader();
            callPaymentFailureAPI(activity, description);
          }
        },
      );
    } catch (e) {
      print("payment logs error${e.toString()}");
      hideLoader();
    }
  }

  callWebViewPayment() async {
    var i = Platform.isIOS;
    showOnlyLoaderDialog();
    await apiHelper
        .makeOrder(
            selectedDate: selectedDate,
            selectedTime: selectedTime,
            paymentType: selectedPaymentType,
            totalAmount:
                (totalOrderPrice + totalDeliveryCharge!).toStringAsFixed(2),
            totalDelivery: global.total_delivery_count,
            // repeatOrders: repeat_orders,
            selectedAddressID: selectedAddressID,
            coupon_code: couponCodeStr,
            walletmount: isWalletSelected ? "${totalWalletSpendings}" : "0.0",
            message: message != null ? message : "",
            coupon_amount: couponDiscount.toString(),
            si_sub_ref_no: si_sub_ref_no)
        .then((result) async {
      print(result.toString());
      if (result != null) {
        if (result.status == "1") {
          //order = result.data;
          // hideLoader();
          print('G11--->Checkout call${result.data}');
          hideloadershowing();

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => WebViewScreen(
                userid: global.currentUser.id.toString(),
                platform: i,
                paymentURL: result.data['data'],
                a: widget.analytics,
                o: widget.observer,
                totalAmount:
                    (totalOrderPrice + totalDeliveryCharge!).toStringAsFixed(2),
                // order: order,
              ),
              //     TapPaymentScreen(
              //   a: widget.analytics,
              //   o: widget.observer,
              // ),
            ),
          );

          //
          //_orderCheckOut1('success', 'COD', null, null);
        } else if (result.status == "2") {
          print('G12--->${result.message}');
          hideloadershowing();
          _alertMsg(result.message, 1);
        } else {
          print('G11--->${result.message}');

          hideloadershowing();
          _alertMsg(result.message, 0);
        }
      } else {
        hideloadershowing();
        _alertMsg("Something went wrong. Please try again", 0);
      }
    });
  }
}
