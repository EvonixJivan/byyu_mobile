import 'package:byyu/constants/analytics_GA4.dart';
import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/controllers/cart_controller.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/models/productDetailModel.dart';
import 'package:byyu/models/productFilterModel.dart';
import 'package:byyu/screens/auth/login_screen.dart';
import 'package:byyu/widgets/bundle_offers_menu.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/categoryProductModel.dart';
import 'package:byyu/models/recentSearchModel.dart';
import 'package:byyu/screens/home_screen.dart';
import 'package:byyu/screens/product/search_results_screen.dart';
import 'package:byyu/utils/navigation_utils.dart';
import 'package:byyu/widgets/my_text_box.dart';

class SearchScreen extends BaseRoute {
  int? searchProductId;
  bool? fromBottomNvigation;
  SearchScreen({a, o, this.searchProductId,this.fromBottomNvigation})
      : super(a: a, o: o, r: 'SearchScreen');

  @override
  _SearchScreenState createState() =>
      _SearchScreenState(productId: searchProductId,fromBottomNvigation:fromBottomNvigation);
}

class SearchScreenHeader extends StatefulWidget {
  final TextTheme textTheme;
  final dynamic analytics;
  final dynamic observer;
    bool? fromBottomNvigation;

  SearchScreenHeader({required this.textTheme, this.analytics, this.observer,this.fromBottomNvigation})
      : super();

  @override
  _SearchScreenHeaderState createState() => _SearchScreenHeaderState(
      textTheme: textTheme,
      analytics: analytics,
      observer: observer,
      fromBottomNvigation: fromBottomNvigation,
      searchProductId: 0);
}

class _SearchScreenHeaderState extends State<SearchScreenHeader> {
  TextTheme textTheme;
  dynamic analytics;
  dynamic observer;
  int? searchProductId;
  bool? fromBottomNvigation;
  TextEditingController _cSearch = new TextEditingController();
  _SearchScreenHeaderState(
      {required this.textTheme,
      this.analytics,
      this.observer,
      this.fromBottomNvigation,
      required this.searchProductId});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        fromBottomNvigation==true?SizedBox():BackButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            //icon: Icon(Icons.keyboard_arrow_left),
            color: ColorConstants.appColor),
        SizedBox(width: 16),
        MyTextBox(
            isHomePage: false,
            borderRadius: 10,
            key: Key('30'),
            autofocus: false,
            controller: _cSearch,
            suffixIcon: InkWell(
              onTap: () {
                _cSearch.clear();
              },
              child: Icon(Icons.cancel,
                  color:
                      ColorConstants.appColor //Theme.of(context).primaryColor,
                  ),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: ColorConstants.appColor,
            ),
            
            
            hintText:
                "Search products", //"${AppLocalizations.of(context).hnt_search_product}",
            textCapitalization: TextCapitalization.words,
            onChanged: (value) {},
            onEditingComplete: () {
              Navigator.of(context).push(NavigationUtils.createAnimatedRoute(
                  1.0,
                  SearchResultsScreen(
                    a: widget.analytics,
                    o: widget.observer,
                    searchParams: _cSearch.text.trim(),
                    searchScreen: "search",
                  )));
            }),

        // TextButton(
        //   onPressed: () => Get.to(() => HomeScreen(
        //         a: widget.analytics,
        //         o: widget.observer,
        //       )),
        //   child: Text(
        //     "Cancel",
        //     // "${AppLocalizations.of(context).lbl_cancel}",
        //     style: TextStyle(
        //       color: ColorConstants.appColor,
        //     ),
        //   ),
        // )
      ],
    );
  }
}

class _SearchScreenState extends BaseRouteState {
  bool _isDataLoaded = false;
  List<RecentSearch> _recentSearchList = [];
  List<Product> _trendingSearchProducts = [];
  List<Product> _trendingSearchBrand = [];
  List<Product> _productsList = [];
  CartController cartController = Get.put(CartController());
  int? productId;
  int? storeId;
  int? _selectedIndex;
  ProductDetail _productDetail = new ProductDetail();
  List<String> _productImages = [];
  bool _isRecordPending = true;
  bool _isMoreDataLoaded = false;
  int page = 1;
  bool? fromBottomNvigation;
  int? categoryId;
  ProductFilter _productFilter = new ProductFilter();

  GlobalKey<ScaffoldState>? _scaffoldKey;

  _SearchScreenState({this.productId,this.fromBottomNvigation});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return WillPopScope(
      onWillPop: () async {
        global.productSearchText="";
        Navigator.of(context).pop();
        return true;

        // return Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => HomeScreen(
        //               a: widget.analytics,
        //               o: widget.observer,
        //               selectedIndex: 0,
        //             )));
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: global.nearStoreModel != null
              ? null
              : AppBar(
                  backgroundColor: ColorConstants.appBarColorWhite,
                  title: Text("Search products",
                      // '${AppLocalizations.of(context).hnt_search_product}',
                      style: TextStyle(
                          fontFamily: fontRailwayRegular,
                          color:
                              ColorConstants.pureBlack) //textTheme.titleLarge,
                      ),
                      leading: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: ColorConstants.newAppColor),
                ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            color: ColorConstants.colorPageBackground,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.0),
                child: global.nearStoreModel != null
                    ? RefreshIndicator(
                        onRefresh: () async {
                          await _onRefresh();
                        },
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 16.0,
                                  bottom: 32,
                                ),
                                child: SearchScreenHeader(
                                  textTheme: textTheme,
                                  analytics: widget.analytics,
                                  observer: widget.observer,
                                  fromBottomNvigation:fromBottomNvigation,
                                ),
                              ),

                              // Padding(
                              //   padding: const EdgeInsets.only(top: 0),
                              //   child: Text("Recent search",
                              //       // "${AppLocalizations.of(context).lbl_recent_search}",
                              //       style: TextStyle(
                              //           fontFamily: fontRailwayRegular,
                              //           color: ColorConstants.appColor,
                              //           fontWeight: FontWeight.w200,
                              //           fontSize: 22)),
                              // ),
                              // _isDataLoaded
                              //     ? _recentSearchList != null &&
                              //             _recentSearchList.length > 0
                              //         ? ListView.builder(
                              //             itemCount: _recentSearchList.length,
                              //             shrinkWrap: true,
                              //             physics:
                              //                 NeverScrollableScrollPhysics(),
                              //             itemBuilder: (context, index) =>
                              //                 InkWell(
                              //               onTap: () {
                              //                 Navigator.of(context).push(
                              //                     NavigationUtils
                              //                         .createAnimatedRoute(
                              //                             1.0,
                              //                             SearchResultsScreen(
                              //                               a: widget.analytics,
                              //                               o: widget.observer,
                              //                               searchParams:
                              //                                   _recentSearchList[
                              //                                           index]
                              //                                       .keyword,
                              //                               searchScreen:
                              //                                   "search",
                              //                             )));
                              //               },
                              //               child: ListTile(
                              //                 leading: Icon(
                              //                   Icons.history_outlined,
                              //                 ),
                              //                 title: Text(
                              //                   _recentSearchList[index]
                              //                       .keyword,
                              //                   style: textTheme.bodyText1,
                              //                 ),
                              //                 trailing: Icon(
                              //                   Icons.chevron_right,
                              //                 ),
                              //               ),
                              //             ),
                              //           )
                              //         : Padding(
                              //             padding:
                              //                 const EdgeInsets.only(top: 5),
                              //             child: Text(
                              //                 "No gift? No problem! We love a challenge. What's next on your list?",
                              //                 style: TextStyle(
                              //                     fontFamily:
                              //                         fontRailwayRegular,
                              //                     color: ColorConstants
                              //                         .guidlinesGolden,
                              //                     fontWeight: FontWeight.w200,
                              //                     fontSize: 14)
                              //                 // '${AppLocalizations.of(context).txt_nothing_to_show}'
                              //                 ),
                              //           )
                              //     : _shimmer2(),

                              Padding(
                                padding: const EdgeInsets.only(left:10,top: 20),
                                child: Text("Trending products",
                                    // "${AppLocalizations.of(context).lbl_trending_products}",
                                    style: TextStyle(
                                        fontFamily: fontRalewayMedium,
                                        color: ColorConstants.newTextHeadingFooter,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 19)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: _isDataLoaded
                                    ? _productDetail != null &&
                                            _productDetail.similarProductList!
                                                    .length >
                                                0
                                        ? Container(
                                            margin: EdgeInsets.only(bottom: 1),
                                            height: _productDetail
                                                        .similarProductList !=
                                                    null
                                                ? 310
                                                : 0,
                                            child: _isDataLoaded &&
                                                    _productDetail
                                                            .similarProductList !=
                                                        null
                                                ? _productDetail.similarProductList !=
                                                            null &&
                                                        _productDetail
                                                                .similarProductList!
                                                                .length >
                                                            0
                                                    ? BundleOffersMenu(
                                                        analytics:
                                                            widget.analytics,
                                                        observer:
                                                            widget.observer,
                                                        categoryProductList:
                                                            _productDetail
                                                                .similarProductList!,
                                                        isHomeSelected: 'home',
                                                      )
                                                    : SizedBox()
                                                : _shimmer2(),
                                          )
                                        : Container(
                                            padding: EdgeInsets.only(left: 10,right: 10),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            color: ColorConstants.colorPageBackground,
                                            child: Text(
                                                "No gift? No problem! We love a challenge. What's next on your list?",
                                                style: TextStyle(
                                                    fontFamily:
                                                        fontRailwayRegular,
                                                    color: ColorConstants
                                                        .newAppColor,
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 14)
                                                // '${AppLocalizations.of(context).txt_nothing_to_show}'
                                                ),
                                          )
                                    : _shimmer1(),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Center(child: Text(global.locationMessage)),
              ),
            ),
          )),
    );
  }

  @override
  void initState() {
    super.initState();
    if(global.productSearchText !=null && global.productSearchText.length>0){
      Future.delayed(Duration.zero, () {
          Navigator.of(context).push(NavigationUtils.createAnimatedRoute(
                  1.0,
                  SearchResultsScreen(
                    a: widget.analytics,
                    o: widget.observer,
                    searchParams: global.productSearchText.trim(),
                    searchScreen: "search",
                  )));
      });
    }else{

    _init();
    }
    // if (global.nearStoreModel != null) {
    //   _init();
    // }
  }

  _getProductDetail(productId) async {
    try {
      bool isConnected = await br!.checkConnectivity();
      print("Product id---------${productId}");
      if (isConnected) {
        await apiHelper
            .getProductDetail(productId, global.isSubscription!)
            .then((result) async {
          if (result != null) {
            if (result.status == "1") {
              setState(() {
                _isDataLoaded = true;
                _productDetail = _productDetail;
                _productDetail = result.data;
                _productImages.clear();
                _productImages.add("${global.imageBaseUrl}" +
                    _productDetail.productDetail!.productImage!);
                for (int i = 0;
                    i < _productDetail.productDetail!.images!.length;
                    i++) {
                  _productImages.add("${global.imageBaseUrl}" +
                      _productDetail.productDetail!.images![i].image!);
                }
                FirebaseAnalyticsGA4().callAnalyticsProductDetail(
                    _productDetail.productDetail!.productId!,
                    _productDetail.productDetail!.productName!,
                    '',
                    _productDetail.productDetail!.varientId!,
                    '',
                    _productDetail.productDetail!.price!,
                    _productDetail.productDetail!.mrp!,
                    0);
              });
            } else {
              _productDetail = _productDetail;
            }
          }
        });
      } else {
        showNetworkErrorSnackBar1(_scaffoldKey!);
      }
    } catch (e) {
      print(
          "Exception -  product_description_screen.dart - _getProductDetail()aa:" +
              e.toString());
    }
  }


  _init() async {
    try {
      await _getProductDetail(productId);
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - search_screen.dart - _init():" + e.toString());
    }
  }

  _onRefresh() async {
    try {
      _isDataLoaded = false;
      setState(() {});
      await _init();
    } catch (e) {
      print("Exception - search_screen.dart - _onRefresh():" + e.toString());
    }
  }

  _shimmer1() {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          children: [
            SizedBox(
                height: 43,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 3.3,
                        height: 43,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                        )),
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 3.3,
                        height: 43,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                        )),
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 3.3,
                        height: 43,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                        ))
                  ],
                )),
            SizedBox(
                height: 43,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 3.3,
                        height: 43,
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                        )),
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 3.3,
                        height: 43,
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                        )),
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 3.3,
                        height: 43,
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                        ))
                  ],
                )),
          ],
        ));
  }

  _shimmer2() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: Card());
              })),
    );
  }

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
}
