import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:byyu/controllers/cart_controller.dart';
import 'package:byyu/models/businessLayer/apiHelper.dart';
import 'package:byyu/models/cartModel.dart';
import 'package:byyu/screens/intro_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/appInfoModel.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/businessLayer/network_util.dart';
import 'package:byyu/models/userModel.dart';
import 'package:byyu/screens/auth/login_screen.dart';
import 'package:byyu/screens/home_screen.dart';
import 'package:byyu/screens/auth/intro_screen.dart';
import 'package:byyu/widgets/toastfile.dart';

import '../models/businessLayer/global.dart';
import '../utils/size_config.dart';

class SplashScreen1 extends BaseRoute {
  // what is base route? yt video dekhna hai AAQ

  int? routingProductID;
  SplashScreen1({a, o, this.routingProductID})
      : super(a: a, o: o, r: 'SplashScreen');
  @override
  _SplashScreenState createState() => new _SplashScreenState(
      routingProductID != null ? routingProductID : null);
}

enum SupportState {
  unknown,
  supported,
  unSupported,
}

class _SplashScreenState extends BaseRouteState implements TickerProvider {
  final LocalAuthentication auth = LocalAuthentication();
  SupportState supportState = SupportState.unknown;

  // AnimationController controller;
  int percentValue = 4;
  bool isloading = true;
  int? routingProductID;

  GlobalKey<ScaffoldState>? _scaffoldKey;
  //What is Scaffold AAQ
  _SplashScreenState(this.routingProductID) : super();
  // Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences? _prefs;
  String popupURL = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: ColorConstants.colorPageBackground,
        body: Center(
          child: Container(
            margin: EdgeInsets.only(top: 0),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            // child: Image.asset(
            //   'assets/images/launcher.gif',
            //   fit: BoxFit.contain,
            // ),
          ),
        ));
  }

  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    auth.isDeviceSupported().then((bool isSupported) => setState(() =>
        supportState =
            isSupported ? SupportState.supported : SupportState.unSupported));
    super.initState();
    checkBiometric();
    getAvailableBiometrics();
    getDEVICEID();
    sharedPrefs();

    global.isSplashSelected = true;
    WidgetsBinding.instance.addObserver(this);
  }

  getDEVICEID() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      globalDeviceId = iosDeviceInfo.identifierForVendor!;
      // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      globalDeviceId = androidDeviceInfo.id;
      // unique ID on Android
    }
    print("nihil this is the device id ${globalDeviceId}");
  }

  Future<void> sharedPrefs() async {
    global.sp = await SharedPreferences.getInstance();

    if (global.sp!.getString("popUpURL") != null) {
      popupURL = global.sp!.getString("popUpURL")!;
      // print('G1---->0004 >  ${_prefs.getString("popUpURL")}');
      setState(() {});
      Timer(Duration(seconds: 3), () {
        if (sp!.containsKey(global.quickLoginEnabled) &&
            sp!.getBool(quickLoginEnabled)!) {
          authenticateWithBiometrics();
        } else {
          checkUpdate();
        }
        // checkUpdate();
      });
    } else {
      if (sp!.containsKey(global.quickLoginEnabled) &&
          sp!.getBool(quickLoginEnabled)!) {
        authenticateWithBiometrics();
      } else {
        checkUpdate();
      }
    }
  }

  Future<void> checkUpdate() async {
    print("this is splashscreen checkUpdate");
    global.sp = await SharedPreferences.getInstance();
    if (global.sp != null &&
        global.sp!.getString("userInfo") != null &&
        global.sp!.containsKey(global.quickLoginEnabled) &&
        global.sp!.getBool(global.quickLoginEnabled)!) {
      print("this is splashscreen checkUpdate");
      global.currentUser =
          CurrentUser.fromJson(json.decode(global.sp!.getString("userInfo")!));
      global.stayLoggedIN = global.sp!.getBool(global.isLoggedIn)!;
    } else if (global.sp!.containsKey(global.isLoggedIn) &&
        global.sp!.getBool(global.isLoggedIn)!) {
      global.currentUser =
          CurrentUser.fromJson(json.decode(global.sp!.getString("userInfo")!));
      global.stayLoggedIN = global.sp!.getBool(global.isLoggedIn)!;
    }

    // global.sp.setString(global.appLoadString, "true");
    if (global.appDeviceId == null || global.appDeviceId == "") {
      FirebaseMessaging _firebaseMessaging =
          FirebaseMessaging.instance; // Change here
      _firebaseMessaging.getToken().then((token) {
        print("token is $token");
        global.appDeviceId = token!;
        _getAppInfo(token);
      }).onError((error, stackTrace) {
        _getAppInfo("");
      });
    } else {
      _getAppInfo(global.appDeviceId!);
    }
  }

  Future _getAppInfo(String fcmToken) async {
    global.showLoaderTransparent(context);
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      print("token is 111 $fcmToken");
      // showOnlyLoaderDialog();
      var platform;
      dynamic userId = '';
      userId = global.currentUser != null ? global.currentUser.id : "";
      if (Platform.isIOS) {
        platform = "ios";
      } else {
        platform = "android";
      }
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      // print("G1---buildNumber>${await FirebaseMessaging.instance.getToken()}");
      var map = new Map<String, dynamic>();
      map['user_id'] = userId != null ? userId.toString() : "";
      map["platform"] = platform;
      map['app_name'] = "customer";
      map['fcm_token'] = fcmToken != null ? fcmToken : "";
      map['actual_device_id'] = global.globalDeviceId;
      map['app_cur_version'] = version;
      print('${global.nodeBaseUrl}app_info');
      print(map);
      try {
        // APIHelper apiHelper = new APIHelper();
        // await apiHelper.getAppInfo().then((result) async {
        //   if (result != null) {
        //     if (result.status == "1") {
        //       global.appInfo = result.data;

        //       setState(() {});
        //     } else {
        //       hideLoader();
        //       showSnackBar(
        //           key: _scaffoldKey, snackBarMessage: '${result.message}');
        //     }
        //   }
        // });

        NetworkUtil _networkUtil = NetworkUtil();
        _networkUtil
            .post('${global.nodeBaseUrl}app_info', body: map)
            .then((dynamic res) {
          try {
            print("NIKHIL:");
            dynamic recordList;
            print(res);
            // print("G112--->statusCode  ${res}");
            // recordList = new AppInfo.fromJson(res);
            recordList = res;
            //new AppInfo.fromJson(res);
            // print('G1--0666--->${DateTime.now()}');
            // var isLocalEnable = prefs.setBool("isLocalEnable", true);

            if (recordList != null) {
              print(recordList);
              percentValue++;
              global.appInfo = AppInfo.fromJson(recordList);

              global.cartCount = global.appInfo.cartitem!;

              global.wishlistCount = global.appInfo.wishlistCount != null
                  ? global.appInfo.wishlistCount!
                  : 0;

              setState(() {});
              String userstatus = global.appInfo.userStatus!;
              if (userstatus == "deactivate") {
                global.hideloaderTransparent(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginScreen(
                              a: widget.analytics,
                              o: widget.observer,
                            )));
              } else {
                _init();
              }
            } else {
              // hideLoader();
              showSnackBar(
                  key: _scaffoldKey, snackBarMessage: 'Something went wrong');
            }

            // Navigator.pop(context);
          } catch (es) {
            print(es.toString());
            // showToast(es);
          }
          // setState(() {});
        });
      } catch (e) {
        // Navigator.pop(context);
        print(e.toString());
        //showToast(e);
      }
    } else {
      showNetworkErrorSnackBar(_scaffoldKey!);
    }
  }

  void _init() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (global.sp!.getString('currentUser') == null) {
      PermissionStatus permissionStatus = await Permission.phone.status;
      if (!permissionStatus.isGranted) {
        permissionStatus = await Permission.phone.request();
      }
    }
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String version = packageInfo.version;
    // String buildNumber = packageInfo.buildNumber;

    final mversion = version.replaceAll(".", "");
    final apiVersion = global.appInfo.version!.replaceAll(".", "");

    if (global.appInfo.version == null ||
        global.appInfo.app_version_status == 100) {
      global.isSplashSelected = false;

      if (global.sp!.getString('currentUser') != null) {
        // print('G1--->1--${global.sp.getString('currentUser')}');
        global.currentUser = CurrentUser.fromJson(
            json.decode(global.sp!.getString("currentUser")!));
        if (global.sp!.getBool(global.isLoggedIn) != null) {
          global.stayLoggedIN = global.sp!.getBool(global.isLoggedIn)!;
        } else {
          global.stayLoggedIN = false;
        }
        global.cartCount = global.appInfo.cartitem!;
        global.hideloaderTransparent(context);
        Future.delayed(Duration.zero, () {
          if (global.goToCorporatePage) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomeScreen(
                      a: widget.analytics,
                      o: widget.observer,
                      selectedIndex: 4,
                    )));
          } else if (global.sp!.getString(global.appLoadString) != null) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomeScreen(
                      a: widget.analytics,
                      o: widget.observer,
                      selectedIndex: 0,
                    )));
          } else {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => IntroSliderScreen(
                      a: widget.analytics,
                      o: widget.observer,
                    )));
          }
        });
      } else {
        global.isSplashSelected = false;
        global.cartCount = global.appInfo.cartitem!;
        if (global.goToCorporatePage) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomeScreen(
                    a: widget.analytics,
                    o: widget.observer,
                    selectedIndex: 4,
                  )));
        } else if (global.sp!.getString(global.appLoadString) != null) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomeScreen(
                    a: widget.analytics,
                    o: widget.observer,
                    selectedIndex: 0,
                  )));
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => IntroSliderScreen(
                    a: widget.analytics,
                    o: widget.observer,
                  )));
        }
      }
    } else {
      if (global.appInfo.app_version_status == 300) {
        _updateForcefullyDialog('${global.appInfo.app_version_messgae}');
      } else {
        global.cartCount = global.appInfo.cartitem!;

        _updateDialog("${global.appInfo.app_version_messgae}");
      }
    }

    // });
  }

  _updateDialog(String msg) async {
    try {
      showCupertinoDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(dialogBackgroundColor: Colors.white),
              child: Column(
                children: [
                  Expanded(
                    child: Text(""),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: ColorConstants.dialogBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/gift_rocket.png',
                          width: MediaQuery.of(context).size.width / 1.5,
                          height: MediaQuery.of(context).size.width / 1.5,
                          fit: BoxFit.contain,
                        ),

                        Container(
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Container(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  'App update Required!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: fontRailwayRegular,
                                      fontWeight: FontWeight.w200,
                                      color: ColorConstants.pureBlack),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  '${msg}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: fontRailwayRegular,
                                      fontWeight: FontWeight.w200,
                                      color: ColorConstants.pureBlack),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 1,
                                  width:
                                      MediaQuery.of(context).size.width - 100,
                                  color: ColorConstants.grey,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 100,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () async {
                                            // Navigator.of(context).pop();
                                            // _updateDialog(msg);
                                            global.isSplashSelected = false;
                                            bool isConnected =
                                                await br!.checkConnectivity();
                                            showOnlyLoaderDialog();
                                            if (isConnected) {
                                              if (global.sp!.getString(
                                                      'currentUser') !=
                                                  null) {
                                                global.currentUser = CurrentUser
                                                    .fromJson(json.decode(
                                                        global.sp!.getString(
                                                            "currentUser")!));

                                                if (global.sp!.getString(
                                                        global.appLoadString) !=
                                                    null) {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              HomeScreen(
                                                                a: widget
                                                                    .analytics,
                                                                o: widget
                                                                    .observer,
                                                                selectedIndex:
                                                                    0,
                                                              )));
                                                } else {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              IntroSliderScreen(
                                                                a: widget
                                                                    .analytics,
                                                                o: widget
                                                                    .observer,
                                                              )));
                                                }
                                                // await _getAppNotice();
                                              } else {
                                                if (global.sp!.getString(
                                                        global.appLoadString) !=
                                                    null) {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              HomeScreen(
                                                                a: widget
                                                                    .analytics,
                                                                o: widget
                                                                    .observer,
                                                                selectedIndex:
                                                                    0,
                                                              )));
                                                } else {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              IntroSliderScreen(
                                                                a: widget
                                                                    .analytics,
                                                                o: widget
                                                                    .observer,
                                                              )));
                                                }
                                              }
                                            } else {
                                              showNetworkErrorSnackBar(
                                                  _scaffoldKey!);
                                            }
                                          },
                                          child: Text('Skip',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily:
                                                      fontRailwayRegular,
                                                  fontWeight: FontWeight.w200,
                                                  color:
                                                      ColorConstants.appColor)),
                                        ),
                                      ),
                                      Container(
                                        height: 20,
                                        width: 1,
                                        color: ColorConstants.grey,
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () async {
                                            global.sp!
                                                .setBool("UpdateClicked", true);
                                            Navigator.of(context).pop();
                                            print(global.appInfo.app_link);
                                            var url =
                                                "${global.appInfo.app_link}";
                                            if (await canLaunch(url))
                                              await launch(url);
                                            else
                                              // can't launch url, there is some error
                                              throw "Could not launch $url";
                                          },
                                          child: Text('Update',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily:
                                                      fontRailwayRegular,
                                                  fontWeight: FontWeight.w200,
                                                  color: Colors.blue.shade300)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // CupertinoAlertDialog(
                        //   title: Text(
                        //     '',
                        //   ),
                        //   content: Text(
                        //     '${msg}',
                        //     style: TextStyle(
                        //       fontSize: 14,
                        //       fontFamily: fontRailwayRegular,
                        //       fontWeight: FontWeight.w200,
                        //     ),
                        //   ),
                        //   actions: <Widget>[
                        //     CupertinoDialogAction(
                        //       child: Text('Update',
                        //           style: TextStyle(
                        //             fontSize: 16,
                        //             fontFamily: fontRailwayRegular,
                        //             fontWeight: FontWeight.w200,
                        //           )),
                        //       onPressed: () async {
                        //         Navigator.of(context).pop();
                        //         _updateForcefullyDialog(msg);
                        //         // global.sp.setBool("UpdateClicked", true);
                        //         // Navigator.of(context).pop();
                        //         // print(global.appInfo.app_link);
                        //         // var url = "${global.appInfo.app_link}";
                        //         // if (await canLaunch(url))
                        //         //   await launch(url);
                        //         // else
                        //         //   // can't launch url, there is some error
                        //         //   throw "Could not launch $url";
                        //       },
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(""),
                  ),
                ],
              ),
            );
          });

      // showCupertinoDialog(
      //     context: context,
      //     barrierDismissible: false,
      //     builder: (BuildContext context) {
      //       return Theme(
      //         data: ThemeData(dialogBackgroundColor: Colors.white),
      //         child: CupertinoAlertDialog(
      //           title: Image.asset(
      //             'assets/images/gift_rocket.png',
      //             width: 20,
      //             height: 20,
      //             fit: BoxFit.fill,
      //             color: ColorConstants.grey,
      //           ),
      //           content: Text(
      //             '${msg}',
      //             style: TextStyle(
      //                 fontSize: 14,
      //                 fontFamily: fontRailwayRegular,
      //                 fontWeight: FontWeight.w200,
      //                 color: ColorConstants.pureBlack),
      //           ),
      //           actions: <Widget>[
      //             CupertinoDialogAction(
      //               child: Text('Skip',
      //                   style: TextStyle(
      //                       fontSize: 16,
      //                       fontFamily: fontRailwayRegular,
      //                       fontWeight: FontWeight.w200,
      //                       color: ColorConstants.appColor)),
      //               onPressed: () async {
      //                 global.isSplashSelected = false;
      //                 bool isConnected = await br.checkConnectivity();
      //                 showOnlyLoaderDialog();
      //                 if (isConnected) {
      //                   if (global.sp.getString('currentUser') != null) {
      //                     global.currentUser = CurrentUser.fromJson(
      //                         json.decode(global.sp.getString("currentUser")));

      //                     if (global.sp.getString(global.appLoadString) !=
      //                         null) {
      //                       Navigator.of(context).push(MaterialPageRoute(
      //                           builder: (context) => HomeScreen(
      //                                 a: widget.analytics,
      //                                 o: widget.observer,
      //                                 selectedIndex: 0,
      //                               )));
      //                     } else {
      //                       Navigator.of(context).push(MaterialPageRoute(
      //                           builder: (context) => IntroSliderScreen(
      //                                 a: widget.analytics,
      //                                 o: widget.observer,
      //                               )));
      //                     }
      //                     // await _getAppNotice();
      //                   } else {
      //                     if (global.sp.getString(global.appLoadString) !=
      //                         null) {
      //                       Navigator.of(context).push(MaterialPageRoute(
      //                           builder: (context) => HomeScreen(
      //                                 a: widget.analytics,
      //                                 o: widget.observer,
      //                                 selectedIndex: 0,
      //                               )));
      //                     } else {
      //                       Navigator.of(context).push(MaterialPageRoute(
      //                           builder: (context) => IntroSliderScreen(
      //                                 a: widget.analytics,
      //                                 o: widget.observer,
      //                               )));
      //                     }
      //                   }
      //                 } else {
      //                   showNetworkErrorSnackBar(_scaffoldKey);
      //                 }
      //               },
      //             ),
      //             CupertinoDialogAction(
      //               child: Text(
      //                 'Update',
      //                 style: TextStyle(
      //                   fontSize: 16,
      //                   fontFamily: fontRailwayRegular,
      //                   fontWeight: FontWeight.w200,
      //                 ),
      //               ),
      //               onPressed: () async {
      //                 global.sp.setBool("UpdateClicked", true);
      //                 Navigator.of(context).pop();
      //                 print(global.appInfo.app_link);
      //                 var url = "${global.appInfo.app_link}";
      //                 if (await canLaunch(url))
      //                   await launch(url);
      //                 else
      //                   // can't launch url, there is some error
      //                   throw "Could not launch $url";
      //               },
      //             ),
      //           ],
      //         ),
      //       );
      //     });
    } catch (e) {
      print('Exception - app_menu_screen.dart - exitAppDialog(): ' +
          e.toString());
    }
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     if (global.sp != null &&
  //         global.sp.getBool("UpdateClicked") != null &&
  //         global.sp.getBool("UpdateClicked")) {
  //       global.sp.setBool("UpdateClicked", false);
  //       setState(() {
  //         sharedPrefs();
  //       });
  //     } else {
  //       print("resume");
  //     }
  //   }
  // }

  _updateForcefullyDialog(String msg) async {
    try {
      showCupertinoDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () async {
                _updateForcefullyDialog("");
                return true;
              },
              child: Theme(
                data: ThemeData(dialogBackgroundColor: Colors.white),
                child: Container(
                  color: ColorConstants.appbrownColor,
                  // decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //         image: AssetImage("assets/images/login_bg.png"),
                  //         fit: BoxFit.cover)),
                  child: Column(
                    children: [
                      Expanded(
                        child: Text(""),
                      ),
                      Stack(
                        children: [
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: Text(""),
                          //     ),
                          //     Container(
                          //       margin: EdgeInsets.only(top: 75),
                          //       decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(10),
                          //       ),
                          //       padding: EdgeInsets.only(
                          //           top: MediaQuery.of(context).size.width / 3.5,
                          //           left: 10,
                          //           right: 10),
                          //       child: Column(
                          //         children: [
                          //           SizedBox(
                          //             height: 15,
                          //           ),
                          //           Text(
                          //             '${msg}',
                          //             textAlign: TextAlign.center,
                          //             style: TextStyle(
                          //                 fontSize: 14,
                          //                 fontFamily: fontRailwayRegular,
                          //                 fontWeight: FontWeight.w200,
                          //                 color: ColorConstants.pureBlack),
                          //           ),
                          //           SizedBox(
                          //             height: 10,
                          //           ),
                          //           Container(
                          //             height: 1,
                          //             width:
                          //                 MediaQuery.of(context).size.width - 100,
                          //             color: ColorConstants.grey,
                          //           ),
                          //           SizedBox(
                          //             height: 10,
                          //           ),
                          //           Container(
                          //             padding: EdgeInsets.only(
                          //                 top: 8, bottom: 8, left: 15, right: 15),
                          //             decoration: BoxDecoration(
                          //                 color: ColorConstants.appColor,
                          //                 border: Border.all(
                          //                     color: ColorConstants.appColor,
                          //                     width: 1),
                          //                 borderRadius:
                          //                     BorderRadius.circular(10)),
                          //             child: GestureDetector(
                          //               onTap: () async {
                          //                 global.sp
                          //                     .setBool("UpdateClicked", true);
                          //                 Navigator.of(context).pop();
                          //                 print(global.appInfo.app_link);
                          //                 var url = "${global.appInfo.app_link}";
                          //                 if (await canLaunch(url))
                          //                   await launch(url);
                          //                 else
                          //                   // can't launch url, there is some error
                          //                   throw "Could not launch $url";
                          //               },
                          //               child: Text('Update',
                          //                   style: TextStyle(
                          //                       fontFamily: fontMontserratMedium,
                          //                       fontWeight: FontWeight.bold,
                          //                       fontSize: 16,
                          //                       color: ColorConstants.white,
                          //                       letterSpacing: 1)),
                          //             ),
                          //           ),
                          //           SizedBox(
                          //             height: 10,
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //     Expanded(
                          //       child: Text(""),
                          //     ),
                          //   ],
                          // ),

                          Row(
                            children: [
                              Expanded(
                                child: Text(""),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  global.sp!.setBool("UpdateClicked", true);
                                  Navigator.of(context).pop();
                                  print(global.appInfo.app_link);
                                  var url = "${global.appInfo.app_link}";
                                  if (await canLaunch(url))
                                    await launch(url);
                                  else
                                    // can't launch url, there is some error
                                    throw "Could not launch $url";
                                },
                                child: Image.asset(
                                  'assets/images/force_update.png',
                                  width: MediaQuery.of(context).size.width - 40,
                                  height:
                                      MediaQuery.of(context).size.height - 150,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Expanded(
                                child: Text(""),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // CupertinoAlertDialog(
                      //   title: Text(
                      //     '',
                      //   ),
                      //   content: Text(
                      //     '${msg}',
                      //     style: TextStyle(
                      //       fontSize: 14,
                      //       fontFamily: fontRailwayRegular,
                      //       fontWeight: FontWeight.w200,
                      //     ),
                      //   ),
                      //   actions: <Widget>[
                      //     CupertinoDialogAction(
                      //       child: Text('Update',
                      //           style: TextStyle(
                      //             fontSize: 16,
                      //             fontFamily: fontRailwayRegular,
                      //             fontWeight: FontWeight.w200,
                      //           )),
                      //       onPressed: () async {
                      //         Navigator.of(context).pop();
                      //         _updateForcefullyDialog(msg);
                      //         // global.sp.setBool("UpdateClicked", true);
                      //         // Navigator.of(context).pop();
                      //         // print(global.appInfo.app_link);
                      //         // var url = "${global.appInfo.app_link}";
                      //         // if (await canLaunch(url))
                      //         //   await launch(url);
                      //         // else
                      //         //   // can't launch url, there is some error
                      //         //   throw "Could not launch $url";
                      //       },
                      //     ),
                      //   ],
                      // ),

                      Expanded(
                        child: Text(""),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
    } catch (e) {
      print('Exception - app_menu_screen.dart - exitAppDialog(): ' +
          e.toString());
    }
  }

  Future<void> checkBiometric() async {
    bool canCheckBiometric;
    try {
      canCheckBiometric = await auth.canCheckBiometrics;
      print("Biometric supported: $canCheckBiometric");
    } on PlatformException catch (e) {
      print(e);
      canCheckBiometric = false;
    }
  }

  Future<void> getAvailableBiometrics() async {
    List<BiometricType> biometricTypes = [];
    try {
      biometricTypes = await auth.getAvailableBiometrics();
      print("supported biometrics $biometricTypes");
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) {
      return;
    }
    setState(() {
      print("this is available biometric set state called");
      global.availableBiometrics = biometricTypes;
      //global.availableBiometrics = biometricTypes;
    });
  }

  Future<void> authenticateWithBiometrics() async {
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;

      if (canCheckBiometrics) {
        await auth
            .authenticate(
                localizedReason: Platform.isIOS
                    ? 'Authenticate with Face ID'
                    : 'Authenticate with fingerprint or Face ID',
                options: const AuthenticationOptions(useErrorDialogs: false))
            .then((value) {
          print(value);
          if (value) {
            checkUpdate();
          }
          return;
        });
        if (!mounted) {
          // _sampleDialog("authenticateWithBiometrics");
          return;
        }
      }
    } on PlatformException catch (e) {
      checkUpdate();
      // _sampleDialog("nikhil this is the last pop up");
      print(e);
      return;
    }
  }

  _sampleDialog(String msg) async {
    try {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(dialogBackgroundColor: Colors.white),
              child: CupertinoAlertDialog(
                title: Text(
                  'byyu',
                ),
                content: Text(
                  '${msg}',
                  style: TextStyle(
                      fontSize: 20, fontFamily: global.fontMontserratLight),
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('OK',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: fontRailwayRegular,
                            fontWeight: FontWeight.w200,
                            color: Colors.blue)),
                    onPressed: () async {
                      Navigator.of(context).pop();
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
