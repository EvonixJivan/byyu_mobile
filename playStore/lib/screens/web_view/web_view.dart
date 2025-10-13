// import 'dart:async';
// import 'dart:io';
// import 'package:byyu/constants/color_constants.dart';
// import 'package:byyu/models/orderModel.dart';
// import 'package:byyu/screens/order/order_confirmation_screen.dart';
// import 'package:flutter/material.dart';
// //import 'package:get/get.dart';
// //import 'package:url_launcher/url_launcher.dart';
// import 'package:byyu/models/businessLayer/apiHelper.dart';
// import 'package:byyu/models/businessLayer/baseRoute.dart';
// //import 'package:byyu/screens/payment_view/wallet_screen.dart';
// import 'package:byyu/widgets/toastfile.dart';
// import 'package:flutter/services.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// //import 'package:byyu/models/businessLayer/global.dart' as global;

// import '../../models/businessLayer/global.dart';

// class WebViewScreen extends BaseRoute {
//   final String? userid;
//   final String? totalAmount;
//   final String? paymentURL;
//   final bool? platform;
//   WebViewScreen({
//     a,
//     o,
//     this.userid,
//     this.totalAmount,
//     this.paymentURL,
//     this.platform,
//   }) : super(a: a, o: o, r: 'WalletScreen');
//   @override
//   _WebViewScreenState createState() =>
//       new _WebViewScreenState(userid!, totalAmount!, paymentURL!, platform!);
// }

// class _WebViewScreenState extends BaseRouteState {
//   final Completer<WebViewController> _controller =
//       Completer<WebViewController>();
//   GlobalKey<ScaffoldState>? _scaffoldKey;
//   APIHelper apiHelper4 = new APIHelper();
//   // var paymentURL = 'https://quickart.ae/admin/pay/user_id/amount';

//   String userid;
//   String totalAmount;
//   String paymentURL;
//   bool platform;
//   final _key = UniqueKey();
//   bool _load = true;

//   @override
//   void initState() {
//     super.initState();
//     if (Platform.isAndroid) {
//       WebView.platform = SurfaceAndroidWebView();
//     }
//     print(paymentURL);
//     if (platform == true) {
//       SystemChrome.setPreferredOrientations([
//         DeviceOrientation.portraitUp,
//         // DeviceOrientation.landscapeRight,
//         // DeviceOrientation.landscapeLeft
//       ]);
//     }
//   }

//   @override
//   void dispose() {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.landscapeRight,
//       DeviceOrientation.landscapeLeft
//     ]);
//     super.dispose();
//   }

//   _WebViewScreenState(
//       this.userid, this.totalAmount, this.paymentURL, this.platform)
//       : super();
//   @override
//   Widget build(BuildContext context) {
//     print("NIKHIL   ????????????????????????????????????????");
//     Widget loadingIndicator = _load
//         ? new Container(
//             width: 100.0,
//             height: 100.0,
//             child: new Padding(
//                 padding: const EdgeInsets.all(5.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     new Center(child: new CircularProgressIndicator()),
//                   ],
//                 )),
//           )
//         : new Container();

//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: ColorConstants.appBrownFaintColor,
//           title: Text(
//             paymentURL.contains("www.thegiftscatalog.com") ? 'Catalog' : 'Payment View',
//             style: TextStyle(
//                 color: ColorConstants.pureBlack,
//                 fontFamily: fontRailwayRegular,
//                 fontWeight: FontWeight.w200),
//           ),
//           centerTitle: true,
//           leading: BackButton(
//               onPressed: () {
//                 Navigator.of(context).pop('back');
//               },
//               //icon: Icon(Icons.keyboard_arrow_left),
//               color: ColorConstants.pureBlack),
//         ),
//         body: Stack(
//           children: [
//             platform
//                 ?
//                 //          launch(
//                 //   paymentURL,
//                 //   forceSafariVC: true,
//                 // )
//                 WebView(
//                     initialUrl: '${paymentURL}',
//                     javascriptMode: JavascriptMode.unrestricted,
//                     onWebViewCreated: (WebViewController webViewController) {
//                       _controller.complete(webViewController);
//                     },
//                     onProgress: (int progress) {
                      
//                       print('WebView is loading (progress : $progress%)');
//                     },
//                     javascriptChannels: <JavascriptChannel>{
//                       _toasterJavascriptChannel(context),
//                     },
//                     navigationDelegate: (NavigationRequest request) {
//                       if (request.url.startsWith('https://www.youtube.com/')) {
//                         // print('blocking navigation to $request}');
//                         return NavigationDecision.prevent;
//                       }
//                       // print('allowing navigation to $request');
//                       return NavigationDecision.navigate;
//                     },
//                     onPageStarted: (String url) {
//                       _load = false;
//                       setState(() {});
//                       print('Page started loading: $url');
//                     },
//                     onPageFinished: (String url) {
                      
//                       print('Page finished loading: $url');
//                       if (url.toLowerCase().contains('failed')) {
//                         showToast("Payment failed. Please try again!");
//                         callPaymentFailureAPI(
//                             "WebViewScreen", "onPageFinished_Failed");
//                         setState(() {
//                           Navigator.of(context).pop();
//                         });
//                       } else if (url.toLowerCase().contains('success')) {
//                         print("this is the after payment URL------${url}");
//                         showToast("Payment done successfully");
// // Page finished loading: https://quickart.ae/DEMOTEST/success/SI2231210575698
//                         var parts = url.split('/');
//                         var SIID = parts.last.trim();
//                         callPaymentFailureAPI("WebViewScreen",
//                             "onPageFinished_SuccessSSID_${SIID}");

//                         print("this is the after payment URL------${SIID}");
//                         setState(() {
//                           //_addSIStatusBankCard(SIID);
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => OrderConfirmationScreen(
//                                         a: widget.analytics,
//                                         o: widget.observer,
//                                         screenId: 1,
//                                         cartID: SIID,
//                                       )));
//                           // Navigator.of(context).pop(prefix);
//                         });
//                       }
//                     },
//                     gestureNavigationEnabled: true,
//                     backgroundColor: const Color(0x00000000),
//                   )
//                 : WebView(
//                     initialUrl: paymentURL,
//                     javascriptMode: JavascriptMode.unrestricted,
//                     onPageFinished: (String url) {
//                       _load = false;
//                       setState(() {});
//                       print('Page finished loading: $url');
//                       if (url.toLowerCase().contains("failed")) {
//                         showToast("Payment failed. Please try again!");
//                         callPaymentFailureAPI(
//                             "WebViewScreen", "onPageFinished_Failed");

//                         //  Navigator.pop(context);
//                         setState(() {
//                           //   print("====your page is load");
//                           Navigator.pop(context);

//                           // Navigator.of(context).pop();
//                         });
//                       } else if (url.toLowerCase().contains("success")) {
//                         showToast("Payment done successfully");
// // Page finished loading: https://quickart.ae/DEMOTEST/success/SI2231210575698
//                         var parts = url.split('/');
//                         var SIID = parts.last.trim();
//                         callPaymentFailureAPI("WebViewScreen",
//                             "onPageFinished_SuccessSSID_${SIID}");

//                         print(SIID);
//                         setState(() {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => OrderConfirmationScreen(
//                                         a: widget.analytics,
//                                         o: widget.observer,
//                                         screenId: 1,
//                                         cartID: SIID,
//                                       )));

//                           // Navigator.of(context).pop(prefix);
//                         });
//                       }
//                     }),
//             new Align(
//               child: loadingIndicator,
//               alignment: FractionalOffset.center,
//             ),
//           ],
//         ));
//   }

//   JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
//     return JavascriptChannel(
//         name: 'Toaster',
//         onMessageReceived: (JavascriptMessage message) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(message.message)),
//           );
//         });
//   }

//   callPaymentFailureAPI(String activity, dynamic description) async {
//     showOnlyLoaderDialog();
//     try {
//       await apiHelper.paymentError(activity, description).then(
//         (result) async {
//           if (result.status == "1") {
//             hideLoader();
//           } else {
//             hideLoader();
//             callPaymentFailureAPI(activity, description);
//           }
//         },
//       );
//     } catch (e) {
//       print("payment logs error${e.toString()}");
//       hideLoader();
//     }
//   }

//   // //API call for SI Status... G1
//   // _addSIStatusBankCard(
//   //   String SIID,
//   // ) async {
//   // AAAC useless code
//   //   setState(() {
//   //     _load = true;
//   //   });
//   //   try {
//   //     bool isConnected = await br!.checkConnectivity();
//   //     if (isConnected) {
//   //       await apiHelper.addSIStatusBankCard(SIID).then((result) async {
//   //         if (result != null) {
//   //           if (result.status == "1") {
//   //             setState(() {
//   //               _load = false;
//   //             });
//   //             showToast(result.message);
//   //             // _alertForFreeDeliveryDialog(result.message);
//   //             Navigator.of(context).pop(SIID);
//   //           } else {
//   //             setState(() {
//   //               _load = false;
//   //             });
//   //             showSnackBar(key: _scaffoldKey, snackBarMessage: result.message);
//   //           }
//   //         } else {
//   //           setState(() {
//   //             _load = false;
//   //           });
//   //           showSnackBar(key: _scaffoldKey, snackBarMessage: result.message);
//   //         }
//   //       });
//   //     } else {
//   //       setState(() {
//   //         _load = false;
//   //       });
//   //       showSnackBar(
//   //           key: _scaffoldKey, snackBarMessage: "No Internet Connection");
//   //     }
//   //   } catch (e) {
//   //     setState(() {
//   //       _load = false;
//   //     });
//   //     print("Exception - dashboard_screen.dart - _getHomeScreenData():" +
//   //         e.toString());
//   //   }
//   // }
// }

import 'dart:io';
import 'package:byyu/constants/color_constants.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String userid;
  final String totalAmount;
  final String paymentURL;
  final bool platform;

  const WebViewScreen({
    super.key,
    required this.userid,
    required this.totalAmount,
    required this.paymentURL,
    required this.platform, FirebaseAnalytics? a, FirebaseAnalyticsObserver? o,
  });

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            debugPrint("Loading progress: $progress%");
          },
          onPageStarted: (url) {
            setState(() => _loading = true);
            debugPrint("Page started: $url");
          },
          onPageFinished: (url) {
            setState(() => _loading = false);
            debugPrint("Page finished: $url");

            if (url.toLowerCase().contains("failed")) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Payment failed. Please try again!")),
              );
              Navigator.of(context).pop();
            } else if (url.toLowerCase().contains("success")) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Payment done successfully")),
              );

              // Example: Extract SIID
              var parts = url.split('/');
              var siid = parts.isNotEmpty ? parts.last.trim() : "";
              debugPrint("Payment Success SIID: $siid");

              // TODO: Navigate to confirmation page
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentURL));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.white,
        title: Text(widget.paymentURL.contains("thegiftscatalog")
            ? "Catalog"
            : "Payment View"),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
