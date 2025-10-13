import 'dart:io';
import 'dart:math';
import 'package:banner_image/banner_image.dart';
import 'package:byyu/screens/auth/signup_screen.dart';
import 'package:byyu/screens/product/all_events_screen.dart';
import 'package:byyu/screens/product/filtered_sub_categories_screen.dart';
import 'package:byyu/screens/product/product_description_screen.dart';
import 'package:byyu/widgets/toastfile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/controllers/cart_controller.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/categoryListModel.dart';
import 'package:byyu/models/categoryProductModel.dart';
import 'package:byyu/models/homeScreenDataModel.dart';
import 'package:byyu/screens/address/addressListScreen.dart';
import 'package:byyu/screens/product/all_categories_screen.dart';
import 'package:byyu/screens/notification_screen.dart';
import 'package:byyu/screens/search_screen.dart';
import 'package:byyu/screens/product/sub_categories_screen.dart';
import 'package:byyu/utils/navigation_utils.dart';
import 'package:byyu/widgets/bundle_offers_menu.dart';

import '../models/businessLayer/global.dart';
import '../models/genderRelationSelectionFilter.dart';
import '../widgets/bottom_button.dart';
// import 'package:marquee_widget/marquee_widget.dart' as m;

class DashboardScreen extends BaseRoute {
  final Function onAppDrawerButtonPressed;
  @required
  int isSubscription;

  DashboardScreen(
      {a,
      o,
      required this.onAppDrawerButtonPressed,
      required this.isSubscription})
      : super(a: a, o: o, r: 'DashboardScreen');

  @override
  _DashboardScreenState createState() => _DashboardScreenState(
      onAppDrawerButtonPressed: onAppDrawerButtonPressed,
      isSubscription: isSubscription);
}

class _DashboardScreenState extends BaseRouteState with WidgetsBindingObserver {
  Function onAppDrawerButtonPressed;
  HomeScreenData? _homeScreenData;
  //ProductHomeDataList productHomeDataList;
  List<Product>? productListAll;
  List<Product> productSection1List = [];
  List<Product> productSection2List = [];
  List<Product> productSection3List = [];
  List<Product> productSection4List = [];
  List<Product> productSection5List = [];
  List<String> bannerEventImageURL = [];
  List<EventIconName> bannerEventIconURL = [];
  List<CategoryList>? categories;
  List<Product>? categoriesProducts;
  List<Product>? combos;
  List<Product>? personalizedGifts;
  int isSubscription = 0;
  Color _selectedBannerColor = ColorConstants.appColor;
  bool _isDataLoaded = false, _isLoading = false;
  int _selectedIndex = 0;
  int? _bannerIndex;
  int _currentIndex = 0, showCloseButton = 0;
  int _secondBannercurrentIndex = 0;
  // CarouselController _carouselController;
  // CarouselController _secondCarouselController;
  IconData lastTapped = Icons.notifications;
  AnimationController? menuAnimation;
  double _productContainerheight = 265.0;
  int? randomSearchProductId;

  bool showRelationField = false;
  bool hideRelationField = false;
  bool showAgeField = false;
  bool hideAgeField = false;
  bool showRecipientField = false;
  bool hideRecipientField = false;
  bool showOcassionField = false;
  bool hideOcassionField = false;
  int openedContainerHeight = 1;
  String recipient = "", relation = "";
  String ocassion = "";
  String selectedAge = "1";
  int _mincurrentValue = 18;
  int _maxcurrentValue = 23;
  int? selectedRecipient_ID,
      selectedRelation_ID,
      selectedOccasion_ID,
      selectedAge_ID;

  List<SearchRelationship> maleRelation = [];
  List<SearchRelationship> femaleRelation = [];

  int chooseRecePient = 0;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CartController cartController = Get.put(CartController());
  String homeLocation = '';

  SelectionData selectionData = new SelectionData();
  var SelectionFilterModel = 0;

  final ScrollController _scrollAutoController = ScrollController();

  _DashboardScreenState(
      {required this.onAppDrawerButtonPressed, required this.isSubscription});
  @override
  void didPopNext() {
    super.didPopNext();
    _isDataLoaded = true;
    if (global.isBannerShow == 1) {
      _init();
    }
    setState(() {});
  }

  // _launchWhatsapp() async {
  // AAAC useless code
  //   print('G1---->${global.appInfo.whatsapp_link}');
  //   // var whatsapp = "97142390322";
  //   var whatsapp = global.appInfo.whatsapp_link;
  //   // String whatsappURLIos =
  //   //     "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
  //   // "https://api.whatsapp.com/send?phone=$whatsapp";
  //   var iosUrl = "https://wa.me/$whatsapp?text=${Uri.parse('hello')}";

  //   if (Platform.isIOS) {
  //     if (await canLaunch(iosUrl)) {
  //       await launch(iosUrl, forceSafariVC: false);
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content: new Text("WhatsApp is not installed on the device")));
  //     }
  //     // if (await canLaunchUrl(Uri.parse(iosUrl))) {
  //     //   await launchUrl(Uri.parse(iosUrl));
  //     // } else {
  //     //   ScaffoldMessenger.of(context).showSnackBar(
  //     //     const SnackBar(
  //     //       content: Text("WhatsApp is not installed on the device"),
  //     //     ),
  //     //   );
  //     // }
  //   } else {
  //     var whatsappUrl = "whatsapp://send?phone=$whatsapp";
  //     await canLaunch(whatsappUrl)
  //         ? launch(whatsappUrl)
  //         : print(
  //             "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
  //     if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
  //       await launchUrl(Uri.parse(whatsappUrl));
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text("WhatsApp is not installed on the device"),
  //         ),
  //       );
  //     }
  //   }
  // }

  // setLocationScreen() {
  // AAAC useless code
  //   Navigator.of(context)
  //       .push(
  //         NavigationUtils.createAnimatedRoute(
  //           1.0,
  //           LocationSignupScreen(
  //             a: widget.analytics,
  //             o: widget.observer,
  //             isHomeSelected: "home",
  //             societyName: "societyName",
  //             latSelected: global.lat,
  //             lngSelected: global.lng,
  //           ),
  //         ),
  //       )
  //       .then((card) => {
  //             setState(() {
  //               // getNearByStore().then((value) async {
  //               //   if (
  //               //       global.appInfo.store_id != null) {
  //               //     await _getHomeScreenData();
  //               //     _isDataLoaded = true;
  //               //   }
  //               // });
  //               print("G1---->return");
  //               updateData();
  //             })
  //           });

  //   //  Get.to(() => LocationScreen(
  //   //                         a: widget.analytics,
  //   //                         o: widget.observer,
  //   //                         societyName: "",
  //   //                         isHomeSelected: 'home',
  //   //                         latSelected: global.lat,
  //   //                         lngSelected: global.lng,
  //   //                         societyLat: global.lat,
  //   //                         societyLng: global.lng,
  //   //                       ));
  // }

  // setAddressListScrren() {
  //AAAC useless code
  //   Navigator.of(context)
  //       .push(
  //         NavigationUtils.createAnimatedRoute(
  //           1.0,
  //           AddressListScreen(
  //             a: widget.analytics,
  //             o: widget.observer,
  //           ),
  //         ),
  //       )
  //       .then((card) => {
  //             setState(() {
  //               // _getMyAddressList();
  //               // add karne........................
  //             })
  //           });
  // }

  // updateData() async {
  /// AAAC useless code
  //   homeLocation = global.currentLocation!;

  //   _isDataLoaded = true;
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawerEnableOpenDragGesture: true,
      //drawer: sideDrawer(context, widget.analytics, widget.observer),
      appBar: AppBar(
          backgroundColor: ColorConstants.appBrownFaintColor,
          leadingWidth: 46,
          automaticallyImplyLeading: false, // use for back button remover
          centerTitle: false, // place logo in center
          // leading: InkWell(
          //   onTap: () => onAppDrawerButtonPressed(),
          //   child: Container(
          //     margin:
          //         EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
          //     width: MediaQuery.of(context).size.width - 23,
          //     height: MediaQuery.of(context).size.height - 23,
          //     child: Icon(
          //       Icons.menu,
          //       size: 35,
          //     ),
          //   ),
          //   // onTap: () {

          //   // },
          // ),
          actions: [
            // InkWell(
            //   onTap: () {
            //     Navigator.of(context).push(MaterialPageRoute(
            //         builder: (context) => SearchScreen(
            //               a: widget.analytics,
            //               o: widget.observer,
            //             )));
            //   },
            //   child: Icon(
            //     Icons.search,
            //     size: 30,
            //   ),
            // ),
            SizedBox(
              width: 8,
            ),
            // global.currentUser.id != null
            global.currentUser != null && global.currentUser.id != null //AA
                ? InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationScreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                  )));
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Icon(
                        Icons.notifications_none,
                        size: 25,
                        color: Colors.black45,
                      ),
                    ),
                  )
                : SizedBox(),

            SizedBox(
              width: 8,
            )
          ],
          title: Image.asset(
            "assets/images/new_logo.png",
            fit: BoxFit.contain,
            height: 35,
            alignment: Alignment.center,
          )),

      body: RefreshIndicator(
        onRefresh: () async {
          await _onRefresh();
        },
        child: _isDataLoaded && _homeScreenData != null
            ? Container(
                color: ColorConstants.colorPageBackground,
                child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(children: [
                      // Padding(
                      //   padding: EdgeInsets.only(left: 8, right: 8),
                      //   child: Row(
                      //     // mainAxisAlignment:
                      //     // MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Expanded(
                      //         child: InkWell(
                      //           // onTap: () => Get.to(() => SearchScreen(
                      //           //       a: widget.analytics,
                      //           //       o: widget.observer,
                      //           //     )),
                      //           onTap: () {
                      //             randomSearchProductId = _homeScreenData!
                      //                 .topselling![Random().nextInt(
                      //                     _homeScreenData!.topselling!.length)]
                      //                 .productId!;
                      //             print(
                      //                 "Search click This is the random product id from topseling${randomSearchProductId}");

                      //             Navigator.of(context)
                      //                 .push(NavigationUtils.createAnimatedRoute(
                      //                     1.0,
                      //                     SearchScreen(
                      //                       a: widget.analytics,
                      //                       o: widget.observer,
                      //                       searchProductId: randomSearchProductId!,
                      //                     )));
                      //           },
                      //           child: Container(
                      //             margin: EdgeInsets.symmetric(
                      //                 horizontal: 12, vertical: 10),
                      //             height:
                      //                 50, //MediaQuery.of(context).size.height - 758,
                      //             // width: 100,
                      //             decoration: BoxDecoration(
                      //               border: Border.all(
                      //                   color: global.textGrey, width: 0.1),
                      //               borderRadius: BorderRadius.all(
                      //                 Radius.circular(70),
                      //               ),
                      //               color: global.searchBox,
                      //             ),
                      //             child: Row(
                      //               children: <Widget>[
                      //                 SizedBox(
                      //                   width: 12,
                      //                 ),
                      //                 Expanded(
                      //                   child: Text(
                      //                     'Search Product',
                      //                     style: TextStyle(
                      //                         fontFamily:
                      //                             global.fontMetropolisRegular,
                      //                         fontWeight: FontWeight.w200,
                      //                         fontSize: 14,
                      //                         color: ColorConstants.grey),
                      //                   ),
                      //                 ),
                      //                 Icon(
                      //                   Icons.search,
                      //                   size: 30,
                      //                   color: ColorConstants.black26,
                      //                 ),
                      //                 SizedBox(
                      //                   width: 8,
                      //                 )
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      // Container(
                      //   width: MediaQuery.of(context).size.width,
                      //   margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                      //   child: MyTextBox(
                      //     isHomePage: true,
                      //     onTap: () {
                      //       Navigator.of(context).push(MaterialPageRoute(
                      //           builder: (context) => SearchScreen(
                      //                 a: widget.analytics,
                      //                 o: widget.observer,
                      //               )));
                      //     },

                      //     borderRadius: 50,
                      //     autofocus: false,
                      //     suffixIcon: Icon(Icons.cancel, color: Colors.black45
                      //         //Theme.of(context).primaryColor,
                      //         ),
                      //     prefixIcon: Icon(
                      //       Icons.search_outlined,
                      //       color: Colors.black45,
                      //     ),
                      //     hintText:
                      //         "Search products", //"${AppLocalizations.of(context).hnt_search_product}",
                      //   ),
                      // ),

                      // AAAST down

                      _homeScreenData!.banner != null &&
                              _homeScreenData!.banner != [] &&
                              _homeScreenData!.banner!.length > 0 &&
                              bannerEventImageURL != null &&
                              bannerEventImageURL.length > 0
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              //color: new Color(0xffF3E2B3),
                              //height: 340, //'#F3E2B3',
                              child: Column(
                                children: [
                                  Container(
                                    child: _isDataLoaded &&
                                            _homeScreenData != null
                                        ? Container(
                                            alignment: Alignment.center,
                                            // padding: EdgeInsets.only(left: 8, right: 8),
                                            child:
                                                _homeScreenData!.banner !=
                                                            null &&
                                                        _homeScreenData!
                                                                .banner !=
                                                            [] &&
                                                        _homeScreenData!.banner!
                                                                .length >
                                                            0 &&
                                                        bannerEventImageURL !=
                                                            null &&
                                                        bannerEventImageURL
                                                                .length >
                                                            0
                                                    ? BannerImage(
                                                        onTap: (p0) {
                                                          global.homeSelectedCatID =
                                                              _homeScreenData!
                                                                  .events![p0]
                                                                  .id!;
                                                          global.isEventProduct =
                                                              true;
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          SubCategoriesScreen(
                                                                            a: widget.analytics,
                                                                            o: widget.observer,
                                                                            showCategories:
                                                                                true,
                                                                            screenHeading:
                                                                                _homeScreenData!.events![p0].eventName,
                                                                            categoryId:
                                                                                _homeScreenData!.events![p0].id,
                                                                            isEventProducts:
                                                                                true,
                                                                            isSubcategory:
                                                                                false, //subscriptionProduct: 1,
                                                                          )));
                                                        },
                                                        // borderRadius:
                                                        //     BorderRadius.circular(10),
                                                        autoPlay: true,
                                                        timerDuration: Duration(
                                                            seconds: 4),
                                                        aspectRatio: 2.3,
                                                        padding:
                                                            EdgeInsets.only(),
                                                        itemLength:
                                                            bannerEventImageURL
                                                                .length,
                                                        imageUrlList:
                                                            bannerEventImageURL,
                                                        selectedIndicatorColor:
                                                            ColorConstants
                                                                .appColor,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context,
                                                            child,
                                                            loadingProgress) {
                                                          return Container(
                                                            height: 10,
                                                            width: 10,
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        },
                                                      )
                                                    : SizedBox(),
                                          )
                                        : _bannerShimmer(),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),

                      // Container(
                      //   height: 50,
                      //   color: ColorConstants.colorHomePageSectiondim,
                      //   padding: EdgeInsets.only(top:10,bottom: 10,left: 10),
                      // child:   ListView.builder(
                      //     controller: _scrollAutoController,
                      //     scrollDirection: Axis.horizontal,
                      //     itemCount: homeScrollingTitles.length,
                      //     itemBuilder: (context, index) {
                      //       return Container(
                      //         margin: EdgeInsets.only(right: 10),
                      //         child: Text(
                      //           homeScrollingTitles[index],
                      //           style: TextStyle(
                      //                   fontFamily: global.fontRailwayRegular,
                      //                   fontWeight: FontWeight.w400,
                      //                   fontSize: 19,
                      //                   color: ColorConstants.colorAllHomeTitle),

                      //         ),
                      //       );
                      //     },
                      //   ),
                      // ),
                      Container(
                          height: 50,
                          color: ColorConstants.colorHomePageSectiondim,
                          padding:
                              EdgeInsets.only(top: 10, bottom: 10, left: 10),
                          child: Marquee(
                            text:
                                homeScrollingTitles.join("                   "),
                            blankSpace: 20.0,
                            startPadding: 20.0,
                            pauseAfterRound: Duration(seconds: 1),
                            accelerationDuration: Duration(seconds: 1),
                            scrollAxis: Axis.horizontal,
                            style: TextStyle(
                                fontFamily: global.fontRailwayRegular,
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: ColorConstants.colorAllHomeTitle),
                          )),
                      /////this is the section for special events

                      Container(
                        color: ColorConstants.colorHomePageSection,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Column(
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.only(top: 1, left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Special Events",
                                    style: TextStyle(
                                        fontFamily: global.fontRailwayRegular,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 19,
                                        color:
                                            ColorConstants.colorAllHomeTitle),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              // margin: EdgeInsets.only(top: 5, bottom: 20),
                              // padding: EdgeInsets.only(top: 5, bottom: 20),
                              height: 130,
                              margin: EdgeInsets.only(top: 10),
                              child: Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(bottom: 5),
                                    height: 130,
                                    child:
                                        _isDataLoaded && _homeScreenData != null
                                            ? _isDataLoaded &&
                                                    _homeScreenData != null &&
                                                    bannerEventIconURL !=
                                                        null &&
                                                    bannerEventIconURL != [] &&
                                                    bannerEventIconURL.length >
                                                        0
                                                ? ListView.builder(
                                                    itemCount:
                                                        bannerEventIconURL
                                                            .length,
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Container(
                                                          width: 75,
                                                          margin:
                                                              EdgeInsets.all(5),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                width: 75,
                                                                height: 75,
                                                                child: Card(
                                                                  elevation: 0,
                                                                  color: Colors
                                                                      .white,
                                                                  shadowColor:
                                                                      Colors
                                                                          .transparent,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            100),
                                                                  ),
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              1,
                                                                          right:
                                                                              1),
                                                                  child: Column(
                                                                    children: [
                                                                      Container(
                                                                        width:
                                                                            75,
                                                                        height:
                                                                            75,
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(100),
                                                                          child:
                                                                              CachedNetworkImage(
                                                                            height:
                                                                                70,
                                                                            fit:
                                                                                BoxFit.contain,
                                                                            width:
                                                                                70,
                                                                            imageUrl:
                                                                                global.imageBaseUrl + bannerEventIconURL[index].eventIconURL!,
                                                                            imageBuilder: (context, imageProvider) =>
                                                                                Container(
                                                                              height: double.infinity,
                                                                              width: double.infinity,
                                                                              decoration: BoxDecoration(
                                                                                // borderRadius: BorderRadius.circular(10),
                                                                                image: DecorationImage(
                                                                                  image: imageProvider,
                                                                                  fit: BoxFit.contain,
                                                                                  alignment: Alignment.center,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            placeholder: (context, url) =>
                                                                                Center(child: CircularProgressIndicator()),
                                                                            errorWidget: (context, url, error) =>
                                                                                Container(
                                                                              width: 70.0,
                                                                              height: 70.0,
                                                                              decoration: BoxDecoration(
                                                                                // borderRadius: BorderRadius.circular(15),
                                                                                image: DecorationImage(
                                                                                  image: AssetImage(global.catNoImage),
                                                                                  fit: BoxFit.contain,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 8),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              1,
                                                                          right:
                                                                              1),
                                                                      child:
                                                                          Text(
                                                                        "${bannerEventIconURL[index].eventName}",
                                                                        maxLines:
                                                                            2,
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: TextStyle(
                                                                            fontFamily: global
                                                                                .fontRailwayRegular,
                                                                            fontWeight: FontWeight
                                                                                .w200,
                                                                            fontSize:
                                                                                12,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ));
                                                    },
                                                  )
                                                : SizedBox()
                                            : SizedBox(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      ///Special events section ends here
                      Container(
                        margin: EdgeInsets.only(
                            top: 25, left: 10, right: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Explore Categories",
                              style: TextStyle(
                                  fontFamily: global.fontRalewayMedium,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 40,
                                  color: ColorConstants.colorAllHomeTitle),
                            ),
                            Container(
                              height: 28,
                              padding: EdgeInsets.only(left: 8, right: 8),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                      color: ColorConstants.newAppColor,
                                      width: 0.25)),
                              child: TextButton(
                                child: Text(
                                  "View All",
                                  style: TextStyle(
                                      fontFamily: global.fontRailwayRegular,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 12,
                                      color: ColorConstants.newColorBlack),
                                ),
                                onPressed: () {
                                  // Akshada change
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AllCategoriesScreen(
                                              a: widget.analytics,
                                              o: widget.observer,
                                            )),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        // margin: EdgeInsets.only(top: 5, bottom: 20),
                        // padding: EdgeInsets.only(top: 5, bottom: 20),
                        height: 130,
                        child: Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.only(bottom: 5),
                              height: 130,
                              child: _isDataLoaded && _homeScreenData != null
                                  ? _homeScreenData!.topCat != null &&
                                          _homeScreenData!.topCat != [] &&
                                          _homeScreenData!.topCat!.length > 0
                                      ? ListView.builder(
                                          itemCount:
                                              _homeScreenData!.topCat!.length,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return Container(
                                                width: 75,
                                                margin: EdgeInsets.all(5),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    // print(
                                                    //     "hellooo----------------------");
                                                    setState(() {
                                                      _homeScreenData!.topCat!
                                                          .map((e) =>
                                                              e.isSelected =
                                                                  false)
                                                          .toList();
                                                      _selectedIndex = index;
                                                      if (_selectedIndex ==
                                                          index) {
                                                        _homeScreenData!
                                                            .topCat![index]
                                                            .isSelected = true;
                                                      }
                                                    });
                                                    print(
                                                        "caategory id-------${_homeScreenData!.topCat![index].catId}");
                                                    global.isEventProduct =
                                                        false;
                                                    global.isSubCatSelected =
                                                        false;
                                                    global.homeSelectedCatID =
                                                        _homeScreenData!
                                                            .topCat![index]
                                                            .catId!;
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                (SubCategoriesScreen(
                                                                  a: widget
                                                                      .analytics,
                                                                  o: widget
                                                                      .observer,
                                                                  showCategories:
                                                                      true,
                                                                  screenHeading:
                                                                      _homeScreenData!
                                                                          .topCat![
                                                                              index]
                                                                          .title,
                                                                  categoryId: _homeScreenData!
                                                                      .topCat![
                                                                          index]
                                                                      .catId,
                                                                  isEventProducts:
                                                                      false,
                                                                  isSubcategory:
                                                                      false, //subscriptionProduct: 1,
                                                                ))));
                                                  }, // remove single child scroll view that wrap with column
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: 75,
                                                        height: 75,
                                                        child: Card(
                                                          elevation: 0,
                                                          color: Colors.white,
                                                          shadowColor: Colors
                                                              .transparent,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                          ),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 1,
                                                                  right: 1),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                width: 75,
                                                                height: 75,
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    height: 70,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    width: 70,
                                                                    imageUrl: global
                                                                            .catImageBaseUrl +
                                                                        _homeScreenData!
                                                                            .topCat![index]
                                                                            .image!,
                                                                    imageBuilder:
                                                                        (context,
                                                                                imageProvider) =>
                                                                            Container(
                                                                      height: double
                                                                          .infinity,
                                                                      width: double
                                                                          .infinity,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        // borderRadius: BorderRadius.circular(10),
                                                                        image:
                                                                            DecorationImage(
                                                                          image:
                                                                              imageProvider,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          alignment:
                                                                              Alignment.center,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    placeholder: (context,
                                                                            url) =>
                                                                        Center(
                                                                            child:
                                                                                CircularProgressIndicator()),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Container(
                                                                      width:
                                                                          70.0,
                                                                      height:
                                                                          70.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        // borderRadius: BorderRadius.circular(15),
                                                                        image:
                                                                            DecorationImage(
                                                                          image:
                                                                              AssetImage(global.catNoImage),
                                                                          fit: BoxFit
                                                                              .contain,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 8),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 1,
                                                                      right: 1),
                                                              decoration:
                                                                  BoxDecoration(
                                                                      color: Colors
                                                                          .white38),
                                                              child: Text(
                                                                "${_homeScreenData!.topCat![index].title}",
                                                                maxLines: 2,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        global
                                                                            .fontRailwayRegular,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w200,
                                                                    fontSize:
                                                                        12,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ));
                                          },
                                        )
                                      : SizedBox()
                                  : SizedBox(),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(left: 8, right: 8, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                _homeScreenData!.recentselling!.length > 0
                                    ? "${_homeScreenData!.recentselling![0].catName}"
                                    : "",
                                maxLines: 1,
                                style: TextStyle(
                                    fontFamily: global.fontRalewayMedium,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 19,
                                    color: Colors.black)),
                            Container(
                              height: 28,
                              padding: EdgeInsets.only(left: 8, right: 8),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                      color: ColorConstants.newAppColor,
                                      width: 0.25)),
                              child: TextButton(
                                child: Text(
                                  "View All",
                                  style: TextStyle(
                                      fontFamily: global.fontRailwayRegular,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 12,
                                      color: ColorConstants.newColorBlack),
                                ),
                                onPressed: () {
                                  global.isSubCatSelected = false;
                                  setState(() {});
                                  global.homeSelectedCatID =
                                      _homeScreenData!.recentselling![0].catId!;
                                  global.parentCatID =
                                      _homeScreenData!.recentselling![0].catId!;
                                  global.isEventProduct = false;
                                  global.isSubCatSelected = false;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SubCategoriesScreen(
                                                a: widget.analytics,
                                                o: widget.observer,
                                                showCategories: true,
                                                screenHeading: _homeScreenData!
                                                    .recentselling![0].catName,
                                                categoryId: _homeScreenData!
                                                    .recentselling![0].catId,
                                                isEventProducts: false,
                                                isSubcategory:
                                                    false, //subscriptionProduct: 1,
                                              )));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: productSection1List != null
                            ? _productContainerheight
                            : 0,
                        child: _isDataLoaded && productSection1List != null
                            ? productSection1List != null &&
                                    productSection1List.length > 0
                                ? BundleOffersMenu(
                                    analytics: widget.analytics,
                                    observer: widget.observer,
                                    categoryProductList: productSection1List,
                                    isHomeSelected: 'home',
                                  )
                                : SizedBox()
                            : _shimmer2(),
                      ),

                      _homeScreenData!.recentselling!.length > 1
                          ? Stack(
                              children: [
                                Wrap(
                                  children: [
                                    Container(
                                      color: ColorConstants
                                          .colorHomePageSectiondim,
                                      //height: productSection2List != null ? 675 : 0,
                                      padding: EdgeInsets.only(top: 15),
                                      //margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                                bottom: 5,
                                                top: 1),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    _homeScreenData!
                                                                .recentselling!
                                                                .length >
                                                            1
                                                        ? "${_homeScreenData!.recentselling![1].catName}"
                                                        : "",
                                                    style: TextStyle(
                                                        fontFamily: global
                                                            .fontRalewayMedium,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 19,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                Container(
                                                  height: 28,
                                                  padding: EdgeInsets.only(
                                                      left: 8, right: 8),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      border: Border.all(
                                                          color: ColorConstants
                                                              .newAppColor,
                                                          width: 0.25)),
                                                  child: TextButton(
                                                    child: Text(
                                                      "View All",
                                                      style: TextStyle(
                                                          fontFamily: global
                                                              .fontRailwayRegular,
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          fontSize: 12,
                                                          color: ColorConstants
                                                              .newColorBlack),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        // _homeScreenData.topCat
                                                        //     .map((e) =>
                                                        //         e.isSelected = false)
                                                        //     .toList();
                                                        // _selectedIndex = index;
                                                        // if (_selectedIndex == index) {
                                                        //   _homeScreenData.topCat[index]
                                                        //       .isSelected = true;
                                                        // }
                                                      });
                                                      global.homeSelectedCatID =
                                                          _homeScreenData!
                                                              .recentselling![1]
                                                              .catId!;
                                                      global.parentCatID =
                                                          _homeScreenData!
                                                              .recentselling![1]
                                                              .catId!;
                                                      global.isEventProduct =
                                                          false;
                                                      global.isSubCatSelected =
                                                          false;
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  SubCategoriesScreen(
                                                                    a: widget
                                                                        .analytics,
                                                                    o: widget
                                                                        .observer,
                                                                    showCategories:
                                                                        true,
                                                                    screenHeading: _homeScreenData!
                                                                        .recentselling![
                                                                            1]
                                                                        .catName,
                                                                    categoryId: _homeScreenData!
                                                                        .recentselling![
                                                                            1]
                                                                        .catId,
                                                                    isSubcategory:
                                                                        false,
                                                                    isEventProducts:
                                                                        false,
                                                                    // subscriptionProduct: global
                                                                    //     .isSubscription, //subscriptionProduct: 1,
                                                                  )));
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(bottom: 2),
                                            height:
                                                _productContainerheight - 10,
                                            child: _isDataLoaded &&
                                                    productSection2List != null
                                                ? productSection2List != null &&
                                                        productSection2List
                                                                .length >
                                                            0
                                                    ? BundleOffersMenu(
                                                        analytics:
                                                            widget.analytics,
                                                        observer:
                                                            widget.observer,
                                                        categoryProductList:
                                                            productSection2List,
                                                        isHomeSelected: 'home',
                                                      )
                                                    : SizedBox()
                                                : _shimmer2(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : SizedBox(),

                      // Container(
                      //     //margin: EdgeInsets.only(bottom: 80.0),
                      //     child: Column(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Container(
                      //       child: Text(
                      //         "Gifts",
                      //         style: TextStyle(
                      //             fontFamily: global.fontAdelia,
                      //             fontWeight: FontWeight.w200,
                      //             fontSize: 62,
                      //             color: ColorConstants.appColor),
                      //       ),
                      //     ),
                      //     SizedBox(height: 5),
                      //     Text(
                      //       "Best for your loved ones!",
                      //       style: TextStyle(
                      //           fontFamily: global.fontMetropolisRegular,
                      //           fontWeight: FontWeight.w500,
                      //           fontSize: 17,
                      //           color: ColorConstants.pureBlack),
                      //     ),
                      //     Container(
                      //       margin: EdgeInsets.only(top: 10),
                      //       height: 37,
                      //       //width: 133,
                      //       decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(30)),
                      //       child: BottomButton(
                      //           child: Text(
                      //             "GIFT NOW",
                      //             style: TextStyle(
                      //                 fontFamily: fontMontserratMedium,
                      //                 fontWeight: FontWeight.bold,
                      //                 fontSize: 16,
                      //                 color: ColorConstants.white,
                      //                 letterSpacing: 1),
                      //           ),
                      //           loadingState: false,
                      //           disabledState: true,
                      //           onPressed: () {
                      //             showRelationField = false;
                      //             showAgeField = false;
                      //             showOcassionField = false;
                      //             if (showRecipientField) {
                      //               showRecipientField = false;
                      //               for (int i = 0; i < maleRelation.length; i++) {
                      //                 maleRelation[i].selectedRelation = false;
                      //               }
                      //               for (int i = 0;
                      //                   i < femaleRelation.length;
                      //                   i++) {
                      //                 femaleRelation[i].selectedRelation = false;
                      //               }
                      //               for (int i = 0;
                      //                   i <
                      //                       selectionData
                      //                           .searchRelationship!.length;
                      //                   i++) {
                      //                 selectionData.searchRelationship![i]
                      //                     .selectedRelation = false;
                      //               }
                      //               for (int i = 0;
                      //                   i < selectionData.searchAge!.length;
                      //                   i++) {
                      //                 selectionData.searchAge![i].selectedAge =
                      //                     false;
                      //               }
                      //               for (int i = 0;
                      //                   i < selectionData.searchGender!.length;
                      //                   i++) {
                      //                 selectionData
                      //                     .searchGender![i].selectedGender = false;
                      //               }
                      //             } else {
                      //               showRecipientField = true;
                      //             }
                      //             setState(() {});
                      //           }),
                      //     ),
                      //   ],
                      // )),

                      // showRecipientField
                      //     ? Wrap(
                      //         children: [
                      //           Container(
                      //             padding: EdgeInsets.all(10),
                      //             margin:
                      //                 EdgeInsets.only(top: 10, right: 5, left: 5),
                      //             decoration: BoxDecoration(
                      //                 borderRadius: BorderRadius.circular(8),
                      //                 border: Border.all(
                      //                     color: ColorConstants.allBorderColor)),
                      //             child: Column(
                      //               children: [
                      //                 Container(
                      //                   width: MediaQuery.of(context).size.width,
                      //                   child: Text(
                      //                     // hideRecipientField
                      //                     //     ? "Recipient; ${recipient}"
                      //                     //     :
                      //                     "Choose Recipient",
                      //                     style: TextStyle(
                      //                         fontFamily:
                      //                             global.fontMontserratLight,
                      //                         fontWeight: FontWeight.w600,
                      //                         fontSize: 15,
                      //                         color: Colors.black),
                      //                   ),
                      //                 ),
                      //                 SizedBox(
                      //                   height: 8,
                      //                 ),
                      //                 GridView.builder(
                      //                     shrinkWrap: true,
                      //                     gridDelegate:
                      //                         SliverGridDelegateWithFixedCrossAxisCount(
                      //                             crossAxisCount: 2,
                      //                             childAspectRatio: 1.7),
                      //                     scrollDirection: Axis.vertical,
                      //                     itemCount:
                      //                         selectionData.searchGender!.length,
                      //                     physics: NeverScrollableScrollPhysics(),
                      //                     itemBuilder: (context, index) {
                      //                       return Container(
                      //                         width: MediaQuery.of(context)
                      //                                 .size
                      //                                 .width /
                      //                             2.1,
                      //                         child: Column(
                      //                           children: [
                      //                             InkWell(
                      //                               onTap: () {
                      //                                 // openedContainerHeight = 2;
                      //                                 showRelationField = true;
                      //                                 hideRecipientField = true;
                      //                                 recipient = selectionData
                      //                                     .searchGender![index]
                      //                                     .name!;
                      //                                 selectedRecipient_ID =
                      //                                     selectionData
                      //                                         .searchGender![index]
                      //                                         .id!;
                      //                                 for (int i = 0;
                      //                                     i <
                      //                                         selectionData
                      //                                             .searchGender!
                      //                                             .length;
                      //                                     i++) {
                      //                                   if (i == index) {
                      //                                     selectionData
                      //                                             .searchGender![i]
                      //                                             .selectedGender =
                      //                                         true;
                      //                                   } else {
                      //                                     selectionData
                      //                                             .searchGender![i]
                      //                                             .selectedGender =
                      //                                         false;
                      //                                     for (int i = 0;
                      //                                         i <
                      //                                             selectionData
                      //                                                 .searchRelationship!
                      //                                                 .length;
                      //                                         i++) {
                      //                                       if (i == index) {
                      //                                         selectionData
                      //                                             .searchRelationship![
                      //                                                 i]
                      //                                             .selectedRelation = false;
                      //                                       }
                      //                                     }
                      //                                     for (int i = 0;
                      //                                         i <
                      //                                             maleRelation
                      //                                                 .length;
                      //                                         i++) {
                      //                                       maleRelation[i]
                      //                                               .selectedRelation =
                      //                                           false;
                      //                                     }
                      //                                     for (int i = 0;
                      //                                         i <
                      //                                             femaleRelation
                      //                                                 .length;
                      //                                         i++) {
                      //                                       femaleRelation[i]
                      //                                               .selectedRelation =
                      //                                           false;
                      //                                     }
                      //                                     for (int i = 0;
                      //                                         i <
                      //                                             selectionData
                      //                                                 .searchRelationship!
                      //                                                 .length;
                      //                                         i++) {
                      //                                       selectionData
                      //                                           .searchRelationship![
                      //                                               i]
                      //                                           .selectedRelation = false;
                      //                                     }
                      //                                     for (int i = 0;
                      //                                         i <
                      //                                             selectionData
                      //                                                 .searchAge!
                      //                                                 .length;
                      //                                         i++) {
                      //                                       selectionData
                      //                                               .searchAge![i]
                      //                                               .selectedAge =
                      //                                           false;
                      //                                     }
                      //                                   }
                      //                                 }

                      //                                 setState(() {});
                      //                               },
                      //                               child: Container(
                      //                                 height: 70,
                      //                                 margin: EdgeInsets.only(
                      //                                     left: 5, right: 5),
                      //                                 padding: EdgeInsets.only(
                      //                                     top: 5,
                      //                                     bottom: 5,
                      //                                     right: 40,
                      //                                     left: 40),
                      //                                 decoration: BoxDecoration(
                      //                                     borderRadius:
                      //                                         BorderRadius.circular(
                      //                                             8),
                      //                                     border: Border.all(
                      //                                         color: selectionData
                      //                                                 .searchGender![
                      //                                                     index]
                      //                                                 .selectedGender!
                      //                                             ? ColorConstants
                      //                                                 .appColor
                      //                                             : ColorConstants
                      //                                                 .allBorderColor)),
                      //                                 child: Container(
                      //                                   padding: EdgeInsets.only(
                      //                                       left: 5,
                      //                                       right: 5,
                      //                                       top: 5),
                      //                                   width: 60,
                      //                                   height: 50,
                      //                                   decoration: BoxDecoration(
                      //                                       borderRadius:
                      //                                           BorderRadius
                      //                                               .circular(100),
                      //                                       color: selectionData
                      //                                               .searchGender![
                      //                                                   index]
                      //                                               .selectedGender!
                      //                                           ? ColorConstants
                      //                                               .orderDtailBorder
                      //                                           : ColorConstants
                      //                                               .white),
                      //                                   child: CachedNetworkImage(
                      //                                     // height: 200,
                      //                                     imageUrl: global
                      //                                             .imageBaseUrl +
                      //                                         selectionData
                      //                                             .searchGender![
                      //                                                 index]
                      //                                             .icon!,
                      //                                     imageBuilder: (context,
                      //                                             imageProvider) =>
                      //                                         Container(
                      //                                       height: 100,
                      //                                       width: 100,
                      //                                       decoration:
                      //                                           BoxDecoration(
                      //                                         // borderRadius: BorderRadius.circular(10),
                      //                                         image:
                      //                                             DecorationImage(
                      //                                           image:
                      //                                               imageProvider,
                      //                                           fit: BoxFit.contain,
                      //                                           alignment: Alignment
                      //                                               .center,
                      //                                         ),
                      //                                       ),
                      //                                     ),
                      //                                     placeholder: (context,
                      //                                             url) =>
                      //                                         Center(
                      //                                             child:
                      //                                                 CircularProgressIndicator()),
                      //                                     errorWidget: (context,
                      //                                             url, error) =>
                      //                                         Container(
                      //                                       width: 100.0,
                      //                                       height: 100.0,
                      //                                       decoration:
                      //                                           BoxDecoration(
                      //                                         // borderRadius: BorderRadius.circular(15),
                      //                                         image:
                      //                                             DecorationImage(
                      //                                           image: AssetImage(
                      //                                               "assets/images/male_icon.png"),
                      //                                           fit: BoxFit.contain,
                      //                                         ),
                      //                                       ),
                      //                                     ),
                      //                                   ),
                      //                                 ),
                      //                                 // Image.asset(
                      //                                 //   //"assets/images/loation_pin_green.png",
                      //                                 //   "assets/images/male_icon.png",
                      //                                 //   height: Platform.isIOS
                      //                                 //       ? 60
                      //                                 //       : 60,
                      //                                 //   width: Platform.isIOS
                      //                                 //       ? 60
                      //                                 //       : 60,
                      //                                 // ),
                      //                               ),
                      //                             ),
                      //                             SizedBox(
                      //                               height: 8,
                      //                             ),
                      //                             Container(
                      //                               child: Text(
                      //                                 "${selectionData.searchGender![index].name}",
                      //                                 textAlign: TextAlign.center,
                      //                                 style: TextStyle(
                      //                                     fontFamily: global
                      //                                         .fontMontserratLight,
                      //                                     fontWeight:
                      //                                         FontWeight.w200,
                      //                                     fontSize: 13,
                      //                                     color: Colors.black),
                      //                               ),
                      //                             ),
                      //                           ],
                      //                         ),
                      //                       );
                      //                     }),
                      //                 // : Container(
                      //                 //     width:
                      //                 //         MediaQuery.of(context).size.width,
                      //                 //     child: Text(
                      //                 //       "Gender : ${recipient}",
                      //                 //       style: TextStyle(
                      //                 //           fontFamily:
                      //                 //               global.fontMontserratLight,
                      //                 //           fontWeight: FontWeight.w600,
                      //                 //           fontSize: 15,
                      //                 //           color: Colors.black),
                      //                 //     ),
                      //                 //   ),

                      //                 showRelationField
                      //                     ? Container(
                      //                         child: Column(
                      //                           children: [
                      //                             Container(
                      //                               width: MediaQuery.of(context)
                      //                                   .size
                      //                                   .width,
                      //                               child: Text(
                      //                                 "Choose Relation",
                      //                                 style: TextStyle(
                      //                                     fontFamily: global
                      //                                         .fontMontserratLight,
                      //                                     fontWeight:
                      //                                         FontWeight.w600,
                      //                                     fontSize: 15,
                      //                                     color: Colors.black),
                      //                               ),
                      //                             ),
                      //                             SizedBox(
                      //                               height: 8,
                      //                             ),
                      //                             recipient.toLowerCase() ==
                      //                                         "male" ||
                      //                                     recipient.toLowerCase() ==
                      //                                         "female"
                      //                                 ? GridView.builder(
                      //                                     shrinkWrap: true,
                      //                                     gridDelegate:
                      //                                         SliverGridDelegateWithFixedCrossAxisCount(
                      //                                             crossAxisCount: 3,
                      //                                             childAspectRatio:
                      //                                                 1),
                      //                                     scrollDirection:
                      //                                         Axis.vertical,
                      //                                     itemCount: recipient
                      //                                                 .toLowerCase() ==
                      //                                             "male"
                      //                                         ? maleRelation.length
                      //                                         : femaleRelation
                      //                                             .length,
                      //                                     physics: ScrollPhysics(),
                      //                                     itemBuilder:
                      //                                         (context, index) {
                      //                                       return Column(
                      //                                         children: [
                      //                                           InkWell(
                      //                                             onTap: () {
                      //                                               showAgeField =
                      //                                                   true;
                      //                                               showOcassionField =
                      //                                                   true;
                      //                                               for (int i = 0;
                      //                                                   i <
                      //                                                       selectionData
                      //                                                           .searchRelationship!
                      //                                                           .length;
                      //                                                   i++) {
                      //                                                 if (i ==
                      //                                                     index) {
                      //                                                   selectionData
                      //                                                       .searchRelationship![
                      //                                                           i]
                      //                                                       .selectedRelation = false;
                      //                                                 }
                      //                                               }
                      //                                               if (recipient
                      //                                                       .toLowerCase() ==
                      //                                                   "male") {
                      //                                                 relation =
                      //                                                     maleRelation[
                      //                                                             index]
                      //                                                         .name!;
                      //                                                 selectedRelation_ID =
                      //                                                     maleRelation[
                      //                                                             index]
                      //                                                         .id!;
                      //                                                 for (int i =
                      //                                                         0;
                      //                                                     i <
                      //                                                         femaleRelation
                      //                                                             .length;
                      //                                                     i++) {
                      //                                                   femaleRelation[i]
                      //                                                           .selectedRelation =
                      //                                                       false;
                      //                                                 }
                      //                                                 for (int i =
                      //                                                         0;
                      //                                                     i <
                      //                                                         maleRelation
                      //                                                             .length;
                      //                                                     i++) {
                      //                                                   if (i ==
                      //                                                       index) {
                      //                                                     maleRelation[i]
                      //                                                             .selectedRelation =
                      //                                                         true;
                      //                                                   } else {
                      //                                                     maleRelation[i]
                      //                                                             .selectedRelation =
                      //                                                         false;
                      //                                                   }
                      //                                                 }
                      //                                               } else {
                      //                                                 relation =
                      //                                                     femaleRelation[
                      //                                                             index]
                      //                                                         .name!;
                      //                                                 selectedRelation_ID =
                      //                                                     femaleRelation[
                      //                                                             index]
                      //                                                         .id!;
                      //                                                 for (int i =
                      //                                                         0;
                      //                                                     i <
                      //                                                         maleRelation
                      //                                                             .length;
                      //                                                     i++) {
                      //                                                   maleRelation[i]
                      //                                                           .selectedRelation =
                      //                                                       false;
                      //                                                 }
                      //                                                 for (int i =
                      //                                                         0;
                      //                                                     i <
                      //                                                         femaleRelation
                      //                                                             .length;
                      //                                                     i++) {
                      //                                                   if (i ==
                      //                                                       index) {
                      //                                                     femaleRelation[i]
                      //                                                             .selectedRelation =
                      //                                                         true;
                      //                                                   } else {
                      //                                                     femaleRelation[i]
                      //                                                             .selectedRelation =
                      //                                                         false;
                      //                                                   }
                      //                                                 }
                      //                                               }
                      //                                               for (int i = 0;
                      //                                                   i <
                      //                                                       selectionData
                      //                                                           .searchAge!
                      //                                                           .length;
                      //                                                   i++) {
                      //                                                 selectionData
                      //                                                     .searchAge![
                      //                                                         i]
                      //                                                     .selectedAge = false;
                      //                                               }

                      //                                               setState(() {});
                      //                                             },
                      //                                             child: Container(
                      //                                               padding: EdgeInsets
                      //                                                   .only(
                      //                                                       top: 5,
                      //                                                       bottom:
                      //                                                           5,
                      //                                                       right:
                      //                                                           20,
                      //                                                       left:
                      //                                                           20),
                      //                                               decoration: BoxDecoration(
                      //                                                   borderRadius: BorderRadius.circular(8),
                      //                                                   border: recipient.toLowerCase() == "male"
                      //                                                       ? Border.all(
                      //                                                           color: maleRelation[index].selectedRelation!
                      //                                                               ? ColorConstants.appColor
                      //                                                               : ColorConstants.allBorderColor,
                      //                                                           // color: recipient.toLowerCase() == "male" && maleRelation[index].selectedRelation
                      //                                                           //     ? ColorConstants.appColor
                      //                                                           //     : recipient.toLowerCase() == "female" && femaleRelation[index].selectedRelation
                      //                                                           //         ? ColorConstants.appColor
                      //                                                           //         : ColorConstants.allBorderColor
                      //                                                         )
                      //                                                       : Border.all(
                      //                                                           color: femaleRelation[index].selectedRelation!
                      //                                                               ? ColorConstants.appColor
                      //                                                               : ColorConstants.allBorderColor,
                      //                                                           // color: recipient.toLowerCase() == "male" && maleRelation[index].selectedRelation
                      //                                                           //     ? ColorConstants.appColor
                      //                                                           //     : recipient.toLowerCase() == "female" && femaleRelation[index].selectedRelation
                      //                                                           //         ? ColorConstants.appColor
                      //                                                           //         : ColorConstants.allBorderColor
                      //                                                         )),
                      //                                               child:
                      //                                                   Container(
                      //                                                 padding: EdgeInsets
                      //                                                     .only(
                      //                                                         left:
                      //                                                             5,
                      //                                                         right:
                      //                                                             5,
                      //                                                         top:
                      //                                                             5),
                      //                                                 width: 50,
                      //                                                 height: 50,
                      //                                                 decoration: recipient
                      //                                                             .toLowerCase() ==
                      //                                                         "male"
                      //                                                     ? BoxDecoration(
                      //                                                         borderRadius: BorderRadius.circular(
                      //                                                             100),
                      //                                                         color: maleRelation[index].selectedRelation!
                      //                                                             ? ColorConstants
                      //                                                                 .orderDtailBorder
                      //                                                             : ColorConstants
                      //                                                                 .white)
                      //                                                     : BoxDecoration(
                      //                                                         borderRadius: BorderRadius.circular(
                      //                                                             100),
                      //                                                         color: femaleRelation[index].selectedRelation!
                      //                                                             ? ColorConstants.orderDtailBorder
                      //                                                             : ColorConstants.white),
                      //                                                 child:
                      //                                                     CachedNetworkImage(
                      //                                                   // height: 200,

                      //                                                   imageUrl: recipient.toLowerCase() ==
                      //                                                           "male"
                      //                                                       ? global.imageBaseUrl +
                      //                                                           maleRelation[index]
                      //                                                               .icon!
                      //                                                       : global.imageBaseUrl +
                      //                                                           femaleRelation[index].icon!,
                      //                                                   imageBuilder:
                      //                                                       (context,
                      //                                                               imageProvider) =>
                      //                                                           Container(
                      //                                                     height:
                      //                                                         100,
                      //                                                     width: double
                      //                                                         .infinity,
                      //                                                     decoration:
                      //                                                         BoxDecoration(
                      //                                                       // borderRadius: BorderRadius.circular(10),
                      //                                                       image:
                      //                                                           DecorationImage(
                      //                                                         image:
                      //                                                             imageProvider,
                      //                                                         fit: BoxFit
                      //                                                             .contain,
                      //                                                         alignment:
                      //                                                             Alignment.center,
                      //                                                       ),
                      //                                                     ),
                      //                                                   ),
                      //                                                   placeholder: (context,
                      //                                                           url) =>
                      //                                                       Center(
                      //                                                           child:
                      //                                                               CircularProgressIndicator()),
                      //                                                   errorWidget: (context,
                      //                                                           url,
                      //                                                           error) =>
                      //                                                       Container(
                      //                                                     width:
                      //                                                         100.0,
                      //                                                     height:
                      //                                                         100.0,
                      //                                                     decoration:
                      //                                                         BoxDecoration(
                      //                                                       // borderRadius: BorderRadius.circular(15),
                      //                                                       image:
                      //                                                           DecorationImage(
                      //                                                         image:
                      //                                                             AssetImage("assets/images/male_icon.png"),
                      //                                                         fit: BoxFit
                      //                                                             .contain,
                      //                                                       ),
                      //                                                     ),
                      //                                                   ),
                      //                                                 ),
                      //                                               ),
                      //                                             ),
                      //                                           ),
                      //                                           SizedBox(
                      //                                             height: 8,
                      //                                           ),
                      //                                           Container(
                      //                                             child: Text(
                      //                                               recipient.toLowerCase() ==
                      //                                                       "male"
                      //                                                   ? "${maleRelation[index].name}"
                      //                                                   : "${femaleRelation[index].name}",
                      //                                               textAlign:
                      //                                                   TextAlign
                      //                                                       .center,
                      //                                               style: TextStyle(
                      //                                                   fontFamily:
                      //                                                       global
                      //                                                           .fontMontserratLight,
                      //                                                   fontWeight:
                      //                                                       FontWeight
                      //                                                           .w200,
                      //                                                   fontSize:
                      //                                                       13,
                      //                                                   color: Colors
                      //                                                       .black),
                      //                                             ),
                      //                                           ),
                      //                                         ],
                      //                                       );
                      //                                     })
                      //                                 : GridView.builder(
                      //                                     shrinkWrap: true,
                      //                                     gridDelegate:
                      //                                         SliverGridDelegateWithFixedCrossAxisCount(
                      //                                             crossAxisCount: 3,
                      //                                             childAspectRatio:
                      //                                                 1),
                      //                                     scrollDirection:
                      //                                         Axis.vertical,
                      //                                     itemCount: selectionData
                      //                                         .searchRelationship!
                      //                                         .length,
                      //                                     physics: ScrollPhysics(),
                      //                                     itemBuilder:
                      //                                         (context, index) {
                      //                                       return Column(
                      //                                         children: [
                      //                                           InkWell(
                      //                                             onTap: () {
                      //                                               showAgeField =
                      //                                                   true;
                      //                                               showOcassionField =
                      //                                                   true;
                      //                                               relation = selectionData
                      //                                                   .searchRelationship![
                      //                                                       index]
                      //                                                   .id
                      //                                                   .toString();
                      //                                               selectedRelation_ID =
                      //                                                   selectionData
                      //                                                       .searchRelationship![
                      //                                                           index]
                      //                                                       .id!;
                      //                                               for (int i = 0;
                      //                                                   i <
                      //                                                       femaleRelation
                      //                                                           .length;
                      //                                                   i++) {
                      //                                                 femaleRelation[
                      //                                                             i]
                      //                                                         .selectedRelation =
                      //                                                     false;
                      //                                               }
                      //                                               for (int i = 0;
                      //                                                   i <
                      //                                                       maleRelation
                      //                                                           .length;
                      //                                                   i++) {
                      //                                                 maleRelation[
                      //                                                             i]
                      //                                                         .selectedRelation =
                      //                                                     false;
                      //                                               }
                      //                                               for (int i = 0;
                      //                                                   i <
                      //                                                       selectionData
                      //                                                           .searchRelationship!
                      //                                                           .length;
                      //                                                   i++) {
                      //                                                 if (i ==
                      //                                                     index) {
                      //                                                   selectionData
                      //                                                       .searchRelationship![
                      //                                                           i]
                      //                                                       .selectedRelation = true;
                      //                                                 } else {
                      //                                                   selectionData
                      //                                                       .searchRelationship![
                      //                                                           i]
                      //                                                       .selectedRelation = false;
                      //                                                 }
                      //                                               }
                      //                                               for (int i = 0;
                      //                                                   i <
                      //                                                       selectionData
                      //                                                           .searchAge!
                      //                                                           .length;
                      //                                                   i++) {
                      //                                                 selectionData
                      //                                                     .searchAge![
                      //                                                         i]
                      //                                                     .selectedAge = false;
                      //                                               }

                      //                                               setState(() {});
                      //                                             },
                      //                                             child: Container(
                      //                                               padding: EdgeInsets
                      //                                                   .only(
                      //                                                       top: 10,
                      //                                                       bottom:
                      //                                                           10,
                      //                                                       right:
                      //                                                           20,
                      //                                                       left:
                      //                                                           20),
                      //                                               decoration: BoxDecoration(
                      //                                                   borderRadius: BorderRadius.circular(8),
                      //                                                   border: Border.all(
                      //                                                       color: //ColorConstants.appColor
                      //                                                           selectionData.searchRelationship![index].selectedRelation! ? ColorConstants.appColor : ColorConstants.allBorderColor)),
                      //                                               child:
                      //                                                   Container(
                      //                                                 padding: EdgeInsets
                      //                                                     .only(
                      //                                                         left:
                      //                                                             5,
                      //                                                         right:
                      //                                                             5,
                      //                                                         top:
                      //                                                             5),
                      //                                                 width: 50,
                      //                                                 height: 50,
                      //                                                 decoration: BoxDecoration(
                      //                                                     borderRadius:
                      //                                                         BorderRadius.circular(
                      //                                                             100),
                      //                                                     color: selectionData
                      //                                                             .searchRelationship![
                      //                                                                 index]
                      //                                                             .selectedRelation!
                      //                                                         ? ColorConstants
                      //                                                             .orderDtailBorder
                      //                                                         : ColorConstants
                      //                                                             .white),
                      //                                                 child:
                      //                                                     CachedNetworkImage(
                      //                                                   // height: 200,

                      //                                                   imageUrl: global
                      //                                                           .imageBaseUrl +
                      //                                                       selectionData
                      //                                                           .searchRelationship![index]
                      //                                                           .icon!,
                      //                                                   imageBuilder:
                      //                                                       (context,
                      //                                                               imageProvider) =>
                      //                                                           Container(
                      //                                                     height:
                      //                                                         100,
                      //                                                     width: double
                      //                                                         .infinity,
                      //                                                     decoration:
                      //                                                         BoxDecoration(
                      //                                                       // borderRadius: BorderRadius.circular(10),
                      //                                                       image:
                      //                                                           DecorationImage(
                      //                                                         image:
                      //                                                             imageProvider,
                      //                                                         fit: BoxFit
                      //                                                             .contain,
                      //                                                         alignment:
                      //                                                             Alignment.center,
                      //                                                       ),
                      //                                                     ),
                      //                                                   ),
                      //                                                   placeholder: (context,
                      //                                                           url) =>
                      //                                                       Center(
                      //                                                           child:
                      //                                                               CircularProgressIndicator()),
                      //                                                   errorWidget: (context,
                      //                                                           url,
                      //                                                           error) =>
                      //                                                       Container(
                      //                                                     width:
                      //                                                         100.0,
                      //                                                     height:
                      //                                                         100.0,
                      //                                                     decoration:
                      //                                                         BoxDecoration(
                      //                                                       // borderRadius: BorderRadius.circular(15),
                      //                                                       image:
                      //                                                           DecorationImage(
                      //                                                         image:
                      //                                                             AssetImage("assets/images/male_icon.png"),
                      //                                                         fit: BoxFit
                      //                                                             .contain,
                      //                                                       ),
                      //                                                     ),
                      //                                                   ),
                      //                                                 ),
                      //                                               ),
                      //                                             ),
                      //                                           ),
                      //                                           SizedBox(
                      //                                             height: 8,
                      //                                           ),
                      //                                           Container(
                      //                                             child: Text(
                      //                                               "${selectionData.searchRelationship![index].name}",
                      //                                               textAlign:
                      //                                                   TextAlign
                      //                                                       .center,
                      //                                               style: TextStyle(
                      //                                                   fontFamily:
                      //                                                       global
                      //                                                           .fontMontserratLight,
                      //                                                   fontWeight:
                      //                                                       FontWeight
                      //                                                           .w200,
                      //                                                   fontSize:
                      //                                                       13,
                      //                                                   color: Colors
                      //                                                       .black),
                      //                                             ),
                      //                                           ),
                      //                                         ],
                      //                                       );
                      //                                     },
                      //                                   ),
                      //                           ],
                      //                         ),
                      //                       )
                      //                     : Container(),

                      //                 showAgeField
                      //                     ? Container(
                      //                         child: Column(
                      //                           children: [
                      //                             Container(
                      //                               width: MediaQuery.of(context)
                      //                                   .size
                      //                                   .width,
                      //                               child: Text(
                      //                                 "Choose Age",
                      //                                 style: TextStyle(
                      //                                     fontFamily: global
                      //                                         .fontMontserratLight,
                      //                                     fontWeight:
                      //                                         FontWeight.w600,
                      //                                     fontSize: 15,
                      //                                     color: Colors.black),
                      //                               ),
                      //                             ),
                      //                             SizedBox(
                      //                               height: 8,
                      //                             ),
                      //                             Wrap(
                      //                               children: [
                      //                                 Row(
                      //                                   mainAxisAlignment:
                      //                                       MainAxisAlignment
                      //                                           .center,
                      //                                   children: [
                      //                                     Container(
                      //                                         child: NumberPicker(
                      //                                       // value: _currentValue,
                      //                                       textStyle: TextStyle(
                      //                                           fontSize: 12,
                      //                                           color:
                      //                                               ColorConstants
                      //                                                   .grey),
                      //                                       selectedTextStyle: TextStyle(
                      //                                           fontSize: 18,
                      //                                           color:
                      //                                               ColorConstants
                      //                                                   .appColor),
                      //                                       minValue: 18,
                      //                                       maxValue: 113,
                      //                                       step: 5,
                      //                                       value: _mincurrentValue,
                      //                                       decoration:
                      //                                           BoxDecoration(
                      //                                         border: Border(
                      //                                             top: BorderSide(
                      //                                                 color: ColorConstants
                      //                                                     .pureBlack,
                      //                                                 width: 1),
                      //                                             bottom: BorderSide(
                      //                                                 color: ColorConstants
                      //                                                     .pureBlack,
                      //                                                 width: 1)),
                      //                                       ),
                      //                                       onChanged: (value) {
                      //                                         _mincurrentValue =
                      //                                             value;
                      //                                         _maxcurrentValue =
                      //                                             _mincurrentValue +
                      //                                                 5;
                      //                                         selectedAge =
                      //                                             "${_mincurrentValue} - ${_maxcurrentValue}";
                      //                                         showOcassionField =
                      //                                             true;

                      //                                         setState(() {});
                      //                                       },
                      //                                     )),
                      //                                     Container(
                      //                                       child: Text(
                      //                                         "TO",
                      //                                         style: TextStyle(
                      //                                             fontFamily: global
                      //                                                 .fontMontserratLight,
                      //                                             fontWeight:
                      //                                                 FontWeight
                      //                                                     .w600,
                      //                                             fontSize: 15,
                      //                                             color:
                      //                                                 Colors.black),
                      //                                       ),
                      //                                     ),
                      //                                     Container(
                      //                                         child: NumberPicker(
                      //                                       // value: _currentValue,
                      //                                       textStyle: TextStyle(
                      //                                           fontSize: 12,
                      //                                           color:
                      //                                               ColorConstants
                      //                                                   .grey),
                      //                                       selectedTextStyle: TextStyle(
                      //                                           fontSize: 18,
                      //                                           color:
                      //                                               ColorConstants
                      //                                                   .appColor),
                      //                                       minValue: 23,
                      //                                       step: 5,
                      //                                       maxValue: 118,
                      //                                       value: _maxcurrentValue,
                      //                                       decoration:
                      //                                           BoxDecoration(
                      //                                         border: Border(
                      //                                             top: BorderSide(
                      //                                                 color: ColorConstants
                      //                                                     .pureBlack,
                      //                                                 width: 1),
                      //                                             bottom: BorderSide(
                      //                                                 color: ColorConstants
                      //                                                     .pureBlack,
                      //                                                 width: 1)),
                      //                                       ),
                      //                                       onChanged: (value) {
                      //                                         _maxcurrentValue =
                      //                                             value;
                      //                                         _mincurrentValue =
                      //                                             _maxcurrentValue -
                      //                                                 5;
                      //                                         selectedAge =
                      //                                             "${_mincurrentValue} - ${_maxcurrentValue}";
                      //                                         showOcassionField =
                      //                                             true;

                      //                                         setState(() {});
                      //                                       },
                      //                                     )),
                      //                                   ],
                      //                                 ),
                      //                               ],
                      //                             ),
                      //                           ],
                      //                         ),
                      //                       )
                      //                     : Container(),

                      //                 showOcassionField
                      //                     ? Container(
                      //                         child: Column(
                      //                           children: [
                      //                             Container(
                      //                               width: MediaQuery.of(context)
                      //                                   .size
                      //                                   .width,
                      //                               child: Text(
                      //                                 "Choose Occassion",
                      //                                 style: TextStyle(
                      //                                     fontFamily: global
                      //                                         .fontMontserratLight,
                      //                                     fontWeight:
                      //                                         FontWeight.w600,
                      //                                     fontSize: 15,
                      //                                     color: Colors.black),
                      //                               ),
                      //                             ),
                      //                             SizedBox(
                      //                               height: 8,
                      //                             ),
                      //                             GridView.builder(
                      //                                 shrinkWrap: true,
                      //                                 gridDelegate:
                      //                                     SliverGridDelegateWithFixedCrossAxisCount(
                      //                                         crossAxisCount: 3,
                      //                                         childAspectRatio: 1),
                      //                                 scrollDirection:
                      //                                     Axis.vertical,
                      //                                 itemCount: selectionData
                      //                                     .searchOccasion!.length,
                      //                                 physics: ScrollPhysics(),
                      //                                 itemBuilder:
                      //                                     (context, index) {
                      //                                   return Column(
                      //                                     children: [
                      //                                       InkWell(
                      //                                         onTap: () {
                      //                                           ocassion = selectionData
                      //                                               .searchOccasion![
                      //                                                   index]
                      //                                               .id
                      //                                               .toString();
                      //                                           selectedOccasion_ID =
                      //                                               selectionData
                      //                                                   .searchOccasion![
                      //                                                       index]
                      //                                                   .id!;
                      //                                           Navigator.push(
                      //                                               context,
                      //                                               MaterialPageRoute(
                      //                                                   builder:
                      //                                                       (context) =>
                      //                                                           FilteredSubCategoriesScreen(
                      //                                                             a: widget.analytics,
                      //                                                             o: widget.observer,
                      //                                                             minAge: _mincurrentValue,
                      //                                                             maxAge: _maxcurrentValue,
                      //                                                             genderID: selectedRecipient_ID,
                      //                                                             relationID: selectedRelation_ID,
                      //                                                             ocassionID: selectedOccasion_ID,
                      //                                                           )));

                      //                                           setState(() {});
                      //                                         },
                      //                                         child: Container(
                      //                                           padding:
                      //                                               EdgeInsets.only(
                      //                                                   top: 10,
                      //                                                   bottom: 10,
                      //                                                   right: 20,
                      //                                                   left: 20),
                      //                                           decoration: BoxDecoration(
                      //                                               borderRadius:
                      //                                                   BorderRadius
                      //                                                       .circular(
                      //                                                           8),
                      //                                               border: Border.all(
                      //                                                   color: ColorConstants
                      //                                                       .allBorderColor)),
                      //                                           child:
                      //                                               CachedNetworkImage(
                      //                                             // height: 200,
                      //                                             height: 50,
                      //                                             width: 50,
                      //                                             imageUrl: global
                      //                                                     .imageBaseUrl +
                      //                                                 selectionData
                      //                                                     .searchOccasion![
                      //                                                         index]
                      //                                                     .icon!,
                      //                                             imageBuilder:
                      //                                                 (context,
                      //                                                         imageProvider) =>
                      //                                                     Container(
                      //                                               height: 100,
                      //                                               width: 100,
                      //                                               decoration:
                      //                                                   BoxDecoration(
                      //                                                 // borderRadius: BorderRadius.circular(10),
                      //                                                 image:
                      //                                                     DecorationImage(
                      //                                                   image:
                      //                                                       imageProvider,
                      //                                                   fit: BoxFit
                      //                                                       .contain,
                      //                                                   alignment:
                      //                                                       Alignment
                      //                                                           .center,
                      //                                                 ),
                      //                                               ),
                      //                                             ),
                      //                                             placeholder: (context,
                      //                                                     url) =>
                      //                                                 Center(
                      //                                                     child:
                      //                                                         CircularProgressIndicator()),
                      //                                             errorWidget:
                      //                                                 (context, url,
                      //                                                         error) =>
                      //                                                     Container(
                      //                                               width: 100.0,
                      //                                               height: 100.0,
                      //                                               decoration:
                      //                                                   BoxDecoration(
                      //                                                 // borderRadius: BorderRadius.circular(15),
                      //                                                 image:
                      //                                                     DecorationImage(
                      //                                                   image: AssetImage(
                      //                                                       "assets/images/male_icon.png"),
                      //                                                   fit: BoxFit
                      //                                                       .contain,
                      //                                                 ),
                      //                                               ),
                      //                                             ),
                      //                                           ),
                      //                                         ),
                      //                                       ),
                      //                                       SizedBox(
                      //                                         height: 8,
                      //                                       ),
                      //                                       Expanded(
                      //                                         child: Container(
                      //                                           child: Text(
                      //                                             "${selectionData.searchOccasion![index].name}",
                      //                                             textAlign:
                      //                                                 TextAlign
                      //                                                     .center,
                      //                                             style: TextStyle(
                      //                                                 fontFamily: global
                      //                                                     .fontMontserratLight,
                      //                                                 fontWeight:
                      //                                                     FontWeight
                      //                                                         .w200,
                      //                                                 fontSize: 13,
                      //                                                 color: Colors
                      //                                                     .black),
                      //                                           ),
                      //                                         ),
                      //                                       ),
                      //                                     ],
                      //                                   );
                      //                                 }),
                      //                           ],
                      //                         ),
                      //                       )
                      //                     : Container(),
                      //               ],
                      //             ),
                      //           ),
                      //         ],
                      //       )
                      //     : Container(),

                      // Container(
                      //   margin: EdgeInsets.only(top: 10),
                      //   // height: 160,

                      //   color: Colors.transparent,
                      //   child: Image.asset(
                      //     "assets/images/iv_cakes_card.png",
                      //     fit: BoxFit.cover,
                      //     height: 185,
                      //     width: MediaQuery.of(context).size.width,
                      //   ),
                      // ),

                      homeProducts.length > 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: homeProducts.length,
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 15,
                                          left: 8,
                                          right: 8,
                                          bottom: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${homeProducts[index].catName}",
                                            style: TextStyle(
                                                fontFamily:
                                                    global.fontRailwayRegular,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 19,
                                                color: Colors.black),
                                          ),
                                          Container(
                                            height: 28,
                                            padding: EdgeInsets.only(
                                                left: 8, right: 8),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                border: Border.all(
                                                    color: ColorConstants
                                                        .newAppColor,
                                                    width: 0.25)),
                                            child: TextButton(
                                              child: Text(
                                                "View All",
                                                style: TextStyle(
                                                    fontFamily: global
                                                        .fontRailwayRegular,
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 12,
                                                    color: ColorConstants
                                                        .newColorBlack),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  // _homeScreenData.topCat
                                                  //     .map((e) =>
                                                  //         e.isSelected = false)
                                                  //     .toList();
                                                  // _selectedIndex = index;
                                                  // if (_selectedIndex == index) {
                                                  //   _homeScreenData.topCat[index]
                                                  //       .isSelected = true;
                                                  // }
                                                });
                                                global.homeSelectedCatID =
                                                    homeProducts[index].catId!;
                                                global.isEventProduct = false;
                                                global.isSubCatSelected = false;
                                                global.parentCatID =
                                                    homeProducts[index].catId!;
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SubCategoriesScreen(
                                                              a: widget
                                                                  .analytics,
                                                              o: widget
                                                                  .observer,
                                                              showCategories:
                                                                  true,
                                                              screenHeading:
                                                                  homeProducts[
                                                                          index]
                                                                      .catName,
                                                              categoryId:
                                                                  homeProducts[
                                                                          index]
                                                                      .catId,
                                                              isSubcategory:
                                                                  false,
                                                              isEventProducts:
                                                                  false,
                                                              // subscriptionProduct: global
                                                              //     .isSubscription, //subscriptionProduct: 1,
                                                            )));
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: _productContainerheight,
                                      child: _isDataLoaded
                                          ? BundleOffersMenu(
                                              analytics: widget.analytics,
                                              observer: widget.observer,
                                              categoryProductList:
                                                  homeProducts[index]
                                                      .productList,
                                              isHomeSelected: 'home',
                                            )
                                          : SizedBox(),
                                    )
                                  ],
                                );
                              })
                          : SizedBox(),
                    ])),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  )
                ],
              ),
      ),
    );
  }

  // _CategoriesHorizontalList() {
  // AAAC useless code
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Shimmer.fromColors(
  //       baseColor: Colors.grey.shade300,
  //       highlightColor: Colors.grey.shade100,
  //       child: SizedBox(
  //         height: 130,
  //         child: ListView.builder(
  //             shrinkWrap: true,
  //             itemCount: 4,
  //             scrollDirection: Axis.horizontal,
  //             itemBuilder: (BuildContext context, int index) {
  //               return Padding(
  //                 padding: const EdgeInsets.only(left: 16, right: 16),
  //                 child: SizedBox(width: 90, child: Card()),
  //               );
  //             }),
  //       ),
  //     ),
  //   );
  // }

  // checkLocationPermission() async {
  // AAAC useless code
  //   var status = await Permission.locationWhenInUse.status;
  //   if (!status.isGranted) {
  //     var status = await Permission.locationWhenInUse.request();
  //     if (status.isGranted) {
  //       var status = await Permission.locationAlways.request();
  //       if (status.isGranted) {
  //         //Do some stuff
  //         print("G1----> check");
  //       } else {
  //         //Do another stuff
  //         print("G1----> design");
  //       }
  //     } else {
  //       //The user deny the permission
  //     }
  //     if (status.isPermanentlyDenied) {
  //       //When the user previously rejected the permission and select never ask again
  //       //Open the screen of settings
  //       bool res = await openAppSettings();
  //     }
  //   } else {
  //     //In use is available, check the always in use
  //     var status = await Permission.locationAlways.status;
  //     if (!status.isGranted) {
  //       var status = await Permission.locationAlways.request();
  //       if (status.isGranted) {
  //         //Do some stuff
  //         print("G1----> check");
  //       } else {
  //         //Do another stuff
  //         print("G1----> design");
  //       }
  //     } else {
  //       //previously available, do some stuff or nothing
  //     }
  //   }
  // }

  Future<void> getCurrentPosition() async {
    try {
      if (Platform.isIOS) {
        print("G1---->01111");
        LocationPermission s = await Geolocator.checkPermission();
        if (s == LocationPermission.denied ||
            s == LocationPermission.deniedForever) {
          s = await Geolocator.requestPermission();
          print("G1---->01112");
          await getCurrentLocation();
        } else if (s != LocationPermission.denied ||
            s != LocationPermission.deniedForever) {
          print("G1---->01113");
          await getCurrentLocation();
        } else {
          print("G1---->01114");
          global.locationMessage =
              // '${AppLocalizations.of(context).txt_please_enablet_location_permission_to_use_app}';
              "Please enable location permission to use this App";
        }
      } else {
        PermissionStatus permissionStatus = await Permission.location.status;
        if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
          permissionStatus = await Permission.location.request();
          print("G1---->01115");
        }
        if (permissionStatus.isGranted) {
          print("G1---->01116");
          await getCurrentLocation();
        } else {
          print("G1---->01117");
          global.locationMessage =
              // '${AppLocalizations.of(context).txt_please_enablet_location_permission_to_use_app}';
              "Please enable location permission to use this App";
        }
      }
    } catch (e) {
      // hideLoader();

      print("Exception123 -  base.dart - getCurrentPosition():" + e.toString());
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
    }

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

  // void _handleDynamicLink(Uri deepLink) async {
  //AAAC useless code
  //   // print("123--------->");
  //   if (deepLink != null) {
  //     //  print("code1");

  //     final url = deepLink.toString();
  //     //  print("code2");
  //     var isRefer = url.contains('byyu.page.com%2Freferral%3Fcode%3D');
  //     if (isRefer) {
  //       // print("code");
  //       var code = url.split('byyu.page.com%2Freferral%3Fcode%3D')[1];
  //       global.refferalCode = code;
  //       print(global.refferalCode);
  //       if (code != null) {
  //         // print("Akshada----->$code");
  //       }
  //     }
  //   }
  // }

  void _startAutoScroll() async {
    final itemWidth = 160.0; // item width (150) + margin (10)
    while (true) {
      await Future.delayed(const Duration(seconds: 2));

      if (_scrollAutoController.hasClients) {
        _currentIndex++;

        double targetOffset = _currentIndex * itemWidth;

        // if we reach the end of the duplicated list, reset back to 0 instantly
        if (targetOffset >= homeScrollingTitles.length * itemWidth) {
          _currentIndex = 0;
          _scrollAutoController
              .jumpTo(0); // jump instantly (no backward scroll)
          targetOffset = 0;
        }

        _scrollAutoController.animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    if (global.iscatListRouting) {
      callSendSEODeeplinkData();
      print("AllCategoriesScreen List Routing");
      Future.delayed(Duration.zero, () {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => AllCategoriesScreen(
                    a: widget.analytics,
                    o: widget.observer,
                  )),
        );
      });
    } else if (global.routingProductID != 0) {
      callSendSEODeeplinkData();
      Future.delayed(Duration.zero, () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDescriptionScreen(
              a: widget.analytics,
              o: widget.observer,
              productId: global.routingProductID,
              isHomeSelected: "FROMROUTING",
            ),
          ),
        );
      });
    } else if (global.routingCategoryID != 0) {
      callSendSEODeeplinkData();
      global.isSubCatSelected = false;
      global.homeSelectedCatID = global.routingCategoryID;
      global.isEventProduct = false;
      global.isSubCatSelected = false;
      Future.delayed(Duration.zero, () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SubCategoriesScreen(
                      a: widget.analytics,
                      o: widget.observer,
                      showCategories: true,
                      screenHeading: global.routingCategoryName,
                      categoryId: global.routingCategoryID,
                      isEventProducts: false,
                      isSubcategory: false, //subscriptionProduct: 1,
                    )));
      });
    } else if (global.routingEventID != 0) {
      callSendSEODeeplinkData();
      global.isSubCatSelected = false;
      global.homeSelectedCatID = global.routingEventID;
      global.isEventProduct = true;
      Future.delayed(Duration.zero, () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SubCategoriesScreen(
                      a: widget.analytics,
                      o: widget.observer,
                      showCategories: true,
                      screenHeading: global.routingCategoryName,
                      categoryId: global.routingCategoryID,
                      isEventProducts: false,
                      isSubcategory: false, //subscriptionProduct: 1,
                    )));
      });
    } else if (global.occasionName != null &&
        global.occasionName.length > 0 &&
        global.genderID != null &&
        global.genderID.length > 0 &&
        global.relationshipID != null &&
        global.relationshipID.length > 0 &&
        global.maxAge != null &&
        global.maxAge.length > 0 &&
        global.minAge != null &&
        global.minAge.length > 0 &&
        global.occasionID != null &&
        global.occasionID.length > 0) {
      print(
          "FilteredSubCategoriesScreen List Routing routingEventID ${global.routingEventID}");
      callSendSEODeeplinkData();
      Future.delayed(Duration.zero, () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FilteredSubCategoriesScreen(
                      a: widget.analytics,
                      o: widget.observer,
                      minAge: int.parse(global.minAge),
                      maxAge: int.parse(global.maxAge),
                      genderID: int.parse(global.genderID
                          .trim()
                          .substring(global.genderID.indexOf("-") + 1)),
                      relationID: int.parse(global.relationshipID
                          .trim()
                          .substring(global.relationshipID.indexOf("-") + 1)),
                      ocassionID: int.parse(global.occasionID
                          .trim()
                          .substring(global.occasionID.indexOf("-") + 1)),
                    )));
      });
    } else if (global.productSearchText != null &&
        global.productSearchText.length > 0) {
      callSendSEODeeplinkData();

      Future.delayed(Duration.zero, () {
        Navigator.of(context).push(NavigationUtils.createAnimatedRoute(
            1.0,
            SearchScreen(
              a: widget.analytics,
              o: widget.observer,
              searchProductId:
                  randomSearchProductId != null ? randomSearchProductId! : 5,
            )));
      });
    } else {
      if (global.refferalCode == "" ||
          global.refferalCode.isEmpty ||
          global.refferalCode == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _startAutoScroll();
        });
        callHomeDataApi();
        _updateFCMTOken();
        // isLoading = true;
        print('G1--05--home->${DateTime.now()}');
      } else {
        Future.delayed(Duration.zero, () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SignUpScreen(
                    a: widget.analytics,
                    o: widget.observer,
                    loginCountryCode: "",
                    loginSeletedFlag: "",
                    refferCode: "referHome",
                  )));
        });
      }
    }
  }

  Widget _bannerShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width,
            child: Card(),
          ),
        ],
      ),
    );
  }

  _init() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _isDataLoaded = true;

      if (global.currentUser.id != null) {
        cartController.getCartList();
      }
      setState(() {});
    } catch (e) {
      print("Exception - dashboard_screen.dart - _init():" + e.toString());
    }
  }

  _onRefresh() async {
    try {
      _isDataLoaded = false;
      callHomeDataApi();
      //_isRecordPending = true;
      setState(() {});
      //await _init();
    } catch (e) {
      print("Exception - all_categories_screen.dart - _onRefresh():" +
          e.toString());
    }
  }

  // _shimmer1() {
  //AAAC useless code
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Shimmer.fromColors(
  //       baseColor: Colors.grey.shade300,
  //       highlightColor: Colors.grey.shade100,
  //       child: SizedBox(
  //         height: 130,
  //         child: ListView.builder(
  //             shrinkWrap: true,
  //             itemCount: 4,
  //             scrollDirection: Axis.horizontal,
  //             itemBuilder: (BuildContext context, int index) {
  //               return Padding(
  //                 padding: const EdgeInsets.only(left: 16, right: 16),
  //                 child: SizedBox(width: 90, child: Card()),
  //               );
  //             }),
  //       ),
  //     ),
  //   );
  // }

  _shimmer2() {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 264 / 796 - 20,
            child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 3.5)),
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 220 / 411,
                        child: Card()),
                  );
                }),
          )),
    );
  }

  // _shimmer3() {
  //AAAC useless code
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Shimmer.fromColors(
  //         baseColor: Colors.grey.shade300,
  //         highlightColor: Colors.grey.shade100,
  //         child: ListView.builder(
  //             shrinkWrap: true,
  //             itemCount: 4,
  //             scrollDirection: Axis.vertical,
  //             itemBuilder: (BuildContext context, int index) {
  //               return SizedBox(
  //                   height: 100 * MediaQuery.of(context).size.height / 830,
  //                   width: MediaQuery.of(context).size.width,
  //                   child: Card());
  //             })),
  //   );
  // }

  // void callNumberStore(store_number) async {
  // AAAC useless code
  //   await launch('tel:$store_number');
  // }

  _updateFCMTOken() async {
    try {
      // var fcmToken = '';
      FirebaseMessaging _firebaseMessaging =
          FirebaseMessaging.instance; // Change here
      _firebaseMessaging.getToken().then((token) {
        global.appDeviceId = token!;
      });
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        if (global.appDeviceId != null) {
          await apiHelper
              .updateFCMToken(global.appDeviceId!)
              .then((result) async {
            if (result != null) {
              print("G1--> FCM updated");
            }
          });
        } else {
          _updateFCMTOken();
        }
      } else {
        showToast("Something went wrong to update token");
      }
    } catch (e) {
      print("Exception - search_screen.dart - _getRecentSearchData():" +
          e.toString());
    }
  }

  callSendSEODeeplinkData() async {
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        await apiHelper.sendSEODeeplinkData().then((result) async {
          if (result != null) {
            if (result.status == "1") {
            } else {}
          } else {}
        });
      } else {
        showSnackBar(
            key: _scaffoldKey,
            snackBarMessage: 'Please check your internet connection');
      }
    } catch (e) {
      print("Exception - dashboard_screen.dart - callSendSEODeeplinkData():" +
          e.toString());
    }
  }

  // _getMyAddressList() async {
  //AAAC useless code
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     var _type, _lat, _lng;
  //     global.currentLocation = (prefs.getString('type') ?? '');
  //     global.lat = prefs.getDouble('lat');
  //     global.lng = prefs.getDouble('lng');
  //     if (global.currentLocation == null || global.currentLocation.isEmpty) {
  //       homeLocation = 'Home';
  //     } else {
  //       homeLocation = prefs.getString('type') ?? '';
  //     }
  //     setState(() {});
  //   } catch (e) {
  //     print("Exception - addressListScreen.dart (88):" + e.toString());
  //   }
  // }
  // _setHomeAddress() async {

  //AAAC useless code
  //   try {
  //     global.userProfileController.getUserAddressList();

  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     print('G1--05--home21->${DateTime.now()}');
  //     if (global.addressList.length > 0) {
  //       for (var i = 0; i < global.addressList.length; i++) {
  //         if (global.addressList[i].type!.toLowerCase() == "home") {
  //           global.lat = double.parse(global.addressList[i].lat!);
  //           global.lng = double.parse(global.addressList[i].lng!);
  //           global.currentLocation = "${global.addressList[i].type}";
  //           setState(() {
  //             prefs.setString('type', "${global.addressList[i].type}");
  //             prefs.setDouble('lat', double.parse(global.addressList[i].lat!));
  //             prefs.setDouble('lng', double.parse(global.addressList[i].lng!));
  //           });
  //         }
  //         setState(() {});
  //       }
  //       setState(() {});
  //     } else {
  //       // _getMyAddressList();
  //     }
  //     setState(() {});
  //   } catch (e) {
  //     print("Exception - addressListScreen.dart (22):" + e.toString());
  //   }
  // }

  showNetworkErrorSnackBar1(GlobalKey<ScaffoldState> scaffoldKey) {
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
                ),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
            textColor: Colors.white,
            label: 'RETRY',
            onPressed: () {
              _onRefresh();
              ;
            }),
        backgroundColor: Colors.grey,
      ));
    } catch (e) {
      print("Exception -  base.dart - showNetworkErrorSnackBar1():" +
          e.toString());
    }
  }

  // callAllProductsApi() async {
  //   try {
  //     print('HomeScreen data');
  //     bool isConnected = await br.checkConnectivity();
  //     if (isConnected) {
  //       await apiHelper.getProductBeanList().then((result) async {
  //         if (result != null) {
  //           // print("g1---->${result.toString}");
  //           // //print("g1---->${result.success}");

  //           //if (result.success == true) {
  //           setState(() {
  //             _isLoading = false;
  //             _isDataLoaded = true;
  //           });
  //           print("g1---->${result.data}");
  //           productHomeDataList = result.data;
  //           productListAll = productHomeDataList.data;

  //           print("g1---->${productListAll.length}");
  //           //print("g1---->${productListAll}");
  //           // } else {
  //           //   productHomeDataList = null;
  //           // }
  //           setState(() {});
  //         }
  //       });
  //     } else {
  //       showNetworkErrorSnackBar1(_scaffoldKey);
  //     }
  //   } catch (e) {
  //     print("Exception - dashboard_screen.dart - _getHomeScreenData():" +
  //         e.toString());
  //   }
  // }
  List<Recentselling> homeProducts = [];
  callHomeDataApi() async {
    try {
      print('HomeScreen data');
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        await apiHelper
            .getHomeBeanData(Platform.isIOS ? "iOS" : "Android")
            .then((result) async {
          if (result != null) {
            // print("g1---->${result.toString}");
            // //print("g1---->${result.success}");

            //if (result.success == true) {

            _bannerIndex = 0;
            _homeScreenData = null;
            productSection1List.clear();
            productSection3List.clear();
            productSection2List.clear();
            productSection4List.clear();
            productSection5List.clear();
            bannerEventImageURL.clear();
            homeProducts.clear();

            _homeScreenData = result.data;
            if (_homeScreenData!.banner != null &&
                _homeScreenData!.banner!.length > 0) {
              _homeScreenData!.banner![0].isSelected = true;
            }

            if (_homeScreenData!.events != null &&
                _homeScreenData!.events!.length > 0) {
              for (int i = 0; i < _homeScreenData!.events!.length; i++) {
                bannerEventImageURL.add(global.imageBaseUrl +
                    _homeScreenData!.events![i].eventBannerImage! +
                    "?width=500&height=500");

                if (_homeScreenData!.events![i].eventImage != null &&
                    _homeScreenData!.events![i].eventImage!.trim() != "N/A" &&
                    _homeScreenData!.events![i].eventImage! != "n\a") {
                  print(_homeScreenData!.events![i].eventImage);
                  bannerEventIconURL.add(new EventIconName(
                      _homeScreenData!.events![i].id,
                      _homeScreenData!.events![i].eventName!,
                      _homeScreenData!.events![i].eventImage! +
                          "?width=500&height=500"));
                }
              }
            }
            for (int i = 2; i < _homeScreenData!.recentselling!.length; i++) {
              homeProducts.add(_homeScreenData!.recentselling![i]);
            }
            if (_homeScreenData!.recentselling!.length >= 2) {
              productSection1List =
                  _homeScreenData!.recentselling![0].productList!;
              productSection2List =
                  _homeScreenData!.recentselling![1].productList!;
            } else if (_homeScreenData!.recentselling!.length >= 1) {
              productSection1List =
                  _homeScreenData!.recentselling![0].productList!;
            }

            _isDataLoaded = true;
            await callFiltersApi();
            //await cartController.getCartList();
            setState(() {
              _bannerIndex = 0;
              _isLoading = false;
            });
          }
        });
      } else {
        showNetworkErrorSnackBar1(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - dashboard_screen.dart 1- _getHomeScreenData():" +
          e.toString());
    }
  }

  callFiltersApi() async {
    try {
      print('HomeScreen data');
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        await apiHelper.getFiltersRelations().then((result) async {
          if (result != null) {
            selectionData = result.data;
            maleRelation.clear();
            femaleRelation.clear();
            for (int i = 0; i < selectionData.searchRelationship!.length; i++) {
              if (selectionData.searchRelationship![i].type != null &&
                  selectionData.searchRelationship![i].type!.toLowerCase() ==
                      "m") {
                maleRelation.add(selectionData.searchRelationship![i]);
              } else if (selectionData.searchRelationship![i].type != null &&
                  selectionData.searchRelationship![i].type!.toLowerCase() ==
                      "f") {
                femaleRelation.add(selectionData.searchRelationship![i]);
              }
            }
            //selectionData = selectionFilterModel.selectionData;
            setState(() {
              _isLoading = false;
              _isDataLoaded = true;
            });
          }
        });
      } else {
        showNetworkErrorSnackBar1(_scaffoldKey);
      }
    } catch (e) {
      print(
          "Exception - dashboard_screen.dart callFiltersApi- _getHomeScreenData():" +
              e.toString());
    }
  }
}
