import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:byyu/dialog/openImageDialog.dart';
import 'package:byyu/models/businessLayer/apiHelper.dart';
import 'package:byyu/models/businessLayer/businessRule.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/imageModel.dart';
import 'package:byyu/models/userModel.dart';
import 'package:byyu/screens/auth/login_screen.dart';
import 'package:byyu/screens/auth/otp_verification_screen.dart';
import 'package:byyu/screens/product/product_description_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:byyu/widgets/toastfile.dart';

class Base extends StatefulWidget {
  final FirebaseAnalytics? analytics;
  final FirebaseAnalyticsObserver? observer;

  final String? routeName;

  Base({this.analytics, this.observer, this.routeName});

  @override
  BaseState createState() => BaseState();

  void showNetworkErrorSnackBar(GlobalKey<ScaffoldState> scaffoldKey) {}
}

class BaseState extends State<Base>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool bannerAdLoaded = false;
  late APIHelper apiHelper;

  BusinessRule? br;
  GlobalKey<ScaffoldState>? _scaffoldKey;

  BaseState() {
    apiHelper = new APIHelper();
    br = new BusinessRule(apiHelper);
  }

  Future<bool> addRemoveWishList(int varientId) async {
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

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void closeDialog() {
    Navigator.of(context).pop();
  }

  dialogToOpenImage(String name, List<ImageModel> imageList, int index) {
    try {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return OpenImageDialog(
              a: widget.analytics,
              o: widget.observer,
              imageList: imageList,
              index: index,
              name: name,
            );
          });
    } catch (e) {
      print("Exception - base.dart - dialogToOpenImage() " + e.toString());
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    print('appLifeCycleState inactive');

    if (global.sp != null && global.sp!.getString("currentUser") != null) {
      if (global.localNotificationModel != null && !global.isChatNotTapped) {
        global.currentUser = CurrentUser.fromJson(
            json.decode(global.sp!.getString("currentUser")!));
        if (global.localNotificationModel.route == 'chatlist_screen') {
          if (state == AppLifecycleState.resumed) {
            setState(() {
              global.isChatNotTapped = true;
            });
          }
        }
      }
    } else if (global.localNotificationModel != null &&
        global.localNotificationModel.chatId != null &&
        !global.isChatNotTapped) {
      if (state == AppLifecycleState.resumed) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => LoginScreen(
                  a: widget.analytics,
                  o: widget.observer,
                )));
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> dontCloseDialog() async {
    return false;
  }

  Future exitAppDialog() async {
    try {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(dialogBackgroundColor: Colors.white),
              child: CupertinoAlertDialog(
                title: Text(
                  "Exit app",
                  style: TextStyle(
                    fontFamily: 'AvenirLTStd',
                  ),
                ),
                content: Text("Do you want to exit app?",
                    style: TextStyle(
                      fontFamily: 'AvenirLTStd',
                    )),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: ColorConstants.appColor,
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
                      "Exit",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: fontMetropolisRegular,
                          fontWeight: FontWeight.w200,
                          color: Colors.blue),
                    ),
                    onPressed: () async {
                      exit(0);
                    },
                  ),
                ],
              ),
            );
          });
    } catch (e) {
      print('Exception - base.dart - exitAppDialog(): ' + e.toString());
    }
  }

  getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(global.lat!, global.lng!);

      Placemark place = placemarks[0];

      setState(() {
        global.currentLocation = "Current Location";
      });
    } catch (e) {
      hideLoader();
      print("Exception - base.dart - getAddressFromLatLng():" + e.toString());
    }
  }

  Future<void> getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) async {
      setState(() {
        global.lat = position.latitude;
        global.lng = position.longitude;
        print('G1---->${position.latitude} && ${position.longitude}');
      });
      await getAddressFromLatLng();
      await getNearByStore();
    }).catchError((e) async {
      print(
          "Exception 122 -  base.dart - getCurrentLocation():" + e.toString());
      if (e.toString().contains(
          "User denied permissions to access the device's location.")) {
        print('G1---isLocationSelected---> 111');
        SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('isLocationSelected', "false");
        if (Platform.isIOS) {
          _showPermissionDialog();
        }
        setState(() {});
      }
    });
    return;
  }

  _showPermissionDialog() async {
    try {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(dialogBackgroundColor: Colors.white),
              child: CupertinoAlertDialog(
                title: Text(
                  'Location Permisstion',
                ),
                content: Text(
                  "You have denied permissions to access the device's location. Please allow the location permission",
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('OK',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: fontMetropolisRegular,
                            fontWeight: FontWeight.w200,
                            color: Colors.blue)),
                    onPressed: () async {
                      Navigator.of(context).pop(false);
                      openAppSettings();
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

  Future<void> getCurrentPosition() async {
    try {
      if (Platform.isIOS) {
        LocationPermission s = await Geolocator.checkPermission();
        if (s == LocationPermission.denied ||
            s == LocationPermission.deniedForever) {
          s = await Geolocator.requestPermission();
        }
        if (s != LocationPermission.denied ||
            s != LocationPermission.deniedForever) {
          await getCurrentLocation();
        } else {
          global.locationMessage =
              "Please enable location permission to use appp";
        }
      } else {
        PermissionStatus permissionStatus = await Permission.location.status;
        if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
          permissionStatus = await Permission.location.request();
        }
        if (permissionStatus.isGranted) {
          await getCurrentLocation();
        } else {
          global.locationMessage =
              "Please enable location permission to use appp";
        }
      }
    } catch (e) {
      hideLoader();
      print("Exception -  base.dart - getCurrentPosition():" + e.toString());
    }

    return;
  }

  Future<void> getNearByStore() async {
    try {
      await apiHelper.getNearbyStore().then((result) async {
        if (result != null) {
          if (result.status == "1") {
            global.nearStoreModel = result.data;
            if (global.appInfo.lastLoc == 1) {
              global.sp!.setString("lastloc", '${global.lat}|${global.lng}');
            }
          } else if (result.status == "0") {
            global.locationMessage = result.message;
          }
        }
      });
    } catch (e) {
      hideLoader();
      print("Exception -  base.dart - _getNearByStore():" + e.toString());
    }

    return;
  }

  void hideLoader() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
  }

  sendOTP(String phoneNumber, {int? screenId}) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+${global.appInfo.countryCode}$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          hideLoader();
          showSnackBar(
              key: _scaffoldKey,
              snackBarMessage: 'Please try again after sometime');
        },
        codeSent: (String verificationId, int? resendToken) async {
          hideLoader();
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => OtpVerificationScreen(
                      a: widget.analytics,
                      o: widget.observer,
                      verificationCode: verificationId,
                      phoneNumber: phoneNumber,
                    )),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      hideLoader();
      print("Exception - base.dart - _sendOTP():" + e.toString());
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  showNetworkErrorSnackBar(GlobalKey<ScaffoldState> scaffoldKey) {
    try {
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
            textColor: Colors.white, label: 'RETRY', onPressed: () async {}),
        backgroundColor: Colors.grey,
      ));
    } catch (e) {
      print("Exception -  base.dart - showNetworkErrorSnackBar():" +
          e.toString());
    }
  }

  showOnlyLoaderDialog() {
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

  void showSnackBar({String? snackBarMessage, GlobalKey<ScaffoldState>? key}) {
    showToast(snackBarMessage!);
  }

  void showSnackBarWithDuration(
      {String? snackBarMessage, GlobalKey<ScaffoldState>? key}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      key: key,
      content: Text(
        snackBarMessage!,
        textAlign: TextAlign.center,
      ),
      duration: Duration(seconds: 5),
    ));
  }

  
}
