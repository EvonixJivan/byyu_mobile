import 'dart:io';
import 'package:byyu/controllers/cart_controller.dart';
import 'package:byyu/screens/address/addressListScreen.dart';
import 'package:byyu/screens/order/checkout_screen.dart';
import 'package:byyu/utils/navigation_utils.dart';
import 'package:country_picker/country_picker.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:material_text_fields/material_text_fields.dart';
import 'package:material_text_fields/theme/material_text_field_theme.dart';
import 'package:shimmer/shimmer.dart';
import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/addressModel.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/screens/location_view/location_screen.dart';
import 'package:byyu/widgets/bottom_button.dart';
import 'package:byyu/widgets/my_text_field.dart';

import '../../models/CountryCodeList.dart';
import '../../models/contactUsDropDown.dart';

final _formAddressKey = GlobalKey<FormState>();

class AddAddressScreen extends BaseRoute {
  final Address1 address;
  final int? screenId;
  final String? landmark,
      city,
      address_str,
      fromWhere,
      phoneCode,
      phoneCode1,
      countryCode,
      prefixCode;
  final String? selectedScreen;
  Placemark? setPlace;
  final double? lat;
  final double? lng;
  final bool? isEditButtonClicked;
  bool? fromProfile;
  bool isHomePresent = false;
  bool isOfficePresent = false;

  int? isHOmeOfficePresent = 0;
  CartController? cartController;
  AddAddressScreen(this.address,
      {a,
      o,
      this.screenId,
      this.landmark,
      this.fromProfile,
      this.city,
      this.address_str,
      this.fromWhere,
      this.phoneCode,
      this.phoneCode1,
      this.countryCode,
      this.cartController,
      this.prefixCode,
      this.setPlace,
      isHomePresent,
      isOfficePresent,
      this.selectedScreen,
      this.lat,
      this.lng,
      this.isHOmeOfficePresent,
      this.isEditButtonClicked})
      : super(
            a: a,
            o: o,
            r: 'AddAddressScreen'); //a: a, o: o, r: 'AddAddressScreen');

  @override
  _AddAddressScreenState createState() => new _AddAddressScreenState(
      this.address,
      screenId!,
      this.landmark ?? "",
      this.city,
      this.address_str,
      this.fromWhere,
      this.phoneCode,
      this.phoneCode1,
      this.countryCode,
      this.fromProfile!,
      this.prefixCode ?? "",
      isHomePresent,
      isOfficePresent,
      this.cartController,
      this.setPlace!,
      this.selectedScreen ?? "",
      this.lat!,
      this.lng!,
      this.isHOmeOfficePresent!,
      this.isEditButtonClicked!);
}

class _AddAddressScreenState extends BaseRouteState {
  var _cAddress = new TextEditingController();

  var _cPincode = new TextEditingController();
  var _cState = new TextEditingController();

  var _cName = new TextEditingController();
  var giftRecepient = new TextEditingController();
  var _cPhone = new TextEditingController();

  var _cBuilding = new TextEditingController();
  var _cAppartment = new TextEditingController();
  var _cStreet = new TextEditingController();
  var _cLandmark = new TextEditingController();
  var _cCity = new TextEditingController();
  var _cEmirateName = new TextEditingController();

  var _cSearchArea = new TextEditingController();

  CartController? cartController;

  TextEditingController _cSearchCity = new TextEditingController();
  bool fromProfile;
  String? countryCode = "+971";
  int _phonenumMaxLength = 9;
  String prefixCode;
  String selectedScreen;
  String? dropdownValuestate;
  String? dropdownValueCode;
  List<CountryCodeList> _countryCodeList = [];

  Placemark setPlace;

  bool saveAddressClicked = false;

  var _fPhone = new FocusNode();
  bool isHomePresent = false;
  bool isOfficePresent = false;
  GlobalKey<ScaffoldState>? _scaffoldKey;

  String type = 'Home';
  int editType = 0;
  Address1 address;
  int screenId;
  String? land = "Landmark",
      city = 'City',
      address_str = 'Address',
      fromWhere = '',
      phoneCode = '',
      phoneCode1 = '';
  bool _isDataLoaded = false;

  double lat;
  double lng;
  String? toWhom;
  bool isEditButtonClicked;
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  List<DropDownValueModel> countryListDropDown = [];
  int _phonenumMaxLength1 = 0;
  String countryCodeSelected = "+971", countryCodeFlg = "🇦🇪";
  int isHOmeOfficePresent = 0;
  bool mobileValid = false;

  _AddAddressScreenState(
      this.address,
      this.screenId,
      this.land,
      this.city,
      this.address_str,
      this.fromWhere,
      this.phoneCode,
      this.phoneCode1,
      this.countryCode,
      this.fromProfile,
      this.prefixCode,
      isHomePresent,
      isOfficePresent,
      this.cartController,
      this.setPlace,
      this.selectedScreen,
      this.lat,
      this.lng,
      this.isHOmeOfficePresent,
      this.isEditButtonClicked)
      : super();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        //return null;
        return false;
      },
      child: Container(
        color: global.white,
        child: SafeArea(
          child: Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                backgroundColor: ColorConstants.appBarColorWhite,
                leading: BackButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  color: ColorConstants.newAppColor,
                ),
                centerTitle: false,
                title: isEditButtonClicked == false
                    ? Text("Add Receiver Address",
                        style: TextStyle(
                            fontFamily: fontRailwayRegular,
                            color: ColorConstants.pureBlack,
                            fontWeight: FontWeight
                                .w200) //Theme.of(context).textTheme.titleLarge,
                        )
                    : Text("Save Address",
                        style: TextStyle(
                            fontFamily: fontRailwayRegular,
                            color: ColorConstants.pureBlack,
                            fontWeight: FontWeight
                                .w200) //Theme.of(context).textTheme.titleLarge,
                        ),
              ),
              body: Form(
                key: _formAddressKey,
                child: _isDataLoaded
                    ? Container(
                        color: ColorConstants.colorPageBackground,
                        child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                            },
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, left: 20),
                                    child: Row(
                                      children: [
                                        Icon(Icons.location_on_outlined,
                                            color: ColorConstants
                                                .appColor //Theme.of(context).primaryColor,
                                            ),
                                        Text(
                                          "${setPlace.thoroughfare}",
                                          style: TextStyle(
                                              fontFamily: fontRailwayRegular,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: ColorConstants.pureBlack,
                                              letterSpacing: 1),
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 25,
                                        top: 10,
                                        bottom: 10,
                                        right: 25),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "${setPlace.street}",
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: fontRailwayRegular,
                                              color: ColorConstants.pureBlack,
                                              fontWeight: FontWeight.normal),
                                        )),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: ColorConstants.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7.0))),
                                    margin: EdgeInsets.only(
                                        top: 15, left: 20, right: 20),
                                    padding: EdgeInsets.only(),
                                    child: MaterialTextField(
                                      textInputAction: TextInputAction.next,
                                      style: TextStyle(
                                          fontFamily: global.fontRailwayRegular,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w200,
                                          color: ColorConstants.pureBlack),
                                      theme: FilledOrOutlinedTextTheme(
                                        radius: 8,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 4),
                                        errorStyle: const TextStyle(
                                            fontSize: 10,
                                            fontFamily:
                                                global.fontRailwayRegular,
                                            fontWeight: FontWeight.w200),
                                        fillColor: Colors.transparent,
                                        enabledColor: Colors.grey,
                                        focusedColor: ColorConstants.appColor,
                                        floatingLabelStyle: const TextStyle(
                                            color: ColorConstants.appColor),
                                        width: 0.5,
                                        labelStyle: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),

                                      controller: _cBuilding,

                                      labelText:
                                          'Community/ Building Name*', //'${AppLocalizations.of(context).hnt_address}',
                                      onChanged: (val) {
                                        if (saveAddressClicked &&
                                            _formAddressKey.currentState!
                                                .validate()) {
                                          print("Submit Data");
                                        }
                                      },
                                      validator: (value) {
                                        print(value);
                                        if (value == null || value.isEmpty) {
                                          return "Please enter Community/ Building Name  ";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: ColorConstants.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7.0))),
                                    margin: EdgeInsets.only(
                                        top: 15, left: 20, right: 20),
                                    padding: EdgeInsets.only(),
                                    child: MaterialTextField(
                                      textInputAction: TextInputAction.next,
                                      style: TextStyle(
                                          fontFamily: global.fontRailwayRegular,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w200,
                                          color: ColorConstants.pureBlack),
                                      theme: FilledOrOutlinedTextTheme(
                                        radius: 8,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 4),
                                        errorStyle: const TextStyle(
                                            fontSize: 10,
                                            fontFamily:
                                                global.fontRailwayRegular,
                                            fontWeight: FontWeight.w200),
                                        fillColor: Colors.transparent,
                                        enabledColor: Colors.grey,
                                        focusedColor: ColorConstants.appColor,
                                        floatingLabelStyle: const TextStyle(
                                            color: ColorConstants.appColor),
                                        width: 0.5,
                                        labelStyle: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),

                                      controller: _cAppartment,

                                      labelText:
                                          'Villa/ Apartment Number*', //'${AppLocalizations.of(context).hnt_address}',
                                      onChanged: (val) {
                                        if (saveAddressClicked &&
                                            _formAddressKey.currentState!
                                                .validate()) {
                                          print("Submit Data");
                                        }
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please enter Villa/ Apartment Number ";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: ColorConstants.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7.0))),
                                    margin: EdgeInsets.only(
                                        top: 15, left: 20, right: 20),
                                    padding: EdgeInsets.only(),
                                    child: MaterialTextField(
                                      textInputAction: TextInputAction.next,
                                      style: TextStyle(
                                          fontFamily: global.fontRailwayRegular,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w200,
                                          color: ColorConstants.pureBlack),
                                      theme: FilledOrOutlinedTextTheme(
                                        radius: 8,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 4),
                                        errorStyle: const TextStyle(
                                            fontSize: 10,
                                            fontFamily:
                                                global.fontRailwayRegular,
                                            fontWeight: FontWeight.w200),
                                        fillColor: Colors.transparent,
                                        enabledColor: Colors.grey,
                                        focusedColor: ColorConstants.appColor,
                                        floatingLabelStyle: const TextStyle(
                                            color: ColorConstants.appColor),
                                        width: 0.5,
                                        labelStyle: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                      controller: _cStreet,
                                      labelText: 'Street/ Locality Name*',
                                      onChanged: (val) {
                                        if (saveAddressClicked &&
                                            _formAddressKey.currentState!
                                                .validate()) {
                                          print("Submit Data");
                                        }
                                        //FocusScope.of(context).requestFocus(_fLandmark);
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please enter Street/ Locality name ";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: ColorConstants.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7.0))),
                                    margin: EdgeInsets.only(
                                        top: 15, left: 20, right: 20),
                                    padding: EdgeInsets.only(),
                                    child: MaterialTextField(
                                      textInputAction: TextInputAction.next,
                                      style: TextStyle(
                                          fontFamily: global.fontRailwayRegular,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w200,
                                          color: ColorConstants.pureBlack),
                                      theme: FilledOrOutlinedTextTheme(
                                        radius: 8,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 4),
                                        errorStyle: const TextStyle(
                                            fontSize: 10,
                                            fontFamily:
                                                global.fontRailwayRegular,
                                            fontWeight: FontWeight.w200),
                                        fillColor: Colors.transparent,
                                        enabledColor: Colors.grey,
                                        focusedColor: ColorConstants.appColor,
                                        floatingLabelStyle: const TextStyle(
                                            color: ColorConstants.appColor),
                                        width: 0.5,
                                        labelStyle: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                      controller: _cLandmark,
                                      labelText: 'Landmark (Optional)',
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: ColorConstants.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7.0))),
                                    margin: EdgeInsets.only(
                                        top: 15, left: 20, right: 20),
                                    padding: EdgeInsets.only(),
                                    child: MaterialTextField(
                                      textInputAction: TextInputAction.done,
                                      style: TextStyle(
                                          fontFamily: global.fontRailwayRegular,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w200,
                                          color: ColorConstants.pureBlack),
                                      theme: FilledOrOutlinedTextTheme(
                                        radius: 8,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 4),
                                        errorStyle: const TextStyle(
                                            fontSize: 10,
                                            fontFamily:
                                                global.fontRailwayRegular,
                                            fontWeight: FontWeight.w200),
                                        fillColor: Colors.transparent,
                                        enabledColor: Colors.grey,
                                        focusedColor: ColorConstants.appColor,
                                        floatingLabelStyle: const TextStyle(
                                            color: ColorConstants.appColor),
                                        width: 0.5,
                                        labelStyle: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                      controller: _cEmirateName,
                                      labelText: currentUser != null &&
                                              currentUser.userPhone != null &&
                                              currentUser
                                                  .userPhone!.isNotEmpty &&
                                              (currentUser.userPhone == "971" ||
                                                  currentUser.userPhone ==
                                                      "+971")
                                          ? 'Emirate*'
                                          : "City*",
                                      onChanged: (value) {
                                        if (saveAddressClicked &&
                                            _formAddressKey.currentState!
                                                .validate()) {
                                          print("Submit Data");
                                        }
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return currentUser != null &&
                                                  currentUser.userPhone !=
                                                      null &&
                                                  currentUser
                                                      .userPhone!.isNotEmpty &&
                                                  (currentUser.userPhone ==
                                                          "971" ||
                                                      currentUser.userPhone ==
                                                          "+971")
                                              ? "Please enter the Emirate"
                                              : "Please enter the City";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: ListTile(
                                      title: Text(
                                        "Save as",
                                        // '${AppLocalizations.of(context).lbl_save_address}',
                                        style: TextStyle(
                                            fontFamily: fontRailwayRegular,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: ColorConstants.grey,
                                            letterSpacing: 1),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Visibility(
                                          visible: (isEditButtonClicked &&
                                                  editType == 1) ||
                                              (!isEditButtonClicked &&
                                                  (isHOmeOfficePresent == 0 ||
                                                      isHOmeOfficePresent ==
                                                          2)),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            child: InkWell(
                                              onTap: () {
                                                print(isHOmeOfficePresent);
                                                if (!isEditButtonClicked) {
                                                  if (isHOmeOfficePresent !=
                                                          0 &&
                                                      (isHOmeOfficePresent ==
                                                              1 ||
                                                          isHOmeOfficePresent ==
                                                              3)) {
                                                  } else {
                                                    type = 'Home';
                                                    setState(() {});
                                                  }
                                                } else if (editType == 1) {
                                                  type = 'Home';
                                                  setState(() {});
                                                }
                                              },
                                              customBorder:
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(7.0),
                                              ),
                                              child: Container(
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(7.0),
                                                      ),
                                                      color: type == 'Home'
                                                          ? ColorConstants
                                                              .appColor
                                                          : Theme.of(context)
                                                              .scaffoldBackgroundColor),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 4),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Home",
                                                    // "${AppLocalizations.of(context).txt_home} ",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          fontRailwayRegular,
                                                      color: type == 'Home'
                                                          ? Colors.white
                                                          : ColorConstants
                                                              .newTextHeadingFooter,
                                                      fontWeight: type == 'Home'
                                                          ? FontWeight.w400
                                                          : FontWeight.w700,
                                                      fontSize: 13,
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        ),
                                        (isEditButtonClicked &&
                                                    editType == 2) ||
                                                (!isEditButtonClicked &&
                                                    (isHOmeOfficePresent == 0 ||
                                                        isHOmeOfficePresent ==
                                                            1))
                                            ? SizedBox(
                                                width: 15,
                                              )
                                            : SizedBox(),
                                        Visibility(
                                          visible: (isEditButtonClicked &&
                                                  editType == 2) ||
                                              (!isEditButtonClicked &&
                                                  (isHOmeOfficePresent == 0 ||
                                                      isHOmeOfficePresent ==
                                                          1)),
                                          child: InkWell(
                                            onTap: () {
                                              if (!isEditButtonClicked) {
                                                if (isHOmeOfficePresent != 0 &&
                                                    (isHOmeOfficePresent == 2 ||
                                                        isHOmeOfficePresent ==
                                                            3)) {
                                                } else {
                                                  type = 'Office';
                                                  setState(() {});
                                                }
                                              } else if (editType == 2) {
                                                type = 'Office';
                                                setState(() {});
                                              }
                                            },
                                            customBorder:
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7.0),
                                            ),
                                            child: Container(
                                                height: 30,
                                                margin:
                                                    EdgeInsets.only(left: 1),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(7.0),
                                                    ),
                                                    color: type == 'Office'
                                                        ? ColorConstants
                                                            .appColor
                                                        : Theme.of(context)
                                                            .scaffoldBackgroundColor),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                    vertical: 4),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Office",
                                                  // "${AppLocalizations.of(context).txt_office} ",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        fontRailwayRegular,
                                                    color: type == 'Office'
                                                        ? Colors.white
                                                        : ColorConstants
                                                            .newTextHeadingFooter,
                                                    fontWeight: type == 'Office'
                                                        ? FontWeight.w400
                                                        : FontWeight.w700,
                                                    fontSize: 13,
                                                  ),
                                                )),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 4),
                                          child: InkWell(
                                            onTap: () {
                                              // if (isEditButtonClicked) {
                                              type = 'Others';
                                              setState(() {});
                                              // }
                                            },
                                            customBorder:
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7.0),
                                            ),
                                            child: Container(
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(7.0),
                                                    ),
                                                    color: type == 'Others'
                                                        ? ColorConstants
                                                            .appColor
                                                        : Theme.of(context)
                                                            .scaffoldBackgroundColor),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 4),
                                                alignment: Alignment.center,
                                                child: Text("Others",
                                                    // "${AppLocalizations.of(context).txt_others}",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          fontRailwayRegular,
                                                      color: type == 'Others'
                                                          ? Colors.white
                                                          : ColorConstants
                                                              .newTextHeadingFooter,
                                                      fontWeight:
                                                          type == 'Others'
                                                              ? FontWeight.w400
                                                              : FontWeight.w700,
                                                      fontSize: 13,
                                                    ))),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Visibility(
                                    visible: type == null ? true : false,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: ListTile(
                                        title: Text(
                                          "Select address type",
                                          // '${AppLocalizations.of(context).lbl_save_address}',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: ColorConstants.appColor,
                                              fontFamily:
                                                  global.fontRailwayRegular,
                                              fontWeight: FontWeight.w200),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Container(
                                      child: Text(
                                        'Personal Details',
                                        style: TextStyle(
                                            fontFamily: fontRailwayRegular,
                                            color: ColorConstants.grey,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            letterSpacing: 1),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      margin: EdgeInsets.only(left: 15),
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  type == 'Others'
                                      ? Container(
                                          decoration: BoxDecoration(
                                              color: ColorConstants.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(7.0))),
                                          margin: EdgeInsets.only(
                                              top: 15, left: 20, right: 20),
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
                                                  fontFamily:
                                                      global.fontRailwayRegular,
                                                  fontWeight: FontWeight.w200),
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
                                            controller: giftRecepient,
                                            labelText: "To Whom",
                                            // '${AppLocalizations.of(context).lbl_name}',

                                            onChanged: (value) {
                                              if (saveAddressClicked &&
                                                  _formAddressKey.currentState!
                                                      .validate()) {
                                                print("Submit Data");
                                              }
                                            },
                                          ),
                                        )
                                      : Container(),
                                  type == 'Others'
                                      ? SizedBox(height: 5.0)
                                      : Container(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            showCountryPicker(
                                              countryListTheme:
                                                  CountryListThemeData(
                                                      inputDecoration:
                                                          InputDecoration(
                                                              hintText: "",
                                                              label: Text(
                                                                "Search",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontFamily:
                                                                        fontRailwayRegular,
                                                                    color: ColorConstants
                                                                        .appColor),
                                                              )),
                                                      searchTextStyle: TextStyle(
                                                          color: ColorConstants
                                                              .pureBlack),
                                                      textStyle: TextStyle(
                                                          fontFamily:
                                                              fontRailwayRegular,
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          fontSize: 16,
                                                          color: ColorConstants
                                                              .pureBlack,
                                                          letterSpacing: 1)),
                                              context: context,
                                              showPhoneCode:
                                                  true, // optional. Shows phone code before the country name.
                                              onSelect: (Country country) {
                                                _cPhone.text = "";
                                                print(
                                                    'Select country: ${country.displayName} & ${country.countryCode} & ${country.flagEmoji}');
                                                countryCode = country.phoneCode;
                                                countryCodeFlg =
                                                    "${country.flagEmoji}";
                                                countryCodeSelected =
                                                    "+${country.phoneCode}";
                                                _phonenumMaxLength1 =
                                                    country.example.length;
                                                setState(() {});
                                              },
                                            );
                                          },
                                          child: Container(
                                            height: mobileValid ? 40 : 48,
                                            width: 125,
                                            margin: EdgeInsets.only(
                                                bottom: mobileValid ? 20 : 5),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey.shade300,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(7.0))),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        5, 1, 0, 0),
                                                child: Row(
                                                  children: [
                                                    Text(countryCodeFlg,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                fontMontserratMedium,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 25,
                                                            color:
                                                                ColorConstants
                                                                    .pureBlack,
                                                            letterSpacing: 1)),
                                                    Expanded(
                                                        child: Text(
                                                            countryCodeSelected,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    fontRailwayRegular,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w200,
                                                                fontSize: 16,
                                                                color: ColorConstants
                                                                    .pureBlack,
                                                                letterSpacing:
                                                                    1))),
                                                    Icon(
                                                      Icons.arrow_drop_down,
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
                                            height: mobileValid ? 40 : 60,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(0.0))),
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
                                                cursorColor: ColorConstants
                                                    .newTextHeadingFooter,
                                                controller: _cPhone,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                        fontRailwayRegular,
                                                    fontWeight: FontWeight.w200,
                                                    color: ColorConstants
                                                        .pureBlack,
                                                    letterSpacing: 1),
                                                keyboardType: TextInputType
                                                    .number,
                                                textCapitalization:
                                                    TextCapitalization.words,
                                                maxLength:
                                                    _phonenumMaxLength1 == 0
                                                        ? 9
                                                        : _phonenumMaxLength1,
                                                focusNode: _fPhone,
                                                onFieldSubmitted: (val) {
                                                  FocusScope.of(context)
                                                      .requestFocus(_fPhone);
                                                },
                                                obscuringCharacter: '*',
                                                decoration: InputDecoration(
                                                    counterText: "",
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelStyle: TextStyle(
                                                        color: _fPhone
                                                                    .hasFocus ==
                                                                true
                                                            ? ColorConstants
                                                                .appColor
                                                            : ColorConstants
                                                                .grey),
                                                    labelText: "Mobile Number*",
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7),
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey.shade400,
                                                          width: 0.0),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7),
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey.shade400,
                                                          width: 0.0),
                                                    ),
                                                    errorStyle: const TextStyle(
                                                        fontSize: 10,
                                                        fontFamily: global
                                                            .fontRailwayRegular,
                                                        fontWeight:
                                                            FontWeight.w200),
                                                    hintText: '561234567',
                                                    hintStyle: TextStyle(
                                                        fontFamily:
                                                            fontRailwayRegular,
                                                        fontSize:
                                                            14) //textFieldHintStyle(context),
                                                    ),
                                                onChanged: (val) {
                                                  if (saveAddressClicked &&
                                                      _formAddressKey
                                                          .currentState!
                                                          .validate()) {
                                                    print("Submit Data");
                                                  }
                                                },
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    mobileValid = false;
                                                    setState(() {});
                                                    return "Please enter Mobile Number ";
                                                  } else if (_cPhone
                                                          .text.isNotEmpty &&
                                                      _phonenumMaxLength1 ==
                                                          0 &&
                                                      _cPhone.text.length < 9) {
                                                    mobileValid = false;
                                                    setState(() {});
                                                    return "Please enter valid mobile number";
                                                  } else if (_phonenumMaxLength1 >
                                                          0 &&
                                                      _cPhone.text.length <
                                                          _phonenumMaxLength1) {
                                                    return "Please enter valid mobile number";
                                                  } else {
                                                    return null;
                                                  }
                                                }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: ColorConstants.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7.0))),
                                    margin: EdgeInsets.only(
                                        top: 1, left: 20, right: 20),
                                    padding: EdgeInsets.only(),
                                    child: MaterialTextField(
                                        textInputAction: TextInputAction.done,
                                        style: TextStyle(
                                            fontFamily:
                                                global.fontRailwayRegular,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w200,
                                            color: ColorConstants.pureBlack),
                                        theme: FilledOrOutlinedTextTheme(
                                          radius: 8,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 4, vertical: 4),
                                          errorStyle: const TextStyle(
                                              fontSize: 10,
                                              fontFamily:
                                                  global.fontRailwayRegular,
                                              fontWeight: FontWeight.w200),
                                          fillColor: Colors.transparent,
                                          enabledColor: Colors.grey,
                                          focusedColor: ColorConstants.appColor,
                                          floatingLabelStyle: const TextStyle(
                                              color: ColorConstants.appColor),
                                          width: 0.5,
                                          labelStyle: const TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                        controller: _cName,
                                        labelText: "Name*",
                                        onChanged: (val) {
                                          if (saveAddressClicked &&
                                              _formAddressKey.currentState!
                                                  .validate()) {
                                            print("Submit Data");
                                          }
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Please enter Name";
                                          } else {
                                            return null;
                                          }
                                        }),
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            )
                            // : _shimmerList(),
                            ),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
              bottomNavigationBar: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: InkWell(
                    onTap: () {
                      saveAddressClicked = true;
                      if (_formAddressKey.currentState!.validate()) {
                        isEditButtonClicked != true
                            ? _callSaveAddressApi()
                            : _calleditAddress();
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: (MediaQuery.of(context).size.width / 2) - 30,
                      decoration: BoxDecoration(
                          color: ColorConstants.appColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        isEditButtonClicked != true
                            ? "SAVE ADDRESS"
                            : "SAVE ADDRESS",
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
                  ))
              // : null,
              ),
        ),
      ),
    );
  }

  _fillData() async {
    try {
      _cBuilding.text = address.houseNo!;
      _cAppartment.text = address.building_villa!;
      _cStreet.text = address.society!;
      _cLandmark.text = address.landmark ?? "";
      _cEmirateName.text = address.cityName!;
      type = address.type!;
      if (type.toLowerCase() == "home") {
        editType = 1;
      } else if (type.toLowerCase() == "office") {
        editType = 2;
      } else {
        editType = 3;
      }
      _cName.text = address.receiverName!;
      _cPhone.text = address.receiverPhone!;
      giftRecepient.text = address.recepientName!;
    } catch (e) {
      print("Excetion - addAddessScreen.dart - _fillData():" + e.toString());
    }
    //}
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print(
        "Nikhilkhghjgv isHOmeOfficePresent-------------${isHOmeOfficePresent}");
    if (isHOmeOfficePresent >= 1 && !isEditButtonClicked) {
      if (isHOmeOfficePresent == 1) {
        type = 'Office';
      } else if (isHOmeOfficePresent == 3) {
        type = 'Others';
      }
    } else {
      type = 'Home';
    }
    print(isHomePresent);
    print(isOfficePresent);

    isEditButtonClicked = isEditButtonClicked;
    _init();
  }

  _init() async {
    if (address != null) {
      if (address.addressId != null) {
        await _fillData();
        setState(() {});
      } else {
        _cEmirateName.text = "Dubai";
      }
    } else {
      _cEmirateName.text = "Dubai";
    }
    _isDataLoaded = true;
    // _getCountryCode();
  }

  Widget _shimmerList() {
    try {
      return ListView.builder(
        itemCount: 7,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(top: 15, left: 16, right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(7.0),
              ),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 52,
                    width: MediaQuery.of(context).size.width,
                    child: Card(),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      print("Exception - add_address_screen.dart - _shimmerList():" +
          e.toString());
      return SizedBox();
    }
  }

  Future<void> _callSaveAddressApi() async {
    Address1 newAddress = new Address1();
    // newAddress.addressId = address.addressId;
    newAddress.type = type;
    newAddress.landmark = _cLandmark.text;
    newAddress.receiverName = _cName.text;
    newAddress.receiverPhone = _cPhone.text;
    newAddress.countryCode = countryCodeSelected;
    newAddress.city = setPlace.street;
    newAddress.lat = lat.toString();
    newAddress.lng = lng.toString();
    newAddress.state = setPlace.country;
    newAddress.society = _cStreet.text;
    newAddress.landmark = _cLandmark.text;
    newAddress.houseNo = _cBuilding.text;
    newAddress.building_villa = _cAppartment.text;
    newAddress.cityName = _cEmirateName.text;

    await apiHelper
        .addAddress(newAddress, giftRecepient.text, countryCodeFlg)
        .then((result) async {
      if (result != null) {
        if (result.status == "1") {
          //await global.userProfileController.getUserAddressList();
          hideLoader();

          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              // builder: (context) => CheckoutScreen(
              builder: (context) => CheckoutScreen(
                    a: widget.analytics,
                    o: widget.observer,
                    cartController: fromProfile ? null : cartController,
                    fromProfile: fromProfile,
                  )));
        } else {
          showSnackBar(
              snackBarMessage: 'Something went wrong', key: _scaffoldKey);
        }
      }
    });
  }

  Future<void> _calleditAddress() async {
    Address1 newAddress = new Address1();
    newAddress.addressId = address.addressId;
    newAddress.type = type;
    newAddress.landmark = _cLandmark.text;
    newAddress.receiverName = _cName.text;
    newAddress.receiverPhone = _cPhone.text;
    newAddress.countryCode = countryCodeSelected;
    newAddress.city = setPlace.street;
    newAddress.lat = lat.toString();
    newAddress.lng = lng.toString();
    newAddress.society = _cStreet.text;
    newAddress.state = setPlace.country;
    newAddress.houseNo = _cBuilding.text.toString();
    newAddress.building_villa = _cAppartment.text.toString();
    newAddress.cityName = _cEmirateName.text.toString();

    await apiHelper
        .editAddress(newAddress, countryCodeFlg, giftRecepient.text)
        .then((result) async {
      if (result != null) {
        if (result.status == "1") {
          // await global.userProfileController.getUserAddressList();
          hideLoader();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CheckoutScreen(
                    a: widget.analytics,
                    o: widget.observer,
                    cartController: cartController,
                    fromProfile: fromProfile,
                  )));
        } else {
          hideLoader();
          showSnackBar(key: _scaffoldKey, snackBarMessage: '${result.message}');
        }
      } else {
        hideLoader();
        showSnackBar(
            key: _scaffoldKey,
            snackBarMessage: 'Some error occurred please try again.');
      }
    });
  }
  // }
}
