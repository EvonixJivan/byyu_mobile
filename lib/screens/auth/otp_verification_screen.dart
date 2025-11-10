
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:byyu/widgets/toastfile.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
  
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/screens/home_screen.dart';
import 'package:byyu/utils/size_config.dart';
import 'package:byyu/widgets/bottom_button.dart';

import '../../models/userModel.dart';

class OtpVerificationScreen extends BaseRoute {
  final String? phoneNumber;
  final String? countryCode;
  final String? verificationCode;
  final String? referalCode;
  final int? screenId;
  int? isPhoneChange;
  bool? isFromUpdate = false;
  bool? isFromSignUPLogin;
  UpdateMobileEmailMobel? updateMobEmailResponse;
  bool? isAddMobile = false;
  String? socialSignedUserID;

  OtpVerificationScreen(
      {a,
      o,
      this.screenId,
      this.countryCode,
      this.phoneNumber,
      this.verificationCode,
      this.referalCode,
      this.isPhoneChange,
      this.isFromUpdate,
      this.updateMobEmailResponse,
      this.socialSignedUserID,
      this.isFromSignUPLogin,
      this.isAddMobile})
      : super(a: a, o: o, r: 'OtpVerificationScreen');
  @override
  _OtpVerificationScreenState createState() => new _OtpVerificationScreenState(
      this.screenId,
      this.phoneNumber!,
      this.verificationCode,
      this.referalCode,
      this.isPhoneChange,
      this.isFromUpdate!,
      this.updateMobEmailResponse,
      this.countryCode,
      this.socialSignedUserID ?? "",
      this.isFromSignUPLogin!,
      this.isAddMobile!);
}

class _OtpVerificationScreenState extends BaseRouteState {
  int _seconds = 60;
  Timer? _countDown;
  String phoneNumber;
  String? countryCode;
  String? verificationCode;
  GlobalKey<ScaffoldState>? _scaffoldKey;
  String? status;
  int? screenId;
  String? referalCode = "";
  UpdateMobileEmailMobel? updateMobEmailResponse;
  bool isFromUpdate = false;
  bool isFromSignUPLogin;
  final FocusNode _fOtp = FocusNode();
  var _cOtp = TextEditingController();
  int? isPhoneChange;
  String socialSignedUserID;
  bool isAddMobile = false;
  bool boolOTPError = false;
  String strOTPerror = "";
  _OtpVerificationScreenState(
      this.screenId,
      this.phoneNumber,
      this.verificationCode,
      this.referalCode,
      this.isPhoneChange,
      this.isFromUpdate,
      this.updateMobEmailResponse,
      this.countryCode,
      this.socialSignedUserID,
      this.isFromSignUPLogin,
      this.isAddMobile)
      : super();
  int i=0;
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      child: Scaffold(
          backgroundColor: ColorConstants.colorPageBackground,
          resizeToAvoidBottomInset: false,
          key: _scaffoldKey,
          appBar: AppBar(
            leadingWidth: 46,
            backgroundColor: ColorConstants.appBarColorWhite,
            title: Text("Verify OTP",
                style: TextStyle(
                  fontFamily: fontRailwayRegular,
                  color: ColorConstants.newTextHeadingFooter,
                  fontWeight: FontWeight.w200,
                )),
            centerTitle: false,
            leading: BackButton(
              onPressed: () {
                print("Go back");
                Navigator.pop(context);
              },
              color: ColorConstants.appColor,
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Stack(
                children: [
                  SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 30, right: 30, top: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Container(
                                          padding: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              border: Border.all(
                                                  color: ColorConstants
                                                      .newAppColor,
                                                  width: 5)),
                                          margin: EdgeInsets.only(top: 0),
                                          height: 130,
                                          width:
                                              130, 
                                          child: Image.asset(
                                            'assets/images/otp_verification.png',
                                            fit: BoxFit.fill,
                                            color: ColorConstants.newAppColor,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      !isAddMobile && !isFromUpdate
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20, right: 20),
                                              child: Text(
                                                isFromSignUPLogin != null &&
                                                        isFromSignUPLogin
                                                    ? "Kindly enter the OTP sent to your WhatsApp text ${addMobileCountryCode}  XXXXXXX${addMobilePhone!.substring(addMobilePhone!.length - 2)}"
                                                    : "Kindly enter the OTP sent to your SMS  ${addMobileCountryCode}  XXXXXXX${addMobilePhone!.substring(addMobilePhone!.length - 2)}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: ColorConstants
                                                        .pureBlack,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontFamily:
                                                        fontRailwayRegular,
                                                    height: 1.5),
                                              ),
                                            )
                                          : SizedBox(),
                                      isAddMobile
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20, right: 20),
                                              child: Text(
                                                addMobileCountryCode != null &&
                                                        (addMobileCountryCode ==
                                                                "971" ||
                                                            addMobileCountryCode ==
                                                                "+971")
                                                    ? "Kindly enter the OTP sent to your SMS isAddMobile${addMobileCountryCode} XXXXXXX${addMobilePhone!.substring(addMobilePhone!.length - 2)}"
                                                    : "Kindly enter the OTP sent to your WhatsApp ${addMobileCountryCode} XXXXXXX${addMobilePhone!.substring(addMobilePhone!.length - 2)}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: ColorConstants
                                                        .pureBlack,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontFamily:
                                                        fontRailwayRegular,
                                                    height: 1.5),
                                              ),
                                            )
                                          : SizedBox(),
                                      isFromUpdate
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20, right: 20),
                                              child: isPhoneChange == 1
                                                  ? Text(
                                                      addMobileCountryCode !=
                                                                  null &&
                                                              (addMobileCountryCode ==
                                                                      "971" ||
                                                                  addMobileCountryCode ==
                                                                      "+971") &&
                                                              updateMobEmailResponse!
                                                                      .whatsappFlag ==
                                                                  "0"
                                                          ? "Kindly enter the OTP sent to your SMS isFromUpdate ${addMobileCountryCode} XXXXXXX${addMobilePhone!.substring(addMobilePhone!.length - 2)}"
                                                          : "Kindly enter the OTP sent to your WhatsApp ${addMobileCountryCode} XXXXXXX${addMobilePhone!.substring(addMobilePhone!.length - 2)}",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: ColorConstants
                                                              .pureBlack,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontFamily:
                                                              fontRailwayRegular,
                                                          height: 1.5),
                                                    )
                                                  : Text(
                                                      "OTP has been sent to your registered email id",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: ColorConstants
                                                              .pureBlack,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontFamily:
                                                              fontRailwayRegular,
                                                          height: 1.5),
                                                    ))
                                          : SizedBox(),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          width: 315,
                                          alignment: Alignment.center,
                                          child: PinFieldAutoFill(
                                            key: Key("1"),
                                            focusNode: _fOtp,
                                            decoration: BoxLooseDecoration(
                                                strokeColorBuilder:
                                                    FixedColorBuilder(
                                                        Colors.grey.shade300),
                                                bgColorBuilder:
                                                    FixedColorBuilder(
                                                        Colors.grey.shade200),
                                                hintText: '••••••',
                                                textStyle: TextStyle(
                                                    color: ColorConstants
                                                        .pureBlack,
                                                    fontFamily:
                                                        fontMontserratMedium,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            currentCode: _cOtp.text,
                                            controller: _cOtp,
                                            codeLength: 6,
                                            keyboardType: TextInputType.number,
                                            onCodeSubmitted: (code) {
                                              setState(() {
                                                _cOtp.text = code;
                                              });
                                            },
                                            onCodeChanged: (code) async {
                                              if (code!.length == 6) {
                                                _cOtp.text = code;
                                                setState(() { });
                                                if (isAddMobile) {
                                                  _checkAddMobileOTP(
                                                      _cOtp.text);
                                                } else {
                                                  if (isFromUpdate!) {
                                                    _checkUpdateOTP(_cOtp.text);
                                                  } else {
                                                    setState(() {});
                                                    await _checkOTP(_cOtp.text);
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            FocusNode());
                                                  }
                                                }
                                              }
                                            },
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Visibility(
                                        visible: boolOTPError,
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(top: 5, left: 5),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              strOTPerror,
                                              style: global.errorTextStyle,
                                            ),
                                          ),
                                        ),
                                      ),
                                      boolOTPError
                                          ? SizedBox(
                                              height: 10,
                                            )
                                          : SizedBox(),
                                      Container(
                                        height: 40,
                                        width:
                                            (MediaQuery.of(context).size.width /
                                                    2) -
                                                70,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: ColorConstants.appColor,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: BottomButton(
                                            color: ColorConstants.appColor,
                                            loadingState: false,
                                            disabledState: true,
                                            onPressed: () async {
                                              if (_cOtp.text.length == 6) {
                                                if (isFromUpdate!) {
                                                  _checkUpdateOTP(_cOtp.text);
                                                } else {
                                                  await _checkOTP(_cOtp.text);
                                                }
                                              } else {
                                                boolOTPError = true;
                                                strOTPerror = "Required*";
                                                setState(() {});
                                              }
                                            },
                                            child: Text(
                                              "VERIFY",
                                              style: TextStyle(
                                                  fontFamily:
                                                      fontMontserratMedium,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: ColorConstants.white,
                                                  letterSpacing: 1),
                                            )),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 20),
                                        child: Text("Didn't receive OTP?",
                                            style: TextStyle(
                                                color: ColorConstants.pureBlack,
                                                fontWeight: FontWeight.normal)),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      _seconds != 0
                                          ? Text("Wait 00:$_seconds",
                                              style: TextStyle(
                                                  color:
                                                      ColorConstants.pureBlack))
                                          : InkWell(
                                              onTap: () async {
                                                if (isFromUpdate!) {
                                                } else {
                                                  await _resendOTP();
                                                }
                                              },
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                child: Text("Resend OTP",
                                                    style: TextStyle(
                                                        color: ColorConstants
                                                            .appColor)),
                                              ),
                                            )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          )),
    );
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  String? addMobileCountryCode;
  String? addMobilePhone;
  @override
  void initState() {
    super.initState();
    addMobileCountryCode = countryCode;
    addMobilePhone = phoneNumber;
    print(addMobileCountryCode);
    print(isFromSignUPLogin);
    global.isSplashSelected = false;
    _listenForSmsCode();

    // SmsAutoFill().getAppSignature.then((signature) {
    //   print("Hello niks----------------");
    //   setState(() {
    //     print(signature);
    //     // showToast("release Sign---${signature}");
    //   });
    // });
    startTimer();
  }
  void _listenForSmsCode() async {
    await SmsAutoFill().listenForCode();
  }

  Future startTimer() async {
    setState(() {});
    const oneSec = const Duration(seconds: 1);
    _countDown = new Timer.periodic(
      oneSec,
      (timer) {
        if (_seconds == 0) {
          setState(() {
            _countDown!.cancel();
            timer.cancel();
          });
        } else {
          setState(() {
            _seconds--;
          });
        }
      },
    );

    setState(() {});
  }

  Future _checkOTP(String otp) async {
    try {
      bool isConnected = await br!.checkConnectivity();

      if (isConnected) {
        print("Screen ID-----${screenId}");

        showOnlyLoaderDialog();
        await apiHelper
            .verifyPhone(
                phoneNumber, _cOtp.text, countryCode ?? "", referalCode ?? "")
            .then((result) async {
          if (result != null) {
            if (result.status == "1") {
              print("${result.data}.toString");
              global.currentUser = result.data;
              SharedPreferences prefs = await SharedPreferences.getInstance();
              global.userProfileController.currentUser = global.currentUser;
              prefs.setString('currentUser', json.encode(result.data));
              prefs.setString('userInfo', json.encode(result.data));
              global.cartCount = global.currentUser.cart_count!;
              global.wishlistCount=0;
              global.refferalCode = "";
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
                prefs.setBool(global.isLoggedIn, true);
                global.stayLoggedIN = true;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(
                      a: widget.analytics,
                      o: widget.observer,
                      selectedIndex: 0,
                    ),
                  ),
                );
              }

              
            } else {
              print("this is the status 0");
              hideLoader();
              boolOTPError = true;
              strOTPerror = result.message;
            }
          } else {
            boolOTPError = true;
            strOTPerror = result.message;
            hideLoader();
          }
        });
      } else {
        hideLoader();
        boolOTPError = true;
        strOTPerror = strCheckInternet;
        showNetworkErrorSnackBar(_scaffoldKey!);
      }
    } catch (e) {
      hideLoader();
      boolOTPError = true;
      strOTPerror = strWentWrong;
      print("Exception - otp_verification_screen.dart - _checkOTP()A:" +
          e.toString());
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
                  Platform.isIOS
                      ? "Would you like to register FaceID for quick login?"
                      : 'Would you like to register fingerprint for quick login?',
                  style: TextStyle(
                      fontSize: 14, fontFamily: global.fontRailwayRegular),
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('NO',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: fontRailwayRegular,
                            fontWeight: FontWeight.w200,
                            color: ColorConstants.newTextHeadingFooter)),
                    onPressed: () async {
                      prefs.setBool(global.quickLoginEnabled, false);
                      prefs.setBool(global.isLoggedIn, true);
                      global.stayLoggedIN = true;
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(
                            a: widget.analytics,
                            o: widget.observer,
                            selectedIndex: 0,
                          ),
                        ),
                      );
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text('YES',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: fontRailwayRegular,
                            fontWeight: FontWeight.w200,
                            color: ColorConstants.newAppColor)),
                    onPressed: () async {
                      prefs.setBool('quickLoginEnabled', true);
                      prefs.setBool("isLoggedIn", true);
                      global.stayLoggedIN = true;
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(
                            a: widget.analytics,
                            o: widget.observer,
                            selectedIndex: 0,
                          ),
                        ),
                      );
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

  Future _checkUpdateOTP(String otp) async {
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog();
        await apiHelper
            .verifyUpdateOTP(updateMobEmailResponse!.lastid.toString(), otp)
            .then((result) async {
          if (result != null) {
            if (result.status == "1") {
              global.refferalCode = "";
              getMyProfile();
            } else {
              hideLoader();
              boolOTPError = true;
              strOTPerror = result.message;
              setState(() {});
            }
          } else {
            boolOTPError = true;
            strOTPerror = result.message;
            setState(() {});
            hideLoader();
          }
        });

      } else {
        hideLoader();
        boolOTPError = true;
        strOTPerror = "Please check your internet connection";
        setState(() {});
      }
    } catch (e) {
      hideLoader();
      boolOTPError = true;
      strOTPerror = "Something went wrong";
      print("Exception - otp_verification_screen.dart - _checkOTP()BA:" +
          e.toString());
    }
  }

  Future _checkAddMobileOTP(String otp) async {
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog();
        await apiHelper
            .verifyAddMobileOTP(socialSignedUserID, otp, phoneNumber)
            .then((result) async {
          if (result != null) {
            if (result.status == "1") {
              showSnackBar(
                  key: _scaffoldKey, snackBarMessage: '${result.message}');
              global.refferalCode = "";
              getMyProfile();
            } else {
              hideLoader();
              boolOTPError = true;
              strOTPerror = result.message;
            }
          } else {
            hideLoader();
            boolOTPError = true;
            strOTPerror = result.message;
          }
        });

      } else {
        hideLoader();
        boolOTPError = true;
        strOTPerror = strCheckInternet;
      }
    } catch (e) {
      hideLoader();
      boolOTPError = true;
      strOTPerror = strWentWrong;
      print("Exception - otp_verification_screen.dart - _checkAddMobileOTP():" +
          e.toString());
    }
  }

  getMyProfile() async {
    try {
      await apiHelper.myProfile().then((result) async {
        if (result != null) {
          if (result.status == "1") {
            currentUser = result.data;
            global.currentUser = currentUser;
            global.stayLoggedIN = true;
            hideLoader();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomeScreen(
                      a: widget.analytics,
                      o: widget.observer,
                      selectedIndex: 0,
                    )));
            setState(() {});
          } else {

            currentUser = CurrentUser();

            setState(() {});
          }
        }
      });
    } catch (e) {
      print("Exception - user_profile_controller.dart - _getMyProfile():" +
          e.toString());
    }
  }

  _resendOTP() async {
    try {
      showOnlyLoaderDialog();
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        if (isFromUpdate!) {
        } else {
          await apiHelper
              .resendOTP(phoneNumber, countryCode!)
              .then((result) async {
            if (result != null) {
              if (result.status == "1") {
                print(result.data.toString());
                hideLoader();
                _cOtp.clear();
                _seconds = 60;
                startTimer();
                await SmsAutoFill().listenForCode();
                setState(() {});
              } else {
                hideLoader();
              }
            }
          });
        }
      }
    } catch (e) {
      hideLoader();
      print("Exception - otp_verification_screen.dart - _resendOTP():" +
          e.toString());
    }
  }
}
