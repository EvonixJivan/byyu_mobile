import 'dart:convert';
import 'dart:io';

import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/screens/auth/user_members_list_sccreen.dart';
import 'package:byyu/screens/auth/user_settings.dart';
import 'package:byyu/screens/contact_us_screen.dart';
import 'package:byyu/screens/faq_screen.dart';
import 'package:byyu/screens/home_screen.dart';
import 'package:byyu/screens/notification_screen.dart';
import 'package:byyu/screens/order/checkout_screen.dart';
import 'package:byyu/screens/order/coupons_screen.dart';
import 'package:byyu/screens/order/order_history_screen.dart';
import 'package:byyu/screens/order/transaction_history_screen.dart';
import 'package:byyu/screens/payment_view/wallet_screen.dart';
import 'package:byyu/screens/product/corporateGifts.dart';
import 'package:byyu/screens/product/offersProductList.dart';
import 'package:byyu/screens/referral_share_screen.dart';
import 'package:byyu/widgets/my_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/userModel.dart';
import 'package:byyu/screens/auth/login_screen.dart';
import 'package:byyu/screens/auth/profile_edit_screen.dart';
import 'package:byyu/utils/navigation_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class UserInfoTile extends StatefulWidget {
  final String? value;
  final Widget? leadingIcon;
  final String? heading;
  final Function? onPressed;
  final key;

  UserInfoTile(
      {@required this.heading,
      this.value,
      this.leadingIcon,
      this.onPressed,
      this.key})
      : super();

  @override
  _UserInfoTileState createState() => _UserInfoTileState(
      heading: heading,
      value: value,
      leadingIcon: leadingIcon,
      onPressed: onPressed,
      key: key);
}

class UserOrdersDashboardBox extends StatefulWidget {
  final String? heading;
  final String? value;

  UserOrdersDashboardBox({@required this.heading, this.value}) : super();

  @override
  _UserOrdersDashboardBoxState createState() =>
      _UserOrdersDashboardBoxState(heading: heading, value: value);
}

class UserProfileScreen extends BaseRoute {
  UserProfileScreen({a, o}) : super(a: a, o: o, r: 'UserProfileScreen');

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserInfoTileState extends State<UserInfoTile> {
  String? value;
  Widget? leadingIcon;
  String? heading;
  Function? onPressed;
  var key;

  _UserInfoTileState(
      {@required this.heading,
      this.value,
      this.leadingIcon,
      this.onPressed,
      this.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return InkWell(
      key: key,
      onTap: () => onPressed!(),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  leadingIcon ?? Container(),
                  leadingIcon == null ? Container() : SizedBox(width: 8),
                  Text(
                    heading!,
                    style: textTheme.bodyLarge!.copyWith(
                        fontWeight:
                            value == null ? FontWeight.bold : FontWeight.normal,
                        fontSize: 15),
                  ),
                ],
              ),
              SizedBox(height: 8),
              value == null
                  ? Container()
                  : Text(
                      value!,
                      style: textTheme.bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
              value == null ? Container() : SizedBox(height: 8),
              Divider(
                thickness: 2.0,
              ),
            ],
          ),
          onPressed == null
              ? Container()
              : Positioned(
                  bottom: 24,
                  right: global.isRTL ? null : 0,
                  left: global.isRTL ? 0 : null,
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                  ),
                ),
        ],
      ),
    );
  }
}

class _UserOrdersDashboardBoxState extends State<UserOrdersDashboardBox> {
  String? value;
  Widget? leadingIcon;
  String? heading;
  Function? onPressed;

  _UserOrdersDashboardBoxState({@required this.heading, this.value});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          heading!,
          style: textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Text(
          value!,
          style: textTheme.titleMedium,
        )
      ],
    );
  }
}

class _UserProfileScreenState extends BaseRouteState {
  bool _isDataLoaded = false;
  GlobalKey<ScaffoldState>? _scaffoldKey1;
  TextEditingController _cName = new TextEditingController();
  FocusNode _fName = new FocusNode();
  FocusNode _fDismiss = new FocusNode();
  String? countryCode;
  TextEditingController dateinput = TextEditingController();
  TextEditingController _cEmail = new TextEditingController();
  FocusNode _fEmail = new FocusNode();
  String? phoneNumber;
  TextEditingController _cPhone = new TextEditingController();
  var _txtRedeemCode = new TextEditingController();
  FocusNode _fRedeemCode = new FocusNode();
  bool showContactUs = false;

  Widget _loadColumnData(dynamic heading, dynamic value) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.normal,
            fontSize: 15,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: textTheme.titleMedium,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
        key: _scaffoldKey1,
        appBar: AppBar(
            backgroundColor: ColorConstants.appBarColorWhite,
            automaticallyImplyLeading: false,
            leadingWidth: 46,
            actions: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => UserSettingsScreen(
                              a: widget.analytics,
                              o: widget.observer,
                            )),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(right: 8, top: 5, bottom: 5),
                  padding: EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.settings,
                      size: 24,
                      color: ColorConstants.newAppColor,
                    ),
                  ),
                ),
              ),
            ],
            centerTitle: false,
            title: InkWell(
                onTap: () {},
                child: Image.asset(
                  "assets/images/new_logo.png",
                  fit: BoxFit.contain,
                  height: 25,
                  alignment: Alignment.center, // this center is not working
                ))),
        body: !_isDataLoaded
            ? Container(
                color: ColorConstants.colorPageBackground,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
                color: ColorConstants.colorPageBackground,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 10,
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, top: 8, right: 10),
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color: ColorConstants.greyDull),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        global.currentUser !=
                                                                    null &&
                                                                global
                                                                    .stayLoggedIN! &&
                                                                global.currentUser
                                                                        .name !=
                                                                    null
                                                            ? Container(
                                                                width: (MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    1.7),
                                                                child: Text(
                                                                  global.currentUser
                                                                              .name ==
                                                                          null
                                                                      ? "Hello, ${global.currentUser.email!.substring(0, global.currentUser.email!.indexOf("@"))}"
                                                                      : "Hello, ${global.currentUser.name}",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900,
                                                                      fontFamily:
                                                                          fontRalewayMedium,
                                                                      color: ColorConstants
                                                                          .appColor,
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                              )
                                                            : SizedBox(),
                                                        global.currentUser !=
                                                                    null &&
                                                                global
                                                                    .stayLoggedIN! &&
                                                                global.currentUser
                                                                        .id !=
                                                                    null // A2 wanted
                                                            ? InkWell(
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(
                                                                        NavigationUtils.createAnimatedRoute(
                                                                            1.0,
                                                                            ProfileEditScreen(
                                                                              a: widget.analytics,
                                                                              o: widget.observer,
                                                                            )),
                                                                      )
                                                                      .then(
                                                                          (card) =>
                                                                              {
                                                                                setState(() {
                                                                                  setState(() {});
                                                                                })
                                                                              });
                                                                },
                                                                child: Icon(
                                                                    Icons.edit,
                                                                    size: 24,
                                                                    color: ColorConstants
                                                                        .appColor),
                                                              )
                                                            : SizedBox(),
                                                      ],
                                                    ),
                                                    global.currentUser !=
                                                                null &&
                                                            global
                                                                .stayLoggedIN! &&
                                                            global.currentUser
                                                                    .id !=
                                                                null
                                                        ? SizedBox(
                                                            height: 8,
                                                          )
                                                        : SizedBox(),
                                                    Row(
                                                      children: [
                                                        RichText(
                                                          text: TextSpan(
                                                            text: global
                                                                            .currentUser !=
                                                                        null &&
                                                                    global
                                                                        .stayLoggedIN! &&
                                                                    global.currentUser
                                                                            .email !=
                                                                        null &&
                                                                    global
                                                                        .currentUser
                                                                        .email!
                                                                        .isNotEmpty
                                                                ? global
                                                                    .currentUser
                                                                    .email
                                                                : '',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontFamily:
                                                                    fontRailwayRegular,
                                                                color: global
                                                                            .currentUser
                                                                            .email ==
                                                                        null
                                                                    ? ColorConstants
                                                                        .newAppColor
                                                                    : ColorConstants
                                                                        .newAppColor,
                                                                fontSize: global
                                                                            .currentUser
                                                                            .email ==
                                                                        null
                                                                    ? 16
                                                                    : 13),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    global.currentUser !=
                                                                null &&
                                                            global
                                                                .stayLoggedIN! &&
                                                            global.currentUser
                                                                    .id !=
                                                                null
                                                        ? SizedBox(
                                                            height: 8,
                                                          )
                                                        : SizedBox(),
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        LoginScreen(
                                                                          a: widget
                                                                              .analytics,
                                                                          o: widget
                                                                              .observer,
                                                                          logout:
                                                                              false,
                                                                        )));
                                                      },
                                                      child: Row(
                                                        children: [
                                                          !global.stayLoggedIN!
                                                              ? Expanded(
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets.only(
                                                                        top: 8,
                                                                        bottom:
                                                                            8),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.all(
                                                                              Radius.circular(7.0),
                                                                            ),
                                                                            color: ColorConstants.appColor),
                                                                    child: Text(
                                                                        "SIGN IN/ SIGN UP",
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                fontRalewayMedium,
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                ColorConstants.white,
                                                                            letterSpacing: 1)),
                                                                  ),
                                                                )
                                                              : RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text: global.stayLoggedIN! &&
                                                                            global.currentUser.userPhone !=
                                                                                null &&
                                                                            global.currentUser.countryCode !=
                                                                                null
                                                                        ? "${global.currentUser.countryCode} ${global.currentUser.userPhone}"
                                                                        : "",
                                                                    style: TextStyle(
                                                                        fontWeight: global.currentUser.userPhone ==
                                                                                null
                                                                            ? FontWeight
                                                                                .w600
                                                                            : FontWeight
                                                                                .w200,
                                                                        fontFamily:
                                                                            fontOufitMedium,
                                                                        color: global.currentUser.userPhone ==
                                                                                null
                                                                            ? ColorConstants
                                                                                .appColor
                                                                            : ColorConstants
                                                                                .appColor,
                                                                        fontSize: global.currentUser.userPhone ==
                                                                                null
                                                                            ? 16
                                                                            : 13),
                                                                  ),
                                                                ), // A2 wanted
                                                        ],
                                                      ), // Row
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                            ),

                            global.currentUser != null &&
                                    global.stayLoggedIN! &&
                                    global.currentUser.id != null
                                ? InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UserMemberListScreen(
                                                  a: widget.analytics,
                                                  o: widget.observer,
                                                )),
                                      );
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: ColorConstants
                                              .colorPageBackground,
                                        ),
                                        padding: EdgeInsets.only(
                                          top: 12,
                                          bottom: 12,
                                          left: 12,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(width: 10),
                                                Image.asset(
                                                  'assets/images/iv_category.png',
                                                  width: 20,
                                                  height: 20,
                                                  fit: BoxFit.fill,
                                                  color:
                                                      ColorConstants.appColor,
                                                ),
                                                SizedBox(width: 18),
                                                Text("Special Days",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            fontRailwayRegular,
                                                        color: ColorConstants
                                                            .pureBlack,
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        fontSize: 15)),
                                                Expanded(
                                                  child: Text(" ",
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              fontRailwayRegular,
                                                          color: ColorConstants
                                                              .pureBlack,
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          fontSize: 25)),
                                                )
                                              ],
                                            ),
                                            SizedBox(width: 10),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),

                            global.currentUser != null &&
                                    global.stayLoggedIN! &&
                                    global.currentUser.id != null
                                ? InkWell(
                                    onTap: () {
                                      if (global.currentUser.id != null) {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CheckoutScreen(
                                                    a: widget.analytics,
                                                    o: widget.observer,
                                                    fromProfile: true,
                                                  )),
                                        );
                                      } else {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => LoginScreen(
                                                    a: widget.analytics,
                                                    o: widget.observer,
                                                  )),
                                        );
                                      }
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: ColorConstants
                                              .colorPageBackground,
                                        ),
                                        padding: EdgeInsets.only(
                                          top: 12,
                                          bottom: 12,
                                          left: 12,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(width: 10),
                                                Image.asset(
                                                  'assets/images/Your-Address.png',
                                                  width: 25,
                                                  height: 25,
                                                  fit: BoxFit.fill,
                                                  color:
                                                      ColorConstants.appColor,
                                                ),
                                                SizedBox(width: 18),
                                                Text("Your Addresses",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            fontRailwayRegular,
                                                        color: ColorConstants
                                                            .pureBlack,
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        fontSize: 15)),
                                                Expanded(
                                                  child: Text(" ",
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              fontRailwayRegular,
                                                          color: ColorConstants
                                                              .pureBlack,
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          fontSize: 25)),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              height: 1,
                            ),

                            global.currentUser != null &&
                                    global.stayLoggedIN! &&
                                    global.currentUser.id != null
                                ? InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OrderHistoryScreen(
                                                  a: widget.analytics,
                                                  o: widget.observer,
                                                )),
                                      );
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: ColorConstants
                                              .colorPageBackground,
                                        ),
                                        padding: EdgeInsets.only(
                                          top: 12,
                                          bottom: 12,
                                          left: 12,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(width: 10),
                                                Image.asset(
                                                  'assets/images/Your-Orders.png',
                                                  width: 25,
                                                  height: 25,
                                                  fit: BoxFit.fill,
                                                  color:
                                                      ColorConstants.appColor,
                                                ),
                                                SizedBox(width: 18),
                                                Text("Your Orders",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            fontRailwayRegular,
                                                        color: ColorConstants
                                                            .pureBlack,
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        fontSize: 15)),
                                                Expanded(
                                                  child: Text(" ",
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              fontRailwayRegular,
                                                          color: ColorConstants
                                                              .pureBlack,
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          fontSize: 25)),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),

                            global.currentUser != null &&
                                    global.stayLoggedIN! &&
                                    global.currentUser.id != null
                                ? InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => CouponsScreen(
                                                  a: widget.analytics,
                                                  o: widget.observer,
                                                  fromDrawer: true,
                                                )),
                                      );
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: ColorConstants
                                              .colorPageBackground,
                                        ),
                                        padding: EdgeInsets.only(
                                          top: 12,
                                          bottom: 12,
                                          left: 12,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(width: 10),
                                                Image.asset(
                                                  'assets/images/Coupons_red.png',
                                                  width: 25,
                                                  height: 25,
                                                  fit: BoxFit.fill,
                                                  color:
                                                      ColorConstants.appColor,
                                                ),
                                                SizedBox(width: 18),
                                                Text("Coupons",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            fontRailwayRegular,
                                                        color: ColorConstants
                                                            .pureBlack,
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        fontSize: 15)),
                                                Expanded(
                                                  child: Text("",
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              fontRailwayRegular,
                                                          color: ColorConstants
                                                              .pureBlack,
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          fontSize: 25)),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),

                            // global.currentUser != null &&
                            //         global.currentUser.id != null
                            //     ? InkWell(
                            //         onTap: () {
                            //           Navigator.of(context).push(
                            //             MaterialPageRoute(
                            //                 builder: (context) =>
                            //                     TransactionHistoryScreen(
                            //                       a: widget.analytics,
                            //                       o: widget.observer,
                            //                     )),
                            //           );
                            //         },
                            //         child: Container(
                            //           width: MediaQuery.of(context).size.width,
                            //           child: Container(
                            //             decoration: BoxDecoration(
                            //                 //   border: Border.all(
                            //                 // color: ColorConstants.color2,
                            //                 // width: 1,)
                            //                 color: Colors.white),
                            //             padding: EdgeInsets.only(
                            //               top: 12,
                            //               bottom: 12,
                            //               left: 12,
                            //             ),
                            //             child: Column(
                            //               mainAxisAlignment:
                            //                   MainAxisAlignment.start,
                            //               crossAxisAlignment:
                            //                   CrossAxisAlignment.start,
                            //               children: [
                            //                 Row(
                            //                   children: [
                            //                     SizedBox(width: 10),
                            //                     Image.asset(
                            //                       'assets/images/Transaction-History.png',
                            //                       width: 25,
                            //                       height: 25,
                            //                       fit: BoxFit.fill,
                            //                       // color: ColorConstants.allIconsBlack45,
                            //                     ),
                            //                     SizedBox(width: 18),
                            //                     Text("Transaction History",
                            //                         style: TextStyle(
                            //                             fontFamily:
                            //                                 fontRailwayRegular,
                            //                             color: ColorConstants
                            //                                 .pureBlack,
                            //                             fontWeight: FontWeight.w200,
                            //                             fontSize: 15)),
                            //                     Expanded(
                            //                       child: Text(" ",
                            //                           textAlign: TextAlign.end,
                            //                           style: TextStyle(
                            //                               fontFamily:
                            //                                   fontRailwayRegular,
                            //                               color: ColorConstants
                            //                                   .pureBlack,
                            //                               fontWeight:
                            //                                   FontWeight.w200,
                            //                               fontSize: 25)),
                            //                     )
                            //                   ],
                            //                 ),
                            //               ],
                            //             ),
                            //           ),
                            //         ),
                            //       )
                            //     : Container(),

                            global.currentUser != null &&
                                    global.stayLoggedIN! &&
                                    global.currentUser.id != null
                                ? InkWell(
                                    onTap: () {
                                      _txtRedeemCode.text = "";
                                      setState(() {});
                                      showReedemCodeSheet();
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: ColorConstants
                                              .colorPageBackground,
                                        ),
                                        padding: EdgeInsets.only(
                                          top: 12,
                                          bottom: 12,
                                          left: 12,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(width: 10),
                                                Container(
                                                  child: Image.asset(
                                                    'assets/images/redeem_code.png',
                                                    width: 25,
                                                    height: 25,
                                                    color:
                                                        ColorConstants.appColor,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                                SizedBox(width: 18),
                                                Text("Gift Voucher",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            fontRailwayRegular,
                                                        color: ColorConstants
                                                            .pureBlack,
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        fontSize: 15)),
                                                Expanded(
                                                  child: Text(" ",
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              fontRailwayRegular,
                                                          color: ColorConstants
                                                              .pureBlack,
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          fontSize: 25)),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(),

                            global.currentUser != null &&
                                    global.stayLoggedIN! &&
                                    global.currentUser.id != null
                                ? InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => WalletScreen(
                                                  a: widget.analytics,
                                                  o: widget.observer,
                                                  totalAmount: 0,
                                                )),
                                      );
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: ColorConstants
                                              .colorPageBackground,
                                        ),
                                        padding: EdgeInsets.only(
                                          top: 12,
                                          bottom: 12,
                                          left: 12,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(width: 10),
                                                Container(
                                                  child: Image.asset(
                                                    'assets/images/wallet_red.png',
                                                    width: 25,
                                                    height: 25,
                                                    fit: BoxFit.fill,
                                                    color:
                                                        ColorConstants.appColor,
                                                  ),
                                                ),
                                                SizedBox(width: 18),
                                                Text("Wallet",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            fontRailwayRegular,
                                                        color: ColorConstants
                                                            .pureBlack,
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        fontSize: 15)),
                                                Expanded(
                                                  child: Text(" ",
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              fontRailwayRegular,
                                                          color: ColorConstants
                                                              .pureBlack,
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          fontSize: 25)),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),

                            global.currentUser != null &&
                                    global.stayLoggedIN! &&
                                    global.currentUser.id != null
                                ? InkWell(
                                    onTap: () async {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ReferralShareScreen(
                                                      a: widget.analytics,
                                                      o: widget.observer)));
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: ColorConstants
                                              .colorPageBackground,
                                        ),
                                        padding: EdgeInsets.only(
                                          top: 12,
                                          bottom: 12,
                                          left: 12,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(width: 10),
                                                Image.asset(
                                                  'assets/images/referral_red.png',
                                                  width: 25,
                                                  height: 25,
                                                  fit: BoxFit.fill,
                                                  color:
                                                      ColorConstants.appColor,
                                                ),
                                                SizedBox(width: 18),
                                                Text("Referral",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            fontRailwayRegular,
                                                        color: ColorConstants
                                                            .pureBlack,
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        fontSize: 15)),
                                                Expanded(
                                                  child: Text(" ",
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              fontRailwayRegular,
                                                          color: ColorConstants
                                                              .pureBlack,
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          fontSize: 25)),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            SizedBox(height: 1),
                            global.currentUser != null &&
                                    global.stayLoggedIN! &&
                                    global.currentUser.id != null
                                ? InkWell(
                                    onTap: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NotificationScreen(
                                                    a: widget.analytics,
                                                    o: widget.observer,
                                                  )));
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: ColorConstants
                                                .colorPageBackground),
                                        padding: EdgeInsets.only(
                                          top: 12,
                                          bottom: 12,
                                          left: 12,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(width: 10),
                                                Icon(
                                                  Icons.notifications_none,
                                                  size: 25,
                                                  color:
                                                      ColorConstants.appColor,
                                                  weight: 200,
                                                ),
                                                SizedBox(width: 18),
                                                Text("Notifications",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            fontRailwayRegular,
                                                        color: ColorConstants
                                                            .pureBlack,
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        fontSize: 15)),
                                                Expanded(
                                                  child: Text(" ",
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              fontRailwayRegular,
                                                          color: ColorConstants
                                                              .pureBlack,
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          fontSize: 25)),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            SizedBox(height: 1),
                            // ContactUsScreen

                            // global.currentUser == "fggf"
                            //     ? Container(
                            //         width: MediaQuery.of(context).size.width,
                            //         decoration: BoxDecoration(
                            //             color:
                            //                 ColorConstants.colorPageBackground),
                            //         child: Row(
                            //           children: [
                            //             Expanded(
                            //               child: InkWell(
                            //                 onTap: () {
                            //                   // Navigator.of(context).push(
                            //                   //     MaterialPageRoute(
                            //                   //         builder: (context) =>
                            //                   //             CorporateGiftsScreen(
                            //                   //               a: widget.analytics,
                            //                   //               o: widget.observer,
                            //                   //             )));
                            //                   _launchURL(
                            //                       "https://corporate.byyu.com/");
                            //                 },
                            //                 child: Container(
                            //                   child: Container(
                            //                     decoration: BoxDecoration(
                            //                       color: ColorConstants
                            //                           .colorPageBackground,
                            //                     ),
                            //                     padding: EdgeInsets.only(
                            //                       top: 12,
                            //                       bottom: 12,
                            //                       left: 12,
                            //                     ),
                            //                     child: Row(
                            //                       children: [
                            //                         SizedBox(width: 10),
                            //                         Image.asset(
                            //                           'assets/images/ic_corporate_red.png',
                            //                           width: 22,
                            //                           height: 22,
                            //                           fit: BoxFit.fill,
                            //                           color: ColorConstants
                            //                               .appColor,
                            //                         ),
                            //                         SizedBox(width: 18),
                            //                         Text("Corporate Gifts",
                            //                             style: TextStyle(
                            //                                 fontFamily:
                            //                                     fontRailwayRegular,
                            //                                 color:
                            //                                     ColorConstants
                            //                                         .pureBlack,
                            //                                 fontWeight:
                            //                                     FontWeight.w200,
                            //                                 fontSize: 15)),
                            //                       ],
                            //                     ),
                            //                   ),
                            //                 ),
                            //               ),
                            //             ),
                            //             SizedBox(width: 10),
                            //           ],
                            //         ),
                            //       )
                            //     : Container(),

                            SizedBox(height: 2),
                            // ContactUsScreen
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(color: Colors.white),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        contactUsView();
                                        setState(() {});
                                      },
                                      child: Container(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: ColorConstants
                                                  .colorPageBackground),
                                          padding: EdgeInsets.only(
                                            top: 12,
                                            bottom: 12,
                                            left: 12,
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(width: 10),
                                              Image.asset(
                                                'assets/images/Contact-Us.png',
                                                width: 25,
                                                height: 25,
                                                fit: BoxFit.fill,
                                                color: ColorConstants.appColor,
                                              ),
                                              SizedBox(width: 18),
                                              Text("Contact Us",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          fontRailwayRegular,
                                                      color: ColorConstants
                                                          .pureBlack,
                                                      fontWeight:
                                                          FontWeight.w200,
                                                      fontSize: 15)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                            ),
                            SizedBox(height: 1),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: ColorConstants.colorPageBackground,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FrequentlyQuestionsScreen(
                                                    a: widget.analytics,
                                                    o: widget.observer,
                                                  )),
                                        );
                                      },
                                      child: Container(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: ColorConstants
                                                .colorPageBackground,
                                          ),
                                          padding: EdgeInsets.only(
                                            top: 12,
                                            bottom: 12,
                                            left: 12,
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(width: 10),
                                              Icon(
                                                Icons.question_mark_outlined,
                                                color: ColorConstants.appColor,
                                                size: 25,
                                              ),
                                              SizedBox(width: 18),
                                              Text("FAQ",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          fontRailwayRegular,
                                                      color: ColorConstants
                                                          .pureBlack,
                                                      fontWeight:
                                                          FontWeight.w200,
                                                      fontSize: 15)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                            ),

                            SizedBox(height: 2),

                            global.currentUser != null &&
                                    global.stayLoggedIN! &&
                                    global.currentUser.id != null
                                ? InkWell(
                                    onTap: () {
                                      if (Platform.isAndroid ||
                                          Platform.isIOS) {
                                        final url = Uri.parse(
                                          Platform.isAndroid
                                              ? global.appInfo.androidAppLink
                                                  .toString()
                                              : global.appInfo.iosAppLink
                                                  .toString(),
                                        );
                                        launchUrl(
                                          url,
                                          mode: LaunchMode.externalApplication,
                                        );
                                      }
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: ColorConstants
                                              .colorPageBackground,
                                        ),
                                        padding: EdgeInsets.only(
                                          top: 12,
                                          bottom: 12,
                                          left: 12,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(width: 10),
                                                Image.asset(
                                                  'assets/images/Rate-this-app.png',
                                                  width: 25,
                                                  height: 25,
                                                  fit: BoxFit.fill,
                                                  color:
                                                      ColorConstants.appColor,
                                                ),
                                                SizedBox(width: 18),
                                                Text("Rate Us",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            fontRailwayRegular,
                                                        color: ColorConstants
                                                            .pureBlack,
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        fontSize: 15)),
                                                Expanded(
                                                  child: Text(" ",
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              fontRailwayRegular,
                                                          color: ColorConstants
                                                              .pureBlack,
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          fontSize: 25)),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            SizedBox(height: 1),
                            global.currentUser.id != null &&
                                    global.stayLoggedIN!
                                ? SizedBox(
                                    height: 10,
                                  )
                                : SizedBox(height: 1),

                            global.currentUser.id != null &&
                                    global.stayLoggedIN!
                                ? InkWell(
                                    onTap: () {
                                      if (global.currentUser.id == null) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen(
                                                        a: widget.analytics,
                                                        o: widget.observer)));
                                      } else {
                                        _signOutDialog(
                                            context,
                                            widget.analytics,
                                            widget.observer,
                                            true);
                                      }
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.only(bottom: 80),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: ColorConstants
                                              .colorPageBackground,
                                        ),
                                        padding: EdgeInsets.only(
                                          // top: 12,
                                          bottom: 12,
                                          left: 12,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(width: 10),
                                                Image.asset(
                                                  'assets/images/Log-Out.png',
                                                  width: 25,
                                                  height: 25,
                                                  fit: BoxFit.fill,
                                                  color: ColorConstants
                                                      .newAppColor,
                                                ),
                                                SizedBox(width: 18),
                                                Text("Sign Out",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            fontRailwayRegular,
                                                        color: ColorConstants
                                                            .pureBlack,
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        fontSize: 15)),
                                                Expanded(
                                                  child: Text(" ",
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              fontRailwayRegular,
                                                          color: ColorConstants
                                                              .pureBlack,
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          fontSize: 25)),
                                                )
                                              ],
                                            ),
                                            SizedBox(width: 10),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                )));
  }

  String allWordsCapitilize(String str) {
    return str.toLowerCase().split(' ').map((word) {
      String leftText = (word.length > 1) ? word.substring(1, word.length) : '';
      return word[0].toUpperCase() + leftText;
    }).join(' ');
  }

  _deactivatedAccount() async {
    try {
      _isDataLoaded = true;
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        await apiHelper.deactivatedAcount().then((result) async {
          if (result != null) {
            _isDataLoaded = false;
            print("G1--> ${result.message.toString()}");

            showSnackBarWithDuration(
              key: _scaffoldKey1,
              snackBarMessage: result.message.toString(),
            );
            global.sp!.remove("currentUser");
            global.currentUser = CurrentUser();
            Get.offAll(
                () => LoginScreen(a: widget.analytics, o: widget.observer));
          }
        });
      } else {}
    } catch (e) {
      print("Exception - search_screen.dart - _getRecentSearchData():" +
          e.toString());
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      _getMyProfile();
    }
  }

  SharedPreferences? preference;
  @override
  void initState() {
    super.initState();
    print("check Profile Data API");
      //  _getMyProfile();
    if (global.goToCorporatePage) {
      Future.delayed(Duration.zero, () {
        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => CorporateGiftsScreen(
                      a: widget.analytics,
                      o: widget.observer,
                    )))
            .then((value) => {
                  global.goToCorporatePage = false,
                  if (global.stayLoggedIN == null)
                    {
                      global.stayLoggedIN = false,
                    },
                  _isDataLoaded = true,
                  Future.delayed(Duration.zero, () {
                    if (global.currentUser != null &&
                        global.currentUser.id != null) {
                      _getMyProfile();
                    }
                  }),
                });
      });
    } else {
      print("this is the stay logged in value${global.stayLoggedIN}");
      if (global.stayLoggedIN == null) {
        global.stayLoggedIN = false;
      }
      _isDataLoaded = true;

      Future.delayed(Duration.zero, () {
        if (global.currentUser != null && global.currentUser.id != null) {
          _getMyProfile();
        }
      });
    }
  }

  showOnlyLoaderDialog1() {
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

  void hideLoader() {
    Navigator.pop(context);
  }

  _getMyProfile() async {
    preference = await SharedPreferences.getInstance();
    showOnlyLoaderDialog1();
    _isDataLoaded = true;
    try {
      await apiHelper.myProfile().then((result) async {
        if (result != null) {
          if (result.status == "1") {
            print("1111111>>>>>>");
            currentUser = result.data;
            global.currentUser = currentUser;

            hideLoader();
            _isDataLoaded = true;
            setState(() {
              _getAppInfo();
            });
          } else {
             print("222222222222>>>>>>");
            hideLoader();
            _isDataLoaded = true;
            currentUser = new CurrentUser();
            setState(() {
              _getAppInfo();
            });
          }
        }
      });
    } catch (e) {
      _isDataLoaded = false;
       print("3333333333333>>>>>>");

      print("Exception - UserProfileScreen.dart - _getMyProfile():" +
          e.toString());
    }
  }

  _getAppInfo() async {
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        await apiHelper.getAppInfo().then((result) async {
          if (result != null) {
            if (result.status == "1") {
              global.appInfo = result.data;

              setState(() {});
            }
          }
        });
      }
    } catch (e) {
      print("Exception - splash_screen.dart - _getAppInfo():" + e.toString());
    } finally {}
  }

  _signOutDialog(context, a, o, bool logout) {
    try {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(dialogBackgroundColor: Colors.white),
              child: CupertinoAlertDialog(
                content: Text(
                  'Are you sure you want to sign out?',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: fontRailwayRegular,
                      fontWeight: FontWeight.w200,
                      color: ColorConstants.pureBlack),
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: fontRalewayMedium,
                          fontWeight: FontWeight.w200,
                          color: ColorConstants.newTextHeadingFooter),
                    ),
                    onPressed: () {
                      return Navigator.of(context).pop(false);
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text(
                      'Yes',
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: global.fontRalewayMedium,
                          fontWeight: FontWeight.w200,
                          color: ColorConstants.newAppColor),
                    ),
                    onPressed: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();

                      bool quickLoginEnabled = false;
                      if (preferences.containsKey('quickLoginEnabled')) {
                        quickLoginEnabled =
                            preferences.getBool('quickLoginEnabled')!;
                      }

                      await preferences.clear();
                      preferences.setString(global.appLoadString, "true");
                      // preferences.setString(
                      //     'currentUser', json.encode(global.currentUser));
                      // preferences.setString(
                      //     'userInfo', json.encode(global.currentUser));
                      global.currentUser = CurrentUser();
                      print(
                          "this is the print on signout current user---=-=-=--=-=---=-=-==--=");
                      print(global.currentUser);
                      global.wishlistCount = 0;
                      global.cartCount = 0;
                      preferences.setBool(
                          global.quickLoginEnabled, quickLoginEnabled);
                      preferences.setBool(global.isLoggedIn, false);
                      global.stayLoggedIN = false;
                      Navigator.of(context).pop(false);
                      setState(() {});
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                    logout: false,
                                  )));
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

  Future<Null> updated(StateSetter updateState) async {
    updateState(() {});
  }

  showReedemCodeSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, state) {
            return WillPopScope(
                onWillPop: () async {
                  if (global.currentUser.countryCode == null) {
                    if (global.currentUser != null &&
                        global.currentUser.id != null) {
                      _getMyProfile();
                    }
                  }
                  boolRedemCodErrorVisible = false;
                  Navigator.pop(context);
                  return true;
                },
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    FocusScope.of(context)
                        .unfocus(); // Hide keyboard on outside tap
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom > 0
                          ? MediaQuery.of(context).viewInsets.bottom
                          : MediaQuery.of(context).padding.bottom > 0
                              ? MediaQuery.of(context).padding.bottom
                              : 0,
                    ),
                    child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 40),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                                color: ColorConstants.white),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(child: Text("")),
                                    InkWell(
                                      onTap: () {
                                        boolRedemCodErrorVisible = false;
                                        Navigator.pop(context);
                                      },
                                      child: Icon(
                                        Icons.close,
                                        color: ColorConstants.appColor,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 10, bottom: 1),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: global.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7.0))),
                                    padding: EdgeInsets.only(
                                        left: 5,
                                        bottom: 10,
                                        right: 10,
                                        top: 10),
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: MyTextField(
                                              suffixIcon: InkWell(
                                                  onTap: () {
                                                    _txtRedeemCode.text = "";
                                                    setState(() {});
                                                  },
                                                  child: Icon(
                                                    Icons.cancel,
                                                    color: ColorConstants
                                                        .newAppColor,
                                                    size: 20,
                                                  )),
                                              Key('21'),
                                              controller: _txtRedeemCode,
                                              inputTextFontWeight:
                                                  FontWeight.w200,
                                              focusNode: _fRedeemCode,
                                              textCapitalization:
                                                  TextCapitalization.characters,
                                              hintText: 'Enter Gift Voucher',
                                              maxLines: 1,
                                              onFieldSubmitted: (val) {},
                                              onChanged: (str) {
                                                if (str.trim().length > 0) {
                                                  boolRedemCodErrorVisible =
                                                      false;
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                    visible: boolRedemCodErrorVisible,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width -
                                          20,
                                      child: Text(
                                        strRedeemCodeError,
                                        style: global.errorTextStyle,
                                      ),
                                    )),
                                boolRedemCodErrorVisible
                                    ? SizedBox(
                                        height: 10,
                                      )
                                    : SizedBox(),
                                InkWell(
                                  onTap: () async {
                                    if (_txtRedeemCode != null &&
                                        _txtRedeemCode.text.isNotEmpty) {
                                      await _getRewardsWalletRedeemList(
                                          _txtRedeemCode.text, state);
                                    } else {
                                      boolRedemCodErrorVisible = true;
                                      strRedeemCodeError =
                                          "Please Enter Redeem code";
                                      updated(state);
                                    }
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    padding: EdgeInsets.only(
                                        left: 8, right: 8, top: 8, bottom: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      color: ColorConstants.appColor,
                                      border: Border.all(
                                          width: 0.5,
                                          color: ColorConstants.appColor),
                                    ),
                                    child: Container(
                                      child: Text(
                                        "APPLY",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: fontOufitMedium,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: ColorConstants.white,
                                            letterSpacing: 1),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
          });
        });
  }

  String strRedeemCodeError = "";
  bool boolRedemCodErrorVisible = false;

  _getRewardsWalletRedeemList(String enteredCode, state) async {
    try {
      showOnlyLoaderDialog();
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        await apiHelper.redeemRewardWallet(enteredCode).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              print("Nikhil---------------------1");
              _txtRedeemCode.text = "";
              boolRedemCodErrorVisible = true;
              strRedeemCodeError = result.message;
              hideLoader();
            } else {
              hideLoader();
              boolRedemCodErrorVisible = true;
              strRedeemCodeError = result.message;
            }
          }
        });
      } else {
        hideLoader();
        boolRedemCodErrorVisible = true;
        strRedeemCodeError = "Please check you internet connection";
        print("Nikhil---------------------3");
      }
      updated(state);
      setState(() {});
    } catch (e) {
      hideLoader();
      print("Nikhil---------------------4");
      boolRedemCodErrorVisible = true;
      strRedeemCodeError = "Something went wrong, Please try again.";
      print(
          "Exception - RewardsWalletRedeem_screen.dart - _getRewardsWalletRedeemList():" +
              e.toString());
    }
  }

  contactUsView() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            if (global.currentUser.countryCode == null) {
              if (global.currentUser != null && global.currentUser.id != null) {
                _getMyProfile();
              }
            }
            Navigator.pop(context);
            return true;
          },
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom > 0
                  ? MediaQuery.of(context).viewInsets.bottom
                  : MediaQuery.of(context).padding.bottom > 0
                      ? MediaQuery.of(context).padding.bottom
                      : 10,
            ),
            decoration: BoxDecoration(color: Colors.transparent),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text("")),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.close,
                            color: ColorConstants.newAppColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 30),
                    child: InkWell(
                      onTap: () {
                        final Uri _emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: appInfo.contactEmail,
                            queryParameters: {'subject': ''});
                        launch(_emailLaunchUri.toString());
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            color: ColorConstants.newAppColor,
                            size: 30,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "EMAIL",
                                style: TextStyle(
                                    fontFamily: fontRailwayRegular,
                                    color: ColorConstants.pureBlack,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14),
                              ),
                              SizedBox(height: 5),
                              Text(
                                global.appInfo != null &&
                                        global.appInfo.contactEmail != null &&
                                        global.appInfo.contactEmail!.length > 0
                                    ? "${global.appInfo.contactEmail}"
                                    : "",
                                style: TextStyle(
                                    fontFamily: fontOufitMedium,
                                    color: ColorConstants.appColor,
                                    fontWeight: FontWeight.w200,
                                    fontSize: 14),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 30),
                    child: InkWell(
                      onTap: () async {
                        await _launchWhatsapp();
                      },
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.whatsapp,
                            color: ColorConstants.newAppColor,
                            size: 30,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "WHATSAPP",
                                style: TextStyle(
                                    fontFamily: fontRailwayRegular,
                                    color: ColorConstants.pureBlack,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14),
                              ),
                              SizedBox(height: 5),
                              Text(
                                global.appInfo != null &&
                                        global.appInfo.contactWhatsApp !=
                                            null &&
                                        global.appInfo.contactWhatsApp!.length >
                                            0
                                    ? "${global.appInfo.contactWhatsApp}"
                                    : "",
                                style: TextStyle(
                                    fontFamily: fontOufitMedium,
                                    color: ColorConstants.appColor,
                                    fontWeight: FontWeight.w200,
                                    fontSize: 14),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 30),
                    child: InkWell(
                      onTap: () {
                        callNumberStore(global.appInfo.contactPhone);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            color: ColorConstants.newAppColor,
                            size: 30,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "CONTACT NUMBER",
                                style: TextStyle(
                                    fontFamily: fontRailwayRegular,
                                    color: ColorConstants.pureBlack,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14),
                              ),
                              SizedBox(height: 5),
                              Text(
                                global.appInfo != null &&
                                        global.appInfo.contactPhone != null &&
                                        global.appInfo.contactPhone!.length > 0
                                    ? "${global.appInfo.contactPhone!.trim()}"
                                    : "",
                                style: TextStyle(
                                    fontFamily: fontOufitMedium,
                                    color: ColorConstants.appColor,
                                    fontWeight: FontWeight.w200,
                                    fontSize: 14),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 2, right: 2, top: 5, bottom: 10),
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: InkWell(
                          onTap: () {
                            _launchSocialMediaAppIfInstalled(
                              url:
                                  'https://www.facebook.com/profile.php?id=61552755963187', // Facebook
                            );
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            // padding: EdgeInsets.only(top:10,right: 15,bottom:10,left:15),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: ColorConstants.socialIconsBackground),
                            child: Image.asset(
                              "assets/images/facebookgrad.png",
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: InkWell(
                          onTap: () {
                            _launchSocialMediaAppIfInstalled(
                                url: "https://twitter.com/byyu_com");
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            // padding: EdgeInsets.only(top:10,right: 15,bottom:10,left:15),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: ColorConstants.socialIconsBackground),
                            child: Image.asset(
                              "assets/images/twitter_gradient.png",
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: InkWell(
                          onTap: () {
                            _launchSocialMediaAppIfInstalled(
                                url:
                                    "https://www.linkedin.com/company/101379431/admin/settings/");
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            // padding: EdgeInsets.only(top:10,right: 15,bottom:10,left:15),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: ColorConstants.socialIconsBackground),
                            child: Image.asset(
                              "assets/images/linkedin_gradient.png",
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: InkWell(
                          onTap: () async {
                            await _launchWhatsapp();
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            // padding: EdgeInsets.only(top:10,right: 15,bottom:10,left:15),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: ColorConstants.socialIconsBackground),
                            child: Image.asset(
                              "assets/images/whatsapp.png",
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: InkWell(
                          onTap: () {
                            _launchSocialMediaAppIfInstalled(
                                url: "https://www.instagram.com/byyu.ae/");
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            // padding: EdgeInsets.only(top:10,right: 15,bottom:10,left:15),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: ColorConstants.socialIconsBackground),
                            child: Image.asset(
                              "assets/images/instagram_grdient.png",
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: InkWell(
                          onTap: () {
                            _launchSocialMediaAppIfInstalled(
                                url: "https://www.tiktok.com/@byyu.ae/");
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            // padding: EdgeInsets.only(top:10,right: 15,bottom:10,left:15),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: ColorConstants.socialIconsBackground),
                            child: Image.asset(
                              "assets/images/tiktok.png",
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: Platform.isIOS ? 20 : 10,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void callNumberStore(store_number) async {
    await launch('tel:$store_number');
  }

  _launchWhatsapp() async {
    print(global.appInfo.contactWhatsApp!.replaceAll(" ", ""));
    var whatsapp = "";
    if (global.appInfo.contactWhatsApp!.contains(" ")) {
      whatsapp = global.appInfo.contactWhatsApp!.replaceAll(" ", "");
    } else {
      whatsapp = global.appInfo.contactWhatsApp!;
    }

    var iosUrl = "https://wa.me/$whatsapp?text=${Uri.parse('Hello!')}";
    if (Platform.isIOS) {
      if (await canLaunch(iosUrl)) {
        await launch(iosUrl, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: new Text("WhatsApp is not installed on the device")));
      }
    } else {
      // var whatsappUrl = "whatsapp://send?phone=$whatsapp";
      var whatsappUrl = "https://wa.me/$whatsapp?text=${Uri.parse('Hello!')}";
      await canLaunch(whatsappUrl)
          ? launch(whatsappUrl)
          : print(
              "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(Uri.parse(whatsappUrl));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("WhatsApp is not installed on the device"),
          ),
        );
      }
    }
  }

  Future<void> _launchSocialMediaAppIfInstalled({
    String? url,
  }) async {
    try {
      bool launched = await launch(url!,
          forceSafariVC: false); // Launch the app if installed!

      if (!launched) {
        launch(url); // Launch web view if app is not installed!
      }
    } catch (e) {
      launch(url!); // Launch web view if app is not installed!
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication, // Opens in browser
    )) {
      throw 'Could not launch $url';
    }
  }
}
