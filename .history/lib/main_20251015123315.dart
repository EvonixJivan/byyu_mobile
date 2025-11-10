import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
// import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
//import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:byyu/l10n/l10n.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/userModel.dart';
// import 'package:byyu/provider/local_provider.dart';
import 'package:byyu/screens/home_screen.dart';
import 'package:byyu/screens/auth/intro_screen.dart';
import 'package:byyu/screens/notification_screen.dart';
import 'package:byyu/screens/splash_screen1.dart';
import 'package:byyu/theme/style.dart';
import 'package:byyu/widgets/toastfile.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'models/appInfoModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  /// 👇 Ensure the system UI overlays are *enabled* and not edge-to-edge
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: SystemUiOverlay.values,
  );

  /// 👇 Apply the global navigation + status bar colors
  const overlayStyle = SystemUiOverlayStyle(
    systemNavigationBarColor: ColorConstants.white,
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarColor: ColorConstants.white,
    statusBarIconBrightness: Brightness.dark,
  );

  SystemChrome.setSystemUIOverlayStyle(overlayStyle);
//SAFE AREA CODE
  runApp(
    AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: SafeArea(
        top: false,
        bottom: true,
        child: App(),
      ),
    ),
  );
}

AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', 'High Importance Notifications',
    importance: Importance.high,
    description: 'Channel Description',
    playSound: true);
//FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
    print('Handling a background message ${message.messageId}');
  } catch (e) {
    print('Exception - main.dart - _firebaseMessagingBackgroundHandler(): ' +
        e.toString());
  }
}

// GoRouter _goRouter=

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  //FirebaseMessaging messaging = FirebaseMessaging.instance;
  final String routeName = "main";
  GlobalKey<ScaffoldState>? _scaffoldKey;
  String? isLogin;
  // String _deepLinkUrl = 'Unknown';
  // FlutterFacebookSdk facebookDeepLinks;
  Future<void> checkUpdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userInfoJson = prefs.getString("userInfo");
    print('G1---->005');
    if (userInfoJson == null) {
      global.currentUser = CurrentUser.fromJson(json.decode(userInfoJson!));
    }
  }

  GoRouter _appRoute = GoRouter(
    errorBuilder: (context, state) => SplashScreen1(
      a: analytics,
      o: observer,
    ),
    routes: <RouteBase>[
      GoRoute(
        path: "/",
        builder: (BuildContext context, GoRouterState state) {
          print("1.this is the full uri${state.uri}");
          global.refferalCode = "";
          global.productSearchText = "";
          if (global.iscatListRouting) {
            global.iscatListRouting = false;
          }
          return SplashScreen1(
            a: analytics,
            o: observer,
          );
        },
      ),
      // https://byyu.com/sharing/product?id=175

      GoRoute(
        path: '/sharing/product',
        builder: (BuildContext context, GoRouterState state) {
          print("2.this is the full uri${state.uri}");
          global.productSearchText = "";
          if (global.routingEventID != 0) {
            global.routingEventID = 0;
          }
          Uri uri = state.uri;
          print(uri.queryParameters['id']);
          // global.routingProductID = int.parse(
          //     uri.toString().substring(uri.toString().lastIndexOf("/") + 1));
          if (uri.queryParameters == null) {
            global.routingProductID = 0;
          } else {
            global.routingProductID =
                int.parse(uri.queryParameters['id'].toString());
          }
          if (global.iscatListRouting) {
            global.iscatListRouting = false;
          }
          if (uri.queryParameters != null && uri.queryParameters.length > 0) {
            global.utmSource = uri.queryParameters["utm_source"] != null
                ? uri.queryParameters["utm_source"]!
                : "webShare";
            global.utmNetwork = uri.queryParameters["utm_network"] != null
                ? uri.queryParameters["utm_network"]!
                : "webShare";
            global.utmKeyword = uri.queryParameters["utm_keyword"] != null
                ? uri.queryParameters["utm_keyword"]!
                : "product-list-id${global.routingProductID}";
            global.utmCampaign = uri.queryParameters["utm_campaign"] != null
                ? uri.queryParameters["utm_campaign"]!
                : "webShare";
            global.utmMedium = uri.queryParameters["utm_medium"] != null
                ? uri.queryParameters["utm_medium"]!
                : "webShare";
            global.utmMedium = uri.queryParameters["utm_medium"] != null
                ? uri.queryParameters["utm_medium"]!
                : "webShare";
            global.placement = uri.queryParameters["placement"] != null
                ? uri.queryParameters["placement"]!
                : "webShare";
          } else {
            global.utmSource = "webShare";
            global.utmNetwork = "webShare";
            global.utmKeyword = "product-list-id${global.routingProductID}";
            global.utmCampaign = "webShare";
            global.utmMedium = "webShare";
            global.utmMedium = "webShare";
            global.placement = "webShare";
          }
          print(global.routingProductID);
          return SplashScreen1(
            a: analytics,
            o: observer,
          );
        },
      ),
      /////#####Event Product list routing#############updated Routing for https://byyu.com/event-product-list/specialdays-1
      GoRoute(
        path: '/event-product-list/:eventID',
        builder: (BuildContext context, GoRouterState state) {
          print("event-product-list.this is the full uri${state.uri}");
          if (global.routingProductID != 0) {
            global.routingProductID = 0;
          }
          global.productSearchText = "";

          global.iscatListRouting = false;
          Uri uri = state.uri;
          String eventString = uri.toString().contains("?")
              ? uri.toString().substring(uri.toString().lastIndexOf("/") + 1,
                  uri.toString().indexOf("?"))
              : uri.toString().substring(uri.toString().lastIndexOf("/") + 1);
          global.routingEventID = int.parse(
              eventString.substring(eventString.lastIndexOf("-") + 1));
          global.routingEventName =
              eventString.substring(0, eventString.lastIndexOf("-") + 1);
          if (uri.queryParameters != null && uri.queryParameters.length > 0) {
            global.utmSource = uri.queryParameters["utm_source"] != null
                ? uri.queryParameters["utm_source"]!
                : "webShare";
            global.utmNetwork = uri.queryParameters["utm_network"] != null
                ? uri.queryParameters["utm_network"]!
                : "webShare";
            global.utmKeyword = uri.queryParameters["utm_keyword"] != null
                ? uri.queryParameters["utm_keyword"]!
                : "event-product-list-id${global.routingEventID}";
            global.utmCampaign = uri.queryParameters["utm_campaign"] != null
                ? uri.queryParameters["utm_campaign"]!
                : "webShare";
            global.utmMedium = uri.queryParameters["utm_medium"] != null
                ? uri.queryParameters["utm_medium"]!
                : "webShare";
            global.utmMedium = uri.queryParameters["utm_medium"] != null
                ? uri.queryParameters["utm_medium"]!
                : "webShare";
            global.placement = uri.queryParameters["placement"] != null
                ? uri.queryParameters["placement"]!
                : "webShare";
          } else {
            global.utmSource = "webShare";
            global.utmNetwork = "webShare";
            global.utmKeyword = "event-product-list-id${global.routingEventID}";
            global.utmCampaign = "webShare";
            global.utmMedium = "webShare";
            global.utmMedium = "webShare";
            global.placement = "webShare";
          }

          return SplashScreen1(
            a: analytics,
            o: observer,
          );
        },
      ),
/////#####Product Details routing#############updated Routing for https://byyu.com/product-details/vibrant-bouquet-619
      GoRoute(
        path: '/product-details/:productID',
        builder: (BuildContext context, GoRouterState state) {
          print("4.this is the full uri${state.uri}");
          global.iscatListRouting = false;
          global.productSearchText = "";
          if (global.routingEventID != 0) {
            global.routingEventID = 0;
          }
          if (global.iscatListRouting) {
            global.iscatListRouting = false;
          }
          Uri uri = state.uri;
          String productName =
              uri.toString().substring(uri.toString().lastIndexOf("/") + 1);
          global.routingProductID = int.parse(productName.substring(
              productName.lastIndexOf("-") + 1, productName.length));
          if (uri.queryParameters != null && uri.queryParameters.length > 0) {
            global.utmSource = uri.queryParameters["utm_source"] != null
                ? uri.queryParameters["utm_source"]!
                : "appShare";
            global.utmNetwork = uri.queryParameters["utm_network"] != null
                ? uri.queryParameters["utm_network"]!
                : "appShare";
            global.utmKeyword = uri.queryParameters["utm_keyword"] != null
                ? uri.queryParameters["utm_keyword"]!
                : "product-details-productID${global.routingProductID}";
            global.utmCampaign = uri.queryParameters["utm_campaign"] != null
                ? uri.queryParameters["utm_campaign"]!
                : "webShare";
            global.utmMedium = uri.queryParameters["utm_medium"] != null
                ? uri.queryParameters["utm_medium"]!
                : "webShare";
            global.utmMedium = uri.queryParameters["utm_medium"] != null
                ? uri.queryParameters["utm_medium"]!
                : "webShare";
            global.placement = uri.queryParameters["placement"] != null
                ? uri.queryParameters["placement"]!
                : "webShare";
          } else {
            global.utmSource = "appShare";
            global.utmNetwork = "appshare";
            global.utmKeyword = "product-details-id${global.routingCategoryID}";
            global.utmCampaign = "appShare";
            global.utmMedium = "appShare";
            global.utmMedium = "appShare";
            global.placement = "appShare";
          }
          print(global.routingProductID);
          return SplashScreen1(
            a: analytics,
            o: observer,
          );
        },
      ),
/////#####Product list by category routing#############updated Routing for https://byyu.com/product-details/vibrant-bouquet-619
      GoRoute(
        path: '/product-list/:catID',
        builder: (BuildContext context, GoRouterState state) {
          print("5.this is the full uri${state.uri}");
          global.productSearchText = "";
          if (global.routingProductID != 0) {
            global.routingProductID = 0;
          }
          if (global.routingEventID != 0) {
            global.routingEventID = 0;
          }
          if (global.iscatListRouting) {
            global.iscatListRouting = false;
          }
          global.iscatListRouting = false;
          Uri uri = state.uri;
          String catName = uri.toString().contains("?")
              ? uri.toString().substring(uri.toString().lastIndexOf("/") + 1,
                  uri.toString().indexOf("?"))
              : uri.toString().substring(uri.toString().lastIndexOf("/") + 1);
          global.routingCategoryID = int.parse(
              catName.substring(catName.lastIndexOf("-") + 1, catName.length));
          global.routingCategoryName =
              catName.substring(0, catName.lastIndexOf("-") + 1);

          if (uri.queryParameters != null && uri.queryParameters.length > 0) {
            global.utmSource = uri.queryParameters["utm_source"] != null
                ? uri.queryParameters["utm_source"]!
                : "webShare";
            global.utmNetwork = uri.queryParameters["utm_network"] != null
                ? uri.queryParameters["utm_network"]!
                : "webShare";
            global.utmKeyword = uri.queryParameters["utm_keyword"] != null
                ? uri.queryParameters["utm_keyword"]!
                : "webShare";
            global.utmCampaign = uri.queryParameters["utm_campaign"] != null
                ? uri.queryParameters["utm_campaign"]!
                : "webShare";
            global.utmMedium = uri.queryParameters["utm_medium"] != null
                ? uri.queryParameters["utm_medium"]!
                : "webShare";
            global.utmMedium = uri.queryParameters["utm_medium"] != null
                ? uri.queryParameters["utm_medium"]!
                : "webShare";
            global.placement = uri.queryParameters["placement"] != null
                ? uri.queryParameters["placement"]!
                : "webShare";
          } else {
            global.utmSource = "webShare";
            global.utmNetwork = "webShare";
            global.utmKeyword =
                "product-list-cat-id${global.routingCategoryID}";
            global.utmCampaign = "webShare";
            global.utmMedium = "webShare";
            global.utmMedium = "webShare";
            global.placement = "webShare";
          }
          print(global.routingProductID);
          return SplashScreen1(
            a: analytics,
            o: observer,
          );
        },
      ),
//////######### Category listing routing###############
      GoRoute(
        path: '/category-listing',
        builder: (BuildContext context, GoRouterState state) {
          print("6.this is the full uri${state.uri}");
          global.productSearchText = "";
          if (global.routingProductID != 0) {
            global.routingProductID = 0;
          }
          if (global.routingCategoryID != 0) {
            global.routingCategoryID = 0;
          }
          if (global.routingEventID != 0) {
            global.routingEventID = 0;
          }
          Uri uri = state.uri;

          if (uri.queryParameters != null && uri.queryParameters.length > 0) {
            global.utmSource = uri.queryParameters["utm_source"] != null
                ? uri.queryParameters["utm_source"]!
                : "webShare";
            global.utmNetwork = uri.queryParameters["utm_network"] != null
                ? uri.queryParameters["utm_network"]!
                : "webShare";
            global.utmKeyword = uri.queryParameters["utm_keyword"] != null
                ? uri.queryParameters["utm_keyword"]!
                : "webShare";
            global.utmCampaign = uri.queryParameters["utm_campaign"] != null
                ? uri.queryParameters["utm_campaign"]!
                : "webShare";
            global.utmMedium = uri.queryParameters["utm_medium"] != null
                ? uri.queryParameters["utm_medium"]!
                : "webShare";
            global.utmMedium = uri.queryParameters["utm_medium"] != null
                ? uri.queryParameters["utm_medium"]!
                : "webShare";
            global.placement = uri.queryParameters["placement"] != null
                ? uri.queryParameters["placement"]!
                : "webShare";
          } else {
            global.utmSource = "webShare";
            global.utmNetwork = "webShare";
            global.utmKeyword = "category-listing";
            global.utmCampaign = "webShare";
            global.utmMedium = "webShare";
            global.utmMedium = "webShare";
            global.placement = "webShare";
          }
          global.iscatListRouting = true;
          return SplashScreen1(
            a: analytics,
            o: observer,
          );
        },
      ),
//////////############################### product filter with gender,ocassion, relation and age
      GoRoute(
        path: "/product-gift-now",
        builder: (BuildContext context, GoRouterState state) {
          print("3.this is the full uri${state.uri}");
          global.productSearchText = "";
          if (global.routingProductID != 0) {
            global.routingProductID = 0;
          }
          if (global.iscatListRouting) {
            global.iscatListRouting = false;
          }
          if (global.routingCategoryID != 0) {
            global.routingCategoryID = 0;
          }
          if (global.routingEventID != 0) {
            global.routingEventID = 0;
          }
          global.refferalCode = "";

          Uri uri = state.uri;
          print(uri.queryParameters['code']);
          if (uri.queryParameters != null && uri.queryParameters.length > 0) {
            global.occasionName = uri.queryParameters["occasion_name"]!;
            global.genderID = uri.queryParameters["gender_id"]!;
            global.relationshipID = uri.queryParameters["relationship_id"]!;
            global.maxAge = uri.queryParameters["max_age"]!;
            global.minAge = uri.queryParameters["min_age"]!;
            global.ageID = uri.queryParameters["age_id"]!;
            // utm_source=google&utm_campaign=birthday_shopping&utm_network=search_ads&utm_medium=dubai_location&utm_keyword=Birthday&placement=placement
            global.occasionID = uri.queryParameters["occasion_id"]!;
            if (uri.queryParameters != null && uri.queryParameters.length > 0) {
              global.utmSource = uri.queryParameters["utm_source"] != null
                  ? uri.queryParameters["utm_source"]!
                  : "webShare";
              global.utmNetwork = uri.queryParameters["utm_network"] != null
                  ? uri.queryParameters["utm_network"]!
                  : "webShare";
              global.utmKeyword = uri.queryParameters["utm_keyword"] != null
                  ? uri.queryParameters["utm_keyword"]!
                  : "webShare";
              global.utmCampaign = uri.queryParameters["utm_campaign"] != null
                  ? uri.queryParameters["utm_campaign"]!
                  : "webShare";
              global.utmMedium = uri.queryParameters["utm_medium"] != null
                  ? uri.queryParameters["utm_medium"]!
                  : "webShare";
              global.utmMedium = uri.queryParameters["utm_medium"] != null
                  ? uri.queryParameters["utm_medium"]!
                  : "webShare";
              global.placement = uri.queryParameters["placement"] != null
                  ? uri.queryParameters["placement"]!
                  : "webShare";
            } else {
              global.utmSource = "webShare";
              global.utmNetwork = "category-listing";
              global.utmKeyword = "webShare";
              global.utmCampaign = "webShare";
              global.utmMedium = "webShare";
              global.utmMedium = "webShare";
              global.placement = "webShare";
            }
          } else {
            global.occasionName = "";
            global.genderID = "";
            global.relationshipID = "";
            global.maxAge = "";
            global.minAge = "";
            global.ageID = "";
            global.occasionID = "";
            global.utmSource = "";
            global.utmNetwork = "";
            global.utmKeyword = "";
            global.utmCampaign = "";
            global.utmMedium = "";
            global.utmMedium = "";
            global.placement = "";
          }
          return SplashScreen1(
            a: analytics,
            o: observer,
          );
        },
      ),

//////////################ Referall code Routing
      GoRoute(
        path: "/sharing/referral",
        builder: (BuildContext context, GoRouterState state) {
          print("3.this is the full uri${state.uri}");
          global.productSearchText = "";
          if (global.routingProductID != 0) {
            global.routingProductID = 0;
          }
          if (global.iscatListRouting) {
            global.iscatListRouting = false;
          }
          if (global.routingCategoryID != 0) {
            global.routingCategoryID = 0;
          }
          if (global.routingEventID != 0) {
            global.routingEventID = 0;
          }
          Uri uri = state.uri;
          print(uri.queryParameters['code']);
          if (uri.queryParameters == null) {
            global.refferalCode = "";
          } else {
            global.refferalCode = uri.queryParameters['code']!;
          }
          return SplashScreen1(
            a: analytics,
            o: observer,
          );
        },
      ),
      //////////################ Search text Routing

      GoRoute(
        path: "/search",
        builder: (BuildContext context, GoRouterState state) {
          print("Search.this is the full uri${state.uri}");
          global.productSearchText = "";
          if (global.routingProductID != 0) {
            global.routingProductID = 0;
          }
          if (global.iscatListRouting) {
            global.iscatListRouting = false;
          }
          if (global.routingCategoryID != 0) {
            global.routingCategoryID = 0;
          }
          if (global.routingEventID != 0) {
            global.routingEventID = 0;
          }
          global.refferalCode = "";

          Uri uri = state.uri;
          print(uri.queryParameters['code']);
          if (uri.queryParameters != null && uri.queryParameters.length > 0) {
            global.productSearchText = uri.queryParameters["search_text"]!;

            if (uri.queryParameters != null && uri.queryParameters.length > 0) {
              global.utmSource = uri.queryParameters["utm_source"] != null
                  ? uri.queryParameters["utm_source"]!
                  : "webShare";
              global.utmNetwork = uri.queryParameters["utm_network"] != null
                  ? uri.queryParameters["utm_network"]!
                  : "search";
              global.utmKeyword = uri.queryParameters["utm_keyword"] != null
                  ? uri.queryParameters["utm_keyword"]!
                  : global.productSearchText;
              global.utmCampaign = uri.queryParameters["utm_campaign"] != null
                  ? uri.queryParameters["utm_campaign"]!
                  : "webShare";
              global.utmMedium = uri.queryParameters["utm_medium"] != null
                  ? uri.queryParameters["utm_medium"]!
                  : "webShare";
              global.utmMedium = uri.queryParameters["utm_medium"] != null
                  ? uri.queryParameters["utm_medium"]!
                  : "webShare";
              global.placement = uri.queryParameters["placement"] != null
                  ? uri.queryParameters["placement"]!
                  : "webShare";
            } else {
              global.utmSource = "webShare";
              global.utmNetwork = "search";
              global.utmKeyword = global.productSearchText;
              global.utmCampaign = "webShare";
              global.utmMedium = "webShare";
              global.utmMedium = "webShare";
              global.placement = "webShare";
            }
          } else {
            global.productSearchText = "";
          }
          return SplashScreen1(
            a: analytics,
            o: observer,
          );
        },
      ),

/////////#################### Corporate gift routing#################
      GoRoute(
        path: '/corporategifts',
        builder: (BuildContext context, GoRouterState state) {
          global.productSearchText = "";
          if (global.routingProductID != 0) {
            global.routingProductID = 0;
          }
          if (global.routingCategoryID != 0) {
            global.routingCategoryID = 0;
          }
          if (global.routingEventID != 0) {
            global.routingEventID = 0;
          }
          Uri uri = state.uri;

          if (uri.queryParameters != null && uri.queryParameters.length > 0) {
            global.utmSource = uri.queryParameters["utm_source"] != null
                ? uri.queryParameters["utm_source"]!
                : "webShare";
            global.utmNetwork = uri.queryParameters["utm_network"] != null
                ? uri.queryParameters["utm_network"]!
                : "webShare";
            global.utmKeyword = uri.queryParameters["utm_keyword"] != null
                ? uri.queryParameters["utm_keyword"]!
                : "webShare";
            global.utmCampaign = uri.queryParameters["utm_campaign"] != null
                ? uri.queryParameters["utm_campaign"]!
                : "webShare";
            global.utmMedium = uri.queryParameters["utm_medium"] != null
                ? uri.queryParameters["utm_medium"]!
                : "webShare";
            global.utmMedium = uri.queryParameters["utm_medium"] != null
                ? uri.queryParameters["utm_medium"]!
                : "webShare";
            global.placement = uri.queryParameters["placement"] != null
                ? uri.queryParameters["placement"]!
                : "webShare";
          } else {
            global.utmSource = "webShare";
            global.utmNetwork = "webShare";
            global.utmKeyword = "corporategifts";
            global.utmCampaign = "webShare";
            global.utmMedium = "webShare";
            global.utmMedium = "webShare";
            global.placement = "webShare";
          }
          global.iscatListRouting = false;
          global.goToCorporatePage = true;

          return SplashScreen1(
            a: analytics,
            o: observer,
          );
        },
      ),
    ],
    debugLogDiagnostics: true,
  );
  // static final facebookAppEvents = FacebookAppEvents();

  @override
  Widget build(BuildContext context) {
    global.refferalCode = "";
    print('G1--- >--->${DateTime.now()}');
    print(_appRoute);
    // return GetMaterialApp(
    //     color: global.indigoColor,
    //     debugShowCheckedModeBanner: false,
    //     title: "byyu",
    //     home: SplashScreen1(
    //       a: analytics,
    //       o: observer,
    //     ),
    //     theme: ThemeUtils.defaultAppThemeData);
    // return MaterialApp.router(
    //   // theme: Theme.of(context).copyWith(
    //   //     appBarTheme: Theme.of(context).appBarTheme.copyWith(
    //   //           color: Colors.white,
    //   //         ),
    //   //     scaffoldBackgroundColor: Colors.white // this
    //   //     ),
    //   theme: ThemeUtils.defaultAppThemeData,

    //   debugShowCheckedModeBanner: false,
    //   routerConfig: _appRoute,
    // );

//AA
    return MaterialApp.router(
      theme: ThemeUtils.defaultAppThemeData,
      debugShowCheckedModeBanner: false,
      routerConfig: _appRoute,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    global.isShowAlert = true;
    super.initState();
    global.refferalCode = "";
    print('G1--05--main->${DateTime.now()}');

    setFNotification();
    setFBEvent();
    var fcmToken = '';

    FirebaseMessaging _firebaseMessaging =
        FirebaseMessaging.instance; // Change here
    _firebaseMessaging.getToken().then((token) {
      print("main .dart token is $token");
      fcmToken = token!;
      global.appDeviceId = token;
    });
  }

  static final facebookAppEvents = FacebookAppEvents();
  setFBEvent() async {
    if (Platform.isIOS) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      String sysVersion = iosInfo.systemVersion.replaceAll('.', '');
      if (1400 <= int.parse(sysVersion)) {
        facebookAppEvents.setAdvertiserTracking(enabled: true);
      }
    } else {
      facebookAppEvents.setAdvertiserTracking(enabled: true);
    }
  }

  Future<void> fetchAppInfoData() async {
    var platform;
    int? userId = null;
    if (Platform.isIOS) {
      platform = "ios";
    } else {
      platform = "android";
    }
    var deviceInfo = DeviceInfoPlugin();
    var deviceID = "";
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceID = iosDeviceInfo.identifierForVendor!; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      // deviceID = androidDeviceInfo.anoidId; // unique ID on Android
      deviceID = androidDeviceInfo.id; // unique ID on Android
    }
    String? fcmToken = '';
    FirebaseMessaging _firebaseMessaging =
        FirebaseMessaging.instance; // Change here
    _firebaseMessaging.getToken().then((token) {
      print("token is $token");
      fcmToken = token;
      global.appDeviceId = token!;
    });
    print("G1---buildNumber>${await FirebaseMessaging.instance.getToken()}");

    Map data = {
      'user_id': userId,
      'platform': platform,
      'app_name': 'byyu',
      'device_id': fcmToken,
      'actual_device_id': ""
    };

    var body = json.encode(data);
    print(
        "{'user_id': ${userId}, platform: ${platform}, app_name: byyu, 'device_id': ${fcmToken},'actual_device_id' : ${deviceID}");

    try {
      var response = await http.post(Uri.parse('${global.baseUrl}app_info'),
          headers: {
            "Content-type": "application/json",
            "Accept": "application/json",
          },
          body: body);
      print(response.statusCode);

      dynamic recordList;

      if (response.statusCode == 200) {
        recordList = AppInfo.fromJson(json.decode(response.body));
        global.appInfo = recordList;
        print(response.body.toString());
        if (recordList != null) {
          if (recordList.status == "1") {
            print('G1--06--->${DateTime.now()}');
            _init();
          } else {
            showToast(recordList.message);
          }
        }
      } else {
        recordList = null;
        showToast("Something Went Wrong, Please Try Again!");
      }
    } catch (e) {
      print(e);
    }
  }

  void _init() async {
    PermissionStatus permissionStatus = await Permission.phone.status;
    if (!permissionStatus.isGranted) {
      permissionStatus = await Permission.phone.request();
    }

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    print("G1---version>${version}");
    print("G1---1>${global.appInfo.version}");

    final mversion = version.replaceAll(".", "");
    final apiVersion = global.appInfo.version!.replaceAll(".", "");
    print("G111---version>${mversion}");
    print("G111---1>${apiVersion}");
    if (global.appInfo.version == null ||
        int.parse(apiVersion) <= int.parse(mversion)) {
      global.isSplashSelected = false;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userInfoJson = prefs.getString("userInfo");
      print(userInfoJson);
      if (userInfoJson != null) {
        global.currentUser = CurrentUser.fromJson(
            json.decode(global.sp!.getString("currentUser")!));

        if (global.sp!.getString('currentUser') != null) {
          global.currentLocation = (prefs.getString('type') ?? '');
          global.lat = prefs.getDouble('lat');
          global.lng = (prefs.getDouble('lng'));

          print('G1--02--->${DateTime.now()}');
        } else {}
      } else {}
    } else {
      if (global.appInfo.forcefully_update == 1) {
        _updateForcefullyDialog(
            "New update available.\nPlease download the updated app.");
      } else {
        _updateDialog(
            "New update available.\nPlease download the updated app.");
      }
    }
    // } else {
    //   showNetworkErrorSnackBar(_scaffoldKey);
    // }
    // });
  }

  showNetworkErrorSnackBar(GlobalKey<ScaffoldState> scaffoldKey) {
    try {
      // bool isConnected;
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
                  style: TextStyle(
                      fontFamily: fontRailwayRegular,
                      fontWeight: FontWeight.w900),
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

  _updateDialog(String msg) async {
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
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Skip',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: fontRailwayRegular,
                            fontWeight: FontWeight.w200,
                            color: ColorConstants.appColor)),
                    onPressed: () async {
                      global.isSplashSelected = false;
                      // bool isConnected = await br.checkConnectivity();
                      showOnlyLoaderDialog();
                      // if (isConnected) {
                      if (global.sp!.getString('currentUser') != null) {
                        global.currentUser = CurrentUser.fromJson(
                            json.decode(global.sp!.getString("currentUser")!));
                        if (global.sp!.getString('lastloc') != null) {
                          List<String> _tlist =
                              global.sp!.getString('lastloc')!.split("|");
                          global.lat = double.parse(_tlist[0]);
                          global.lng = double.parse(_tlist[1]);
                          // await getAddressFromLatLng();

                          // await getNearByStore();
                          if (global.currentUser.id != null) {
                            await global.userProfileController
                                .getUserAddressList();
                          }
                          // hideLoader();
                          print('G1--03--->${DateTime.now()}');
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                    a: global.sAnalytics,
                                    o: global.sObserver,
                                    selectedIndex: 0,
                                  )));
                          // await _getAppNotice();
                        } else {
                          print('G1--04--->${DateTime.now()}');
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                    a: global.sAnalytics,
                                    o: global.sObserver,
                                    selectedIndex: 0,
                                  )));
                          // await _getAppNotice();
                        }
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => IntroScreen(
                                  a: global.sAnalytics,
                                  o: global.sObserver,
                                )));
                      }
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text(
                      'Update',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: fontRailwayRegular,
                          fontWeight: FontWeight.w200,
                          color: Colors.blue),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      print(global.appInfo.app_link);
                      var url = "${global.appInfo.app_link}";
                      if (await canLaunch(url))
                        await launch(url);
                      else
                        // can't launch url, there is some error
                        throw "Could not launch $url";
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

  _updateForcefullyDialog(String msg) async {
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
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Update',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: fontRailwayRegular,
                            fontWeight: FontWeight.w200,
                            color: ColorConstants.appColor)),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      print(global.appInfo.app_link);
                      var url = "${global.appInfo.app_link}";
                      if (await canLaunch(url))
                        await launch(url);
                      else
                        // can't launch url, there is some error
                        throw "Could not launch $url";
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

  void setFNotification() async {
    var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    var initialzationSettingsAndroid =
        AndroidInitializationSettings('ic_notification');
    var initializationSettingsIOS = DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initialzationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      try {
        if (message != null && message.data != null) {}
        if (message.notification != null) {
          Future<String> _downloadAndSaveFile(
              String? url, String fileName) async {
            final Directory directory =
                await getApplicationDocumentsDirectory();
            final String filePath = '${directory.path}/$fileName';
            final http.Response response = await http.get(Uri.parse(url!));
            final File file = File(filePath);
            await file.writeAsBytes(response.bodyBytes);
            return filePath;
          }

          if (Platform.isAndroid) {
            String bigPicturePath;
            AndroidNotificationDetails androidPlatformChannelSpecifics;
            if (message.notification!.android!.imageUrl != null &&
                '${message.notification!.android!.imageUrl}' != 'N/A') {
              print('in Image');
              print('${message.notification!.android!.imageUrl}');
              bigPicturePath = await _downloadAndSaveFile(
                  message.notification!.android!.imageUrl != null
                      ? message.notification!.android!.imageUrl
                      : 'https://picsum.photos/200/300',
                  'bigPicture');
              final BigPictureStyleInformation bigPictureStyleInformation =
                  BigPictureStyleInformation(
                FilePathAndroidBitmap(bigPicturePath),
              );
              androidPlatformChannelSpecifics = AndroidNotificationDetails(
                  channel.id, channel.name,
                  channelDescription: channel.description,
                  icon: 'ic_notification',
                  color: ColorConstants.appColor,
                  styleInformation: bigPictureStyleInformation,
                  playSound: true);
            } else {
              print('in No Image');
              androidPlatformChannelSpecifics = AndroidNotificationDetails(
                  channel.id, channel.name,
                  channelDescription: channel.description,
                  icon: 'ic_notification',
                  color: ColorConstants.appColor,
                  styleInformation:
                      BigTextStyleInformation(message.notification!.body!),
                  playSound: true);
            }
            // final AndroidNotificationDetails androidPlatformChannelSpecifics2 =
            final NotificationDetails platformChannelSpecifics =
                NotificationDetails(android: androidPlatformChannelSpecifics);
            flutterLocalNotificationsPlugin.show(1, message.notification!.title,
                message.notification!.body, platformChannelSpecifics);
          } else if (Platform.isIOS) {
            final String bigPicturePath = await _downloadAndSaveFile(
                message.notification!.apple!.imageUrl != null
                    ? message.notification!.apple!.imageUrl
                    : 'https://picsum.photos/200/300',
                'bigPicture.jpg');
            final DarwinNotificationDetails iOSPlatformChannelSpecifics =
                DarwinNotificationDetails(
                    attachments: <DarwinNotificationAttachment>[
                  DarwinNotificationAttachment(bigPicturePath)
                ],
                    presentSound: true);
            final DarwinNotificationDetails iOSPlatformChannelSpecifics2 =
                DarwinNotificationDetails(presentSound: true);
            final NotificationDetails notificationDetails = NotificationDetails(
              iOS: message.notification!.apple!.imageUrl != null
                  ? iOSPlatformChannelSpecifics
                  : iOSPlatformChannelSpecifics2,
            );
            print("G1 noti");
            //G1 changes for ios side showing double notificaiton...
            // await flutterLocalNotificationsPlugin.show(
            //     1,
            //     message.notification.title,
            //     message.notification.body,
            //     notificationDetails);
            // await flutterLocalNotificationsPlugin
            //     .initialize(initializationSettings,
            //         onSelectNotification: (String payload) async {
            //   print("G1 noti${payload}");
            //   // navigate to test screen instead of home screen
            //   Get.to(() => NotificationScreen(
            //         a: analytics,
            //         o: observer,
            //       ));
            // });
            await flutterLocalNotificationsPlugin.initialize(
              initializationSettings,
              onDidReceiveNotificationResponse:
                  (NotificationResponse? notificationResponse) {
                switch (notificationResponse!.notificationResponseType) {
                  case NotificationResponseType.selectedNotification:
                    selectNotificationStream.add(notificationResponse.payload!);
                    break;
                  case NotificationResponseType.selectedNotificationAction:
                    if (notificationResponse.actionId == navigationActionId) {
                      selectNotificationStream
                          .add(notificationResponse.payload!);
                    }
                    break;
                }
              },
              onDidReceiveBackgroundNotificationResponse:
                  notificationTapBackground,
            );
          }
        }
      } catch (e) {
        print('Exception - main.dart - onMessage.listen(): ' + e.toString());
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("onMessageOpenedApp: $message");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NotificationScreen(
                    a: analytics,
                    o: observer,
                  )));
    });
  }

  final StreamController<String> selectNotificationStream =
      StreamController<String>.broadcast();
  String navigationActionId = 'id_3';
  @pragma('vm:entry-point')
  void notificationTapBackground(NotificationResponse notificationResponse) {
    // ignore: avoid_print
    print('notification(${notificationResponse.id}) action tapped: '
        '${notificationResponse.actionId} with'
        ' payload: ${notificationResponse.payload}');
    if (notificationResponse.input?.isNotEmpty ?? false) {
      // ignore: avoid_print
      print(
          'notification action tapped with input: ${notificationResponse.input}');
    }
  }
}
