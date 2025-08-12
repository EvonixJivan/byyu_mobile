import 'dart:core';
import 'dart:core';
import 'dart:io';

import 'package:byyu/screens/aboutUsAndTermsOfServices.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:byyu/constants/color_constants.dart';

import 'package:byyu/models/businessLayer/apiHelper.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/businessLayer/global.dart';

import 'package:byyu/models/userModel.dart';
import 'package:byyu/screens/home_screen.dart';

import '../../models/termsOfServicesModel.dart';

class UserSettingsScreen extends BaseRoute {
  UserSettingsScreen({a, o}) : super(a: a, o: o, r: 'UserSettingsScreen');

  @override
  _UserSettingsScreenState createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends BaseRouteState {
  APIHelper apiHelper = APIHelper();
  bool? _switchValue = true;
  GlobalKey<ScaffoldState>? _scaffoldKey;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.appBrownFaintColor,
        leadingWidth: 46,
        actions: [],
        centerTitle: true,
        title: Text(
          "Settings",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: ColorConstants.pureBlack,
              fontFamily: fontMetropolisRegular,
              fontWeight: FontWeight.w200),
        ),
      ),
      body: Container(
        color: white,
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => AboutUsAndTermsOfServiceScreen(
                            true,
                            a: widget.analytics,
                            o: widget.observer,
                          )),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Container(
                  decoration: BoxDecoration(
                      
                      color: Colors.white),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.privacy_tip_outlined,
                            size: 20,
                            color: ColorConstants.appColor,
                          ),
                          SizedBox(width: 10),
                          Text("Privacy Policy",
                              style: TextStyle(
                                  fontFamily: fontMetropolisRegular,
                                  color: ColorConstants.pureBlack,
                                  fontWeight: FontWeight.w200,
                                  fontSize: 15)),
                          Expanded(
                            child: Text(">",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontFamily: fontMetropolisRegular,
                                    color: ColorConstants.pureBlack,
                                    fontWeight: FontWeight.w200,
                                    fontSize: 25)),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 1,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => AboutUsAndTermsOfServiceScreen(
                            false,
                            a: widget.analytics,
                            o: widget.observer,
                          )),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.privacy_tip_outlined,
                            size: 20,
                            color: ColorConstants.appColor,
                          ),
                          SizedBox(width: 10),
                          Text("Terms & Conditions",
                              style: TextStyle(
                                  fontFamily: fontMetropolisRegular,
                                  color: ColorConstants.pureBlack,
                                  fontWeight: FontWeight.w200,
                                  fontSize: 15)),
                          Expanded(
                            child: Text(">",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontFamily: fontMetropolisRegular,
                                    color: ColorConstants.pureBlack,
                                    fontWeight: FontWeight.w200,
                                    fontSize: 25)),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 1,
            ),
            global.stayLoggedIN! && global.currentUser.id != null
                ? InkWell(
                    onTap: () {
                      _deleteAccountDialog();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/user_deactivate.png',
                                  width: 22,
                                  height: 22,
                                  fit: BoxFit.fill,
                                  color: ColorConstants.appColor,
                                ),
                                SizedBox(width: 10),
                                Text("Delete My Account",
                                    style: TextStyle(
                                        fontFamily: fontMetropolisRegular,
                                        color: ColorConstants.pureBlack,
                                        fontWeight: FontWeight.w200,
                                        fontSize: 15)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
            isbiometricEnabled
                ? Container(
                    decoration: BoxDecoration(
                        color: Colors.white),
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Icon(
                          Platform.isIOS
                              ? MdiIcons.fingerprint
                              : MdiIcons.fingerprint,
                          size: 20,
                          color: ColorConstants.appColor,
                        ),
                        SizedBox(width: 10),
                        Text(
                            Platform.isIOS
                                ? "Enable/ Disable Face ID"
                                : "Enable/ Disable biometric auth",
                            style: TextStyle(
                                fontFamily: fontMetropolisRegular,
                                color: ColorConstants.pureBlack,
                                fontWeight: FontWeight.w200,
                                fontSize: 15)),
                        Expanded(child: Text("")),
                        Transform.scale(
                          scale: 0.7,
                          child: CupertinoSwitch(
                            value: isquickLoginEnabled,
                            onChanged: (value) async {
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              print(preferences
                                  .getBool(global.quickLoginEnabled));
                              preferences.setBool(
                                  global.quickLoginEnabled, value);
                              setState(() {
                                isquickLoginEnabled = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 1,
                        )
                      ],
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  bool isbiometricEnabled = false;
  bool isquickLoginEnabled = false;
  @override
  void initState() {
    super.initState();

    init();
  }

  init() async {
    if (global.sp != null &&
        global.sp!.containsKey(global.quickLoginEnabled) &&
        global.sp!.getBool(quickLoginEnabled)!) {
      print("hello outer if");
      final LocalAuthentication auth = LocalAuthentication();
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      if (canCheckBiometrics) {
        print("hello inner if");
        isbiometricEnabled = true;
      } else {
        print("hello inner else");
        isbiometricEnabled = true;
      }
    } else {
      print("hello outer else");
      isbiometricEnabled = true;
    }
    print(
        "hello this is quick login enabled${global.sp!.getBool(quickLoginEnabled)!}");
    if (global.sp!.getBool(quickLoginEnabled)!) {
      isquickLoginEnabled = global.sp!.getBool(quickLoginEnabled)!;
    }
    setState(() {});
  }

  _deleteAccountDialog() {
    try {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(dialogBackgroundColor: Colors.white),
              child: CupertinoAlertDialog(
                title: Text(
                  'Are you sure you want to delete your account?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: fontMontserratLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                content: Text(
                  'Please note that upon account deletion, you will need to reactivate your account. Confirm to proceed.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: fontMetropolisRegular,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontFamily: fontMetropolisRegular,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    onPressed: () {
                      return Navigator.of(context).pop(false);
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
                      callDeleteMyAccountAPI();
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

  callDeleteMyAccountAPI() async {
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog();
        await apiHelper.apiDeleteMyAccount().then((result) async {
          if (result != null) {
            DeleteMyAccount deleteMyAccount = result.data;
            if (result.status == "1") {
              DeleteMyAccount deleteMyAccount = result.data;
              if (deleteMyAccount.status == "1") {
                sp!.remove("currentUser");
                currentUser = CurrentUser();
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                await preferences.clear();
                global.stayLoggedIN = false;
                preferences.setString(global.appLoadString, "true");
                preferences.setBool(global.quickLoginEnabled, false);
                preferences.setBool(global.isLoggedIn, false);
                hideLoader();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomeScreen(
                          a: widget.analytics,
                          o: widget.observer,
                          selectedIndex: 0,
                        )));
              }
            } else {
              hideLoader();
              Fluttertoast.showToast(
                msg: deleteMyAccount.message!, // message
                toastLength: Toast.LENGTH_SHORT, // length
                gravity: ToastGravity.CENTER, // location
                // duration
              );
            }
          }
        });
      }
    } catch (e) {
      hideLoader();
      Fluttertoast.showToast(
        msg: "Something went wrong", // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.CENTER, // location
        // duration
      );
    }
  }
}
