import 'dart:io';
import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/productFilterModel.dart';
import 'package:byyu/screens/auth/login_screen.dart';
import 'package:byyu/screens/order/checkout_screen.dart';
import 'package:byyu/screens/order/coupons_screen.dart';
import 'package:byyu/screens/product/all_categories_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
//   
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:byyu/controllers/user_profile_controller.dart';
import 'package:byyu/models/addressModel.dart';
import 'package:byyu/models/appInfoModel.dart';
import 'package:byyu/models/localNotificationModel.dart';

import 'package:byyu/models/nearByStoreModel.dart';

import 'package:byyu/models/userModel.dart';
// import 'package:simple_drawer/simple_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

List<Address1> addressList = [];
List<BiometricType> availableBiometrics = [];
bool? stayLoggedIN;
// APIHelper apiHelper;
String? appDeviceId;
AppInfo appInfo = new AppInfo();
String appName = 'byyu';
String facebookAppID = '1018363386048764';
String facebookAppSecretKey = '1d9cb261d1b06c714f09798115fa5669';
String appShareMessage =
    "I'm inviting you to use $appName, a simple and easy app to find all required products near by your location. Here's my code [CODE] - jusy enter it while registration.";
String appVersion = '1.0';


// String imageBaseUrl = 'https://byyu.com/admin/';  // this is old live image base url without CDN
String imageBaseUrl = 'https://byyu.b-cdn.net/';
String catImageBaseUrl = 'https://byyu.com/admin/';
// String catImageBaseUrl = 'https://byyu.com/adminDev/';

String baseUrl = 'https://byyu.com/admin/api/'; //this is live base URL
// String baseUrl = 'https://byyu.com/adminDev/api/'; //this  is devBaseUrl
String nodeBaseUrl = 'http://node.byyu.com/api/';//'https://byyu.com/admin/api/'; //node this is live base URL
// String nodeBaseUrl = 'https://byyu.com/adminDev/api/'; //node this is live base URL


String totalWeeksCount = "1";
int cartCount = 0, isBannerShow = 0, wishlistCount = 0;
bool cartItemsPresent = false;
int total_delivery_count = 1;
List<Color> colorList = [
  Color(0xFF4DD0E1),
  Color(0xFFAB47BC),
];
bool isSplashSelected = false;
AppLifecycleState appLifecycleState = AppLifecycleState.detached;


var sAnalytics;
var sObserver;
int? isSubscription = 1, selectedCardIDN;
String? currentLocation, selctedSubCatN;
bool currentLocationSelected = false;
CurrentUser currentUser = new CurrentUser();
String defaultImage = 'assets/images/icon.png';
String noImage = 'assets/images/noImageAvailable.png';
String catNoImage = 'assets/images/noImageAvailable.png';
String refferalCode = '';
String occasionName = '';
String relationshipID = '';
String genderID = '';
String maxAge = '';
String minAge = '';
String ageID = '';
String occasionID = '';
String productSearchText = '';
int routingProductID = 0;
int routingCategoryID = 0;
int routingEventID = 0;
bool iscatListRouting = false;
bool isEventListRouting = false;
String routingCategoryName = "";
String routingEventName = "";
bool goToCorporatePage = false;
String pleaseLogin =
    '"Login to add a personal touch to your gifting adventures."';

String googleMapAPIKey = "AIzaSyCSfEYjknao_GTrv0-kIifoqxAWPzvCcJ0";
String tapPaySecreatKey = "sk_test_ajGboS2ldW1ELpmvMqtsIi3Q";
String tapPayPublicKey = "pk_test_8T2e6jxckiIlW5shOJwBESgA";

String tapPayMobileSecretKey = "sk_test_rIP7Ad6beyxonMHmLOw3gp42";

String tapPayMobileLiveSecretKey = "sk_live_qEcXkL49WN8fYrP7d0avihpn";

String arabicDubai = "دبي";

ShowFilters globalShowFilters = new ShowFilters();

// Secret Live key: sk_live_sfoPDbkCELzmGJBwrUjuI8H1
// Secret Test key: sk_test_0gOsFJvfd9WMuXl3n64pSyk7

//########################## SEO parametrs from deeplinks
String? utmSource;
String? utmCampaign;
String? utmNetwork;
String? utmMedium;
String? utmKeyword;
String? placement;

bool isSubCatSelected = false;
String imageUploadMessageKey = 'w0daAWDk81';
bool isChatNotTapped = false;
String languageCode = 'en';
double? lat;
double? lng;
bool isRTL = false;
List<String> rtlLanguageCodeLList = [
  'ar',
  'arc',
  'ckb',
  'dv',
  'fa',
  'ha',
  'he',
  'khw',
  'ks',
  'ps',
  'ur',
  'uz_AF',
  'yi'
];

LocalNotification localNotificationModel = new LocalNotification();
String locationMessage = '';
NearStoreModel nearStoreModel = new NearStoreModel();
String? selectedImage;
SharedPreferences? sp;
String appLoadString = "isFirstAppLoad";
String quickLoginEnabled = "quickLoginEnabled";
String isLoggedIn = "isLoggedIn";
String strCheckInternet = "Please check your internet connection";
String strWentWrong = "Something went wrong";
bool isNavigate = false;
String stripeBaseApi = 'https://api.stripe.com/v1';
var orderApiRazorpay = Uri.parse('https://api.razorpay.com/v1/orders');
final UserProfileController userProfileController =
    Get.put(UserProfileController());

Future<Map<String, String>> getApiHeaders(bool authorizationRequired) async {
  Map<String, String> apiHeader = new Map<String, String>();

  apiHeader.addAll({"Content-Type": "application/json"});
  apiHeader.addAll({"Accept": "application/json"});
  return apiHeader;
}



Color indigoColor = Color(0xffF13613);
Color white = Colors.white;
Color yellow = Color(0xffffde34);
Color yellow1 = Color.fromARGB(255, 240, 214, 83);

bool isShowAlert = false;

Color bgCompletedColor = Color(0xffe20312);
Color completedTextColor = Color(0xffF13613);
Color searchBox = Color(0xffF2F2F2);

Color pauseBgColor = Color(0xffff8D34);
Color pauseTextColor = Color(0xffD55E00);

Color bgNormalCard = Color(0xffDDDDDD);
Color cardColor = Color(0xffFFFFFF);
Color cardTextColor = Color(0xff5F5F5F);
Color orderInfoCardColor = Color(0xffF3F3F3);
Color whitebackground = Color(0xfff7f7f7);
Color selectedCard = Color(0xffDE1F28).withOpacity(0.28);
Color skipColor = Color(0xff2B2A2A);
Color whiteCircle = Color(0xffD4D4D4);
Color greyText = Color(0xffB6B7B7);
Color textGrey = Color(0xff7C7D7E);

int selectedMainCategory = -1;
int selectedSubCategory = -1;
List<String> allMonths = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];

List<String> homeScrollingTitles = [
  "10% OFF ON ALL ORDERS",
  "PREMIUM QUALITY PRODUCTS",
  "CUSTOMISABLE GIFTS        "
];

TextStyle errorTextStyle = TextStyle(
    fontFamily: fontMontserratMedium,
    fontWeight: FontWeight.w200,
    fontSize: 10,
    color: ColorConstants.appColor,
    letterSpacing: 1);

const fontAdelia = 'Adelia';
const fontMontserratLight = 'metropolis_semi_bold';
const fontMontserratMedium = 'metropolis_medium';
const fontMetropolisRegular = 'metropolis_regular';

const fontOufitMedium = 'Outfit-Medium';
const fontRalewayMedium = 'Raleway-Medium';
const fontRailwayRegular = 'Raleway-Regular';
DateFormat monthInStrFormat = DateFormat("yyyy-MMMM-dd");
DateFormat monthInIntFormt = DateFormat("yyyy-MM-dd");
DateFormat dateandtime = DateFormat("yyyy-MM-dd HH:mm");
DateFormat dateOnly = DateFormat("yyyy-MM-dd");
DateFormat dateMonthFormat = DateFormat("dd-MM");
DateFormat hourMinTime = DateFormat("hh:mm a");
DateFormat onlyHourTime = DateFormat("hh");
DateFormat onlyMonth = DateFormat("MMMM");
DateFormat onlydate = DateFormat("dd");

int homeSelectedCatID = -1;
int parentCatID = -1;
bool isEventProduct = false;

bool globalHomeLoading = false;

var globalDeviceId = "";

getDeviceID() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    var iosDeviceInfo = await deviceInfo.iosInfo;
    String? deviceid = iosDeviceInfo.identifierForVendor;
    return deviceid;
  } else if (Platform.isAndroid) {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    String deviceid = androidDeviceInfo.id;
    return deviceid;
  }
}

_signOutDialog(context, a, o) {
  try {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return Theme(
            data: ThemeData(dialogBackgroundColor: Colors.white),
            child: CupertinoAlertDialog(
              title: Text(
                'Logout',
                style:
                    TextStyle(fontFamily: fontMetropolisRegular, fontSize: 14),
              ),
              content: Text(
                'Are you sure you want to logout',
                style:
                    TextStyle(fontFamily: fontMetropolisRegular, fontSize: 12),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: fontMetropolisRegular,
                        color: ColorConstants.appColor),
                  ),
                  onPressed: () {
                    return Navigator.of(context).pop(false);
                  },
                ),
                CupertinoDialogAction(
                  child: Text('Logout',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: fontMetropolisRegular,
                          fontWeight: FontWeight.w200,
                          color: Colors.blue)),
                  onPressed: () async {
                    sp!.remove("currentUser");
                    currentUser = CurrentUser();
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    await preferences.clear();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LoginScreen(a: a, o: o)));
                  },
                ),
              ],
            ),
          );
        });
  } catch (e) {
    print(
        'Exception - app_menu_screen.dart - exitAppDialog(): ' + e.toString());
  }
}

// sideDrawer(context, a, o) {
//   Widget bottomSimpleDrawer = SimpleDrawer(
//     simpleDrawerAreaWidth: 200,
//     fadeColor: Colors.green,
//     simpleDrawerAreaHeight: MediaQuery.of(context).size.height / 2,
//     child: Container(
//       color: Colors.transparent,
//       width: 10,
//     ),
//     childWidth: 5,
//     direction: Direction.left,
//     id: "left",
//   );

//   return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Container(
//           width: MediaQuery.of(context).size.width / 1.45,
//           height: MediaQuery.of(context).size.height,
//           color: Colors.white,
//           child:
//               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             const SizedBox(
//               height: 30,
//             ),
//             Container(
//               width: MediaQuery.of(context).size.width / 1.45,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Container(
//                     color: ColorConstants.appfaintColor,
//                     padding: EdgeInsets.all(8),
//                     child: Image.asset(
//                       "assets/images/byyu_logo_no_tag.png",
//                       fit: BoxFit.contain,
//                       height: 40,
//                       width: double.infinity,
//                       alignment: Alignment.center,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 5,
//             ),
//             Container(
//               height: 30,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     elevation: 0, backgroundColor: Colors.transparent),
//                 onPressed: () async {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                         builder: (context) => AllCategoriesScreen(
//                               a: a,
//                               o: o,
//                             )),
//                   );
//                 },
//                 child: Padding(
//                   padding: EdgeInsets.all(1.0),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Image.asset(
//                         'assets/images/iv_category.png',
//                         width: 20,
//                         height: 20,
//                         fit: BoxFit.fill,
//                         color: ColorConstants.grey,
//                       ),
//                       SizedBox(width: 10),
//                       Text("All Categories",
//                           style: TextStyle(
//                               fontFamily: fontMontserratLight,
//                               color: ColorConstants.grey,
//                               fontWeight: FontWeight.w200,
//                               fontSize: 15))
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               height: 30,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     elevation: 0, backgroundColor: Colors.transparent),
//                 onPressed: () async {},
//                 child: Padding(
//                   padding: EdgeInsets.all(1.0),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Image.asset(
//                         'assets/images/festivals.png',
//                         width: 20,
//                         height: 20,
//                         fit: BoxFit.fill,
//                         color: ColorConstants.grey,
//                       ),
//                       SizedBox(width: 10),
//                       Text("Festivals",
//                           style: TextStyle(
//                               fontFamily: fontMontserratLight,
//                               color: ColorConstants.grey,
//                               fontWeight: FontWeight.w200,
//                               fontSize: 15))
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               height: 30,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     elevation: 0, backgroundColor: Colors.transparent),
//                 onPressed: () async {},
//                 child: Padding(
//                   padding: EdgeInsets.all(1.0),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         MdiIcons.cartCheck,
//                         size: 20,
//                         color: ColorConstants.grey,
//                       ),
//                       SizedBox(width: 10),
//                       Text("My Orders",
//                           style: TextStyle(
//                               fontFamily: fontMontserratLight,
//                               color: ColorConstants.grey,
//                               fontWeight: FontWeight.w200,
//                               fontSize: 15))
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               height: 30,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     elevation: 0, backgroundColor: Colors.transparent),
//                 onPressed: () async {},
//                 child: Padding(
//                   padding: EdgeInsets.all(1.0),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Image.asset(
//                         'assets/images/offers.png',
//                         width: 20,
//                         height: 20,
//                         fit: BoxFit.fill,
//                         color: ColorConstants.grey,
//                       ),
//                       SizedBox(width: 10),
//                       Text("Offers",
//                           style: TextStyle(
//                               fontFamily: fontMontserratLight,
//                               color: ColorConstants.grey,
//                               fontWeight: FontWeight.w200,
//                               fontSize: 15))
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               height: 30,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     elevation: 0, backgroundColor: Colors.transparent),
//                 onPressed: () async {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                         builder: (context) => CouponsScreen(
//                               a: a,
//                               o: o,
//                               fromDrawer: true,
//                             )),
//                   );
//                 },
//                 child: Padding(
//                   padding: EdgeInsets.all(1.0),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Image.asset(
//                         'assets/images/coupons.png',
//                         width: 20,
//                         height: 20,
//                         fit: BoxFit.fill,
//                         color: ColorConstants.grey,
//                       ),
//                       SizedBox(width: 10),
//                       Text("Coupons",
//                           style: TextStyle(
//                               fontFamily: fontMontserratLight,
//                               color: ColorConstants.grey,
//                               fontWeight: FontWeight.w200,
//                               fontSize: 15))
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               height: 30,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     elevation: 0, backgroundColor: Colors.transparent),
//                 onPressed: () async {},
//                 child: Padding(
//                   padding: EdgeInsets.all(1.0),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Image.asset(
//                         'assets/images/transaction_history.png',
//                         width: 20,
//                         height: 20,
//                         fit: BoxFit.fill,
//                         color: ColorConstants.grey,
//                       ),
//                       SizedBox(width: 10),
//                       Text("Transaction History",
//                           style: TextStyle(
//                               fontFamily: fontMontserratLight,
//                               color: ColorConstants.grey,
//                               fontWeight: FontWeight.w200,
//                               fontSize: 15))
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               height: 30,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     elevation: 0, backgroundColor: Colors.transparent),
//                 onPressed: () async {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                         builder: (context) => CheckoutScreen(
//                               a: a,
//                               o: o,
//                             )),
//                   );
//                 },
//                 child: Padding(
//                   padding: EdgeInsets.all(1.0),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Image.asset(
//                         'assets/images/your_address.png',
//                         width: 20,
//                         height: 20,
//                         fit: BoxFit.fill,
//                         color: ColorConstants.grey,
//                       ),
//                       SizedBox(width: 10),
//                       Text("Your Address",
//                           style: TextStyle(
//                               fontFamily: fontMontserratLight,
//                               color: ColorConstants.grey,
//                               fontWeight: FontWeight.w200,
//                               fontSize: 15))
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               margin: EdgeInsets.only(left: 8, right: 8),
//               child: const Divider(
//                 color: ColorConstants.drawerDividerColor,
//                 height: 0.5,
//               ),
//             ),
//             Container(
//               height: 30,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     elevation: 0, backgroundColor: Colors.transparent),
//                 onPressed: () async {},
//                 child: Padding(
//                   padding: EdgeInsets.all(1.0),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Image.asset(
//                         'assets/images/iv_terms_condition.png',
//                         width: 20,
//                         height: 20,
//                         fit: BoxFit.fill,
//                         color: ColorConstants.grey,
//                       ),
//                       SizedBox(width: 10),
//                       Text("Terms & Condition",
//                           style: TextStyle(
//                               fontFamily: fontMontserratLight,
//                               color: ColorConstants.grey,
//                               fontWeight: FontWeight.w200,
//                               fontSize: 15))
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               height: 30,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     elevation: 0, backgroundColor: Colors.transparent),
//                 onPressed: () async {},
//                 child: Padding(
//                   padding: EdgeInsets.all(1.0),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         Icons.privacy_tip,
//                         size: 20,
//                         color: ColorConstants.grey,
//                       ),
//                       SizedBox(width: 10),
//                       Text("Privacy Policy",
//                           style: TextStyle(
//                               fontFamily: fontMontserratLight,
//                               color: ColorConstants.grey,
//                               fontWeight: FontWeight.w200,
//                               fontSize: 15))
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               height: 30,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     elevation: 0, backgroundColor: Colors.transparent),
//                 onPressed: () async {},
//                 child: Padding(
//                   padding: EdgeInsets.all(1.0),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         Icons.contact_support_outlined,
//                         size: 20,
//                         color: ColorConstants.grey,
//                       ),
//                       SizedBox(width: 10),
//                       Text("Contact Us",
//                           style: TextStyle(
//                               fontFamily: fontMontserratLight,
//                               color: ColorConstants.grey,
//                               fontWeight: FontWeight.w200,
//                               fontSize: 15))
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               height: 30,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     elevation: 0, backgroundColor: Colors.transparent),
//                 onPressed: () async {},
//                 child: Padding(
//                   padding: EdgeInsets.all(1.0),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         Icons.star_rate_rounded,
//                         size: 20,
//                         color: ColorConstants.grey,
//                       ),
//                       SizedBox(width: 10),
//                       Text("Rate the app",
//                           style: TextStyle(
//                               fontFamily: fontMontserratLight,
//                               color: ColorConstants.grey,
//                               fontWeight: FontWeight.w200,
//                               fontSize: 15))
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               height: 30,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     elevation: 0, backgroundColor: Colors.transparent),
//                 onPressed: () async {},
//                 child: Padding(
//                   padding: EdgeInsets.all(1.0),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         Icons.settings,
//                         size: 20,
//                         color: ColorConstants.grey,
//                       ),
//                       SizedBox(width: 10),
//                       Text("Settings",
//                           style: TextStyle(
//                               fontFamily: fontMontserratLight,
//                               color: ColorConstants.grey,
//                               fontWeight: FontWeight.w200,
//                               fontSize: 15))
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               height: 30,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     elevation: 0, backgroundColor: Colors.transparent),
//                 onPressed: () async {
//                   if (currentUser.id == null) {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => LoginScreen(a: a, o: o)));
//                   } else {
//                     _signOutDialog(context, a, o);
//                   }
//                 },
//                 child: Padding(
//                   padding: EdgeInsets.all(1.0),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         Icons.logout,
//                         size: 24,
//                         color: ColorConstants.grey,
//                       ),
//                       SizedBox(width: 10),
//                       Text("Log out",
//                           style: TextStyle(
//                               fontFamily: fontMontserratLight,
//                               color: ColorConstants.grey,
//                               fontWeight: FontWeight.w200,
//                               fontSize: 15))
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Container(
//                   margin: EdgeInsets.only(bottom: 20),
//                   child: Wrap(
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             //color: Colors.amber,
//                             margin: EdgeInsets.only(left: 10, right: 10),
//                             child: Text("Follow us:-",
//                                 style: TextStyle(
//                                     fontFamily: fontMontserratLight,
//                                     color: ColorConstants.grey,
//                                     fontWeight: FontWeight.w200,
//                                     fontSize: 15)),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           InkWell(
//                             onTap: () {
//                               _launchSocialMediaAppIfInstalled(
//                                 url:
//                                     'https://www.facebook.com/profile.php?id=61551455799889', // Facebook
//                               );
//                             },
//                             child: Container(
//                               //color: Colors.amber,
//                               margin: EdgeInsets.only(left: 10, top: 10),
//                               child: Image.asset(
//                                 'assets/images/facebook_icon.png',
//                                 color: ColorConstants.fbIconColor,
//                                 height: 25,
//                                 width: 25,
//                                 fit: BoxFit.contain,
//                               ),
//                             ),
//                           ),
//                           InkWell(
//                             onTap: () {
//                               _launchSocialMediaAppIfInstalled(
//                                   url: "https://www.instagram.com/byyuonline/");
//                             },
//                             child: Container(
//                               margin: EdgeInsets.only(left: 10, top: 10),
//                               child: Image.asset(
//                                 'assets/images/instagram.png',
//                                 height: 25,
//                                 width: 25,
//                                 fit: BoxFit.contain,
//                               ),
//                             ),
//                           ),
//                           InkWell(
//                             onTap: () {
//                               _launchSocialMediaAppIfInstalled(
//                                   url: "https://twitter.com/byyuonline");
//                             },
//                             child: Container(
//                               margin: EdgeInsets.only(left: 10, top: 10),
//                               child: Image.asset(
//                                 'assets/images/twitter_icon.png',
//                                 color: ColorConstants.pureBlack,
//                                 height: 25,
//                                 width: 25,
//                                 fit: BoxFit.fill,
//                               ),
//                             ),
//                           ),
//                           InkWell(
//                             onTap: () {
//                               _launchSocialMediaAppIfInstalled(
//                                   url:
//                                       "https://www.linkedin.com/company/98773769/admin/feed/posts/");
//                             },
//                             child: Container(
//                               margin:
//                                   EdgeInsets.only(left: 10, right: 10, top: 10),
//                               child: Image.asset(
//                                 'assets/images/linkedin.png',
//                                 height: 25,
//                                 width: 25,
//                                 fit: BoxFit.fill,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Container(
//                           margin: EdgeInsets.only(left: 10, right: 10, top: 10),
//                           child: Text("Version: 1.0.0",
//                               style: TextStyle(
//                                   fontFamily: fontMontserratLight,
//                                   color: ColorConstants.grey,
//                                   fontWeight: FontWeight.w200,
//                                   fontSize: 15))),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ])));
// }

Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

Future<void> _launchSocialMediaAppIfInstalled({
  String? url,
}) async {
  try {
    bool launched = await launch(url!, forceSafariVC: false);

    if (!launched) {
      launch(url);
    }
  } catch (e) {
    launch(url!);
  }
}

String getFormattedDate(String date) {
  if (date.isNotEmpty || date != null || date != "") {
    var utc = DateTime.parse("$date Z");

    var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    var inputDate = inputFormat.parse(utc.toLocal().toString());
    var outputFormat = DateFormat('yyyy-MM-dd hh:mm a');
    var outputDate = outputFormat.format(inputDate);

    return outputDate.toString();
  } else {
    return "";
  }
}

String getlocaleNotifyTime(String date) {
  if (date.isNotEmpty || date != null || date != "") {
    print(date);
    var dateTime = DateFormat("yyyy-MM-dd HH:mm").parse(date, false);
    // var dateLocal = dateTime.toLocal();

    return dateTime.toString();
  } else {
    return "";
  }
}



showLoaderTransparent(context) {
  return showDialog(
    barrierColor: Colors.transparent,
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        child: Center(
            child: new CircularProgressIndicator(
          strokeWidth: 5,
        )),
      );
    },
  );
}

void hideloaderTransparent(context) {
  Navigator.pop(context);
}

void showToastMSG(String msg){
  Fluttertoast.showToast(
          msg: msg, // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.CENTER, // location
          // duration
        );  
}
