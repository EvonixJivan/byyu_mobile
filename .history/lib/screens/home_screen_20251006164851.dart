import 'dart:async';

import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/models/categoryProductModel.dart';
import 'package:byyu/screens/product/corporateGifts.dart';
import 'package:byyu/screens/product/offersProductList.dart';
import 'package:byyu/screens/product/wishlist_screen.dart';
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
  bool _isDataLoaded = false;
  double menuTextSize = 11;
  Function? onAppDrawerButtonPressed;
  final CartController cartController = Get.put(CartController());

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
      CorporateGiftsScreen(
        a: widget.analytics,
        o: widget.observer,
      ),
      // OffersProductListScreen(
      //   a: widget.analytics,
      //   o: widget.observer,
      // ),
      CartScreen(
        a: widget.analytics,
        o: widget.observer,
        onAppDrawerButtonPressed: () {},
        callbackHomescreenSetState: callHomeScreenSetState,
      ),
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

    // return WillPopScope(
    //   onWillPop: () async {
    //     await exitAppDialog(); // add await for back ?
    //     return true;
    //   },
    //   child:
    //       // global.globalHomeLoading
    //       //     ?
    //       Scaffold(
    //           body: _homeScreenItems[selectedIndex!],
    //           bottomNavigationBar: _isDataLoaded
    //               ? Padding(
    //                   padding: EdgeInsets.only(
    //       bottom: Platform.isIOS?0: MediaQuery.of(context).viewPadding.bottom > 0
    //           ? MediaQuery.of(context).viewPadding.bottom
    //           : 10, // fallback for gesture nav
    //       top: 1,
    //     ),
    //                   child: GNav(

    //                       tabMargin: EdgeInsets.only(
    //                           bottom: Platform.isIOS ? 20 : 5, top: 1),
    //                       backgroundColor: Colors.transparent,
    //                       hoverColor:
    //                           Colors.transparent, //Colors.grey[100],
    //                       gap: 1,
    //                       activeColor: ColorConstants.appColor,
    //                       selectedIndex: selectedIndex!,
    //                       iconSize: 30,
    //                       textSize: 15,
    //                       textStyle: TextStyle(
    //                           color: ColorConstants.appColor,
    //                           fontFamily: global.fontMontserratLight),
    //                       padding: Platform.isIOS
    //                           ? EdgeInsets.symmetric(
    //                               horizontal: 15, vertical: 10)
    //                           : EdgeInsets.symmetric(
    //                               horizontal: 12, vertical: 8),
    //                       duration: Duration(microseconds: 5),
    //                       tabBackgroundColor: ColorConstants.appBrownFaintColor,
    //                       color: Colors.black45,
    //                       tabs: [
    //                         GButton(
    //                           backgroundColor: Colors.amber,
    //                           onPressed: () {
    //                             selectedIndex = 0;
    //                             setState(() {});
    //                           },
    //                           leading: Container(
    //                               child: Column(
    //                             children: [
    //                               Padding(
    //                                 padding: const EdgeInsets.only(top:8.0),

    //                                 child: Icon(
    //                                   Icons.home,
    //                                   color: selectedIndex == 0
    //                                       ? ColorConstants.appColor
    //                                       : ColorConstants.grey,
    //                                 ),
    //                               ),
    //                               SizedBox(
    //                                 height: 3,
    //                               ),
    //                               Text(
    //                                 "Home",
    //                                 style: TextStyle(
    //                                     fontFamily: fontMetropolisRegular,
    //                                     fontSize: menuTextSize,
    //                                     color: selectedIndex == 0
    //                                         ? ColorConstants.appColor
    //                                         : ColorConstants.grey),
    //                               )
    //                               //: SizedBox(),
    //                             ],
    //                           )),
    //                           icon: Icons.abc_outlined,
    //                         ),
    //                         GButton(
    //                           backgroundColor: ColorConstants.white,
    //                           onPressed: () {
    //                             selectedIndex = 1;
    //                             setState(() {});
    //                           },
    //                           leading: Container(
    //                               child: Column(
    //                             children: [
    //                               Padding(
    //                                 padding: const EdgeInsets.only(top:8.0),
    //                                 // child: Icon(
    //                                 //   Icons.corporate_fare,
    //                                 //   color: selectedIndex == 1
    //                                 //       ? ColorConstants.appColor
    //                                 //       : ColorConstants.grey,
    //                                 // ),

    //                                 child:Image.asset(
    //                                             'assets/images/ic_corporate_gift.png',
    //                                             width: 23,
    //                                             height: 23,
    //                                             color: selectedIndex == 1
    //                                     ? ColorConstants.appColor
    //                                     : ColorConstants.grey,

    //                                             fit: BoxFit.contain,
    //                                           ),
    //                               ),

    //                               SizedBox(
    //                                 height: 5,
    //                               ),
    //                               Text(
    //                                 "Corporate Gifts",
    //                                 textAlign: TextAlign.center,
    //                                 style: TextStyle(
    //                                     fontFamily: fontMetropolisRegular,
    //                                     fontSize: menuTextSize,
    //                                     color: selectedIndex == 1
    //                                         ? ColorConstants.appColor
    //                                         : ColorConstants.grey),
    //                               )
    //                             ],
    //                           )),
    //                           icon: Icons.abc_outlined,
    //                         ),

    //                         GButton(
    //                           backgroundColor: ColorConstants.white,
    //                           onPressed: () {
    //                             selectedIndex = 2;
    //                             setState(() {});
    //                           },
    //                           leading: Container(
    //                               child: Column(
    //                             children: [
    //                               Container(
    //                                 child: Stack(
    //                                   children: [
    //                                     Center(
    //                                       child: Padding(
    //                                         padding: const EdgeInsets.only(
    //                                             top: 8, right: 5, left: 5),
    //                                         child: Icon(
    //                                           Icons.shopping_cart,
    //                                           color: selectedIndex == 2
    //                                               ? ColorConstants.appColor
    //                                               : ColorConstants.grey,
    //                                         ),
    //                                       ),
    //                                     ),
    //                                     global.cartCount != 0
    //                                         ? new Positioned(
    //                                             right: 2,
    //                                             top: 2,
    //                                             child: new Container(
    //                                               padding: EdgeInsets.all(2),
    //                                               decoration: new BoxDecoration(
    //                                                 color: Colors.red,
    //                                                 borderRadius:
    //                                                     BorderRadius.circular(
    //                                                         6),
    //                                               ),
    //                                               constraints: BoxConstraints(
    //                                                 minWidth: 14,
    //                                                 minHeight: 14,
    //                                               ),
    //                                               child: Text(
    //                                                 // "${_seconds}",

    //                                             global.cartCount <= 99?'${global.cartCount}':"99+",
    //                                                 style: TextStyle(
    //                                                   color: Colors.white,
    //                                                   fontSize: 8,
    //                                                 ),
    //                                                 textAlign: TextAlign.center,
    //                                               ),
    //                                             ),
    //                                           )
    //                                         : new Container()
    //                                   ],
    //                                 ),
    //                               ),
    //                               SizedBox(
    //                                 height: 3,
    //                               ),
    //                               Text(
    //                                 "Cart",
    //                                 style: TextStyle(
    //                                     fontFamily: fontMetropolisRegular,
    //                                     fontSize: menuTextSize,
    //                                     color: selectedIndex == 2
    //                                         ? ColorConstants.appColor
    //                                         : ColorConstants.grey),
    //                               ),
    //                             ],
    //                           )),
    //                           icon: Icons.abc_outlined,
    //                         ),
    //                         GButton(
    //                           backgroundColor: ColorConstants.white,
    //                           onPressed: () {
    //                             selectedIndex = 3;
    //                             setState(() {});
    //                           },
    //                           leading: Container(
    //                               child: Column(
    //                             children: [
    //                               Container(
    //                                 child: Stack(
    //                                   children: [
    //                                     Center(
    //                                       child: Padding(
    //                                         padding: const EdgeInsets.only(
    //                                             top: 8, right: 5, left: 5),
    //                                         child: Icon(
    //                                           Icons.favorite,
    //                                           color: selectedIndex == 3
    //                                               ? ColorConstants.appColor
    //                                               : ColorConstants.grey,
    //                                         ),
    //                                       ),
    //                                     ),
    //                                     global.wishlistCount != 0
    //                                         ? new Positioned(
    //                                             right: 2,
    //                                             top: 2,
    //                                             child: new Container(
    //                                               padding: EdgeInsets.all(2),
    //                                               decoration: new BoxDecoration(
    //                                                 color: Colors.red,
    //                                                 borderRadius:
    //                                                     BorderRadius.circular(
    //                                                         6),
    //                                               ),
    //                                               constraints: BoxConstraints(
    //                                                 minWidth: 14,
    //                                                 minHeight: 14,
    //                                               ),
    //                                               child: Text(
    //                                                 // "${_seconds}",

    //                                             global.wishlistCount <= 99?'${global.wishlistCount}':"99+",
    //                                                 style: TextStyle(
    //                                                   color: Colors.white,
    //                                                   fontSize: 8,
    //                                                 ),
    //                                                 textAlign: TextAlign.center,
    //                                               ),
    //                                             ),
    //                                           )
    //                                         : new Container()
    //                                   ],
    //                                 ),
    //                               ),
    //                               SizedBox(
    //                                 height: 3,
    //                               ),
    //                               Text(
    //                                 "Wishlist",
    //                                 style: TextStyle(
    //                                     fontFamily: fontMetropolisRegular,
    //                                     fontSize: menuTextSize,
    //                                     color: selectedIndex == 3
    //                                         ? ColorConstants.appColor
    //                                         : ColorConstants.grey),
    //                               )
    //                             ],
    //                           )),
    //                           icon: Icons.abc_outlined,
    //                         ),
    //                         GButton(
    //                           backgroundColor: ColorConstants.white,
    //                           // icon: Icons.person,
    //                           // text: 'Me',
    //                           // style: GnavStyle.oldSchool,
    //                           onPressed: () {
    //                             selectedIndex = 4;
    //                             setState(() {});
    //                           },
    //                           leading: Container(
    //                               child: Column(
    //                             children: [
    //                               Padding(
    //                                 padding: const EdgeInsets.only(top:8.0),

    //                                 child: Icon(
    //                                   Icons.person,
    //                                   color: selectedIndex == 4
    //                                       ? ColorConstants.appColor
    //                                       : ColorConstants.grey,
    //                                 ),
    //                               ),
    //                               SizedBox(
    //                                 height: 3,
    //                               ),
    //                               Text(
    //                                 "Me",
    //                                 style: TextStyle(
    //                                     fontFamily: fontMetropolisRegular,
    //                                     fontSize: menuTextSize,
    //                                     color: selectedIndex == 4
    //                                         ? ColorConstants.appColor
    //                                         : ColorConstants.grey),
    //                               ),
    //                             ],
    //                           )),
    //                           icon: Icons.abc_outlined,
    //                         ),
    //                       ],
    //                       //selectedIndex: _selectedIndex,
    //                       onTabChange: (index) {
    //                         setState(() {
    //                           _currentIndex = index;
    //                         });
    //                       }),
    //                 )
    //               : Container(
    //                   width: MediaQuery.of(context).size.width,
    //                   height: MediaQuery.of(context).size.height,
    //                   color: Colors.white,
    //                 )),
    //   // : SizedBox(),

    //   /// Floting cart Bi
    //   /*floatingActionButton: FloatingActionButton(
    //         child: Icon(
    //           Icons.add_shopping_cart_outlined,
    //           //color: Colors.white,
    //           color: global.yellow,
    //         ),
    //         onPressed: () {
    //           if (global.currentUser.id == null) {
    //             Navigator.push(
    //               context,
    //               MaterialPageRoute(
    //                 builder: (context) => LoginScreen(a: widget.analytics, o: widget.observer),
    //               ),
    //             );
    //           } else {
    //             Navigator.push(
    //               context,
    //               MaterialPageRoute(
    //                 builder: (context) => CartScreen(a: widget.analytics, o: widget.observer, isSubscription: 1,),
    //               ),
    //             );
    //           }
    //         }),
    //     floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,*/
    // );

    return WillPopScope(
        onWillPop: () async {
          await exitAppDialog(); // add await for back ?
          return true;
        },
        child: Scaffold(
          extendBody: true,
          body: _homeScreenItems[selectedIndex!],
          backgroundColor: Colors.transparent,
          bottomNavigationBar: Container(
            color: Colors.transparent,
            height: 80,
            child: Stack(children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 50,
                  color: Colors.white,
                ),
              ),
              Row(
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
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100)),
                          child: Icon(
                            Icons.home_outlined,
                            color: selectedIndex == 0
                                ? ColorConstants.newAppColor
                                : ColorConstants.newColorBlack,
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
                                  ? ColorConstants.newAppColor
                                  : ColorConstants.newColorBlack),
                        ),
                      ],
                    ),
                  ),
                  ///////////////////////////////////////////////////////////////////////////
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100)),
                          child: Icon(
                            MdiIcons.gift,
                            color: selectedIndex == 1
                                ? ColorConstants.newAppColor
                                : ColorConstants.newColorBlack,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Explore More",
                          style: TextStyle(
                              fontFamily: fontRailwayRegular,
                              fontSize: menuTextSize,
                              color: selectedIndex == 1
                                  ? ColorConstants.newAppColor
                                  : ColorConstants.newColorBlack),
                        ),
                      ],
                    ),
                  ),
                  ///////////////////////////////////////////////////////////////////////////
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = 2;
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100)),
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            color: selectedIndex == 2
                                ? ColorConstants.newAppColor
                                : ColorConstants.newColorBlack,
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
                                  ? ColorConstants.newAppColor
                                  : ColorConstants.newColorBlack),
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
                        Container(
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100)),
                          child: Stack(
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8, right: 5, left: 5),
                                  child: Icon(
                                    Icons.favorite_border_outlined,
                                    color: selectedIndex == 3
                                        ? ColorConstants.newAppColor
                                        : ColorConstants.newColorBlack,
                                  ),
                                ),
                              ),
                              global.wishlistCount != 0
                                  ? new Positioned(
                                      right: 2,
                                      top: 2,
                                      child: new Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: new BoxDecoration(
                                          color: ColorConstants.newAppColor,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        constraints: BoxConstraints(
                                          minWidth: 14,
                                          minHeight: 14,
                                        ),
                                        child: Text(
                                          // "${_seconds}",

                                          global.wishlistCount <= 99
                                              ? '${global.wishlistCount}'
                                              : "99+",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 8,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                  : new Container()
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Wishlist",
                          style: TextStyle(
                              fontFamily: fontRailwayRegular,
                              fontSize: menuTextSize,
                              color: selectedIndex == 3
                                  ? ColorConstants.newAppColor
                                  : ColorConstants.newColorBlack),
                        ),
                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = 4;
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100)),
                          child: Icon(
                            Icons.person,
                            color: selectedIndex == 4
                                ? ColorConstants.newAppColor
                                : ColorConstants.newColorBlack,
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
                              color: selectedIndex == 4
                                  ? ColorConstants.newAppColor
                                  : ColorConstants.newColorBlack),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ]),
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
