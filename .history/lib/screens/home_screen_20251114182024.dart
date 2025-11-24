import 'dart:async';

import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/models/categoryProductModel.dart';
import 'package:byyu/screens/product/corporateGifts.dart';
import 'package:byyu/screens/product/offersProductList.dart';
import 'package:byyu/screens/product/wishlist_screen.dart';
import 'package:byyu/screens/search_screen.dart';
import 'package:byyu/widgets/cart_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;
import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/controllers/cart_controller.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/screens/coming_soon.dart';
import 'package:byyu/screens/dashboard_screen.dart';
import 'package:byyu/screens/product/all_categories_screen.dart';
import 'package:byyu/screens/cart_screen/cart_screen.dart';
import 'package:byyu/screens/auth/login_screen.dart';
import 'package:byyu/screens/order/order_history_screen.dart';
import 'package:byyu/screens/auth/user_profile_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../models/cartModel.dart';

class HomeScreen extends BaseRoute {
  final int? screenId;
  final Function? onAppDrawerButtonPressed;
  int? selectedIndex;
  final CartController cartController = Get.put(CartController());
  HomeScreen(
      {a, o, this.onAppDrawerButtonPressed, this.screenId, this.selectedIndex})
      : super(a: a, o: o, r: 'HomeScreen');
  @override
  _HomeScreenState createState() => _HomeScreenState(
      // onAppDrawerButtonPressed: onAppDrawerButtonPressed,
      screenId: screenId,
      selectedIndex: selectedIndex);
}

class _HomeScreenState extends BaseRouteState {
  int _currentIndex = 0;
  int? screenId;
  int? selectedIndex = 0;
  int? previousIndex = 0;
  bool _isDataLoaded = false;
  double menuTextSize = 11;
  Function? onAppDrawerButtonPressed;
  final CartController cartController = Get.put(CartController());
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  _HomeScreenState(
      {this.onAppDrawerButtonPressed, this.screenId, this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final List<Widget> _homeScreenItems = [
      DashboardScreen(
        a: widget.analytics,
        o: widget.observer,
        isSubscription: global.isSubscription!, //isSubscription: 1,
        onAppDrawerButtonPressed: () {
          // if (drawerKey.currentState.isOpened()) {
          //   drawerKey.currentState.closeDrawer();
          // } else {
          //   drawerKey.currentState.openDrawer();
          // }
        },
      ),
      // CorporateGiftsScreen(
      //   a: widget.analytics,
      //   o: widget.observer,
      // ),
      AllCategoriesScreen(
        a: widget.analytics,
        o: widget.observer,
        fromNavBar: true,
      ),
      // OffersProductListScreen(
      //   a: widget.analytics,
      //   o: widget.observer,
      // ),
      // CartScreen(
      //   a: widget.analytics,
      //   o: widget.observer,
      //   onAppDrawerButtonPressed: () {},
      //   callbackHomescreenSetState: callHomeScreenSetState,
      // ),

      WishListScreen(
        a: widget.analytics,
        o: widget.observer,
        //isSubscription: 1,
        callbackHomescreenSetState: callHomeScreenSetState,
        onAppDrawerButtonPressed: () {},
      ),
      // ComingSoon(),
      UserProfileScreen(
        a: widget.analytics,
        o: widget.observer,
      )
    ];

    return WillPopScope(
        onWillPop: () async {
          await exitAppDialog(); // add await for back ?
          return true;
        },
        child: Scaffold(
          key: _scaffoldKey,
          extendBody: true,
          body: _homeScreenItems[selectedIndex!],
          backgroundColor: ColorConstants.colorPageBackground,
          bottomNavigationBar: SafeArea(
            top: false,
            child: Container(
              color: Colors.white,
              height: 70,
              child: Stack(children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 50,
                    color: Colors.white,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //////////////////////////////////////////////
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 0;
                        });
                      },
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100)),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Image.asset(
                                  'assets/images/ic_nav_home.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Home",
                            style: TextStyle(
                                fontFamily: fontRailwayRegular,
                                fontSize: menuTextSize,
                                color: selectedIndex == 0
                                    ? ColorConstants.newTextHeadingFooter
                                    : ColorConstants.newColorBlack),
                          ),
                        ],
                      ),
                    ),
                    ///////////////////////////////////////////////////////////////////////////
                    GestureDetector(
                      // onTap: () {
                      //   setState(() {
                      //     selectedIndex = 1;
                      //   });
                      // },
                      onTap: () => {_scaffoldKey.currentState?.openDrawer()},

                      child: Column(
                        children: [
                          Center(
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100)),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Image.asset(
                                  'assets/images/ic_nav_explore.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Explore",
                            style: TextStyle(
                                fontFamily: fontRailwayRegular,
                                fontSize: menuTextSize,
                                color: selectedIndex == 1
                                    ? ColorConstants.newTextHeadingFooter
                                    : ColorConstants.newColorBlack),
                          ),
                        ],
                      ),
                    ),
                    ///////////////////////////////////////////////////////////////////////////
                    GestureDetector(
                      onTap: () {
                        setState() {
                          previousIndex = selectedIndex;
                        }

                        Future.delayed(Duration.zero, () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            useRootNavigator: true,
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            builder: (context) => CartBottomSheet(
                              analytics: widget.analytics,
                              observer: widget.observer,
                              fromNavigationBar: true,
                              callbackHomescreenSetState:
                                  callHomeScreenSetState,
                            ),
                          ).whenComplete(() {
                            setState() {
                              selectedIndex =
                                  previousIndex; // restore previous screen
                            }

                            ;
                          });
                        });
                      },
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100)),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Image.asset(
                                      'assets/images/ic_nav_cart.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  global.cartCount != 0
                                      ? Positioned(
                                          right: 2,
                                          top: 2,
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              color: ColorConstants.appColor,
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                            ),
                                            constraints: const BoxConstraints(
                                              minWidth: 16,
                                              minHeight: 16,
                                            ),
                                            child: Text(
                                              global.cartCount <= 99
                                                  ? '${global.cartCount}'
                                                  : "99+",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 8,
                                                  fontFamily: fontOufitMedium),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Cart",
                            style: TextStyle(
                                fontFamily: fontRailwayRegular,
                                fontSize: menuTextSize,
                                color: selectedIndex == 2
                                    ? ColorConstants.newTextHeadingFooter
                                    : ColorConstants.newColorBlack),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (global.stayLoggedIN == null ||
                            !global.stayLoggedIN!) {
                          // User not logged in → Navigate to login screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(
                                a: widget.analytics,
                                o: widget.observer,
                              ),
                            ),
                          );
                        } else {
                          // User logged in → Go to Wishlist tab
                          setState(() {
                            selectedIndex = 2;
                          });
                        }
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Image.asset(
                                      'assets/images/ic_nav_favorites.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                global.wishlistCount != 0
                                    ? Positioned(
                                        right: 2,
                                        top: 2,
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: ColorConstants.appColor,
                                            borderRadius:
                                                BorderRadius.circular(60),
                                          ),
                                          constraints: const BoxConstraints(
                                            minWidth: 16,
                                            minHeight: 16,
                                          ),
                                          child: Text(
                                            global.wishlistCount <= 99
                                                ? '${global.wishlistCount}'
                                                : "99+",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 8,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Wishlist",
                            style: TextStyle(
                              fontFamily: fontRailwayRegular,
                              fontSize: menuTextSize,
                              color: selectedIndex == 2
                                  ? ColorConstants.newTextHeadingFooter
                                  : ColorConstants.newColorBlack,
                            ),
                          ),
                        ],
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 3;
                        });
                      },
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100)),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Image.asset(
                                  'assets/images/ic_nav_me.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Me",
                            style: TextStyle(
                                fontFamily: fontRailwayRegular,
                                fontSize: menuTextSize,
                                color: selectedIndex == 3
                                    ? ColorConstants.newTextHeadingFooter
                                    : ColorConstants.newColorBlack),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ]),
            ),
          ),
        ));
  }

  Timer? _countDown;
  int _seconds = 60;
  @override
  void initState() {
    super.initState();
    print('uID ${global.currentUser.id}');
    // _getWishListProduct();
    //startTimer();
    _isDataLoaded = true;
    // getCartList();
    // if (screenId == 1) {
    //   _currentIndex = 4;
    // } else if (screenId == 2) {
    //   _currentIndex = 3;
    // } else {
    //   _currentIndex = 0;
    // }

    global.isNavigate = false;
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      // Cart pressed
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => CartBottomSheet(
            analytics: widget.analytics,
            observer: widget.observer,
            fromNavigationBar: true,
            callbackHomescreenSetState: callHomeScreenSetState,
          ),
        );
      });
    } else {
      // Home / Explore / Wishlist / Me
      setState(() {
        selectedIndex = index > 2 ? index - 1 : index;
      });
    }
  }

  callHomeScreenSetState() {
    print("this is home screen setState called");

    setState(() {});
  }

  Future startTimer() async {
    setState(() {});
    const oneSec = const Duration(seconds: 1);
    _countDown = new Timer.periodic(
      oneSec,
      (timer) {
        if (_seconds == 0) {
          setState(() {
            _seconds = 60;
            // _countDown.cancel();
            // timer.cancel();
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
}
