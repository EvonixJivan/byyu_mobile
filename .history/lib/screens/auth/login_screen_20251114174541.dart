import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'package:byyu/screens/home_screen.dart';
import 'package:byyu/widgets/toastfile.dart';

import 'package:country_picker/country_picker.dart';
import 'package:crypto/crypto.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:dio/dio.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/CountryCodeList.dart';

import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/models/userModel.dart';
import 'package:byyu/screens/auth/otp_verification_screen.dart';
import 'package:byyu/screens/auth/signup_screen.dart';
import 'package:byyu/widgets/bottom_button.dart';

import 'update_mobile_email.dart';

class LoginScreen extends BaseRoute {
  bool? logout;
  LoginScreen({a, o, this.logout}) : super(a: a, o: o, r: 'LoginScreen');

  @override
  _LoginScreenState createState() => _LoginScreenState(logout: logout);
}

class _LoginScreenState extends BaseRouteState {
  bool isLoginWithEmail = false;
  bool? logout = false;
  TextEditingController _cPhone = new TextEditingController();
  TextEditingController _cEmail = new TextEditingController();
  TextEditingController _cPassword = new TextEditingController();
  TextEditingController _cCountryCode = TextEditingController();

  GlobalKey<ScaffoldState>? _scaffoldKey1;
  var _cPhoneCode = new TextEditingController();
  var dropdownAge;
  String selectedAge = "Age";
  bool _isLoading = true;

  late String dropdownValuestate;
  late String dropdownValueCode;
  List<CountryCodeList> _countryCodeList = [];

  String countryCode = "+971";
  bool mobileInputEnabled = true;

  late GlobalKey<ScaffoldState> _scaffoldKey;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int _phonenumMaxLength1 = 0;
  int _phonenumMaxLength = 9;
  List<Map<String, dynamic>> _ccItems = [];
  late String selectedCountryCode;
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  FocusNode _fPhone = FocusNode();
  List<DropDownValueModel> countryListDropDown = [];

  String countryCodeSelected = "+971", countryCodeFlg = "🇦🇪";

  String strNumberError = "";
  bool boolNumberError = false;

  _LoginScreenState({this.logout});

  @override
  Widget build(BuildContext context) {
    _cPhoneCode.text = "";
    double screenHeight = MediaQuery.of(context).size.height;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      backgroundColor: ColorConstants.colorPageBackground,
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey1,
      appBar: AppBar(
        leadingWidth: 46,
        backgroundColor: ColorConstants.appBarColorWhite,
        title: Text("SIGN IN",
            style: TextStyle(
              fontFamily: fontRailwayRegular,
              color: ColorConstants.newTextHeadingFooter,
              fontWeight: FontWeight.w200,
            )),
        centerTitle: false,
        leading: BackButton(
          onPressed: () {
            global.currentUser = CurrentUser();
            global.cartCount = 0;
            global.wishlistCount = 0;
            print("Go back");
            Navigator.pop(context);
          },
          color: ColorConstants.appColor,
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  EdgeInsets.only(left: 15, right: 15, top: 30),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      margin: EdgeInsets.only(top: 0),
                                      height: 200,
                                      width: 200,
                                      child: Image.asset(
                                        'assets/images/new_logo.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
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
                                                                    label: Text(
                                                                      "Search",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontFamily:
                                                                              fontRailwayRegular,
                                                                          color:
                                                                              ColorConstants.appColor),
                                                                    )),
                                                            searchTextStyle: TextStyle(
                                                                color: ColorConstants
                                                                    .pureBlack),
                                                            flagSize: 20,
                                                            textStyle:
                                                                TextStyle(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              fontFamily:
                                                                  fontRailwayRegular,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200,
                                                              fontSize: 15,
                                                              color:
                                                                  ColorConstants
                                                                      .pureBlack,
                                                            )),
                                                    context: context,
                                                    showPhoneCode: true,
                                                    onSelect:
                                                        (Country country) {
                                                      _cPhone.text = "";
                                                      print(
                                                          'Select country: ${country.displayName} & ${country.countryCode} & ${country.flagEmoji}');
                                                      print(
                                                          'Select country: ${country.example}');
                                                      print(
                                                          'Select country: ${country.fullExampleWithPlusSign}');
                                                      countryCode =
                                                          country.phoneCode;
                                                      countryCodeFlg =
                                                          "${country.flagEmoji}";
                                                      countryCodeSelected =
                                                          "+${country.phoneCode}";
                                                      _phonenumMaxLength1 =
                                                          country
                                                              .example.length;

                                                      setState(() {});
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  height: 40,
                                                  width: 125,
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
                                                      padding: const EdgeInsets
                                                          .fromLTRB(5, 1, 0, 0),
                                                      child: Row(
                                                        children: [
                                                          Text(countryCodeFlg,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      fontMontserratMedium,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 25,
                                                                  color: ColorConstants
                                                                      .pureBlack,
                                                                  letterSpacing:
                                                                      1)),
                                                          Expanded(
                                                              child: Text(
                                                                  countryCodeSelected,
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
                                                            color: global
                                                                .bgCompletedColor,
                                                          )
                                                        ],
                                                      )),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  height: 40,
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
                                                    controller: _cPhone,
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
                                                        TextInputType.number,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .words,
                                                    maxLength:
                                                        _phonenumMaxLength1 == 0
                                                            ? 9
                                                            : _phonenumMaxLength1,
                                                    focusNode: _fPhone,
                                                    onFieldSubmitted: (val) {
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              _fPhone);
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
                                                        labelText:
                                                            "Enter Mobile Number*",
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(7),
                                                          borderSide: BorderSide(
                                                              color: _fPhone
                                                                          .hasFocus ==
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
                                                                  .circular(7),
                                                          borderSide: BorderSide(
                                                              color: ColorConstants
                                                                  .newAppColor,
                                                              width: 0.0),
                                                        ),
                                                        hintText: '561234567',
                                                        hintStyle: TextStyle(
                                                            fontFamily:
                                                                fontRailwayRegular,
                                                            fontSize: 14)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: boolNumberError,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                            ),
                                            child: Text(
                                              strNumberError,
                                              style: TextStyle(
                                                  color:
                                                      ColorConstants.appColor,
                                                  fontSize: 11,
                                                  fontFamily:
                                                      global.fontRailwayRegular,
                                                  fontWeight: FontWeight.w200),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: userInactive ? 1 : 10,
                                        ),
                                        Visibility(
                                          visible: countryCodeSelected ==
                                                      "971" ||
                                                  countryCodeSelected == "+971"
                                              ? false
                                              : true,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                            ),
                                            child: Text(
                                              "All communication outside the UAE is exclusively done through WhatsApp.",
                                              style: TextStyle(
                                                  color:
                                                      ColorConstants.appColor,
                                                  fontSize: 11,
                                                  fontFamily:
                                                      global.fontRailwayRegular,
                                                  fontWeight: FontWeight.w200),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: userInactive ? 8 : 5,
                                        ),
                                        Visibility(
                                            visible: userInactive,
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                left: 15,
                                                right: 15,
                                              ),
                                              child: Text(
                                                activateMessage,
                                                style: TextStyle(
                                                    color:
                                                        ColorConstants.appColor,
                                                    fontSize: 13,
                                                    fontFamily: global
                                                        .fontRailwayRegular,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            )),
                                        SizedBox(
                                          height: userInactive ? 8 : 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5, right: 5),
                                              child: Container(
                                                height: 35,
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2) -
                                                    50,
                                                decoration: BoxDecoration(
                                                    color:
                                                        ColorConstants.appColor,
                                                    border: Border.all(
                                                        color: ColorConstants
                                                            .appColor,
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: BottomButton(
                                                    color:
                                                        ColorConstants.appColor,
                                                    child: Text(
                                                      "GET OTP",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              fontMontserratMedium,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color: ColorConstants
                                                              .white,
                                                          letterSpacing: 1),
                                                    ),
                                                    loadingState: false,
                                                    disabledState: true,
                                                    onPressed: () {
                                                      // if(userInactive){

                                                      //   activateAccount=0;
                                                      //   userInactive=false;

                                                      //   setState(() { });
                                                      // }else{
                                                      print("NIKHIKLLLLLLLLLL");
                                                      if (_cPhone
                                                          .text.isEmpty) {
                                                        boolNumberError = true;
                                                        strNumberError =
                                                            "Please enter Mobile Number";
                                                        setState(() {});
                                                      } else if (_cPhone.text
                                                              .isNotEmpty &&
                                                          _phonenumMaxLength1 ==
                                                              0 &&
                                                          _cPhone.text.length <
                                                              9) {
                                                        boolNumberError = true;
                                                        strNumberError =
                                                            "Please enter valid Mobile Number";
                                                        setState(() {});
                                                      } else if (_phonenumMaxLength1 >
                                                              0 &&
                                                          _cPhone.text.length <
                                                              _phonenumMaxLength1) {
                                                        boolNumberError = true;
                                                        strNumberError =
                                                            "Please enter valid Mobile Number";
                                                        setState(() {});
                                                      } else {
                                                        boolNumberError = false;
                                                        setState(() {});
                                                        login(_cPhone.text);
                                                      }
                                                    }
                                                    // },
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        isBiometricEnabled
                                            ? Column(
                                                children: [
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    height: 45,
                                                    child: Column(
                                                      children: [
                                                        Platform.isIOS
                                                            ? InkWell(
                                                                onTap: () {
                                                                  authenticateWithBiometrics();
                                                                },
                                                                child:
                                                                    Image.asset(
                                                                  'assets/images/iv_face_id.png',
                                                                  width: 40,
                                                                  height: 40,
                                                                  color: ColorConstants
                                                                      .newAppColor,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ),
                                                              )
                                                            : InkWell(
                                                                onTap: () {
                                                                  authenticateWithBiometrics();
                                                                },
                                                                child:
                                                                    isFaceIdPresent
                                                                        ? Image
                                                                            .asset(
                                                                            'assets/images/iv_face_id.png',
                                                                            width:
                                                                                40,
                                                                            height:
                                                                                40,
                                                                            color:
                                                                                ColorConstants.newAppColor,
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          )
                                                                        : Icon(
                                                                            MdiIcons.fingerprint,
                                                                            color:
                                                                                ColorConstants.newAppColor,
                                                                            size:
                                                                                40,
                                                                          ),
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              )
                                            : SizedBox(
                                                height: userInactive ? 50 : 75,
                                              ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                color: Colors.black12,
                                                height: 1,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text("Or continue with",
                                                style: TextStyle(
                                                    color: ColorConstants
                                                        .pureBlack,
                                                    fontFamily:
                                                        fontRailwayRegular,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Container(
                                                color: Colors.black12,
                                                height: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        Platform.isIOS
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5,
                                                    left: 20,
                                                    right: 20,
                                                    bottom: 5),
                                                child: Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        _googleBtnClick();
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color:
                                                                    ColorConstants
                                                                        .grey),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        7),
                                                            color: Colors
                                                                .transparent),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Image.asset(
                                                                'assets/images/google_logo.png',
                                                                height: 20,
                                                                width: 20,
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                              SizedBox(
                                                                width: 8,
                                                              ),
                                                              Text(
                                                                'Continue with Google',
                                                                style: TextStyle(
                                                                    color: ColorConstants
                                                                        .pureBlack,
                                                                    fontFamily:
                                                                        fontRailwayRegular,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    // SizedBox(height: 10,),
                                                    // InkWell(
                                                    //   onTap: () {
                                                    //     facebookLoginAA();
                                                    //   },
                                                    //   child: Container(
                                                    //     width: 40,
                                                    //     height: 40,
                                                    //     decoration: BoxDecoration(
                                                    //         border: Border.all(
                                                    //             color:
                                                    //                 ColorConstants
                                                    //                     .pureBlack),
                                                    //         borderRadius:
                                                    //             BorderRadius
                                                    //                 .circular(7),
                                                    //         color: Colors
                                                    //             .transparent),
                                                    //     child: Padding(
                                                    //       padding:
                                                    //           const EdgeInsets
                                                    //               .all(1.0),
                                                    //       child: Row(
                                                    //         mainAxisAlignment:
                                                    //             MainAxisAlignment
                                                    //                 .center,
                                                    //         children: [
                                                    //           Image.asset(
                                                    //             'assets/images/facebookgrad.png',
                                                    //             color: ColorConstants
                                                    //                 .fbIconColor,
                                                    //             height: 28,
                                                    //             width: 28,
                                                    //             fit: BoxFit
                                                    //                 .contain,
                                                    //           ),
                                                    //         ],
                                                    //       ),
                                                    //     ),
                                                    //   ),
                                                    // ),

                                                    // Container(
                                                    //   width: 40,
                                                    //   height: 40,
                                                    //   decoration: BoxDecoration(
                                                    //       border: Border.all(
                                                    //           color:
                                                    //               ColorConstants
                                                    //                   .pureBlack),
                                                    //       borderRadius:
                                                    //           BorderRadius
                                                    //               .circular(7),
                                                    //       color:
                                                    //           Colors.transparent),
                                                    //   child: Padding(
                                                    //     padding:
                                                    //         const EdgeInsets.all(
                                                    //             1.0),
                                                    //     child: Row(
                                                    //       mainAxisAlignment:
                                                    //           MainAxisAlignment
                                                    //               .center,
                                                    //       children: [
                                                    //         Image.asset(
                                                    //           'assets/images/yandex.png',
                                                    //           color: ColorConstants
                                                    //               .YandexIconColor,
                                                    //           height: 40,
                                                    //           width: 20,
                                                    //           fit: BoxFit.contain,
                                                    //         ),
                                                    //       ],
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        _signInWithApple();
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color:
                                                                    ColorConstants
                                                                        .grey),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        7),
                                                            color: Colors
                                                                .transparent),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons.apple,
                                                                size: 25,
                                                                color: ColorConstants
                                                                    .pureBlack,
                                                              ),
                                                              SizedBox(
                                                                width: 8,
                                                              ),
                                                              Text(
                                                                'Continue with Apple',
                                                                style: TextStyle(
                                                                    color: ColorConstants
                                                                        .pureBlack,
                                                                    fontFamily:
                                                                        fontRailwayRegular,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5,
                                                    left: 20,
                                                    right: 20,
                                                    bottom: 5),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        _googleBtnClick();
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 0.5,
                                                                color:
                                                                    ColorConstants
                                                                        .grey),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        7),
                                                            color: Colors
                                                                .transparent),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Image.asset(
                                                                'assets/images/google_logo.png',
                                                                height: 20,
                                                                width: 20,
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                              SizedBox(
                                                                width: 8,
                                                              ),
                                                              Text(
                                                                'Continue with Google',
                                                                style: TextStyle(
                                                                    color: ColorConstants
                                                                        .pureBlack,
                                                                    fontFamily:
                                                                        fontRailwayRegular,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),

                                                    // SizedBox(
                                                    //   height: 10,
                                                    // ),
                                                    // InkWell(
                                                    //   onTap: () {
                                                    //     // loginWithFacebook();
                                                    //     // facebookLoginAA();
                                                    //     FacebookAuth.instance
                                                    //         .login(
                                                    //             permissions: [
                                                    //           "public_profile",
                                                    //           "email"
                                                    //         ]).then((value) {
                                                    //       FacebookAuth.instance
                                                    //           .getUserData()
                                                    //           .then((userData) {
                                                    //         setState(() {
                                                    //           print(userData.toString());
                                                    //           showToast(userData
                                                    //               .toString());
                                                    //         });
                                                    //       });
                                                    //     });
                                                    //   },
                                                    //   child: Container(
                                                    //     // width: 40,
                                                    //     height: 40,
                                                    //     decoration: BoxDecoration(
                                                    //         border: Border.all(
                                                    //             width: 0.5,
                                                    //             color:
                                                    //                 ColorConstants
                                                    //                     .grey),
                                                    //         borderRadius:
                                                    //             BorderRadius
                                                    //                 .circular(
                                                    //                     7),
                                                    //         color: Colors
                                                    //             .transparent),
                                                    //     child: Padding(
                                                    //       padding:
                                                    //           const EdgeInsets
                                                    //               .all(1.0),
                                                    //       child: Row(
                                                    //         mainAxisAlignment:
                                                    //             MainAxisAlignment
                                                    //                 .center,
                                                    //         children: [
                                                    //           Image.asset(
                                                    //             'assets/images/facebookgrad.png',
                                                    //             // color: ColorConstants
                                                    //             //     .fbIconColor,
                                                    //             height: 28,
                                                    //             width: 28,
                                                    //             fit: BoxFit
                                                    //                 .contain,
                                                    //           ),
                                                    //           SizedBox(
                                                    //             width: 8,
                                                    //           ),
                                                    //           Text(
                                                    //             'Continue with Facebook',
                                                    //             style: TextStyle(
                                                    //                 color: ColorConstants
                                                    //                     .pureBlack,
                                                    //                 fontFamily:
                                                    //                     fontRailwayRegular,
                                                    //                 fontWeight:
                                                    //                     FontWeight
                                                    //                         .w400,
                                                    //                 fontSize:
                                                    //                     16),
                                                    //           ),
                                                    //         ],
                                                    //       ),
                                                    //     ),
                                                    //   ),
                                                    // ),

                                                    //<---------------------------
                                                    // Container(
                                                    //   width: 40,
                                                    //   height: 40,
                                                    //   decoration: BoxDecoration(
                                                    //       border: Border.all(
                                                    //           width: 0.5,
                                                    //           color:
                                                    //               ColorConstants
                                                    //                   .grey),
                                                    //       borderRadius:
                                                    //           BorderRadius
                                                    //               .circular(7),
                                                    //       color:
                                                    //           Colors.transparent),
                                                    //   child: Padding(
                                                    //     padding:
                                                    //         const EdgeInsets.all(
                                                    //             1.0),
                                                    //     child: Row(
                                                    //       mainAxisAlignment:
                                                    //           MainAxisAlignment
                                                    //               .center,
                                                    //       children: [
                                                    //         Image.asset(
                                                    //           'assets/images/yandex.png',
                                                    //           color: ColorConstants
                                                    //               .YandexIconColor,
                                                    //           height: 40,
                                                    //           width: 20,
                                                    //           fit: BoxFit.contain,
                                                    //         ),
                                                    //       ],
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                        SizedBox(
                                          height: userInactive ? 0 : 10,
                                        ),
                                        ConstrainedBox(
                                          constraints: BoxConstraints.expand(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: userInactive
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3.2
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 1),
                                                child: Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: Text(
                                                    "Don't have an account?",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            fontRailwayRegular,
                                                        color: ColorConstants
                                                            .pureBlack,
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        fontSize: 14,
                                                        letterSpacing: 1),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 1),
                                                child: Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  SignUpScreen(
                                                                    a: widget
                                                                        .analytics,
                                                                    o: widget
                                                                        .observer,
                                                                    countryCodeList:
                                                                        _countryCodeList,
                                                                    loginCountryCode:
                                                                        "",
                                                                    loginSeletedFlag:
                                                                        "",
                                                                  )));
                                                    },
                                                    child: Text(
                                                      "SIGN UP",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              fontRailwayRegular,
                                                          color: ColorConstants
                                                              .appColor,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16,
                                                          letterSpacing: 1),
                                                    ),
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
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  bool isBiometricEnabled = false;
  bool isFaceIdPresent = false;
  @override
  void initState() {
    super.initState();

    _isLoading = false;
    if (global.availableBiometrics != null &&
        global.availableBiometrics.length > 0) {
      print("Niks----1");
      isBiometricEnabled = true;
    } else {
      print("Niks----2");
      isBiometricEnabled = false;
    }
    _fPhone.addListener(() {
      setState(() {});
    });
    print("Niks-----------current user in intstate");
    print(global.currentUser);
    if (global.sp != null &&
        global.sp!.getString("currentUser") != null &&
        global.sp!.containsKey(global.quickLoginEnabled) &&
        global.sp!.getBool(quickLoginEnabled)!) {
      if (global.availableBiometrics.length > 0) {
        print("Niks----3");
        isBiometricEnabled = true;
        authenticateWithBiometrics();
      }
    } else {
      print("Niks----4");
      isBiometricEnabled = false;
    }
    if (isBiometricEnabled) {
      for (int i = 0; i < global.availableBiometrics.length; i++) {
        if (global.availableBiometrics[i] == BiometricType.face) {
          isFaceIdPresent = true;
        }
      }
    }
  }

// Aayush: FaceBook Login Function
// Map<String, dynamic>? _userData;
//   AccessToken? _accessToken;
//   facebookLoginAA() async {
//     print("FaceBook");
//     try {
//       // final result =
//       //     await FacebookAuth.i.login(permissions: ['public_profile', 'email']);
//       // if (result.status == LoginStatus.success) {
//       //   final userData = await FacebookAuth.i.getUserData();
//       //   print(userData);
//       // }
//     final LoginResult loginResult = await FacebookAuth.instance.login(permissions: ['public_profile', 'email']);
//     print(loginResult);
//     if (loginResult.status == LoginStatus.success) {
//       _accessToken = loginResult.accessToken;
//       final userInfo = await FacebookAuth.instance.getUserData();
//       _userData = userInfo;
//     } else {
//       print('ResultStatus: ${loginResult.status}');
//       print('Message: ${loginResult.message}');
//     }
//     } catch (error) {
//       print(error);
//     }
//   }

  Future<void> authenticateWithBiometrics() async {
    print("jhnfjkasndjkf afojasbdfkj asdfbsjd fjasdhfjnasj");
    try {
      final LocalAuthentication auth = LocalAuthentication();
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      global.currentUser = CurrentUser();
      if (canCheckBiometrics) {
        await auth
            .authenticate(
                localizedReason: 'Authenticate with fingerprint or Face ID',
                options: const AuthenticationOptions(useErrorDialogs: false))
            .then((value) async {
          print("authenticateWithBiometrics ------");
          print(value);
          if (value) {
            global.stayLoggedIN = true;
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            print("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-");
            print(preferences.getString("currentUser"));
            global.currentUser = CurrentUser.fromJson(
                json.decode(preferences.getString("currentUser")!));
            global.cartCount = global.currentUser.cart_count != null
                ? global.currentUser.cart_count!
                : 0;
            preferences.setBool(global.quickLoginEnabled, true);
            preferences.setBool(global.isLoggedIn, true);
            print(global.currentUser);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomeScreen(
                      a: widget.analytics,
                      o: widget.observer,
                      selectedIndex: 0,
                    )));
          } else {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.setBool(global.quickLoginEnabled, false);
            // global.currentUser=CurrentUser();
            print(global.currentUser);
            print("biometric auth cancelled");
          }
          return;
        });
        if (!mounted) {
          return;
        }
      }
    } on PlatformException catch (e) {
      print(e);
      return;
    }
  }

  int activateAccount = 0;
  bool userInactive = false;

  String activateMessage = "";
  login(String userPhone) async {
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        String nPhone = "${_cPhone.text}";

        print("Nikhil login method-- ${nPhone}");
        showOnlyLoaderDialog();
        global.currentUser = new CurrentUser();
        await apiHelper
            .login(nPhone, countryCode, activateAccount)
            .then((result) async {
          print("RESULTTTTTTTTTT LOGIN APIIII>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
          print(result.message);
          if (result != null) {
            print(result.status);
            if (result.status == "1") {
              print(result.status);
              print(
                  "Nikhil login method-countryCode- ${int.parse(countryCode) != 971}");
              print(
                  "Nikhil login method-global.currentUser.whatsapp_flag- ${global.currentUser.whatsapp_flag}");
              bool isWhatsAppFlag;

              if (global.currentUser.whatsapp_flag != null &&
                  global.currentUser.whatsapp_flag == "1") {
                isWhatsAppFlag = true;
              } else if (int.parse(countryCode) == 971) {
                print("Nikhil login method-countryCode- ${countryCode}");
                isWhatsAppFlag = false;
              } else {
                isWhatsAppFlag = true;
              }
              if (Platform.isAndroid) {
                hideLoader();

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OtpVerificationScreen(
                            phoneNumber: nPhone,
                            isPhoneChange: 1,
                            isFromUpdate: false,
                            isAddMobile: false,
                            isFromSignUPLogin: isWhatsAppFlag,
                            countryCode:
                                countryCode != null ? countryCode : "971",
                            a: widget.analytics,
                            o: widget.observer)));
              } else {
                hideLoader();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OtpVerificationScreen(
                            phoneNumber: nPhone,
                            isPhoneChange: 1,
                            isFromUpdate: false,
                            isAddMobile: false,
                            isFromSignUPLogin: isWhatsAppFlag,
                            countryCode:
                                countryCode != null ? countryCode : "+971",
                            a: widget.analytics,
                            o: widget.observer)));
              }
            } else if (result.status == "2") {
              print(result.status);
              hideLoader();
              CurrentUser _currentUser = new CurrentUser();
              _currentUser.userPhone = nPhone;
              // registration required
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignUpScreen(
                            phoneNumber: nPhone,
                            user: _currentUser,
                            loginCountryCode: countryCode,
                            loginSeletedFlag: countryCodeFlg,
                            countryCodeList: _countryCodeList,
                            a: widget.analytics,
                            o: widget.observer,
                          )));
            } else if (result.status == "3") {
              print(result.message);
              print("ABHIIIIIIIIIIII222222222>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
              _cPhone.text = "";

              userInactive = true;
              activateMessage = result.message;
              hideLoader();
              showActivateDialog();
              setState(() {});
            } else {
              print(result.message);
              print("ABHIIIIIIIIIIII33333333333>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
              hideLoader();
              boolNumberError = true;
              strNumberError = result.message.toString();
              setState(() {});
            }
          }
        });
      } else {
        print("ABHIIIIIIIIIIII4444444444444>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        print("nPhone");
        boolNumberError = true;
        strNumberError = global.strCheckInternet;
        setState(() {});
      }
    } catch (e) {
      hideLoader();

      boolNumberError = true;
      strNumberError = global.strWentWrong;
      setState(() {});
      print("Exception - login_screen.dart - login():" + e.toString());
    }
  }

//  _signInWithApple() async {
//   print("Firebase app name: ${Firebase.app().options.appId}");
//   try {
//     bool isConnected = await br!.checkConnectivity();
//     if (!isConnected) {
//       showNetworkErrorSnackBar(_scaffoldKey1!);
//       return;
//     }

//     showOnlyLoaderDialog();
//     final _firebaseAuth = FirebaseAuth.instance;

//     String generateNonce([int length = 32]) {
//       final charset =
//           '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
//       final random = Random.secure();
//       return List.generate(
//           length, (_) => charset[random.nextInt(charset.length)]).join();
//     }

//     String sha256ofString(String input) {
//       final bytes = utf8.encode(input);
//       final digest = sha256.convert(bytes);
//       return digest.toString();
//     }

//     final rawNonce = generateNonce();
//     final nonce = sha256ofString(rawNonce);

//     // ✅ Handle error properly and rethrow if needed
//     final credential = await SignInWithApple.getAppleIDCredential(
//   scopes: [
//     AppleIDAuthorizationScopes.email,
//     AppleIDAuthorizationScopes.fullName,
//   ],
//   nonce: nonce,
//   // webAuthenticationOptions: WebAuthenticationOptions(
//   //   clientId: 'com.byyu.signin', // 🔹 Your Apple Service ID
//   //   redirectUri: Uri.parse(
//   //     'https://byyu-a656a.firebaseapp.com/__/auth/handler', // 🔹 Your Firebase redirect
//   //   ),
//   // ),
// );
//     print('Raw nonce: $rawNonce');
//     print('Hashed nonce: $nonce');
//     print('Apple identity token: ${credential.identityToken}');

//     final oauthCredential = OAuthProvider("apple.com").credential(
//       idToken: credential.identityToken,
//       rawNonce: rawNonce,
//     );

//     final authResult = await _firebaseAuth
//         .signInWithCredential(oauthCredential)
//         .catchError((e) {

//       throw Exception("Firebase sign-in failed: $e");
//     });

//     // ✅ Hide loader after successful login

//     User? currentUser = authResult.user;
//     if (currentUser == null) throw Exception("User not found after sign-in");

//     hideLoader();
//     print("User: ${currentUser.displayName} | ${currentUser.email}");

//     apiCallForSocialMedia(
//       currentUser.displayName ?? "",
//       currentUser.email ?? "",
//     );
//   } catch (e) {
//     hideLoader();
//     print("Exception - login_screen.dart - _signinWithApple(): $e");
//   }
// }

  _signInWithApple() async {
    print("Firebase app name: ${Firebase.app().options.appId}");
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog();
        final _firebaseAuth = FirebaseAuth.instance;
        // String generateNonce([int length = 32]) {
        //   final charset =
        //       '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
        //   final random = Random.secure();
        //   return List.generate(
        //       length, (_) => charset[random.nextInt(charset.length)]).join();
        // }

        // String sha256ofString(String input) {
        //   final bytes = utf8.encode(input);
        //   final digest = sha256.convert(bytes);
        //   return digest.toString();
        // }
        String generateNonce([int length = 32]) {
          const charset =
              '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
          final random = Random.secure();
          return List.generate(
              length, (_) => charset[random.nextInt(charset.length)]).join();
        }

        String sha256ofString(String input) {
          final bytes = utf8.encode(input);
          final digest = sha256.convert(bytes);
          return digest.toString();
        }

        final rawNonce = generateNonce();
        final nonce = sha256ofString(rawNonce);

        final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: nonce,
          state: generateNonce(),
        ).catchError((e) {
          hideLoader();
        });
        print('Apple identity token: ${credential.identityToken}');

        final oauthCredential = OAuthProvider("apple.com").credential(
          idToken: credential.identityToken,
          rawNonce: rawNonce,
          accessToken: credential.authorizationCode,
        );
        print("rawNonce: $rawNonce");
        print("hashed nonce: $nonce");
        print("Apple returned token: ${credential.identityToken}");
        print("Recomputed hash: ${sha256ofString(rawNonce)}");
        final authResult = await _firebaseAuth
            .signInWithCredential(oauthCredential)
            .onError((error, stackTrace) {
          print("on error method ------- $error");
          throw Exception("Firebase sign-in failed: $error");
        }).catchError((e) {
          print(e);

          throw Exception("Firebase sign-in failed: $e");
        });
        User currentUser = FirebaseAuth.instance.currentUser!;
        print(" ${currentUser.displayName} ??? ${currentUser.email}");
        apiCallForSocialMedia(
            currentUser.displayName != null ? currentUser.displayName! : "",
            currentUser.email != null ? currentUser.email! : "");
      } else {
        showNetworkErrorSnackBar(_scaffoldKey1!);
      }
    } catch (e) {
      hideLoader();
      print(
          "Exception - login_screen.dart - _signinWithApple():" + e.toString());
    }
  }

  _googleBtnClick() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      print("credential ----${credential.toString()}");

      // Once signed in, return the UserCredential
      UserCredential? credential1 =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print("UserCredential ----${credential1.toString()}");
      // var isNewSer = credential1!.additionalUserInfo!.isNewUser;
      print(
          "profile ----isNewUser--->${credential1.additionalUserInfo!.isNewUser}");
      // if (credential1.additionalUserInfo!.isNewUser) {
      //   print("profile ----${credential1.additionalUserInfo!.isNewUser}");
      // }

      // var j = credential1.additionalUserInfo!.profile;
      // print("profile ----${j.toString()}");
      final _auth = FirebaseAuth.instance;
      var user = await _auth.currentUser;
      var userEmail = user!.email;
      var userName = user!.displayName;
      print("profile ----${userEmail.toString()} && ${user.displayName}");

      apiCallForSocialMedia(userName != null ? userName! : "",
          userEmail != null ? userEmail! : "");
    } catch (e) {
      print("error ----${e.toString()}");
    }
  }

  void apiCallForSocialMedia(String userName, String userEmail) async {
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog();
        global.currentUser = new CurrentUser();
        await apiHelper
            .socialLogin(userEmail: userEmail, userName: userName)
            .then((result) async {
          if (result != null) {
            if (result.status == "1") {
              List<CurrentUser> responseData = result.data;
              global.currentUser = responseData[0];
              SharedPreferences prefs = await SharedPreferences.getInstance();
              global.userProfileController.currentUser = global.currentUser;
              prefs.setString('currentUser', json.encode(result.data[0]));
              prefs.setString('userInfo', json.encode(result.data[0]));
              prefs.setBool(global.isLoggedIn, true);
              global.stayLoggedIN = true;
              prefs.setBool('ISSOCIALMEDIA', true);
              hideLoader();
              global.wishlistCount = 0;
              if (global.availableBiometrics.length > 0 &&
                  prefs.containsKey(global.quickLoginEnabled) &&
                  !prefs.getBool(quickLoginEnabled)!) {
                _verifyFingerDialog();
              } else if (global.availableBiometrics.length > 0 &&
                  !prefs.containsKey(global.quickLoginEnabled)) {
                if (global.availableBiometrics.length > 0) {
                  _verifyFingerDialog();
                }
              } else {
                if (global.userProfileController.currentUser.userPhone !=
                        null &&
                    global.userProfileController.currentUser.userPhone!.length >
                        0) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => HomeScreen(
                            a: widget.analytics,
                            o: widget.observer,
                            selectedIndex: 0,
                          )));
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UpdateMobileEmailScreen(
                          a: widget.analytics,
                          o: widget.observer,
                          throughSignUP: true,
                          socialSignedUserID: global
                              .userProfileController.currentUser.id
                              .toString(),
                          isPhoneChange: true)));
                }
              }
            } else {
              hideLoader();
              showSnackBarWithDuration(
                key: _scaffoldKey1,
                snackBarMessage: result.message.toString(),
              );
            }
          }
        });
      } else {
        print("nPhone");
        showNetworkErrorSnackBar(_scaffoldKey1!);
      }
    } catch (e) {
      hideLoader();
      print("Exception - login_screen.dart - login():" + e.toString());
    }
  }

  _verifyFingerDialog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(dialogBackgroundColor: Colors.white),
              child: CupertinoAlertDialog(
                title: Text(
                  '',
                ),
                content: Text(
                  'Would you like to register fingerprint for quick login?',
                  style: TextStyle(
                      fontSize: 14, fontFamily: global.fontMontserratLight),
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('NO',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: fontRailwayRegular,
                            fontWeight: FontWeight.w200,
                            color: ColorConstants.appColor)),
                    onPressed: () async {
                      prefs.setBool(global.quickLoginEnabled, false);
                      prefs.setBool(global.isLoggedIn, true);
                      global.stayLoggedIN = true;
                      Navigator.of(context).pop();
                      if (global.userProfileController.currentUser.userPhone !=
                              null &&
                          global.userProfileController.currentUser.userPhone!
                                  .length >
                              0) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomeScreen(
                                  a: widget.analytics,
                                  o: widget.observer,
                                  selectedIndex: 0,
                                )));
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UpdateMobileEmailScreen(
                                a: widget.analytics,
                                o: widget.observer,
                                throughSignUP: true,
                                socialSignedUserID: global
                                    .userProfileController.currentUser.id
                                    .toString(),
                                isPhoneChange: true)));
                      }
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text('YES',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: fontRailwayRegular,
                            fontWeight: FontWeight.w200,
                            color: Colors.blue)),
                    onPressed: () async {
                      prefs.setBool('quickLoginEnabled', true);
                      prefs.setBool("isLoggedIn", true);
                      global.stayLoggedIN = true;
                      Navigator.of(context).pop();
                      if (global.userProfileController.currentUser.userPhone !=
                          null) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomeScreen(
                                  a: widget.analytics,
                                  o: widget.observer,
                                  selectedIndex: 0,
                                )));
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UpdateMobileEmailScreen(
                                a: widget.analytics,
                                o: widget.observer,
                                throughSignUP: true,
                                socialSignedUserID: global
                                    .userProfileController.currentUser.id
                                    .toString(),
                                isPhoneChange: true)));
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

  void loginWithFacebook() async {
    print("Login facebook called");
  }

  void showActivateDialog() {
    try {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(dialogBackgroundColor: Colors.white),
              child: CupertinoAlertDialog(
                title: Text(
                  activateMessage,
                  style: TextStyle(
                    color: ColorConstants.newTextHeadingFooter,
                    fontSize: 16,
                    fontFamily: fontRailwayRegular,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(
                      'CANCEL',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontFamily: fontRailwayRegular,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text(
                      'OK',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: fontRailwayRegular,
                          fontWeight: FontWeight.w200,
                          color: Colors.blue),
                    ),
                    onPressed: () async {
                      activateAccount = 1;
                      userInactive = false;
                      Navigator.of(context).pop();
                      print(
                          "nikhil----------------------------${activateAccount}");
                      setState(() {});
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
}
