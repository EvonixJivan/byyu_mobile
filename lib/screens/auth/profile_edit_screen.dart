import 'dart:convert';
import 'dart:io';

import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/CountryCodeList.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/screens/auth/update_mobile_email.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:material_text_fields/material_text_fields.dart';
import 'package:material_text_fields/theme/material_text_field_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/userModel.dart';
import 'package:byyu/widgets/bottom_button.dart';
import '../aboutUsAndTermsOfServices.dart';

final _formKeyEP = GlobalKey<FormState>();
String? validateEmail(String? email) {
  RegExp emailRegex =
      RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,3}$');
  final isEmailValid = emailRegex.hasMatch(email ?? '');
  if (!isEmailValid) {
    return 'Please enter a valid email';
  }
}

class ProfileEditScreen extends BaseRoute {
  ProfileEditScreen({a, o}) : super(a: a, o: o, r: 'ProfileEditScreen');
  @override
  _ProfileEditScreenState createState() => new _ProfileEditScreenState();
}

class _ProfileEditScreenState extends BaseRouteState {
  var _cName = new TextEditingController();
  var _cPhone = new TextEditingController();
  var _cEmail = new TextEditingController();
  DateTime _selectedDate = DateTime(
      DateTime.now().year - 18, DateTime.now().month, DateTime.now().day - 1);
  var _fName = new FocusNode();
  GlobalKey<ScaffoldState>? _scaffoldKey;
  var _fPhone = new FocusNode();
  var _fEmail = new FocusNode();
  var _fSearchSociety = new FocusNode();
  TextEditingController _cSearchArea = new TextEditingController();

  TextEditingController dateinput = TextEditingController();

  var _cSociety = new TextEditingController();
  File? _tImage;
  bool? _isDataLoaded = true;
  String? phoneNumber;
  String? countryCode;
  int? _phonenumMaxLength = 9;
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  List<DropDownValueModel>? countryListDropDown = [];
  List<CountryCodeList>? _countryCodeList = [];
  String? dropdownValuestate;
  var checkedValue;
  int privacyChecked = 0, whatsAppChecked = 0;
  int maleSelected = 0;
  int femaleSelected = 0;
  var checkedValue1;
  String? selectedGender;
  bool showError = false;
  String showErrorStr="Please update your profile with your mobile number, email, or date of birth to proceed.";

  int _phonenumMaxLength1 = 0;
  String countryCodeSelected = "+971", countryCodeFlg = "🇦🇪";

  _ProfileEditScreenState() : super();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      color: global.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ColorConstants.colorPageBackground,
          resizeToAvoidBottomInset: false,
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: ColorConstants.appBarColorWhite,
            leadingWidth: 46,
            centerTitle: false,
            title: Text(
              "Edit Profile",
              style: TextStyle(
                fontFamily: fontRailwayRegular,
                fontWeight: FontWeight.normal,
                color: ColorConstants.newTextHeadingFooter,
              ),
            ),
            leading: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: ColorConstants.appColor,
            ),
          ),
          body: _isDataLoaded!
              ? GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  child: SingleChildScrollView(
                    child: Container(
                        height: MediaQuery.of(context).size.height,
                        
                        child: global.currentUser != null &&
                                global.currentUser.id != null
                            ? Center(
                                child: _isDataLoaded!
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20, top: 60),
                                        child: Form(
                                          key: _formKeyEP,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                             
                                             
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
                                                      fontSize: 14,
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
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700),
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
                                                  labelText: "Full Name",
                                                  keyboardType:
                                                      TextInputType.name,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  onChanged: (p0) {},
                                                  validator: (name) {
                                                    if (name == null ||
                                                        name.isEmpty) {
                                                      return "Please Enter Updated name";
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              UpdateMobileEmailScreen(
                                                                a: widget
                                                                    .analytics,
                                                                o: widget
                                                                    .observer,
                                                                isPhoneChange:
                                                                    false,
                                                                throughSignUP:
                                                                    false,
                                                                socialSignedUserID:
                                                                    "",
                                                              )));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color:
                                                          ColorConstants.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7)),
                                                  child: MaterialTextField(
                                                    style: TextStyle(
                                                        fontFamily: global
                                                            .fontRailwayRegular,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        color: ColorConstants
                                                            .pureBlack),
                                                    enabled: false,
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
                                                      fillColor:
                                                          Colors.transparent,
                                                      enabledColor: Colors.grey,
                                                      focusedColor:
                                                          ColorConstants
                                                              .appColor,
                                                      floatingLabelStyle:
                                                          const TextStyle(
                                                              color:
                                                                  ColorConstants
                                                                      .appColor),
                                                      width: 0.5,
                                                      labelStyle:
                                                          const TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.grey),
                                                    ),
                                                    controller: _cEmail,
                                                    labelText: "Email Id",
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
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        UpdateMobileEmailScreen(
                                                                          a: widget
                                                                              .analytics,
                                                                          o: widget
                                                                              .observer,
                                                                          isPhoneChange:
                                                                              true,
                                                                          throughSignUP:
                                                                              false,
                                                                          socialSignedUserID:
                                                                              "",
                                                                        )));
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        width: 125,
                                                        decoration:
                                                            BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300,
                                                                ),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
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
                                                                    countryCodeFlg,
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
                                                                        countryCodeSelected.contains("+")
                                                                            ? countryCodeSelected
                                                                            : "+${countryCodeSelected}",
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                fontRailwayRegular,
                                                                            fontWeight: FontWeight
                                                                                .w200,
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                ColorConstants.pureBlack,
                                                                            letterSpacing: 1))),
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
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.of(context).push(MaterialPageRoute(
                                                              builder: (context) => UpdateMobileEmailScreen(
                                                                  a: widget
                                                                      .analytics,
                                                                  o: widget
                                                                      .observer,
                                                                  isPhoneChange:
                                                                      true,
                                                                  throughSignUP:
                                                                      false,
                                                                  socialSignedUserID:
                                                                      "")));
                                                        },
                                                        child: Container(
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          0.0))),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 8,
                                                                  right: 1,
                                                                  top: 10,
                                                                  bottom: 10),
                                                          padding:
                                                              EdgeInsets.only(),
                                                          child: TextFormField(
                                                            enabled: false,
                                                            controller: _cPhone,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  fontRailwayRegular,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200,
                                                              color:
                                                                  ColorConstants
                                                                      .pureBlack,
                                                            ),
                                                            decoration:
                                                                InputDecoration(
                                                              counterText: "",
                                                              border:
                                                                  OutlineInputBorder(),
                                                              labelStyle: TextStyle(
                                                                  color: ColorConstants
                                                                      .appColor),
                                                              labelText:
                                                                  "Mobile Number",
                                                                  errorStyle: const TextStyle(
                                        fontSize: 10,
                                        fontFamily:
                                            global.fontRailwayRegular,
                                        fontWeight: FontWeight.w200),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            7),
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade400,
                                                                    width: 0.0),
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
                                                                    width: 0.0),
                                                              ),
                                                            ),
                                                            
                                                            validator:
                                                                (newNum) {
                                                              if (newNum == 0 ||
                                                                  newNum!
                                                                      .isEmpty) {
                                                                return "Please Enter Your Phone Number";
                                                              } else {
                                                                return null;
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: 15,
                                                  right: 15,
                                                ),
                                                child: Text(
                                                  countryCodeSelected ==
                                                              "971" ||
                                                          countryCodeSelected ==
                                                              "+971"
                                                      ? checkedValue1
                                                          ? 'You will receive further communication via whatsapp.'
                                                          : 'You will receive further communication via SMS.'
                                                      : "All communication outside the UAE is exclusively done through WhatsApp.",
                                                  style: TextStyle(
                                                      color: ColorConstants
                                                          .appColor,
                                                      fontSize: 11,
                                                      fontFamily: global
                                                          .fontRailwayRegular,
                                                      fontWeight:
                                                          FontWeight.w200),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15, right: 15),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    RichText(
                                                      text: const TextSpan(
                                                          text: 'Date of Birth',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200,
                                                              fontFamily:
                                                                  fontRailwayRegular,
                                                              color:
                                                                  ColorConstants
                                                                      .pureBlack,
                                                              fontSize: 16),
                                                          children: const <TextSpan>[
                                                            TextSpan(
                                                                text: '',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w200,
                                                                    fontFamily:
                                                                        fontRailwayRegular,
                                                                    fontSize:
                                                                        16,
                                                                    color: ColorConstants
                                                                        .appColor)),
                                                          ]),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: 15,
                                                  right: 15,
                                                ),
                                                child: DatePickerWidget(
                                                  initialDate: _selectedDate,
                                                  looping:
                                                      false, // default is not looping
                                                  lastDate: DateTime(
                                                      DateTime.now().year - 18,
                                                      DateTime.now().month,
                                                      DateTime.now().day - 1),
                                                  dateFormat: "dd/MMMM/yyyy",
                                                  locale: DatePicker
                                                      .localeFromString('en'),
                                                  onChange:
                                                      (DateTime newDate, _) {
                                                    setState(() {
                                                      _selectedDate = newDate;
                                                    });
                                                    print(_selectedDate);
                                                  },
                                                  pickerTheme:
                                                      DateTimePickerTheme(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    itemTextStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontFamily: global
                                                            .fontRailwayRegular,
                                                        fontWeight:
                                                            FontWeight.w200),
                                                    dividerColor: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: ColorConstants
                                                                  .allBorderColor,
                                                              width: 0.5),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2.5,
                                                      child: RadioListTile(
                                                          activeColor:
                                                              ColorConstants
                                                                  .appColor,
                                                          value: 1,
                                                          groupValue:
                                                              maleSelected,
                                                          title: Text(
                                                            "Male",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    fontRailwayRegular,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w200,
                                                                fontSize: 15,
                                                                color: selectedGender !=
                                                                            null &&
                                                                        selectedGender ==
                                                                            "male"
                                                                    ? ColorConstants
                                                                        .appColor
                                                                    : ColorConstants
                                                                        .pureBlack),
                                                          ),
                                                          selected: true,
                                                          onChanged:
                                                              (val) async {
                                                            print(val);
                                                            maleSelected = val!;
                                                            selectedGender =
                                                                "male";
                                                            setState(() {});
                                                          }),
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: ColorConstants
                                                                  .allBorderColor,
                                                              width: 0.5),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2.5,
                                                      child: RadioListTile(
                                                        activeColor:
                                                            ColorConstants
                                                                .appColor,
                                                        value: 2,
                                                        groupValue:
                                                            maleSelected,
                                                        title: Text(
                                                          "Female",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  fontRailwayRegular,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200,
                                                              fontSize: 15,
                                                              color: selectedGender !=
                                                                          null &&
                                                                      selectedGender ==
                                                                          "Female"
                                                                  ? ColorConstants
                                                                      .appColor
                                                                  : ColorConstants
                                                                      .pureBlack),
                                                        ),
                                                        onChanged: (val) async {
                                                          print(val);
                                                          maleSelected = val!;
                                                          selectedGender =
                                                              "female";
                                                          setState(() {});
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: !checkedValue,
                                                child: Container(
                                                  height: 30,
                                                  margin: EdgeInsets.only(
                                                      bottom: 8),
                                                  child: CheckboxListTile(
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    activeColor:
                                                        ColorConstants.appColor,
                                                    title: Transform.translate(
                                                      offset:
                                                          const Offset(-15, 0),
                                                      child: Row(
                                                        children: [
                                                          const Text(
                                                              "I agree to the ",
                                                              style: TextStyle(
                                                                color: ColorConstants
                                                                    .pureBlack,
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    fontRailwayRegular,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              )),
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .push(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            AboutUsAndTermsOfServiceScreen(
                                                                              true,
                                                                              a: widget.analytics,
                                                                              o: widget.observer,
                                                                            )),
                                                              );
                                                            },
                                                            child: Text(
                                                                "Privacy Policy",
                                                                style:
                                                                    TextStyle(
                                                                  color: ColorConstants
                                                                      .appColor,
                                                                  fontSize: 13,
                                                                  fontFamily:
                                                                      fontRailwayRegular,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    value: checkedValue,
                                                    onChanged: (newValue) {
                                                      checkedValue = newValue;
                                                      if (newValue!) {
                                                        privacyChecked = 1;
                                                      } else {
                                                        privacyChecked = 0;
                                                      }
                                                      setState(() {});
                                                    },
                                                    controlAffinity:
                                                        ListTileControlAffinity
                                                            .leading, //  <-- leading Checkbox
                                                  ),
                                                ),
                                              ),
                                              CheckboxListTile(
                                                contentPadding: EdgeInsets.zero,
                                                activeColor:
                                                    ColorConstants.appColor,
                                                title: Transform.translate(
                                                  offset: const Offset(-20, 0),
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                            "I want to receive notifications on ",
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                              color:
                                                                  ColorConstants
                                                                      .pureBlack,
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  fontRailwayRegular,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            )),
                                                        Text("WhatsApp",
                                                            style: TextStyle(
                                                              color:
                                                                  ColorConstants
                                                                      .appColor,
                                                              fontSize: 13,
                                                              fontFamily:
                                                                  fontRailwayRegular,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                                value: checkedValue1,
                                                onChanged: (newValue) {
                                                  print(countryCodeSelected);
                                                  if ((countryCodeSelected ==
                                                              "+971" ||
                                                          countryCodeSelected ==
                                                              "971") ||
                                                      (currentUser != null &&
                                                          currentUser
                                                                  .countryCode !=
                                                              null &&
                                                          (currentUser
                                                                      .countryCode ==
                                                                  "971" ||
                                                              currentUser
                                                                      .countryCode ==
                                                                  "+971"))) {
                                                    print(
                                                        "Helooooooo Nikhil-------");
                                                    _showNotifyDialog(
                                                        newValue!);
                                                  } else if (global.currentUser
                                                              .whatsapp_flag !=
                                                          null &&
                                                      global.currentUser.whatsapp_flag !=
                                                          "1" &&
                                                      currentUser.countryCode !=
                                                          "971" &&
                                                      currentUser.countryCode !=
                                                          "+971") {
                                                    checkedValue1 = true;
                                                    whatsAppChecked = 1;
                                                    setState(() {});
                                                  }

                                                  setState(() {});
                                                },

                                                controlAffinity:
                                                    ListTileControlAffinity
                                                        .leading, //  <-- leading Checkbox
                                              ),
                                              
                                               Visibility(
                                                visible: showError,
                                                child: Container(
                                                  margin: EdgeInsets.all(8),
                                                  child: Text(
                                                    showErrorStr,
                                                    style: TextStyle(
                                                        fontFamily: global
                                                            .fontMontserratLight,
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        fontSize: 15,
                                                        color: ColorConstants
                                                            .appColor),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Align(
                                                alignment: Alignment.center,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: BottomButton(
                                                      key: UniqueKey(),
                                                      child: Text(
                                                        "SAVE & UPDATE",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                fontRailwayRegular,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 14,
                                                            color: global.white,
                                                            letterSpacing: 1),
                                                      ),
                                                      loadingState: false,
                                                      disabledState: false,
                                                      onPressed: () {
                                                        _save();
                                                        // if (_formKeyEP
                                                        //         .currentState!
                                                        //         .validate() &&
                                                        //     checkedValue) {
                                                          
                                                        // }
                                                      }),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              )
                                            ],
                                          ),
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
                                        fontFamily: global.fontMontserratLight,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w200,
                                        color: ColorConstants.grey),
                                  ),
                                ),
                              )),
                  ),
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

  _showNotifyDialog(bool updateValue) {
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
                content: Text(
                  updateValue
                      ? 'You will receive further communication via whatsapp'
                      : 'You will receive further communication via SMS',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: fontRailwayRegular,
                      fontWeight: FontWeight.w200,
                      color: ColorConstants.pureBlack),
                ),
                actions: [
                  CupertinoDialogAction(
                    child: Text(
                      "OK",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: fontRailwayRegular,
                          fontWeight: FontWeight.w200,
                          color: ColorConstants.appColor),
                    ),
                    onPressed: () {
                      checkedValue1 = updateValue;
                      if (checkedValue1) {
                        whatsAppChecked = 1;
                      } else {
                        whatsAppChecked = 0;
                      }
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
    _init();
  }

  _init() async {
    _isDataLoaded = false;
    getMyProfile();

    print(
        "this is the country code${global.userProfileController.currentUser.countryCode}");

    setState(() {});
  }

  getMyProfile() async {
    try {
      await apiHelper.myProfile().then((result) async {
        if (result != null) {
          if (result.status == "1") {
            _isDataLoaded = true;
            currentUser = result.data;
            global.currentUser = currentUser;

            if (global.currentUser.name != null && global.currentUser.name!.isNotEmpty) {
              _cName.text = global.currentUser.name!;
            } else {
              showError = true;
            }
            if (global.currentUser.email != null && global.currentUser.email!.isNotEmpty) {
              _cEmail.text = global.currentUser.email!;
            } else {
              showError = true;
            }
            if (global.currentUser.userPhone != null && global.currentUser.userPhone!.isNotEmpty) {
              _cPhone.text = global.currentUser.userPhone!;
            } else {
              showError = true;
            }
            if (global.currentUser.dob != null) {
              _selectedDate =
                  global.monthInIntFormt.parse(global.currentUser.dob!);
            } else {
              showError = true;
            }
            if (global.currentUser.countryCode != null &&
                global.currentUser.countryCode!.length > 0) {
              countryCodeSelected = global.currentUser.countryCode!;
            } else {
              countryCodeSelected = "+971";
            }
            if (global.currentUser.flagCode != null &&
                global.currentUser.flagCode!.length > 0) {
              countryCodeFlg = global.currentUser.flagCode!;
            } else {
              countryCodeFlg = "🇦🇪";
            }
            if (global.currentUser.gender != null) {
              selectedGender = global.currentUser.gender;
              if (selectedGender!.toLowerCase() == "male") {
                maleSelected = 1;
              } else {
                maleSelected = 2;
              }
            }
            print("This is male selected value below");
            print(maleSelected);
            if (global.currentUser.whatsapp_flag != null &&
                global.currentUser.whatsapp_flag == "1") {
              checkedValue1 = true;
              whatsAppChecked = 1;
            } else {
              checkedValue1 = false;
              whatsAppChecked = 0;
              showError = true;
            }
            if (global.currentUser.privacy_policy_flag != null &&
                global.currentUser.privacy_policy_flag == "1") {
              checkedValue = true;
              privacyChecked = 1;
            } else {
              checkedValue = false;
              privacyChecked = 0;
              showError = true;
            }

            setState(() {});
          } else {
            setState(() {});
          }
        }
      });
    } catch (e) {
      print("Exception - user_profile_controller.dart - _getMyProfile()c:" +
          e.toString());
    }
  }

  _save() async {
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        if(_cName!=null &&  _cName.text.isEmpty){
            showError=true; 
            showErrorStr="Name is required";
            setState(() { });

        }else if(_cEmail!=null && _cEmail.text.isEmpty){
            showError=true; 
            showErrorStr="Email is required";
            setState(() { });
        }
        else if(_cPhone!=null && _cPhone.text.isEmpty){
            showError=true; 
            showErrorStr="Mobile number is required";
            setState(() { });
        }
        else{
        if (_cName.text.isNotEmpty && global.currentUser != null) {
          showError=false;
          showOnlyLoaderDialog();
          CurrentUser _user = new CurrentUser();
          _user.name = _cName.text;
          _user.gender = selectedGender;
          _user.whatsapp_flag = whatsAppChecked.toString();
          _user.privacy_policy_flag = privacyChecked.toString();
          _user.countryCode = countryCodeSelected;
          _user.referralCode = currentUser.referralCode;
          _user.userPhone = _cPhone.text;
          _user.email = _cEmail.text;
          _user.dob = _selectedDate.toString();

          await apiHelper.updateProfile(_user).then((result) async {
            if (result != null) {
              if (result.status == "1") {
                global.userProfileController.currentUser = result.data;
                global.currentUser = global.userProfileController.currentUser;
                global.sp!.setString(
                    'currentUser', json.encode(global.currentUser.toJson()));
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString(
                    'userInfo', json.encode(global.currentUser.toJson()));
                hideLoader();
                await global.userProfileController.getMyProfile();
                Navigator.of(context).pop();
                showSnackBar(
                  key: _scaffoldKey,
                  snackBarMessage: result.message.toString(),
                );
              } else {
                hideLoader();
                showSnackBar(
                    key: _scaffoldKey,
                    snackBarMessage: result.message.toString());
              }
            }
          });
        } else if (_cName.text.isEmpty) {
          showSnackBar(
            key: _scaffoldKey,
            snackBarMessage: "Please enter your name",
          );
        }
        }
      } else {
        hideLoader();
        showNetworkErrorSnackBar(_scaffoldKey!);
      }
    } catch (e) {
      hideLoader();

      print("Exception - profile_edit_screen.dart - _save()a:" + e.toString());
    }
  }

  removeProfileImage() async {
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog();
        CurrentUser _user = new CurrentUser();

        await apiHelper.removeProfileImage(_user).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              hideLoader();
              _init();
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
      print("Exception - profile_edit_screen.dart - _save()b:" + e.toString());
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
