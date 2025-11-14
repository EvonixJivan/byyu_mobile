import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:byyu/constants/analytics_GA4.dart';
import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/CountryCodeList.dart';
import 'package:byyu/models/addressModel.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/models/couponsModel.dart';
import 'package:byyu/models/productDetailModel.dart';
import 'package:byyu/models/userModel.dart';
import 'package:byyu/screens/auth/login_screen.dart';
import 'package:byyu/screens/location_view/location_screen.dart';
import 'package:byyu/screens/notification_screen.dart';
import 'package:byyu/screens/payment_view/add_message_screen.dart';
import 'package:byyu/screens/payment_view/wallet_screen.dart';
import 'package:byyu/screens/search_screen.dart';
import 'package:byyu/widgets/bottom_button.dart';
import 'package:byyu/widgets/cart_menu.dart';
import 'package:country_picker/country_picker.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:email_validator/email_validator.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:byyu/widgets/side_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:go_sell_sdk_flutter/go_sell_sdk_flutter.dart';
import 'package:go_sell_sdk_flutter/model/models.dart';
import 'package:http/http.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:material_text_fields/material_text_fields.dart';
import 'package:material_text_fields/theme/material_text_field_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

import 'package:checkout_flutter/checkout_flutter.dart';
import 'package:crypto/crypto.dart';

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
        cartPrice!,
        callbackHomescreenSetState,
      );
}

class _PaymentGatewayScreenState extends BaseRouteState
    with WidgetsBindingObserver {
  String _checkoutStatus = '';
  String? cartId;
  int? total_delivery;
  int screenId;
  List<Coupon> _couponList = [];
  CartController cartController;
  double totalAmount;
  double cartPrice;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int total_delivery_count;
  bool _isDataLoaded = false;
  bool onProceedClicked = false;
  final _formKey = GlobalKey<FormState>();

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
  String selectedPaymentType = "Card";
  String cardWithOtherPay = "";

  bool isLoading = false;
  bool isAlertVisible = false;
  double addAmount = 0.0;
  String selectedTime;
  int? is_subscription;
  int selectedAddressID;
  DateTime? selectedDate;
  bool isLoadingTimeSlots = false;
  double couponDiscount = 0.0;
  bool isCouponCodeVisible = false;
  bool isDiscountCodeVisible = true;
  bool isBankSelected = true;
  bool isBankVisible = false;
  double? cartItemPrice;
  String? couponCodeStr = "", bankCardName = "", si_sub_ref_no;
  int couponid = 0, bankCardID = 0;

  String guestEmail = "";
  String guestName = "";
  String guestContactNumber = "";
  String guestDeliveryName = "";
  String guestDeliveryContact = "";
  String guestDeliveryEmail = "";
  String guestDeliveryDate = "";
  String guestDeliveryTimeSlot = "";
  String guestAddress = "";
  bool guestDeliveryTimeslotbool = false;
  bool isCardSelected = true;

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

  List<TimeSlotsDetails> timeSlots1 = [];
  bool callTimeslotAPI = false;
  String timeSlotNotAvailable = "";
  List<DropDownValueModel> timeSlotsDropDown = [];
  List<String> timeSlots = [];
  bool boolDeliveryTypeErrorShow = false;
  FocusNode textFieldFocusNode = FocusNode();
  FocusNode searchFocusNode = FocusNode();
  String? _selectedTime;
  bool boolDeliverySlotErrorShow = false;

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
  double priceDetailsLabelFontSize = 15;
  double priceDetailsLValueFontSize = 15;

//VARIABLES TO HOLD GUEST USER CONTACT FORM

  TextEditingController deliveryDateController = TextEditingController();
  TextEditingController loggedindeliveryDateController =
      TextEditingController();

  TextEditingController _cPhoneNumber = new TextEditingController();
  TextEditingController _cEmail = new TextEditingController();
  TextEditingController _cName = new TextEditingController();
  TextEditingController _cPhone = new TextEditingController();

  TextEditingController _AddressName = new TextEditingController();
  TextEditingController _AddressMobil = new TextEditingController();
  TextEditingController _AddressEmail = new TextEditingController();
  TextEditingController _AddressdataFiled = new TextEditingController();
  TextEditingController _Addressdata = new TextEditingController();

  FocusNode _fAddressName = new FocusNode();
  FocusNode _fAddressMobil = new FocusNode();
  FocusNode _fAddressEmailil = new FocusNode();
  FocusNode _fAddressdataFiled = new FocusNode();
  FocusNode _fAddressdata = new FocusNode();

  FocusNode _fPhoneNumber = new FocusNode();
  FocusNode _fPhone = new FocusNode();
  FocusNode _fEmail = new FocusNode();

  String countryCode = "+971";
  int _phonenumMaxLength = 9;
  String? prefixCode;
  String? dropdownValuestate;
  String? dropdownValueCode;
  int _phonenumMaxLength1 = 0;
  String? countryCodeSelected = "+971", countryCodeFlg = "🇦🇪";

  bool mobileValid = true;

  int isHomeOfficePresent = 0;
  bool isHomePresent = false;
  bool isOfficePresent = false;

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
  bool deliveryDateEmpty = false;
  bool deliveryTimeEmpty = false;

  String strWalletAmountError = "";
  String strCouponCodeError = "";
  GuestUserResponseModel? siginInResponse = new GuestUserResponseModel();

  _PaymentGatewayScreenState(
    this.screenId,
    this.totalAmount,
    this.cartController,
    this.total_delivery_count,
    this.selectedTime,
    this.is_subscription,
    this.selectedAddressID,
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
                  padding: const EdgeInsets.all(8),
                  // child: Image.asset(
                  //   "assets/images/iv_search.png",
                  //   fit: BoxFit.contain,
                  //   height: 25,
                  //   alignment: Alignment.center,
                  // ),
                  child: Icon(
                    Icons.arrow_back,
                    size: 25,
                    color: ColorConstants.appColor,
                  ),
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
                            fromBottomNvigation: false,
                          )));
                },
                child: Container(
                  height: 10,
                  alignment:
                      Alignment.center, // optional: keeps the image centered
                  child: Image.asset(
                    "assets/images/search.png",
                    fit: BoxFit.contain,
                    height: 20,
                    alignment: Alignment.center,
                  ),
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
                        height: 22,
                        width: 22,
                        margin: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        child: Image.asset(
                          "assets/images/iv_bell_appcolor.png",
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
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
            ? Form(
                key: _formKey,
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: SingleChildScrollView(
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
                          padding: const EdgeInsets.only(left: 1, right: 1),
                          child: InkWell(
                            onTap: () {},
                            child: CartMenu(
                              a: widget.analytics,
                              o: widget.observer,
                              fromPaymentScreen: true,
                              cartController: cartController,
                              homeScreenSetState: callbackHomescreenSetState,
                              callbackPaymentSetState: callbackPaymentSetState,
                            ),
                          ),
                        ),
                        // ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Messages",
                              style: TextStyle(
                                fontFamily: global.fontRailwayRegular,
                                fontWeight: FontWeight.w400,
                                fontSize: 19,
                                color: ColorConstants.newTextHeadingFooter,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Container(
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 10,
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
                            child: TextFormField(
                              maxLength: 250,
                              controller: selectedOccasionString,
                              maxLines: null,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w200,
                                  fontFamily: global.fontRailwayRegular,
                                  color: ColorConstants.pureBlack),
                              autofocus: false,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w200,
                                    fontFamily: fontRailwayRegular,
                                    color: ColorConstants.pureBlack),
                                //labelText: 'Message',
                                hintText: "Any special requests?",
                                filled: true,
                                fillColor: Colors.transparent,
                                contentPadding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
                                  bottom: 8.0,
                                ),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                              ),
                              onChanged: (value) {
                                print(selectedOccasionString.text);
                              },
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 8,
                        ),

                        screenId > 1
                            ? SizedBox()
                            : Container(
                                margin:
                                    EdgeInsets.only(left: 0, right: 0, top: 8),
                                decoration: BoxDecoration(
                                  color: ColorConstants.white,
                                ),
                                child: Visibility(
                                  visible: false,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 10, bottom: 10),
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
                                                  color:
                                                      ColorConstants.pureBlack,
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
                                                    color: ColorConstants
                                                        .appColor),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                textAlign: TextAlign.center,
                                                showCouponField
                                                    ? "Cancel"
                                                    : "APPLY",
                                                style: TextStyle(
                                                    color:
                                                        ColorConstants.appColor,
                                                    fontFamily: global
                                                        .fontRailwayRegular,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w200),
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

                        showCouponField
                            ? SizedBox(
                                height: 8,
                              )
                            : SizedBox(),
                        Visibility(
                            visible: true,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: ColorConstants.colorPageBackground,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.0)),
                                      border: Border.all(
                                        color: ColorConstants.appColor
                                            .withOpacity(0.5), // border color
                                        width: 0.3, // border width
                                      ),
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, top: 10),
                                        child: Column(
                                          children: [
                                            currentUser != null &&
                                                    currentUser.id != null
                                                ? !isCouponCodeVisible
                                                    ? Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10,
                                                                right: 10,
                                                                top: 10,
                                                                bottom: 10),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const Text(
                                                              "Coupons",
                                                              style: TextStyle(
                                                                fontFamily: global
                                                                    .fontRailwayRegular,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 19,
                                                                color: ColorConstants
                                                                    .newTextHeadingFooter,
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(
                                                                      NavigationUtils
                                                                          .createAnimatedRoute(
                                                                        1.0,
                                                                        CouponsScreen(
                                                                          a: widget
                                                                              .analytics,
                                                                          o: widget
                                                                              .observer,
                                                                          screenId:
                                                                              0,
                                                                          fromDrawer:
                                                                              false,
                                                                          screenIdO:
                                                                              screenId,
                                                                          cartId: cartController
                                                                              .cartItemsList
                                                                              .cartData!
                                                                              .cartProductdata![0]
                                                                              .storeId
                                                                              .toString(),
                                                                          total_delivery:
                                                                              global.total_delivery_count,
                                                                          cartController:
                                                                              cartController,
                                                                        ),
                                                                      ),
                                                                    )
                                                                    .then(
                                                                        (value) =>
                                                                            {
                                                                              setState(() {
                                                                                if (value != null) {
                                                                                  showCouponField = false;
                                                                                  boolCouponCodeError = false;
                                                                                  CouponCode couponCode = value;
                                                                                  double percentCalOfCoupon = 0;
                                                                                  couponDiscount = 0.0;

                                                                                  couponDiscount = couponCode != null ? couponCode.save_amount! : 0.0;
                                                                                  couponCodeStr = couponCode != null ? couponCode.coupon_code : "";
                                                                                  couponid = couponCode != null ? couponCode.coupon_id! : 0;
                                                                                  if (couponDiscount > 0) {
                                                                                    isCouponCodeVisible = true;
                                                                                    isDiscountCodeVisible = false;
                                                                                  } else {
                                                                                    isCouponCodeVisible = false;
                                                                                    isDiscountCodeVisible = true;
                                                                                  }
                                                                                  _isCOD = 0;

                                                                                  if ((addAmount - couponDiscount).toStringAsFixed(2) == "0.00" || (addAmount - couponDiscount).toStringAsFixed(2) == "-0.00" || (addAmount - couponDiscount).toStringAsFixed(2) == "0.0") {
                                                                                    isAlertVisible = false;
                                                                                  }
                                                                                }
                                                                              }),
                                                                              walletAppliedRemoved(),
                                                                            });
                                                                setState(() {});
                                                              },
                                                              child:
                                                                  Image.asset(
                                                                "assets/images/ic_coupon_black.png",
                                                                color: ColorConstants
                                                                    .newAppColor,
                                                                height: 35,
                                                                width: 35,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : SizedBox()
                                                : SizedBox(),

                                            // Apply Coupon Code Row (your existing code)

                                            currentUser != null &&
                                                    currentUser.id != null
                                                ? !isCouponCodeVisible
                                                    ? Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          // color: global.white,
                                                          color: ColorConstants
                                                              .colorPageBackground,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          7.0)),
                                                        ),
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5),
                                                        height: 40,
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  // color: global.white,
                                                                  color:
                                                                      ColorConstants
                                                                          .white,
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              7.0)),
                                                                ),
                                                                height: 40,
                                                                child:
                                                                    MyTextField(
                                                                  Key('21'),
                                                                  textCapitalization:
                                                                      TextCapitalization
                                                                          .characters,
                                                                  controller:
                                                                      _txtApplyCoupan,
                                                                  focusNode:
                                                                      _fCoupan,
                                                                  hintText:
                                                                      'Enter coupon code',
                                                                  maxLines: 1,
                                                                  onChanged:
                                                                      (p0) {
                                                                    if (p0.length >
                                                                        0) {
                                                                      boolCouponCodeError =
                                                                          false;
                                                                      setState(
                                                                          () {});
                                                                    }
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  onFieldSubmitted:
                                                                      (val) {},
                                                                  suffixIcon:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      _txtApplyCoupan
                                                                          .text = "";
                                                                    },
                                                                    child: Icon(
                                                                      Icons
                                                                          .cancel,
                                                                      size: 20,
                                                                      color: ColorConstants
                                                                          .newAppColor,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 5),
                                                            InkWell(
                                                              onTap: () async {
                                                                if (_txtApplyCoupan
                                                                    .text
                                                                    .isNotEmpty) {
                                                                  boolCouponCodeError =
                                                                      false;
                                                                  setState(
                                                                      () {});
                                                                  await _applyCoupon(
                                                                      _txtApplyCoupan
                                                                          .text);
                                                                } else {
                                                                  _fCoupan
                                                                      .requestFocus();
                                                                  boolCouponCodeError =
                                                                      true;
                                                                  strCouponCodeError =
                                                                      'Please enter coupon code';
                                                                  setState(
                                                                      () {});
                                                                }
                                                              },
                                                              child: Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    4.2,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            8,
                                                                        vertical:
                                                                            12),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: ColorConstants
                                                                      .appColor
                                                                      .withOpacity(
                                                                          0.5),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5)),
                                                                ),
                                                                child: Text(
                                                                  "APPLY",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        fontMontserratMedium,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        14,
                                                                    color: ColorConstants
                                                                        .white,
                                                                    letterSpacing:
                                                                        1,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : SizedBox()
                                                : SizedBox(),
                                            Visibility(
                                              visible: isCouponCodeVisible,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 0,
                                                      right: 0,
                                                      top: 10),
                                                  decoration: BoxDecoration(
                                                    color: ColorConstants.white,
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(20, 8, 20, 8),
                                                    child: Row(
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Text(
                                                              "'${couponCodeStr}'applied\n ${couponDiscount.toStringAsFixed(2)} AED Coupon Savings",
                                                              style: TextStyle(
                                                                  color: ColorConstants
                                                                      .pureBlack,
                                                                  fontFamily: global
                                                                      .fontOufitMedium,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w200),
                                                            ),
                                                          ],
                                                        ),
                                                        Expanded(
                                                            child: Text('')),
                                                        InkWell(
                                                          onTap: () {
                                                            isCouponCodeVisible =
                                                                false;
                                                            showCouponField =
                                                                false;
                                                            couponDiscount =
                                                                0.0;
                                                            couponCodeStr = "";

                                                            isDiscountCodeVisible =
                                                                true;
                                                            var tamount =
                                                                totalAmount -
                                                                    couponDiscount;
                                                            walletAppliedRemoved();

                                                            if ((addAmount -
                                                                            couponDiscount)
                                                                        .toStringAsFixed(
                                                                            2) ==
                                                                    "0.00" ||
                                                                (addAmount -
                                                                            couponDiscount)
                                                                        .toStringAsFixed(
                                                                            2) ==
                                                                    "-0.00" ||
                                                                (addAmount -
                                                                            couponDiscount)
                                                                        .toStringAsFixed(
                                                                            2) ==
                                                                    "0.0") {
                                                              isAlertVisible =
                                                                  false;
                                                            } else {
                                                              isAlertVisible =
                                                                  true;
                                                            }

                                                            setState(() {});
                                                          },
                                                          child: Text("Remove",
                                                              style: TextStyle(
                                                                  color: ColorConstants
                                                                      .newAppColor,
                                                                  fontFamily: global
                                                                      .fontRailwayRegular,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w200)),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            //UI DESIGN COUPON CODE

                                            // Padding(
                                            //   padding: const EdgeInsets.only(
                                            //       top: 10),
                                            //   child: GridView.builder(
                                            //     padding:
                                            //         const EdgeInsets.symmetric(
                                            //             horizontal: 12,
                                            //             vertical: 8),
                                            //     shrinkWrap: true,
                                            //     physics:
                                            //         const NeverScrollableScrollPhysics(),
                                            //     itemCount: 5,
                                            //     gridDelegate:
                                            //         const SliverGridDelegateWithFixedCrossAxisCount(
                                            //       crossAxisCount:
                                            //           3, // 3 coupons horizontally
                                            //       crossAxisSpacing:
                                            //           10, // space between columns
                                            //       mainAxisSpacing:
                                            //           10, // space between rows
                                            //       childAspectRatio:
                                            //           1.9, // decrease value to increase height, increase value to reduce height
                                            //     ),
                                            //     itemBuilder: (context, index) {
                                            //       return Container(
                                            //         padding: const EdgeInsets
                                            //             .symmetric(
                                            //             horizontal: 8,
                                            //             vertical: 8),
                                            //         decoration: BoxDecoration(
                                            //           color:
                                            //               ColorConstants.white,
                                            //           borderRadius:
                                            //               BorderRadius.circular(
                                            //                   10),
                                            //           border: Border.all(
                                            //             color: Color.fromARGB(
                                            //                 255, 232, 228, 228),
                                            //             width: 0.8,
                                            //           ),
                                            //         ),
                                            //         child: Column(
                                            //           mainAxisAlignment:
                                            //               MainAxisAlignment
                                            //                   .center,
                                            //           children: [
                                            //             Text(
                                            //               "Flat 20% Off",
                                            //               style: TextStyle(
                                            //                 fontSize: 12,
                                            //                 fontWeight:
                                            //                     FontWeight.w600,
                                            //                 color: Color(
                                            //                     0xFF8B4513),
                                            //               ),
                                            //               textAlign:
                                            //                   TextAlign.center,
                                            //             ),
                                            //             const SizedBox(
                                            //                 height: 4),
                                            //             Text(
                                            //               "Expiry Date: 2026-01-01",
                                            //               style: TextStyle(
                                            //                 fontSize: 10,
                                            //                 fontWeight:
                                            //                     FontWeight.w300,
                                            //                 color:
                                            //                     Colors.black54,
                                            //               ),
                                            //               textAlign:
                                            //                   TextAlign.center,
                                            //             ),
                                            //           ],
                                            //         ),
                                            //       );
                                            //     },
                                            //   ),
                                            // ),

                                            //Coupon Discount is valid only for Card Payments
                                            SizedBox(
                                              height: currentUser != null &&
                                                      currentUser.id != null
                                                  ? 10
                                                  : 0,
                                            ),
                                            currentUser != null &&
                                                    currentUser.id != null
                                                ? Container(
                                                    // margin: EdgeInsets.only(left: 10),
                                                    child: CheckboxListTile(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      activeColor:
                                                          ColorConstants
                                                              .appColor,
                                                      title:
                                                          Transform.translate(
                                                        offset: const Offset(
                                                            -10, 0),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
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
                                                                    style:
                                                                        TextStyle(
                                                                      color: ColorConstants
                                                                          .pureBlack,
                                                                      fontSize:
                                                                          15,
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
                                                                  child:
                                                                      Container(
                                                                          child:
                                                                              Row(
                                                                    children: [
                                                                      RichText(
                                                                        text:
                                                                            TextSpan(
                                                                          text:
                                                                              'Available Balance: ',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                ColorConstants.grey,
                                                                            fontSize:
                                                                                14,
                                                                            fontFamily:
                                                                                fontRailwayRegular,
                                                                            fontWeight:
                                                                                FontWeight.w200,
                                                                          ),
                                                                          children: <TextSpan>[
                                                                            TextSpan(
                                                                                text: totalWalletbalance > 0 ? 'AED ${totalWalletbalance.toStringAsFixed(2)}' : 'AED ${totalWalletAmount.toStringAsFixed(2)}',
                                                                                style: TextStyle(
                                                                                  color: ColorConstants.green,
                                                                                  fontSize: 14,
                                                                                  fontFamily: global.fontOufitMedium,
                                                                                  fontWeight: FontWeight.bold,
                                                                                )),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                    ],
                                                                  )),
                                                                ),
                                                              ],
                                                            ),
                                                            Expanded(
                                                                child:
                                                                    Text("")),
                                                            Image.asset(
                                                              "assets/images/wallet_red.png",
                                                              color: ColorConstants
                                                                  .newAppColor,
                                                              height: 35,
                                                              width: 35,
                                                            ),
                                                            SizedBox(),
                                                          ],
                                                        ),
                                                      ),
                                                      value: isWalletSelected,
                                                      onChanged: (newValue) {
                                                        if (totalWalletAmount >
                                                            0.0) {
                                                          if (totalOrderPrice >
                                                              0.0) {
                                                            totalWalletSpendings =
                                                                0.0;
                                                            totalOrderPrice = double.parse(cartController
                                                                    .cartItemsList
                                                                    .cartData!
                                                                    .totalPrice
                                                                    .toString()) -
                                                                couponDiscount;
                                                            isWalletSelected =
                                                                newValue!;
                                                            if (!isWalletSelected) {
                                                              boolWalletAmountError =
                                                                  false;
                                                              _txtWalletAmount
                                                                  .text = "";
                                                              totalWalletbalance =
                                                                  global.appInfo
                                                                      .userwallet!;
                                                            }
                                                            setState(() {});
                                                          } else {
                                                            boolWalletAmountError =
                                                                true;
                                                            strWalletAmountError =
                                                                "You cannot use the wallet for an order with zero price due to the applied coupon.";
                                                            setState(() {});
                                                          }
                                                        }
                                                      },
                                                      controlAffinity:
                                                          ListTileControlAffinity
                                                              .leading, //  <-- leading Checkbox
                                                    ),
                                                  )
                                                : Container(),

                                            Visibility(
                                              visible: isWalletSelected &&
                                                  totalWalletSpendings == 0.0,
                                              child: Container(
                                                height: 45,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                    padding: EdgeInsets.only(
                                                        left: 5),
                                                    height: 5,
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                            height: 40,
                                                            child: Container(
                                                              color: Colors
                                                                  .white, // White background
                                                              child:
                                                                  MyTextField(
                                                                Key('21'),
                                                                keyboardType: TextInputType
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
                                                                suffixIcon:
                                                                    InkWell(
                                                                  onTap: () {
                                                                    _txtWalletAmount
                                                                        .text = "";
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .cancel,
                                                                    size: 20,
                                                                    color: ColorConstants
                                                                        .newAppColor,
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
                                                                totalOrderPrice = double.parse(cartController
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
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    5),
                                                              ),
                                                              border: Border.all(
                                                                  width: 0.5,
                                                                  color: ColorConstants
                                                                      .appColor),
                                                            ),
                                                            child: Container(
                                                              child: Text(
                                                                "USE",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        fontMontserratMedium,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        11,
                                                                    color: ColorConstants
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          right: 8.0),
                                                  child: Text(
                                                    strWalletAmountError,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            fontMontserratMedium,
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        fontSize: 10,
                                                        color: ColorConstants
                                                            .appColor,
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
                                                  margin: EdgeInsets.only(
                                                      bottom: 10),
                                                  child: Row(
                                                    children: [
                                                      RichText(
                                                        text: TextSpan(
                                                          text:
                                                              'Available Balance :- ',
                                                          style: TextStyle(
                                                            color:
                                                                ColorConstants
                                                                    .grey,
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
                                                                style:
                                                                    TextStyle(
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

                                            // spacing before price details

                                            // Price Details Section (Subtotal, Delivery Fee, Coupon Discount, Total)
                                            Container(
                                              decoration: BoxDecoration(
                                                color: ColorConstants
                                                    .colorPageBackground,
                                              ),
                                              padding: EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              child: Column(
                                                children: [
                                                  // Subtotal
                                                  totalOrderPrice ==
                                                          cartItemPrice
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
                                                                  color: ColorConstants
                                                                      .newTextHeadingFooter),
                                                            ),
                                                            Text(
                                                              "AED ${cartItemPrice!.toStringAsFixed(2)}",
                                                              style: TextStyle(
                                                                  fontFamily: global
                                                                      .fontOufitMedium,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      priceDetailsLValueFontSize,
                                                                  color: ColorConstants
                                                                      .pureBlack),
                                                            ),
                                                          ],
                                                        ),
                                                  (cartController
                                                                  .cartItemsList
                                                                  .cartData!
                                                                  .deliveryCharge !=
                                                              null &&
                                                          cartController
                                                                  .cartItemsList
                                                                  .cartData!
                                                                  .deliveryCharge! >
                                                              0.0)
                                                      ? SizedBox(height: 8)
                                                      : SizedBox(),

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
                                                                  fontOufitMedium,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize:
                                                                  priceDetailsLabelFontSize,
                                                              color: ColorConstants
                                                                  .newTextHeadingFooter),
                                                        ),
                                                        Text(
                                                          cartController
                                                                      .cartItemsList
                                                                      .cartData!
                                                                      .deliveryCharge ==
                                                                  0.0
                                                              ? "AED ${(cartController.cartItemsList.cartData!.deliverychargediscount!.toStringAsFixed(2))}"
                                                              : "AED ${(cartController.cartItemsList.cartData!.deliveryCharge!.toStringAsFixed(2))}",
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
                                                  ),
                                                  (cartController
                                                                  .cartItemsList
                                                                  .cartData!
                                                                  .deliveryCharge !=
                                                              null &&
                                                          cartController
                                                                  .cartItemsList
                                                                  .cartData!
                                                                  .deliveryCharge! >
                                                              0.0)
                                                      ? SizedBox(height: 5)
                                                      : SizedBox(),
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
                                                                    fontFamily:
                                                                        global
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
                                                              "AED ${couponDiscount.toStringAsFixed(2)}",
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
                                                  couponCodeStr != null &&
                                                          couponCodeStr!
                                                              .isNotEmpty
                                                      ? SizedBox(height: 5)
                                                      : SizedBox(),

                                                  isWalletSelected &&
                                                          totalWalletSpendings >
                                                              0.0
                                                      ? SizedBox(height: 5)
                                                      : SizedBox(),
                                                  // Wallet Amount
                                                  isWalletSelected &&
                                                          totalWalletSpendings >
                                                              0.0
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
                                                                  color: ColorConstants
                                                                      .pureBlack),
                                                            ),
                                                            Text(
                                                              "AED ${totalWalletSpendings.toStringAsFixed(2)}",
                                                              style: TextStyle(
                                                                  fontFamily: global
                                                                      .fontOufitMedium,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      priceDetailsLValueFontSize,
                                                                  color: ColorConstants
                                                                      .appColor),
                                                            ),
                                                          ],
                                                        )
                                                      : SizedBox(),
                                                  // SizedBox(height: 8),
                                                  isWalletSelected &&
                                                          totalWalletSpendings >
                                                              0.0
                                                      ? SizedBox(height: 5)
                                                      : SizedBox(),
                                                  !isWalletSelected &&
                                                              totalWalletSpendings ==
                                                                  0.0 &&
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
                                                      : SizedBox(
                                                          height: 5,
                                                        ),
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
                                                                  color: ColorConstants
                                                                      .pureBlack),
                                                            ),
                                                            Text(
                                                              "AED ${(cartController.cartItemsList.cartData!.deliverychargediscount!.toStringAsFixed(2))}",
                                                              style: TextStyle(
                                                                  fontFamily: global
                                                                      .fontOufitMedium,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      priceDetailsLValueFontSize,
                                                                  color: ColorConstants
                                                                      .pureBlack),
                                                            ),
                                                          ],
                                                        ),

                                                  // Divider(
                                                  //   color: ColorConstants
                                                  //       .appfaintColor,
                                                  //   thickness: 1,
                                                  // ),
                                                  // SizedBox(height: 4),

                                                  // Total Amount
                                                  Container(
                                                    margin:
                                                        EdgeInsets.only(top: 5),
                                                    child: Row(
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
                                                                  FontWeight
                                                                      .w300,
                                                              fontSize:
                                                                  priceDetailsLabelFontSize,
                                                              color:
                                                                  ColorConstants
                                                                      .pureBlack),
                                                        ),
                                                        Text(
                                                          "AED ${(totalOrderPrice).toStringAsFixed(2)}",
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

                        // Visibility(
                        //     visible: !isCouponCodeVisible,
                        //     child: Container(
                        //       padding: const EdgeInsets.only(
                        //         left: 10,
                        //         right: 10,
                        //       ),
                        //       width: MediaQuery.of(context).size.width,
                        //       color: ColorConstants.colorPageBackground,
                        //       child: InkWell(
                        //         onTap: () {
                        //           Navigator.of(context)
                        //               .push(
                        //                 NavigationUtils.createAnimatedRoute(
                        //                   1.0,
                        //                   CouponsScreen(
                        //                     a: widget.analytics,
                        //                     o: widget.observer,
                        //                     screenId: 0,
                        //                     fromDrawer: false,
                        //                     screenIdO: screenId,
                        //                     cartId: cartController
                        //                         .cartItemsList
                        //                         .cartData!
                        //                         .cartProductdata![0]
                        //                         .storeId
                        //                         .toString(),
                        //                     total_delivery:
                        //                         global.total_delivery_count,
                        //                     cartController: cartController,
                        //                   ),
                        //                 ),
                        //               )
                        //               .then((value) => {
                        //                     setState(() {
                        //                       if (value != null) {
                        //                         showCouponField = false;
                        //                         boolCouponCodeError = false;
                        //                         CouponCode couponCode = value;
                        //                         double percentCalOfCoupon = 0;
                        //                         couponDiscount = 0.0;

                        //                         couponDiscount = couponCode != null
                        //                             ? couponCode.save_amount!
                        //                             : 0.0;
                        //                         couponCodeStr = couponCode != null
                        //                             ? couponCode.coupon_code
                        //                             : "";
                        //                         couponid = couponCode != null
                        //                             ? couponCode.coupon_id!
                        //                             : 0;
                        //                         if (couponDiscount > 0) {
                        //                           isCouponCodeVisible = true;
                        //                           isDiscountCodeVisible = false;
                        //                         } else {
                        //                           isCouponCodeVisible = false;
                        //                           isDiscountCodeVisible = true;
                        //                         }
                        //                         _isCOD = 0;
                        //                         selectedPaymentType = "Wallet";

                        //                         if ((addAmount - couponDiscount)
                        //                                     .toStringAsFixed(2) ==
                        //                                 "0.00" ||
                        //                             (addAmount - couponDiscount)
                        //                                     .toStringAsFixed(2) ==
                        //                                 "-0.00" ||
                        //                             (addAmount - couponDiscount)
                        //                                     .toStringAsFixed(2) ==
                        //                                 "0.0") {
                        //                           isAlertVisible = false;
                        //                         }
                        //                       }
                        //                     }),
                        //                     walletAppliedRemoved(),
                        //                   });
                        //           setState(() {});
                        //         },
                        //         child: Container(
                        //           width: MediaQuery.of(context).size.width,
                        //           padding: EdgeInsets.only(
                        //               top: 8, bottom: 8, left: 5, right: 5),
                        //           // child: Text(
                        //           //   "View Coupons",
                        //           //   textAlign: TextAlign.start,
                        //           //   style: TextStyle(
                        //           //     fontFamily: fontRailwayRegular,
                        //           //     color: ColorConstants.appColor,
                        //           //     fontWeight: FontWeight.w600,
                        //           //     fontSize: 11,
                        //           //   ),
                        //           // ),
                        //         ),
                        //       ),
                        //     )),

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

                        // 🔸 Delivery Address Section
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
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
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: Column(
                            children: [
                              global.currentUser.id == null
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              10), // 👈 Added left & right padding
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // 🔸 Contact Section
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start, // ✅ left align if needed
                                                      children: [
                                                        Text(
                                                          "Sender Details",
                                                          style: TextStyle(
                                                            fontFamily: global
                                                                .fontRailwayRegular,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 19,
                                                            color: ColorConstants
                                                                .newTextHeadingFooter,
                                                          ),
                                                        ),

                                                        SizedBox(
                                                            height:
                                                                3), // spacing between the two texts

                                                        Text(
                                                          "(Order as a Guest)",
                                                          style: TextStyle(
                                                            fontFamily: global
                                                                .fontRailwayRegular,
                                                            fontWeight:
                                                                FontWeight.w200,
                                                            fontSize: 12,
                                                            color: ColorConstants
                                                                .newAppColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                        width:
                                                            5), // spacing between texts
                                                  ],
                                                ),
                                                OutlinedButton.icon(
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              LoginScreen(
                                                                a: widget
                                                                    .analytics,
                                                                o: widget
                                                                    .observer,
                                                              )),
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.login,
                                                    size: 16,
                                                    color: Colors.white,
                                                  ),
                                                  label: const Text(
                                                    "SIGN IN",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: global
                                                          .fontRalewayMedium,
                                                    ),
                                                  ),
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFF8B4B2C),
                                                    foregroundColor:
                                                        Colors.white,
                                                    side: const BorderSide(
                                                        color:
                                                            Color(0xFFFFFFFF)),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12,
                                                        vertical: 6),
                                                    textStyle: const TextStyle(
                                                        fontSize: 12),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24),
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
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: ColorConstants.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              7.0))),
                                              padding: EdgeInsets.only(),
                                              child: MaterialTextField(
                                                style: TextStyle(
                                                    fontFamily: global
                                                        .fontRailwayRegular,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w200,
                                                    color: ColorConstants
                                                        .pureBlack),
                                                theme:
                                                    FilledOrOutlinedTextTheme(
                                                  radius: 8,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 4,
                                                          vertical: 4),
                                                  errorStyle: const TextStyle(
                                                      fontSize: 10,
                                                      fontFamily: global
                                                          .fontRailwayRegular,
                                                      fontWeight:
                                                          FontWeight.w200),
                                                  fillColor: Colors.transparent,
                                                  enabledColor: Colors.grey,
                                                  focusedColor:
                                                      ColorConstants.appColor,
                                                  floatingLabelStyle:
                                                      const TextStyle(
                                                          color: ColorConstants
                                                              .appColor),
                                                  width: 0.5,
                                                  labelStyle: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey),
                                                ),
                                                controller: _cName,
                                                labelText: "Full Name*",
                                                keyboardType:
                                                    TextInputType.name,
                                                onChanged: (val) {
                                                  String filtered =
                                                      val.replaceAll(
                                                          RegExp(
                                                              r'[^a-zA-Z\s]'),
                                                          '');
                                                  if (filtered != val) {
                                                    _cName.text = filtered;
                                                    _cName.selection =
                                                        TextSelection
                                                            .fromPosition(
                                                      TextPosition(
                                                          offset:
                                                              filtered.length),
                                                    );
                                                  }
                                                  if (onProceedClicked &&
                                                      _formKey.currentState!
                                                          .validate()) {
                                                    print("Submit Data");
                                                  }
                                                },
                                                validator: (value) {
                                                  print(value);
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Please enter your Full Name";
                                                  } else if (!RegExp(
                                                          r"^[a-zA-Z\s]+$")
                                                      .hasMatch(value)) {
                                                    return "Only alphabets are allowed";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: ColorConstants.white,
                                                  borderRadius:
                                                      BorderRadius.circular(7)),
                                              child: MaterialTextField(
                                                style: TextStyle(
                                                    fontFamily: global
                                                        .fontRailwayRegular,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w200,
                                                    color: ColorConstants
                                                        .pureBlack),
                                                theme:
                                                    FilledOrOutlinedTextTheme(
                                                  radius: 8,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 4,
                                                          vertical: 4),
                                                  errorStyle: const TextStyle(
                                                      fontSize: 10,
                                                      fontFamily: global
                                                          .fontRailwayRegular,
                                                      fontWeight:
                                                          FontWeight.w200),
                                                  fillColor: Colors.transparent,
                                                  enabledColor: Colors.grey,
                                                  focusedColor:
                                                      ColorConstants.appColor,
                                                  floatingLabelStyle:
                                                      const TextStyle(
                                                          color: ColorConstants
                                                              .appColor),
                                                  width: 0.5,
                                                  labelStyle: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey),
                                                ),
                                                controller: _cEmail,
                                                labelText: "Email*",
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                onChanged: (val) {
                                                  if (onProceedClicked &&
                                                      _formKey.currentState!
                                                          .validate()) {
                                                    print("Submit Data");
                                                  }
                                                },
                                                validator: (value) {
                                                  print(
                                                      "this is value ${value}");
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Please enter your Email";
                                                  } else if (!EmailValidator
                                                      .validate(value)) {
                                                    return "Please enter valid Email";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: 0,
                                                right: 0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      showCountryPicker(
                                                        countryListTheme:
                                                            CountryListThemeData(
                                                                inputDecoration:
                                                                    InputDecoration(
                                                                        hintText:
                                                                            "",
                                                                        label:
                                                                            Text(
                                                                          "Search",
                                                                          style: TextStyle(
                                                                              fontSize: 16,
                                                                              fontFamily: fontRailwayRegular,
                                                                              color: ColorConstants.appColor),
                                                                        )),
                                                                searchTextStyle:
                                                                    TextStyle(
                                                                        color: ColorConstants
                                                                            .pureBlack),
                                                                textStyle: TextStyle(
                                                                    fontFamily:
                                                                        fontRailwayRegular,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w200,
                                                                    fontSize:
                                                                        16,
                                                                    color: ColorConstants
                                                                        .pureBlack,
                                                                    letterSpacing:
                                                                        1)),
                                                        context: context,
                                                        showPhoneCode:
                                                            true, // optional. Shows phone code before the country name.
                                                        onSelect:
                                                            (Country country) {
                                                          print(
                                                              'Select country: ${country.displayName} & ${country.countryCode} & ${country.flagEmoji}');
                                                          countryCode =
                                                              country.phoneCode;
                                                          countryCodeFlg =
                                                              "${country.flagEmoji}";
                                                          countryCodeSelected =
                                                              country.phoneCode;
                                                          _phonenumMaxLength1 =
                                                              country.example
                                                                  .length;

                                                          setState(() {
                                                            _cPhone.text = "";
                                                          });
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      width: 125,
                                                      margin: EdgeInsets.only(
                                                          bottom: mobileValid
                                                              ? 0
                                                              : 20),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors
                                                                .grey.shade300,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          7.0))),
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  5, 1, 0, 0),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                  countryCodeFlg!,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          fontMontserratMedium,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          25,
                                                                      color: ColorConstants
                                                                          .pureBlack,
                                                                      letterSpacing:
                                                                          1)),
                                                              Expanded(
                                                                  child: Text(
                                                                      countryCodeSelected!,
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              fontRailwayRegular,
                                                                          fontWeight: FontWeight
                                                                              .w200,
                                                                          fontSize:
                                                                              16,
                                                                          color: ColorConstants
                                                                              .pureBlack,
                                                                          letterSpacing:
                                                                              1))),
                                                              Icon(
                                                                Icons
                                                                    .arrow_drop_down,
                                                                size: 30,
                                                                color: global
                                                                    .bgCompletedColor,
                                                              )
                                                            ],
                                                          )),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      height:
                                                          mobileValid ? 40 : 60,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          0.0))),
                                                      margin: EdgeInsets.only(
                                                          left: 8,
                                                          right: 1,
                                                          top: 10,
                                                          bottom: 10),
                                                      padding:
                                                          EdgeInsets.only(),
                                                      child: TextFormField(
                                                        inputFormatters: <TextInputFormatter>[
                                                          FilteringTextInputFormatter
                                                              .digitsOnly
                                                        ],
                                                        key: Key('1'),
                                                        cursorColor:
                                                            Colors.black,
                                                        controller: _cPhone,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontFamily:
                                                                fontRailwayRegular,
                                                            fontWeight:
                                                                FontWeight.w200,
                                                            color:
                                                                ColorConstants
                                                                    .pureBlack,
                                                            letterSpacing: 1),
                                                        keyboardType:
                                                            TextInputType.phone,
                                                        maxLength:
                                                            _phonenumMaxLength1 ==
                                                                    0
                                                                ? 9
                                                                : _phonenumMaxLength1,
                                                        focusNode: _fPhone,
                                                        onFieldSubmitted:
                                                            (val) {
                                                          FocusScope.of(context)
                                                              .requestFocus(
                                                                  _fPhone);
                                                        },
                                                        obscuringCharacter: '*',
                                                        decoration:
                                                            InputDecoration(
                                                                counterText: "",
                                                                border:
                                                                    OutlineInputBorder(),
                                                                labelStyle: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        fontRailwayRegular,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w200,
                                                                    color: _fPhone.hasFocus ==
                                                                            true
                                                                        ? ColorConstants
                                                                            .appColor
                                                                        : ColorConstants
                                                                            .grey),
                                                                labelText:
                                                                    "Mobile Number*",
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              7),
                                                                  borderSide: BorderSide(
                                                                      color: _fPhone.hasFocus ==
                                                                              true
                                                                          ? ColorConstants
                                                                              .appColor
                                                                          : ColorConstants
                                                                              .grey,
                                                                      width:
                                                                          0.0),
                                                                ),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              7),
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade400,
                                                                      width:
                                                                          0.0),
                                                                ),
                                                                hintText:
                                                                    '561234567',
                                                                errorStyle: const TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontFamily:
                                                                        global
                                                                            .fontRailwayRegular,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w200),
                                                                hintStyle: TextStyle(
                                                                    fontFamily:
                                                                        fontRailwayRegular,
                                                                    fontSize:
                                                                        14)),
                                                        onChanged: (val) {
                                                          if (onProceedClicked &&
                                                              _formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                            print(
                                                                "Submit Data");
                                                          }
                                                        },
                                                        validator: (value) {
                                                          print(value);
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            mobileValid = false;
                                                            setState(() {});
                                                            return "Please enter your mobile number";
                                                          } else if (_cPhone
                                                                  .text
                                                                  .isNotEmpty &&
                                                              _phonenumMaxLength1 ==
                                                                  0 &&
                                                              _cPhone.text
                                                                      .length <
                                                                  9) {
                                                            mobileValid = false;
                                                            setState(() {});
                                                            return "Please enter valid mobile number";
                                                          } else if (_phonenumMaxLength1 >
                                                                  0 &&
                                                              _cPhone.text
                                                                      .length <
                                                                  _phonenumMaxLength1) {
                                                            mobileValid = false;
                                                            setState(() {});
                                                            return "Please enter valid mobile number";
                                                          } else {
                                                            mobileValid = true;
                                                            setState(() {});
                                                            return null;
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]))
                                  : Container(),
                              currentUser == null && currentUser.id == null
                                  ? SizedBox(height: 25)
                                  : SizedBox(),
                              global.currentUser.id != null &&
                                      global.currentUser.userPhone == null
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              10), // 👈 Added left & right padding
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // 🔸 Contact Section
                                            const Text(
                                              "Sender Details",
                                              style: TextStyle(
                                                color: ColorConstants
                                                    .newTextHeadingFooter,
                                                fontFamily:
                                                    global.fontOufitMedium,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),

                                            const Divider(
                                              color: Color(0xFFE0E0E0),
                                              thickness: 1,
                                            ),
                                            SizedBox(height: 10),
                                            Visibility(
                                              visible: global.currentUser.id !=
                                                      null &&
                                                  global.currentUser.name ==
                                                      null,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: ColorConstants.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                7.0))),
                                                padding: EdgeInsets.only(),
                                                child: MaterialTextField(
                                                  style: TextStyle(
                                                      fontFamily: global
                                                          .fontRailwayRegular,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w200,
                                                      color: ColorConstants
                                                          .pureBlack),
                                                  theme:
                                                      FilledOrOutlinedTextTheme(
                                                    radius: 8,
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 4,
                                                            vertical: 4),
                                                    errorStyle: const TextStyle(
                                                        fontSize: 10,
                                                        fontFamily: global
                                                            .fontRailwayRegular,
                                                        fontWeight:
                                                            FontWeight.w200),
                                                    fillColor:
                                                        Colors.transparent,
                                                    enabledColor: Colors.grey,
                                                    focusedColor:
                                                        ColorConstants.appColor,
                                                    floatingLabelStyle:
                                                        const TextStyle(
                                                            color:
                                                                ColorConstants
                                                                    .appColor),
                                                    width: 0.5,
                                                    labelStyle: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey),
                                                  ),
                                                  controller: _cName,
                                                  labelText: "Full Name*",
                                                  keyboardType:
                                                      TextInputType.name,
                                                  onChanged: (val) {
                                                    String filtered =
                                                        val.replaceAll(
                                                            RegExp(
                                                                r'[^a-zA-Z\s]'),
                                                            '');
                                                    if (filtered != val) {
                                                      _cName.text = filtered;
                                                      _cName.selection =
                                                          TextSelection
                                                              .fromPosition(
                                                        TextPosition(
                                                            offset: filtered
                                                                .length),
                                                      );
                                                    }
                                                    if (onProceedClicked &&
                                                        _formKey.currentState!
                                                            .validate()) {
                                                      print("Submit Data");
                                                    }
                                                  },
                                                  validator: (value) {
                                                    print(value);
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return "Please enter your Full Name";
                                                    } else if (!RegExp(
                                                            r"^[a-zA-Z\s]+$")
                                                        .hasMatch(value)) {
                                                      return "Only alphabets are allowed";
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),

                                            global.currentUser.id != null &&
                                                    global.currentUser.name ==
                                                        null
                                                ? SizedBox(height: 10)
                                                : SizedBox(),

                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: 0,
                                                right: 0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      showCountryPicker(
                                                        countryListTheme:
                                                            CountryListThemeData(
                                                                inputDecoration:
                                                                    InputDecoration(
                                                                        hintText:
                                                                            "",
                                                                        label:
                                                                            Text(
                                                                          "Search",
                                                                          style: TextStyle(
                                                                              fontSize: 16,
                                                                              fontFamily: fontRailwayRegular,
                                                                              color: ColorConstants.appColor),
                                                                        )),
                                                                searchTextStyle:
                                                                    TextStyle(
                                                                        color: ColorConstants
                                                                            .pureBlack),
                                                                textStyle: TextStyle(
                                                                    fontFamily:
                                                                        fontRailwayRegular,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w200,
                                                                    fontSize:
                                                                        16,
                                                                    color: ColorConstants
                                                                        .pureBlack,
                                                                    letterSpacing:
                                                                        1)),
                                                        context: context,
                                                        showPhoneCode:
                                                            true, // optional. Shows phone code before the country name.
                                                        onSelect:
                                                            (Country country) {
                                                          print(
                                                              'Select country: ${country.displayName} & ${country.countryCode} & ${country.flagEmoji}');
                                                          countryCode =
                                                              country.phoneCode;
                                                          countryCodeFlg =
                                                              "${country.flagEmoji}";
                                                          countryCodeSelected =
                                                              country.phoneCode;
                                                          _phonenumMaxLength1 =
                                                              country.example
                                                                  .length;

                                                          setState(() {
                                                            _cPhone.text = "";
                                                          });
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      width: 125,
                                                      margin: EdgeInsets.only(
                                                          bottom: mobileValid
                                                              ? 0
                                                              : 20),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors
                                                                .grey.shade300,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          7.0))),
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  5, 1, 0, 0),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                  countryCodeFlg!,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          fontMontserratMedium,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          25,
                                                                      color: ColorConstants
                                                                          .pureBlack,
                                                                      letterSpacing:
                                                                          1)),
                                                              Expanded(
                                                                  child: Text(
                                                                      countryCodeSelected!,
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              fontRailwayRegular,
                                                                          fontWeight: FontWeight
                                                                              .w200,
                                                                          fontSize:
                                                                              16,
                                                                          color: ColorConstants
                                                                              .pureBlack,
                                                                          letterSpacing:
                                                                              1))),
                                                              Icon(
                                                                Icons
                                                                    .arrow_drop_down,
                                                                size: 30,
                                                                color: global
                                                                    .bgCompletedColor,
                                                              )
                                                            ],
                                                          )),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      height:
                                                          mobileValid ? 40 : 60,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          0.0))),
                                                      margin: EdgeInsets.only(
                                                          left: 8,
                                                          right: 1,
                                                          top: 10,
                                                          bottom: 10),
                                                      padding:
                                                          EdgeInsets.only(),
                                                      child: TextFormField(
                                                        inputFormatters: <TextInputFormatter>[
                                                          FilteringTextInputFormatter
                                                              .digitsOnly
                                                        ],
                                                        key: Key('1'),
                                                        cursorColor:
                                                            Colors.black,
                                                        controller: _cPhone,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontFamily:
                                                                fontRailwayRegular,
                                                            fontWeight:
                                                                FontWeight.w200,
                                                            color:
                                                                ColorConstants
                                                                    .pureBlack,
                                                            letterSpacing: 1),
                                                        keyboardType:
                                                            TextInputType.phone,
                                                        maxLength:
                                                            _phonenumMaxLength1 ==
                                                                    0
                                                                ? 9
                                                                : _phonenumMaxLength1,
                                                        focusNode: _fPhone,
                                                        onFieldSubmitted:
                                                            (val) {
                                                          FocusScope.of(context)
                                                              .requestFocus(
                                                                  _fPhone);
                                                        },
                                                        obscuringCharacter: '*',
                                                        decoration:
                                                            InputDecoration(
                                                                counterText: "",
                                                                border:
                                                                    OutlineInputBorder(),
                                                                labelStyle: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        fontRailwayRegular,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w200,
                                                                    color: _fPhone.hasFocus ==
                                                                            true
                                                                        ? ColorConstants
                                                                            .appColor
                                                                        : ColorConstants
                                                                            .grey),
                                                                labelText:
                                                                    "Mobile Number*",
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              7),
                                                                  borderSide: BorderSide(
                                                                      color: _fPhone.hasFocus ==
                                                                              true
                                                                          ? ColorConstants
                                                                              .appColor
                                                                          : ColorConstants
                                                                              .grey,
                                                                      width:
                                                                          0.0),
                                                                ),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              7),
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade400,
                                                                      width:
                                                                          0.0),
                                                                ),
                                                                hintText:
                                                                    '561234567',
                                                                errorStyle: const TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontFamily:
                                                                        global
                                                                            .fontRailwayRegular,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w200),
                                                                hintStyle: TextStyle(
                                                                    fontFamily:
                                                                        fontRailwayRegular,
                                                                    fontSize:
                                                                        14)),
                                                        onChanged: (val) {
                                                          if (onProceedClicked &&
                                                              _formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                            print(
                                                                "Submit Data");
                                                          }
                                                        },
                                                        validator: (value) {
                                                          print(value);
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            mobileValid = false;
                                                            setState(() {});
                                                            return "Please enter your mobile number";
                                                          } else if (_cPhone
                                                                  .text
                                                                  .isNotEmpty &&
                                                              _phonenumMaxLength1 ==
                                                                  0 &&
                                                              _cPhone.text
                                                                      .length <
                                                                  9) {
                                                            mobileValid = false;
                                                            setState(() {});
                                                            return "Please enter valid mobile number";
                                                          } else if (_phonenumMaxLength1 >
                                                                  0 &&
                                                              _cPhone.text
                                                                      .length <
                                                                  _phonenumMaxLength1) {
                                                            mobileValid = false;
                                                            setState(() {});
                                                            return "Please enter valid mobile number";
                                                          } else {
                                                            mobileValid = true;
                                                            setState(() {});
                                                            return null;
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]))
                                  : SizedBox(),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal:
                                        10), // 👈 Added left & right padding
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Receiver Address",
                                            style: TextStyle(
                                              fontFamily:
                                                  global.fontRailwayRegular,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 19,
                                              color: ColorConstants
                                                  .newTextHeadingFooter,
                                            ),
                                          ),
                                          global.currentUser.id != null
                                              ? ElevatedButton.icon(
                                                  onPressed: () async {
                                                    {
                                                      int isbothpresent = 0;
                                                      print(addressList.length);
                                                      if (addressList != null &&
                                                          addressList.length >
                                                              0) {
                                                        for (int i = 0;
                                                            i <
                                                                addressList
                                                                    .length;
                                                            i++) {
                                                          print(
                                                              "helakjdhsjhdahjlooo");
                                                          if (addressList[i]
                                                                  .type!
                                                                  .toLowerCase() ==
                                                              "home") {
                                                            if (isbothpresent ==
                                                                2) {
                                                              isbothpresent = 3;
                                                            } else {
                                                              print(addressList[
                                                                      i]
                                                                  .type!
                                                                  .toLowerCase());
                                                              if (addressList[i]
                                                                      .type!
                                                                      .toLowerCase() ==
                                                                  "home") {
                                                                isbothpresent =
                                                                    1;
                                                              } else {
                                                                isbothpresent =
                                                                    0;
                                                              }
                                                            }
                                                          } else if (addressList[
                                                                      i]
                                                                  .type!
                                                                  .toLowerCase() ==
                                                              "office") {
                                                            if (isbothpresent ==
                                                                1) {
                                                              isbothpresent = 3;
                                                            } else {
                                                              if (addressList[i]
                                                                      .type!
                                                                      .toLowerCase() ==
                                                                  "office") {
                                                                isbothpresent =
                                                                    2;
                                                              } else {
                                                                isbothpresent =
                                                                    0;
                                                              }
                                                            }
                                                          }
                                                        }
                                                      } else {
                                                        print(
                                                            "helakjdhsjhdahjlooo");
                                                        isbothpresent = 0;
                                                        isHomeOfficePresent = 0;
                                                      }
                                                      if (isbothpresent > 2) {
                                                        isHomeOfficePresent = 3;
                                                      } else if (isbothpresent ==
                                                          2) {
                                                        isHomeOfficePresent = 2;
                                                      } else if (isbothpresent ==
                                                          1) {
                                                        isHomeOfficePresent = 1;
                                                      }
                                                      if (Platform.isIOS) {
                                                        LocationPermission s =
                                                            await Geolocator
                                                                .checkPermission();
                                                        // print("G---->${s}");
                                                        if (s ==
                                                                LocationPermission
                                                                    .denied ||
                                                            s ==
                                                                LocationPermission
                                                                    .deniedForever) {
                                                          s = await Geolocator
                                                              .requestPermission();
                                                          // bool res = await openAppSettings();
                                                          s = await Geolocator
                                                              .checkPermission();
                                                        } else {
                                                          // print("G15");

                                                          getCurrentPosition()
                                                              .then((value) {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        LocationScreen(
                                                                          a: widget
                                                                              .analytics,
                                                                          o: widget
                                                                              .observer,
                                                                          isHOmeOfficePresent:
                                                                              isHomeOfficePresent,
                                                                          cartController:
                                                                              cartController,
                                                                          isEditButtonClicked:
                                                                              false,
                                                                          fromProfile:
                                                                              false,
                                                                        ))).then(
                                                                (value) {
                                                              // _isDataLoaded = false;
                                                              getUserAddressList();
                                                              // setState(() {});
                                                            });
                                                          });
                                                        }
                                                      } else {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    LocationScreen(
                                                                      a: widget
                                                                          .analytics,
                                                                      o: widget
                                                                          .observer,
                                                                      cartController:
                                                                          cartController,
                                                                      isEditButtonClicked:
                                                                          false,
                                                                      fromProfile:
                                                                          false,
                                                                      isHOmeOfficePresent:
                                                                          isHomeOfficePresent,
                                                                    ))).then(
                                                            (value) {
                                                          // _isDataLoaded = false;
                                                          getUserAddressList();
                                                          // setState(() {});
                                                        });
                                                      }
                                                    }
                                                  },
                                                  icon: const Icon(Icons.add,
                                                      size: 16),
                                                  label:
                                                      const Text("ADD ADDRESS"),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFF8B4B2C),
                                                    foregroundColor:
                                                        Colors.white,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12,
                                                        vertical: 6),
                                                    textStyle: const TextStyle(
                                                        fontSize: 12),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24),
                                                    ),
                                                  ),
                                                )
                                              : Container()
                                        ]),

                                    const Divider(
                                      color: Color(0xFFE0E0E0),
                                      thickness: 1,
                                    ),
                                    (addressList.isEmpty)
                                        ? SizedBox(height: 10)
                                        : SizedBox(),
                                    (addressList.isEmpty)
                                        ? Container(
                                            decoration: BoxDecoration(
                                                color: ColorConstants.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(7.0))),
                                            padding: EdgeInsets.only(),
                                            child: MaterialTextField(
                                              style: TextStyle(
                                                  fontFamily:
                                                      global.fontRailwayRegular,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w200,
                                                  color:
                                                      ColorConstants.pureBlack),
                                              theme: FilledOrOutlinedTextTheme(
                                                radius: 8,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4,
                                                        vertical: 4),
                                                errorStyle: const TextStyle(
                                                    fontSize: 10,
                                                    fontFamily: global
                                                        .fontRailwayRegular,
                                                    fontWeight:
                                                        FontWeight.w200),
                                                fillColor: Colors.transparent,
                                                enabledColor: Colors.grey,
                                                focusedColor:
                                                    ColorConstants.appColor,
                                                floatingLabelStyle:
                                                    const TextStyle(
                                                        color: ColorConstants
                                                            .appColor),
                                                width: 0.5,
                                                labelStyle: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey),
                                              ),
                                              controller: _AddressName,
                                              labelText: "Full Name*",
                                              keyboardType: TextInputType.name,
                                              onChanged: (val) {
                                                String filtered =
                                                    val.replaceAll(
                                                        RegExp(r'[^a-zA-Z\s]'),
                                                        '');
                                                if (filtered != val) {
                                                  _cName.text = filtered;
                                                  _cName.selection =
                                                      TextSelection
                                                          .fromPosition(
                                                    TextPosition(
                                                        offset:
                                                            filtered.length),
                                                  );
                                                }
                                                if (onProceedClicked &&
                                                    _formKey.currentState!
                                                        .validate()) {
                                                  print("Submit Data");
                                                }
                                              },
                                              validator: (value) {
                                                print(value);
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "Please enter receiver full name  ";
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                          )
                                        : SizedBox(),
                                    addressList.isEmpty
                                        ? SizedBox(
                                            height: 10,
                                          )
                                        : SizedBox(),
                                    // (global.userProfileController.addressList
                                    //         .isNotEmpty)
                                    //     ?
                                    (addressList.isEmpty)
                                        ? Container(
                                            decoration: BoxDecoration(
                                                color: ColorConstants.white,
                                                borderRadius:
                                                    BorderRadius.circular(7)),
                                            child: MaterialTextField(
                                              style: TextStyle(
                                                  fontFamily:
                                                      global.fontRailwayRegular,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w200,
                                                  color:
                                                      ColorConstants.pureBlack),
                                              theme: FilledOrOutlinedTextTheme(
                                                radius: 8,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4,
                                                        vertical: 4),
                                                errorStyle: const TextStyle(
                                                    fontSize: 10,
                                                    fontFamily: global
                                                        .fontRailwayRegular,
                                                    fontWeight:
                                                        FontWeight.w200),
                                                fillColor: Colors.transparent,
                                                enabledColor: Colors.grey,
                                                focusedColor:
                                                    ColorConstants.appColor,
                                                floatingLabelStyle:
                                                    const TextStyle(
                                                        color: ColorConstants
                                                            .appColor),
                                                width: 0.5,
                                                labelStyle: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey),
                                              ),
                                              controller: _AddressEmail,
                                              labelText: "Email*",
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              onChanged: (val) {
                                                if (onProceedClicked &&
                                                    _formKey.currentState!
                                                        .validate()) {
                                                  print("Submit Data");
                                                }
                                              },
                                              validator: (value) {
                                                print("this is value ${value}");
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "Please enter receiver email";
                                                } else if (!EmailValidator
                                                    .validate(value)) {
                                                  return "Please enter valid receiver email";
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                          )
                                        : SizedBox(),

                                    (addressList.isEmpty)
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                left: 0, right: 0, top: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    showCountryPicker(
                                                      countryListTheme:
                                                          CountryListThemeData(
                                                              inputDecoration:
                                                                  InputDecoration(
                                                                      hintText:
                                                                          "",
                                                                      label:
                                                                          Text(
                                                                        "Search",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontFamily:
                                                                                fontRailwayRegular,
                                                                            color:
                                                                                ColorConstants.appColor),
                                                                      )),
                                                              searchTextStyle:
                                                                  TextStyle(
                                                                      color: ColorConstants
                                                                          .pureBlack),
                                                              textStyle: TextStyle(
                                                                  fontFamily:
                                                                      fontRailwayRegular,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w200,
                                                                  fontSize: 16,
                                                                  color: ColorConstants
                                                                      .pureBlack,
                                                                  letterSpacing:
                                                                      1)),
                                                      context: context,
                                                      showPhoneCode:
                                                          true, // optional. Shows phone code before the country name.
                                                      onSelect:
                                                          (Country country) {
                                                        print(
                                                            'Select country: ${country.displayName} & ${country.countryCode} & ${country.flagEmoji}');
                                                        countryCode =
                                                            country.phoneCode;
                                                        countryCodeFlg =
                                                            "${country.flagEmoji}";
                                                        countryCodeSelected =
                                                            country.phoneCode;
                                                        _phonenumMaxLength1 =
                                                            country
                                                                .example.length;

                                                        setState(() {
                                                          _AddressMobil.text =
                                                              "";
                                                        });
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    width: 125,
                                                    margin: EdgeInsets.only(
                                                        bottom: mobileValid
                                                            ? 0
                                                            : 20),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors
                                                              .grey.shade300,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    7.0))),
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                5, 1, 0, 0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                countryCodeFlg!,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        fontMontserratMedium,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        25,
                                                                    color: ColorConstants
                                                                        .pureBlack,
                                                                    letterSpacing:
                                                                        1)),
                                                            Expanded(
                                                                child: Text(
                                                                    countryCodeSelected!,
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            fontRailwayRegular,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w200,
                                                                        fontSize:
                                                                            16,
                                                                        color: ColorConstants
                                                                            .pureBlack,
                                                                        letterSpacing:
                                                                            1))),
                                                            Icon(
                                                              Icons
                                                                  .arrow_drop_down,
                                                              size: 30,
                                                              color: ColorConstants
                                                                  .newAppColor,
                                                            )
                                                          ],
                                                        )),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    height:
                                                        mobileValid ? 40 : 60,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    0.0))),
                                                    margin: EdgeInsets.only(
                                                        left: 8,
                                                        right: 1,
                                                        top: 10,
                                                        bottom: 10),
                                                    padding: EdgeInsets.only(),
                                                    child: TextFormField(
                                                      inputFormatters: <TextInputFormatter>[
                                                        FilteringTextInputFormatter
                                                            .digitsOnly
                                                      ],
                                                      key: Key('1'),
                                                      cursorColor: Colors.black,
                                                      controller: _AddressMobil,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                              fontRailwayRegular,
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          color: ColorConstants
                                                              .pureBlack,
                                                          letterSpacing: 1),
                                                      keyboardType:
                                                          TextInputType.phone,
                                                      maxLength:
                                                          _phonenumMaxLength1 ==
                                                                  0
                                                              ? 9
                                                              : _phonenumMaxLength1,
                                                      focusNode: _fAddressMobil,
                                                      onFieldSubmitted: (val) {
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                _fAddressMobil);
                                                      },
                                                      obscuringCharacter: '*',
                                                      decoration:
                                                          InputDecoration(
                                                              counterText: "",
                                                              border:
                                                                  OutlineInputBorder(),
                                                              labelStyle: TextStyle(
                                                                  color: _fAddressMobil
                                                                              .hasFocus ==
                                                                          true
                                                                      ? ColorConstants
                                                                          .appColor
                                                                      : ColorConstants
                                                                          .grey),
                                                              labelText:
                                                                  "Mobile Number*",
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            7),
                                                                borderSide: BorderSide(
                                                                    color: _fAddressMobil.hasFocus ==
                                                                            true
                                                                        ? ColorConstants
                                                                            .appColor
                                                                        : ColorConstants
                                                                            .grey,
                                                                    width: 0.0),
                                                              ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            7),
                                                                borderSide: BorderSide(
                                                                    color: _fAddressMobil.hasFocus ==
                                                                            true
                                                                        ? ColorConstants
                                                                            .appColor
                                                                        : ColorConstants
                                                                            .grey,
                                                                    width: 0.0),
                                                              ),
                                                              hintText:
                                                                  '561234567',
                                                              errorStyle: const TextStyle(
                                                                  fontSize: 10,
                                                                  fontFamily: global
                                                                      .fontRailwayRegular,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w200),
                                                              hintStyle: TextStyle(
                                                                  fontFamily:
                                                                      fontRailwayRegular,
                                                                  fontSize:
                                                                      14)),
                                                      onChanged: (val) {
                                                        if (onProceedClicked &&
                                                            _formKey
                                                                .currentState!
                                                                .validate()) {
                                                          print("Submit Data");
                                                        }
                                                      },
                                                      validator: (value) {
                                                        print(value);
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          mobileValid = false;
                                                          setState(() {});
                                                          return "Please enter receiver mobile number";
                                                        } else if (_cPhone.text
                                                                .isNotEmpty &&
                                                            _phonenumMaxLength1 ==
                                                                0 &&
                                                            _cPhone.text
                                                                    .length <
                                                                9) {
                                                          mobileValid = false;
                                                          setState(() {});
                                                          return "Please enter valid mobile number";
                                                        } else if (_phonenumMaxLength1 >
                                                                0 &&
                                                            _cPhone.text
                                                                    .length <
                                                                _phonenumMaxLength1) {
                                                          mobileValid = false;
                                                          setState(() {});
                                                          return "Please enter valid mobile number";
                                                        } else {
                                                          mobileValid = true;
                                                          setState(() {});
                                                          return null;
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : SizedBox(),
                                    addressList.isEmpty
                                        ? SizedBox(
                                            height: 5,
                                          )
                                        : SizedBox(),
                                    addressList.isEmpty
                                        ? Column(
                                            children: [
                                              Row(
                                                children: [
//NEW TIMESLOT PLUS DEL DATE CODE GUEST USER

                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () async {
                                                            FocusScope.of(
                                                                    context)
                                                                .requestFocus(
                                                                    FocusNode());

                                                            final DateTime?
                                                                pickedDate =
                                                                await showDatePicker(
                                                              context: context,
                                                              // initialDate:
                                                              //     DateTime
                                                              //         .now(),
                                                              initialDate: (selectedDate !=
                                                                          null &&
                                                                      selectedDate
                                                                          .toString()
                                                                          .isNotEmpty)
                                                                  ? selectedDate
                                                                  : DateTime
                                                                      .now(),
                                                              firstDate:
                                                                  DateTime
                                                                      .now(),
                                                              lastDate:
                                                                  DateTime(
                                                                      2100),
                                                              builder: (BuildContext
                                                                      context,
                                                                  Widget?
                                                                      child) {
                                                                return Theme(
                                                                  data: Theme.of(
                                                                          context)
                                                                      .copyWith(
                                                                    colorScheme:
                                                                        ColorScheme
                                                                            .light(
                                                                      primary:
                                                                          ColorConstants
                                                                              .appColor,
                                                                      onPrimary:
                                                                          Colors
                                                                              .white,
                                                                      onSurface:
                                                                          Colors
                                                                              .black,
                                                                    ),
                                                                    textButtonTheme:
                                                                        TextButtonThemeData(
                                                                      style: TextButton
                                                                          .styleFrom(
                                                                        foregroundColor:
                                                                            ColorConstants.appColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  child: child!,
                                                                );
                                                              },
                                                            );

                                                            if (pickedDate !=
                                                                null) {
                                                              setState(() {
                                                                print(
                                                                    "in condition----------1112");
                                                                deliveryDateEmpty =
                                                                    false;
                                                                _selectedTime =
                                                                    "";
                                                                selectedTime =
                                                                    "";
                                                                selectedDate =
                                                                    pickedDate;
                                                                guestDeliveryDate =
                                                                    "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                                                                loggedindeliveryDateController
                                                                        .text =
                                                                    guestDeliveryDate!;
                                                                callTimeslotAPI =
                                                                    true;
                                                                _getTimeSlots(
                                                                    guestDeliveryDate,
                                                                    true);
                                                              });
                                                            }
                                                          },
                                                          child: AbsorbPointer(
                                                            child: TextField(
                                                              controller:
                                                                  loggedindeliveryDateController,
                                                              style: TextStyle(
                                                                fontFamily: global
                                                                    .fontOufitMedium,
                                                                fontSize: 15,
                                                                color: ColorConstants
                                                                    .newTextHeadingFooter,
                                                              ),
                                                              decoration:
                                                                  _inputDecoration(
                                                                          "Delivery Date")
                                                                      .copyWith(
                                                                suffixIcon:
                                                                    Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              13,
                                                                          bottom:
                                                                              13),
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/images/calender.png',
                                                                    height: 8,
                                                                    width: 8,
                                                                    color: ColorConstants
                                                                        .appColor,
                                                                  ),
                                                                ),
                                                              ),
                                                              readOnly: true,
                                                            ),
                                                          ),
                                                        ),

                                                        /// Required text (if empty)
                                                        Visibility(
                                                          visible:
                                                              deliveryDateEmpty &&
                                                                  addressList
                                                                      .isEmpty,
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 3),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                20,
                                                            child: Text(
                                                              "required*",
                                                              style: TextStyle(
                                                                color: ColorConstants
                                                                    .redVelvet,
                                                                fontSize: 10,
                                                                fontFamily: global
                                                                    .fontRailwayRegular,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w200,
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                        selectedDate == null
                                                            ? SizedBox()
                                                            : SizedBox(
                                                                height: 15),

                                                        /// ✅ TIME SLOT CONTAINER ADDED HERE
                                                        // Container(
                                                        //   child:
                                                        //       isLoadingTimeSlots
                                                        //           ? Center(
                                                        //               child:
                                                        //                   SizedBox(
                                                        //                 width:
                                                        //                     22,
                                                        //                 height:
                                                        //                     10,
                                                        //                 child: CircularProgressIndicator(
                                                        //                     strokeWidth:
                                                        //                         2),
                                                        //               ),
                                                        //             )
                                                        //           : (timeSlotsDropDown
                                                        //                       .isEmpty && selectedDate == null && guestDeliveryDate.isNotEmpty
                                                        //               ? Container(
                                                        //                   height:
                                                        //                       40,
                                                        //                   decoration:
                                                        //                       BoxDecoration(
                                                        //                     border:
                                                        //                         Border.all(
                                                        //                       color: const Color.fromARGB(255, 232, 228, 228),
                                                        //                       width: 0.5,
                                                        //                     ),
                                                        //                     color:
                                                        //                         ColorConstants.white,
                                                        //                     borderRadius:
                                                        //                         BorderRadius.circular(10.0),
                                                        //                   ),
                                                        //                   padding:
                                                        //                       EdgeInsets.symmetric(horizontal: 12),
                                                        //                   alignment:
                                                        //                       Alignment.centerLeft,
                                                        //                   child:
                                                        //                       Text(
                                                        //                     "No time slots available",
                                                        //                     style:
                                                        //                         TextStyle(
                                                        //                       fontFamily: global.fontRailwayRegular,
                                                        //                       fontSize: 13,
                                                        //                       color: ColorConstants.grey,
                                                        //                     ),
                                                        //                   ),
                                                        //                 )
                                                        //               : GridView
                                                        //                   .builder(
                                                        //                   // padding: EdgeInsets.symmetric(
                                                        //                   //     horizontal: 5,
                                                        //                   //     vertical: 5),
                                                        //                   padding: EdgeInsets.only(
                                                        //                       bottom: 20,
                                                        //                       top: 5,
                                                        //                       left: 5,
                                                        //                       right: 5),
                                                        //                   shrinkWrap:
                                                        //                       true,
                                                        //                   physics:
                                                        //                       const NeverScrollableScrollPhysics(),
                                                        //                   itemCount:
                                                        //                       timeSlotsDropDown.length,
                                                        //                   gridDelegate:
                                                        //                       const SliverGridDelegateWithFixedCrossAxisCount(
                                                        //                     crossAxisCount:
                                                        //                         3,
                                                        //                     mainAxisSpacing:
                                                        //                         8,
                                                        //                     crossAxisSpacing:
                                                        //                         8,
                                                        //                     childAspectRatio:
                                                        //                         2.8,
                                                        //                   ),
                                                        //                   itemBuilder:
                                                        //                       (context, index) {
                                                        //                     final item =
                                                        //                         timeSlotsDropDown[index];
                                                        //                     final slotName = (item is DropDownValueModel)
                                                        //                         ? item.name
                                                        //                         : item.toString();
                                                        //                     final bool
                                                        //                         isSelected =
                                                        //                         selectedTime == slotName;

                                                        //                     return GestureDetector(
                                                        //                       onTap: () {
                                                        //                         setState(() {
                                                        //                           _selectedTime = slotName;
                                                        //                           selectedTime = slotName;
                                                        //                           boolDeliverySlotErrorShow = false;
                                                        //                         });
                                                        //                       },
                                                        //                       child: AnimatedContainer(
                                                        //                         duration: Duration(milliseconds: 160),
                                                        //                         padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                        //                         decoration: BoxDecoration(
                                                        //                           color: isSelected ? Color(0xFF8B4513) : ColorConstants.white,
                                                        //                           borderRadius: BorderRadius.circular(10),
                                                        //                           border: Border.all(
                                                        //                             color: isSelected ? Color(0xFF8B4513) : Color.fromARGB(255, 232, 228, 228),
                                                        //                             width: 0.8,
                                                        //                           ),
                                                        //                         ),
                                                        //                         child: Center(
                                                        //                           child: Text(
                                                        //                             slotName.replaceAll(":00", ""),
                                                        //                             textAlign: TextAlign.center,
                                                        //                             style: TextStyle(
                                                        //                               fontFamily: global.fontRailwayRegular,
                                                        //                               fontSize: 10,
                                                        //                               color: isSelected ? Colors.white : ColorConstants.newTextHeadingFooter,
                                                        //                               fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                                        //                             ),
                                                        //                           ),
                                                        //                         ),
                                                        //                       ),
                                                        //                     );
                                                        //                   },
                                                        //                 )

                                                        //                 ),
                                                        // ),

// TIME SLOT CONTAINER
                                                        Container(
                                                          child:
                                                              isLoadingTimeSlots
                                                                  ? Center(
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            22,
                                                                        height:
                                                                            10,
                                                                        child: CircularProgressIndicator(
                                                                            strokeWidth:
                                                                                2),
                                                                      ),
                                                                    )
                                                                  : (timeSlotsDropDown
                                                                              .isEmpty &&
                                                                          selectedDate ==
                                                                              null &&
                                                                          (guestDeliveryDate ?? '')
                                                                              .isNotEmpty
                                                                      ? Container(
                                                                          height:
                                                                              40,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            border:
                                                                                Border.all(
                                                                              color: const Color.fromARGB(255, 232, 228, 228),
                                                                              width: 0.5,
                                                                            ),
                                                                            color:
                                                                                ColorConstants.white,
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                          ),
                                                                          padding:
                                                                              EdgeInsets.symmetric(horizontal: 12),
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          child:
                                                                              Text(
                                                                            "No time slots available",
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: global.fontRailwayRegular,
                                                                              fontSize: 13,
                                                                              color: ColorConstants.grey,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : GridView
                                                                          .builder(
                                                                          padding: EdgeInsets.only(
                                                                              bottom: 20,
                                                                              top: 5,
                                                                              left: 5,
                                                                              right: 5),
                                                                          shrinkWrap:
                                                                              true,
                                                                          physics:
                                                                              const NeverScrollableScrollPhysics(),
                                                                          itemCount:
                                                                              timeSlotsDropDown.length,
                                                                          gridDelegate:
                                                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                                            crossAxisCount:
                                                                                3,
                                                                            mainAxisSpacing:
                                                                                8,
                                                                            crossAxisSpacing:
                                                                                8,
                                                                            childAspectRatio:
                                                                                2.8,
                                                                          ),
                                                                          itemBuilder:
                                                                              (context, index) {
                                                                            final item =
                                                                                timeSlotsDropDown[index];
                                                                            final slotName = (item is DropDownValueModel)
                                                                                ? item.name
                                                                                : item.toString();
                                                                            final bool
                                                                                isSelected =
                                                                                selectedTime == slotName;

                                                                            return GestureDetector(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  _selectedTime = slotName;
                                                                                  selectedTime = slotName;
                                                                                  boolDeliverySlotErrorShow = false;
                                                                                  guestDeliveryTimeslotbool = false;
                                                                                });
                                                                              },
                                                                              child: AnimatedContainer(
                                                                                duration: Duration(milliseconds: 160),
                                                                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                                                decoration: BoxDecoration(
                                                                                  color: isSelected ? Color(0xFF8B4513) : ColorConstants.white,
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                  border: Border.all(
                                                                                    color: isSelected ? Color(0xFF8B4513) : const Color.fromARGB(255, 232, 228, 228),
                                                                                    width: 0.8,
                                                                                  ),
                                                                                ),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    slotName.replaceAll(":00", ""),
                                                                                    textAlign: TextAlign.center,
                                                                                    style: TextStyle(
                                                                                      fontFamily: global.fontRailwayRegular,
                                                                                      fontSize: 10,
                                                                                      color: isSelected ? Colors.white : ColorConstants.newTextHeadingFooter,
                                                                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                        )),
                                                        ),

// VISIBILITY FOR "required*" MESSAGE
                                                        Visibility(
                                                          visible:
                                                              guestDeliveryTimeslotbool,
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 6),
                                                            child: Text(
                                                              "required*",
                                                              style: TextStyle(
                                                                color: ColorConstants
                                                                    .redVelvet,
                                                                fontSize: 10,
                                                                fontFamily: global
                                                                    .fontRailwayRegular,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w200,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  // const SizedBox(height: 8),

                                                  // --- NEW.    Select Time (horizontal list using existing timeSlotsDropDown) ---
                                                ],
                                              ),
                                              GridView.builder(
                                                // padding: const EdgeInsets.all(16),
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,

                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  crossAxisSpacing: 12,
                                                  mainAxisSpacing: 12,
                                                  childAspectRatio: 3,
                                                ),
                                                itemCount: addressList
                                                    .length, // number of items in the grid
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () async {
                                                      // ✅ Update selected index on tap
                                                      setState(() {
                                                        // selectedIndex = index;
                                                        selectedAddressID =
                                                            addressList[index]
                                                                .addressId!;
                                                        print("G1--------->1");
                                                        print(
                                                            selectedAddressID);
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration:
                                                          ShapeDecoration(
                                                        color: Colors.white,
                                                        shape: selectedIndex ==
                                                                index
                                                            ? RoundedRectangleBorder(
                                                                side:
                                                                    BorderSide(
                                                                  color: ColorConstants
                                                                      .appColor,
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                              )
                                                            : RoundedRectangleBorder(
                                                                side:
                                                                    BorderSide(
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      232,
                                                                      228,
                                                                      228),
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                              ),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          // 🏠 Home / Office / Other Icon
                                                          if (addressList[index]
                                                                      .type !=
                                                                  null &&
                                                              addressList[index]
                                                                      .type!
                                                                      .toLowerCase() ==
                                                                  'home')
                                                            Icon(
                                                              Icons
                                                                  .house_outlined,
                                                              color: ColorConstants
                                                                  .allIconsBlack45,
                                                              size: 18,
                                                            )
                                                          else if (addressList[
                                                                          index]
                                                                      .type !=
                                                                  null &&
                                                              addressList[index]
                                                                      .type!
                                                                      .toLowerCase() ==
                                                                  'office')
                                                            Icon(
                                                              Icons
                                                                  .book_outlined,
                                                              color: ColorConstants
                                                                  .allIconsBlack45,
                                                              size: 18,
                                                            )
                                                          else if (addressList[
                                                                          index]
                                                                      .type !=
                                                                  null &&
                                                              (addressList[index]
                                                                          .type!
                                                                          .toLowerCase() ==
                                                                      'other' ||
                                                                  addressList[index]
                                                                          .type!
                                                                          .toLowerCase() ==
                                                                      'others'))
                                                            Icon(
                                                              Icons
                                                                  .flag_outlined,
                                                              color: ColorConstants
                                                                  .allIconsBlack45,
                                                              size: 18,
                                                            ),

                                                          const SizedBox(
                                                              width: 10),

                                                          // 📄 Address Texts
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                addressList[
                                                                        index]
                                                                    .type!,
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 2),
                                                              Row(
                                                                children: [
                                                                  if (addressList[
                                                                              index]
                                                                          .building_villa !=
                                                                      null) ...[
                                                                    Text(
                                                                      addressList[
                                                                              index]
                                                                          .building_villa!,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        color: Colors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      ",",
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        color: Colors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                  const SizedBox(
                                                                      width: 2),
                                                                  Text(
                                                                    addressList[
                                                                            index]
                                                                        .cityName!,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          )
                                        : SizedBox(),

                                    // addressList.isEmpty
                                    //     ? SizedBox(height: 15)
                                    //     : SizedBox(),

                                    addressList.isEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: ColorConstants.white,
                                                  borderRadius:
                                                      BorderRadius.circular(7)),
                                              child: MaterialTextField(
                                                style: TextStyle(
                                                    fontFamily: global
                                                        .fontRailwayRegular,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w200,
                                                    color: ColorConstants
                                                        .pureBlack),
                                                theme:
                                                    FilledOrOutlinedTextTheme(
                                                  radius: 8,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 4,
                                                          vertical: 4),
                                                  errorStyle: const TextStyle(
                                                      fontSize: 10,
                                                      fontFamily: global
                                                          .fontRailwayRegular,
                                                      fontWeight:
                                                          FontWeight.w200),
                                                  fillColor: Colors.transparent,
                                                  enabledColor: Colors.grey,
                                                  focusedColor:
                                                      ColorConstants.appColor,
                                                  floatingLabelStyle:
                                                      const TextStyle(
                                                          color: ColorConstants
                                                              .appColor),
                                                  width: 0.5,
                                                  labelStyle: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey),
                                                ),
                                                controller: _Addressdata,
                                                labelText: "Address*",
                                                keyboardType:
                                                    TextInputType.streetAddress,
                                                onChanged: (val) {
                                                  if (onProceedClicked &&
                                                      _formKey.currentState!
                                                          .validate()) {
                                                    print("Submit Data");
                                                  }
                                                },
                                                validator: (value) {
                                                  print(
                                                      "this is value ${value}");
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Please enter receiver address";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                              ),
                                            ),
                                          )
                                        : SizedBox(),

                                    addressList.isNotEmpty
                                        ? SizedBox(
                                            height: 12,
                                          )
                                        : SizedBox(),

                                    GridView.builder(
                                      // padding: const EdgeInsets.all(16),
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,

                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                        childAspectRatio: 3,
                                      ),
                                      itemCount: addressList
                                          .length, // number of items in the grid
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () async {
                                            // ✅ Update selected index on tap
                                            setState(() {
                                              selectedIndex = index;
                                            });
                                            // print(global.userProfileController
                                            //     .addressList[index].lng!);
                                            // print(global.userProfileController
                                            //     .addressList[index].type!);

                                            // Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            decoration: ShapeDecoration(
                                              color: Colors.white,
                                              shape: selectedIndex == index
                                                  ? RoundedRectangleBorder(
                                                      side: BorderSide(
                                                        color: ColorConstants
                                                            .appColor,
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    )
                                                  : RoundedRectangleBorder(
                                                      side: BorderSide(
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 232, 228, 228),
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                            ),
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                // 🏠 Home / Office / Other Icon
                                                if (addressList[index].type !=
                                                        null &&
                                                    addressList[index]
                                                            .type!
                                                            .toLowerCase() ==
                                                        'home')
                                                  Icon(
                                                    Icons.house_outlined,
                                                    color: ColorConstants
                                                        .allIconsBlack45,
                                                    size: 18,
                                                  )
                                                else if (addressList[index]
                                                            .type !=
                                                        null &&
                                                    addressList[index]
                                                            .type!
                                                            .toLowerCase() ==
                                                        'office')
                                                  Icon(
                                                    Icons.book_outlined,
                                                    color: ColorConstants
                                                        .allIconsBlack45,
                                                    size: 18,
                                                  )
                                                else if (addressList[index]
                                                            .type !=
                                                        null &&
                                                    (addressList[index]
                                                                .type!
                                                                .toLowerCase() ==
                                                            'other' ||
                                                        addressList[index]
                                                                .type!
                                                                .toLowerCase() ==
                                                            'others'))
                                                  Icon(
                                                    Icons.flag_outlined,
                                                    color: ColorConstants
                                                        .allIconsBlack45,
                                                    size: 18,
                                                  ),

                                                const SizedBox(width: 10),

                                                // 📄 Address Texts
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      addressList[index].type!,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Row(
                                                      children: [
                                                        if (addressList[index]
                                                                .building_villa !=
                                                            null) ...[
                                                          Text(
                                                            addressList[index]
                                                                .building_villa!,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                          Text(
                                                            ",",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ],
                                                        const SizedBox(
                                                            width: 2),
                                                        Text(
                                                          addressList[index]
                                                              .cityName!,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),

                                    SizedBox(height: 20),
                                    global.currentUser != null &&
                                            global.currentUser.id != null &&
                                            addressList.length > 0
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Select Delivery Date & Timeslot",
                                                style: TextStyle(
                                                  fontFamily:
                                                      global.fontRailwayRegular,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 19,
                                                  color: ColorConstants
                                                      .newTextHeadingFooter,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              const Divider(
                                                color: Color(0xFFE0E0E0),
                                                thickness: 1,
                                              ),
                                            ],
                                          )
                                        : SizedBox(),
                                    global.currentUser != null &&
                                            global.currentUser.id != null &&
                                            addressList.length > 0
                                        ? SizedBox(height: 5)
                                        : SizedBox(),

                                    global.currentUser != null &&
                                            global.currentUser.id != null &&
                                            addressList.length > 0
                                        ? SizedBox(height: 20)
                                        : SizedBox(),

                                    global.currentUser != null &&
                                            global.currentUser.id != null &&
                                            addressList.length > 0
                                        ?

//new code >>>>>>>>>>>>>

                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // --- Delivery Date Field (same as your code) ---
                                              GestureDetector(
                                                onTap: () async {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          FocusNode());
                                                  _selectedTime = "";
                                                  selectedTime = "";
                                                  final DateTime? pickedDate =
                                                      await showDatePicker(
                                                    context: context,
                                                    // initialDate: DateTime.now(),
                                                    initialDate:
                                                        (selectedDate != null &&
                                                                selectedDate
                                                                    .toString()
                                                                    .isNotEmpty)
                                                            ? selectedDate
                                                            : DateTime.now(),
                                                    firstDate: DateTime.now(),
                                                    lastDate: DateTime(2100),
                                                    builder:
                                                        (BuildContext context,
                                                            Widget? child) {
                                                      return Theme(
                                                        data: Theme.of(context)
                                                            .copyWith(
                                                          colorScheme:
                                                              ColorScheme.light(
                                                            primary:
                                                                ColorConstants
                                                                    .appColor,
                                                            onPrimary:
                                                                Colors.white,
                                                            onSurface:
                                                                Colors.black,
                                                          ),
                                                          textButtonTheme:
                                                              TextButtonThemeData(
                                                            style: TextButton
                                                                .styleFrom(
                                                              foregroundColor:
                                                                  ColorConstants
                                                                      .appColor,
                                                            ),
                                                          ),
                                                        ),
                                                        child: child!,
                                                      );
                                                    },
                                                  );

                                                  if (pickedDate != null) {
                                                    setState(() {
                                                      print(
                                                          "in condition----------1113");

                                                      selectedDate = pickedDate;
                                                      guestDeliveryDate =
                                                          "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                                                      loggedindeliveryDateController
                                                              .text =
                                                          guestDeliveryDate!;
                                                      callTimeslotAPI = true;
                                                      print(
                                                          "G1------selecteddate---->$selectedDate");
                                                      _getTimeSlots(
                                                          guestDeliveryDate,
                                                          true);
                                                    });
                                                  }
                                                },
                                                child: AbsorbPointer(
                                                  child: TextField(
                                                    controller:
                                                        loggedindeliveryDateController,
                                                    style: TextStyle(
                                                      fontFamily: global
                                                          .fontOufitMedium,
                                                      fontSize: 15,
                                                      color: ColorConstants
                                                          .newTextHeadingFooter,
                                                    ),
                                                    decoration:
                                                        _inputDecoration(
                                                                "Delivery Date")
                                                            .copyWith(
                                                      suffixIcon: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 13,
                                                                bottom: 13),
                                                        child: Image.asset(
                                                          'assets/images/calender.png',
                                                          height: 8,
                                                          width: 8,
                                                          color: ColorConstants
                                                              .appColor,
                                                        ),
                                                      ),
                                                    ),
                                                    readOnly: true,
                                                  ),
                                                ),
                                              ),

                                              // date validation text
                                              Visibility(
                                                visible: deliveryDateEmpty &&
                                                    deliveryTimeEmpty,
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(top: 6),
                                                  child: Text(
                                                    "required*",
                                                    style: TextStyle(
                                                      color: ColorConstants
                                                          .redVelvet,
                                                      fontSize: 10,
                                                      fontFamily: global
                                                          .fontRailwayRegular,
                                                      fontWeight:
                                                          FontWeight.w200,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              SizedBox(height: 10),

                                              // --- Time slot horizontal list (shown only after date selected) ---
                                              if (selectedDate == null)
                                                Container(
                                                  height: 20,
                                                  // decoration: BoxDecoration(
                                                  //   border: Border.all(
                                                  //       color:
                                                  //           ColorConstants.grey,
                                                  //       width: 0.5),
                                                  //   color: ColorConstants.white,
                                                  //   borderRadius:
                                                  //       BorderRadius.circular(
                                                  //           10.0),
                                                  // ),
                                                  // alignment:
                                                  //     Alignment.centerLeft,
                                                  // padding: EdgeInsets.symmetric(
                                                  //     horizontal: 12),
                                                  // child: Text(
                                                  //   "Select delivery date first",
                                                  //   style: TextStyle(
                                                  //     fontFamily: global
                                                  //         .fontRailwayRegular,
                                                  //     fontSize: 13,
                                                  //     color:
                                                  //         ColorConstants.grey,
                                                  //   ),
                                                  // ),
                                                )
                                              else
                                                Container(
                                                  child: isLoadingTimeSlots
                                                      ? Center(
                                                          child: SizedBox(
                                                              width: 22,
                                                              height: 22,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                      strokeWidth:
                                                                          2)))
                                                      : (timeSlotsDropDown
                                                                  .isEmpty &&
                                                              selectedDate ==
                                                                  null
                                                          ? Container(
                                                              height: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        232,
                                                                        228,
                                                                        228),
                                                                    width: 0.5),
                                                                color:
                                                                    ColorConstants
                                                                        .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                              ),
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          12),
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                "No time slots available",
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily: global
                                                                      .fontRailwayRegular,
                                                                  fontSize: 13,
                                                                  color:
                                                                      ColorConstants
                                                                          .grey,
                                                                ),
                                                              ),
                                                            )
                                                          // : ListView.separated(
                                                          //     scrollDirection:
                                                          //         Axis.horizontal,
                                                          //     padding: EdgeInsets
                                                          //         .symmetric(
                                                          //             horizontal:
                                                          //                 6,
                                                          //             vertical:
                                                          //                 6),
                                                          //     itemCount:
                                                          //         timeSlotsDropDown
                                                          //             .length,
                                                          //     separatorBuilder:
                                                          //         (_, __) =>
                                                          //             SizedBox(
                                                          //                 width:
                                                          //                     8),
                                                          //     itemBuilder:
                                                          //         (context,
                                                          //             index) {
                                                          //       final item =
                                                          //           timeSlotsDropDown[
                                                          //               index];
                                                          //       final slotName = (item
                                                          //               is DropDownValueModel)
                                                          //           ? item.name
                                                          //           : item
                                                          //               .toString();
                                                          //       final bool
                                                          //           isSelected =
                                                          //           selectedTime ==
                                                          //               slotName;
                                                          //       return GestureDetector(
                                                          //         onTap: () {
                                                          //           setState(
                                                          //               () {
                                                          //             _selectedTime =
                                                          //                 slotName;
                                                          //             selectedTime =
                                                          //                 slotName;
                                                          //             boolDeliverySlotErrorShow =
                                                          //                 false;
                                                          //             print(
                                                          //                 selectedTime);
                                                          //           });
                                                          //         },
                                                          //         child:
                                                          //             AnimatedContainer(
                                                          //           duration: Duration(
                                                          //               milliseconds:
                                                          //                   160),
                                                          //           padding: EdgeInsets.symmetric(
                                                          //               horizontal:
                                                          //                   8,
                                                          //               vertical:
                                                          //                   8),
                                                          //           constraints:
                                                          //               BoxConstraints(
                                                          //                   minWidth:
                                                          //                       110),
                                                          //           decoration:
                                                          //               BoxDecoration(
                                                          //             color: isSelected
                                                          //                 ? Color(
                                                          //                     0xFF8B4513)
                                                          //                 : ColorConstants
                                                          //                     .white,
                                                          //             borderRadius:
                                                          //                 BorderRadius.circular(
                                                          //                     10),
                                                          //             border:
                                                          //                 Border
                                                          //                     .all(
                                                          //               color: isSelected
                                                          //                   ? Color(
                                                          //                       0xFF8B4513)
                                                          //                   : const Color.fromARGB(
                                                          //                       255,
                                                          //                       232,
                                                          //                       228,
                                                          //                       228),
                                                          //               width:
                                                          //                   0.8,
                                                          //             ),
                                                          //           ),
                                                          //           child:
                                                          //               Center(
                                                          //             child:
                                                          //                 Text(
                                                          //               slotName,
                                                          //               textAlign:
                                                          //                   TextAlign.center,
                                                          //               style:
                                                          //                   TextStyle(
                                                          //                 fontFamily:
                                                          //                     global.fontRailwayRegular,
                                                          //                 fontSize:
                                                          //                     13,
                                                          //                 color: isSelected
                                                          //                     ? Colors.white
                                                          //                     : ColorConstants.newTextHeadingFooter,
                                                          //                 fontWeight: isSelected
                                                          //                     ? FontWeight.w600
                                                          //                     : FontWeight.w400,
                                                          //               ),
                                                          //             ),
                                                          //           ),
                                                          //         ),
                                                          //       );
                                                          //     },
                                                          //   )

// Replace your current ListView.separated with this GridView.builder
                                                          : GridView.builder(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          5,
                                                                      vertical:
                                                                          5),
                                                              shrinkWrap: true,
                                                              physics:
                                                                  const NeverScrollableScrollPhysics(),
                                                              itemCount:
                                                                  timeSlotsDropDown
                                                                      .length,
                                                              gridDelegate:
                                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount:
                                                                    3, // 3 boxes horizontally
                                                                mainAxisSpacing:
                                                                    8, // vertical spacing between rows
                                                                crossAxisSpacing:
                                                                    8, // horizontal spacing between items
                                                                childAspectRatio:
                                                                    2.8, // width / height ratio — tweak if needed
                                                              ),
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                final item =
                                                                    timeSlotsDropDown[
                                                                        index];
                                                                final slotName = (item
                                                                        is DropDownValueModel)
                                                                    ? item.name
                                                                    : item
                                                                        .toString();
                                                                final bool
                                                                    isSelected =
                                                                    selectedTime ==
                                                                        slotName;

                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      _selectedTime =
                                                                          slotName;
                                                                      selectedTime =
                                                                          slotName;
                                                                      boolDeliverySlotErrorShow =
                                                                          false;
                                                                      deliveryTimeEmpty =
                                                                          false;
                                                                    });
                                                                  },
                                                                  child:
                                                                      AnimatedContainer(
                                                                    duration: const Duration(
                                                                        milliseconds:
                                                                            160),
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            8,
                                                                        vertical:
                                                                            8),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: isSelected
                                                                          ? const Color(
                                                                              0xFF8B4513)
                                                                          : ColorConstants
                                                                              .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: isSelected
                                                                            ? const Color(
                                                                                0xFF8B4513)
                                                                            : const Color.fromARGB(
                                                                                255,
                                                                                232,
                                                                                228,
                                                                                228),
                                                                        width:
                                                                            0.8,
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        slotName.replaceAll(
                                                                            ":00",
                                                                            ""),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              global.fontRailwayRegular,
                                                                          fontSize:
                                                                              10, // decreased font size
                                                                          color: isSelected
                                                                              ? Colors.white
                                                                              : ColorConstants.newTextHeadingFooter,
                                                                          fontWeight: isSelected
                                                                              ? FontWeight.w600
                                                                              : FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            )),
                                                ),

                                              // time validation text
                                              Visibility(
                                                visible: deliveryTimeEmpty,
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                    top: 6,
                                                  ),
                                                  child: Text(
                                                    "required*",
                                                    style: TextStyle(
                                                      color: ColorConstants
                                                          .redVelvet,
                                                      fontSize: 10,
                                                      fontFamily: global
                                                          .fontRailwayRegular,
                                                      fontWeight:
                                                          FontWeight.w200,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                            ],

                                            // <- closes the Column's children list
                                          )
                                        : addressList.length > 0
                                            ? SizedBox()
                                            : OutlinedButton.icon(
                                                onPressed: () async {
                                                  int isbothpresent = 0;
                                                  print(addressList.length);
                                                  if (addressList != null &&
                                                      addressList.length > 0) {
                                                    for (int i = 0;
                                                        i < addressList.length;
                                                        i++) {
                                                      print(
                                                          "helakjdhsjhdahjlooo");
                                                      if (addressList[i]
                                                              .type!
                                                              .toLowerCase() ==
                                                          "home") {
                                                        if (isbothpresent ==
                                                            2) {
                                                          isbothpresent = 3;
                                                        } else {
                                                          print(addressList[i]
                                                              .type!
                                                              .toLowerCase());
                                                          if (addressList[i]
                                                                  .type!
                                                                  .toLowerCase() ==
                                                              "home") {
                                                            isbothpresent = 1;
                                                          } else {
                                                            isbothpresent = 0;
                                                          }
                                                        }
                                                      } else if (addressList[i]
                                                              .type!
                                                              .toLowerCase() ==
                                                          "office") {
                                                        if (isbothpresent ==
                                                            1) {
                                                          isbothpresent = 3;
                                                        } else {
                                                          if (addressList[i]
                                                                  .type!
                                                                  .toLowerCase() ==
                                                              "office") {
                                                            isbothpresent = 2;
                                                          } else {
                                                            isbothpresent = 0;
                                                          }
                                                        }
                                                      }
                                                    }
                                                  } else {
                                                    print(
                                                        "helakjdhsjhdahjlooo");
                                                    isbothpresent = 0;
                                                    isHomeOfficePresent = 0;
                                                  }
                                                  if (isbothpresent > 2) {
                                                    isHomeOfficePresent = 3;
                                                  } else if (isbothpresent ==
                                                      2) {
                                                    isHomeOfficePresent = 2;
                                                  } else if (isbothpresent ==
                                                      1) {
                                                    isHomeOfficePresent = 1;
                                                  }
                                                  if (Platform.isIOS) {
                                                    LocationPermission s =
                                                        await Geolocator
                                                            .checkPermission();
                                                    // print("G---->${s}");
                                                    if (s ==
                                                            LocationPermission
                                                                .denied ||
                                                        s ==
                                                            LocationPermission
                                                                .deniedForever) {
                                                      s = await Geolocator
                                                          .requestPermission();
                                                      // bool res = await openAppSettings();
                                                      s = await Geolocator
                                                          .checkPermission();
                                                    } else {
                                                      // print("G15");

                                                      getCurrentPosition()
                                                          .then((value) {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    LocationScreen(
                                                                      a: widget
                                                                          .analytics,
                                                                      o: widget
                                                                          .observer,
                                                                      isHOmeOfficePresent:
                                                                          isHomeOfficePresent,
                                                                      cartController:
                                                                          cartController,
                                                                      isEditButtonClicked:
                                                                          false,
                                                                      picklocationOnly:
                                                                          true,
                                                                      fromProfile:
                                                                          false,
                                                                    ))).then(
                                                            (value) {
                                                          // _isDataLoaded = false;
                                                          _Addressdata.text =
                                                              pickedLocationAddress;
                                                          // setState(() {});
                                                        });
                                                      });
                                                    }
                                                  } else {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                LocationScreen(
                                                                  a: widget
                                                                      .analytics,
                                                                  o: widget
                                                                      .observer,
                                                                  cartController:
                                                                      cartController,
                                                                  isEditButtonClicked:
                                                                      false,
                                                                  fromProfile:
                                                                      false,
                                                                  picklocationOnly:
                                                                      true,
                                                                  isHOmeOfficePresent:
                                                                      isHomeOfficePresent,
                                                                ))).then(
                                                        (value) {
                                                      // _isDataLoaded = false;
                                                      _Addressdata.text =
                                                          pickedLocationAddress;
                                                      // setState(() {});
                                                    });
                                                  }
                                                },
                                                icon: const Icon(
                                                  Icons.location_on_outlined,
                                                  color: ColorConstants
                                                      .newAppColor,
                                                  size: 18,
                                                ),
                                                label: const Text(
                                                  "SELECT MAP",
                                                  style: TextStyle(
                                                    color: ColorConstants
                                                        .newAppColor,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                style: OutlinedButton.styleFrom(
                                                  backgroundColor: ColorConstants
                                                      .colorHomePageSectiondim,
                                                  foregroundColor: Colors.white,
                                                  side: BorderSide.none,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 6),
                                                  minimumSize:
                                                      const Size(0, 32),
                                                  tapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                ),
                                              ),

                                    const SizedBox(height: 45),

                                    // 🔸 Payment Buttons
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () async {
                                              FocusScope.of(context).unfocus();
                                              setState(() {
                                                if (totalOrderPrice > 0) {
                                                  isCardSelected = true;
                                                  selectedPaymentType = "Card";
                                                }
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  top: 5,
                                                  bottom: 5,
                                                  left: 8,
                                                  right: 8),
                                              decoration: BoxDecoration(
                                                  color: selectedPaymentType ==
                                                          "Card"
                                                      ? ColorConstants.appColor
                                                      : ColorConstants
                                                          .colorHomePageSectiondim,
                                                  border: Border.all(
                                                      color: ColorConstants
                                                          .appColor,
                                                      width: 0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    "assets/images/iv_card_appcolor.png",
                                                    height: 25,
                                                    width: 25,
                                                    color: isCardSelected
                                                        // ? ColorConstants.appColor
                                                        //     .withOpacity(0.3)
                                                        ? ColorConstants.white
                                                        : ColorConstants
                                                            .appColor,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "CARD \nPAYMENT",
                                                    textAlign: TextAlign.center,
                                                    // "${AppLocalizations.of(context).tle_add_new_address} ",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            fontOufitMedium,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13,
                                                        color: isCardSelected
                                                            // ? ColorConstants.appColor
                                                            //     .withOpacity(0.3)
                                                            ? ColorConstants
                                                                .white
                                                            : ColorConstants
                                                                .appColor,
                                                        letterSpacing: 1),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              FocusScope.of(context).unfocus();
                                              setState(() {
                                                if (totalOrderPrice > 0) {
                                                  isCardSelected = false;
                                                  selectedPaymentType = "COD";
                                                }
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  top: 5,
                                                  bottom: 5,
                                                  left: 8,
                                                  right: 8),
                                              decoration: BoxDecoration(
                                                  color: isCardSelected
                                                      // ? ColorConstants.appColor
                                                      //     .withOpacity(0.3)
                                                      ? ColorConstants
                                                          .colorHomePageSectiondim
                                                      : ColorConstants.appColor,
                                                  border: Border.all(
                                                      color: ColorConstants
                                                          .appColor,
                                                      width: 0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    "assets/images/iv_cod_appcolor.png",
                                                    height: 25,
                                                    width: 25,
                                                    color: isCardSelected
                                                        // ? ColorConstants.appColor
                                                        //     .withOpacity(0.3)
                                                        ? ColorConstants
                                                            .appColor
                                                        : ColorConstants.white,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "CASH ON \nDELIVERY",
                                                    textAlign: TextAlign.center,
                                                    // "${AppLocalizations.of(context).tle_add_new_address} ",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            fontOufitMedium,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13,
                                                        color: isCardSelected
                                                            // ? ColorConstants.appColor
                                                            //     .withOpacity(0.3)
                                                            ? ColorConstants
                                                                .appColor
                                                            : ColorConstants
                                                                .white,
                                                        letterSpacing: 1),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),

                                    const SizedBox(
                                      height: 20,
                                    ),

                                    Center(
                                      child: Wrap(
                                        alignment: WrapAlignment
                                            .center, // centers items in each row
                                        runAlignment: WrapAlignment.center,
                                        spacing:
                                            10, // horizontal space between items
                                        runSpacing: 8,
                                        children: [
                                          ...[
                                            "mastercard.png",
                                            "americanexpress.png",
                                            "visa.png",
                                            // if (Platform.isIOS) "applepay.png",
                                            "careempay.png",
                                            "tabby.jpg"
                                          ].map((img) => Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    width: 0.5,
                                                    color: const Color.fromARGB(
                                                        255, 46, 31, 26),
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 9,
                                                        vertical: 0),
                                                child: Image.asset(
                                                    "assets/images/$img",
                                                    width: 33,
                                                    height: 33),
                                              )),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 60),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

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

                        // Visibility(
                        //   visible: global.appInfo.codEnabled == 1,
                        //   child: Container(
                        //     height: radioListTileHeight,
                        //     margin: EdgeInsets.only(left: 0, right: 0, top: 1),
                        //     decoration: BoxDecoration(
                        //       color: ColorConstants.white,
                        //     ),
                        //     child: RadioListTile(
                        //         activeColor: ColorConstants.appColor,
                        //         value: 2, //isWalletSelected,
                        //         groupValue: _isCOD,
                        //         title: Text(
                        //           "Cash on delivery",
                        //           style: TextStyle(
                        //               fontFamily: fontRailwayRegular,
                        //               fontWeight: FontWeight.w200,
                        //               fontSize: 15,
                        //               color: selectedPaymentType == "COD" &&
                        //                       cardWithOtherPay == "COD"
                        //                   ? ColorConstants.appColor
                        //                   : ColorConstants.pureBlack),
                        //         ),
                        //         secondary: Image.asset(
                        //           "assets/images/iv_cod.png",
                        //           height: 30,
                        //           width: 30,
                        //         ),
                        //         // card_icon
                        //         selected: false,
                        //         onChanged: (val) async {
                        //           if (isWalletSelected && totalOrderPrice == 0) {
                        //             showPaymentError = true;
                        //             paymentErrorMSG =
                        //                 "Sufficient amount in wallet to place this order";
                        //             setState(() {});
                        //           } else if (isCouponCodeVisible &&
                        //               totalOrderPrice == 0) {
                        //             showPaymentError = true;
                        //             paymentErrorMSG =
                        //                 "Sufficient amount in coupon discount to place this order";
                        //             setState(() {});
                        //           } else {
                        //             isCODSelected = true;
                        //             print("This is the card on pressed fun${val}");
                        //             selectedPaymentType = "COD";
                        //             // cardWithOtherPay = "COD";
                        //             _isCOD = val;
                        //             setState(() {});
                        //           }
                        //         }),
                        //   ),
                        // ),

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
                  ),
                ),
              )
            : _productShimmer(),

        bottomNavigationBar: BottomAppBar(
          height: 70,
          color: ColorConstants.colorPageBackground,
          elevation: 8,
          child: InkWell(
            onTap: () {
              setState(() {
                onProceedClicked = true;
              });
              if (currentUser == null || currentUser.id == null) {
                print(selectedDate);
                if (selectedDate.toString().length == 0 ||
                    selectedDate == null) {
                  setState(() {
                    deliveryDateEmpty = true;
                    deliveryTimeEmpty = true;
                  });
                }
                if (_formKey.currentState!.validate()) {
                  if (selectedDate.toString().length == 0) {
                    setState(() {
                      deliveryDateEmpty = true;
                      deliveryTimeEmpty = true;
                    });
                  } else if (selectedTime == null ||
                      _selectedTime == null ||
                      selectedTime.isEmpty) {
                    setState(() {
                      guestDeliveryTimeslotbool = true;
                      print(guestDeliveryTimeslotbool);
                      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>");
                    });
                  } else {
                    if (selectedDate.toString().length != 0 &&
                        selectedDate != null) {
                      _callSignInGuest();
                    }
                  }
                } else {
                  if (selectedDate.toString().length == 0) {
                    setState(() {
                      deliveryDateEmpty = true;
                      deliveryTimeEmpty = true;
                    });
                  } else if (selectedTime == null) {
                    setState(() {
                      deliveryTimeEmpty = true;
                    });
                  } else {
                    deliveryDateEmpty = false;
                    deliveryTimeEmpty = false;
                  }
                }
              } else if (currentUser != null &&
                  currentUser.id != null &&
                  currentUser.userPhone == null) {
                if (_formKey.currentState!.validate()) {
                  _callUpdatePhoneNameSocialLogin();
                } else {
                  if (selectedDate.toString().length == 0 &&
                      _selectedTime == null) {
                    setState(() {
                      deliveryDateEmpty = true;
                      deliveryTimeEmpty = true;
                    });
                  } else if (selectedTime == null && _selectedTime == null) {
                    setState(() {
                      deliveryTimeEmpty = true;
                    });
                  } else {
                    deliveryDateEmpty = false;
                    deliveryTimeEmpty = false;
                  }
                }
              } else {
                if (selectedDate.toString().length == 0) {
                  setState(() {
                    deliveryDateEmpty = true;
                    deliveryTimeEmpty = true;
                  });
                } else if (selectedDate.toString().length > 0 &&
                    _selectedTime == null) {
                  setState(() {
                    deliveryTimeEmpty = true;
                  });
                } else {
                  print("---------selectedaddressss");
                  print(selectedAddressID);
                  // print(global.currentUser);
                  // print(addressList.toString());
                  deliveryDateEmpty = false;
                  deliveryTimeEmpty = false;
                  showOnlyLoaderDialog();
                  _makeOrder();
                }
              }
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
                height: 40,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //  Wallet Image
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/wallet_red.png",
                            color: ColorConstants.white,
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Center(
                            child: Text(
                              btnProceedName,
                              style: TextStyle(
                                fontFamily: global.fontOufitMedium,
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                                color: ColorConstants.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 📝 Center Text

                    // 💰 Price Text
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Text(
                        "AED ${(totalOrderPrice).toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontFamily: global.fontOufitMedium,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
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

              if (couponDiscount == totalOrderPrice) {
                selectedPaymentType = "Wallet";
              } else {
                selectedPaymentType = "Card";
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

// get coup[on list API CALL ----------------------------

  _getCouponsList() async {
    _couponList.clear();
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        await apiHelper
            .getCoupons(
                store_id: cartController
                    .cartItemsList.cartData!.storeDetails?.id
                    .toString(),
                total_delivery: global.total_delivery_count)
            .then((result) async {
          if (result != null) {
            if (result.status == "1") {
              List<Coupon> cuplist = result.data;
              _couponList.addAll(cuplist);
              print(result.toString());
              print("Nikhil---------------------3");
            }
          }
        });
      } else {
        print("Nikhil---------------------3");
        showNetworkErrorSnackBar(_scaffoldKey!);
      }

      setState(() {});
    } catch (e) {
      print("Nikhil---------------------4");
      print("Exception - coupons_screen.dart - _getCouponsList():" +
          e.toString());
    }
  }

// GET COUPON LIST ABOVE CODE -----------------------------

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

    print("paymentscreen copy initstate");
    print(currentUser);
    // print(customerId);

    _getCouponsList();
    _getAppInfo();
    _init();

    _fPhone.addListener(() {
      // Rebuild UI whenever focus changes
      setState(() {});
    });
    _fAddressMobil.addListener(() {
      setState(() {});
    });

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

  Address1 _selectedAddress = new Address1();
  int selectedIndex = -1;

  getUserAddressList() async {
    try {
      await apiHelper.getAddressList().then((result) async {
        if (result != null) {
          if (result.status == "1") {
            addressList = result.data;
            print("nikhil address list----$addressList");

            print("lgobal list ${addressList[0].type}");
            _isDataLoaded = true;
            if (addressList.length == 1) {
              _selectedAddress = addressList[0];
              selectedIndex = 0;
            } else {
              for (int i = 0; i < addressList.length; i++) {
                print("nikhikkhkjhkjhjggj");
                if (addressList[i].type!.trim().toLowerCase() == 'home') {
                  selectedAddressID = addressList[i].addressId!;
                  _selectedAddress = addressList[i];
                  selectedIndex = i;
                }
              }
            }

            print(selectedIndex);
            setState(() {
              _isDataLoaded = true;
              // if (userProfileController.addressList.length == 1) {
              //   _selectedAddress = userProfileController.addressList[0];
              //   selectedIndex = 0;
              // }
            });
          } else {
            print("nikhilllll");
            addressList = [];
          }
        }
      });
    } catch (e) {
      _isDataLoaded = true;
      print(
          "Exception - user_profile_controller.dart - _init():" + e.toString());
    }
  }

  _callUpdateDeliveryDates() async {
    try {
      final result = await apiHelper.UpdateDateTime(
        deliveryDate: selectedDate.toString(),
        deliveryTime: selectedTime,
        userId: global.currentUser.id == null
            ? siginInResponse!.userId
            : global.currentUser.id,
      );

      print("on the page response");
      print(result.status);

      if (result.status == "true") {
        return 1;
      } else {
        return 0;
      }
    } catch (e) {
      print(e);

      return 0;
    }
  }

  _callSignInGuest() async {
    showOnlyLoaderDialog();
    try {
      await apiHelper.SaveGuestUserAddress(
        contact_name: _cName.text,
        contact_phone: _cPhone.text,
        contact_email: _cEmail.text,
        receiver_name: _AddressName.text,
        receiver_phone: _AddressMobil.text,
        city: _Addressdata.text,
        delivery_date: selectedDate.toString(),
        time_slot: selectedTime,
      ).then((result) {
        if (result != null && result.data["status"] == true) {
          siginInResponse = new GuestUserResponseModel(
            status: result.data["status"],
            message: result.data["message"],
            userId: result.data["user_id"],
            addressId: result.data["address_id"],
            deliveryDate: result.data["delivery_date"],
            timeSlot: result.data["time_slot"],
          );

          if (siginInResponse!.status.toString() == "true") {
            selectedAddressID = siginInResponse!.addressId!;
            selectedDate = DateTime.tryParse(siginInResponse!.deliveryDate!) ??
                DateTime.now();
            selectedTime = siginInResponse!.timeSlot!;

            _makeOrder();
          } else {
            hideloadershowing();

            setState(() {
              paymentErrorMSG = siginInResponse!.message != null
                  ? siginInResponse!.message!
                  : "Unable to create user";
            });
          }
          //
          //
        } else {
          hideloadershowing();

          setState(() {
            paymentErrorMSG = "Something went wrong for user";
          });
        }
      });
    } catch (e) {
      print(e);
      paymentErrorMSG = "Something went wrong an exception occured";
      setState(() {});
      hideloadershowing();
    }
  }

  _callUpdatePhoneNameSocialLogin() async {
    showOnlyLoaderDialog();
    try {
      await apiHelper.UpdateUserPhoneName(
        user_phone: _cPhone.text,
        name: _cName.text,
      ).then((result) async {
        if (result != null && result.data["status"] == 1) {
          print(
              "dkjfhkjdsfkjdf sdnfojsdfo dsnfj-=-===-=-=-=-=-=-=-=-=-0=-0-=0-=0=-0=-0");
          print(result.data["message"]);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          global.currentUser.name = _cName.text;
          global.currentUser.userPhone = couponCodeStr! + _cPhone.text;
          prefs.setString('currentUser', json.encode(global.currentUser));
          _makeOrder();
        } else {
          hideloadershowing();

          setState(() {
            showPaymentError = true;
            paymentErrorMSG = siginInResponse!.message != null
                ? siginInResponse!.message!
                : "Unable to create user";
          });
        }
        //
        //
      });
    } catch (e) {
      print(e);
      paymentErrorMSG = "Something went wrong an exception occured";
      setState(() {});
      hideloadershowing();
    }
  }

  _makeOrder() async {
    // itemsToOrder.clear();
    // print(selectedOccasionString.text);

    int updateDateSuccess = 0;
    try {
      bool isConnected = await br!.checkConnectivity();
      // if (global.currentUser.id == null) {
      //   Fluttertoast.showToast(msg: "user not present");
      //   // return;
      // } else if (global.currentUser != null &&
      //         global.currentUser.email == null ||
      //     (global.currentUser.email != null &&
      //         global.currentUser.email!.isEmpty) ||
      //     global.currentUser.userPhone == null ||
      //     (global.currentUser.userPhone != null &&
      //         global.currentUser.userPhone!.isEmpty)) {
      //   Navigator.of(context).push(
      //     NavigationUtils.createAnimatedRoute(
      //         1.0,
      //         ProfileEditScreen(
      //           a: widget.analytics,
      //           o: widget.observer,
      //         )),
      //   );
      // } else {
      if (isCouponCodeVisible && selectedPaymentType == "COD") {
        Fluttertoast.showToast(
          msg: "Coupon Discount is valid only for Card Payments", // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.CENTER, // location
          // duration
        );
        hideloadershowing();
      } else if (isWalletSelected &&
          (totalOrderPrice != 0 || totalOrderPrice != 0.0) &&
          selectedPaymentType.toLowerCase() == "wallet") {
        showPaymentError = true;
        paymentErrorMSG = "Select Payment Method As Your Wallet Has Low Amount";
        hideloadershowing();
        setState(() {});
      } else if (isConnected) {
        print("Make order isConnected");
        print(
            "G1---currentUser--->${global.currentUser.id} &&--- siginInResponse--- ${siginInResponse!.userId}");
        if (isWalletSelected &&
            selectedPaymentType.toLowerCase() == "wallet" &&
            global.currentUser != null &&
            (totalOrderPrice == 0 || totalOrderPrice == 0.0)) {
          int updateDateSuccess = await _callUpdateDeliveryDates();
          if (updateDateSuccess == 1) {
            await apiHelper
                .makeOrder(
                    user_id: global.currentUser.id == null
                        ? siginInResponse!.userId
                        : global.currentUser.id,
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
                    message: selectedOccasionString.text != null
                        ? selectedOccasionString.text
                        : "",
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
            hideloadershowing();
            paymentErrorMSG = "Something went wrong in date. Please try again";
            showPaymentError = true;
            btnProceedName = "RETRY";
            setState(() {});
          }
        } else if (!isWalletSelected &&
            isCouponCodeVisible &&
            selectedPaymentType.toLowerCase() == "wallet" &&
            (totalOrderPrice == 0 || totalOrderPrice == 0.0)) {
          updateDateSuccess = await _callUpdateDeliveryDates();
          if (updateDateSuccess == 1) {
            await apiHelper
                .makeOrder(
                    user_id: global.currentUser.id != null
                        ? global.currentUser.id
                        : siginInResponse!.userId!,
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
                    message: selectedOccasionString.text != null
                        ? selectedOccasionString.text
                        : "",
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
            hideloadershowing();
            paymentErrorMSG = "Something went wrong in date. Please try again";
            showPaymentError = true;
            btnProceedName = "RETRY";
            setState(() {});
          }
        } else {
          print('G11--->Checkout Card ---1');
          if (selectedPaymentType == "Card") {
            print('G11--->Checkout Card ---2');
            await _callUpdateDeliveryDates();
            if (appInfo.openPaymentSDK != null && appInfo.openPaymentSDK!) {
              updateDateSuccess = await _callUpdateDeliveryDates();
              if (updateDateSuccess == 1) {
                initGoSellSdk();
                // _startCheckout(); //Mark error
              } else {
                hideloadershowing();
                paymentErrorMSG =
                    "Something went wrong in date. Please try again";
                showPaymentError = true;
                btnProceedName = "RETRY";
                setState(() {});
              }
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
            updateDateSuccess = await _callUpdateDeliveryDates();
            print("thiis is jjsnfkabd sadhsdj------$updateDateSuccess");
            if (updateDateSuccess == 1) {
              await apiHelper
                  .makeOrder(
                      user_id: global.currentUser.id != null
                          ? global.currentUser.id
                          : siginInResponse!.userId!,
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
                      message: selectedOccasionString.text != null
                          ? selectedOccasionString.text
                          : "",
                      coupon_amount: couponDiscount.toString(),
                      si_sub_ref_no: si_sub_ref_no)
                  .then((result) async {
                print(result.toString());
                print('G11--->Checkout call ---1');

                if (result != null) {
                  print('G11--->Checkout call ---2');
                  if (result.status == "1") {
                    print('G11--->Checkout call ---3');
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
              hideloadershowing();
              paymentErrorMSG =
                  "Something went wrong in date. Please try again";
              showPaymentError = true;
              btnProceedName = "RETRY";
              setState(() {});
            }
          } else {
            hideloadershowing();
            showPaymentError = true;
            paymentErrorMSG = "Choose Payment Method";
            setState(() {});
          }
        }
      } else {
        hideloadershowing();
        showNetworkErrorSnackBar(_scaffoldKey!);
      }
      // }
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
                  'BYYU',
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
        getUserAddressList();
        await apiHelper.getAppInfo().then((result) async {
          if (result != null) {
            if (result.status == "1") {
              global.appInfo = result.data;
              print(global.appInfo.userwallet);
              print(global.appInfo);
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
                // print(object)
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
      } else {
        selectedPaymentType = "Card";
        setState(() {});
      }
    } else {
      //////#####################this is wallet removed

      totalWalletSpendings = 0.0;
      totalWalletbalance = global.appInfo.userwallet!;
      totalOrderPrice = double.parse(
              (cartController.cartItemsList.cartData!.totalPrice).toString()) -
          couponDiscount;
      selectedPaymentType = "Card";
      setState(() {});
    }
  }

  void callbackPaymentSetState(CartController cartController) {
    print("callbackPaymentSetState-----------------");
    print(cartController.cartItemsList.cartData!.cartProductdata!.length);
    if (global.cartItemsPresent) {
      setState(() {
        isCouponCodeVisible = false;
        showCouponField = false;
        couponDiscount = 0.0;
        couponCodeStr = "";

        isDiscountCodeVisible = true;

        walletAppliedRemoved();

        if ((addAmount - couponDiscount).toStringAsFixed(2) == "0.00" ||
            (addAmount - couponDiscount).toStringAsFixed(2) == "-0.00" ||
            (addAmount - couponDiscount).toStringAsFixed(2) == "0.0") {
          isAlertVisible = false;
        } else {
          isAlertVisible = true;
        }
        this.cartController = cartController;
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
      });
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            a: widget.analytics,
            o: widget.observer,
            selectedIndex: 0,
          ),
        ),
      );
    }
  }

  _getTimeSlots(String selectedDate, bool showLoading) async {
    print("_getTimeSlots$callTimeslotAPI");
    _isDataLoaded = true;
    if (callTimeslotAPI) {
      callTimeslotAPI = true;

      if (showLoading) {
        showOnlyLoaderDialog();
      }
      try {
        await apiHelper
            .getTimeSlots(
                cartController
                    .cartItemsList.cartData!.cartProductdata![0].varientId!,
                "2025-11-29")
            .then((result) async {
          if (result != null) {
            timeSlotsDropDown.clear();
            timeSlots.clear();

            print("this is the timeslot result api call printed below");
            timeSlotNotAvailable = "";

            timeSlots1.clear();
            timeSlots1 = result.data;
            timeSlots.clear();
            timeSlotsDropDown.clear();
            for (int i = 0; i < timeSlots1.length; i++) {
              timeSlots.add(timeSlots1[i].timeSlot!);
              timeSlotsDropDown.add(DropDownValueModel(
                  value: "${i}", name: timeSlots1[i].timeSlot!));
            }

            setState(() {
              if (showLoading) {
                hideLoader();
              }
              callTimeslotAPI = true;
              _isDataLoaded = true;
            });
          } else {
            timeSlotNotAvailable =
                "Please order before 4:00 PM for same day delivery";
            boolDeliverySlotErrorShow = false;

            setState(() {
              if (showLoading) {
                hideLoader();
              }
            });
          }
        });
      } catch (e) {
        timeSlotNotAvailable =
            "Please order before 4:00 PM for same day delivery";
        setState(() {
          if (showLoading) {
            hideLoader();
          }
        });
      }
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
    print("setUpIosSdkSession");
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
          email: global.currentUser.email != null
              ? global.currentUser.email!
              : _cEmail.text,
          isdNumber: "", //global.currentUser.countryCode,
          number: global.currentUser.userPhone != null
              ? global.currentUser.userPhone!
              : _cPhone.text,
          firstName: global.currentUser.name != null
              ? global.currentUser.name!
              : _cName.text,
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
            order: global.currentUser.id.toString() +
                (global.currentUser.name != null
                    ? global.currentUser.name!
                    : _cName.text)),
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
    } on Exception {
      paymentErrorMSG = "Something went wrong. Please try again";
      showPaymentError = true;
      hideLoader();
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
          email: global.currentUser.email != null
              ? global.currentUser.email!
              : _cEmail.text,
          isdNumber: "", //global.currentUser.countryCode,
          number: global.currentUser.userPhone != null
              ? global.currentUser.userPhone!
              : _cPhone.text,
          firstName: global.currentUser.name != null
              ? global.currentUser.name!
              : _cName.text,
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
            order: (global.currentUser.id != null &&
                    global.currentUser.name != null)
                ? "${global.currentUser.id} ${global.currentUser.name}"
                : "${siginInResponse!.userId} ${_cName.text}"),
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
    // setState(() {
    //   showOnlyLoaderDialog();
    // });
    try {
      print("calling start sdk");
      tapSDKResult = await GoSellSdkFlutter.startPaymentSDK;
    } catch (e) {
      print("calling start sdk exception");
      GoSellSdkFlutter.terminateSession;
      hideLoader();
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
              user_id: global.currentUser.id != null
                  ? global.currentUser.id
                  : siginInResponse!.userId!,
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
              message: selectedOccasionString.text != null
                  ? selectedOccasionString.text
                  : "",
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
      await apiHelper
          .paymentError(
        activity,
        description,
        global.currentUser.id == null
            ? siginInResponse!.userId
            : global.currentUser.id,
      )
          .then(
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

  String generateTapHashString({
    required String publicKey,
    required String secretKey,
    required double amount,
    required String currency,
    String postUrl = '',
    String transactionReference = '',
  }) {
    final key = utf8.encode(secretKey);
    final formattedAmount = amount.toStringAsFixed(2);

    final toBeHashed = 'x_publickey$publicKey'
        'x_amount$formattedAmount'
        'x_currency$currency'
        'x_transaction$transactionReference'
        'x_post$postUrl';

    final hmacSha256 = Hmac(sha256, key);
    final digest = hmacSha256.convert(utf8.encode(toBeHashed));
    print("digest>>>>>>>>>>>>>>>>");
    print(digest);
    return digest.toString();
  }

//TAP NEW CHECKOUT SDK CODE WITHOUT MERCHANT ID
  // Future<void> _startCheckout() async {
  //   try {
  //     setState(() {
  //       _checkoutStatus = 'Starting checkout...';
  //     });

  //     // ✅ Generate hash using AED
  //     final hash = generateTapHashString(
  //       publicKey: "pk_live_mwsjP76vnVUfkHCQRxgcKpIX",
  //       secretKey: "sk_live_qEcXkL49WN8fYrP7d0avihpn",
  //       amount: 1,
  //       currency: "AED", // ✅ Changed to AED
  //       postUrl: "https://example.com/webhook",
  //       transactionReference: "",
  //     );

  //     // ✅ Checkout configurations — AED everywhere
  //     Map<String, dynamic> configurations = {
  //       "hashString": hash,
  //       "language": "en",
  //       "themeMode": "light",
  //       "supportedPaymentMethods": "ALL",
  //       "paymentType": "ALL",

  //       // ✅ Selected currency is AED
  //       "selectedCurrency": "AED",
  //       "supportedCurrencies": "ALL",

  //       "supportedPaymentTypes": [],
  //       "supportedRegions": [],
  //       "supportedSchemes": [],
  //       "supportedCountries": [],

  //       // ✅ Your real keys
  //       "gateway": {
  //         "publicKey": "pk_live_mwsjP76vnVUfkHCQRxgcKpIX",
  //         "merchantId": "",
  //       },

  //       "customer": {
  //         "firstName": "Android",
  //         "lastName": "Test",
  //         "email": "example@gmail.com",
  //         "phone": {"countryCode": "971", "number": "55567890"},
  //       },

  //       "transaction": {
  //         "mode": "charge",
  //         "charge": {
  //           "metadata": {"value_1": "checkout_flutter"},
  //           "reference": {
  //             "transaction": "trans_01",
  //             "order": "order_01",
  //             "idempotent": "order_01",
  //           },
  //           "saveCard": true,
  //           "redirect": {
  //             "url": "https://demo.staging.tap.company/v2/sdk/checkout",
  //           },
  //           "post": "https://example.com/webhook",
  //           "threeDSecure": true,
  //         },
  //       },

  //       // ✅ Amount using AED
  //       "amount": "1",

  //       "order": {
  //         "currency": "AED", // ✅ Changed to AED
  //         "amount": "1",
  //         "items": [
  //           {
  //             "amount": "1",
  //             "currency": "AED", // ✅ Changed to AED
  //             "name": "Item Title 1",
  //             "quantity": 1,
  //             "description": "item description 1",
  //           },
  //         ],
  //       },

  //       "cardOptions": {
  //         "showBrands": true,
  //         "showLoadingState": false,
  //         "collectHolderName": true,
  //         "preLoadCardName": "",
  //         "cardNameEditable": true,
  //         "cardFundingSource": "all",
  //         "saveCardOption": "all",
  //         "forceLtr": false,
  //         "alternativeCardInputs": {"cardScanner": true, "cardNFC": true},
  //       },

  //       "isApplePayAvailableOnClient": true,
  //     };

  //     // ✅ Start the checkout
  //     final success = await startCheckout(
  //       configurations: configurations,
  //       onReady: () {
  //         setState(() {
  //           _checkoutStatus = 'Checkout is ready!';
  //         });
  //         print('Checkout is ready!');
  //       },
  //       onSuccess: (data) {
  //
  //         setState(() {
  //           _checkoutStatus = 'Payment successful: $data';
  //         });
  //         print('Payment successful: $data');
  //       },
  //       onError: (error) {
  //         hideLoader();
  //         setState(() {
  //           _checkoutStatus = 'Payment failed: $error';
  //         });
  //         print('Payment failed: $error');
  //       },
  //       onClose: () {
  // hideLoader();
  //         setState(() {
  //           _checkoutStatus = 'Checkout closed';
  //         });
  //         print('Checkout closed');
  //       },
  //       onCancel: () {
  // hideLoader();
  //         setState(() {
  //           _checkoutStatus = 'Checkout cancelled';
  //         });
  //         print('Checkout cancelled (Android)');
  //       },
  //     );

  //     if (!success) {
  //       hideLoader();
  //       setState(() {
  //         _checkoutStatus = 'Failed to start checkout';
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _checkoutStatus;
  //     });
  //   }
  //   ;
  // }
}
