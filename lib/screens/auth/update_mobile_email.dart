import 'dart:convert';
import 'dart:io';

import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/CountryCodeList.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/screens/auth/otp_verification_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_picker/country_picker.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';
import 'package:material_text_fields/material_text_fields.dart';
import 'package:material_text_fields/theme/material_text_field_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/contactUsDropDown.dart';
import 'package:byyu/models/userModel.dart';
import 'package:byyu/screens/home_screen.dart';
import 'package:byyu/widgets/bottom_button.dart';
import 'package:byyu/widgets/my_text_field.dart';

class UpdateMobileEmailScreen extends BaseRoute {
  bool? isPhoneChange;
  bool? throughSignUP;
  String? socialSignedUserID = "";
  UpdateMobileEmailScreen(
      {a, o, this.isPhoneChange, this.throughSignUP, this.socialSignedUserID})
      : super(a: a, o: o, r: 'UpdateMobileEmailScreen');
  @override
  _UpdateMobileEmailScreenState createState() =>
      new _UpdateMobileEmailScreenState(this.isPhoneChange!,
          this.throughSignUP!, this.socialSignedUserID ?? "");
}

class _UpdateMobileEmailScreenState extends BaseRouteState {
  var _cPhone = new TextEditingController();
  var _cEmail = new TextEditingController();
  GlobalKey<ScaffoldState>? _scaffoldKey;
  var _fPhone = new FocusNode();
  var _fEmail = new FocusNode();
  bool _isDataLoaded = true;
  String? phoneNumber;
  String? countryCode;
  bool isPhoneChange;
  int _phonenumMaxLength = 9;
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();

  int _phonenumMaxLength1 = 0;
  String countryCodeSelected = "+971", countryCodeFlg = "🇦🇪";
  bool throughSignUP = false;
  String socialSignedUserID = "";
  _UpdateMobileEmailScreenState(
      this.isPhoneChange, this.throughSignUP, this.socialSignedUserID)
      : super();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      color: global.white,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: ColorConstants.appBrownFaintColor,
            leadingWidth: 46,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              throughSignUP ? "Add Mobile Number" : "UPDATE",
              style: TextStyle(
                fontFamily: fontMetropolisRegular,
                fontWeight: FontWeight.normal,
                color: ColorConstants.pureBlack,
              ), //textTheme.headline6,
            ),
            leading: !throughSignUP
                ? BackButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: ColorConstants.pureBlack,
                  )
                : SizedBox(),
            
          ),
          body: _isDataLoaded
              ? GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  child: Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/login_bg.png"),
                              fit: BoxFit.cover)),
                      child:
                          global.currentUser != null &&
                                  global.currentUser.id != null
                              ? Center(
                                  child: _isDataLoaded
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20, top: 60),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              !isPhoneChange
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                          color: ColorConstants
                                                              .white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(7)),
                                                      child: MaterialTextField(
                                                        style: TextStyle(
                                                            fontFamily: global
                                                                .fontMetropolisRegular,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w200,
                                                            color:
                                                                ColorConstants
                                                                    .pureBlack),
                                                        theme:
                                                            FilledOrOutlinedTextTheme(
                                                          radius: 8,
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 4,
                                                                  vertical: 4),
                                                          errorStyle:
                                                              const TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                          fillColor: Colors
                                                              .transparent,
                                                          enabledColor:
                                                              Colors.grey,
                                                          focusedColor:
                                                              ColorConstants
                                                                  .appColor,
                                                          floatingLabelStyle:
                                                              const TextStyle(
                                                                  color: ColorConstants
                                                                      .appColor),
                                                          width: 0.5,
                                                          labelStyle:
                                                              const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .grey),
                                                        ),
                                                        controller: _cEmail,
                                                        labelText: "Email",

                                                        keyboardType:
                                                            TextInputType
                                                                .emailAddress,
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        onChanged: (value) {
                                                          
                                                        },
                                                      ),
                                                    )
                                                  : Container(),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              isPhoneChange
                                                  ? Container(
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  showCountryPicker(
                                                                    countryListTheme: CountryListThemeData(
                                                                        inputDecoration: InputDecoration(
                                                                            hintText: "",
                                                                            label: Text(
                                                                              "Search",
                                                                              style: TextStyle(fontSize: 16, fontFamily: fontMetropolisRegular, color: ColorConstants.appColor),
                                                                            )),
                                                                        searchTextStyle: TextStyle(color: ColorConstants.pureBlack),
                                                                        textStyle: TextStyle(fontFamily: fontMetropolisRegular, fontWeight: FontWeight.w200, fontSize: 16, color: ColorConstants.pureBlack, letterSpacing: 1)),
                                                                    context:
                                                                        context,

                                                                    showPhoneCode:
                                                                        true, // optional. Shows phone code before the country name.
                                                                    onSelect:
                                                                        (Country
                                                                            country) {
                                                                      _cPhone.text =
                                                                          "";
                                                                      print(
                                                                          'Select country: ${country.displayName} & ${country.countryCode} & ${country.flagEmoji}');
                                                                      countryCode =
                                                                          country
                                                                              .phoneCode;
                                                                      countryCodeFlg =
                                                                          "${country.flagEmoji}";
                                                                      countryCodeSelected =
                                                                          country
                                                                              .phoneCode;
                                                                      _phonenumMaxLength1 = country
                                                                          .example
                                                                          .length;
                                                                      setState(
                                                                          () {});
                                                                    },
                                                                  );
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 40,
                                                                  width: 125,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          border: Border
                                                                              .all(
                                                                            color:
                                                                                Colors.grey.shade300,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(7.0))),
                                                                  child:
                                                                      Padding(
                                                                          padding: const EdgeInsets
                                                                              .fromLTRB(
                                                                              5,
                                                                              1,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text(countryCodeFlg, style: TextStyle(fontFamily: fontMontserratMedium, fontWeight: FontWeight.bold, fontSize: 25, color: ColorConstants.pureBlack, letterSpacing: 1)),
                                                                              Expanded(child: Text(countryCodeSelected.contains("+") ? countryCodeSelected : "+${countryCodeSelected}", style: TextStyle(fontFamily: fontMetropolisRegular, fontWeight: FontWeight.w200, fontSize: 16, color: ColorConstants.pureBlack, letterSpacing: 1))),
                                                                              Icon(
                                                                                Icons.arrow_drop_down,
                                                                                size: 30,
                                                                                color: global.bgCompletedColor,
                                                                              )
                                                                            ],
                                                                          )),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  height: 40,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(0.0))),
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              8,
                                                                          right:
                                                                              1,
                                                                          top:
                                                                              10,
                                                                          bottom:
                                                                              10),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(),
                                                                  child:
                                                                      TextFormField(
                                                                    inputFormatters: <TextInputFormatter>[
                                                                      FilteringTextInputFormatter
                                                                          .digitsOnly
                                                                    ],
                                                                    key: Key(
                                                                        '1'),
                                                                    cursorColor:
                                                                        Colors
                                                                            .black,
                                                                    controller:
                                                                        _cPhone,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontFamily:
                                                                            fontMetropolisRegular,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w200,
                                                                        color: ColorConstants
                                                                            .pureBlack,
                                                                        letterSpacing:
                                                                            1),
                                                                    keyboardType: TextInputType.numberWithOptions(
                                                                        signed:
                                                                            false,
                                                                        decimal:
                                                                            false),
                                                                    maxLength:
                                                                        _phonenumMaxLength1 ==
                                                                                0
                                                                            ? 9
                                                                            : _phonenumMaxLength1,
                                                                    focusNode:
                                                                        _fPhone,
                                                                    onFieldSubmitted:
                                                                        (val) {
                                                                      FocusScope.of(
                                                                              context)
                                                                          .requestFocus(
                                                                              _fPhone);
                                                                    },
                                                                    obscuringCharacter:
                                                                        '*',
                                                                    decoration: InputDecoration(
                                                                        counterText: "",
                                                                        border: OutlineInputBorder(),
                                                                        labelStyle: TextStyle(color: _fPhone == true ? ColorConstants.appColor : ColorConstants.grey),
                                                                        labelText: "Enter Mobile Number",
                                                                        focusedBorder: OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(7),
                                                                          borderSide: BorderSide(
                                                                              color: Colors.grey.shade400,
                                                                              width: 0.0),
                                                                        ),
                                                                        enabledBorder: OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(7),
                                                                          borderSide: BorderSide(
                                                                              color: Colors.grey.shade400,
                                                                              width: 0.0),
                                                                        ),
                                                                        hintText: '561234567',
                                                                        hintStyle: TextStyle(fontFamily: fontMetropolisRegular, fontSize: 14) 
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Visibility(
                                                            visible: countryCodeSelected ==
                                                                        "971" ||
                                                                    countryCodeSelected ==
                                                                        "+971"
                                                                ? false
                                                                : true,
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 2),
                                                              child: Text(
                                                                "All communication outside the UAE is exclusively done through WhatsApp.",
                                                                style: TextStyle(
                                                                    color: ColorConstants
                                                                        .appColor,
                                                                    fontSize:
                                                                        11,
                                                                    fontFamily:
                                                                        global
                                                                            .fontMetropolisRegular,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w200),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Container(),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Align(
                                                alignment: Alignment.center,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: BottomButton(
                                                      key: UniqueKey(),
                                                      child: Text(
                                                        throughSignUP!
                                                            ? "Add Mobile Number"
                                                            : "UPDATE",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                fontMetropolisRegular,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 14,
                                                            color: global.white,
                                                            letterSpacing: 1),
                                                      ),
                                                      loadingState: false,
                                                      disabledState: false,
                                                      onPressed: () {
                                                        if (throughSignUP!) {
                                                          _addMobile();
                                                        } else {
                                                          _save();
                                                        }

                                                      }),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              throughSignUP!
                                                  ? InkWell(
                                                      onTap: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        HomeScreen(
                                                                          a: widget
                                                                              .analytics,
                                                                          o: widget
                                                                              .observer,
                                                                          selectedIndex:
                                                                              0,
                                                                        )));
                                                      },
                                                      child: Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: Text(
                                                            "Skip",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontFamily:
                                                                  fontMetropolisRegular,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  ColorConstants
                                                                      .appColor,
                                                            ),
                                                          )),
                                                    )
                                                  : SizedBox()
                                            ],
                                          ),
                                        )
                                      : _shimmerList(),
                                )
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  child: Center(
                                    child: Text(
                                      global.pleaseLogin,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily:
                                              global.fontMontserratLight,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w200,
                                          color: ColorConstants.grey),
                                    ),
                                  ),
                                )),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
          
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    _isDataLoaded = true;
    if (isPhoneChange && !throughSignUP!) {
      if (global.currentUser != null && global.currentUser.userPhone != null) {
        _cPhone.text = global.currentUser.userPhone!;
      }
      if (_cPhone.text != null && _cPhone.text.length > 0) {
        _phonenumMaxLength1 = _cPhone.text.length;
      }
      if (global.currentUser.countryCode != null &&
          global.currentUser.countryCode!.length > 0) {
        countryCodeSelected = global.currentUser.countryCode!;
        countryCode = global.currentUser.countryCode!;
      } else {
        countryCodeSelected = "+971";
        countryCode = "+971";
      }
      if (global.currentUser.flagCode != null &&
          global.currentUser.flagCode!.length > 0) {
        countryCodeFlg = global.currentUser.flagCode!;
      } else {
        countryCodeFlg = "🇦🇪";
      }
    } else {
      if (global.currentUser.email != null) {
        _cEmail.text = global.currentUser.email!;
      }
    }
  }

  _save() async {
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        if (isPhoneChange) {
          if (isPhoneChange && _cPhone.text.isEmpty) {
            showSnackBar(
              key: _scaffoldKey,
              snackBarMessage:
                  "Please enter mobile number",
            );
          } else if (_cPhone.text.isNotEmpty &&
              _phonenumMaxLength1 == 0 &&
              _cPhone.text.length < 9) {
            showSnackBar(
              key: _scaffoldKey,
              snackBarMessage:
                  "Please enter valid mobile number",
            );
          } else if (_phonenumMaxLength1 > 0 &&
              _cPhone.text.length < _phonenumMaxLength1) {
            showSnackBar(
              key: _scaffoldKey,
              snackBarMessage:
                  "Please enter valid mobile number",
            );
          } else if (global.currentUser != null &&
              _cPhone.text != global.currentUser.userPhone) {
            showOnlyLoaderDialog();

            await apiHelper
                .updateMobileEmail("mobileno", _cPhone.text,
                    countryCodeSelected, countryCodeFlg)
                .then((result) async {
              if (result != null) {
                if (result.status == "1") {
                  print(result.data.toString());
                  UpdateMobileEmailMobel data = result.data;
                  hideLoader();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OtpVerificationScreen(
                              isPhoneChange: 1,
                              updateMobEmailResponse: data,
                              phoneNumber: _cPhone.text,
                              isAddMobile: false,
                              countryCode: countryCodeSelected != null
                                  ? countryCodeSelected
                                  : "971",
                              isFromUpdate: true,
                              isFromSignUPLogin: false,
                              a: widget.analytics,
                              o: widget.observer)));
                } else {
                  hideLoader();
                  showSnackBar(
                      key: _scaffoldKey,
                      snackBarMessage: result.message.toString());
                }
              }
            });
          }
        } else {
          print("Nikhilllll");
          if (_cEmail.text.isNotEmpty &&
              global.currentUser != null &&
              _cEmail.text != global.currentUser.email) {
            showOnlyLoaderDialog();

            await apiHelper
                .updateMobileEmail(
                    "email",
                    _cEmail.text,
                    global.currentUser.countryCode!,
                    global.currentUser.flagCode!)
                .then((result) async {
              if (result != null) {
                if (result.status == "1") {
                  hideLoader();
                  print("nikhil update email status 1");
                  UpdateMobileEmailMobel data = result.data;
                  print("nikhil update email status 1");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OtpVerificationScreen(
                              phoneNumber: _cPhone.text,
                              isPhoneChange: 0,
                              isFromUpdate: true,
                              updateMobEmailResponse: data,
                              isAddMobile: false,
                              isFromSignUPLogin: false,
                              countryCode:
                                  countryCode != null ? countryCode : "+971",
                              a: widget.analytics,
                              o: widget.observer)));
                } else {
                  hideLoader();
                  showSnackBar(
                      key: _scaffoldKey,
                      snackBarMessage: result.message.toString());
                }
              }
            });
          } else if (!isPhoneChange && _cEmail.text.isEmpty) {
            showSnackBar(
                key: _scaffoldKey, snackBarMessage: "Please enter your email");
          } else if (_cEmail.text.isNotEmpty &&
              !EmailValidator.validate(_cEmail.text)) {
            showSnackBar(
                key: _scaffoldKey,
                snackBarMessage: "Please enter your valid email");
          }
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey!);
      }
    } catch (e) {
      print("Exception - profile_edit_screen.dart - _save()c:" + e.toString());
    }
  }

  _addMobile() async {
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        if (isPhoneChange && _cPhone.text.isEmpty) {
          showSnackBar(
            key: _scaffoldKey,
            snackBarMessage:
                "Please enter mobile number",
          );
        } else if (_cPhone.text.isNotEmpty &&
            _phonenumMaxLength1 == 0 &&
            _cPhone.text.length < 9) {
          showSnackBar(
            key: _scaffoldKey,
            snackBarMessage:
                "Please enter valid mobile number",
          );
        } else if (_phonenumMaxLength1 > 0 &&
            _cPhone.text.length < _phonenumMaxLength1) {
          showSnackBar(
            key: _scaffoldKey,
            snackBarMessage:
                "Please enter valid mobile number",
          );
        } else if (global.currentUser != null &&
            _cPhone.text != global.currentUser.userPhone) {
          showOnlyLoaderDialog();

          await apiHelper
              .addMobileNumberSocialMedia(socialSignedUserID, _cPhone.text,
                  countryCodeSelected, countryCodeFlg)
              .then((result) async {
            if (result != null) {
              if (result.status == "1") {
                print(result.data.toString());
                hideLoader();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OtpVerificationScreen(
                            isPhoneChange: 1,
                            socialSignedUserID: socialSignedUserID,
                            phoneNumber: _cPhone.text,
                            countryCode:
                                countryCode != null ? countryCode : "971",
                            isFromUpdate: false,
                            isFromSignUPLogin: false,
                            isAddMobile: true,
                            a: widget.analytics,
                            o: widget.observer)));
              } else {
                hideLoader();
                showSnackBar(
                    key: _scaffoldKey,
                    snackBarMessage: result.message.toString());
              }
            }
          });
        }
      }
    } catch (e) {
      print("Exception - profile_edit_screen.dart - _save()d:" + e.toString());
    }
  }

  Widget _shimmerList() {
    try {
      return ListView.builder(
        itemCount: 5,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(top: 10, left: 16, right: 16),
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
                    height: 20,
                    width: MediaQuery.of(context).size.width / 2,
                    child: Card(),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 52,
                    width: MediaQuery.of(context).size.width,
                    child: Card(),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      print("Exception - productDetailScreen.dart - _shimmerList():" +
          e.toString());
      return SizedBox();
    }
  }
}
