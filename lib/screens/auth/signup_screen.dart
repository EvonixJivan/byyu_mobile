import 'dart:core';
import 'dart:io';

import 'package:byyu/screens/home_screen.dart';

import 'package:country_picker/country_picker.dart';

import 'package:email_validator/email_validator.dart';
import 'package:facebook_app_events/facebook_app_events.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:material_text_fields/material_text_fields.dart';
import 'package:material_text_fields/theme/material_text_field_theme.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/CountryCodeList.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/businessLayer/global.dart';

import 'package:byyu/models/userModel.dart';

import 'package:byyu/screens/auth/otp_verification_screen.dart';
import 'package:byyu/utils/navigation_utils.dart';

import 'package:byyu/widgets/bottom_button.dart';

import 'package:byyu/screens/aboutUsAndTermsOfServices.dart';

final _formKeyM = GlobalKey<FormState>();

void _submitForm() {
  if (_formKeyM.currentState!.validate()) {}
}

final _formSignUPKey = GlobalKey<FormState>();

class SignUpScreen extends BaseRoute {
  final CurrentUser? user;
  final int? loginType;
  final String? loginCountryCode;
  final String? phoneNumber;
  final String? prefixCode;
  final String? loginSeletedFlag;
  final int? loginMaxPhoneLength;
  final String? refferCode;

  List<CountryCodeList>? countryCodeList;

  SignUpScreen({
    a,
    o,
    this.user,
    this.loginType,
    this.loginCountryCode,
    this.prefixCode,
    this.phoneNumber,
    this.countryCodeList,
    this.loginSeletedFlag,
    this.loginMaxPhoneLength,
    this.refferCode,
  }) : super(a: a, o: o, r: 'SignUpScreen');

  @override
  _SignUpScreenState createState() => _SignUpScreenState(
        user: user,
        logintype: loginType,
        loginCountryCode: loginCountryCode,
        prefixCode: prefixCode,
        phoneNumber: phoneNumber,
        loginSeletedFlag: loginSeletedFlag,
        countryCodeList: countryCodeList,
        loginMaxPhoneLength: loginMaxPhoneLength,
        refferCode: refferCode,
      );
}

class _SignUpScreenState extends BaseRouteState {
  CurrentUser? user;
  TextEditingController _cName = new TextEditingController();
  TextEditingController _cReferralCode = new TextEditingController();
  FocusNode _fName = new FocusNode();

  TextEditingController _cPhoneNumber = new TextEditingController();
  TextEditingController _cEmail = new TextEditingController();

  TextEditingController _cReferral = new TextEditingController();

  TextEditingController _cPhone = new TextEditingController();

  TextEditingController dateinput = TextEditingController();

  var checkedValue = false;
  int privacyChecked = 0, whatsAppChecked = 0;
  var checkedValue1 = false;

  FocusNode _fLandmark = new FocusNode();
  int? logintype;
  FocusNode _fPhoneNumber = new FocusNode();
  FocusNode _fPhone = new FocusNode();
  FocusNode _fEmail = new FocusNode();

  FocusNode _fReferral = new FocusNode();

  String countryCode = "+971";
  int _phonenumMaxLength = 9;
  String? prefixCode;
  String? dropdownValuestate;
  String? dropdownValueCode;
  List<CountryCodeList>? countryCodeList;

  final String? phoneNumber;
  String gender = "";
  bool isMale = false, isFemale = false;
  DateTime _selectedDate = DateTime(
      DateTime.now().year - 18, DateTime.now().month, DateTime.now().day - 1);

  double? latSelected, lngSelected;
  GlobalKey<ScaffoldState>? _scaffoldKey;
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();

  int _phonenumMaxLength1 = 0;
  String? countryCodeSelected, countryCodeFlg = "🇦🇪";
  int? loginMaxPhoneLength;
  String? loginCountryCode;
  String? loginSeletedFlag;
  String? refferCode;
  bool signUpClicked = false;
  bool mobileValid = true;

  _SignUpScreenState({
    this.user,
    this.logintype,
    this.loginCountryCode,
    this.prefixCode,
    this.phoneNumber,
    this.loginSeletedFlag,
    this.countryCodeList,
    this.loginMaxPhoneLength,
    this.refferCode,
  });
  SharedPreferences? prefs;

  String? validateEmail(String? email) {
    RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,3}$');
    final isEmailValid = emailRegex.hasMatch(email ?? '');
    if (!isEmailValid) {
      return 'Please enter a valid email';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 46,
        backgroundColor: ColorConstants.appBrownFaintColor,
        title: Text("Sign Up",
            style: TextStyle(
              fontFamily: fontMetropolisRegular,
              color: ColorConstants.pureBlack,
              fontWeight: FontWeight.w200,
            )),
        centerTitle: true,
        leading: BackButton(
            onPressed: () {
              if (refferCode == "referHome") {
                global.refferalCode = "";
                print("G1---->");
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomeScreen(
                          a: widget.analytics,
                          o: widget.observer,
                          selectedIndex: 0,
                        )));
              } else {
                Navigator.of(context).pop();
              }
            },
            color: ColorConstants.pureBlack),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        top: false,
        bottom: true,
        child: Form(
          key: _formSignUPKey,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/login_bg.png"),
                          fit: BoxFit.cover)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 10),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "Create an Account",
                            style: TextStyle(
                                fontFamily: fontMetropolisRegular,
                                color: ColorConstants.pureBlack,
                                fontWeight: FontWeight.w200,
                                fontSize: 18,
                                letterSpacing: 1),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: ColorConstants.white,
                            borderRadius: BorderRadius.all(Radius.circular(7.0))),
                        margin: EdgeInsets.only(top: 0, left: 20, right: 20),
                        padding: EdgeInsets.only(),
                        child: MaterialTextField(
                          style: TextStyle(
                              fontFamily: global.fontMetropolisRegular,
                              fontSize: 16,
                              fontWeight: FontWeight.w200,
                              color: ColorConstants.pureBlack),
                          theme: FilledOrOutlinedTextTheme(
                            radius: 8,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 4),
                            errorStyle: const TextStyle(
                                fontSize: 10,
                                fontFamily: global.fontMetropolisRegular,
                                fontWeight: FontWeight.w200),
                            fillColor: Colors.transparent,
                            enabledColor: Colors.grey,
                            focusedColor: ColorConstants.appColor,
                            floatingLabelStyle:
                                const TextStyle(color: ColorConstants.appColor),
                            width: 0.5,
                            labelStyle:
                                const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          controller: _cName,
                          labelText: "Full Name*",
                          keyboardType: TextInputType.name,
                          onChanged: (val) {
                            if (signUpClicked &&
                                _formSignUPKey.currentState!.validate()) {
                              print("Submit Data");
                            }
                          },
                          validator: (value) {
                            print(value);
                            if (value == null || value.isEmpty) {
                              return "Please enter your Full Name  ";
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
                            borderRadius: BorderRadius.circular(7)),
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: MaterialTextField(
                          style: TextStyle(
                              fontFamily: global.fontMetropolisRegular,
                              fontSize: 16,
                              fontWeight: FontWeight.w200,
                              color: ColorConstants.pureBlack),
                          theme: FilledOrOutlinedTextTheme(
                            radius: 8,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 4),
                            errorStyle: const TextStyle(
                                fontSize: 10,
                                fontFamily: global.fontMetropolisRegular,
                                fontWeight: FontWeight.w200),
                            fillColor: Colors.transparent,
                            enabledColor: Colors.grey,
                            focusedColor: ColorConstants.appColor,
                            floatingLabelStyle:
                                const TextStyle(color: ColorConstants.appColor),
                            width: 0.5,
                            labelStyle:
                                const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          controller: _cEmail,
                          labelText: "Email*",
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (val) {
                            if (signUpClicked &&
                                _formSignUPKey.currentState!.validate()) {
                              print("Submit Data");
                            }
                          },
                          validator: (value) {
                            print("this is value ${value}");
                            if (value == null || value.isEmpty) {
                              return "Please enter your Email";
                            } else if (!EmailValidator.validate(value)) {
                              return "Please enter valid Email";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                     
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                showCountryPicker(
                                  countryListTheme: CountryListThemeData(
                                      inputDecoration: InputDecoration(
                                          hintText: "",
                                          label: Text(
                                            "Search",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: fontMetropolisRegular,
                                                color: ColorConstants.appColor),
                                          )),
                                      searchTextStyle: TextStyle(
                                          color: ColorConstants.pureBlack),
                                      textStyle: TextStyle(
                                          fontFamily: fontMetropolisRegular,
                                          fontWeight: FontWeight.w200,
                                          fontSize: 16,
                                          color: ColorConstants.pureBlack,
                                          letterSpacing: 1)),
                                  context: context,
                                  showPhoneCode:
                                      true, // optional. Shows phone code before the country name.
                                  onSelect: (Country country) {
                                    print(
                                        'Select country: ${country.displayName} & ${country.countryCode} & ${country.flagEmoji}');
                                    countryCode = country.phoneCode;
                                    countryCodeFlg = "${country.flagEmoji}";
                                    countryCodeSelected = country.phoneCode;
                                    _phonenumMaxLength1 = country.example.length;
                                    if (countryCode != "971" ||
                                        countryCode != "+971") {
                                      checkedValue1 = true;
                                    }
                                    setState(() {
                                      _cPhone.text = "";
                                    });
                                  },
                                );
                              },
                              child: Container(
                                height: 40,
                                width: 125,
                                margin:
                                    EdgeInsets.only(bottom: mobileValid ? 0 : 20),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7.0))),
                                child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 1, 0, 0),
                                    child: Row(
                                      children: [
                                        Text(countryCodeFlg!,
                                            style: TextStyle(
                                                fontFamily: fontMontserratMedium,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                                color: ColorConstants.pureBlack,
                                                letterSpacing: 1)),
                                        Expanded(
                                            child: Text(countryCodeSelected!,
                                                style: TextStyle(
                                                    fontFamily:
                                                        fontMetropolisRegular,
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 16,
                                                    color:
                                                        ColorConstants.pureBlack,
                                                    letterSpacing: 1))),
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
                              child: Container(
                                height: mobileValid ? 40 : 60,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(0.0))),
                                margin: EdgeInsets.only(
                                    left: 8, right: 1, top: 10, bottom: 10),
                                padding: EdgeInsets.only(),
                                child: TextFormField(
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  key: Key('1'),
                                  cursorColor: Colors.black,
                                  controller: _cPhone,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: fontMetropolisRegular,
                                      fontWeight: FontWeight.w200,
                                      color: ColorConstants.pureBlack,
                                      letterSpacing: 1),
                                  keyboardType: TextInputType.phone,
                                  maxLength: _phonenumMaxLength1 == 0
                                      ? 9
                                      : _phonenumMaxLength1,
                                  focusNode: _fPhone,
                                  onFieldSubmitted: (val) {
                                    FocusScope.of(context).requestFocus(_fPhone);
                                  },
                                  obscuringCharacter: '*',
                                  decoration: InputDecoration(
                                      counterText: "",
                                      border: OutlineInputBorder(),
                                      labelStyle: TextStyle(
                                          fontSize: 17,
                                          fontFamily: fontMetropolisRegular,
                                          fontWeight: FontWeight.w200,
                                          color: _cPhone.text.length > 0
                                              ? ColorConstants.appColor
                                              : ColorConstants.grey),
                                      labelText: "Mobile Number*",
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(7),
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade400,
                                            width: 0.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(7),
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade400,
                                            width: 0.0),
                                      ),
                                      hintText: '561234567',
                                      errorStyle: const TextStyle(
                                          fontSize: 10,
                                          fontFamily:
                                              global.fontMetropolisRegular,
                                          fontWeight: FontWeight.w200),
                                      hintStyle: TextStyle(
                                          fontFamily: fontMetropolisRegular,
                                          fontSize:
                                              14) 
                                      ),
                                  onChanged: (val) {
                                    if (signUpClicked &&
                                        _formSignUPKey.currentState!
                                            .validate()) {}
                                  },
                                  validator: (value) {
                                    print(value);
                                    if (value == null || value.isEmpty) {
                                      mobileValid = false;
                                      setState(() {});
                                      return "Please enter your mobile number";
                                    } else if (_cPhone.text.isNotEmpty &&
                                        _phonenumMaxLength1 == 0 &&
                                        _cPhone.text.length < 9) {
                                      mobileValid = false;
                                      setState(() {});
                                      return "Please enter valid mobile number";
                                    } else if (_phonenumMaxLength1 > 0 &&
                                        _cPhone.text.length <
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
                      SizedBox(
                        height: 8,
                      ),
                      Visibility(
                        visible: countryCodeSelected == "971" ||
                                countryCodeSelected == "+971"
                            ? false
                            : true,
                        child: Padding(
                          padding: EdgeInsets.only(left: 25, right: 15),
                          child: Text(
                            "All communication outside the UAE is exclusively done through WhatsApp.",
                            style: TextStyle(
                                fontSize: 11,
                                color: ColorConstants.appColor,
                                fontFamily: global.fontMetropolisRegular,
                                fontWeight: FontWeight.w200),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RichText(
                              text: const TextSpan(
                                  text: 'Date of Birth',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w200,
                                      fontFamily: fontMetropolisRegular,
                                      color: ColorConstants.pureBlack,
                                      fontSize: 16),
                                  children: const <TextSpan>[
                                    TextSpan(
                                        text: '',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w200,
                                            fontFamily: fontMetropolisRegular,
                                            fontSize: 16,
                                            color: ColorConstants.appColor)),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(
                                  color: Colors.grey.shade400, width: 0.0)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 1),
                            child: Container(
                              child: DatePickerWidget(
                                initialDate: DateTime(DateTime.now().year - 18,
                                    DateTime.now().month, DateTime.now().day - 1),
                                looping: false, // default is not looping
                                lastDate: DateTime(
                                    DateTime.now().year - 18,
                                    DateTime.now().month,
                                    DateTime.now().day - 1), 
                                dateFormat:
                                    "dd/MMMM/yyyy",
                                locale: DatePicker.localeFromString('en'),
                                onChange: (DateTime newDate, _) {
                                  setState(() {
                                    _selectedDate = newDate;
                                    print("Selected Date-----${_selectedDate}");
                                  });
                                  print(_selectedDate);
                                },
                                pickerTheme: DateTimePickerTheme(
                                  backgroundColor: Colors.transparent,
                                  itemTextStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: global.fontMetropolisRegular,
                                      fontWeight: FontWeight.w200),
                                  dividerColor: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(left: 25, right: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            
                            Container(
                              decoration: BoxDecoration(
                                  color: isMale
                                      ? ColorConstants.appColor
                                      : ColorConstants.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isMale
                                        ? ColorConstants.appColor
                                        : ColorConstants.pureBlack,
                                  )),
                              padding: EdgeInsets.only(
                                  left: 6, right: 6, bottom: 5, top: 5),
                              width: MediaQuery.of(context).size.width / 3.2,
                              child: InkWell(
                                onTap: () {
                                  gender = "male";
                                  isMale = true;
                                  isFemale = false;
                                  setState(() {});
                                },
                                child: Image.asset(
                                  "assets/images/male_icon.png",
                                  height: Platform.isIOS ? 30 : 30,
                                  width: Platform.isIOS ? 30 : 30,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: isFemale
                                      ? ColorConstants.appColor
                                      : ColorConstants.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isFemale
                                        ? ColorConstants.appColor
                                        : ColorConstants.pureBlack,
                                  )),
                              padding: EdgeInsets.only(
                                  left: 6, right: 6, bottom: 5, top: 5),
                              width: MediaQuery.of(context).size.width / 3.2,
                              child: InkWell(
                                onTap: () {
                                  gender = "female";
                                  isFemale = true;
                                  isMale = false;
                                  setState(() {});
                                },
                                child: Image.asset(
                                  "assets/images/female_icon.png",
                                  height: Platform.isIOS ? 30 : 30,
                                  width: Platform.isIOS ? 30 : 30,
                                ),
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: ColorConstants.white,
                            borderRadius: BorderRadius.all(Radius.circular(7.0))),
                        margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                        padding: EdgeInsets.only(),
                        child: MaterialTextField(
                          style: TextStyle(
                              fontFamily: global.fontMetropolisRegular,
                              fontSize: 16,
                              fontWeight: FontWeight.w200,
                              color: ColorConstants.pureBlack),
                          theme: FilledOrOutlinedTextTheme(
                            radius: 8,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 4),
                            errorStyle: const TextStyle(
                                fontSize: 10,
                                fontFamily: global.fontMetropolisRegular,
                                fontWeight: FontWeight.w200),
                            fillColor: Colors.transparent,
                            enabledColor: Colors.grey,
                            focusedColor: ColorConstants.appColor,
                            floatingLabelStyle:
                                const TextStyle(color: ColorConstants.appColor),
                            width: 0.5,
                            labelStyle:
                                const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          controller: _cReferralCode,
                          labelText: "Referral code",
                          keyboardType: TextInputType.name,
                          onChanged: (p0) {
                          },
                        ),
                      ),
        
                      Container(
                        height: 30,
                        margin: EdgeInsets.only(bottom: 8),
                        child: CheckboxListTile(
                          activeColor: ColorConstants.appColor,
                          title: Transform.translate(
                            offset: const Offset(-10, 0),
                            child: Row(
                              children: [
                                Text("I agree to the ",
                                    style: TextStyle(
                                      color: ColorConstants.pureBlack,
                                      fontSize: 13,
                                      fontFamily: fontMetropolisRegular,
                                      fontWeight: FontWeight.normal,
                                    )),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AboutUsAndTermsOfServiceScreen(
                                                true,
                                                a: widget.analytics,
                                                o: widget.observer,
                                              )),
                                    );
                                  },
                                  child: Text("Privacy Policy",
                                      style: TextStyle(
                                        color: ColorConstants.appColor,
                                        fontSize: 14,
                                        fontFamily: fontMetropolisRegular,
                                        fontWeight: FontWeight.w400,
                                      )),
                                ),
                              ],
                            ),
                          ),
                          value: checkedValue,
                          onChanged: (newValue) {
                            checkedValue = newValue!;
                            if (newValue) {
                              privacyChecked = 1;
                            } else {
                              privacyChecked = 0;
                            }
                            setState(() {});
                          },
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        ),
                      ),
                      Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(bottom: 8),
                        child: CheckboxListTile(
                          activeColor: ColorConstants.appColor,
                          title: Transform.translate(
                            offset: const Offset(-10, 0),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                      "I want to receive notifications on ",
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: ColorConstants.pureBlack,
                                        fontSize: 12,
                                        fontFamily: fontMetropolisRegular,
                                        fontWeight: FontWeight.normal,
                                      )),
                                  Text("WhatsApp",
                                      style: TextStyle(
                                        color: ColorConstants.appColor,
                                        fontSize: 14,
                                        fontFamily: fontMetropolisRegular,
                                        fontWeight: FontWeight.w400,
                                      )),
                                ],
                              ),
                            ),
                          ),
        
                          value: checkedValue1,
                          onChanged: (newValue) {
                            print(countryCodeSelected);
                            if (countryCodeSelected == "+971" ||
                                countryCodeSelected == "971") {
                              _showNotifyDialog(newValue!);
                            } else {
                              _showNotifyDialog(true);
                            }
        
                            if (checkedValue1) {
                              whatsAppChecked = 1;
                            } else {
                              whatsAppChecked = 0;
                            }
        
                            setState(() {});
                          },
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        ),
                      ),
                      Padding(
                        padding:
                             EdgeInsets.only(left: 13, right: 13, top: 15 ,bottom: MediaQuery.of(context).viewInsets.bottom > 0
                          ? MediaQuery.of(context).viewInsets.bottom
                          : MediaQuery.of(context).padding.bottom > 0
                              ? MediaQuery.of(context).padding.bottom
                              : 10,),
                        child: Container(
                          height: 40,
                          width: (MediaQuery.of(context).size.width / 2) - 40,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: ColorConstants.appColor, width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          child: BottomButton(
                            color: ColorConstants.appColor,
                            child: Text(
                              "SIGN UP",
                              style: TextStyle(
                                  fontFamily: fontMontserratMedium,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: ColorConstants.white,
                                  letterSpacing: 1),
                            ),
                            loadingState: false,
                            disabledState: true,
                            onPressed: () {
                              print("Sign up ============on pressed");
                              signUpClicked = true;
                              if (_formSignUPKey.currentState!.validate() &&
                                  checkedValue) {
                                _onSignUp();
                              } else {
                                if (!checkedValue) {
                                  showSnackBar(
                                      key: _scaffoldKey,
                                      snackBarMessage:
                                          "Please select the privacy policy"
                                      );
                                }
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _showNotifyDialog(bool updateValue) {
    try {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(dialogBackgroundColor: Colors.white),
              child: CupertinoAlertDialog(
                
                content: Text(
                  updateValue
                      ? (countryCode == "971" || countryCode == "+971")
                          ? 'You will receive further communication via whatsapp. Please confirm'
                          : 'All communication outside the UAE is exclusively done through WhatsApp.'
                      : 'You will receive further communication via sms. Please confirm',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: fontMetropolisRegular,
                      fontWeight: FontWeight.w200,
                      color: ColorConstants.pureBlack),
                ),
                actions: countryCode == "971" || countryCode == "+971"
                    ? <Widget>[
                        CupertinoDialogAction(
                          child: Text(
                            countryCode == "971" || countryCode == "+971"
                                ? 'Cancel'
                                : "OK",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: fontMetropolisRegular,
                                fontWeight: FontWeight.w200,
                                color: ColorConstants.appColor),
                          ),
                          onPressed: () {
                            if (countryCode == "971" || countryCode == "+971") {
                              checkedValue1 = updateValue;
                            }
                            return Navigator.of(context).pop();
                          },
                        ),
                        CupertinoDialogAction(
                          child: Text(
                            'Yes',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: fontMetropolisRegular,
                                fontWeight: FontWeight.w200,
                                color: Colors.blue),
                          ),
                          onPressed: () async {
                            // checkedValue1 = true;
                            if (countryCode == "971" || countryCode == "+971") {
                              checkedValue1 = updateValue;
                            } else {
                              checkedValue1 = true;
                            }
                            return Navigator.of(context).pop();
                          },
                        ),
                      ]
                    : [
                        CupertinoDialogAction(
                          child: Text(
                            "OK",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: fontMetropolisRegular,
                                fontWeight: FontWeight.w200,
                                color: ColorConstants.appColor),
                          ),
                          onPressed: () {
                            checkedValue1 = true;
                            // checkedValue1 = false;
                            return Navigator.of(context).pop();
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
    super.initState();
    // showSnackBar(key: _scaffoldKey, snackBarMessage: '${phoneNumber}');

    print("This is the Reffer Code from deep link ${refferCode}");
    // print(" Badal badqal  ${phoneNumber}");

    //   _cPhone.text = phoneNumber!;
    if (global.sp != null &&
        global.sp!.containsKey(global.quickLoginEnabled) &&
        global.sp!.getBool(quickLoginEnabled)!) {
      global.sp!.setBool('quickLoginEnabled', false);
    }
    dateinput.text = "";
    // _phonenumMaxLength1 = loginMaxPhoneLength != null ? loginMaxPhoneLength : 0;
    countryCodeSelected =
        loginCountryCode != null && loginCountryCode!.length > 0
            ? loginCountryCode
            : "+971";
    countryCode = (loginCountryCode != null && loginCountryCode!.length > 0
        ? loginCountryCode
        : "+971")!;
    if (countryCode != "971" || countryCode != "+971") {
      checkedValue1 = true;
    } else {
      checkedValue1 = false;
    }
    countryCodeFlg = loginSeletedFlag != null && loginSeletedFlag!.length > 0
        ? loginSeletedFlag
        : "🇦🇪";
  

    print(global.refferalCode);
    if (global.refferalCode != '') {
      print('Akshada---->${global.refferalCode}');

      _cReferralCode.text = global.refferalCode;
    }

    _init();
  }

  _filldata() async {
    try {

      var nPhoneCode1;
      var nPhone;
      if (Platform.isIOS) {
        nPhoneCode1 = user!.userPhone!.substring(0, 2);
        nPhone = user!.userPhone!.substring(2);
      } else {
        nPhoneCode1 = user!.userPhone!.substring(2);
        nPhone = user!.userPhone!.substring(2);
      }

      dropdownValuestate = dropdownValuestate;
      dropdownValueCode = dropdownValueCode;
      _cPhone.text = phoneNumber!;
    } catch (e) {
      print("Exception - signup_screen.dart - _filldata():" + e.toString());
    }
  }

  _init() async {
    prefs = await SharedPreferences.getInstance();

    dropdownValuestate = dropdownValuestate;
    dropdownValueCode = dropdownValueCode;
    try {
      dropdownValueCode = '';
      _filldata();

      dropdownValueCode = dropdownValueCode;
      dropdownValuestate = dropdownValuestate;
      setState(() {});
    } catch (e) {
      print("Exception - signup_screen.dart - _init():" + e.toString());
    }
  }

  static final facebookAppEvents = FacebookAppEvents();
  _onSignUp() async {
    try {
      bool isConnected = await br!.checkConnectivity();
      print("Nikhil _cName${_cName.text}");
      print("Nikhil _cName${_cEmail.text}");
      print("Nikhil _cName${_cPhone.text}");
      print("Nikhil _cName${gender}");

      if (isConnected) {
        showOnlyLoaderDialog();
        CurrentUser _user = new CurrentUser();
        _user.countryCode = countryCode;
        _user.name = _cName.text.trim();
        _user.email = _cEmail.text.trim();
        _user.gender = gender.trim();
        _user.dob = global.monthInIntFormt.format(_selectedDate).toString();

        _user.userPhone = _cPhone.text;
        await apiHelper
            .signUp(_user, countryCodeSelected!, gender, _cReferralCode.text,
                checkedValue1 ? 1 : 0, privacyChecked, countryCodeFlg!)
            .then((result) async {
          if (result != null) {
            if (result.status == "1") {

              hideLoader();

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OtpVerificationScreen(
                            a: widget.analytics,
                            o: widget.observer,
                            isPhoneChange: 1,
                            isFromUpdate: false,
                            isAddMobile: false,
                            isFromSignUPLogin: checkedValue1,
                            countryCode: countryCodeSelected,
                            phoneNumber: _cPhone
                                .text, 
                            referalCode: _cReferralCode.text,
                          )));
              facebookAppEvents.setUserData(
                email: _user.email,
                firstName: _user.name,
                city: _user.userCity.toString(),
              );

              // }
            } else {
              hideLoader();
              showSnackBar(
                  key: _scaffoldKey,
                  snackBarMessage: result.message.toString());
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey!);
      }
    } catch (e) {
      print("Exception - signup_screen.dart - _onSignUp():" + e.toString());
    }
  }

  _showNotifyOnSignUPDialog() {
    try {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(dialogBackgroundColor: Colors.white),
              child: CupertinoAlertDialog(
                  title: Text(
                    'byyu',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: fontMontserratLight,
                        color: ColorConstants.pureBlack),
                  ),
                  content: countryCodeSelected == "971" ||
                          countryCodeSelected == "+971"
                      ? Text(
                          checkedValue1
                              ? "You have selected WhatsApp as your preferred mode of communication. To make changes, please click 'No, Change.'"
                              : "You have selected SMS as your preferred mode of communication. To make changes, please click 'No, Change.'",
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: fontMetropolisRegular,
                              fontWeight: FontWeight.w200,
                              color: ColorConstants.pureBlack),
                        )
                      : Text(
                          "All communication outside the UAE is exclusively done through WhatsApp.",
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: fontMetropolisRegular,
                              fontWeight: FontWeight.w200,
                              color: ColorConstants.pureBlack),
                        ),
                  actions: countryCodeSelected == "971" ||
                          countryCodeSelected == "+971"
                      ? <Widget>[
                          CupertinoDialogAction(
                            child: Text(
                              "No, Change",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: fontMetropolisRegular,
                                  fontWeight: FontWeight.w200,
                                  color: ColorConstants.appColor),
                            ),
                            onPressed: () {
                              // if (checkedValue1) {
                              //   checkedValue1 = false;
                              //   whatsAppChecked = 0;
                              // } else {
                              //   whatsAppChecked = 1;
                              //   checkedValue1 = true;
                              // }
                              setState(() {});
                              Navigator.of(context).pop();

                              // checkedValue1 = false;
                            },
                          ),
                          CupertinoDialogAction(
                            child: Text(
                              "OK",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: fontMetropolisRegular,
                                  fontWeight: FontWeight.w200,
                                  color: Colors.blue),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              _onSignUp();

                              // checkedValue1 = false;
                            },
                          ),
                        ]
                      : [
                          CupertinoDialogAction(
                            child: Text(
                              "OK",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: fontMetropolisRegular,
                                  fontWeight: FontWeight.w200,
                                  color: Colors.blue),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              _onSignUp();

                              // checkedValue1 = false;
                            },
                          ),
                        ]),
            );
          });
    } catch (e) {
      print('Exception - app_menu_screen.dart - exitAppDialog(): ' +
          e.toString());
    }
  }
}
