import 'dart:io';

import 'package:byyu/screens/home_screen.dart';
import 'package:byyu/screens/location_view/location_screen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/controllers/cart_controller.dart';
import 'package:byyu/models/addressModel.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/models/orderModel.dart';
import 'package:byyu/models/timeSlotModel.dart';

import 'package:byyu/screens/payment_view/payment_screen.dart';

import 'package:byyu/widgets/toastfile.dart';
import 'package:get/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class CheckoutScreen extends BaseRoute {
  CartController? cartController;
  bool? fromProfile;
  CheckoutScreen({a, o, this.cartController, this.fromProfile})
      : super(a: a, o: o, r: 'CheckoutScreen');

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState(
      cartController: cartController, fromProfile: fromProfile);
}

class _CheckoutScreenState extends BaseRouteState {
  CartController? cartController;
  GlobalKey<ScaffoldState>? _scaffoldKey;
  Address1 _selectedAddress = new Address1();
  List<TimeSlot> _timeSlotList = [];
  DateTime? selectedDate;
  TimeSlot? selectedTimeSlot;
  var _openingTime;
  var _closingTime;
  double labelFontSize = 12;
  double valueFontSize = 12;

  bool _isClosingTime = false;
  ScrollController _scrollController = ScrollController();
  Order? orderDetails;
  bool _isDataLoaded = false, _isLoading = false;

  int? is_subscription;
  int? totalDelivery;
  String? repeatOrders, selectedAddress;
  int? selectedAddressID;
  bool? fromDrawer;
  bool selected = false;
  int selectedIndex = -1;
  List<Address1> addressList = [];
  Placemark? setPlace;
  bool? fromProfile;
  int isHomeOfficePresent = 0;
  bool isHomePresent = false;
  bool isOfficePresent = false;
  _CheckoutScreenState(
      {this.cartController,
      this.fromProfile,
      this.is_subscription,
      this.totalDelivery,
      this.repeatOrders,
      this.fromDrawer,
      this.selectedDate,
      this.selectedTimeSlot});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // onWillPop: () async {
      //   Navigator.of(context).pop();
      //   return false;
      // },
      onWillPop: () async {
        if (fromProfile!) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomeScreen(
                    a: widget.analytics,
                    o: widget.observer,
                    selectedIndex: 4,
                  )));
        } else {
          Navigator.of(context).pop();
        }
        return true;
      },

      child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorConstants.appBarColorWhite,
            title: Text(
              fromProfile! ? "Saved Addresses" : "Select Delivery Address",
              style: TextStyle(
                  color: ColorConstants.newTextHeadingFooter,
                  fontFamily: fontRailwayRegular,
                  fontWeight: FontWeight.w200),
            ),
            centerTitle: false,
            leading: BackButton(
                onPressed: () {
                  // print("this is fromdrawer value${fromProfile}");
                  if (fromProfile!) {
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                color: ColorConstants.newAppColor),
          ),
          body: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  color: ColorConstants.colorPageBackground,
                  height: MediaQuery.of(context).size.height - 150,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Expanded(
                            //   child: Container(
                            //     child: Text(
                            //       global.userProfileController.addressList !=
                            //                   null &&
                            //               global.userProfileController
                            //                       .addressList.length >
                            //                   0
                            //           ? "Shipping to" //${AppLocalizations.of(context).lbl_shipping_to}"
                            //           : "No address", //"${AppLocalizations.of(context).txt_no_address}",
                            //       style: TextStyle(
                            //           fontFamily: fontMontserratMedium,
                            //           fontWeight: FontWeight.w600,
                            //           fontSize: 14,
                            //           color: ColorConstants.appColor),
                            //     ),
                            //   ),
                            // ),
                            // Padding(
                            //     padding: const EdgeInsets.symmetric(
                            //         vertical: 8, horizontal: 12.0),
                            //     child:
                            //         // global.userProfileController.addressList !=
                            //         //             null &&
                            //         //         global.userProfileController.addressList
                            //         //                 .length >
                            //         //             0
                            //         // ?
                            //         InkWell(
                            //       onTap: () {
                            //         Get.to(() => LocationScreen(
                            //               a: widget.analytics,
                            //               o: widget.observer,
                            //             )).then((value) {
                            //           setState(() {});
                            //         });
                            //       },
                            //       child: Container(
                            //         padding: EdgeInsets.all(10),
                            //         width: (MediaQuery.of(context).size.width /
                            //                 2) -
                            //             30,
                            //         decoration: BoxDecoration(
                            //             border: Border.all(
                            //                 color: ColorConstants.appColor,
                            //                 width: 0.5),
                            //             borderRadius:
                            //                 BorderRadius.circular(10)),
                            //         child: Text(
                            //           "Add new address",
                            //           textAlign: TextAlign.center,
                            //           // "${AppLocalizations.of(context).tle_add_new_address} ",
                            //           style: TextStyle(
                            //               fontFamily: fontRailwayRegular,
                            //               fontWeight: FontWeight.w200,
                            //               fontSize: 14,
                            //               color: ColorConstants.appColor),
                            //         ),
                            //       ),
                            //     )
                            //     // : SizedBox(),
                            //     ),
                          ],
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: !_isDataLoaded
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                    : global.userProfileController.addressList
                                                    .length !=
                                                null &&
                                            global.userProfileController
                                                    .addressList.length >
                                                0
                                        ? ListView.builder(
                                            physics: ScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: global
                                                .userProfileController
                                                .addressList
                                                .length,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () async {
                                                  setState(() =>
                                                      selectedIndex = index);
                                                  print(
                                                      "nikhil hdfsghsgfghfghjfjagshdgfa");
                                                  print(global
                                                      .userProfileController
                                                      .addressList[index]
                                                      .lat!);
                                                  global.lat = double.parse(
                                                      global
                                                          .userProfileController
                                                          .addressList[index]
                                                          .lat!);

                                                  global.lng = double.parse(
                                                      global
                                                          .userProfileController
                                                          .addressList[index]
                                                          .lng!);
                                                  //global.currentLocation = "${global.userProfileController.addressList[index].landmark}, ${global.userProfileController.addressList[index].city} ";
                                                  global.currentLocation =
                                                      "${global.userProfileController.addressList[index].type}";
                                                  // await _getNearByStore();
                                                  global.currentLocationSelected =
                                                      true;
                                                  SharedPreferences prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  prefs.setString(
                                                      'type',
                                                      global
                                                          .userProfileController
                                                          .addressList[index]
                                                          .type!);
                                                  prefs.setDouble(
                                                      'lat',
                                                      double.parse(global
                                                          .userProfileController
                                                          .addressList[index]
                                                          .lat!));
                                                  prefs.setDouble(
                                                      'lng',
                                                      double.parse(global
                                                          .userProfileController
                                                          .addressList[index]
                                                          .lng!));
                                                  // Navigator.of(context).pop();
                                                  // showToast('Address Selected');
                                                  _selectedAddress =
                                                      userProfileController
                                                          .addressList[index];
                                                  if (!fromProfile!) {
                                                    onCardClick();
                                                  }

                                                  setState(() {});
                                                },
                                                // height:
                                                //     MediaQuery.of(context).size.height /
                                                //         6,

                                                // Not Working code

                                                //   global.currentLocation =
                                                //       "${global.userProfileController.addressList[index].type}";

                                                //   global.currentLocationSelected =
                                                //       true;
                                                //   SharedPreferences prefs =
                                                //       await SharedPreferences
                                                //           .getInstance();
                                                //   prefs.setString(
                                                //       'type',
                                                //       global
                                                //           .userProfileController
                                                //           .addressList[index]
                                                //           .type!);
                                                //   prefs.setDouble(
                                                //       'lat',
                                                //       double.parse(global
                                                //           .userProfileController
                                                //           .addressList[index]
                                                //           .lat!));
                                                //   prefs.setDouble(
                                                //       'lng',
                                                //       double.parse(global
                                                //           .userProfileController
                                                //           .addressList[index]
                                                //           .lng!));

                                                //   _selectedAddress =
                                                //       userProfileController
                                                //           .addressList[index];
                                                //   onCardClick();
                                                //   setState(() {});
                                                // },
                                                child: Container(
                                                  child: Card(
                                                    elevation: 1,
                                                    shape: selectedIndex ==
                                                            index // index AAA
                                                        ? new RoundedRectangleBorder(
                                                            side: new BorderSide(
                                                                color:
                                                                    ColorConstants
                                                                        .appColor,
                                                                width: 1.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0))
                                                        : new RoundedRectangleBorder(
                                                            side: new BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 1.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0)),
                                                    margin: EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                        bottom: 20),
                                                    color: ColorConstants
                                                        .white, // C1 AAA
                                                    child: ListTile(
                                                      contentPadding:
                                                          EdgeInsets.all(10),
                                                      title: SizedBox(
                                                        height: 25,
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  if (global.userProfileController.addressList[index].type !=
                                                                          null &&
                                                                      global.userProfileController.addressList[index].type!
                                                                              .toLowerCase() ==
                                                                          'home')
                                                                    WidgetSpan(
                                                                        child:
                                                                            Icon(
                                                                      Icons
                                                                          .house_outlined,
                                                                      color: ColorConstants
                                                                          .allIconsBlack45,
                                                                      size: 18,
                                                                    ))
                                                                  else if (global
                                                                              .userProfileController
                                                                              .addressList[
                                                                                  index]
                                                                              .type !=
                                                                          null &&
                                                                      global.userProfileController.addressList[index].type!
                                                                              .toLowerCase() ==
                                                                          'office')
                                                                    WidgetSpan(
                                                                        child:
                                                                            Icon(
                                                                      Icons
                                                                          .book_outlined,
                                                                      color: ColorConstants
                                                                          .allIconsBlack45,
                                                                      size: 18,
                                                                    ))
                                                                  else if (global
                                                                              .userProfileController
                                                                              .addressList[
                                                                                  index]
                                                                              .type !=
                                                                          null &&
                                                                      (global.userProfileController.addressList[index].type!.toLowerCase() ==
                                                                              'other' ||
                                                                          global.userProfileController.addressList[index].type!.toLowerCase() ==
                                                                              'others'))
                                                                    WidgetSpan(
                                                                        child:
                                                                            Icon(
                                                                      Icons
                                                                          .flag_outlined,
                                                                      color: ColorConstants
                                                                          .allIconsBlack45,
                                                                      size: 18,
                                                                    )),
                                                                  TextSpan(
                                                                      text: global.userProfileController.addressList[index].type != null &&
                                                                              (global.userProfileController.addressList[index].recepientName != null && global.userProfileController.addressList[index].recepientName!.length > 0) &&
                                                                              (global.userProfileController.addressList[index].type!.toLowerCase() == 'other' || global.userProfileController.addressList[index].type!.toLowerCase() == 'others')
                                                                          ? "  "
                                                                          : ""),
                                                                  TextSpan(
                                                                    text:
                                                                        ('${(global.userProfileController.addressList[index].type!.toLowerCase() == 'other' || global.userProfileController.addressList[index].type!.toLowerCase() == 'others') && global.userProfileController.addressList[index].recepientName != null ? global.userProfileController.addressList[index].recepientName : ""}   ${global.userProfileController.addressList[index].type}'),
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            fontRailwayRegular,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: ColorConstants
                                                                            .newTextHeadingFooter,
                                                                        fontSize:
                                                                            14),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                                child:
                                                                    Text('')),
                                                            Row(children: [
                                                              InkWell(
                                                                onTap:
                                                                    () async {
                                                                  int isbothpresent =
                                                                      0;
                                                                  print(global
                                                                      .addressList
                                                                      .length);
                                                                  if (global.addressList !=
                                                                          null &&
                                                                      global.addressList
                                                                              .length >
                                                                          0) {
                                                                    for (int i =
                                                                            0;
                                                                        i < global.addressList.length;
                                                                        i++) {
                                                                      if (global
                                                                              .addressList[
                                                                                  i]
                                                                              .type!
                                                                              .toLowerCase() ==
                                                                          "home") {
                                                                        isHomePresent =
                                                                            true;
                                                                        if (isbothpresent ==
                                                                            2) {
                                                                          isbothpresent =
                                                                              3;
                                                                        } else {
                                                                          print(global
                                                                              .addressList[i]
                                                                              .type!
                                                                              .toLowerCase());
                                                                          if (global.addressList[i].type!.toLowerCase() ==
                                                                              "home") {
                                                                            isbothpresent =
                                                                                1;
                                                                          } else {
                                                                            isbothpresent =
                                                                                0;
                                                                          }
                                                                        }
                                                                      } else if (global
                                                                              .addressList[i]
                                                                              .type!
                                                                              .toLowerCase() ==
                                                                          "office") {
                                                                        isOfficePresent =
                                                                            true;
                                                                        if (isbothpresent ==
                                                                            1) {
                                                                          isbothpresent =
                                                                              3;
                                                                        } else {
                                                                          if (global.addressList[i].type!.toLowerCase() ==
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
                                                                    isbothpresent =
                                                                        0;
                                                                    isHomeOfficePresent =
                                                                        0;
                                                                  }
                                                                  if (isbothpresent >
                                                                      2) {
                                                                    isHomeOfficePresent =
                                                                        3;
                                                                  } else if (isbothpresent ==
                                                                      2) {
                                                                    isHomeOfficePresent =
                                                                        2;
                                                                  } else if (isbothpresent ==
                                                                      1) {
                                                                    isHomeOfficePresent =
                                                                        1;
                                                                  }
                                                                  if (Platform
                                                                      .isIOS) {
                                                                    LocationPermission
                                                                        s =
                                                                        await Geolocator
                                                                            .checkPermission();
                                                                    if (s == LocationPermission.denied ||
                                                                        s ==
                                                                            LocationPermission
                                                                                .deniedForever ||
                                                                        s ==
                                                                            LocationPermission.unableToDetermine) {
                                                                      s = await Geolocator
                                                                          .requestPermission();
                                                                      // bool res = await openAppSettings();
                                                                      s = await Geolocator
                                                                          .checkPermission();
                                                                    } else {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => LocationScreen(
                                                                                    address: global.addressList[index],
                                                                                    lat: double.parse(global.addressList[index].lat!),
                                                                                    lng: double.parse(global.addressList[index].lng!),
                                                                                    isEditButtonClicked: true,
                                                                                    a: widget.analytics,
                                                                                    isHomePresent: isHomePresent,
                                                                                    isOfficePresent: isOfficePresent,
                                                                                    cartController: fromProfile! ? null : cartController,
                                                                                    isHOmeOfficePresent: 0,
                                                                                    fromProfile: fromProfile,
                                                                                    o: widget.observer,
                                                                                  ))).then((value) {
                                                                        setState(
                                                                            () {});
                                                                      });
                                                                    }
                                                                  } else {
                                                                    LocationPermission
                                                                        s =
                                                                        await Geolocator
                                                                            .checkPermission();
                                                                    if (s == LocationPermission.denied ||
                                                                        s ==
                                                                            LocationPermission
                                                                                .deniedForever ||
                                                                        s ==
                                                                            LocationPermission.unableToDetermine) {
                                                                      s = await Geolocator
                                                                          .requestPermission();
                                                                      // bool res = await openAppSettings();
                                                                      s = await Geolocator
                                                                          .checkPermission();
                                                                    } else {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => LocationScreen(
                                                                                    address: global.addressList[index],
                                                                                    lat: double.parse(global.addressList[index].lat!),
                                                                                    lng: double.parse(global.addressList[index].lng!),
                                                                                    isEditButtonClicked: true,
                                                                                    a: widget.analytics,
                                                                                    isHOmeOfficePresent: 0,
                                                                                    isHomePresent: isHomePresent,
                                                                                    isOfficePresent: isOfficePresent,
                                                                                    cartController: fromProfile! ? null : cartController,
                                                                                    fromProfile: fromProfile,
                                                                                    o: widget.observer,
                                                                                  ))).then((value) {
                                                                        setState(
                                                                            () {});
                                                                      });
                                                                    }
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              5,
                                                                          bottom:
                                                                              5,
                                                                          left:
                                                                              5,
                                                                          right:
                                                                              5),
                                                                  child: Text(
                                                                    "Edit",
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          fontRailwayRegular,
                                                                      color: ColorConstants
                                                                          .appColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          13,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              // global.userProfileController.addressList[index].type!
                                                              //                 .toLowerCase() ==
                                                              //             "home" ||
                                                              //         global.userProfileController.addressList[index].type!
                                                              //                 .toLowerCase() ==
                                                              //             "office"
                                                              //     ? SizedBox() :
                                                              InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    await deleteConfirmationDialog(
                                                                        index);
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .delete_outline,
                                                                    color: ColorConstants
                                                                        .appColor,
                                                                    size: 20,
                                                                  )),
                                                            ]),
                                                          ],
                                                        ),
                                                      ),
                                                      subtitle: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          Divider(
                                                            height: 1,
                                                            color:
                                                                ColorConstants
                                                                    .greyDull,
                                                          ),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          Row(children: [
                                                            Container(
                                                              child: Text(
                                                                "Name:",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        fontRailwayRegular,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: ColorConstants
                                                                        .pureBlack,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 8,
                                                            ),
                                                            Container(
                                                              child: Text(
                                                                "${global.addressList[index].receiverName}",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        fontRailwayRegular,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: ColorConstants
                                                                        .pureBlack,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            ),
                                                          ]),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          Divider(
                                                            height: 1,
                                                            color:
                                                                ColorConstants
                                                                    .greyDull,
                                                          ),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  child: Text(
                                                                    "Address:",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            fontRailwayRegular,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: ColorConstants
                                                                            .pureBlack,
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 8,
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    // "${global.userProfileController.addressList[index].city}, ${global.userProfileController.addressList[index].society}, ${global.userProfileController.addressList[index].houseNo}, ${global.userProfileController.addressList[index].landmark}",
                                                                    // global.userProfileController.addressList[index].street ==
                                                                    //         null
                                                                    //     ? "${global.addressList[index].houseNo != null ? global.addressList[index].houseNo : ""}, ${global.addressList[index].society != null ? global.addressList[index].society : ""}, ${global.addressList[index].city != null ? global.addressList[index].city : ""},${global.addressList[index].landmark != null ? global.addressList[index].landmark : ""} ${global.addressList[index].state != null ? global.addressList[index].state : ""}"
                                                                    //     //? "${global.userProfileController.addressList[index].society},  ${global.userProfileController.addressList[index].building_villa},  ${global.userProfileController.addressList[index].city}"
                                                                    //     : "${global.addressList[index].houseNo != null ? global.addressList[index].houseNo : ""}, ${global.addressList[index].society != null ? global.addressList[index].society : ""}, ${global.addressList[index].city != null ? global.addressList[index].city : ""},${global.addressList[index].landmark != null ? global.addressList[index].landmark : ""} ${global.addressList[index].state != null ? global.addressList[index].state : ""}",
                                                                    // : "${global.userProfileController.addressList[index].society},  ${global.userProfileController.addressList[index].building_villa},  ${global.userProfileController.addressList[index].street},  ${global.userProfileController.addressList[index].city}",
                                                                    global.addressList[index].city !=
                                                                            null
                                                                        ? global
                                                                            .addressList[index]
                                                                            .city!
                                                                        : "",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,

                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            fontRailwayRegular,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: ColorConstants
                                                                            .pureBlack,
                                                                        fontSize:
                                                                            14),
                                                                    // maxLines:
                                                                    //     3, //overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                ),
                                                              ]),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          Divider(
                                                            height: 1,
                                                            color:
                                                                ColorConstants
                                                                    .greyDull,
                                                          ),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  child: Text(
                                                                    "Community/ Building Name:",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            fontRailwayRegular,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: ColorConstants
                                                                            .pureBlack,
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 8,
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    // "${global.userProfileController.addressList[index].city}, ${global.userProfileController.addressList[index].society}, ${global.userProfileController.addressList[index].houseNo}, ${global.userProfileController.addressList[index].landmark}",
                                                                    // global.userProfileController.addressList[index].street ==
                                                                    //         null
                                                                    //     ? "${global.addressList[index].houseNo != null ? global.addressList[index].houseNo : ""}, ${global.addressList[index].society != null ? global.addressList[index].society : ""}, ${global.addressList[index].city != null ? global.addressList[index].city : ""},${global.addressList[index].landmark != null ? global.addressList[index].landmark : ""} ${global.addressList[index].state != null ? global.addressList[index].state : ""}"
                                                                    //     //? "${global.userProfileController.addressList[index].society},  ${global.userProfileController.addressList[index].building_villa},  ${global.userProfileController.addressList[index].city}"
                                                                    //     : "${global.addressList[index].houseNo != null ? global.addressList[index].houseNo : ""}, ${global.addressList[index].society != null ? global.addressList[index].society : ""}, ${global.addressList[index].city != null ? global.addressList[index].city : ""},${global.addressList[index].landmark != null ? global.addressList[index].landmark : ""} ${global.addressList[index].state != null ? global.addressList[index].state : ""}",
                                                                    // : "${global.userProfileController.addressList[index].society},  ${global.userProfileController.addressList[index].building_villa},  ${global.userProfileController.addressList[index].street},  ${global.userProfileController.addressList[index].city}",
                                                                    global.addressList[index].houseNo !=
                                                                            null
                                                                        ? global
                                                                            .addressList[index]
                                                                            .houseNo!
                                                                            .capitalizeFirst!
                                                                        : "",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,

                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            fontRailwayRegular,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: ColorConstants
                                                                            .pureBlack,
                                                                        fontSize:
                                                                            14),
                                                                    // maxLines:
                                                                    //     3, //overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                ),
                                                              ]),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          Divider(
                                                            height: 1,
                                                            color:
                                                                ColorConstants
                                                                    .greyDull,
                                                          ),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                child: Text(
                                                                  "Villa/ Apartment Number:",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          fontRailwayRegular,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: ColorConstants
                                                                          .pureBlack,
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 8,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  // "${global.userProfileController.addressList[index].city}, ${global.userProfileController.addressList[index].society}, ${global.userProfileController.addressList[index].houseNo}, ${global.userProfileController.addressList[index].landmark}",
                                                                  // global.userProfileController.addressList[index].street ==
                                                                  //         null
                                                                  //     ? "${global.addressList[index].houseNo != null ? global.addressList[index].houseNo : ""}, ${global.addressList[index].society != null ? global.addressList[index].society : ""}, ${global.addressList[index].city != null ? global.addressList[index].city : ""},${global.addressList[index].landmark != null ? global.addressList[index].landmark : ""} ${global.addressList[index].state != null ? global.addressList[index].state : ""}"
                                                                  //     //? "${global.userProfileController.addressList[index].society},  ${global.userProfileController.addressList[index].building_villa},  ${global.userProfileController.addressList[index].city}"
                                                                  //     : "${global.addressList[index].houseNo != null ? global.addressList[index].houseNo : ""}, ${global.addressList[index].society != null ? global.addressList[index].society : ""}, ${global.addressList[index].city != null ? global.addressList[index].city : ""},${global.addressList[index].landmark != null ? global.addressList[index].landmark : ""} ${global.addressList[index].state != null ? global.addressList[index].state : ""}",
                                                                  // : "${global.userProfileController.addressList[index].society},  ${global.userProfileController.addressList[index].building_villa},  ${global.userProfileController.addressList[index].street},  ${global.userProfileController.addressList[index].city}",
                                                                  global.addressList[index].building_villa !=
                                                                          null
                                                                      ? global
                                                                          .addressList[
                                                                              index]
                                                                          .building_villa!
                                                                      : "",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,

                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          fontRailwayRegular,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: ColorConstants
                                                                          .pureBlack,
                                                                      fontSize:
                                                                          14),
                                                                  // maxLines:
                                                                  //     3, //overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          Divider(
                                                            height: 1,
                                                            color:
                                                                ColorConstants
                                                                    .greyDull,
                                                          ),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                child: Text(
                                                                  "Street/ Locality Name:",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          fontRailwayRegular,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: ColorConstants
                                                                          .pureBlack,
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 8,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  // "${global.userProfileController.addressList[index].city}, ${global.userProfileController.addressList[index].society}, ${global.userProfileController.addressList[index].houseNo}, ${global.userProfileController.addressList[index].landmark}",
                                                                  // global.userProfileController.addressList[index].street ==
                                                                  //         null
                                                                  //     ? "${global.addressList[index].houseNo != null ? global.addressList[index].houseNo : ""}, ${global.addressList[index].society != null ? global.addressList[index].society : ""}, ${global.addressList[index].city != null ? global.addressList[index].city : ""},${global.addressList[index].landmark != null ? global.addressList[index].landmark : ""} ${global.addressList[index].state != null ? global.addressList[index].state : ""}"
                                                                  //     //? "${global.userProfileController.addressList[index].society},  ${global.userProfileController.addressList[index].building_villa},  ${global.userProfileController.addressList[index].city}"
                                                                  //     : "${global.addressList[index].houseNo != null ? global.addressList[index].houseNo : ""}, ${global.addressList[index].society != null ? global.addressList[index].society : ""}, ${global.addressList[index].city != null ? global.addressList[index].city : ""},${global.addressList[index].landmark != null ? global.addressList[index].landmark : ""} ${global.addressList[index].state != null ? global.addressList[index].state : ""}",
                                                                  // : "${global.userProfileController.addressList[index].society},  ${global.userProfileController.addressList[index].building_villa},  ${global.userProfileController.addressList[index].street},  ${global.userProfileController.addressList[index].city}",
                                                                  global.addressList[index].society !=
                                                                          null
                                                                      ? global
                                                                          .addressList[
                                                                              index]
                                                                          .society!
                                                                          .capitalizeFirst!
                                                                      : "",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,

                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          fontRailwayRegular,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: ColorConstants
                                                                          .pureBlack,
                                                                      fontSize:
                                                                          14),
                                                                  // maxLines:
                                                                  //     3, //overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          Divider(
                                                            height: 1,
                                                            color:
                                                                ColorConstants
                                                                    .greyDull,
                                                          ),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          global.addressList[index].landmark !=
                                                                      null &&
                                                                  global
                                                                      .addressList[
                                                                          index]
                                                                      .landmark!
                                                                      .isNotEmpty
                                                              ? Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                      Container(
                                                                        child:
                                                                            Text(
                                                                          "Landmark:",
                                                                          style: TextStyle(
                                                                              fontFamily: fontRailwayRegular,
                                                                              fontWeight: FontWeight.w400,
                                                                              color: ColorConstants.pureBlack,
                                                                              fontSize: 14),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            8,
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          // "${global.userProfileController.addressList[index].city}, ${global.userProfileController.addressList[index].society}, ${global.userProfileController.addressList[index].houseNo}, ${global.userProfileController.addressList[index].landmark}",
                                                                          // global.userProfileController.addressList[index].street ==
                                                                          //         null
                                                                          //     ? "${global.addressList[index].houseNo != null ? global.addressList[index].houseNo : ""}, ${global.addressList[index].society != null ? global.addressList[index].society : ""}, ${global.addressList[index].city != null ? global.addressList[index].city : ""},${global.addressList[index].landmark != null ? global.addressList[index].landmark : ""} ${global.addressList[index].state != null ? global.addressList[index].state : ""}"
                                                                          //     //? "${global.userProfileController.addressList[index].society},  ${global.userProfileController.addressList[index].building_villa},  ${global.userProfileController.addressList[index].city}"
                                                                          //     : "${global.addressList[index].houseNo != null ? global.addressList[index].houseNo : ""}, ${global.addressList[index].society != null ? global.addressList[index].society : ""}, ${global.addressList[index].city != null ? global.addressList[index].city : ""},${global.addressList[index].landmark != null ? global.addressList[index].landmark : ""} ${global.addressList[index].state != null ? global.addressList[index].state : ""}",
                                                                          // : "${global.userProfileController.addressList[index].society},  ${global.userProfileController.addressList[index].building_villa},  ${global.userProfileController.addressList[index].street},  ${global.userProfileController.addressList[index].city}",
                                                                          global.addressList[index].landmark != null
                                                                              ? global.addressList[index].landmark!.capitalizeFirst!
                                                                              : "",
                                                                          textAlign:
                                                                              TextAlign.start,

                                                                          style: TextStyle(
                                                                              fontFamily: fontRailwayRegular,
                                                                              fontWeight: FontWeight.w400,
                                                                              color: ColorConstants.pureBlack,
                                                                              fontSize: 14),
                                                                          // maxLines:
                                                                          //     3, //overflow: TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                                    ])
                                                              : SizedBox(),
                                                          global.addressList[index].landmark !=
                                                                      null &&
                                                                  global
                                                                      .addressList[
                                                                          index]
                                                                      .landmark!
                                                                      .isNotEmpty
                                                              ? SizedBox(
                                                                  height: 8,
                                                                )
                                                              : SizedBox(
                                                                  height: 6,
                                                                ),
                                                          global.addressList[index].landmark !=
                                                                      null &&
                                                                  global
                                                                      .addressList[
                                                                          index]
                                                                      .landmark!
                                                                      .isNotEmpty
                                                              ? Divider(
                                                                  height: 1,
                                                                  color: ColorConstants
                                                                      .greyDull,
                                                                )
                                                              : SizedBox(),
                                                          global.addressList[index].landmark !=
                                                                      null &&
                                                                  global
                                                                      .addressList[
                                                                          index]
                                                                      .landmark!
                                                                      .isNotEmpty
                                                              ? SizedBox(
                                                                  height: 8,
                                                                )
                                                              : SizedBox(),
                                                          //Emirate Field
                                                          global
                                                                      .addressList[
                                                                          index]
                                                                      .cityName !=
                                                                  null
                                                              ? Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                      Container(
                                                                        child:
                                                                            Text(
                                                                          "Emirate:",
                                                                          style: TextStyle(
                                                                              fontFamily: fontRailwayRegular,
                                                                              fontWeight: FontWeight.w400,
                                                                              color: ColorConstants.pureBlack,
                                                                              fontSize: 14),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            8,
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          // "${global.userProfileController.addressList[index].city}, ${global.userProfileController.addressList[index].society}, ${global.userProfileController.addressList[index].houseNo}, ${global.userProfileController.addressList[index].landmark}",
                                                                          // global.userProfileController.addressList[index].street ==
                                                                          //         null
                                                                          //     ? "${global.addressList[index].houseNo != null ? global.addressList[index].houseNo : ""}, ${global.addressList[index].society != null ? global.addressList[index].society : ""}, ${global.addressList[index].city != null ? global.addressList[index].city : ""},${global.addressList[index].landmark != null ? global.addressList[index].landmark : ""} ${global.addressList[index].state != null ? global.addressList[index].state : ""}"
                                                                          //     //? "${global.userProfileController.addressList[index].society},  ${global.userProfileController.addressList[index].building_villa},  ${global.userProfileController.addressList[index].city}"
                                                                          //     : "${global.addressList[index].houseNo != null ? global.addressList[index].houseNo : ""}, ${global.addressList[index].society != null ? global.addressList[index].society : ""}, ${global.addressList[index].city != null ? global.addressList[index].city : ""},${global.addressList[index].landmark != null ? global.addressList[index].landmark : ""} ${global.addressList[index].state != null ? global.addressList[index].state : ""}",
                                                                          // : "${global.userProfileController.addressList[index].society},  ${global.userProfileController.addressList[index].building_villa},  ${global.userProfileController.addressList[index].street},  ${global.userProfileController.addressList[index].city}",

                                                                          global
                                                                              .addressList[index]
                                                                              .cityName!
                                                                              .capitalizeFirst!,
                                                                          textAlign:
                                                                              TextAlign.start,

                                                                          style: TextStyle(
                                                                              fontFamily: fontRailwayRegular,
                                                                              fontWeight: FontWeight.w400,
                                                                              color: ColorConstants.pureBlack,
                                                                              fontSize: 14),
                                                                          // maxLines:
                                                                          //     3, //overflow: TextOverflow.ellipsis,
                                                                        ),
                                                                      )
                                                                    ])
                                                              : SizedBox(),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          Divider(
                                                            height: 1,
                                                            color:
                                                                ColorConstants
                                                                    .greyDull,
                                                          ),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                child: Text(
                                                                  "Mobile Number:",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          fontRailwayRegular,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w200,
                                                                      color: ColorConstants
                                                                          .pureBlack,
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 8,
                                                              ),
                                                              Container(
                                                                child: Text(
                                                                  "${global.addressList[index].countryCode} ${global.addressList[index].receiverPhone}",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          fontRailwayRegular,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: ColorConstants
                                                                          .pureBlack,
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            })
                                        : Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                100,
                                            child: Container(
                                              color: ColorConstants
                                                  .colorPageBackground,
                                              child: Center(
                                                  child: Text(
                                                '"Your gifts are on vacation, waiting for an address to visit!"',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: global
                                                        .fontRailwaySemibold,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w200,
                                                    color: ColorConstants
                                                        .newAppColor),
                                              )),
                                            ),
                                          )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.fromLTRB(
              0,
              0,
              0,
              MediaQuery.of(context).viewPadding.bottom +
                  10, // Prevents bottom overlap
            ),
            child: fromProfile!
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Visibility(
                      //   visible: fromProfile && selectedIndex >= 0,
                      //   child: InkWell(
                      //     onTap: () async {
                      //       if (Platform.isIOS) {
                      //         LocationPermission s =
                      //             await Geolocator.checkPermission();
                      //         // print("G---->${s}");
                      //         if (s == LocationPermission.denied ||
                      //             s == LocationPermission.deniedForever ||
                      //             s == LocationPermission.unableToDetermine) {
                      //           s = await Geolocator.requestPermission();
                      //           // bool res = await openAppSettings();
                      //           s = await Geolocator.checkPermission();
                      //         } else {
                      //           Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) =>
                      //                       // AddAddressScreen(
                      //                       //   Address(),
                      //                       //   a: widget.analytics,
                      //                       //   o: widget.observer,
                      //                       //   screenId:
                      //                       //       0,
                      //                       //   fromWhere:
                      //                       //       "checkout",
                      //                       //   setPlace:
                      //                       //       setPlace,
                      //                       //   // selectedScreen: "checkout",
                      //                       // )
                      //                       LocationScreen(
                      //                         address: global
                      //                             .userProfileController
                      //                             .addressList[selectedIndex],
                      //                         lat: double.parse(global
                      //                             .userProfileController
                      //                             .addressList[selectedIndex]
                      //                             .lat),
                      //                         lng: double.parse(global
                      //                             .userProfileController
                      //                             .addressList[selectedIndex]
                      //                             .lng),
                      //                         isEditButtonClicked: true,
                      //                         a: widget.analytics,
                      //                         isHOmeOfficePresent: 0,
                      //                         fromProfile: fromProfile,
                      //                         o: widget.observer,
                      //                       ))).then((value) {
                      //             setState(() {});
                      //           });
                      //         }
                      //       } else {
                      //         Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) =>
                      //                     // AddAddressScreen(
                      //                     //   Address(),
                      //                     //   a: widget.analytics,
                      //                     //   o: widget.observer,
                      //                     //   screenId:
                      //                     //       0,
                      //                     //   fromWhere:
                      //                     //       "checkout",
                      //                     //   setPlace:
                      //                     //       setPlace,
                      //                     //   // selectedScreen: "checkout",
                      //                     // )
                      //                     LocationScreen(
                      //                       address: global
                      //                           .userProfileController
                      //                           .addressList[selectedIndex],
                      //                       lat: double.parse(global
                      //                           .userProfileController
                      //                           .addressList[selectedIndex]
                      //                           .lat),
                      //                       lng: double.parse(global
                      //                           .userProfileController
                      //                           .addressList[selectedIndex]
                      //                           .lng),
                      //                       isEditButtonClicked: true,
                      //                       a: widget.analytics,
                      //                       isHOmeOfficePresent: 0,
                      //                       fromProfile: fromProfile,
                      //                       o: widget.observer,
                      //                     ))).then((value) {
                      //           setState(() {});
                      //         });
                      //       }
                      //     },
                      //     child: Container(
                      //         width:
                      //             (MediaQuery.of(context).size.width / 2) - 20,
                      //         padding: EdgeInsets.only(top: 10, bottom: 10),
                      //         decoration: BoxDecoration(
                      //             color: ColorConstants.appColor,
                      //             border: Border.all(
                      //                 color: ColorConstants.appColor,
                      //                 width: 0.5),
                      //             borderRadius: BorderRadius.circular(10)),
                      //         child: Text(
                      //           "EDIT \nADDRESS",
                      //           textAlign: TextAlign.center,
                      //           style: TextStyle(
                      //               fontFamily: fontMontserratMedium,
                      //               fontWeight: FontWeight.bold,
                      //               fontSize: 16,
                      //               color: ColorConstants.white,
                      //               letterSpacing: 1),
                      //         )),
                      //   ),
                      // ),
                      InkWell(
                        onTap: () async {
                          int isbothpresent = 0;
                          print(global.addressList.length);
                          if (global.addressList != null &&
                              global.addressList.length > 0) {
                            for (int i = 0;
                                i < global.addressList.length;
                                i++) {
                              print("helakjdhsjhdahjlooo");
                              if (global.addressList[i].type!.toLowerCase() ==
                                  "home") {
                                isHomePresent = true;
                                if (isbothpresent == 2) {
                                  isbothpresent = 3;
                                } else {
                                  print(global.addressList[i].type!
                                      .toLowerCase());
                                  if (global.addressList[i].type!
                                          .toLowerCase() ==
                                      "home") {
                                    isbothpresent = 1;
                                  } else {
                                    isbothpresent = 0;
                                  }
                                }
                              } else if (global.addressList[i].type!
                                      .toLowerCase() ==
                                  "office") {
                                isOfficePresent = true;
                                if (isbothpresent == 1) {
                                  isbothpresent = 3;
                                } else {
                                  if (global.addressList[i].type!
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
                            print("helakjdhsjhdahjlooo");
                            isbothpresent = 0;
                            isHomeOfficePresent = 0;
                          }
                          if (isbothpresent > 2) {
                            isHomeOfficePresent = 3;
                          } else if (isbothpresent == 2) {
                            isHomeOfficePresent = 2;
                          } else if (isbothpresent == 1) {
                            isHomeOfficePresent = 1;
                          }
                          if (Platform.isIOS) {
                            LocationPermission s =
                                await Geolocator.checkPermission();
                            // print("G---->${s}");
                            if (s == LocationPermission.denied ||
                                s == LocationPermission.deniedForever) {
                              s = await Geolocator.requestPermission();
                              // bool res = await openAppSettings();
                              s = await Geolocator.checkPermission();
                            } else {
                              // print("G15");
                              setState(() {
                                _isLoading = true;
                              });
                              getCurrentPosition().then((value) {
                                setState(() {
                                  _isLoading = false;
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LocationScreen(
                                              a: widget.analytics,
                                              o: widget.observer,
                                              isHOmeOfficePresent:
                                                  isHomeOfficePresent,
                                              cartController: fromProfile!
                                                  ? null
                                                  : cartController,
                                              isHomePresent: isHomePresent,
                                              isOfficePresent: isOfficePresent,
                                              isEditButtonClicked: false,
                                              fromProfile: fromProfile,
                                            ))).then((value) {
                                  _isDataLoaded = false;
                                  getUserAddressList();
                                  // setState(() {});
                                });
                              });
                            }
                          } else {
                            print(isHomePresent);
                            print(isOfficePresent);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LocationScreen(
                                          a: widget.analytics,
                                          o: widget.observer,
                                          cartController: fromProfile!
                                              ? null
                                              : cartController,
                                          isEditButtonClicked: false,
                                          fromProfile: fromProfile,
                                          isHomePresent: isHomePresent,
                                          isOfficePresent: isOfficePresent,
                                          isHOmeOfficePresent:
                                              isHomeOfficePresent,
                                        ))).then((value) {
                              _isDataLoaded = false;
                              getUserAddressList();
                              // setState(() {});
                            });
                          }
                        },
                        child: Container(
                          width: !fromProfile! //&& selectedIndex >= 0
                              ? (MediaQuery.of(context).size.width / 2) - 20
                              : MediaQuery.of(context).size.width - 20,
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              color: ColorConstants.appColor,
                              border: Border.all(
                                  color: ColorConstants.appColor, width: 0.5),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            !fromProfile! //&& selectedIndex >= 0
                                ? "ADD RECEIVER \nADDRESS"
                                : "ADD RECEIVER ADDRESS",
                            textAlign: TextAlign.center,
                            // "${AppLocalizations.of(context).tle_add_new_address} ",
                            style: TextStyle(
                                fontFamily: fontOufitMedium,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: ColorConstants.white,
                                letterSpacing: 1),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !fromProfile! &&
                            global.userProfileController.addressList.length !=
                                null &&
                            global.userProfileController.addressList.length > 0,
                        child: InkWell(
                          onTap: () {
                            onCardClick();
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            width: (MediaQuery.of(context).size.width / 2) - 30,
                            decoration: BoxDecoration(
                                color: ColorConstants.appColor,
                                border: Border.all(
                                    color: ColorConstants.appColor, width: 0.5),
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              "PROCEED TO \nCHECKOUT",
                              textAlign: TextAlign.center,
                              // "${AppLocalizations.of(context).tle_add_new_address} ",
                              style: TextStyle(
                                  fontFamily: fontOufitMedium,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: ColorConstants.white,
                                  letterSpacing: 1),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Visibility(
                      //   visible: selectedIndex >= 0,
                      //   child: InkWell(
                      //     onTap: () async {
                      //       if (Platform.isIOS) {
                      //         LocationPermission s =
                      //             await Geolocator.checkPermission();
                      //         // print("G---->${s}");
                      //         if (s == LocationPermission.denied ||
                      //             s == LocationPermission.deniedForever) {
                      //           s = await Geolocator.requestPermission();
                      //           // bool res = await openAppSettings();
                      //           s = await Geolocator.checkPermission();
                      //         } else {
                      //           Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) =>
                      //                       // AddAddressScreen(
                      //                       //   Address(),
                      //                       //   a: widget.analytics,
                      //                       //   o: widget.observer,
                      //                       //   screenId:
                      //                       //       0,
                      //                       //   fromWhere:
                      //                       //       "checkout",
                      //                       //   setPlace:
                      //                       //       setPlace,
                      //                       //   // selectedScreen: "checkout",
                      //                       // )
                      //                       LocationScreen(
                      //                         address: global
                      //                             .userProfileController
                      //                             .addressList[selectedIndex],
                      //                         lat: double.parse(global
                      //                             .userProfileController
                      //                             .addressList[selectedIndex]
                      //                             .lat),
                      //                         lng: double.parse(global
                      //                             .userProfileController
                      //                             .addressList[selectedIndex]
                      //                             .lng),
                      //                         isEditButtonClicked: true,
                      //                         a: widget.analytics,
                      //                         isHOmeOfficePresent: 0,
                      //                         fromProfile: fromProfile,
                      //                         o: widget.observer,
                      //             ))).then((value) {
                      //   setState(() {});
                      // });
                      //         }
                      //       } else {
                      //         Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) =>
                      //                     // AddAddressScreen(
                      //                     //   Address(),
                      //                     //   a: widget.analytics,
                      //                     //   o: widget.observer,
                      //                     //   screenId:
                      //                     //       0,
                      //                     //   fromWhere:
                      //                     //       "checkout",
                      //                     //   setPlace:
                      //                     //       setPlace,
                      //                     //   // selectedScreen: "checkout",
                      //                     // )
                      //                     LocationScreen(
                      //                       address: global
                      //                           .userProfileController
                      //                           .addressList[selectedIndex],
                      //                       lat: double.parse(global
                      //                           .userProfileController
                      //                           .addressList[selectedIndex]
                      //                           .lat),
                      //                       lng: double.parse(global
                      //                           .userProfileController
                      //                           .addressList[selectedIndex]
                      //                           .lng),
                      //                       isEditButtonClicked: true,
                      //                       a: widget.analytics,
                      //                       isHOmeOfficePresent: 0,
                      //                       fromProfile: fromProfile,
                      //                       o: widget.observer,
                      //                     ))).then((value) {
                      //           setState(() {});
                      //         });
                      //       }
                      //     },
                      //     child: Container(
                      //         width: MediaQuery.of(context).size.width / 4,
                      //         padding: EdgeInsets.only(top: 10, bottom: 10),
                      //         decoration: BoxDecoration(
                      //             color: ColorConstants.appColor,
                      //             border: Border.all(
                      //                 color: ColorConstants.appColor,
                      //                 width: 0.5),
                      //             borderRadius: BorderRadius.circular(10)),
                      //         child: Text(
                      //           "EDIT \nADDRESS",
                      //           textAlign: TextAlign.center,
                      //           style: TextStyle(
                      //             fontFamily: fontMontserratMedium,
                      //             fontWeight: FontWeight.bold,
                      //             fontSize: 12,
                      //             color: ColorConstants.white,
                      //           ),
                      //         )),
                      //   ),
                      // ),

                      InkWell(
                        onTap: () async {
                          int isbothpresent = 0;
                          print(global.addressList.length);
                          if (global.addressList != null &&
                              global.addressList.length > 0) {
                            for (int i = 0;
                                i < global.addressList.length;
                                i++) {
                              print("helakjdhsjhdahjlooo");
                              if (global.addressList[i].type!.toLowerCase() ==
                                  "home") {
                                if (isbothpresent == 2) {
                                  isbothpresent = 3;
                                } else {
                                  print(global.addressList[i].type!
                                      .toLowerCase());
                                  if (global.addressList[i].type!
                                          .toLowerCase() ==
                                      "home") {
                                    isbothpresent = 1;
                                  } else {
                                    isbothpresent = 0;
                                  }
                                }
                              } else if (global.addressList[i].type!
                                      .toLowerCase() ==
                                  "office") {
                                if (isbothpresent == 1) {
                                  isbothpresent = 3;
                                } else {
                                  if (global.addressList[i].type!
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
                            print("helakjdhsjhdahjlooo");
                            isbothpresent = 0;
                            isHomeOfficePresent = 0;
                          }
                          if (isbothpresent > 2) {
                            isHomeOfficePresent = 3;
                          } else if (isbothpresent == 2) {
                            isHomeOfficePresent = 2;
                          } else if (isbothpresent == 1) {
                            isHomeOfficePresent = 1;
                          }
                          if (Platform.isIOS) {
                            LocationPermission s =
                                await Geolocator.checkPermission();
                            // print("G---->${s}");
                            if (s == LocationPermission.denied ||
                                s == LocationPermission.deniedForever) {
                              s = await Geolocator.requestPermission();
                              // bool res = await openAppSettings();
                              s = await Geolocator.checkPermission();
                            } else {
                              // print("G15");
                              setState(() {
                                _isLoading = true;
                              });
                              getCurrentPosition().then((value) {
                                setState(() {
                                  _isLoading = false;
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LocationScreen(
                                              a: widget.analytics,
                                              o: widget.observer,
                                              isHOmeOfficePresent:
                                                  isHomeOfficePresent,
                                              cartController: fromProfile!
                                                  ? null
                                                  : cartController,
                                              isEditButtonClicked: false,
                                              fromProfile: fromProfile,
                                            ))).then((value) {
                                  _isDataLoaded = false;
                                  getUserAddressList();
                                  // setState(() {});
                                });
                              });
                            }
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LocationScreen(
                                          a: widget.analytics,
                                          o: widget.observer,
                                          cartController: fromProfile!
                                              ? null
                                              : cartController,
                                          isEditButtonClicked: false,
                                          fromProfile: fromProfile,
                                          isHOmeOfficePresent:
                                              isHomeOfficePresent,
                                        ))).then((value) {
                              _isDataLoaded = false;
                              getUserAddressList();
                              // setState(() {});
                            });
                          }
                        },
                        child: Container(
                          width:
                              global.userProfileController.addressList.length !=
                                          null &&
                                      global.userProfileController.addressList
                                              .length >
                                          0
                                  ? MediaQuery.of(context).size.width / 2.2
                                  : (MediaQuery.of(context).size.width) - 30,
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          margin:
                              global.userProfileController.addressList.length !=
                                          null &&
                                      global.userProfileController.addressList
                                              .length >
                                          0
                                  ? EdgeInsets.only(left: 20, right: 10)
                                  : EdgeInsets.all(1),
                          decoration: BoxDecoration(
                              color: ColorConstants.appColor,
                              border: Border.all(
                                  color: ColorConstants.appColor, width: 0.5),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            !fromProfile! &&
                                    global.userProfileController.addressList
                                            .length !=
                                        null &&
                                    global.userProfileController.addressList
                                            .length >
                                        0
                                ? "ADD RECEIVER \nADDRESS"
                                : "ADD RECEIVER ADDRESS",

                            ///1234
                            textAlign: TextAlign.center,
                            // "${AppLocalizations.of(context).tle_add_new_address} ",
                            style: TextStyle(
                              fontFamily: fontMontserratMedium,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: ColorConstants.white,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !fromProfile! &&
                            global.userProfileController.addressList.length !=
                                null &&
                            global.userProfileController.addressList.length > 0,
                        child: InkWell(
                          onTap: () {
                            onCardClick();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2.2 - 10,
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                color: ColorConstants.appColor,
                                border: Border.all(
                                    color: ColorConstants.appColor, width: 0.5),
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              "PROCEED TO \nCHECKOUT",
                              textAlign: TextAlign.center,
                              // "${AppLocalizations.of(context).tle_add_new_address} ",
                              style: TextStyle(
                                  fontFamily: fontMontserratMedium,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: ColorConstants.white,
                                  letterSpacing: 1),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
          )),
    );
  }

  Future deleteConfirmationDialog(int index) async {
    try {
      await showCupertinoDialog<bool>(
        context: context,
        builder: (context) => Theme(
          data: ThemeData(dialogBackgroundColor: Colors.white),
          child: CupertinoAlertDialog(
            title: Text(
              " Delete Address ",
            ),
            content: Text(
              "Are you sure you want to delete address?",
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('Ok',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: fontRailwayRegular,
                        fontWeight: FontWeight.w200,
                        color: Colors.blue)),
                onPressed: () async {
                  Navigator.of(context).pop();
                  // showOnlyLoaderDialog();
                  await _removeAddress(index);
                },
              ),
              CupertinoDialogAction(
                child: Text("Cancel ",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: fontRailwayRegular,
                        fontWeight: FontWeight.w200,
                        color: ColorConstants.appColor)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      print("Exception - addressListScreen.dart - deleteConfirmationDialog():" +
          e.toString());
      return false;
    }
  }

  _removeAddress(int index) async {
    removeUserAddress(index);
    // try {
    //   showOnlyLoaderDialog();
    //   bool isConnected = await br.checkConnectivity();
    //   if (isConnected) {
    //     global.userProfileController.removeUserAddress(index);

    //     hideLoader();
    //     await _getMyAddressList();
    //     setState(() {});
    //   } else {
    //     hideLoader();
    //     showNetworkErrorSnackBar(_scaffoldKey);
    //   }
    // } catch (e) {
    //   print("Exception - addressListScreen.dart - _removeAddress():" +
    //       e.toString());
    // }
  }

  onCardClick() {
    if (_selectedAddress == null ||
        (_selectedAddress != null && _selectedAddress.addressId == null)) {
      // showToast("Choose address");
    } else {
      print("G1--->101");
      // print('G11--->${selectedTimeSlot.timeslot.toString()}');
      // print('G12--->${is_subscription}');
      // print('G13--->${selectedAddressID}');

      var totalPrice = 0.0;
      var cartPrice = 0.0;
      for (int i = 0;
          i < cartController!.cartItemsList.cartData!.cartProductdata!.length;
          i++) {
        // print('G12--->${cartController.cartItemsList.cartList[i].totalMrp}');
        // print('G13--->${global.total_delivery_count}');
        cartPrice = cartPrice +
            cartController!.cartItemsList.cartData!.cartProductdata![i].price! *
                global.total_delivery_count;
      }
      totalPrice =
          cartController!.cartItemsList.cartData!.totalPrice!.toDouble() +
              cartController!.cartItemsList.cartData!.deliveryCharge! +
              cartController!.cartItemsList.cartData!.subscriptionFee!;
      // print("G1---cartPrice>${cartPrice}");
      // print("G1---totalPrice>${totalPrice}");
      String inString = totalPrice.toStringAsFixed(2); // '2.35'
      double inDouble = double.parse(inString);
      // print("G1---cartPrice>${cartPrice}");
      // print("G1---totalPrice>${inDouble}");

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PaymentGatewayScreen(
                    a: widget.analytics,
                    o: widget.observer,
                    screenId: 1,
                    totalAmount: inDouble,
                    cartController: cartController,
                    order: orderDetails,
                    repeat_orders: repeatOrders,
                    total_delivery_count: global.total_delivery_count,
                    selectedDate: DateTime.now(),
                    selectedTime:
                        "11:00 am - 12:00 pm", //selectedTimeSlot.timeslot,
                    is_subscription: is_subscription,
                    selectedAddressID: _selectedAddress.addressId,
                    selectedAddress: selectedAddress,
                    cartPrice: cartController!
                        .cartItemsList.cartData!.totalPrice!
                        .toDouble(),
                  )));
    }
  }

  @override
  void initState() {
    super.initState();
    getUserAddressList();
  }

  getUserAddressList() async {
    try {
      await apiHelper.getAddressList().then((result) async {
        if (result != null) {
          if (result.status == "1") {
            addressList = result.data;
            global.addressList.clear();
            global.addressList.addAll(addressList);
            global.userProfileController.addressList.clear();
            global.userProfileController.addressList.addAll(addressList);
            print("lgobal list ${global.addressList[0].type}");
            _isDataLoaded = true;

            for (int i = 0; i < global.addressList.length; i++) {
              print("nikhikkhkjhkjhjggj");
              if (global.addressList[i].type!.trim().toLowerCase() == 'home') {
                _selectedAddress = userProfileController.addressList[i];
                selectedIndex = i;
              }
            }
            if (global.addressList.length == 1) {
              _selectedAddress = userProfileController.addressList[0];
              selectedIndex = 0;
            }
            print(selectedIndex);
            setState(() {
              // if (userProfileController.addressList.length == 1) {
              //   _selectedAddress = userProfileController.addressList[0];
              //   selectedIndex = 0;
              // }
            });
          } else {
            print("nikhilllll");
            addressList = [];
            global.addressList = [];
            global.addressList.clear();
            global.userProfileController.addressList.clear();
            global.userProfileController.addressList = [];

            setState(() {
              selectedIndex = -1;
              if (global.userProfileController.addressList.length > 0) {
                _isDataLoaded = true;
              } else {
                _isDataLoaded = true;
              }
            });
          }
        }
      });
    } catch (e) {
      _isDataLoaded = true;
      print(
          "Exception - user_profile_controller.dart - _init():" + e.toString());
    }
  }

  showOnlyLoaderDialog1() {
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

  removeUserAddress(int index) async {
    try {
      await apiHelper
          .removeAddress(addressList[index].addressId!)
          .then((result) async {
        if (result != null) {
          if (result.status == "1") {
            addressList.removeAt(index);
            global.userProfileController.addressList.removeAt(index);
          }

          getUserAddressList();
        }
      });
    } catch (e) {
      hideLoader();
      print("Exception - user_profile_controller.dart - _removeAddress():" +
          e.toString());
    }
  }

  _getMyAddressList() async {
    // setState(() {
    //   _isLoading = true;
    // });
    // try {
    //   // if (global.nearStoreModel != null) {
    //   await global.userProfileController.getUserAddressList();
    //   // }
    //   if (global.userProfileController.isDataLoaded.value == true) {
    //     setState(() {
    //       _isLoading = false;
    //     });

    //     _isDataLoaded = true;
    //   } else {
    //     setState(() {
    //       if (global.userProfileController.addressList.length > 0) {
    //         _isDataLoaded = true;
    //       } else {
    //         _isDataLoaded = false;
    //       }
    //       _isLoading = false;
    //     });
    //   }
    //   setState(() {
    //     if (userProfileController.addressList.length == 1) {
    //       _selectedAddress = userProfileController.addressList[0];
    //       selectedIndex = 0;
    //     }
    //   });
    // } catch (e) {
    //   print("Exception - addressListScreen.dart - _getMyAddressList():" +
    //       e.toString());
    // }
    getUserAddressList();
  }
}
