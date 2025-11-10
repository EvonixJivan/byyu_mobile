import 'dart:convert';
import 'dart:io';

import 'package:byyu/models/eventsListModel.dart';
import 'package:byyu/models/userModel.dart';
import 'package:byyu/screens/product/buy_together_screen.dart';
import 'package:byyu/screens/search_screen.dart';
import 'package:byyu/widgets/cart_bottom_sheet.dart';
import 'package:byyu/widgets/image_zoom.dart';
import 'package:byyu/widgets/toastfile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:byyu/constants/analytics_GA4.dart';
import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/controllers/cart_controller.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/productDetailModel.dart';
import 'package:byyu/screens/home_screen.dart';
import 'package:byyu/screens/auth/login_screen.dart';
import 'package:byyu/screens/product/sub_categories_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:material_text_fields/material_text_fields.dart';
import 'package:material_text_fields/theme/material_text_field_theme.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

import '../../models/businessLayer/global.dart';
import 'dart:ui' as ui;
import 'package:html/parser.dart';

import '../../models/varientModel.dart';
import 'all_categories_screen.dart';

class AppBarActionButton extends StatefulWidget {
  final Function? onPressed;
  final CartController? cartController;
  final String? isHomeSelected;
  final String? isFrom;

  AppBarActionButton(this.cartController,
      {this.onPressed, this.isHomeSelected, this.isFrom})
      : super();

  @override
  _AppBarActionButtonState createState() => _AppBarActionButtonState(
        onPressed: onPressed,
        cartController: cartController,
        isHomeSelected: isHomeSelected,
        //isFrom: isFrom
      );
}

class ProductDescriptionScreen extends BaseRoute {
  final int? productId;
  final ProductDetail? productDetail;
  final int? screenId;
  final String? isHomeSelected;
  final String? isFrom;

  bool? isSubCateSelected;

// 0-> for All Products, 1-> subscription orders

  ProductDescriptionScreen({
    this.isFrom,
    a,
    o,
    this.productId,
    this.screenId,
    this.productDetail,
    this.isHomeSelected,
    this.isSubCateSelected,
  }) : super(a: a, o: o, r: 'ProductDescriptionScreen');

  @override
  _ProductDescriptionScreenState createState() =>
      _ProductDescriptionScreenState(
        isFrom: isFrom,
        productId: productId,
        screenId: screenId,
        productDetail: productDetail,
        isHomeSelected: isHomeSelected,
        isSubCateSelected: isSubCateSelected,
      );
}

class _AppBarActionButtonState extends State<AppBarActionButton> {
  Function? onPressed;

  CartController? cartController;

  String? isHomeSelected;
  final dynamic passdata1;
  final dynamic passdata2;
  final dynamic passdata3;
  bool? isSubCateSelected;
  // String? isFrom;

  _AppBarActionButtonState({
    this.onPressed,
    this.cartController,
    this.isHomeSelected,
    this.isSubCateSelected,
    this.passdata1,
    this.passdata2,
    this.passdata3,
    //this.isFrom
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      init: cartController,
      builder: (value) => Padding(
        padding: const EdgeInsets.all(8.0),
      ),
    );
  }
}

class _ProductDescriptionScreenState extends BaseRouteState {
  int? productId;
  ProductDetail? productDetail;
  String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String? selectedDate;
  @required
  int isSubscription = 0;
  int? screenId;
  ProductDetail _productDetail = new ProductDetail();
  List<String> _productImages = [];
  bool _isDataLoaded = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CartController cartController = Get.put(CartController());
  int _qty = 1;
  int? _selectedIndex;
  String? isHomeSelected;
  String? isFrom;
  final dynamic passdata1;
  final dynamic passdata2;
  final dynamic passdata3;
  bool test = false;

  TimeOfDay? selectedTime;
  String? _selectedTime;

  TimePickerEntryMode entryMode = TimePickerEntryMode.dial;
  Orientation? orientation;

  MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded;
  bool use24HourTime = false;

  var checkedValue = false;
  bool preDefined = false;
  var checkedValue1 = false;
  bool userDefined = false;
  bool isOccasionSelected = false;
  bool isMessageSelected = false;
  bool expressSelected = false;
  bool itsNextDayExpress = false;
  bool itsNextDaySame = false;
  bool sameDay = false;
  bool nextDay = false;
  bool todaySelected = false;
  bool tomorrowSelected = false;
  bool dateSelected = false;
  bool boolDeliveryTypeErrorShow = false;
  bool isCurrentDateLess = false;
  bool isEndDatePassed = false;
  String strDeliveryTypeErrorShow = "Required*";
  String strDeliverySlotErrorShow = "Required*";
  bool boolDeliverySlotErrorShow = false;
  bool boolStartEndDateError = false;
  String strStartEndDateError = "Product not available for delivery";
  bool? isSubCateSelected;
  List<String> messagesList = [];
  List<String> occasionsList = [];
  String? selectedMessage, selectedOccasssion;

  ScrollController _scrollController1 = ScrollController();
  TextEditingController _cSearchCity = new TextEditingController();

  FocusNode _fSearchCity = new FocusNode();
  var _ocassionController = new TextEditingController();
  var _messageController = new TextEditingController();
  TextEditingController timeController = new TextEditingController();
  TextEditingController dateController = new TextEditingController();
  ScrollController _scrollController = ScrollController();
  int varientIndex = 0;
  DateTime? _selectedDate;
  DateTime? otherDetailsDate;
  bool showSheet = false;
  String? responseMessage;

  int otherDetailsTextLength = 0;
  int otherDetailsImageLength = 0;
  List<String> _tImage = [];
  int selectedBannerIndex = 0;
  int? selectedVarientIndex = 0;

  _ProductDescriptionScreenState(
      {this.productId,
      this.screenId,
      this.productDetail,
      this.isHomeSelected,
      this.isFrom,
      this.isSubCateSelected,
      this.passdata1,
      this.passdata2,
      this.passdata3});

  // check if Add To Cart button is pressed once

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final TextEditingController _searchController = TextEditingController();

    double screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(

        // ignore: missing_return
        onWillPop: () async {
          Navigator.of(context).pop();
          return true;
        },
        child: Scaffold(
          backgroundColor: ColorConstants.colorPageBackground,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: ColorConstants.appBarColorWhite,
            title: InkWell(
              onTap: () {
                global.routingProductID = 0;
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomeScreen(
                          a: widget.analytics,
                          o: widget.observer,
                          selectedIndex: 0,
                        )));
              },
              child: Image.asset(
                "assets/images/new_logo.png",
                fit: BoxFit.contain,
                height: 25,
                alignment: Alignment.center,
              ),
            ),
            // title: Text(
            //   _isDataLoaded
            //       ? _productDetail.productDetail.productName
            //       : '${AppLocalizations.of(context).tle_product_details}',
            //   style: TextStyle(
            //       fontSize: 20,
            //       fontFamily: global.fontMontserratMedium,
            //       color: ColorConstants.pureBlack), //textTheme.titleLarge,
            // ),
            leading: BackButton(
                //iconSize: 30,

                onPressed: () {
                  print("this is is home selected value ${isHomeSelected}");
                  if (isHomeSelected == 'home') {
                    print("NIkhil 2");
                    global.routingProductID = 0;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreen(
                                  a: widget.analytics,
                                  o: widget.observer,
                                  selectedIndex: 0,
                                )));
                  } else if (isHomeSelected == 'subCat') {
                    global.routingProductID = 0;
                    print("NIkhil 3");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SubCategoriesScreen(
                                a: widget.analytics,
                                o: widget.observer,
                                screenHeading: passdata1,
                                categoryId: passdata2,

                                isEventProducts: false,
                                //subscriptionProduct: global.isSubscription,
                              )),
                    );
                    global.routingProductID = 0;
                    Navigator.pop(context);
                    // Route route = MaterialPageRoute(
                    //     builder: (context) => SubCategoriesScreen(
                    //           a: widget.analytics,
                    //           o: widget.observer,
                    //           screenHeading: passdata1,
                    //           categoryId: passdata2,
                    //           isEventProducts: false,
                    //           //subscriptionProduct: global.isSubscription,
                    //         ));
                    // // Navigator.of(context).pushNamedAndRemoveUntil('/SubCategoriesScreen', (route1) => false);
                    // Navigator.pushReplacement(context, route);
                  } else if (isHomeSelected == 'search') {
                    global.routingProductID = 0;
                    print("NIkhil 4");
                    Navigator.pop(context);
                  } else if (isHomeSelected == 'FROMROUTING') {
                    print("NIkhil 4");
                    global.routingProductID = 0;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreen(
                                  a: widget.analytics,
                                  o: widget.observer,
                                  selectedIndex: 0,
                                )));
                  } else {
                    print("NIkhil 5");
                    global.routingProductID = 0;
                    Navigator.pop(context);
                  }
                },
                // icon: Icon(
                //   MdiIcons.arrowLeftBoldOutline,
                // ),
                color: ColorConstants.appColor),
            actions: [
              InkWell(
                onTap: () {
                  global.routingProductID = 0;
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SearchScreen(
                            a: widget.analytics,
                            o: widget.observer,
                            fromBottomNvigation: false,
                          )));
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 18, bottom: 18, left: 8),
                  child: Image.asset(
                    "assets/images/iv_search.png",
                    fit: BoxFit.contain,
                    height: 25,
                    alignment: Alignment.center,
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Stack(
                children: [
                  Center(
                    child: InkWell(
                      onTap: () {
                        global.routingProductID = 0;
                        Future.delayed(Duration.zero, () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            useRootNavigator: true,
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            builder: (context) => CartBottomSheet(
                              analytics: widget.analytics,
                              observer: widget.observer,
                              fromNavigationBar: false,
                            ),
                          );
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 15, right: 8),
                        child: Image.asset(
                          "assets/images/ic_nav_cart.png",
                          fit: BoxFit.contain,
                          height: 25,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ),
                  global.cartCount != 0 && global.cartCount <= 10
                      ? new Positioned(
                          right: 1,
                          top: 8,
                          child: new Container(
                            padding: EdgeInsets.all(2),
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 14,
                              minHeight: 14,
                            ),
                            child: Text(
                              '${global.cartCount}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : new Container()
                ],
              ),
              SizedBox(
                width: 8,
              ),
            ],
          ),
          body: _isDataLoaded
              ? _isDataLoaded
                  ? GetBuilder<CartController>(
                      init: cartController,
                      builder: (value) => GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                        child: SingleChildScrollView(
                          controller: _scrollController1,
                          scrollDirection: Axis.vertical,
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                color: ColorConstants.colorPageBackground,
                                // height:
                                //     MediaQuery.of(context).size.height / 2.25,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, top: 5),
                                child: Stack(
                                  children: [
                                    // Container(
                                    //   width: MediaQuery.of(context).size.width,
                                    //   child: BannerImage(
                                    //     // autoPlay: false,
                                    //     // timerDuration:
                                    //     //     Duration(seconds: 8),
                                    //     padding:
                                    //         EdgeInsets.only(left: 3, right: 3),
                                    //     aspectRatio: 1,
                                    //     borderRadius: BorderRadius.circular(1),
                                    //     itemLength: 1, //_productImages.length,

                                    //     imageUrlList: _productImages[selectedBannerIndex],
                                    //     selectedIndicatorColor:
                                    //         ColorConstants.appColor,
                                    //     fit: BoxFit.contain,
                                    //     errorBuilder:
                                    //         (context, child, loadingProgress) {
                                    //       return SizedBox(
                                    //         child: Center(
                                    //             child:
                                    //                 CircularProgressIndicator()),
                                    //         height: 30.0,
                                    //         width: 30.0,
                                    //       );
                                    //     },
                                    //   ),
                                    // ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => ZoomImage(
                                                    a: widget.analytics,
                                                    o: widget.observer,
                                                    productImages:
                                                        _productImages,
                                                  )),
                                        );
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                2.4,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            _productImages[selectedBannerIndex],
                                            cacheWidth: 360,
                                            fit: BoxFit.cover,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.5,
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                2.42,
                                        margin: EdgeInsets.only(
                                            left: 15, bottom: 5),
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Text(""),
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ZoomImage(
                                                              a: widget
                                                                  .analytics,
                                                              o: widget
                                                                  .observer,
                                                              productImages:
                                                                  _productImages,
                                                            )),
                                                  );
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 5, right: 8),
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                      color: ColorConstants
                                                          .colorHomePageSection,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Icon(
                                                    Icons.zoom_out_map,
                                                    size: 25,
                                                    weight: 0.5,
                                                    opticalSize: 2,
                                                    fill: 0.1,
                                                    color:
                                                        ColorConstants.appColor,
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                2.42,
                                        margin:
                                            EdgeInsets.only(right: 5, top: 8),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                                onTap: () async {
                                                  if (global.currentUser !=
                                                          null &&
                                                      global.currentUser.id ==
                                                          null) {
                                                    Future.delayed(
                                                        Duration.zero, () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    LoginScreen(
                                                                      a: widget
                                                                          .analytics,
                                                                      o: widget
                                                                          .observer,
                                                                    )),
                                                      );
                                                    });
                                                  } else {
                                                    bool _isAdded =
                                                        await addRemoveWishListO(
                                                            _productDetail
                                                                .productDetail!
                                                                .varientId!);
                                                    print(_isAdded);
                                                    if (_isAdded) {
                                                      // _showToastWhishList();

                                                      _productDetail
                                                          .productDetail!
                                                          .isFavourite = _productDetail
                                                                  .productDetail!
                                                                  .isFavourite ==
                                                              'false'
                                                          ? 'true'
                                                          : 'false';
                                                      _productDetail
                                                          .productDetail!
                                                          .isFavourite = "true";
                                                    } else {
                                                      _productDetail
                                                              .productDetail!
                                                              .isFavourite =
                                                          "false";
                                                    }

                                                    setState(() {});
                                                  }
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: ColorConstants
                                                          .colorHomePageSection,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  padding: EdgeInsets.all(5),
                                                  margin: EdgeInsets.only(
                                                    top: 1,
                                                    right: 8,
                                                  ),
                                                  child: _productDetail
                                                              .productDetail!
                                                              .isFavourite ==
                                                          'true'
                                                      ? Icon(
                                                          MdiIcons.heart,
                                                          size: 30,
                                                          color: ColorConstants
                                                              .appColor,
                                                        )
                                                      : Icon(
                                                          MdiIcons.heartOutline,
                                                          size: 30,
                                                          color: ColorConstants
                                                              .appColor,
                                                        ),
                                                )),
                                            InkWell(
                                                onTap: () async {
                                                  String productName =
                                                      _productDetail
                                                          .productDetail!
                                                          .productName!
                                                          .trim()
                                                          .replaceAll(" ", "-");

                                                  print(
                                                      "this is the productname${productName}");
                                                  // Unwrap delightful gifts that bring smiles! Visit ${_productDetail.productDetail.productName} at http://byyu.com/product-details/product/${productId} for a curated selection of joy-filled surprises. Make gifting memorable today! 🎁✨
                                                  final result = await Share
                                                      .shareWithResult(
                                                          'Unwrap delightful gifts that bring smiles! Visit ${productName} at https://byyu.com/product-details/${productName}-${productId} for a curated selection of joy-filled surprises. Make gifting memorable today! 🎁✨');

                                                  if (result.status ==
                                                      ShareResultStatus
                                                          .success) {
                                                    print(
                                                        'Thank you for sharing my website!');
                                                  }
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                    bottom: 13,
                                                    right: 8,
                                                  ),
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                      color: ColorConstants
                                                          .colorHomePageSection,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Icon(
                                                    // Icons.ios_share,
                                                    FontAwesomeIcons
                                                        .shareFromSquare,
                                                    // Icons.share_outlined,
                                                    size: 25,
                                                    weight: 0.1,
                                                    opticalSize: 1,
                                                    fill: 0.1,
                                                    color:
                                                        ColorConstants.appColor,
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Container(
                              //   width: MediaQuery.of(context).size.width,
                              //   margin: EdgeInsets.only(left: 8, right: 8),
                              //   height: 80,
                              //   child: Align(
                              //     alignment: Alignment.center,
                              //     child: Padding(
                              //         padding:
                              //             const EdgeInsets.only(bottom: 10),
                              //         child: ListView.builder(
                              //             itemCount: _productImages.length,
                              //             shrinkWrap: true,
                              //             scrollDirection: Axis.horizontal,
                              //             itemBuilder: (context, index) {
                              //               return InkWell(
                              //                 onTap: () {
                              //                   selectedBannerIndex = index;
                              //                   setState(() {});
                              //                 },
                              //                 child: Container(
                              //                     margin: EdgeInsets.only(
                              //                         left: 5, right: 5),
                              //                     decoration: BoxDecoration(
                              //                       border: Border.all(
                              //                         color: selectedBannerIndex ==
                              //                                 index
                              //                             ? ColorConstants
                              //                                 .appColor
                              //                             : ColorConstants
                              //                                 .colorHomePageSectiondim,
                              //                         width: 1,
                              //                       ),
                              //                       borderRadius:
                              //                           BorderRadius.only(
                              //                         topLeft: Radius.circular(
                              //                             100.0),
                              //                         topRight: Radius.circular(
                              //                             100.0),
                              //                         bottomLeft:
                              //                             Radius.circular(10.0),
                              //                         bottomRight:
                              //                             Radius.circular(10.0),
                              //                       ),
                              //                     ),
                              //                     child: Container(
                              //                       width:
                              //                           MediaQuery.of(context)
                              //                                   .size
                              //                                   .width /
                              //                               6,
                              //                       height:
                              //                           MediaQuery.of(context)
                              //                                   .size
                              //                                   .width /
                              //                               5,
                              //                       child: ClipRRect(
                              //                         borderRadius:
                              //                             BorderRadius.only(
                              //                           topLeft:
                              //                               Radius.circular(
                              //                                   100.0),
                              //                           topRight:
                              //                               Radius.circular(
                              //                                   100.0),
                              //                         ),
                              //                         child: Image.network(
                              //                           _productImages[index],
                              //                           cacheWidth: 360,
                              //                           fit: BoxFit.fitWidth,
                              //                           width: MediaQuery.of(
                              //                                       context)
                              //                                   .size
                              //                                   .width /
                              //                               2.1,
                              //                           height: MediaQuery.of(
                              //                                   context)
                              //                               .size
                              //                               .height,
                              //                         ),
                              //                       ),
                              //                     )),
                              //               );
                              //             })),
                              //   ),
                              // ),

                              Padding(
                                padding: const EdgeInsets.only(bottom: 1),
                                child: _productWeightAndQuantity(
                                    textTheme, cartController),
                              ),
                              //_subHeading(textTheme, "About Product"),
                              _productDetail.productDetail!.varient![0].stock ==
                                      0
                                  ? SizedBox(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, bottom: 10),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Currently Out of stock",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontFamily:
                                                    global.fontMontserratLight,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: ColorConstants.appColor),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),

                              // Padding(
                              //   padding: EdgeInsets.only(top: 16, left: 16),
                              //   child: InkWell(
                              //     onTap: () {},
                              //     child: Row(
                              //       children: [
                              //         Text(
                              //           "Ratings & Reviews",
                              //           style: TextStyle(
                              //               fontFamily:
                              //                   global.fontMontserratLight,
                              //               fontWeight: FontWeight.w600,
                              //               fontSize: 16,
                              //               color: ColorConstants.pureBlack),
                              //         ),
                              //         Expanded(child: Text('')),
                              //         Padding(
                              //           padding:
                              //               const EdgeInsets.only(right: 10),
                              //           child: TextButton(
                              //             child: Text(
                              //               "View All",
                              //               style: TextStyle(
                              //                   fontFamily: global
                              //                       .fontRailwayRegular,
                              //                   fontWeight: FontWeight.w200,
                              //                   fontSize: 14,
                              //                   color: ColorConstants
                              //                       .appdimColor),
                              //             ),
                              //             onPressed: () {
                              //               Navigator.of(context).push(
                              //                 MaterialPageRoute(
                              //                   builder: (context) =>
                              //                       RatingListScreen(
                              //                           _productDetail
                              //                               .productDetail
                              //                               .varientId,
                              //                           a: widget.analytics,
                              //                           o: widget.observer),
                              //                 ),
                              //               );
                              //             },
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // _productDetail.ratingReview.length > 0
                              //     ? _ratingAndReviews(textTheme)
                              //     : Container(
                              //         width:
                              //             MediaQuery.of(context).size.width -
                              //                 20,
                              //         child: Text(
                              //           "No reviews yet? \nIt's your chance to be the first star on the gift stage!",
                              //           textAlign: TextAlign.center,
                              //           style: TextStyle(
                              //               fontFamily:
                              //                   global.fontMontserratLight,
                              //               fontSize: 13,
                              //               fontWeight: FontWeight.w200,
                              //               color: ColorConstants.grey),
                              //         ),
                              //       ),
                              Theme(
                                data: ThemeData()
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  tilePadding:
                                      EdgeInsets.only(left: 15, right: 15),
                                  visualDensity: VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  key: Key('section0 ${parent.toString()}'),
                                  childrenPadding: EdgeInsets.only(left: 10),
                                  title: Text(
                                    "About This Product",
                                    style: sectionTextStyle,
                                  ),
                                  initiallyExpanded: parent == 0,
                                  trailing: Icon(
                                    parent == 0 ? Icons.minimize : Icons.add,
                                    size: 20,
                                    color: ColorConstants.appColor,
                                  ),
                                  textColor: ColorConstants.appColor,
                                  collapsedTextColor:
                                      ColorConstants.newTextHeadingFooter,
                                  iconColor: ColorConstants.appColor,
                                  collapsedIconColor: ColorConstants.pureBlack,
                                  onExpansionChanged: (value) {
                                    if (value) {
                                      Duration(seconds: 20000);
                                      parent = 0;
                                    } else {
                                      parent = -1;
                                    }

                                    setState(() {});
                                  },
                                  children: [
                                    Html(
                                      data:
                                          "${_productDetail.productDetail!.description}",
                                      style: {
                                        "body": Style(
                                            fontFamily: fontRailwayRegular,
                                            fontWeight: FontWeight.w200,
                                            fontSize: FontSize(13),
                                            color: ColorConstants.pureBlack)
                                        // Style(color: Theme.of(context).textTheme.bodyText1.color),
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              Theme(
                                data: ThemeData()
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  tilePadding:
                                      EdgeInsets.only(left: 15, right: 15),
                                  visualDensity: VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  key: Key('section1 ${parent.toString()}'),
                                  childrenPadding: EdgeInsets.only(left: 10),
                                  title: Text(
                                    "After Care Instructions",
                                    style: sectionTextStyle,
                                  ),
                                  initiallyExpanded: parent == 1,
                                  trailing: Icon(
                                    parent == 1 ? Icons.minimize : Icons.add,
                                    size: 20,
                                    color: ColorConstants.appColor,
                                  ),
                                  textColor: ColorConstants.appColor,
                                  collapsedTextColor:
                                      ColorConstants.newTextHeadingFooter,
                                  iconColor: ColorConstants.appColor,
                                  collapsedIconColor: ColorConstants.pureBlack,
                                  onExpansionChanged: (value) {
                                    if (value) {
                                      Duration(seconds: 20000);
                                      parent = 1;
                                    } else {
                                      parent = -1;
                                    }

                                    setState(() {});
                                  },
                                  children: [
                                    Html(
                                      data:
                                          "${_productDetail.productDetail!.description}",
                                      style: {
                                        "body": Style(
                                            fontFamily: fontRailwayRegular,
                                            fontWeight: FontWeight.w200,
                                            fontSize: FontSize(13),
                                            color: ColorConstants.pureBlack)
                                        // Style(color: Theme.of(context).textTheme.bodyText1.color),
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              // Theme(
                              //   data: ThemeData()
                              //       .copyWith(dividerColor: Colors.transparent),
                              //   child: ExpansionTile(
                              //     tilePadding:
                              //         EdgeInsets.only(left: 15, right: 15),
                              //     visualDensity: VisualDensity(
                              //         horizontal: 0, vertical: -4),
                              //     key: Key('section2 ${parent.toString()}'),
                              //     childrenPadding: EdgeInsets.only(left: 10),
                              //     title: Text(
                              //       "Need Help?",
                              //       style: sectionTextStyle,
                              //     ),
                              //     initiallyExpanded: parent == 2,
                              //     trailing: Icon(
                              //       parent == 2 ? Icons.minimize : Icons.add,
                              //       size: 20,
                              //       color: ColorConstants.appColor,
                              //     ),
                              //     textColor: ColorConstants.appColor,
                              //     collapsedTextColor:
                              //         ColorConstants.newTextHeadingFooter,
                              //     iconColor: ColorConstants.appColor,
                              //     collapsedIconColor: ColorConstants.pureBlack,
                              //     onExpansionChanged: (value) {
                              //       if (value) {
                              //         Duration(seconds: 20000);
                              //         parent = 2;
                              //       } else {
                              //         parent = -1;
                              //       }

                              //       setState(() {});
                              //     },
                              //     children: [
                              //       Html(
                              //         data:
                              //             "${_productDetail.productDetail!.description}",
                              //         style: {
                              //           "body": Style(
                              //               fontFamily: fontRailwayRegular,
                              //               fontWeight: FontWeight.w200,
                              //               fontSize: FontSize(13),
                              //               color: ColorConstants.pureBlack)
                              //           // Style(color: Theme.of(context).textTheme.bodyText1.color),
                              //         },
                              //       ),
                              //     ],
                              //   ),
                              // ),

                              Padding(
                                padding: EdgeInsets.only(
                                    top: 8, left: 10, right: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      "Similar Products",
                                      style: TextStyle(
                                          fontFamily:
                                              global.fontMontserratLight,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: ColorConstants
                                              .newTextHeadingFooter),
                                    )
                                  ],
                                ),
                              ),
                              _relatedProducts(textTheme),
                              SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 1, left: 16),
                                child: Row(
                                  children: [
                                    Text(
                                      "Frequently Bought Together",
                                      style: TextStyle(
                                          fontFamily:
                                              global.fontMontserratLight,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: ColorConstants.pureBlack),
                                    )
                                  ],
                                ),
                              ),
                              _boughtTogetherProducts(textTheme)

                              // : SizedBox(),
                              // _subHeading(
                              //     textTheme, "Related Products"),
                              // _relatedProducts(textTheme),
                              // _productDetail.productDetail.tags !=
                              //             null &&
                              //         _productDetail.productDetail
                              //                 .tags.length >
                              //             0
                              //     ? _subHeading(textTheme, "Tags")
                              //     : SizedBox(),
                              // _productDetail.productDetail.tags !=
                              //             null &&
                              //         _productDetail.productDetail
                              //                 .tags.length >
                              //             0
                              //     ? _tags(textTheme)
                              //     : SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    )
                  : _shimmer()
              : Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                        ],
                      )
                    ],
                  ),
                ),
          bottomNavigationBar: _isDataLoaded
              ? Container(
                  padding: EdgeInsets.fromLTRB(
                    0,
                    0,
                    0,
                    MediaQuery.of(context).padding.bottom > 0
                        ? MediaQuery.of(context).padding.bottom
                        : 0, // Prevents bottom overlap
                  ),
                  color: ColorConstants.white,
                  height: responseMessage != null && responseMessage!.length > 0
                      ? Platform.isIOS
                          ? responseMessage != null &&
                                  responseMessage!.length > 0
                              ? 100
                              : 70
                          : MediaQuery.of(context).padding.bottom > 0
                              ? 125
                              : 95
                      : Platform.isIOS
                          ? responseMessage != null &&
                                  responseMessage!.length > 0
                              ? 100
                              : 70
                          : MediaQuery.of(context).padding.bottom > 0
                              ? 85
                              : 60,
                  margin: EdgeInsets.only(top: 8, bottom: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: responseMessage != null &&
                            responseMessage!.length > 0,
                        child: Container(
                          margin: EdgeInsets.all(8),
                          child: Text(
                            "$responseMessage",
                            style: TextStyle(
                                fontFamily: global.fontMontserratLight,
                                fontWeight: FontWeight.w200,
                                fontSize: 15,
                                color: ColorConstants.appColor),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IntrinsicWidth(
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.5, color: ColorConstants.appColor),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // width: MediaQuery.of(context).size.width / 2.5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Text(
                                  //   "Quantity",
                                  //   style: TextStyle(
                                  //     fontFamily: global.fontRailwayRegular,
                                  //     fontWeight: FontWeight.w200,
                                  //     fontSize: 16,
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   width: 8,
                                  // ),
                                  _qty != 1 ||
                                          _productDetail
                                                  .productDetail!.cartQty !=
                                              0
                                      ? InkWell(
                                          onTap: () {
                                            print("nikhil");
                                            if (_productDetail
                                                    .productDetail!.cartQty! ==
                                                1) {
                                              addToCartRO(_productDetail
                                                      .productDetail!.cartQty! -
                                                  1);
                                            } else {
                                              if (_qty > 1) {
                                                _qty = _qty - 1;
                                              }
                                            }

                                            setState(() {});
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(right: 5),
                                            width: 35,
                                            height: 35,
                                            child: _productDetail.productDetail!
                                                            .cartQty !=
                                                        null &&
                                                    _productDetail
                                                            .productDetail!
                                                            .cartQty ==
                                                        1
                                                ? Icon(
                                                    FontAwesomeIcons.trashCan,
                                                    size: 20.0,
                                                    color: ColorConstants
                                                        .newTextHeadingFooter,
                                                  )
                                                : Icon(
                                                    MdiIcons.minus,
                                                    size: 25.0,
                                                    color: ColorConstants
                                                        .newTextHeadingFooter,
                                                  ),
                                          ),
                                        )
                                      : Container(),
                                  _productDetail.productDetail!.cartQty != 0 ||
                                          _qty != 0
                                      ? SizedBox(
                                          width: 8,
                                        )
                                      : Container(),
                                  Text(
                                    _productDetail.productDetail!.cartQty != 0
                                        ? "${_productDetail.productDetail!.cartQty}"
                                        : "${_qty}",
                                    style: TextStyle(
                                      fontFamily: global.fontOufitMedium,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 16,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (_productDetail
                                              .productDetail!.cartQty !=
                                          0) {
                                        _productDetail.productDetail!.cartQty =
                                            _productDetail
                                                    .productDetail!.cartQty! +
                                                1;
                                      } else {
                                        _qty = _qty + 1;
                                      }
                                      setState(() {});
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: 5),
                                      width: 35,
                                      height: 35,
                                      child: Icon(
                                        MdiIcons.plus,
                                        size: 25,
                                        color:
                                            ColorConstants.newTextHeadingFooter,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(child: Text('')),
                          IntrinsicWidth(
                            child: InkWell(
                              onTap: () {
                                print("Nikhil-----this is on pressed");
                                if (addCartText == "GO TO CART") {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    useRootNavigator: true,
                                    backgroundColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    builder: (context) => CartBottomSheet(
                                      analytics: widget.analytics,
                                      observer: widget.observer,
                                      fromNavigationBar: true,
                                    ),
                                  );
                                } else {
                                  callAddToCartApi("ADDTOCART");
                                }
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 2, right: 2),
                                child: Container(
                                  height: 35,
                                  width:
                                      MediaQuery.of(context).size.width / 2.2,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: ColorConstants.appColor,
                                      border: Border.all(
                                          width: 0.5,
                                          color: ColorConstants.appColor)),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      // _productDetail.productDetail.cartQty != 0
                                      //     ? "GO TO CART"
                                      // :
                                      addCartText,
                                      style: TextStyle(
                                          fontFamily: fontMontserratMedium,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: ColorConstants.white,
                                          letterSpacing: 1),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          )
                        ],
                      ),
                    ],
                  ),
                )
              : Container(
                  height: 1,
                ),
        ));
  }

  @override
  void initState() {
    super.initState();
    global.routingProductID = 0;
    global.total_delivery_count = 1;
    print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA${isFrom}");
    _init();
  }

  showBottomSheet() {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.width / 2.5,
          decoration: const BoxDecoration(
              color: ColorConstants.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25), topLeft: Radius.circular(25))),
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                      _isDataLoaded
                          ? "${_productDetail.productDetail!.productName} "
                          : "", //coupon.couponName,
                      maxLines: 1,
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: ColorConstants.pureBlack,
                          fontFamily: global.fontRailwayRegular,
                          fontWeight: FontWeight.w600,
                          fontSize: 16)),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                      _isDataLoaded
                          ? "Quantity: ${_productDetail.productDetail!.cartQty != 0 ? _productDetail.productDetail!.cartQty : _qty} "
                          : "", //coupon.couponName,
                      maxLines: 1,
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: ColorConstants.pureBlack,
                          fontFamily: global.fontRailwayRegular,
                          fontWeight: FontWeight.w200,
                          fontSize: 13)),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "${responseMessage}", //"${coupon.couponCode}",
                    maxLines: 4,

                    style: TextStyle(
                        color: ColorConstants.pureBlack,
                        fontSize: 14,
                        fontFamily: global.fontRailwayRegular,
                        fontWeight: FontWeight.w200),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => AllCategoriesScreen(
                                      a: widget.analytics,
                                      o: widget.observer,
                                    )),
                          );
                        },
                        child: Container(
                          height: 25, // height * 0.044,
                          width: MediaQuery.of(context).size.width / 2.2,
                          margin: EdgeInsets.only(bottom: 8, top: 5),
                          child: Center(
                              child: Text('EXPLORE MORE',
                                  style: TextStyle(
                                    fontFamily: fontRailwayRegular,
                                    color: ColorConstants.appGoldenColortint,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ))),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            border: Border.all(
                                width: 0.5,
                                color: ColorConstants.appGoldenColortint),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          global.routingProductID = 0;
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                    selectedIndex: 2,
                                  )));
                        },
                        child: Container(
                          height: 25, // height * 0.044,
                          width: MediaQuery.of(context).size.width / 2.2,
                          margin: EdgeInsets.only(bottom: 8, top: 5),
                          child: Center(
                              child: Text('GO TO CART',
                                  style: TextStyle(
                                    fontFamily: fontRailwayRegular,
                                    color: ColorConstants.appColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ))),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            border: Border.all(
                                width: 0.5, color: ColorConstants.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // : SizedBox(height: 0)
              ],
            ),
          ),
        );
      },
    );
  }

  String _parseHtmlString(String htmlString) {
    var document = parse(htmlString);

    String parsedString = parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  _getEventsList() async {
    print("Nikhil prod Desc---------------------------- eventslist");
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        await apiHelper.getEventsList().then((result) async {
          if (result != null) {
            List<EventsData> _tList = result.data;
            if (_tList.isEmpty) {
              //_isRecordPending = false;
            }

            _eventsList.addAll(_tList);
          }
        });
      }
    } catch (e) {
      print("Exception - all_categories_screen.dart - _getEventsList():" +
          e.toString());
    }
  }

  List<TimeSlotsDetails> timeSlots1 = [];
  bool callTimeslotAPI = false;
  String timeSlotNotAvailable = "";
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
            .getTimeSlots(productId!, selectedDate)
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

  _getProductDetail(productId) async {
    isOccasionSelected = false;
    isMessageSelected = false;
    expressSelected = false;
    sameDay = false;
    nextDay = false;
    todaySelected = false;
    tomorrowSelected = false;
    dateSelected = false;

    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        await apiHelper
            .getProductDetail(productId, global.isSubscription!)
            .then((result) async {
          if (result != null) {
            if (result.status == "1") {
              setState(() {
                _productDetail = _productDetail;
                _productDetail = result.data;
                _productImages.clear();
                cakeDropDown.clear();

                // _productImages.add("${global.imageBaseUrl}" +
                //     _productDetail.productDetail.thumbnail);
                print(_productDetail.eventsDetail.toString());
                for (int i = 0;
                    i < _productDetail.productDetail!.images!.length;
                    i++) {
                  _productImages.add("${global.imageBaseUrl}" +
                      _productDetail.productDetail!.images![i].image! +
                      "?width=800&height=800");
                }
                // for (int i = 0;
                //     i < _productDetail.productDetail!.images!.length;
                //     i++) {
                //   _productImages.add("${global.imageBaseUrl}" +
                //       _productDetail.productDetail!.images![i].image!);
                // }

                if (_productDetail.productDetail!.productStartDate != null) {
                  if (DateTime.now().isAfter(DateTime.tryParse(
                      _productDetail.productDetail!.productStartDate!)!)) {
                    isCurrentDateLess = false;
                  } else {
                    isCurrentDateLess = true;
                  }
                }
                if (_productDetail.productDetail!.productEndDate != null) {
                  if (DateTime.now().isAfter(DateTime.tryParse(
                      _productDetail.productDetail!.productEndDate!)!)) {
                    isEndDatePassed = true;
                  } else {
                    isEndDatePassed = false;
                  }
                }

                for (int i = 0;
                    i < _productDetail.productDetail!.varient!.length;
                    i++) {
                  cakeSize.add(
                      "${_productDetail.productDetail!.varient![i].quantity} ${_productDetail.productDetail!.varient![i].unit}");
                }
                for (int i = 0; i < cakeSize.length; i++) {
                  cakeDropDown.add(
                      DropDownValueModel(value: "${i}", name: cakeSize[i]));
                }
                if (_productDetail.productDetail!.flavour != null &&
                    _productDetail.productDetail!.flavour!.length > 0) {
                  for (int i = 0;
                      i < _productDetail.productDetail!.flavour!.length;
                      i++) {
                    if (_productDetail.productDetail!.flavour![i].name !=
                            null &&
                        _productDetail.productDetail!.flavour![i].name!
                                .trim()
                                .length >
                            0) {
                      flavourDropDown.add(DropDownValueModel(
                          value: "${i}",
                          name:
                              _productDetail.productDetail!.flavour![i].name!));
                      print(flavourDropDown[i]);
                    }
                  }
                }
                _productDetail.productDetail!.vegOrNonveg = 0;
                if (_productDetail.productDetail!.eggEggless != null &&
                    _productDetail.productDetail!.eggEggless!.length > 0) {
                  for (int i = 0;
                      i < _productDetail.productDetail!.eggEggless!.length;
                      i++) {
                    print(_productDetail.productDetail!.vegOrNonveg);
                    if (_productDetail.productDetail!.eggEggless![i]
                            .toLowerCase()
                            .trim() ==
                        "egg") {
                      _productDetail.productDetail!.vegOrNonveg =
                          _productDetail.productDetail!.vegOrNonveg! + 1;
                      print(_productDetail.productDetail!.vegOrNonveg);
                    } else if (_productDetail.productDetail!.eggEggless![i]
                            .toLowerCase()
                            .trim() ==
                        "eggless") {
                      if (_productDetail.productDetail!.vegOrNonveg! > 0) {
                        _productDetail.productDetail!.vegOrNonveg =
                            _productDetail.productDetail!.vegOrNonveg! + 2;
                      } else {
                        _productDetail.productDetail!.vegOrNonveg =
                            _productDetail.productDetail!.vegOrNonveg! + 2;
                      }

                      print(_productDetail.productDetail!.vegOrNonveg);
                    }
                  }
                }

                FirebaseAnalyticsGA4().callAnalyticsProductDetail(
                    _productDetail.productDetail!.productId!,
                    _productDetail.productDetail!.productName!,
                    '',
                    _productDetail.productDetail!.varientId!,
                    '',
                    _productDetail.productDetail!.price!,
                    _productDetail.productDetail!.mrp!,
                    0);
                if (_productDetail.otherDetails!.length > 0) {
                  for (int i = 0;
                      i < _productDetail.otherDetails!.length;
                      i++) {
                    if (_productDetail.otherDetails![i].fieldType!
                            .toLowerCase() ==
                        "text") {
                      otherDetailsTextLength = otherDetailsTextLength + 1;
                    } else if (_productDetail.otherDetails![i].fieldType!
                            .toLowerCase() ==
                        "image") {
                      otherDetailsImageLength = otherDetailsImageLength + 1;
                    }
                  }
                }
                if (int.parse(_productDetail.productDetail!.delivery!) >= 3 &&
                    !isCurrentDateLess) {
                  print("11111111111111111");
                  nextDay = true;
                  _selectedDate = DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day +
                          (int.parse(_productDetail.productDetail!.delivery!) >
                                  2
                              ? int.parse(
                                      _productDetail.productDetail!.delivery!) -
                                  2
                              : 1));
                  callTimeslotAPI = true;
                  _getTimeSlots(
                      global.monthInIntFormt.format(_selectedDate!), false);
                } else if (isCurrentDateLess &&
                    !isEndDatePassed &&
                    _productDetail.productDetail!.productStartDate != null) {
                  print("22222222222");
                  callTimeslotAPI = true;
                  _selectedDate = DateTime.tryParse(
                      _productDetail.productDetail!.productStartDate!);
                  selectedDate = DateTime.tryParse(
                          _productDetail.productDetail!.productStartDate!)
                      .toString();

                  _getTimeSlots(
                      global.monthInIntFormt.format(_selectedDate!), false);
                } else {
                  print("3333333333");

                  callTimeslotAPI = true;
                  _selectedDate = DateTime(DateTime.now().year,
                      DateTime.now().month, DateTime.now().day);
                }
                // if (_productDetail.productDetail!.cartQty! >= 1) {
                //   // addCartText = "GO TO CART";
                // }
                _isDataLoaded = true;
              });
            } else {
              _isDataLoaded = false;
              // _productDetail = null;
              Fluttertoast.showToast(
                msg: "Something went wrong please try again", // message
                toastLength: Toast.LENGTH_SHORT, // length
                gravity: ToastGravity.CENTER, // location
                // duration
              );
            }
          }
        });
      } else {
        showNetworkErrorSnackBar1(_scaffoldKey);
      }
    } catch (e) {
      print(
          "Exception -  product_description_screen.dart - _getProductDetail()bb:" +
              e.toString());
    }
  }

  List<String> cakeSize = [];

  List<String> timeSlots = [];

  List<DropDownValueModel> cakeDropDown = [];
  List<DropDownValueModel> timeSlotsDropDown = [];
  List<DropDownValueModel> flavourDropDown = [];

  _init() async {
    try {
      // if (screenId == 0) {
      //   await _getBannerProductDetail();
      // } else if (productDetail != null) {
      //   _productDetail = productDetail;
      // } else {
      //   await _getProductDetail();
      // }
      //_addCakeDataToDropDown();
      _eventsList.clear();
      //await _getEventsList;

      await _getProductDetail(productId);

      //_isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception -  init product_description_screen.dart - _init():" +
          e.toString());
    }
  }

  List<EventsData> _eventsList = [];
  showOnlyLoaderDialog() {
    return showDialog(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          child: Center(
              child: new CircularProgressIndicator(
            strokeWidth: 4,
          )),
        );
      },
    );
  }

  void hideloadershowing() {
    Navigator.pop(context);
  }

  String addCartText = "ADD To CART";
  callAddToCartApi(String clickedFrom) async {
    bool allDataSet = false;
    try {
      bool isConnected = await br!.checkConnectivity();
      // if (int.parse(_productDetail.productDetail!.delivery!) >= 1 &&
      //     !expressSelected &&
      //     !sameDay &&
      //     !nextDay) {
      //   allDataSet = false;
      //   boolDeliveryTypeErrorShow = true;
      //   _scrollController1.animateTo(450,
      //       duration: Duration(milliseconds: 10), curve: Curves.ease);
      //   setState(() {});
      // } else if (_selectedDate == null && nextDay) {
      //   allDataSet = false;
      //   _scrollController1.animateTo(650,
      //       duration: Duration(milliseconds: 10), curve: Curves.ease);
      //   boolDeliverySlotErrorShow = true;
      //   setState(() {});
      // } else if (timeSlotsDropDown.length == 0 && sameDay) {
      //   allDataSet = false;
      //   boolDeliveryTypeErrorShow = true;
      //   strDeliveryTypeErrorShow =
      //       "Choose Delivery Type to Next Day to Choose Delivery Time Slot";
      //   _scrollController1.animateTo(450,
      //       duration: Duration(milliseconds: 10), curve: Curves.ease);
      //   setState(() {});
      // } else if (_selectedTime == null && sameDay) {
      //   allDataSet = false;
      //   boolDeliverySlotErrorShow = true;
      //   strDeliverySlotErrorShow = "Required*";
      //   _scrollController1.animateTo(650,
      //       duration: Duration(milliseconds: 10), curve: Curves.ease);
      //   setState(() {});
      // } else if (_selectedTime == null && nextDay) {
      //   allDataSet = false;
      //   boolDeliverySlotErrorShow = true;
      //   strDeliverySlotErrorShow = "Required*";
      //   _scrollController1.animateTo(650,
      //       duration: Duration(milliseconds: 10), curve: Curves.ease);
      //   setState(() {});
      // } else if (int.parse(_productDetail.productDetail!.delivery!) >= 2 &&
      //     sameDay) {
      //   DateTime date = DateTime.now();
      //   selectedDate = global.monthInIntFormt.format(date);

      //   allDataSet = true;
      // } else if (expressSelected) {
      //   DateTime date = DateTime.now();
      //   var currTime = date.add(Duration(minutes: 60));
      //   _selectedTime =
      //       global.hourMinTime.format(date.add(Duration(minutes: 60)));
      //   selectedDate = global.monthInIntFormt.format(date);
      //   allDataSet = true;
      // } else {
      //   allDataSet = true;
      // }
      if (isConnected) {
        if (true) {
          showOnlyLoaderDialog();
          print("All Set If Condition Product id---------${productId}");
          print("All Set If Condition _qty---------${_qty}");
          print(
              "All Set If Condition Product id---------${_productDetail.productDetail!.cartQty}");
          print(
              "All Set If Condition selectedDate----- ${_selectedDate}----${_selectedDate == null ? selectedDate : _selectedDate}");
          print("All Set If Condition selectedTime---------${_selectedTime}");
          List<PersonalizedTextList> personalizedTextList = [];
          List<PersonalizedImagesList> personalizedImageList = [];

          for (int i = 0; i < _productDetail.otherDetails!.length; i++) {
            if (_productDetail.otherDetails![i].fieldType!.toLowerCase() ==
                    "text" ||
                _productDetail.otherDetails![i].fieldType!.toLowerCase() ==
                    "date") {
              if (_productDetail.otherDetails![i].setTextValue != null) {
                personalizedTextList.add(new PersonalizedTextList(
                    name: _productDetail.otherDetails![i].fieldValue,
                    value: _productDetail.otherDetails![i].setTextValue));
              }
            } else if (_productDetail.otherDetails![i].fieldType!
                    .toLowerCase() ==
                "image") {
              if (_productDetail.otherDetails![i].setImagePath != null) {
                personalizedImageList.add(new PersonalizedImagesList(
                    name: _productDetail.otherDetails![i].fieldValue,
                    value: _productDetail.otherDetails![i].setImagePath!.path
                        .toString()));
              }
            }
          }
          await apiHelper
              .addToCart(
                  qty: _productDetail.productDetail!.cartQty != null &&
                          _productDetail.productDetail!.cartQty! > 0
                      ? _productDetail.productDetail!.cartQty
                      : _qty,
                  varientId: _productDetail
                      .productDetail!.varient![varientIndex].varientId,
                  special: 0,
                  repeat_orders: "No",
                  deliveryDate: "",
                  deliveryTime: "",
                  deliveryType: expressSelected
                      ? 1
                      : sameDay
                          ? 2
                          : nextDay
                              ? 3
                              : 3,
                  userMessage: selectedOccasionString.text,
                  personalizedText: personalizedTextList.length > 0
                      ? personalizedTextList
                      : null,
                  perosonalizedImages: personalizedImageList.length > 0
                      ? personalizedImageList
                      : null,
                  eggEggless: eggEgglessType,
                  flavour: _selectedFlavour)
              .then((result) async {
            if (result != null) {
              if (result.status == "1") {
                FirebaseAnalyticsGA4().callAnalyticsAddCart(
                    _productDetail.productDetail!.productId!,
                    _productDetail.productDetail!.productName!,
                    "",
                    _productDetail.productDetail!.varientId!,
                    '',
                    _productDetail.productDetail!.price!,
                    _qty,
                    _productDetail.productDetail!.mrp!,
                    true,
                    false);
                if (clickedFrom == "BUYNOW") {
                  hideloadershowing();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => HomeScreen(
                            a: widget.analytics,
                            o: widget.observer,
                            selectedIndex: 2,
                          )));
                } else if (clickedFrom == "BUYNOWLOGIN") {
                  hideloadershowing();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => LoginScreen(
                              a: widget.analytics,
                              o: widget.observer,
                              logout: false,
                            )),
                  );
                } else {
                  //hideloadershowing();
                  hideloadershowing();
                  addCartText = "GO TO CART";
                  if (_productDetail.productDetail!.cartQty != null &&
                      _productDetail.productDetail!.cartQty! > 0) {
                    global.cartCount = global.cartCount;
                  } else {
                    global.cartCount = global.cartCount + 1;
                  }

                  //await cartController.getCartList();
                  // showSheet = true;

                  // showBottomSheet();

                  responseMessage = "Product added to your cart";
                  print(
                      "totalprice------------------------------${_productDetail.productDetail!.cartQty! * _productDetail.productDetail!.price!}");
                  print(
                      "cartqty------------------------------${_productDetail.productDetail!.cartQty!}");
                  print("qty------------------------------${_qty}");
                  print(
                      "price------------------------------${_productDetail.productDetail!.price!}");
                  setState(() {
                    //  Navigator.of(context).push(
                    // MaterialPageRoute(
                    //     builder: (context) => BuyTogetherScreen(
                    //           a: widget.analytics,
                    //           o: widget.observer,
                    //           totalCartPrice: _productDetail.productDetail!.cartQty!=null?(_qty*_productDetail.productDetail!.price!):0,
                    //         )));
                  });
                }
              } else {
                hideloadershowing();
                responseMessage = result.message;
                setState(() {});
              }
            } else {
              hideloadershowing();
              responseMessage = "Something went wrong";

              setState(() {});
            }
          });
        }
      } else {
        hideloadershowing();
        showNetworkErrorSnackBar1(_scaffoldKey);
      }
    } catch (e) {
      hideloadershowing();
      print(
          "Exception -  product_description_screen.dart Add To Cart- _getProductDetail()cc:" +
              e.toString());
    }
  }

  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  int eventListSelectedIndex = 0;
  int? messageListSeletedIndex;
  bool isEggLess = false;
  bool iswithEgg = false;
  String _selectedFlavour = "";
  String eggEgglessType = "";
  //TextEditingController selectedOccasionString = TextEditingController();
  var selectedOccasionString = new TextEditingController();
  int? parent = 0;
  TextStyle sectionTextStyle = TextStyle(
      fontFamily: global.fontRalewayMedium,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: ColorConstants.newTextHeadingFooter);

  Widget _productWeightAndQuantity(TextTheme textTheme, CartController value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _productDetail.productDetail!.vegOrNonveg != null &&
                  _productDetail.productDetail!.vegOrNonveg! != 0 &&
                  _productDetail.productDetail!.vegOrNonveg! <= 2
              ? Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(right: 10, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      (_productDetail.productDetail!.vegOrNonveg != null &&
                              _productDetail.productDetail!.vegOrNonveg == 1)
                          ? Image.asset(
                              "assets/images/iv_veg_symbol.png",
                              height: 35,
                              width: 35,
                            )
                          : _productDetail.productDetail!.vegOrNonveg != null &&
                                  _productDetail.productDetail!.vegOrNonveg == 2
                              ? Image.asset(
                                  "assets/images/iv_nonveg_symbol.png",
                                  height: 35,
                                  width: 35,
                                )
                              : SizedBox(),
                    ],
                  ),
                )
              : SizedBox(
                  height: 15,
                ),
          // SizedBox(
          //   height: 10,
          // ),

          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'AED ', textAlign: TextAlign.center,
                  //${_productDetail.productDetail.varient[i].quantity} ${_productDetail.productDetail.varient[i].unit} /
                  style: TextStyle(
                      fontFamily: global.fontOufitMedium,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      color: ColorConstants.pureBlack),
                ),
                //nikhillllll
                SizedBox(
                  width: 5,
                ),
                Text(
                  _productDetail.productDetail!.varient![varientIndex]
                              .basePrice !=
                          null
                      ? int.parse(_productDetail.productDetail!
                                  .varient![varientIndex].basePrice
                                  .toString()
                                  .substring(_productDetail.productDetail!
                                          .varient![varientIndex].basePrice
                                          .toString()
                                          .indexOf(".") +
                                      1)) >
                              0
                          ? ' ${_productDetail.productDetail!.varient![varientIndex].basePrice!.toStringAsFixed(2)}'
                          : "${_productDetail.productDetail!.varient![varientIndex].basePrice.toString().substring(0, _productDetail.productDetail!.varient![varientIndex].basePrice.toString().indexOf("."))}"
                      : "${_productDetail.productDetail!.basePrice!.toStringAsFixed(2)}",
                  //${_productDetail.productDetail.varient[i].quantity} ${_productDetail.productDetail.varient[i].unit} /
                  style: TextStyle(
                      fontFamily: global.fontOufitMedium,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      color: ColorConstants.pureBlack),
                ),
                _productDetail.productDetail!.varient![varientIndex]
                                .basePrice !=
                            null &&
                        _productDetail.productDetail!.varient![varientIndex]
                                .baseMrp !=
                            null &&
                        _productDetail.productDetail!.varient![varientIndex]
                                .baseMrp! <
                            _productDetail.productDetail!.varient![varientIndex]
                                .basePrice!
                    ? SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Stack(children: [
                          Container(
                            child: Text(
                              _productDetail.productDetail!
                                          .varient![varientIndex].baseMrp
                                          .toString()
                                          .contains(".") &&
                                      int.parse(_productDetail.productDetail!
                                              .varient![varientIndex].baseMrp
                                              .toString()
                                              .substring(_productDetail
                                                      .productDetail!
                                                      .varient![varientIndex]
                                                      .baseMrp
                                                      .toString()
                                                      .indexOf(".") +
                                                  1)) >
                                          0
                                  ? "( ${_productDetail.productDetail!.varient![varientIndex].baseMrp!.toStringAsFixed(2)} )"
                                  : "( ${_productDetail.productDetail!.varient![varientIndex].baseMrp.toString().substring(0, _productDetail.productDetail!.varient![varientIndex].baseMrp.toString().indexOf("."))} )", //"${product.varient[0].baseMrp}",
                              style: TextStyle(
                                  fontFamily: global.fontOufitMedium,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                  color: ColorConstants.newColorBlack),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 11),
                            alignment: Alignment.center,
                            // decoration: BoxDecoration(
                            //     color: Colors.white.withOpacity(0.6),
                            //     borderRadius: BorderRadius.circular(5)),
                            //padding: const EdgeInsets.all(5),
                            child: Center(
                              child: Transform.rotate(
                                angle: 0,
                                child: Text(
                                  "----",
                                  // '${AppLocalizations.of(context).txt_out_of_stock}',
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontFamily: global.fontRailwayRegular,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20,
                                      color: ColorConstants.newColorBlack),
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                Spacer(),

                Container(
                  // color: ColorConstants.,
                  margin: EdgeInsets.only(left: 8, right: 10),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Earliest Delivery:",
                        style: TextStyle(
                            fontFamily: global.fontRalewayMedium,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: ColorConstants.pureBlack),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: ColorConstants.colorHomePageSection),
                          child: _productDetail.productDetail!.delivery !=
                                          null &&
                                      _productDetail.productDetail!.delivery ==
                                          "1" ||
                                  _productDetail.productDetail!.delivery ==
                                      "Today"
                              ? Text(
                                  "Express",
                                  style: TextStyle(
                                      fontFamily: global.fontRailwayRegular,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 12,
                                      color: ColorConstants.colorAllHomeTitle),
                                )
                              : _productDetail.productDetail!.delivery !=
                                              null &&
                                          _productDetail
                                                  .productDetail!.delivery ==
                                              "2" ||
                                      _productDetail.productDetail!.delivery ==
                                          "Tomorrow"
                                  ? Text(
                                      "Today",
                                      style: TextStyle(
                                          fontFamily: global.fontRailwayRegular,
                                          fontWeight: FontWeight.w200,
                                          fontSize: 12,
                                          color:
                                              ColorConstants.colorAllHomeTitle),
                                    )
                                  : _productDetail.productDetail!.delivery !=
                                              null &&
                                          _productDetail
                                                  .productDetail!.delivery ==
                                              "3"
                                      ? Text(
                                          "Tomorrow",
                                          style: TextStyle(
                                              fontFamily:
                                                  global.fontRailwayRegular,
                                              fontWeight: FontWeight.w200,
                                              fontSize: 12,
                                              color: ColorConstants
                                                  .colorAllHomeTitle),
                                        )
                                      : Text(
                                          "${int.parse(_productDetail.productDetail!.delivery!) - 2} days",
                                          style: TextStyle(
                                              fontFamily:
                                                  global.fontRailwayRegular,
                                              fontWeight: FontWeight.w200,
                                              fontSize: 12,
                                              color: ColorConstants.pureBlack),
                                        )),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 15,
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            width: MediaQuery.of(context).size.width - 20,
            child: Text(
              _productDetail.productDetail!.productName.toString().capitalize!,
              // overflow: TextOverflow.ellipsis,
              // maxLines: 1,
              style: TextStyle(
                  fontFamily: global.fontRailwaySemibold,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.black),
            ),
          ),

          SizedBox(
            height: 14.5,
          ),
          // Container(
          //     height: 1,
          //     margin: EdgeInsets.only(left: 10, right: 10),
          //     color: ColorConstants.newTextHeadingFooter),
          // SizedBox(
          //   height: 4.5,
          // ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: false,
                child: Container(
                  margin: EdgeInsets.only(left: 10, bottom: 15),
                  padding: EdgeInsets.all(3),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 15,
                        color: ColorConstants.StarRating,
                      ),
                      RichText(
                        text: TextSpan(
                          text: "${_productDetail.productDetail!.rating} ",
                          style: TextStyle(
                              color: ColorConstants.white,
                              fontFamily: global.fontRailwayRegular,
                              fontWeight: FontWeight.w200,
                              fontSize: 14),
                          children: [
                            TextSpan(
                              text: '|',
                              style: TextStyle(
                                  color: ColorConstants.white,
                                  fontFamily: global.fontRailwayRegular,
                                  fontWeight: FontWeight.w200,
                                  fontSize: 14),
                            ),
                            TextSpan(
                              text:
                                  ' ${_productDetail.productDetail!.ratingCount} Reviews',
                              style: TextStyle(
                                  color: ColorConstants.white,
                                  fontFamily: global.fontRailwayRegular,
                                  fontWeight: FontWeight.w200,
                                  fontSize: 14),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 4,
          ),

          // _productDetail.productDetail!.description != null
          //     ? Container(
          //         margin: EdgeInsets.only(left: 10, right: 10),
          //         child: SizedBox(
          //           height: 18,
          //           child: SingleChildScrollView(
          //             physics: NeverScrollableScrollPhysics(),
          //             child: HtmlWidget(
          //               _productDetail.productDetail!.description!,
          //               textStyle: TextStyle(
          //                   overflow: TextOverflow.ellipsis,
          //                   fontFamily: fontRailwayRegular,
          //                   fontWeight: FontWeight.w400,
          //                   fontSize: 14,
          //                   color: ColorConstants.pureBlack),
          //             ),
          //           ),
          //         ))
          //     : SizedBox(),

          _productDetail.deliveryInformation != null &&
                  _productDetail.deliveryInformation!.length > 0 &&
                  _productDetail.deliveryInformation![0].productRowsName !=
                      null &&
                  _productDetail.deliveryInformation![0].productRowsName!
                          .trim()
                          .length >
                      0
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      EdgeInsets.only(top: 10, bottom: 5, right: 10, left: 10),
                  child: Text(
                    "Delivery Information",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: global.fontMontserratLight,
                        fontWeight: FontWeight.w300,
                        fontSize: 15,
                        color: ColorConstants.pureBlack),
                  ),
                )
              : SizedBox(),
          _productDetail.deliveryInformation != null &&
                  _productDetail.deliveryInformation!.length > 0 &&
                  _productDetail.deliveryInformation![0].productRowsName !=
                      null &&
                  _productDetail.deliveryInformation![0].productRowsName!
                          .trim()
                          .length >
                      0
              ? Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Html(
                    data: _productDetail.deliveryInformation!.length > 0 &&
                            _productDetail
                                    .deliveryInformation![0].productRowsName !=
                                null
                        ? "${_productDetail.deliveryInformation![0].productRowsName}"
                        : "",
                    style: {
                      "body": Style(
                          fontFamily: fontRailwayRegular,
                          fontWeight: FontWeight.w300,
                          fontSize: FontSize.medium,
                          color: ColorConstants.pureBlack)
                      // Style(color: Theme.of(context).textTheme.bodyText1.color),
                    },
                  ),
                )
              : SizedBox(),

          (_productDetail.productDetail!.varient!.length > 1 ||
                  _productDetail.productDetail!.vegOrNonveg != null &&
                      _productDetail.productDetail!.vegOrNonveg! > 0 ||
                  _productDetail.productDetail!.flavour != null &&
                      _productDetail.productDetail!.flavour!.length > 0)
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                  child: Column(
                    children: [
                      _productDetail.productDetail!.varient!.length > 1
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(top: 5, bottom: 5),
                              child: Text(
                                "Select Variant",
                                style: TextStyle(
                                    fontFamily: global.fontRailwaySemibold,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: ColorConstants.pureBlack),
                              ),
                            )
                          : SizedBox(),
                      SizedBox(
                        height:
                            _productDetail.productDetail!.varient!.length > 1
                                ? 10
                                : 0,
                      ),
                      _productDetail.productDetail!.varient!.length > 1
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width / 4,
                              padding: EdgeInsets.only(top: 8, bottom: 8),
                              color: ColorConstants.white,
                              child: ListView.builder(
                                  itemCount: _productDetail
                                      .productDetail!.varient!.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        addCartText = "ADD To CART";
                                        responseMessage = "";
                                        varientIndex = index;
                                        selectedVarientIndex = index;

                                        setState(() {});
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.only(left: 8, right: 8),
                                        margin:
                                            EdgeInsets.only(left: 5, right: 5),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: selectedVarientIndex == index
                                                ? ColorConstants.appColor
                                                : ColorConstants.white,
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(2),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  5,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  6,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: Image.network(
                                                  global.imageBaseUrl +
                                                      _productDetail
                                                          .productDetail!
                                                          .productImage! +
                                                      "?width=500&height=500",
                                                  cacheWidth: 360,
                                                  fit: BoxFit.cover,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.9,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      2,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    _productDetail
                                                            .productDetail!
                                                            .varient![index]
                                                            .quantity
                                                            .toString() +
                                                        " " +
                                                        _productDetail
                                                            .productDetail!
                                                            .varient![index]
                                                            .unit
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontFamily: global
                                                            .fontRailwayRegular,
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        fontSize: 13,
                                                        color: ColorConstants
                                                            .pureBlack),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  child: Text(
                                                    "AED " +
                                                        _productDetail
                                                            .productDetail!
                                                            .varient![index]
                                                            .basePrice!
                                                            .toStringAsFixed(2),
                                                    style: TextStyle(
                                                        fontFamily: global
                                                            .fontOufitMedium,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14,
                                                        color: ColorConstants
                                                            .pureBlack),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            )
                          : SizedBox(),
                      SizedBox(
                        height:
                            _productDetail.productDetail!.varient!.length > 1
                                ? 10
                                : 0,
                      ),
                      Visibility(
                        visible:
                            _productDetail.productDetail!.vegOrNonveg != null &&
                                _productDetail.productDetail!.vegOrNonveg! > 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 1, bottom: 1),
                              child: Text(
                                "Choose Type",
                                style: TextStyle(
                                    fontFamily: global.fontRailwaySemibold,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    //color: ColorConstants.pureBlack
                                    color: Colors.black),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Visibility(
                                visible:
                                    _productDetail.productDetail!.vegOrNonveg !=
                                            null &&
                                        (_productDetail.productDetail!
                                                    .vegOrNonveg ==
                                                1 ||
                                            _productDetail.productDetail!
                                                    .vegOrNonveg ==
                                                3),
                                child: InkWell(
                                  onTap: () {
                                    isEggLess = false;
                                    iswithEgg = true;
                                    if (_productDetail
                                            .productDetail!.vegOrNonveg ==
                                        2) {
                                      eggEgglessType = _productDetail
                                          .productDetail!.eggEggless![0];
                                    } else if (_productDetail
                                            .productDetail!.vegOrNonveg ==
                                        3) {
                                      if (_productDetail
                                              .productDetail!.eggEggless![0] ==
                                          "egg") {
                                        eggEgglessType = _productDetail
                                            .productDetail!.eggEggless![0];
                                      } else {
                                        eggEgglessType = _productDetail
                                            .productDetail!.eggEggless![1];
                                      }
                                    }
                                    setState(() {});
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, top: 5, bottom: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            width: 1,
                                            color: iswithEgg
                                                ? ColorConstants.appColor
                                                : ColorConstants
                                                    .colorPageBackground)),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/iv_nonveg_symbol.png',
                                          width: 25,
                                          height: 25,
                                          fit: BoxFit.fill,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "With Egg",
                                          style: TextStyle(
                                              fontFamily:
                                                  global.fontRailwayRegular,
                                              fontWeight: FontWeight.w200,
                                              fontSize: 14,
                                              //color: ColorConstants.pureBlack
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                            SizedBox(width: 10),
                            // // // // // // ParNiks
                            Visibility(
                                visible:
                                    _productDetail.productDetail!.vegOrNonveg !=
                                            null &&
                                        (_productDetail.productDetail!
                                                    .vegOrNonveg ==
                                                2 ||
                                            _productDetail.productDetail!
                                                    .vegOrNonveg ==
                                                3),
                                child: InkWell(
                                  onTap: () {
                                    isEggLess = true;
                                    iswithEgg = false;
                                    if (_productDetail
                                            .productDetail!.vegOrNonveg ==
                                        2) {
                                      eggEgglessType = _productDetail
                                          .productDetail!.eggEggless![0];
                                    } else if (_productDetail
                                            .productDetail!.vegOrNonveg ==
                                        3) {
                                      if (_productDetail
                                              .productDetail!.eggEggless![0] ==
                                          "eggless") {
                                        eggEgglessType = _productDetail
                                            .productDetail!.eggEggless![0];
                                      } else {
                                        eggEgglessType = _productDetail
                                            .productDetail!.eggEggless![1];
                                      }
                                    }
                                    setState(() {});
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, top: 5, bottom: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            width: 1,
                                            color: isEggLess
                                                ? ColorConstants.appColor
                                                : ColorConstants
                                                    .colorPageBackground)),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/iv_veg_symbol.png',
                                          width: 25,
                                          height: 25,
                                          fit: BoxFit.fill,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "EggLess",
                                          style: TextStyle(
                                              fontFamily:
                                                  global.fontRailwayRegular,
                                              fontWeight: FontWeight.w200,
                                              fontSize: 14,
                                              //color: ColorConstants.pureBlack
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        visible: (flavourDropDown != null &&
                                flavourDropDown.length > 0) ||
                            flavourDropDown.length > 0,
                        child: Container(
                          padding: EdgeInsets.only(left: 8, right: 8, top: 10),
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(top: 1, bottom: 1),
                          child: Text(
                            "Choose ${_productDetail.productDetail!.labelFlavourColor}",
                            style: TextStyle(
                                fontFamily: global.fontMontserratLight,
                                fontWeight: FontWeight.w200,
                                fontSize: 15,
                                //color: ColorConstants.pureBlack
                                color: Colors.black),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: (flavourDropDown != null &&
                                flavourDropDown.length > 0) ||
                            flavourDropDown.length > 0,
                        child: Container(
                            padding:
                                EdgeInsets.only(left: 8, right: 8, top: 10),
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 5, bottom: 5),
                            child: Container(
                                padding: EdgeInsets.only(
                                  left: 2,
                                  right: 2,
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                                margin: EdgeInsets.only(
                                    left: 8, top: 8, bottom: 8, right: 8),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: ColorConstants.grey, width: 0.5),
                                    color: ColorConstants.white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: DropDownTextField(
                                  textStyle: TextStyle(
                                      fontFamily: global.fontRailwayRegular,
                                      fontSize: 13),
                                  listTextStyle: TextStyle(
                                      fontFamily: global.fontRailwayRegular,
                                      fontWeight: FontWeight.w200,
                                      color: ColorConstants.pureBlack,
                                      fontSize: 13),
                                  padding: EdgeInsets.all(8),
                                  clearOption: false,
                                  textFieldFocusNode: textFieldFocusNode,
                                  initialValue: "Select",
                                  textFieldDecoration: InputDecoration(
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    hintText: "Select",
                                    errorStyle: TextStyle(
                                        fontSize: 10,
                                        fontFamily: global.fontRailwayRegular,
                                        fontWeight: FontWeight.w200),
                                    hintStyle: TextStyle(
                                        fontFamily: global.fontRailwayRegular,
                                        fontWeight: FontWeight.w200,
                                        color: ColorConstants.grey,
                                        fontSize: 13),
                                  ), // AAA uper all comment
                                  searchFocusNode: searchFocusNode,
                                  dropDownItemCount: flavourDropDown.length,
                                  searchShowCursor: false,
                                  enableSearch: true,
                                  searchKeyboardType: TextInputType.number,
                                  dropDownList: flavourDropDown,
                                  onChanged: (val) {
                                    DropDownValueModel model = val;
                                    _selectedFlavour = model.name;
                                    setState(() {});
                                  },
                                ))),
                      ),
                    ],
                  ),
                )
              : SizedBox(),

          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            child: Row(
              children: [
                Image.asset(
                  "assets/images/iv_usp_garantee.png",
                  fit: BoxFit.contain,
                  height: 18,
                  alignment: Alignment.center,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Premium Quality Guaranteed",
                  style: TextStyle(
                      fontFamily: global.fontRailwaySemibold,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: ColorConstants.appColor),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: [
                Image.asset(
                  "assets/images/iv_usp_satisfy.png",
                  fit: BoxFit.contain,
                  height: 18,
                  alignment: Alignment.center,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "100% Customer Satisfaction",
                  style: TextStyle(
                      fontFamily: global.fontRailwaySemibold,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: ColorConstants.appColor),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: [
                Image.asset(
                  "assets/images/iv_usp_timedelivery.png",
                  fit: BoxFit.contain,
                  height: 18,
                  alignment: Alignment.center,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Timely Delivery Across UAE",
                  style: TextStyle(
                      fontFamily: global.fontRailwaySemibold,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: ColorConstants.appColor),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),

//           Container(
//             child: Column(
//               children: [
//                 Container(
//                   margin: EdgeInsets.only(left: 10, right: 10),
//                   child: Column(
//                     children: [
//                       // choose delivery date text
//                       Container(
//                         width: MediaQuery.of(context).size.width,
//                         margin: EdgeInsets.only(
//                             top: 5, bottom: 5, right: 8, left: 8),
//                         child: Text(
//                           "Choose Delivery Type",
//                           textAlign: TextAlign.left,
//                           style: TextStyle(
//                               fontFamily: global.fontMontserratLight,
//                               fontWeight: FontWeight.w300,
//                               fontSize: 15,
//                               color: ColorConstants.pureBlack),
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           // express code
//                           Expanded(
//                             child: InkWell(
//                               onTap: () {
//                                 responseMessage = "";
//                                 // Express == 1 tap
//                                 // _productDetail.productDetail!.delivery = "1";
//                                 //  _productDetail.productDetail!.delivery = "2";
//                                 // setState(() {});
//                                 // print("Madaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
//                                 //   print(ProductDetail.fromJson(_productDetail));
//                                 print(
//                                     "this isthe deivery value from api ${int.parse(_productDetail.productDetail!.delivery!)}");

//                                 if (isEndDatePassed) {
//                                   itsNextDayExpress = false;
//                                   itsNextDaySame = false;
//                                   nextDay = false;
//                                   expressSelected = false;
//                                   sameDay = false;
//                                   if (int.parse(_productDetail
//                                           .productDetail!.delivery!) ==
//                                       1) {
//                                     boolDeliverySlotErrorShow = true;
//                                     strDeliverySlotErrorShow =
//                                         "Product not available for delivery";
//                                   }

//                                   setState(() {});
//                                 } else if (int.parse(_productDetail
//                                         .productDetail!.delivery!) ==
//                                     1) {
//                                   expressSelected = true;
//                                   sameDay = false;
//                                   nextDay = false;
//                                   todaySelected = false;
//                                   tomorrowSelected = false;
//                                   dateSelected = false;
//                                   boolDeliveryTypeErrorShow = false;
//                                   setState(() {});
//                                 } else if (int.parse(_productDetail
//                                             .productDetail!.delivery!) ==
//                                         3 ||
//                                     int.parse(_productDetail
//                                             .productDetail!.delivery!) ==
//                                         2) {
//                                   expressSelected = false;
//                                   sameDay = false;
//                                   todaySelected = false;
//                                   tomorrowSelected = false;
//                                   dateSelected = false;
//                                   itsNextDayExpress = true;
//                                   itsNextDaySame = false;
//                                   boolDeliveryTypeErrorShow = false;

//                                   nextDay = false;
//                                   setState(() {});
//                                 }
//                               },
//                               child: Container(
//                                 padding: EdgeInsets.only(top: 10, bottom: 10),
//                                 decoration: BoxDecoration(
//                                     color: _productDetail
//                                                     .productDetail!.delivery ==
//                                                 "Today" &&
//                                             _productDetail
//                                                     .productDetail!.delivery !=
//                                                 "Tomorrow"
//                                         ? expressSelected
//                                             ? ColorConstants.appColor
//                                             : Colors.white
//                                         : int.parse(_productDetail
//                                                     .productDetail!
//                                                     .delivery!) ==
//                                                 1
//                                             ? expressSelected
//                                                 ? ColorConstants.appColor
//                                                 : Colors.white
//                                             : int.parse(_productDetail
//                                                         .productDetail!
//                                                         .delivery!) ==
//                                                     1
//                                                 ? expressSelected
//                                                     ? ColorConstants.appColor
//                                                     : Colors.white
//                                                 : itsNextDayExpress
//                                                     ? ColorConstants.appColor
//                                                     : Colors.white,
//                                     borderRadius: BorderRadius.circular(10),
//                                     border: Border.all(
//                                       width: 0.5,
//                                       color: _productDetail.productDetail!
//                                                       .delivery ==
//                                                   "Today" &&
//                                               _productDetail.productDetail!
//                                                       .delivery !=
//                                                   "Tomorrow"
//                                           ? expressSelected
//                                               ? ColorConstants.appColor
//                                               : Colors.black
//                                           : int.parse(_productDetail
//                                                       .productDetail!
//                                                       .delivery!) ==
//                                                   1
//                                               ? expressSelected
//                                                   ? ColorConstants.appColor
//                                                   : Colors.black
//                                               : itsNextDayExpress
//                                                   ? ColorConstants.appColor
//                                                   : Colors.black,
//                                     )),
//                                 margin: EdgeInsets.only(
//                                     top: 5, bottom: 5, left: 8, right: 8),
//                                 child: Text(
//                                   "Express \nDelivery",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     fontFamily: global.fontRailwayRegular,
//                                     fontWeight: FontWeight.w200,
//                                     fontSize: 13,
//                                     color: _productDetail
//                                                     .productDetail!.delivery ==
//                                                 "Today" &&
//                                             _productDetail
//                                                     .productDetail!.delivery !=
//                                                 "Tomorrow"
//                                         ? expressSelected
//                                             ? ColorConstants.white
//                                             : Colors.black
//                                         : int.parse(_productDetail
//                                                     .productDetail!
//                                                     .delivery!) ==
//                                                 1
//                                             ? expressSelected
//                                                 ? ColorConstants.white
//                                                 : Colors.black
//                                             : int.parse(_productDetail
//                                                         .productDetail!
//                                                         .delivery!) ==
//                                                     1
//                                                 ? expressSelected
//                                                     ? ColorConstants.white
//                                                     : Colors.black
//                                                 : itsNextDayExpress
//                                                     ? ColorConstants.white
//                                                     : Colors.black,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
// // same day code ###############################################
//                           Expanded(
//                             child: InkWell(
//                               onTap: () {
//                                 // setState(() {
//                                 //   _productDetail.productDetail!.delivery = "2";
//                                 // });
//                                 // sameDay = true;
//                                 responseMessage = "";
//                                 boolDeliveryTypeErrorShow = false;
//                                 boolDeliverySlotErrorShow = false;
//                                 setState(() {});
//                                 if (isEndDatePassed) {
//                                   itsNextDayExpress = false;
//                                   itsNextDaySame = false;
//                                   nextDay = false;
//                                   expressSelected = false;
//                                   sameDay = false;
//                                   boolDeliverySlotErrorShow = true;
//                                   strDeliverySlotErrorShow =
//                                       "Product not available for delivery";
//                                   setState(() {});
//                                 } else if (int.parse(_productDetail
//                                             .productDetail!.delivery!) <
//                                         3 &&
//                                     int.parse(_productDetail
//                                             .productDetail!.delivery!) >=
//                                         1) {
//                                   sameDay = true;
//                                   expressSelected = false;
//                                   nextDay = false;
//                                   itsNextDayExpress = false;
//                                   itsNextDaySame = false;

//                                   String currentDate = global.monthInIntFormt
//                                       .format(DateTime.now());
//                                   _getTimeSlots(currentDate, true);
//                                 } else if (int.parse(_productDetail
//                                         .productDetail!.delivery!) ==
//                                     3) {
//                                   itsNextDayExpress = false;
//                                   itsNextDaySame = true;
//                                   nextDay = false;
//                                   setState(() {});
//                                 }
//                               },
//                               child: Container(
//                                 padding: EdgeInsets.only(top: 10, bottom: 10),
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                     color: _productDetail
//                                                 .productDetail!.delivery ==
//                                             "Tomorrow"
//                                         ? sameDay
//                                             ? ColorConstants.appColor
//                                             : Colors.white
//                                         : int.parse(_productDetail.productDetail!.delivery!) <
//                                                     3 &&
//                                                 int.parse(_productDetail
//                                                         .productDetail!
//                                                         .delivery!) >=
//                                                     1
//                                             ? sameDay
//                                                 ? ColorConstants.appColor
//                                                 : Colors.white
//                                             : int.parse(_productDetail
//                                                             .productDetail!
//                                                             .delivery!) <
//                                                         3 &&
//                                                     int.parse(_productDetail
//                                                             .productDetail!
//                                                             .delivery!) >=
//                                                         1
//                                                 ? sameDay
//                                                     ? ColorConstants.appColor
//                                                     : Colors.white
//                                                 : itsNextDaySame
//                                                     ? ColorConstants.appColor
//                                                     : Colors.white,
//                                     border: Border.all(
//                                       width: 0.5,
//                                       color: _productDetail
//                                                   .productDetail!.delivery ==
//                                               "Tomorrow"
//                                           ? sameDay
//                                               ? ColorConstants.appColor
//                                               : Colors.white
//                                           : int.parse(_productDetail
//                                                           .productDetail!
//                                                           .delivery!) <
//                                                       3 &&
//                                                   int.parse(_productDetail
//                                                           .productDetail!
//                                                           .delivery!) >=
//                                                       1
//                                               ? sameDay
//                                                   ? ColorConstants.appColor
//                                                   : Colors.black
//                                               : itsNextDaySame
//                                                   ? ColorConstants.appColor
//                                                   : Colors.black,
//                                     )),
//                                 margin: EdgeInsets.only(
//                                     top: 5, bottom: 5, right: 8),
//                                 child: Text(
//                                   "Same \nDay",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     fontFamily: global.fontRailwayRegular,
//                                     fontWeight: FontWeight.w200,
//                                     fontSize: 13,
//                                     color: _productDetail
//                                                 .productDetail!.delivery ==
//                                             "Tomorrow"
//                                         ? sameDay
//                                             ? ColorConstants.appColor
//                                             : Colors.white
//                                         : int.parse(_productDetail
//                                                         .productDetail!
//                                                         .delivery!) <
//                                                     3 &&
//                                                 int.parse(_productDetail
//                                                         .productDetail!
//                                                         .delivery!) >=
//                                                     1
//                                             ? sameDay
//                                                 ? ColorConstants.white
//                                                 : Colors.black
//                                             : itsNextDaySame
//                                                 ? ColorConstants.white
//                                                 : Colors.black,

//                                     // : int.parse(_productDetail
//                                     //                 .productDetail!
//                                     //                 .delivery!) <
//                                     //             3 &&
//                                     //         int.parse(_productDetail
//                                     //                 .productDetail!
//                                     //                 .delivery!) >=
//                                     //             1
//                                     //     ? sameDay
//                                     //         ? ColorConstants.white
//                                     //         : Colors.black
//                                     //     : itsNextDaySame
//                                     //         ? ColorConstants.white
//                                     //         : Colors.black,
//                                     // Aj unused code
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
// // Next day code ###############################################

//                           Expanded(
//                             child: InkWell(
//                               onTap: () {
//                                 responseMessage = "";
//                                 boolDeliveryTypeErrorShow = false;
//                                 timeSlots.clear();
//                                 timeSlotsDropDown.clear();
//                                 print(
//                                     "NIKHL----------------------_>>>>isEndDatePassed>>>>>>>>>>>>>>>>>>>>>>${isEndDatePassed}");
//                                 if (isEndDatePassed) {
//                                   print("Scheduled 1");
//                                   itsNextDayExpress = false;
//                                   itsNextDaySame = false;
//                                   nextDay = false;
//                                   expressSelected = false;
//                                   sameDay = false;

//                                   boolDeliverySlotErrorShow = true;
//                                   strDeliverySlotErrorShow =
//                                       "Product not available for delivery";

//                                   setState(() {});
//                                 } else if (int.parse(_productDetail
//                                         .productDetail!.delivery!) >=
//                                     1) {
//                                   print("Scheduled 2");
//                                   itsNextDayExpress = false;
//                                   itsNextDaySame = false;
//                                   nextDay = true;
//                                   expressSelected = false;
//                                   sameDay = false;
//                                   if (_productDetail
//                                           .productDetail!.productStartDate ==
//                                       null) {
//                                     _selectedDate = DateTime(
//                                         DateTime.now().year,
//                                         DateTime.now().month,
//                                         DateTime.now().day +
//                                             (int.parse(_productDetail
//                                                         .productDetail!
//                                                         .delivery!) >
//                                                     2
//                                                 ? int.parse(_productDetail
//                                                         .productDetail!
//                                                         .delivery!) -
//                                                     2
//                                                 : 1));
//                                   }

//                                   _getTimeSlots(
//                                       global.monthInIntFormt
//                                           .format(_selectedDate!),
//                                       true);

//                                   setState(() {});
//                                 }
//                               },
//                               child: Container(
//                                 padding: EdgeInsets.only(top: 10, bottom: 10),
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                     color: nextDay
//                                         ? ColorConstants.appColor
//                                         : Colors.white,
//                                     border: Border.all(
//                                         width: 0.5,
//                                         color: nextDay
//                                             ? ColorConstants.appColor
//                                             : ColorConstants.pureBlack)),
//                                 margin: EdgeInsets.only(
//                                     top: 5, bottom: 5, right: 8),
//                                 child: Text(
//                                   "Scheduled \ndelivery",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       fontFamily: global.fontRailwayRegular,
//                                       fontWeight: FontWeight.w200,
//                                       fontSize: 13,
//                                       color: nextDay
//                                           ? ColorConstants.white
//                                           : ColorConstants.pureBlack),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),

//                       Visibility(
//                           visible: boolDeliveryTypeErrorShow,
//                           child: Container(
//                             padding: EdgeInsets.only(left: 8, right: 8),
//                             width: MediaQuery.of(context).size.width,
//                             margin: EdgeInsets.only(top: 5, bottom: 5),
//                             child: Text(
//                               strDeliveryTypeErrorShow,
//                               style: TextStyle(
//                                   fontFamily: global.fontRailwayRegular,
//                                   fontWeight: FontWeight.w300,
//                                   fontSize: 12,
//                                   color: ColorConstants.appColor),
//                             ),
//                           )),

//                       itsNextDayExpress || itsNextDaySame
//                           ? Container(
//                               padding: EdgeInsets.only(left: 8, right: 8),
//                               width: MediaQuery.of(context).size.width,
//                               margin: EdgeInsets.only(top: 5, bottom: 5),
//                               child: Text(
//                                 itsNextDaySame
//                                     ? "Same Day delivery is coming soon! Currently unavailable for this item."
//                                     : "Express delivery is coming soon! Currently unavailable for this item.",
//                                 style: TextStyle(
//                                     fontFamily: global.fontRailwayRegular,
//                                     fontWeight: FontWeight.w300,
//                                     fontSize: 15,
//                                     color: ColorConstants.appColor),
//                               ),
//                             )
//                           : Container(),
//                       int.parse(_productDetail.productDetail!.delivery!) > 1 &&
//                               expressSelected
//                           ? Container(
//                               padding: EdgeInsets.only(left: 8, right: 8),
//                               width: MediaQuery.of(context).size.width,
//                               margin: EdgeInsets.only(top: 5, bottom: 5),
//                               child: Text(
//                                 "Express delivery is coming soon! Currently unavailable for this item.",
//                                 style: TextStyle(
//                                     fontFamily: global.fontRailwayRegular,
//                                     fontWeight: FontWeight.w300,
//                                     fontSize: 15,
//                                     color: ColorConstants.appColor),
//                               ),
//                             )
//                           : Container(),

//                       (itsNextDayExpress || itsNextDaySame)
//                           ? Container()
//                           : isEndDatePassed
//                               ? Container()
//                               : Container(
//                                   padding: EdgeInsets.only(
//                                       left: 8, right: 8, top: 8),
//                                   width: MediaQuery.of(context).size.width,
//                                   margin: EdgeInsets.only(top: 5, bottom: 5),
//                                   child: Text(
//                                     "Choose Delivery Date",
//                                     style: TextStyle(
//                                         fontFamily: global.fontMontserratLight,
//                                         fontWeight: FontWeight.w300,
//                                         fontSize: 15,
//                                         color: ColorConstants.pureBlack),
//                                   ),
//                                 ),
//                       //     : SizedBox(
//                       //         height: 10,
//                       //       ),
//                       // nextDay
//                       //     ?
//                       nextDay && !isEndDatePassed
//                           ? Container(
//                               padding: EdgeInsets.only(left: 8, right: 8),
//                               width: MediaQuery.of(context).size.width,
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: <Widget>[
//                                   DatePickerWidget(
//                                     initialDate: DateTime(
//                                         DateTime.now().year,
//                                         DateTime.now().month,
//                                         DateTime.now().day +
//                                             (int.parse(_productDetail
//                                                         .productDetail!
//                                                         .delivery!) >
//                                                     2
//                                                 ? int.parse(_productDetail
//                                                         .productDetail!
//                                                         .delivery!) -
//                                                     2
//                                                 : 1)),
//                                     looping: false,
//                                     firstDate: isCurrentDateLess &&
//                                             _productDetail.productDetail!
//                                                     .productStartDate !=
//                                                 null
//                                         ? DateTime.tryParse(_productDetail
//                                             .productDetail!.productStartDate!)
//                                         : DateTime(
//                                             DateTime.now().year,
//                                             DateTime.now().month,
//                                             DateTime.now().day +
//                                                 (int.parse(_productDetail
//                                                             .productDetail!
//                                                             .delivery!) >
//                                                         2
//                                                     ? int.parse(_productDetail
//                                                             .productDetail!
//                                                             .delivery!) -
//                                                         2
//                                                     : 1)),
//                                     lastDate: _productDetail.productDetail!
//                                                 .productStartDate !=
//                                             null
//                                         ? DateTime.tryParse(_productDetail
//                                             .productDetail!.productEndDate!)
//                                         : DateTime(
//                                             DateTime.now().year,
//                                             DateTime.now().month,
//                                             DateTime.now().day +
//                                                 (int.parse(_productDetail
//                                                         .productDetail!
//                                                         .delivery!) +
//                                                     90)),
//                                     dateFormat: "dd/MMMM/yyyy",
//                                     locale: DatePicker.localeFromString('en'),
//                                     onChange: (DateTime newDate, _) {
//                                       _selectedDate = newDate;
//                                       _selectedTime = null;
//                                       timeSlots.clear();
//                                       timeSlotsDropDown.clear();
//                                       Future.delayed(Duration(seconds: 2), () {
//                                         _getTimeSlots(
//                                             global.monthInIntFormt
//                                                 .format(_selectedDate!),
//                                             true);
//                                       });

//                                       // setState(() {
//                                       //   // print(_selectedDate);
//                                       // });
//                                     },
//                                     pickerTheme: DateTimePickerTheme(
//                                       backgroundColor: Colors.transparent,
//                                       itemTextStyle: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 14,
//                                           fontFamily:
//                                               global.fontRailwayRegular,
//                                           fontWeight: FontWeight.w200),
//                                       dividerColor: Colors.black,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             )
//                           : SizedBox(),
//                       !nextDay && !itsNextDayExpress && !itsNextDaySame
//                           ? SizedBox(
//                               height: 10,
//                             )
//                           : SizedBox(
//                               height: 1,
//                             ),
//                       itsNextDayExpress || itsNextDaySame
//                           ? Container()
//                           : nextDay
//                               ? SizedBox()
//                               : Container(
//                                   padding: EdgeInsets.only(left: 8, right: 8),
//                                   width: MediaQuery.of(context).size.width,
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: <Widget>[
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Container(
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .width /
//                                                 3.8,
//                                             height: 2,
//                                             color: ColorConstants.grey,
//                                           ),
//                                           Container(
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .width /
//                                                 3.8,
//                                             height: 2,
//                                             color: ColorConstants.grey,
//                                           ),
//                                           Container(
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .width /
//                                                 3.8,
//                                             height: 2,
//                                             color: ColorConstants.grey,
//                                           ),
//                                         ],
//                                       ),
//                                       SizedBox(
//                                         height: 12,
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Container(
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .width /
//                                                   3.8,
//                                               child: Text(
//                                                 "${global.onlydate.format(DateTime.now())}",
//                                                 textAlign: TextAlign.center,
//                                                 style: TextStyle(
//                                                     color: Colors.grey,
//                                                     fontSize: 14,
//                                                     fontFamily: global
//                                                         .fontRailwayRegular,
//                                                     fontWeight:
//                                                         FontWeight.w200),
//                                               )),
//                                           Container(
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .width /
//                                                   3.8,
//                                               child: Text(
//                                                 "${global.onlyMonth.format(DateTime.now())}",
//                                                 textAlign: TextAlign.center,
//                                                 style: TextStyle(
//                                                     color: Colors.grey,
//                                                     fontSize: 14,
//                                                     fontFamily: global
//                                                         .fontRailwayRegular,
//                                                     fontWeight:
//                                                         FontWeight.w200),
//                                               )),
//                                           Container(
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .width /
//                                                   3.8,
//                                               child: Text(
//                                                 "${DateTime.now().year}",
//                                                 textAlign: TextAlign.center,
//                                                 style: TextStyle(
//                                                     color: Colors.grey,
//                                                     fontSize: 14,
//                                                     fontFamily: global
//                                                         .fontRailwayRegular,
//                                                     fontWeight:
//                                                         FontWeight.w200),
//                                               )),
//                                         ],
//                                       ),
//                                       SizedBox(
//                                         height: 12,
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Container(
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .width /
//                                                 3.8,
//                                             height: 2,
//                                             color: ColorConstants.grey,
//                                           ),
//                                           Container(
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .width /
//                                                 3.8,
//                                             height: 2,
//                                             color: ColorConstants.grey,
//                                           ),
//                                           Container(
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .width /
//                                                 3.8,
//                                             height: 2,
//                                             color: ColorConstants.grey,
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                       !nextDay
//                           ? SizedBox(
//                               height: 40,
//                             )
//                           : SizedBox(
//                               height: 1,
//                             ),
//                       // : SizedBox(),
//                       // sameDay || nextDay
//                       //     ?
//                       timeSlotsDropDown.length > 0 &&
//                               ((nextDay && !isEndDatePassed) || sameDay)
//                           ? Container(
//                               padding: EdgeInsets.only(left: 8, right: 8),
//                               width: MediaQuery.of(context).size.width,
//                               margin: EdgeInsets.only(top: 1, bottom: 1),
//                               child: Text(
//                                 "Choose Delivery Slot",
//                                 style: TextStyle(
//                                     fontFamily: global.fontMontserratLight,
//                                     fontWeight: FontWeight.w200,
//                                     fontSize: 15,
//                                     //color: ColorConstants.pureBlack
//                                     color: Colors.black),
//                               ),
//                             )
//                           : Container(),
//                       (timeSlotsDropDown.length == 0 && sameDay)
//                           ? Container(
//                               padding: EdgeInsets.only(left: 8, right: 8),
//                               width: MediaQuery.of(context).size.width,
//                               margin: EdgeInsets.only(top: 5, bottom: 5),
//                               child: Column(
//                                 children: [
//                                   Text(
//                                     timeSlotNotAvailable,
//                                     style: TextStyle(
//                                         fontFamily: global.fontMontserratLight,
//                                         fontWeight: FontWeight.w200,
//                                         fontSize: 15,
//                                         color: ColorConstants.appColor),
//                                   ),
//                                   SizedBox(
//                                     height: 10,
//                                   )
//                                 ],
//                               ),
//                             )
//                           : Container(),

//                       // : SizedBox(),
//                       // sameDay || nextDay
//                       //     ?

//                       //Aayush: time slot code
//                       timeSlotsDropDown.length > 0 &&
//                               ((nextDay && !isEndDatePassed) || sameDay)
//                           ? Container(
//                               padding: EdgeInsets.only(
//                                 left: 2,
//                                 right: 2,
//                               ),
//                               width: MediaQuery.of(context).size.width,
//                               height: 40,
//                               margin: EdgeInsets.only(
//                                   left: 8,
//                                   top: 8,
//                                   bottom: 8,
//                                   right:
//                                       MediaQuery.of(context).size.width / 2.6),
//                               decoration: BoxDecoration(
//                                   border: Border.all(
//                                       color: ColorConstants.grey, width: 0.5),
//                                   color: ColorConstants.white,
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(10.0))),
//                               child: DropDownTextField(
//                                 isEnabled: sameDay || nextDay ? true : false,
//                                 textStyle: TextStyle(
//                                     fontFamily: global.fontRailwayRegular,
//                                     fontSize: 13),
//                                 listTextStyle: TextStyle(
//                                     fontFamily: global.fontRailwayRegular,
//                                     fontWeight: FontWeight.w200,
//                                     color: ColorConstants.pureBlack,
//                                     fontSize: 13),
//                                 padding: EdgeInsets.all(8),
//                                 clearOption: false,
//                                 textFieldFocusNode: textFieldFocusNode,
//                                 initialValue: "Select Time",
//                                 textFieldDecoration: InputDecoration(
//                                   enabledBorder: InputBorder.none,
//                                   focusedBorder: InputBorder.none,
//                                   hintText: "Select",
//                                   errorStyle: TextStyle(
//                                       fontSize: 10,
//                                       fontFamily: global.fontRailwayRegular,
//                                       fontWeight: FontWeight.w200),
//                                   hintStyle: TextStyle(
//                                       fontFamily: global.fontRailwayRegular,
//                                       fontWeight: FontWeight.w200,
//                                       color: ColorConstants.grey,
//                                       fontSize: 13),
//                                 ), // AAA uper all comment
//                                 searchFocusNode: searchFocusNode,
//                                 dropDownItemCount: timeSlots.length,
//                                 searchShowCursor: false,
//                                 enableSearch: true,
//                                 searchKeyboardType: TextInputType.number,
//                                 dropDownList: timeSlotsDropDown,
//                                 onChanged: (val) {
//                                   print(val);
//                                   DropDownValueModel model = val;
//                                   _selectedTime = model.name;
//                                   boolDeliverySlotErrorShow = false;
//                                   print(_selectedTime);
//                                   setState(() {});
//                                 },
//                               ))
//                           : Container(),

//                       int.parse(_productDetail.productDetail!.delivery!) == 1 &&
//                               expressSelected
//                           ? Container(
//                               padding: EdgeInsets.only(left: 8, right: 8),
//                               width: MediaQuery.of(context).size.width,
//                               margin: EdgeInsets.only(top: 5, bottom: 5),
//                               child: Text(
//                                 "Delivery within 120 minutes",
//                                 style: TextStyle(
//                                     fontFamily: global.fontRailwayRegular,
//                                     fontWeight: FontWeight.w300,
//                                     fontSize: 15,
//                                     color: ColorConstants.appColor),
//                               ),
//                             )
//                           : Container(),
//                       Visibility(
//                           visible: boolDeliverySlotErrorShow,
//                           child: Container(
//                             padding: EdgeInsets.only(left: 8, right: 8),
//                             width: MediaQuery.of(context).size.width,
//                             margin: EdgeInsets.only(top: 5, bottom: 5),
//                             child: Text(
//                               strDeliverySlotErrorShow,
//                               style: TextStyle(
//                                   fontFamily: global.fontRailwayRegular,
//                                   fontWeight: FontWeight.w300,
//                                   fontSize: 12,
//                                   color: ColorConstants.appColor),
//                             ),
//                           )),
//                       // : SizedBox(),
//                     ],
//                   ),
//                 ),

//                 SizedBox(
//                   height: 8,
//                   child: Container(
//                     color: ColorConstants.greyDull,
//                   ),
//                 ),
//                 _productDetail.otherDetails != null &&
//                         _productDetail.otherDetails!.length > 0 &&
//                         _productDetail.otherDetails![0].fieldType!
//                                 .toLowerCase() ==
//                             "date"
//                     ? Container(
//                         width: MediaQuery.of(context).size.width,
//                         margin: EdgeInsets.only(
//                             top: 5, left: 10, right: 10, bottom: 5),
//                         child: Text(
//                           "Date on Product",
//                           style: TextStyle(
//                               fontFamily: global.fontMontserratLight,
//                               fontWeight: FontWeight.w300,
//                               fontSize: 15,
//                               color: ColorConstants.pureBlack),
//                         ),
//                       )
//                     : SizedBox(),
//                 _productDetail.otherDetails != null &&
//                         _productDetail.otherDetails!.length > 0 &&
//                         _productDetail.otherDetails![0].fieldType!
//                                 .toLowerCase() ==
//                             "date"
//                     ? Container(
//                         padding: EdgeInsets.only(left: 8, right: 8),
//                         width: MediaQuery.of(context).size.width,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             DatePickerWidget(
//                               initialDate: DateTime(DateTime.now().year,
//                                   DateTime.now().month, DateTime.now().day),
//                               looping: false,
//                               // firstDate: DateTime(
//                               //     DateTime.now().year,
//                               //     DateTime.now().month,
//                               //     DateTime.now().day),
//                               // lastDate: DateTime(
//                               //     DateTime.now().year,
//                               //     DateTime.now().month,
//                               //     DateTime.now().day + 90),
//                               dateFormat: "dd/MMMM/yyyy",
//                               locale: DatePicker.localeFromString('en'),
//                               onChange: (DateTime newDate, _) {
//                                 setState(() {
//                                   otherDetailsDate = newDate;
//                                   print(
//                                       "this is the selcted date${otherDetailsDate}");
//                                   _productDetail.otherDetails![0].setTextValue =
//                                       otherDetailsDate.toString();
//                                 });
//                                 print(_selectedDate);
//                               },
//                               pickerTheme: DateTimePickerTheme(
//                                 backgroundColor: Colors.transparent,
//                                 itemTextStyle: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 14,
//                                     fontFamily: global.fontRailwayRegular,
//                                     fontWeight: FontWeight.w200),
//                                 dividerColor: Colors.black,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : SizedBox(),
//                 _productDetail.otherDetails != null &&
//                         _productDetail.otherDetails!.length > 0 &&
//                         _productDetail.otherDetails![0].fieldType!
//                                 .toLowerCase() ==
//                             "date"
//                     ? SizedBox(
//                         height: 8,
//                         child: Container(
//                           color: ColorConstants.greyDull,
//                         ),
//                       )
//                     : SizedBox(),
//                 otherDetailsTextLength > 0
//                     ? Container(
//                         padding: EdgeInsets.only(left: 8, right: 8, top: 5),
//                         width: MediaQuery.of(context).size.width,
//                         margin: EdgeInsets.only(top: 10),
//                         child: Text(
//                           "Enter Text On Product",
//                           style: TextStyle(
//                               fontFamily: global.fontMontserratLight,
//                               fontWeight: FontWeight.w300,
//                               fontSize: 15,
//                               color: ColorConstants.pureBlack),
//                         ),
//                       )
//                     : SizedBox(),
//                 _productDetail.otherDetails!.length > 0
//                     ? Container(
//                         width: MediaQuery.of(context).size.width,
//                         height: otherDetailsTextLength * 70.0,
//                         child: ListView.builder(
//                             controller: _scrollController,
//                             physics: NeverScrollableScrollPhysics(),
//                             itemCount: _productDetail.otherDetails!.length,
//                             scrollDirection: Axis.vertical,
//                             itemBuilder: (context, index) => Column(
//                                   children: [
//                                     _productDetail
//                                                 .otherDetails![index].fieldType!
//                                                 .toLowerCase() ==
//                                             "text"
//                                         ? Container(
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .width /
//                                                 1.1,
//                                             height: 40,
//                                             decoration: BoxDecoration(
//                                                 color: Colors.white,
//                                                 borderRadius:
//                                                     BorderRadius.circular(7)),
//                                             child: MaterialTextField(
//                                               style: TextStyle(
//                                                   fontFamily: global
//                                                       .fontRailwayRegular,
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.w200,
//                                                   color:
//                                                       ColorConstants.pureBlack),
//                                               theme: FilledOrOutlinedTextTheme(
//                                                 radius: 8,
//                                                 contentPadding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 10,
//                                                         vertical: 4),
//                                                 errorStyle: const TextStyle(
//                                                     fontSize: 16,
//                                                     fontWeight:
//                                                         FontWeight.w700),
//                                                 fillColor: Colors.transparent,
//                                                 enabledColor: Colors.grey,
//                                                 focusedColor:
//                                                     ColorConstants.appColor,
//                                                 floatingLabelStyle:
//                                                     const TextStyle(
//                                                         color: ColorConstants
//                                                             .appColor),
//                                                 width: 0.5,
//                                                 labelStyle: const TextStyle(
//                                                     fontSize: 14,
//                                                     color: Colors.grey),
//                                                 hintStyle: const TextStyle(
//                                                     fontSize: 14,
//                                                     color: Colors.grey),
//                                               ),
//                                               keyboardType: TextInputType.text,
//                                               hint: 'Text',
//                                               labelText: _productDetail
//                                                   .otherDetails![index]
//                                                   .fieldValue,
//                                               textInputAction:
//                                                   TextInputAction.done,
//                                               onChanged: (value) {
//                                                 print(value);
//                                                 _productDetail
//                                                         .otherDetails![index]
//                                                         .setTextValue =
//                                                     value.toString();
//                                               },
//                                             ))
//                                         : Container(
//                                             child: Text(""),
//                                           ),
//                                   ],
//                                 )),
//                       )
//                     : SizedBox(),
//                 _productDetail.otherDetails!.length > 0
//                     ? SizedBox(
//                         height: 10,
//                       )
//                     : SizedBox(),
//                 _productDetail.otherDetails!.length > 0
//                     ? SizedBox(
//                         height: 8,
//                         child: Container(
//                           color: ColorConstants.greyDull,
//                         ),
//                       )
//                     : SizedBox(),
//                 otherDetailsImageLength > 0
//                     ? Container(
//                         padding: EdgeInsets.only(left: 8, right: 8),
//                         width: MediaQuery.of(context).size.width,
//                         height: 30,
//                         margin: EdgeInsets.only(top: 5, bottom: 5),
//                         child: Text(
//                           "Choose Images On Product",
//                           style: TextStyle(
//                               fontFamily: global.fontMontserratLight,
//                               fontWeight: FontWeight.w300,
//                               fontSize: 15,
//                               color: ColorConstants.pureBlack),
//                         ),
//                       )
//                     : Container(),
//                 _productDetail.otherDetails != null &&
//                         _productDetail.otherDetails!.length > 0
//                     ? Container(
//                         width: MediaQuery.of(context).size.width,
//                         height: otherDetailsImageLength == 1
//                             ? 150
//                             : otherDetailsImageLength * 80.0,
//                         child: GridView.builder(
//                             shrinkWrap: true,
//                             gridDelegate:
//                                 SliverGridDelegateWithFixedCrossAxisCount(
//                                     crossAxisCount: 3,
//                                     childAspectRatio: MediaQuery.of(context)
//                                             .size
//                                             .width /
//                                         (MediaQuery.of(context).size.height /
//                                             1.8)),
//                             itemCount: _productDetail.otherDetails!.length,
//                             scrollDirection: Axis.vertical,
//                             itemBuilder: (context, index) => Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     SizedBox(
//                                       height: 10,
//                                     ),
//                                     _productDetail
//                                                 .otherDetails![index].fieldType!
//                                                 .toLowerCase() ==
//                                             "image"
//                                         ? Column(
//                                             children: [
//                                               Container(
//                                                 width: MediaQuery.of(context)
//                                                         .size
//                                                         .width /
//                                                     4,
//                                                 height: MediaQuery.of(context)
//                                                         .size
//                                                         .width /
//                                                     4,
//                                                 child: Stack(
//                                                   children: [
//                                                     Container(
//                                                       width:
//                                                           MediaQuery.of(context)
//                                                                   .size
//                                                                   .width /
//                                                               4.4,
//                                                       height:
//                                                           MediaQuery.of(context)
//                                                                   .size
//                                                                   .width /
//                                                               4.4,
//                                                       decoration: BoxDecoration(
//                                                           color: Colors.white,
//                                                           border: Border.all(
//                                                               color:
//                                                                   ColorConstants
//                                                                       .greyfaint),
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(
//                                                                       10)),
//                                                       child: _productDetail
//                                                                   .otherDetails![
//                                                                       index]
//                                                                   .setImagePath !=
//                                                               null
//                                                           ? CircleAvatar(
//                                                               backgroundColor:
//                                                                   Colors.white,
//                                                               radius: 60,
//                                                               backgroundImage: FileImage(File(
//                                                                   _productDetail
//                                                                       .otherDetails![
//                                                                           index]
//                                                                       .setImagePath!
//                                                                       .path)))
//                                                           : CircleAvatar(
//                                                               backgroundColor:
//                                                                   Colors.white,
//                                                               radius: 60,
//                                                               child: Icon(
//                                                                 Icons
//                                                                     .photo_size_select_actual_sharp,
//                                                                 size: 60,
//                                                                 color: ColorConstants
//                                                                     .allIconsBlack45,
//                                                               )),
//                                                     ),
//                                                     Positioned(
//                                                       bottom: 0,
//                                                       right: 0,
//                                                       child: CircleAvatar(
//                                                         radius: 20,
//                                                         backgroundColor:
//                                                             Theme.of(context)
//                                                                 .primaryColor,
//                                                         child: IconButton(
//                                                           icon: Icon(
//                                                             Icons
//                                                                 .add_a_photo_outlined,
//                                                             color: Colors.white,
//                                                             size: 20,
//                                                           ),
//                                                           onPressed: () {
//                                                             _showCupertinoModalSheet(
//                                                                 index);
//                                                             setState(() {});
//                                                           },
//                                                         ),
//                                                       ),
//                                                     )
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           )
//                                         : Container(),
//                                     _productDetail
//                                                 .otherDetails![index].fieldType!
//                                                 .toLowerCase() ==
//                                             "image"
//                                         ? Container(
//                                             margin: EdgeInsets.only(
//                                                 top: 5, bottom: 5),
//                                             width: 120,
//                                             child: Text(
//                                               "${_productDetail.otherDetails![index].fieldValue}",
//                                               textAlign: TextAlign.center,
//                                               style: TextStyle(
//                                                   fontFamily: global
//                                                       .fontMontserratLight,
//                                                   fontWeight: FontWeight.w200,
//                                                   fontSize: 15,
//                                                   color:
//                                                       ColorConstants.pureBlack),
//                                             ),
//                                           )
//                                         : Container(),
//                                   ],
//                                 )),
//                       )
//                     : Container(),

//                 SizedBox(
//                   height: 8,
//                   child: Container(
//                     color: ColorConstants.greyDull,
//                   ),
//                 ),

//                 // Container(
//                 //   margin:
//                 //       EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
//                 //   width: MediaQuery.of(context).size.width,
//                 //   child: Text(
//                 //     "Add Message",
//                 //     textAlign: TextAlign.left,
//                 //     style: TextStyle(
//                 //         fontFamily: global.fontMontserratLight,
//                 //         fontWeight: FontWeight.w200,
//                 //         fontSize: 15,
//                 //         color: ColorConstants.pureBlack),
//                 //   ),
//                 // ),

//                 // Container(
//                 //   margin: EdgeInsets.only(left: 5, right: 10),
//                 //   height: 40,

//                 //   //height: MediaQuery.of(context).size.width / 3.5,
//                 //   width: MediaQuery.of(context).size.width,
//                 //   child: ListView.builder(
//                 //       controller: _scrollController,
//                 //       physics: AlwaysScrollableScrollPhysics(),
//                 //       itemCount: _productDetail.eventsDetail!.length,
//                 //       scrollDirection: Axis.horizontal,
//                 //       itemBuilder: (context, index) => Container(
//                 //             //width: MediaQuery.of(context).size.width / 2.6,
//                 //             // padding: eventListSelectedIndex == index
//                 //             //     ? EdgeInsets.all(0)
//                 //             //     : EdgeInsets.all(10),
//                 //             margin: EdgeInsets.only(
//                 //                 top: 3, bottom: 3, right: 5, left: 5),
//                 //             color: Colors.transparent,
//                 //             child: InkWell(
//                 //               onTap: () {
//                 //                 eventListSelectedIndex = index;

//                 //                 setState(() {});
//                 //               },
//                 //               child: Wrap(
//                 //                 children: [
//                 //                   Container(
//                 //                     decoration: BoxDecoration(
//                 //                       color: eventListSelectedIndex == index
//                 //                           ? ColorConstants.appColor
//                 //                           : ColorConstants.white,
//                 //                       borderRadius: BorderRadius.circular(10),
//                 //                       border: Border.all(
//                 //                           width: 0.5,
//                 //                           color: eventListSelectedIndex == index
//                 //                               ? ColorConstants.appColor
//                 //                               : ColorConstants.pureBlack),
//                 //                     ),
//                 //                     //width: double.infinity,
//                 //                     padding: EdgeInsets.only(left: 8, right: 8),
//                 //                     child: Align(
//                 //                       alignment: Alignment.bottomCenter,
//                 //                       child: Container(
//                 //                         padding:
//                 //                             EdgeInsets.only(bottom: 5, top: 5),
//                 //                         decoration: BoxDecoration(
//                 //                             borderRadius: BorderRadius.all(
//                 //                                 Radius.circular(10))),
//                 //                         //width: double.infinity,
//                 //                         child: Text(
//                 //                           "${_productDetail.eventsDetail![index].eventName}",
//                 //                           textAlign: TextAlign.center,
//                 //                           maxLines: 1,
//                 //                           style: TextStyle(
//                 //                               fontFamily:
//                 //                                   global.fontRailwayRegular,
//                 //                               fontSize: 13,
//                 //                               fontWeight: FontWeight.w200,
//                 //                               overflow: TextOverflow.ellipsis,
//                 //                               color: eventListSelectedIndex ==
//                 //                                       index
//                 //                                   ? ColorConstants.white
//                 //                                   : ColorConstants.pureBlack),
//                 //                         ),
//                 //                       ),
//                 //                     ),
//                 //                   )
//                 //                 ],
//                 //               ),
//                 //             ),
//                 //           )),
//                 // ),
//                 // //CheckboxListTile(value: value, onChanged: onChanged),
//                 // Container(
//                 //   //margin: EdgeInsets.only(top: 8),
//                 //   height: MediaQuery.of(context).size.width / 2.3,
//                 //   //height: MediaQuery.of(context).size.width / 3.5,
//                 //   width: MediaQuery.of(context).size.width,
//                 //   child: Scrollbar(
//                 //     controller: _scrollController,
//                 //     child: ListView.builder(
//                 //         // controller: _scrollController,
//                 //         itemCount: _productDetail
//                 //             .eventsDetail![eventListSelectedIndex]
//                 //             .eventsMessage!
//                 //             .length,
//                 //         scrollDirection: Axis.vertical,
//                 //         itemBuilder: (context, index) => Container(
//                 //               //width: MediaQuery.of(context).size.width / 2.6,
//                 //               // padding: eventListSelectedIndex == index
//                 //               //     ? EdgeInsets.all(0)
//                 //               //     : EdgeInsets.all(10),
//                 //               margin: EdgeInsets.only(
//                 //                   top: 3, bottom: 3, right: 5, left: 5),
//                 //               color: Colors.transparent,
//                 //               child: InkWell(
//                 //                 onTap: () {
//                 //                   messageListSeletedIndex = index;

//                 //                   selectedOccasionString.text = _productDetail
//                 //                       .eventsDetail![eventListSelectedIndex]
//                 //                       .eventsMessage![index]
//                 //                       .message!;
//                 //                   setState(() {});
//                 //                 },
//                 //                 child: Wrap(
//                 //                   children: [
//                 //                     Container(
//                 //                       width: MediaQuery.of(context).size.width,
//                 //                       child: Align(
//                 //                         alignment: Alignment.bottomCenter,
//                 //                         child: Container(
//                 //                           padding: EdgeInsets.only(
//                 //                               left: 5,
//                 //                               right: 5,
//                 //                               top: 10,
//                 //                               bottom: 10),
//                 //                           width: double.infinity,
//                 //                           child: Text(
//                 //                             "${_productDetail.eventsDetail![eventListSelectedIndex].eventsMessage![index].message}",
//                 //                             textAlign: TextAlign.left,
//                 //                             style: TextStyle(
//                 //                               fontFamily:
//                 //                                   global.fontRailwayRegular,
//                 //                               fontSize: 14,
//                 //                               fontWeight: FontWeight.w200,
//                 //                               color: messageListSeletedIndex ==
//                 //                                       index
//                 //                                   ? ColorConstants.appColor
//                 //                                   : ColorConstants.pureBlack,
//                 //                             ),
//                 //                           ),
//                 //                         ),
//                 //                       ),
//                 //                     ),
//                 //                     Divider(
//                 //                       color: messageListSeletedIndex == index
//                 //                           ? ColorConstants.appColor
//                 //                           : ColorConstants.grey,
//                 //                       thickness: 0.5,
//                 //                       height: 0.5,
//                 //                     )
//                 //                   ],
//                 //                 ),
//                 //               ),
//                 //             )),
//                 //   ),
//                 // ),

//                 // Padding(
//                 //   padding: const EdgeInsets.only(left: 1, right: 1, top: 8),
//                 //   child: Container(
//                 //       height: 150,
//                 //       width: MediaQuery.of(context).size.width - 40,
//                 //       decoration: BoxDecoration(
//                 //           border: Border.all(
//                 //             width: 0.5,
//                 //             color: Colors.grey,
//                 //           ),
//                 //           color: ColorConstants.white,
//                 //           borderRadius:
//                 //               BorderRadius.all(Radius.circular(10.0))),
//                 //       child: Padding(
//                 //         padding:
//                 //             const EdgeInsets.only(left: 5, right: 5, top: 5),
//                 //         child: Row(
//                 //           mainAxisAlignment: MainAxisAlignment.start,
//                 //           crossAxisAlignment: CrossAxisAlignment.start,
//                 //           children: [
//                 //             Expanded(
//                 //               child: Container(
//                 //                   // width: 100,
//                 //                   //height: 80,
//                 //                   child: TextFormField(
//                 //                 maxLength: 250,
//                 //                 controller: selectedOccasionString,
//                 //                 maxLines: null,
//                 //                 textAlign: TextAlign.start,
//                 //                 style: TextStyle(
//                 //                     fontSize: 14,
//                 //                     fontWeight: FontWeight.w200,
//                 //                     fontFamily: global.fontRailwayRegular,
//                 //                     color: ColorConstants.pureBlack),
//                 //                 autofocus: false,
//                 //                 decoration: InputDecoration(
//                 //                   hintStyle: TextStyle(
//                 //                       fontSize: 14,
//                 //                       fontWeight: FontWeight.w200,
//                 //                       fontFamily: fontRailwayRegular,
//                 //                       color: ColorConstants.pureBlack),
//                 //                   //labelText: 'Message',
//                 //                   hintText: "Message",
//                 //                   filled: true,
//                 //                   fillColor: Colors.transparent,
//                 //                   contentPadding: const EdgeInsets.only(
//                 //                     left: 8.0,
//                 //                     right: 8.0,
//                 //                     bottom: 8.0,
//                 //                   ),
//                 //                   border: InputBorder.none,
//                 //                   focusedBorder: InputBorder.none,
//                 //                   enabledBorder: InputBorder.none,
//                 //                 ),
//                 //                 onChanged: (value) {
//                 //                   print(selectedOccasionString);
//                 //                 },
//                 //               )),
//                 //             ),
//                 //           ],
//                 //         ),
//                 //       )),
//                 // )
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 1,
//           ),
        ],
      ),
    );
  }

  Widget _relatedProducts(TextTheme textTheme) {
    return Container(
      margin: EdgeInsets.only(top: 8, bottom: 10),
      child: SizedBox(
        height: 280,
        child: ListView.builder(
          itemCount: _productDetail.similarProductList!.length,
          shrinkWrap: false,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () async {
                _isDataLoaded = false;
                productId ==
                    _productDetail.similarProductList![index].productId;
                var selcetedProduct =
                    _productDetail.similarProductList![index].productId;
                productId = selcetedProduct;
                _selectedIndex = index;
                print("G1--->${productId}");
                addCartText = "ADD To CART";
                responseMessage = "";

                _init();
                scrollTop();
                //await _getProductDetail(selcetedProduct);
              },
              child: Stack(
                children: [
                  Container(
                    width: 195,
                    //height: 275,
                    //color: Colors.amber,
                    child: GetBuilder<CartController>(
                      init: cartController,
                      builder: (value) => Card(
                        //margin: EdgeInsets.only(left: 8),
                        color: Colors.transparent,
                        elevation: 0,
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Card(
                                  elevation: 0,
                                  color: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    // side: BorderSide(
                                    //   color: ColorConstants.greyfaint,
                                    //   width: 0.5,
                                    // )
                                  ),
                                  child: Container(
                                    height: 170,
                                    color: Colors.transparent,
                                    alignment: Alignment.center,
                                    child: Stack(children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(100),
                                            topRight: Radius.circular(100)),
                                        child: CachedNetworkImage(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          fit: BoxFit.fitWidth,
                                          imageUrl:
                                              // _productDetail
                                              //                 .similarProductList[
                                              //                     index]
                                              //                 .thumbnail !=
                                              //             null &&
                                              //         _productDetail
                                              //             .similarProductList[index]
                                              //             .thumbnail
                                              //             .isNotEmpty &&
                                              //         _productDetail
                                              //                 .similarProductList[
                                              //                     index]
                                              //                 .thumbnail !=
                                              //             "N/A"
                                              //     ? global.imageBaseUrl +
                                              //         _productDetail
                                              //             .similarProductList[index]
                                              //             .thumbnail
                                              //     :
                                              global.imageBaseUrl +
                                                  _productDetail
                                                      .similarProductList![
                                                          index]
                                                      .productImage! +
                                                  "?width=500&height=500",
                                          placeholder: (context, url) => Center(
                                              child: CircularProgressIndicator(
                                            strokeWidth: 1.0,
                                          )),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                                  child: Image.asset(
                                            global.noImage,
                                            fit: BoxFit.fill,
                                            width: 175,
                                            height: 210,
                                            alignment: Alignment.center,
                                          )),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: InkWell(
                                            onTap: () async {
                                              if (global.currentUser.id ==
                                                  null) {
                                                Future.delayed(Duration.zero,
                                                    () {
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
                                                });
                                              } else {
                                                bool _isAdded =
                                                    await addRemoveWishListO(
                                                        _productDetail
                                                            .similarProductList![
                                                                index]
                                                            .varientId!);
                                                _productDetail
                                                        .similarProductList![index]
                                                        .isFavourite =
                                                    _isAdded.toString();
                                                setState(() {});
                                              }
                                            },
                                            child: _productDetail
                                                        .similarProductList![
                                                            index]
                                                        .isFavourite ==
                                                    'true'
                                                ? Icon(
                                                    MdiIcons.heart,
                                                    size: 24,
                                                    color:
                                                        ColorConstants.appColor,
                                                  )
                                                : Icon(
                                                    MdiIcons.heartOutline,
                                                    size: 24,
                                                    color:
                                                        ColorConstants.appColor,
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
                                            alignment: Alignment.bottomLeft,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: 45,
                                                  height: 22,
                                                  padding: EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomLeft: Radius
                                                                  .circular(8)),
                                                      color: ColorConstants
                                                          .ratingContainerColor),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.star,
                                                        size: 18,
                                                        color: Colors
                                                            .yellow.shade400,
                                                      ),
                                                      Text(
                                                        "${_productDetail.similarProductList![index].rating}",
                                                        style: TextStyle(
                                                            fontFamily: global
                                                                .fontRailwayRegular,
                                                            fontWeight:
                                                                FontWeight.w200,
                                                            fontSize: 11,
                                                            color:
                                                                ColorConstants
                                                                    .white),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: 22,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          8)),
                                                      color: Colors.black38),
                                                  padding: EdgeInsets.only(
                                                      bottom: 5,
                                                      top: 5,
                                                      left: 6,
                                                      right: 6),
                                                  child: Text(
                                                      "${_productDetail.similarProductList![index].ratingCount} Reviews", //"${product.countrating} Reviews",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily: global
                                                              .fontRailwayRegular,
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          fontSize: 11,
                                                          color: ColorConstants
                                                              .white)),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                      // Visibility(
                                      //   visible: _productDetail
                                      //               .similarProductList[index]
                                      //               .stock >
                                      //           0
                                      //       ? false
                                      //       : true,
                                      //   child: Container(
                                      //     alignment: Alignment.center,
                                      //     // decoration: BoxDecoration(
                                      //     //     color: Colors.white.withOpacity(0.6),
                                      //     //     borderRadius: BorderRadius.circular(5)),
                                      //     padding: const EdgeInsets.all(5),
                                      //     child: Center(
                                      //       child: Transform.rotate(
                                      //         angle: 12,
                                      //         child: Text(
                                      //           "Currently Product\nis Unavailable",
                                      //           // '${AppLocalizations.of(context).txt_out_of_stock}',
                                      //           textAlign: TextAlign.center,
                                      //           maxLines: 2,
                                      //           style: GoogleFonts.poppins(
                                      //               fontWeight:
                                      //                   FontWeight.w600,
                                      //               fontSize: 15,
                                      //               color: Colors.red),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                    ]),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5, right: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(top: 1),
                                              child: Text(
                                                "${_productDetail.similarProductList![index].productName}",
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: global
                                                        .fontRalewayMedium,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: ColorConstants
                                                        .newTextHeadingFooter),
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 8),
                                                    child: Text(
                                                      "AED ",
                                                      style: TextStyle(
                                                          fontFamily: global
                                                              .fontOufitMedium,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 15,
                                                          color: ColorConstants
                                                              .pureBlack),
                                                    ),
                                                  ),
                                                  Text(
                                                    int.parse(_productDetail
                                                                .similarProductList![
                                                                    index]
                                                                // .varient![0]
                                                                .basePrice
                                                                .toString()
                                                                .substring(_productDetail
                                                                        .similarProductList![index]
                                                                        // .varient![
                                                                        //     0]
                                                                        .basePrice
                                                                        .toString()
                                                                        .indexOf(".") +
                                                                    1)) >
                                                            0
                                                        ? "${_productDetail.similarProductList![index] /*.varient![0]*/ .basePrice!.toStringAsFixed(2)}"
                                                        : "${_productDetail.similarProductList![index] /*.varient![0]*/ .basePrice.toString().substring(0, _productDetail.similarProductList![index] /*.varient![0]*/ .basePrice.toString().indexOf("."))}",
                                                    //"${product.varient[0].buyingPrice}",
                                                    style: TextStyle(
                                                        fontFamily: global
                                                            .fontOufitMedium,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15,
                                                        color: ColorConstants
                                                            .pureBlack),
                                                  ),
                                                  _productDetail
                                                              .similarProductList![
                                                                  index]
                                                              // .varient![0]
                                                              .basePrice! <
                                                          _productDetail
                                                              .similarProductList![
                                                                  index]
                                                              // .varient![0]
                                                              .baseMrp!
                                                      ? Stack(children: [
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 8),
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 2,
                                                                    bottom: 2),
                                                            child: Text(
                                                              int.parse(_productDetail
                                                                          .similarProductList![index]
                                                                          // .varient![
                                                                          //     0]
                                                                          .baseMrp
                                                                          .toString()
                                                                          .substring(_productDetail.similarProductList![index] /*.varient![0]*/ .baseMrp.toString().indexOf(".") + 1)) >
                                                                      0
                                                                  ? "( ${_productDetail.similarProductList![index] /*.varient![0]*/ .baseMrp!.toStringAsFixed(2)} )"
                                                                  : "( ${_productDetail.similarProductList![index] /*.varient![0]*/ .baseMrp.toString().substring(0, _productDetail.similarProductList![index] /*.varient![0]*/ .baseMrp.toString().indexOf("."))} )",
                                                              style: TextStyle(
                                                                  fontFamily: global
                                                                      .fontOufitMedium,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 8),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Center(
                                                              child: Transform
                                                                  .rotate(
                                                                angle: 0,
                                                                child: Text(
                                                                  "-----",
                                                                  // '${AppLocalizations.of(context).txt_out_of_stock}',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  maxLines: 1,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          global
                                                                              .fontOufitMedium,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ])
                                                      : SizedBox(),
                                                  // Container(
                                                  //   margin: EdgeInsets.only(
                                                  //       left: 3, right: 2),
                                                  //   child: Text(
                                                  //     _productDetail
                                                  //             .similarProductList[
                                                  //                 index]
                                                  //             .varient[0]
                                                  //             .discountper
                                                  //             .toString()
                                                  //             .startsWith("-")
                                                  //         ? "${_productDetail.similarProductList[index].varient[0].discountper.toString().substring(1)}% off"
                                                  //         : "${_productDetail.similarProductList[index].varient[0].discountper}% off",
                                                  //     style: TextStyle(
                                                  //         fontFamily: global
                                                  //             .fontRailwayRegular,
                                                  //         fontWeight:
                                                  //             FontWeight.w200,
                                                  //         fontSize: 12,
                                                  //         color:
                                                  //             ColorConstants.green),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                            _productDetail
                                                        .similarProductList![
                                                            index]
                                                        .stock! >
                                                    0
                                                ? Container(
                                                    margin: EdgeInsets.only(
                                                        top: 5,
                                                        left: 3,
                                                        right: 3),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Container(
                                                          child: _productDetail
                                                                              .similarProductList![
                                                                                  index]
                                                                              .delivery !=
                                                                          null &&
                                                                      _productDetail
                                                                              .similarProductList![
                                                                                  index]
                                                                              .delivery ==
                                                                          "1" ||
                                                                  _productDetail
                                                                          .similarProductList![
                                                                              index]
                                                                          .delivery ==
                                                                      "Today"
                                                              ? Text(
                                                                  "Express",
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
                                                                          .appColor),
                                                                )
                                                              : _productDetail.similarProductList![index].delivery !=
                                                                              null &&
                                                                          _productDetail.similarProductList![index].delivery ==
                                                                              "2" ||
                                                                      _productDetail
                                                                              .similarProductList![
                                                                                  index]
                                                                              .delivery ==
                                                                          "Tomorrow"
                                                                  ? Text(
                                                                      "Today",
                                                                      style: TextStyle(
                                                                          fontFamily: global
                                                                              .fontRailwayRegular,
                                                                          fontWeight: FontWeight
                                                                              .w200,
                                                                          fontSize:
                                                                              13,
                                                                          color:
                                                                              ColorConstants.appColor),
                                                                    )
                                                                  : _productDetail.similarProductList![index].delivery !=
                                                                              null &&
                                                                          _productDetail.similarProductList![index].delivery ==
                                                                              "3"
                                                                      ? Text(
                                                                          "Tomorrow",
                                                                          style: TextStyle(
                                                                              fontFamily: global.fontRailwayRegular,
                                                                              fontWeight: FontWeight.w200,
                                                                              fontSize: 13,
                                                                              color: ColorConstants.appColor),
                                                                        )
                                                                      : Text(
                                                                          _productDetail.similarProductList![index].delivery == null || _productDetail.similarProductList![index].delivery == ""
                                                                              ? "Tomorrow"
                                                                              : "${int.parse(_productDetail.similarProductList![index].delivery!) - 2} days",
                                                                          style: TextStyle(
                                                                              fontFamily: global.fontRailwayRegular,
                                                                              fontWeight: FontWeight.w200,
                                                                              fontSize: 13,
                                                                              color: ColorConstants.appColor),
                                                                        ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Container(),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            _productDetail
                                                        .similarProductList![
                                                            index]
                                                        .cartQty ==
                                                    0
                                                ? InkWell(
                                                    onTap: () {
                                                      print(
                                                          "Nikhil-----this is on pressed");

                                                      addToCart(
                                                          1,
                                                          _productDetail
                                                              .similarProductList![
                                                                  index]
                                                              .varientId!);
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 2,
                                                              right: 2),
                                                      child: Container(
                                                        height: 25,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3.2,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color:
                                                                ColorConstants
                                                                    .appColor,
                                                            border: Border.all(
                                                                width: 0.5,
                                                                color: ColorConstants
                                                                    .appColor)),
                                                        child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            // product.cartQty != 0
                                                            //     ? "GO TO CART"
                                                            // :
                                                            addCartText,
                                                            style: TextStyle(
                                                                fontFamily: global
                                                                    .fontOufitMedium,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12,
                                                                color:
                                                                    ColorConstants
                                                                        .white,
                                                                letterSpacing:
                                                                    1),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3.2,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            width: 0.5,
                                                            color:
                                                                ColorConstants
                                                                    .appColor)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            print("nikhil");
                                                            if (_productDetail
                                                                    .similarProductList![
                                                                        index]
                                                                    .cartQty! >
                                                                0) {
                                                              addToCart(
                                                                  _productDetail
                                                                          .boughtTogetherProduct![
                                                                              index]
                                                                          .cartQty! -
                                                                      1,
                                                                  _productDetail
                                                                      .similarProductList![
                                                                          index]
                                                                      .varientId!);
                                                              _qty = _qty! - 1;
                                                            }

                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 5),
                                                            width: 25,
                                                            height: 25,
                                                            child: _productDetail
                                                                            .similarProductList![
                                                                                index]
                                                                            .cartQty !=
                                                                        null &&
                                                                    _productDetail
                                                                            .similarProductList![index]
                                                                            .cartQty ==
                                                                        1
                                                                ? Icon(
                                                                    FontAwesomeIcons
                                                                        .trashCan,
                                                                    size: 14.0,
                                                                    color: ColorConstants
                                                                        .newTextHeadingFooter,
                                                                  )
                                                                : Icon(
                                                                    MdiIcons
                                                                        .minus,
                                                                    size: 14.0,
                                                                    color: ColorConstants
                                                                        .newTextHeadingFooter,
                                                                  ),
                                                          ),
                                                        ),
                                                        Text(
                                                          _productDetail
                                                                      .similarProductList![
                                                                          index]
                                                                      .cartQty !=
                                                                  0
                                                              ? "${_productDetail.similarProductList![index].cartQty}"
                                                              : "${_qty}",
                                                          style: TextStyle(
                                                            fontFamily: global
                                                                .fontRailwayRegular,
                                                            fontWeight:
                                                                FontWeight.w200,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            if (_productDetail
                                                                    .similarProductList![
                                                                        index]
                                                                    .cartQty !=
                                                                0) {
                                                              _productDetail
                                                                  .similarProductList![
                                                                      index]
                                                                  .cartQty = _productDetail
                                                                      .similarProductList![
                                                                          index]
                                                                      .cartQty! +
                                                                  1;
                                                            }
                                                            _qty = _qty! + 1;
                                                            addToCart(
                                                                _productDetail
                                                                        .boughtTogetherProduct![
                                                                            index]
                                                                        .cartQty! +
                                                                    1,
                                                                _productDetail
                                                                    .similarProductList![
                                                                        index]
                                                                    .varientId!);
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 5),
                                                            width: 25,
                                                            height: 25,
                                                            child: Icon(
                                                              MdiIcons.plus,
                                                              size: 20,
                                                              color: ColorConstants
                                                                  .newTextHeadingFooter,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            _productDetail.similarProductList![index].stock! > 0
                                ? Container()
                                : Container(
                                    // width: 160,
                                    alignment: Alignment.center,
                                    decoration: new BoxDecoration(
                                        color: Colors.white.withOpacity(0.7)),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _productDetail.similarProductList![index].stock! > 0
                      ? Positioned(
                          left: 4,
                          top: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(1),
                            child: _productDetail.similarProductList![index]
                                            .discount !=
                                        null &&
                                    _productDetail.similarProductList![index]
                                            .discount >
                                        0
                                ? Container(
                                    height: 35,
                                    width: 30,
                                    /*decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    bottomRight: Radius.circular(4),
                                  ),
                                ),*/
                                    decoration: BoxDecoration(
                                      //color: ColorConstants.green,
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
                                        "${_productDetail.similarProductList![index].discount}%\nOFF",
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
                          bottom: 10,
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
                                        fontFamily: global.fontRailwayRegular,
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
          },
        ),
      ),
    );
  }

  Widget _boughtTogetherProducts(TextTheme textTheme) {
    return Container(
      margin: EdgeInsets.only(top: 8, bottom: 10),
      child: SizedBox(
        height: 280,
        child: ListView.builder(
          itemCount: _productDetail.boughtTogetherProduct!.length,
          shrinkWrap: false,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () async {
                _isDataLoaded = false;
                productId ==
                    _productDetail.boughtTogetherProduct![index].productId;
                var selcetedProduct =
                    _productDetail.boughtTogetherProduct![index].productId;
                productId = selcetedProduct;
                _selectedIndex = index;
                print("G1--->${productId}");
                addCartText = "ADD To CART";
                responseMessage = "";

                _init();
                scrollTop();
                //await _getProductDetail(selcetedProduct);
              },
              child: Stack(
                children: [
                  Container(
                    width: 195,
                    //height: 275,
                    //color: Colors.amber,
                    child: GetBuilder<CartController>(
                      init: cartController,
                      builder: (value) => Card(
                        //margin: EdgeInsets.only(left: 8),
                        color: Colors.transparent,
                        elevation: 0,
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Card(
                                  elevation: 0,
                                  color: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    // side: BorderSide(
                                    //   color: ColorConstants.greyfaint,
                                    //   width: 0.5,
                                    // )
                                  ),
                                  child: Container(
                                    height: 170,
                                    color: Colors.transparent,
                                    alignment: Alignment.center,
                                    child: Stack(children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(100),
                                            topRight: Radius.circular(100)),
                                        child: CachedNetworkImage(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          fit: BoxFit.fitWidth,
                                          imageUrl:
                                              // _productDetail
                                              //                 .similarProductList[
                                              //                     index]
                                              //                 .thumbnail !=
                                              //             null &&
                                              //         _productDetail
                                              //             .similarProductList[index]
                                              //             .thumbnail
                                              //             .isNotEmpty &&
                                              //         _productDetail
                                              //                 .similarProductList[
                                              //                     index]
                                              //                 .thumbnail !=
                                              //             "N/A"
                                              //     ? global.imageBaseUrl +
                                              //         _productDetail
                                              //             .similarProductList[index]
                                              //             .thumbnail
                                              //     :
                                              global.imageBaseUrl +
                                                  _productDetail
                                                      .boughtTogetherProduct![
                                                          index]
                                                      .productImage! +
                                                  "?width=500&height=500",
                                          placeholder: (context, url) => Center(
                                              child: CircularProgressIndicator(
                                            strokeWidth: 1.0,
                                          )),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                                  child: Image.asset(
                                            global.noImage,
                                            fit: BoxFit.fill,
                                            width: 175,
                                            height: 210,
                                            alignment: Alignment.center,
                                          )),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: InkWell(
                                            onTap: () async {
                                              if (global.currentUser.id ==
                                                  null) {
                                                Future.delayed(Duration.zero,
                                                    () {
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
                                                });
                                              } else {
                                                bool _isAdded =
                                                    await addRemoveWishListO(
                                                        _productDetail
                                                            .boughtTogetherProduct![
                                                                index]
                                                            .varientId!);
                                                _productDetail
                                                        .boughtTogetherProduct![
                                                            index]
                                                        .isFavourite =
                                                    _isAdded.toString();
                                                setState(() {});
                                              }
                                            },
                                            child: _productDetail
                                                        .boughtTogetherProduct![
                                                            index]
                                                        .isFavourite ==
                                                    'true'
                                                ? Icon(
                                                    MdiIcons.heart,
                                                    size: 24,
                                                    color:
                                                        ColorConstants.appColor,
                                                  )
                                                : Icon(
                                                    MdiIcons.heartOutline,
                                                    size: 24,
                                                    color:
                                                        ColorConstants.appColor,
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
                                            alignment: Alignment.bottomLeft,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: 45,
                                                  height: 22,
                                                  padding: EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomLeft: Radius
                                                                  .circular(8)),
                                                      color: ColorConstants
                                                          .ratingContainerColor),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.star,
                                                        size: 18,
                                                        color: ColorConstants
                                                            .appColor,
                                                      ),
                                                      Text(
                                                        "${_productDetail.boughtTogetherProduct![index].rating}",
                                                        style: TextStyle(
                                                            fontFamily: global
                                                                .fontRailwayRegular,
                                                            fontWeight:
                                                                FontWeight.w200,
                                                            fontSize: 11,
                                                            color:
                                                                ColorConstants
                                                                    .white),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: 22,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          8)),
                                                      color: Colors.black38),
                                                  padding: EdgeInsets.only(
                                                      bottom: 5,
                                                      top: 5,
                                                      left: 6,
                                                      right: 6),
                                                  child: Text(
                                                      "${_productDetail.boughtTogetherProduct![index].ratingCount} Reviews", //"${product.countrating} Reviews",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily: global
                                                              .fontRailwayRegular,
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          fontSize: 11,
                                                          color: ColorConstants
                                                              .white)),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                      // Visibility(
                                      //   visible: _productDetail
                                      //               .similarProductList[index]
                                      //               .stock >
                                      //           0
                                      //       ? false
                                      //       : true,
                                      //   child: Container(
                                      //     alignment: Alignment.center,
                                      //     // decoration: BoxDecoration(
                                      //     //     color: Colors.white.withOpacity(0.6),
                                      //     //     borderRadius: BorderRadius.circular(5)),
                                      //     padding: const EdgeInsets.all(5),
                                      //     child: Center(
                                      //       child: Transform.rotate(
                                      //         angle: 12,
                                      //         child: Text(
                                      //           "Currently Product\nis Unavailable",
                                      //           // '${AppLocalizations.of(context).txt_out_of_stock}',
                                      //           textAlign: TextAlign.center,
                                      //           maxLines: 2,
                                      //           style: GoogleFonts.poppins(
                                      //               fontWeight:
                                      //                   FontWeight.w600,
                                      //               fontSize: 15,
                                      //               color: Colors.red),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                    ]),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5, right: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(top: 1),
                                              child: Text(
                                                "${_productDetail.boughtTogetherProduct![index].productName}",
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: global
                                                        .fontRalewayMedium,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: ColorConstants
                                                        .pureBlack),
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 8),
                                                    child: Text(
                                                      "AED ",
                                                      style: TextStyle(
                                                          fontFamily: global
                                                              .fontOufitMedium,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 15,
                                                          color: ColorConstants
                                                              .pureBlack),
                                                    ),
                                                  ),
                                                  Text(
                                                    int.parse(_productDetail
                                                                .boughtTogetherProduct![
                                                                    index]
                                                                // .varient![0]
                                                                .basePrice
                                                                .toString()
                                                                .substring(_productDetail
                                                                        .boughtTogetherProduct![index]
                                                                        // .varient![
                                                                        //     0]
                                                                        .basePrice
                                                                        .toString()
                                                                        .indexOf(".") +
                                                                    1)) >
                                                            0
                                                        ? "${_productDetail.boughtTogetherProduct![index] /*.varient![0]*/ .basePrice!.toStringAsFixed(2)}"
                                                        : "${_productDetail.boughtTogetherProduct![index] /*.varient![0]*/ .basePrice.toString().substring(0, _productDetail.boughtTogetherProduct![index] /*.varient![0]*/ .basePrice.toString().indexOf("."))}",
                                                    //"${product.varient[0].buyingPrice}",
                                                    style: TextStyle(
                                                        fontFamily: global
                                                            .fontOufitMedium,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15,
                                                        color: ColorConstants
                                                            .pureBlack),
                                                  ),
                                                  _productDetail
                                                              .boughtTogetherProduct![
                                                                  index]
                                                              // .varient![0]
                                                              .basePrice! <
                                                          _productDetail
                                                              .boughtTogetherProduct![
                                                                  index]
                                                              // .varient![0]
                                                              .baseMrp!
                                                      ? Stack(children: [
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 8),
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 2,
                                                                    bottom: 2),
                                                            child: Text(
                                                              int.parse(_productDetail
                                                                          .boughtTogetherProduct![index]
                                                                          // .varient![
                                                                          //     0]
                                                                          .baseMrp
                                                                          .toString()
                                                                          .substring(_productDetail.boughtTogetherProduct![index] /*.varient![0]*/ .baseMrp.toString().indexOf(".") + 1)) >
                                                                      0
                                                                  ? "( ${_productDetail.boughtTogetherProduct![index] /*.varient![0]*/ .baseMrp!.toStringAsFixed(2)} )"
                                                                  : "( ${_productDetail.boughtTogetherProduct![index] /*.varient![0]*/ .baseMrp.toString().substring(0, _productDetail.boughtTogetherProduct![index] /*.varient![0]*/ .baseMrp.toString().indexOf("."))} )",
                                                              style: TextStyle(
                                                                  fontFamily: global
                                                                      .fontOufitMedium,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 8),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Center(
                                                              child: Transform
                                                                  .rotate(
                                                                angle: 0,
                                                                child: Text(
                                                                  "-----",
                                                                  // '${AppLocalizations.of(context).txt_out_of_stock}',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  maxLines: 1,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          global
                                                                              .fontOufitMedium,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ])
                                                      : SizedBox(),
                                                ],
                                              ),
                                            ),
                                            _productDetail
                                                        .boughtTogetherProduct![
                                                            index]
                                                        .stock! >
                                                    0
                                                ? Container(
                                                    margin: EdgeInsets.only(
                                                        top: 5,
                                                        left: 3,
                                                        right: 3),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Container(
                                                          child: _productDetail
                                                                              .boughtTogetherProduct![
                                                                                  index]
                                                                              .delivery !=
                                                                          null &&
                                                                      _productDetail
                                                                              .boughtTogetherProduct![
                                                                                  index]
                                                                              .delivery ==
                                                                          "1" ||
                                                                  _productDetail
                                                                          .boughtTogetherProduct![
                                                                              index]
                                                                          .delivery ==
                                                                      "Today"
                                                              ? Text(
                                                                  "Express",
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
                                                                          .appColor),
                                                                )
                                                              : _productDetail.boughtTogetherProduct![index].delivery !=
                                                                              null &&
                                                                          _productDetail.boughtTogetherProduct![index].delivery ==
                                                                              "2" ||
                                                                      _productDetail
                                                                              .boughtTogetherProduct![
                                                                                  index]
                                                                              .delivery ==
                                                                          "Tomorrow"
                                                                  ? Text(
                                                                      "Today",
                                                                      style: TextStyle(
                                                                          fontFamily: global
                                                                              .fontRailwayRegular,
                                                                          fontWeight: FontWeight
                                                                              .w200,
                                                                          fontSize:
                                                                              13,
                                                                          color:
                                                                              ColorConstants.appColor),
                                                                    )
                                                                  : _productDetail.boughtTogetherProduct![index].delivery !=
                                                                              null &&
                                                                          _productDetail.boughtTogetherProduct![index].delivery ==
                                                                              "3"
                                                                      ? Text(
                                                                          "Tomorrow",
                                                                          style: TextStyle(
                                                                              fontFamily: global.fontRailwayRegular,
                                                                              fontWeight: FontWeight.w200,
                                                                              fontSize: 13,
                                                                              color: ColorConstants.appColor),
                                                                        )
                                                                      : Text(
                                                                          _productDetail.boughtTogetherProduct![index].delivery == null || _productDetail.similarProductList![index].delivery == ""
                                                                              ? "Tomorrow"
                                                                              : "${int.parse(_productDetail.boughtTogetherProduct![index].delivery!) - 2} days",
                                                                          style: TextStyle(
                                                                              fontFamily: global.fontRailwayRegular,
                                                                              fontWeight: FontWeight.w200,
                                                                              fontSize: 13,
                                                                              color: ColorConstants.appColor),
                                                                        ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Container(),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            _productDetail
                                                        .boughtTogetherProduct![
                                                            index]
                                                        .cartQty ==
                                                    0
                                                ? InkWell(
                                                    onTap: () {
                                                      print(
                                                          "Nikhil-----this is on pressed");

                                                      addToCart(
                                                          1,
                                                          _productDetail
                                                              .boughtTogetherProduct![
                                                                  index]
                                                              .varientId!);
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 2,
                                                              right: 2),
                                                      child: Container(
                                                        height: 25,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3.2,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color:
                                                                ColorConstants
                                                                    .appColor,
                                                            border: Border.all(
                                                                width: 0.5,
                                                                color: ColorConstants
                                                                    .appColor)),
                                                        child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            // product.cartQty != 0
                                                            //     ? "GO TO CART"
                                                            // :
                                                            addCartText,
                                                            style: TextStyle(
                                                                fontFamily: global
                                                                    .fontOufitMedium,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12,
                                                                color:
                                                                    ColorConstants
                                                                        .white,
                                                                letterSpacing:
                                                                    1),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3.2,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            width: 0.5,
                                                            color:
                                                                ColorConstants
                                                                    .appColor)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            print("nikhil");
                                                            if (_productDetail
                                                                    .boughtTogetherProduct![
                                                                        index]
                                                                    .cartQty! >=
                                                                0) {
                                                              addToCart(
                                                                  _productDetail
                                                                          .boughtTogetherProduct![
                                                                              index]
                                                                          .cartQty! -
                                                                      1,
                                                                  _productDetail
                                                                      .boughtTogetherProduct![
                                                                          index]
                                                                      .varientId!);
                                                              _qty = _qty! - 1;
                                                            }

                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 5),
                                                            width: 25,
                                                            height: 25,
                                                            child: _productDetail
                                                                            .boughtTogetherProduct![
                                                                                index]
                                                                            .cartQty !=
                                                                        null &&
                                                                    _productDetail
                                                                            .boughtTogetherProduct![index]
                                                                            .cartQty ==
                                                                        1
                                                                ? Icon(
                                                                    FontAwesomeIcons
                                                                        .trashCan,
                                                                    size: 14.0,
                                                                    color: ColorConstants
                                                                        .newTextHeadingFooter,
                                                                  )
                                                                : Icon(
                                                                    MdiIcons
                                                                        .minus,
                                                                    size: 14.0,
                                                                    color: ColorConstants
                                                                        .newTextHeadingFooter,
                                                                  ),
                                                          ),
                                                        ),
                                                        Text(
                                                          _productDetail
                                                                      .boughtTogetherProduct![
                                                                          index]
                                                                      .cartQty !=
                                                                  0
                                                              ? "${_productDetail.boughtTogetherProduct![index].cartQty}"
                                                              : "${_qty}",
                                                          style: TextStyle(
                                                            fontFamily: global
                                                                .fontRailwayRegular,
                                                            fontWeight:
                                                                FontWeight.w200,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            if (_productDetail
                                                                    .boughtTogetherProduct![
                                                                        index]
                                                                    .cartQty !=
                                                                0) {
                                                              _productDetail
                                                                  .boughtTogetherProduct![
                                                                      index]
                                                                  .cartQty = _productDetail
                                                                      .boughtTogetherProduct![
                                                                          index]
                                                                      .cartQty! +
                                                                  1;
                                                            }
                                                            _qty = _qty! + 1;
                                                            addToCart(
                                                                _productDetail
                                                                        .boughtTogetherProduct![
                                                                            index]
                                                                        .cartQty! +
                                                                    1,
                                                                _productDetail
                                                                    .similarProductList![
                                                                        index]
                                                                    .varientId!);
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 5),
                                                            width: 25,
                                                            height: 25,
                                                            child: Icon(
                                                              MdiIcons.plus,
                                                              size: 20,
                                                              color: ColorConstants
                                                                  .newTextHeadingFooter,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            _productDetail
                                        .boughtTogetherProduct![index].stock! >
                                    0
                                ? Container()
                                : Container(
                                    // width: 160,
                                    alignment: Alignment.center,
                                    decoration: new BoxDecoration(
                                        color: Colors.white.withOpacity(0.7)),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _productDetail.boughtTogetherProduct![index].stock! > 0
                      ? Positioned(
                          left: 4,
                          top: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(1),
                            child: _productDetail.boughtTogetherProduct![index]
                                            .discount !=
                                        null &&
                                    _productDetail.boughtTogetherProduct![index]
                                            .discount >
                                        0
                                ? Container(
                                    height: 35,
                                    width: 30,
                                    /*decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    bottomRight: Radius.circular(4),
                                  ),
                                ),*/
                                    decoration: BoxDecoration(
                                      //color: ColorConstants.green,
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
                                        "${_productDetail.boughtTogetherProduct![index].discount}%\nOFF",
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
                          bottom: 10,
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
                                        fontFamily: global.fontRailwayRegular,
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
          },
        ),
      ),
    );
  }

  // Widget _ratingAndReviews(TextTheme textTheme) {
  //AAAC useless code
  //   return Container(
  //     width: MediaQuery.of(context).size.width,
  //     height: MediaQuery.of(context).size.width / 3,
  //     margin: EdgeInsets.only(top: 8, bottom: 8, left: 10),
  //     child: ListView.builder(
  //       itemCount: _productDetail.ratingReview!.length,
  //       shrinkWrap: false,
  //       scrollDirection: Axis.horizontal,
  //       itemBuilder: (BuildContext context, int index) {
  //         return InkWell(
  //           onTap: () {
  //             // _isDataLoaded = false;
  //             // productId == _productDetail.similarProductList[index].productId;
  //             // var selcetedProduct =
  //             //     _productDetail.similarProductList[index].productId;
  //             // productId = selcetedProduct;
  //             // _selectedIndex = index;
  //             // print("G1--->${productId}");
  //             // // _init();
  //             // _getProductDetail();
  //           },
  //           child: Container(
  //             width: (MediaQuery.of(context).size.width / 2) + 70,
  //             child: GetBuilder<CartController>(
  //               init: cartController,
  //               builder: (value) => Card(
  //                 color: Colors.white,
  //                 shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(10.0),
  //                     side: BorderSide(
  //                       color: ColorConstants.greyfaint,
  //                       width: 0.5,
  //                     )),
  //                 // shape: RoundedRectangleBorder(
  //                 //   side: BorderSide(
  //                 //     color: Color(0xffF4F4F4),
  //                 //     width: 1.5,
  //                 //   ),
  //                 //   borderRadius: BorderRadius.circular(4.0),
  //                 // ),
  //                 elevation: 0,
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Container(
  //                       padding: const EdgeInsets.only(top: 10, left: 10),
  //                       width: (MediaQuery.of(context).size.width / 2),
  //                       //color: Colors.amber,
  //                       child: Text(
  //                         "${_productDetail.ratingReview![index].user_name}",
  //                         style: TextStyle(
  //                           fontSize: 15,
  //                           fontFamily: global.fontRailwayRegular,
  //                           fontWeight: FontWeight.w500,
  //                         ),
  //                         maxLines: 1,
  //                         overflow: TextOverflow.ellipsis,
  //                       ),
  //                     ),
  //                     Container(
  //                       padding: const EdgeInsets.only(top: 10, left: 10),
  //                       child: RatingBar.builder(
  //                         initialRating: double.parse(
  //                             _productDetail.ratingReview![index].rating!),
  //                         minRating: 1,
  //                         direction: Axis.horizontal,
  //                         allowHalfRating: true,
  //                         updateOnDrag: false,
  //                         ignoreGestures: true,
  //                         itemCount: 5,
  //                         itemSize: 20,
  //                         itemPadding: EdgeInsets.symmetric(horizontal: 0.5),
  //                         itemBuilder: (context, _) => Icon(
  //                           Icons.star,
  //                           color: Colors.amber,
  //                         ),
  //                         onRatingUpdate: (rating) {
  //                           print(rating);
  //                         },
  //                       ),
  //                     ),
  //                     Container(
  //                       padding: const EdgeInsets.only(top: 10, left: 10),
  //                       width: (MediaQuery.of(context).size.width / 2) + 50,
  //                       height: (MediaQuery.of(context).size.width / 2) - 150,
  //                       //color: Colors.amber,
  //                       child: Text(
  //                         _productDetail.ratingReview![index].description!,
  //                         style: TextStyle(
  //                           fontSize: 13,
  //                           fontFamily: global.fontRailwayRegular,
  //                           fontWeight: FontWeight.w200,
  //                         ),
  //                         maxLines: 2,
  //                         overflow: TextOverflow.ellipsis,
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  void addToCartRO(int qty) async {
    showOnlyLoaderDialog();
    print("Nikhil Add To Cart RO");
    try {
      bool isSuccess = false;
      String message = '--';

      await apiHelper
          .addToCart(
              qty: qty,
              varientId: _productDetail.productDetail!.varientId,
              special: 0,
              deliveryDate: "",
              deliveryTime: "",
              repeat_orders: "0")
          .then((result) async {
        if (result != null) {
          FirebaseAnalyticsGA4().callAnalyticsAddCart(
              _productDetail.productDetail!.productId!,
              _productDetail.productDetail!.productName!,
              "",
              _productDetail.productDetail!.varientId!,
              '',
              _productDetail.productDetail!.price!,
              _qty,
              _productDetail.productDetail!.mrp!,
              false,
              false);
          if (global.cartCount > 0) {
            global.cartCount = global.cartCount - 1;
          } else {
            global.cartCount = 0;
          }
          _productDetail.productDetail!.cartQty = 0;
          addCartText = "Add To Cart";

          _qty = 1;
          hideloadershowing();
          cartController.getCartList();
          await _init();
          setState(() {});
        } else {
          isSuccess = false;
          message = 'Something went wrong please try after some time';
        }
      });
      // return ATCMS(isSuccess: isSuccess, message: message);
    } catch (e) {
      print("Exception -  cart_controller.dart - addToCart():" + e.toString());
      return null;
    }
  }

  void addToCart(int qty, int varientID) async {
    showOnlyLoaderDialog();
    print("Nikhil Add To Cart RO");
    try {
      bool isSuccess = false;
      String message = '--';

      await apiHelper
          .addToCart(
              qty: qty,
              varientId: varientID,
              special: 0,
              deliveryDate: "",
              deliveryTime: "",
              repeat_orders: "0")
          .then((result) async {
        if (result != null) {
          if (global.cartCount > 0) {
            global.cartCount = global.cartCount - 1;
          } else {
            global.cartCount = 0;
          }
          _productDetail.productDetail!.cartQty = 0;
          addCartText = "ADD To CART";

          _qty = 1;
          hideloadershowing();
          cartController.getCartList();
          await _init();
          setState(() {});
        } else {
          isSuccess = false;
          message = 'Something went wrong please try after some time';
        }
      });
      // return ATCMS(isSuccess: isSuccess, message: message);
    } catch (e) {
      print("Exception -  cart_controller.dart - addToCart():" + e.toString());
      return null;
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 260,
                  child: Card(
                    elevation: 0,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                width: MediaQuery.of(context).size.width,
                child: Card(elevation: 0),
              ),
              SizedBox(
                height: 40,
                width: MediaQuery.of(context).size.width,
                child: Card(elevation: 0),
              ),
              SizedBox(
                height: 40,
                width: MediaQuery.of(context).size.width,
                child: Card(elevation: 0),
              ),
              SizedBox(
                height: 40,
                width: MediaQuery.of(context).size.width,
                child: Card(elevation: 0),
              ),
              SizedBox(
                height: 100,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: SizedBox(
                            width: 70,
                            child: Card(
                              elevation: 0,
                            )),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
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
            }),
        backgroundColor: Colors.grey,
      ));
    } catch (e) {
      print("Exception -  base.dart - showNetworkErrorSnackBar1():" +
          e.toString());
    }
  }

  int? _selectedMessage;

  void scrollTop() {
    _scrollController1.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  removeProfileImage() async {
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog();
        CurrentUser _user = new CurrentUser();
        // _user.name = _cName.text;

        await apiHelper.removeProfileImage(_user).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              hideLoader();
              _init();
              // showSnackBar(key: _scaffoldKey, snackBarMessage: "${AppLocalizations.of(context).txt_profile_updated_successfully}");
            } else {
              hideLoader();
              showSnackBar(
                  key: _scaffoldKey,
                  snackBarMessage: result.message.toString());
            }
          }
        });
        // await apiHelper.updateFirebaseUser(global.currentUser);
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - profile_edit_screen.dart - _save()e:" + e.toString());
    }
  }

  _showCupertinoModalSheet(int index) {
    try {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: Text('Choose'),
          actions: [
            CupertinoActionSheetAction(
              child: Text(
                'Capture',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
              ),
              onPressed: () async {
                Navigator.pop(context);
                _productDetail.otherDetails![index].setImagePath =
                    await br!.openCamera();

                // if (_tImage != null && _tImage.length > index) {
                //   _tImage.removeAt(index);
                //   File imageFile = await br.openCamera();
                //   if (imageFile != null) {
                //     print("this is the imageFile 123 ${imageFile.path}");
                //     _tImage[index] = imageFile.path;
                //     print("this is the imageFile 123 ${_tImage[0]}");
                //   }
                // } else {
                //   File imageFile = await br.openCamera();
                //   print(
                //       "this is the imageFile path from Capture image ${imageFile.path}");
                //   if (imageFile != null) {
                //     print("this is the imageFile 123 ${imageFile.path}");
                //     _tImage.add(imageFile.path);
                //     print("this is the imageFile 123 ${_tImage[0]}");
                //   }
                // }
                // print(
                //     "this is the image list length from Capture image ${_tImage.length}");
                // global.selectedImage = _tImage.path;

                setState(() {});
              },
            ),
            CupertinoActionSheetAction(
              child: Text(
                'Upload Image',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
              ),
              onPressed: () async {
                Navigator.pop(context);
                _productDetail.otherDetails![index].setImagePath =
                    await br!.selectImageFromGallery();
                // if (_tImage != null && _tImage.length > index) {
                //   _tImage.removeAt(index);
                //   File imageFile = await br.selectImageFromGallery();
                //   if (imageFile != null) {
                //     print("this is the imageFile 123 ${imageFile.path}");
                //     _tImage[index] = imageFile.path;
                //     print("this is the imageFile 123 ${_tImage[0]}");
                //   }
                // } else {
                //   File imageFile = await br.selectImageFromGallery();
                //   if (imageFile != null) {
                //     print("this is the imageFile 123 ${imageFile.path}");
                //     _tImage.add(imageFile.path);
                //     print("this is the imageFile 123 ${_tImage[0]}");
                //   }
                // }

                // global.selectedImage = _tImage.path;
                print(
                    "this is the image list length from upload image ${_tImage.length}");
                setState(() {});
              },
            ),
            CupertinoActionSheetAction(
              child: Text(
                'Remove Image',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
              ),
              onPressed: () async {
                Navigator.pop(context);
                _tImage = _tImage;

                removeProfileImage();
                setState(() {});
              },
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('Cancel',
                style: TextStyle(color: Theme.of(context).primaryColor)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
    } catch (e) {
      print(
          "Exception - profile_edit_screen.dart - _showCupertinoModalSheet():" +
              e.toString());
    }
  }

  Future<Image> convertFileToImage(File picture) async {
    List<int> imageBase64 = picture.readAsBytesSync();
    String imageAsString = base64Encode(imageBase64);
    Uint8List uint8list = base64.decode(imageAsString);
    Image image = Image.memory(uint8list);
    return image;
  }

  Future<bool> addRemoveWishListO(int varientId) async {
    bool _isAddedSuccesFully = false;
    try {
      showOnlyLoaderDialog();
      await apiHelper.addRemoveWishList(varientId).then((result) async {
        if (result != null) {
          if (result.status == "1") {
            _isAddedSuccesFully = true;
          } else if (result.status == "2") {
            _isAddedSuccesFully = false;
          } else {
            _isAddedSuccesFully = false;
          }
        }
      });
      hideLoader();
      return _isAddedSuccesFully;
    } catch (e) {
      hideLoader();
      print("Exception - base.dart - addRemoveWishList():" + e.toString());
      return _isAddedSuccesFully;
    }
  }
}
