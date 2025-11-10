import 'dart:io';
import 'dart:math';
import 'package:banner_image/banner_image.dart';
import 'package:byyu/screens/auth/signup_screen.dart';
import 'package:byyu/screens/product/all_events_screen.dart';
import 'package:byyu/screens/product/filtered_sub_categories_screen.dart';
import 'package:byyu/screens/product/product_description_screen.dart';
import 'package:byyu/widgets/side_drawer.dart';
import 'package:byyu/widgets/toastfile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
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
  List<ReviewRatingsModel> reviewRatings = [];
  List<String> midSectionImageURL = [
    "assets/images/midSectionBanners/iv_mid_1.png",
    "assets/images/midSectionBanners/iv_mid_2.png",
    "assets/images/midSectionBanners/iv_mid_3.png",
    "assets/images/midSectionBanners/iv_mid_4.png"
  ];
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
  double _productContainerheight = 330.0;
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

  Widget _buildFeatureCard({
    required double width,
    required String image,
    required String title,
    required String subtitle,
  }) {
    const double cardHeight = 70; // height tuned to match design

    return Container(
      width: width,
      height: cardHeight,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // image (left side)
          Image.asset(
            image,
            width: 40,
            height: 40,
            fit: BoxFit.contain,
          ),

          const SizedBox(width: 10),

          // text content
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: global.fontRailwayRegular,
                    fontSize: 13,
                    color: const Color.fromARGB(31, 0, 0, 0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: global.fontRailwayRegular,
                    fontSize: 12,
                    color: ColorConstants.newTextHeadingFooter,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int chooseRecePient = 0;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CartController cartController = Get.put(CartController());
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
      key: _scaffoldKey,
      drawerEnableOpenDragGesture: global.showHamburgerMenu == 1 ? true : false,
      drawer: global.showHamburgerMenu == 1
          ? SideDrawer(
              analytics: widget.analytics,
              observer: widget.observer,
            )
          : Container(),
      appBar: AppBar(
          backgroundColor: ColorConstants.appBarColorWhite,
          leadingWidth: 46,
          automaticallyImplyLeading: false, // use for back button remover
          centerTitle: true, // place logo in center
          leading: global.showHamburgerMenu == 1
              ? InkWell(
                  onTap: () => {_scaffoldKey.currentState?.openDrawer()},
                  child: Container(
                    margin:
                        EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
                    width: MediaQuery.of(context).size.width - 23,
                    height: MediaQuery.of(context).size.height - 23,
                    child: Image.asset(
                      "assets/images/hamburger_menu.png",
                      fit: BoxFit.contain,
                      height: 25,
                      alignment: Alignment.center,
                    ),
                  ),
                  // onTap: () {

                  // },
                )
              : Container(),
          actions: [
            InkWell(
              onTap: () {
                randomSearchProductId = _homeScreenData!
                    .topselling![
                        Random().nextInt(_homeScreenData!.topselling!.length)]
                    .productId!;
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SearchScreen(
                          a: widget.analytics,
                          o: widget.observer,
                          searchProductId: randomSearchProductId!,
                        )));
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 17, bottom: 17, right: 10),
                child: Image.asset(
                  "assets/images/iv_search.png",
                  fit: BoxFit.contain,
                  height: 25,
                  alignment: Alignment.center,
                ),
              ),
            ),
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
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 15, bottom: 15, right: 5),
                      child: Image.asset(
                        "assets/images/iv_bell_appcolor.png",
                        fit: BoxFit.contain,
                        height: 25,
                        alignment: Alignment.center,
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
            height: 25,
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
                      //                             global.fontRailwayRegular,
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
                                                                  .eventsbanner![
                                                                      p0]
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
                                                                                _homeScreenData!.eventsbanner![p0].eventName,
                                                                            categoryId:
                                                                                _homeScreenData!.eventsbanner![p0].id,
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

                      Container(
                        width: double.infinity,
                        color: const Color(0xFFF2E1CF), // beige background
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            // calculate width for 2 cards per row
                            final double totalHorizontalPadding = 16 * 2;
                            final double gapBetweenCards = 12;
                            final double cardWidth = (constraints.maxWidth -
                                    totalHorizontalPadding -
                                    gapBetweenCards) /
                                2;

                            return Wrap(
                              spacing: gapBetweenCards,
                              runSpacing: 12,
                              alignment: WrapAlignment.center,
                              children: [
                                _buildFeatureCard(
                                  width: cardWidth,
                                  image: 'assets/images/USP-01.png',
                                  title: "EXPRESS DELIVERY",
                                  subtitle: "Delivered in Just 1 Hour",
                                ),
                                _buildFeatureCard(
                                  width: cardWidth,
                                  image: 'assets/images/USP-02.png',
                                  title: "FREE DELIVERY",
                                  subtitle: "Zero Delivery Charges",
                                ),
                                _buildFeatureCard(
                                  width: cardWidth,
                                  image: 'assets/images/USP-03.png',
                                  title: "SECURE PAYMENTS",
                                  subtitle: "Pay Safe. Stay Secure",
                                ),
                                _buildFeatureCard(
                                  width: cardWidth,
                                  image: 'assets/images/USP-04.png',
                                  title: "DEDICATED",
                                  subtitle: "Help Center",
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      // /////this is the section for special events

                      Container(
                        color: ColorConstants.colorHomePageSection,
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              padding: EdgeInsets.only(bottom: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Celebrate every occasion",
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
                              height: 125,

                              child: Stack(
                                children: [
                                  Container(
                                    height: 125,
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
                                                      return InkWell(
                                                        onTap: () {
                                                          global.homeSelectedCatID =
                                                              _homeScreenData!
                                                                  .events![
                                                                      index]
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
                                                                                _homeScreenData!.events![index].eventName,
                                                                            categoryId:
                                                                                _homeScreenData!.events![index].id,
                                                                            isEventProducts:
                                                                                true,
                                                                            isSubcategory:
                                                                                false, //subscriptionProduct: 1,
                                                                          )));
                                                        },
                                                        child: Container(
                                                            width: 75,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 5,
                                                                    right: 5,
                                                                    left: 5),
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  width: 60,
                                                                  height: 60,
                                                                  child: Card(
                                                                    elevation:
                                                                        0,
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
                                                                    margin: EdgeInsets.only(
                                                                        left: 1,
                                                                        right:
                                                                            1),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              60,
                                                                          height:
                                                                              60,
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(100),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(15.0),
                                                                              child: CachedNetworkImage(
                                                                                fit: BoxFit.contain,
                                                                                imageUrl: global.imageBaseUrl + bannerEventIconURL[index].eventIconURL!,
                                                                                imageBuilder: (context, imageProvider) => Container(
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
                                                                                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                                                                errorWidget: (context, url, error) => Container(
                                                                                  width: 55,
                                                                                  height: 55,
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
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              8),
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
                                                                              fontFamily: global.fontRailwayRegular,
                                                                              fontWeight: FontWeight.w200,
                                                                              fontSize: 12,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              color: ColorConstants.newTextHeadingFooter),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                                      );
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

                      SizedBox(
                        height: 35,
                      ),

                      ///Special events section ends here
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Curated just for you",
                              style: TextStyle(
                                  fontFamily: global.fontRailwayRegular,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 19,
                                  color: ColorConstants.newTextHeadingFooter),
                            ),
                            Container(
                              height: 24,
                              padding: EdgeInsets.only(left: 4, right: 4),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                      color: ColorConstants.newAppColor,
                                      width: 0.25)),
                              child: TextButton(
                                child: Text(
                                  "VIEW ALL",
                                  style: TextStyle(
                                      fontFamily: global.fontRailwayRegular,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 10,
                                      color:
                                          ColorConstants.newTextHeadingFooter),
                                ),
                                onPressed: () {
                                  // Akshada change
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AllCategoriesScreen(
                                              a: widget.analytics,
                                              o: widget.observer,
                                              fromNavBar: false,
                                            )),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        // margin: EdgeInsets.only(top: 5, bottom: 20),
                        // padding: EdgeInsets.only(top: 5, bottom: 20),
                        height: 130,
                        child: Container(
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
                                                          e.isSelected = false)
                                                      .toList();
                                                  _selectedIndex = index;
                                                  if (_selectedIndex == index) {
                                                    _homeScreenData!
                                                        .topCat![index]
                                                        .isSelected = true;
                                                  }
                                                });
                                                print(
                                                    "caategory id-------${_homeScreenData!.topCat![index].catId}");
                                                global.isEventProduct = false;
                                                global.isSubCatSelected = false;
                                                global.homeSelectedCatID =
                                                    _homeScreenData!
                                                        .topCat![index].catId!;
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
                                                              categoryId:
                                                                  _homeScreenData!
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
                                                      shadowColor:
                                                          Colors.transparent,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                      ),
                                                      margin: EdgeInsets.only(
                                                          left: 1, right: 1),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            width: 75,
                                                            height: 75,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                              child:
                                                                  CachedNetworkImage(
                                                                height: 65,
                                                                fit: BoxFit
                                                                    .contain,
                                                                width: 65,
                                                                imageUrl: global
                                                                        .imageBaseUrl +
                                                                    _homeScreenData!
                                                                        .topCat![
                                                                            index]
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
                                                                          .contain,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
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
                                                                  width: 60.0,
                                                                  height: 60.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    // borderRadius: BorderRadius.circular(15),
                                                                    image:
                                                                        DecorationImage(
                                                                      image: AssetImage(
                                                                          global
                                                                              .catNoImage),
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
                                                    margin:
                                                        EdgeInsets.only(top: 8),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 1,
                                                                  right: 1),
                                                          child: Text(
                                                            "${_homeScreenData!.topCat![index].title}",
                                                            maxLines: 2,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontFamily: global
                                                                    .fontRailwayRegular,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w200,
                                                                fontSize: 12,
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
                      ),

                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 8, right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                _homeScreenData!.recentselling!.length > 0
                                    ? "${_homeScreenData!.recentselling![0].catName}"
                                    : "",
                                maxLines: 1,
                                style: TextStyle(
                                    fontFamily: global.fontRailwayRegular,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 19,
                                    color:
                                        ColorConstants.newTextHeadingFooter)),
                            Container(
                              height: 24,
                              padding: EdgeInsets.only(left: 4, right: 4),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                      color: ColorConstants.newAppColor,
                                      width: 0.25)),
                              child: TextButton(
                                child: Text(
                                  "VIEW ALL",
                                  style: TextStyle(
                                      fontFamily: global.fontRailwayRegular,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 10,
                                      color:
                                          ColorConstants.newTextHeadingFooter),
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
                      SizedBox(
                        height: 25,
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
                      ////section 2 products ends here
                      _homeScreenData!.recentselling!.length >= 1
                          ? Wrap(
                              children: [
                                Container(
                                  color: ColorConstants.colorHomePageSectiondim,
                                  //height: productSection2List != null ? 675 : 0,
                                  padding: EdgeInsets.only(top: 25),
                                  //margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 8, right: 8, top: 1),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Text(
                                                _homeScreenData!.recentselling!
                                                            .length >
                                                        1
                                                    ? "${_homeScreenData!.recentselling![1].catName}"
                                                    : "",
                                                style: TextStyle(
                                                    fontFamily: global
                                                        .fontRailwayRegular,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 19,
                                                    color: ColorConstants
                                                        .newTextHeadingFooter),
                                              ),
                                            ),
                                            Container(
                                              height: 24,
                                              padding: EdgeInsets.only(
                                                  left: 4, right: 4),
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
                                                  "VIEW ALL",
                                                  style: TextStyle(
                                                      fontFamily: global
                                                          .fontRailwayRegular,
                                                      fontWeight:
                                                          FontWeight.w200,
                                                      fontSize: 10,
                                                      color: ColorConstants
                                                          .newTextHeadingFooter),
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
                                                  global.isEventProduct = false;
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
                                                                screenHeading:
                                                                    _homeScreenData!
                                                                        .recentselling![
                                                                            1]
                                                                        .catName,
                                                                categoryId:
                                                                    _homeScreenData!
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
                                      SizedBox(
                                        height: 25,
                                      ),
                                      Container(
                                        height: _productContainerheight - 20,
                                        child: _isDataLoaded &&
                                                productSection2List != null
                                            ? productSection2List != null &&
                                                    productSection2List.length >
                                                        0
                                                ? BundleOffersMenu(
                                                    analytics: widget.analytics,
                                                    observer: widget.observer,
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
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 25,
                      ),
//////Setion 3 products starts here
                      _homeScreenData!.recentselling!.length >= 2
                          ? Wrap(
                              children: [
                                Container(
                                  color: Colors.transparent,
                                  //height: productSection2List != null ? 675 : 0,

                                  //margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 8, right: 8, top: 1),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Text(
                                                _homeScreenData!.recentselling!
                                                            .length >
                                                        1
                                                    ? "${_homeScreenData!.recentselling![2].catName}"
                                                    : "",
                                                style: TextStyle(
                                                    fontFamily: global
                                                        .fontRailwayRegular,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 19,
                                                    color: ColorConstants
                                                        .newTextHeadingFooter),
                                              ),
                                            ),
                                            Container(
                                              height: 24,
                                              padding: EdgeInsets.only(
                                                  left: 4, right: 4),
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
                                                  "VIEW ALL",
                                                  style: TextStyle(
                                                      fontFamily: global
                                                          .fontRailwayRegular,
                                                      fontWeight:
                                                          FontWeight.w200,
                                                      fontSize: 10,
                                                      color: ColorConstants
                                                          .newTextHeadingFooter),
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
                                                          .recentselling![2]
                                                          .catId!;
                                                  global.parentCatID =
                                                      _homeScreenData!
                                                          .recentselling![2]
                                                          .catId!;
                                                  global.isEventProduct = false;
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
                                                                screenHeading:
                                                                    _homeScreenData!
                                                                        .recentselling![
                                                                            2]
                                                                        .catName,
                                                                categoryId:
                                                                    _homeScreenData!
                                                                        .recentselling![
                                                                            2]
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
                                      SizedBox(height: 25),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 14),
                                        height: _productContainerheight - 25,
                                        child: _isDataLoaded &&
                                                productSection3List != null
                                            ? productSection3List != null &&
                                                    productSection3List.length >
                                                        0
                                                ? BundleOffersMenu(
                                                    analytics: widget.analytics,
                                                    observer: widget.observer,
                                                    categoryProductList:
                                                        productSection3List,
                                                    isHomeSelected: 'home',
                                                  )
                                                : SizedBox()
                                            : _shimmer2(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(),
                      //////Setion 3 products ends here

                      // Container(
                      //   margin: EdgeInsets.only(left: 10,right: 10),
                      //   // height: 160,

                      //   color: Colors.transparent,
                      //   child: Image.asset(
                      //     "assets/images/home_section_image.png",
                      //     fit: BoxFit.contain,

                      //     width: MediaQuery.of(context).size.width,
                      //   ),
                      // ),
                      Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          // height: 160,

                          color: Colors.transparent,
                          child: BannerImage(
                            // onTap: (p0) {
                            //   global.homeSelectedCatID =
                            //       _homeScreenData!
                            //           .events![p0].id!;
                            //   global.isEventProduct = true;
                            //   Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) =>
                            //               SubCategoriesScreen(
                            //                 a: widget.analytics,
                            //                 o: widget.observer,
                            //                 showCategories: true,
                            //                 screenHeading:
                            //                     _homeScreenData!
                            //                         .events![p0]
                            //                         .eventName,
                            //                 categoryId:
                            //                     _homeScreenData!
                            //                         .events![p0]
                            //                         .id,
                            //                 isEventProducts: true,
                            //                 isSubcategory:
                            //                     false, //subscriptionProduct: 1,
                            //               )));
                            // },

                            borderRadius: BorderRadius.circular(15),
                            autoPlay: true,
                            timerDuration: Duration(seconds: 4),
                            aspectRatio: 2.3,
                            padding: EdgeInsets.only(),
                            itemLength: midSectionImageURL.length,
                            children: List.generate(
                              midSectionImageURL.length,
                              (index) => Image.file(
                                File(midSectionImageURL[index]
                                    .replaceFirst('file://', '')),
                                fit: BoxFit.cover,
                              ),
                            ),
                            selectedIndicatorColor: ColorConstants.appColor,
                            fit: BoxFit.contain,
                            errorBuilder: (context, child, loadingProgress) {
                              return Container(
                                padding: EdgeInsets.only(
                                    top: 50, bottom: 50, left: 150, right: 150),
                                height: 10,
                                width: 10,
                                child: CircularProgressIndicator(),
                              );
                            },
                          )),
                      SizedBox(
                        height: 25,
                      ),
                      homeProducts.length > 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: homeProducts.length,
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 8, right: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${homeProducts[index].catName}",
                                            style: TextStyle(
                                                fontFamily:
                                                    global.fontRailwayRegular,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 19,
                                                color: ColorConstants
                                                    .newTextHeadingFooter),
                                          ),
                                          Container(
                                            height: 24,
                                            padding: EdgeInsets.only(
                                                left: 4, right: 4),
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
                                                "VIEW ALL",
                                                style: TextStyle(
                                                    fontFamily: global
                                                        .fontRailwayRegular,
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 10,
                                                    color: ColorConstants
                                                        .newTextHeadingFooter),
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
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      height: _productContainerheight - 20,
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
                                    ),
                                  ],
                                );
                              })
                          : SizedBox(),
                      //
                      // Container(height: 50,child: Text(reviewRatings.length.toString(),
                      //     style: TextStyle(fontSize: 30),
                      // ) ,),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                "Loved By You",
                                style: TextStyle(
                                    fontFamily: global.fontRailwayRegular,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 19,
                                    color: ColorConstants.newTextHeadingFooter),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            SizedBox(
                              height: 170,
                              child: ListView.builder(
                                  itemCount: reviewRatings.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.only(left: 10),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: ColorConstants.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: RatingBar.builder(
                                              initialRating: double.parse(
                                                  reviewRatings[index]
                                                      .ratingcount!),
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              updateOnDrag: false,
                                              ignoreGestures: true,
                                              itemCount: 5,
                                              itemSize: 25,
                                              itemPadding: EdgeInsets.symmetric(
                                                  horizontal: 0.5),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {
                                                print(rating);
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            reviewRatings[index].username!,
                                            style: TextStyle(
                                                fontFamily:
                                                    global.fontRalewayMedium,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 19,
                                                color: ColorConstants
                                                    .newTextHeadingFooter),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.5,
                                            child: Text(
                                              reviewRatings[index].message!,
                                              maxLines: 5,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontFamily:
                                                      global.fontRailwayRegular,
                                                  fontWeight: FontWeight.w200,
                                                  fontSize: 13,
                                                  color: ColorConstants
                                                      .newTextHeadingFooter),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 110,
                      ),
                    ])),
              )
            : Container(
                color: ColorConstants.colorPageBackground,
                child: Column(
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
                            fontFamily: fontRailwayRegular,
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
              fromBottomNvigation: false,
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
        loadImages();
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

  loadImages() async {
    print("load images is called--=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-");
    midSectionImageURL = [
      await assetToFileUrl("assets/images/midSectionBanners/iv_mid_1.png"),
      await assetToFileUrl(
        "assets/images/midSectionBanners/iv_mid_2.png",
      ),
      await assetToFileUrl(
        "assets/images/midSectionBanners/iv_mid_3.png",
      ),
      await assetToFileUrl(
        "assets/images/midSectionBanners/iv_mid_4.png",
      ),
    ];
    setState(() {});
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

      cartController = CartController();
      cartController.getCartList();

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
            bannerEventImageURL.clear();
            if (_homeScreenData!.eventsbanner != null &&
                _homeScreenData!.eventsbanner!.length > 0) {
              for (int i = 0; i < _homeScreenData!.eventsbanner!.length; i++) {
                if (_homeScreenData!.eventsbanner![i].eventBannerImg != null &&
                    _homeScreenData!.eventsbanner![i].eventBannerImg!.length >
                        0 &&
                    _homeScreenData!.eventsbanner![i].eventBannerImg!.trim() !=
                        "N/A") {
                  print(
                      "-=-=--=-=-=-=-=-=-=-=-=-=-=-==-=-==-=-=-=-=-=-=-=-=-==--");
                  print(global.imageBaseUrl +
                      _homeScreenData!.events![i].eventBannerImage! +
                      "?width=500&height=500");
                  bannerEventImageURL.add(global.imageBaseUrl +
                      _homeScreenData!.events![i].eventBannerImage! +
                      "?width=500&height=500");
                }
              }
            }
            bannerEventIconURL.clear();
            if (_homeScreenData!.eventsoccasion != null &&
                _homeScreenData!.eventsoccasion!.length > 0) {
              for (int i = 0;
                  i < _homeScreenData!.eventsoccasion!.length;
                  i++) {
                if (_homeScreenData!.eventsoccasion![i].eventImage != null &&
                    _homeScreenData!.eventsoccasion![i].eventImage!.trim() !=
                        "N/A" &&
                    _homeScreenData!.eventsoccasion![i].eventImage! != "n\a") {
                  bannerEventIconURL.add(new EventIconName(
                      _homeScreenData!.eventsoccasion![i].id,
                      _homeScreenData!.eventsoccasion![i].eventName!,
                      _homeScreenData!.eventsoccasion![i].eventImage! +
                          "?width=500&height=500"));
                }
              }
            }
            if (_homeScreenData!.recentselling!.length > 2) {
              for (int i = 3; i < _homeScreenData!.recentselling!.length; i++) {
                homeProducts.add(_homeScreenData!.recentselling![i]);
              }
            }
            if (_homeScreenData!.recentselling!.length >= 3) {
              productSection1List =
                  _homeScreenData!.recentselling![0].productList!;
              productSection2List =
                  _homeScreenData!.recentselling![1].productList!;
              productSection3List =
                  _homeScreenData!.recentselling![2].productList!;
            } else if (_homeScreenData!.recentselling!.length >= 2) {
              productSection1List =
                  _homeScreenData!.recentselling![0].productList!;
              productSection2List =
                  _homeScreenData!.recentselling![1].productList!;
            } else if (_homeScreenData!.recentselling!.length >= 1) {
              productSection1List =
                  _homeScreenData!.recentselling![0].productList!;
            }

            if (_homeScreenData!.reviewratings != null) {
              print(
                  "reviewRatings.length-=-===-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=--=-=-=-");
              if (_homeScreenData!.reviewratings!.length > 0) {
                reviewRatings.addAll(_homeScreenData!.reviewratings!);
              }
            } else {
              List<ReviewRatingsModel> staticRatings = [
                ReviewRatingsModel(
                    id: 1,
                    ratingcount: "5",
                    username: "Pokroff Sergey",
                    message:
                        "They offer a wide selection of flowers, including even the tulips. So far, these are the freshest flowers I’ve found in the desert."),
                ReviewRatingsModel(
                    id: 2,
                    ratingcount: "5",
                    username: "Anleey Pereira",
                    message:
                        "We recently met the team at BYYU and were really impressed with their creativity and the wide range of services they offer..."),
                ReviewRatingsModel(
                    id: 3,
                    ratingcount: "5",
                    username: "Sayeed Asmin",
                    message:
                        "BYYU flowers always has supported me in delivering the flowers in a very organized way, timely delivery, and with great quality. Very much appreciated - guys do prefer BYYU flowers for any occasions."),
                ReviewRatingsModel(
                    id: 3,
                    ratingcount: "5",
                    username: "Habibi Rehman",
                    message:
                        "Customers rave about the exquisite quality of their products and the seamless online shopping experience. BYYU Gift & Flowers delivers smiles, one gift and flower at a time."),
                ReviewRatingsModel(
                    id: 3,
                    ratingcount: "5",
                    username: "Yeth Espinas",
                    message:
                        "I've ordered from them multiple times, and they never disappoint! Deliveries are always made on time, and the flowers are fresh and beautifully arranged, all without breaking the bank. Their customer service is superb!"),
                ReviewRatingsModel(
                    id: 3,
                    ratingcount: "5",
                    username: "Shantanu Mishra",
                    message:
                        "Have been trying out their services very often lately, and I have to say, they deliver more than expected EVERY TIME! Do try their chocolate cakes, its a fan favorite!"),
                ReviewRatingsModel(
                    id: 3,
                    ratingcount: "5",
                    username: "Vaishnavi Naik",
                    message:
                        "BYYU makes gifting so easy and enjoyable! The platform is user-friendly, with a great selection of gifts for any occasion. I love how the personalized options make it feel extra special. Highly recommend it for anyone looking to find the perfect gift!"),
                ReviewRatingsModel(
                    id: 3,
                    ratingcount: "5",
                    username: "Sakchyam Choudhary",
                    message:
                        "I had an amazing experience with this gifting platform! The selection of gifts is diverse and unique, and the ordering process was seamless. Delivery was prompt, and the gifts were beautifully packaged."),
                ReviewRatingsModel(
                    id: 3,
                    ratingcount: "5",
                    username: "Boshra Bassam",
                    message:
                        "Thank you so much for your services. It was a great experience to buy through this store. Thank you BYYU"),
                ReviewRatingsModel(
                    id: 3,
                    ratingcount: "5",
                    username: "Jaspreet Singh",
                    message:
                        "I recently used BYYU for a special gift, and I couldn’t be happier with the experience! The packaging was beautiful, and everything arrived in perfect condition. Customer service was also top-notch-responsive and helpful. I’ll definitely be using them again!"),
                ReviewRatingsModel(
                    id: 3,
                    ratingcount: "5",
                    username: "Karan Gupta",
                    message:
                        "Best gifting experience with a high quality unique gifts and flowers. Also the support is very helpful and responsive."),
              ];
              reviewRatings.addAll(staticRatings);
              print(
                  "reviewRatings.length-=-===-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=--=-=-=-");
              print(reviewRatings.length);
            }

            _isDataLoaded = true;
            // await callFiltersApi();
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
