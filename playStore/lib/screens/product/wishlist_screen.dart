import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/apiHelper.dart';
import 'package:byyu/models/businessLayer/global.dart';
// import 'package:byyu/models/varientModel.dart';
// import 'package:byyu/screens/auth/login_screen.dart';
import 'package:byyu/screens/home_screen.dart';
import 'package:byyu/screens/notification_screen.dart';
import 'package:byyu/screens/product/product_description_screen.dart';
//import 'package:byyu/screens/product/search_results_screen.dart';
import 'package:byyu/screens/search_screen.dart';
//import 'package:byyu/widgets/bottom_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

//import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
//import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
//import 'package:byyu/constants/image_constants.dart';
import 'package:byyu/controllers/cart_controller.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/categoryProductModel.dart';
import 'package:byyu/models/productFilterModel.dart';
import 'package:byyu/screens/cart_screen/cart_screen.dart';
import 'package:byyu/screens/filter_screen.dart';
//import 'package:byyu/widgets/products_menu.dart';

class WishListScreen extends BaseRoute {
  final Function? onAppDrawerButtonPressed;
  final Function? callbackHomescreenSetState;

  WishListScreen(
      {a, o, this.onAppDrawerButtonPressed, this.callbackHomescreenSetState})
      : super(a: a, o: o, r: 'WishListScreen');
  @override
  _WishListScreenState createState() => new _WishListScreenState(
      callbackHomescreenSetState: callbackHomescreenSetState);
}

class _WishListScreenState extends BaseRouteState {
  bool _isDataLoaded = false;
  int page = 1;
  bool _isRecordPending = true;
  bool _isMoreDataLoaded = false;
  bool _isDataAvailable = true;
  ProductFilter _productFilter = new ProductFilter();
  List<Product> _wishListProductList = [];
  GlobalKey<ScaffoldState>? _scaffoldKey;
  final CartController cartController = Get.put(CartController());
  ScrollController _scrollController = ScrollController();

  List<String> _productImages = [];
  List<Product> _productsList = [];
  int? productId;
  int? _selectedIndex;
  final Function? callbackHomescreenSetState;
  _WishListScreenState({this.callbackHomescreenSetState});
  @override
  Widget build(BuildContext context) {
    // TextTheme textTheme = Theme.of(context).textTheme;
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.blue, //or set color with: Color(0xFF0000FF)
    // ));
    return Scaffold(
        key: _scaffoldKey,
        // drawerEnableOpenDragGesture: true,
        // drawer: global.sideDrawer(context, widget.analytics, widget.observer),
        appBar: AppBar(
            backgroundColor: ColorConstants.white,
            automaticallyImplyLeading: false,
            leadingWidth: 46,
            actions: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SearchScreen(
                            a: widget.analytics,
                            o: widget.observer,
                          )));
                },
                child: Container(
                  margin: EdgeInsets.only(top: 7,bottom: 7),

                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: ColorConstants.colorPageBackground
                  ),
                  child: Icon(
                    Icons.search,
                    size: 24,
                    color: ColorConstants.allIconsBlack45,
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              global.currentUser.id != null
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
                        margin: EdgeInsets.only(top: 7,bottom: 7),

                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: ColorConstants.colorPageBackground
                      ),
                        child: Icon(
                          Icons.notifications_none,
                          size: 24,
                          color: ColorConstants.allIconsBlack45,
                        ),
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                width: 8,
              )
            ],
            centerTitle: false,
            title: Text(
              "Wishlist",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: ColorConstants.pureBlack,
                  fontFamily: fontRailwayRegular,
                  fontWeight: FontWeight.w200),
            )),
        body: Container(
            height: MediaQuery.of(context).size.height,
            child: Container(
              height: MediaQuery.of(context).size.height,
              color: ColorConstants.colorPageBackground,

              child: GetBuilder<CartController>(
                init: cartController,
                builder: (value) => RefreshIndicator(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    color: Theme.of(context).primaryColor,
                    onRefresh: () async {
                      _isDataLoaded = false;
                      _isRecordPending = true;
                      _wishListProductList.clear();
                      setState(() {});
                      await _init();
                    },
                    child: _isDataAvailable
                        ? _isDataLoaded
                            ? Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                      itemCount: _wishListProductList.length,
                                      shrinkWrap: false,
                                      scrollDirection: Axis.vertical,
                                      controller: _scrollController,
                                      itemBuilder: (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () {},
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProductDescriptionScreen(
                                                              a: widget.analytics,
                                                              o: widget.observer,
                                                              productId:
                                                                  _wishListProductList[
                                                                          index]
                                                                      .productId,
                                                              //isSubscription: categoryProductList[index].isSubscription,
                                  
                                                              isHomeSelected: "")));
                                            },
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(left: 8, right: 8),
                                              width:
                                                  MediaQuery.of(context).size.width,
                                              height:
                                                  MediaQuery.of(context).size.width /
                                                      2,
                                              //color: Colors.amber,
                                              child: GetBuilder<CartController>(
                                                init: cartController,
                                                builder: (value) => Card(
                                                    //margin: EdgeInsets.only(left: 8),
                                  
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10.0),
                                                        side: BorderSide(
                                                          color: ColorConstants
                                                              .greyfaint,
                                                          width: 0.5,
                                                        )),
                                                    elevation: 0,
                                                    child: Row(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(10),
                                                                  bottomLeft:
                                                                      Radius.circular(
                                                                          10)),
                                                          child: CachedNetworkImage(
                                                            width:
                                                                MediaQuery.of(context)
                                                                        .size
                                                                        .width /
                                                                    2.2,
                                                            height:
                                                                MediaQuery.of(context)
                                                                        .size
                                                                        .width /
                                                                    2,
                                                            fit: BoxFit.cover,
                                                            imageUrl: _wishListProductList[
                                                                                index]
                                                                            .thumbnail !=
                                                                        null &&
                                                                    _wishListProductList[
                                                                            index]
                                                                        .thumbnail!
                                                                        .isNotEmpty &&
                                                                    _wishListProductList[
                                                                                index]
                                                                            .thumbnail !=
                                                                        "N/A"
                                                                ? global.imageBaseUrl +
                                                                    _wishListProductList[
                                                                            index]
                                                                        .thumbnail!
                                                                : global.imageBaseUrl +
                                                                    _wishListProductList[
                                                                            index]
                                                                        .productImage!,
                                                            placeholder: (context,
                                                                    url) =>
                                                                Center(
                                                                    child:
                                                                        CircularProgressIndicator(
                                                              strokeWidth: 1.0,
                                                            )),
                                                            errorWidget: (context,
                                                                    url, error) =>
                                                                Container(
                                                                    child:
                                                                        Image.asset(
                                                              global.noImage,
                                                              fit: BoxFit.fill,
                                                              width: 175,
                                                              height: 210,
                                                              alignment:
                                                                  Alignment.center,
                                                            )),
                                                          ),
                                                        ),
                                                        Container(
                                                          width:
                                                              (MediaQuery.of(context)
                                                                          .size
                                                                          .width /
                                                                      2) -
                                                                  30,
                                                          margin: EdgeInsets.all(8),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "${_wishListProductList[index].productName}",
                                                                maxLines: 2,
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                                style: TextStyle(
                                                                    fontFamily: global
                                                                        .fontRailwayRegular,
                                                                    fontSize: 18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w200,
                                                                    color:
                                                                        ColorConstants
                                                                            .pureBlack),
                                                              ),
                                                              SizedBox(
                                                                height: 8,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            right: 8),
                                                                    child: Text(
                                                                      "AED ",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              global
                                                                                  .fontMontserratLight,
                                                                          fontSize:
                                                                              15,
                                                                          color: ColorConstants
                                                                              .appColor),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "${_wishListProductList[index].price}", //"${_wishListProductList[index].varient[0].basePrice}",
                                                                    style: TextStyle(
                                                                        fontFamily: global
                                                                            .fontMontserratLight,
                                                                        fontSize: 17,
                                                                        color: ColorConstants
                                                                            .appColor),
                                                                  ),
                                                                  _wishListProductList[index]
                                                                                  .varient !=
                                                                              null &&
                                                                          _wishListProductList[index]
                                                                                  .varient!
                                                                                  .length >
                                                                              0
                                                                      ? _wishListProductList[index]
                                                                                  .varient![
                                                                                      0]
                                                                                  .baseMrp
                                                                                  .toString()
                                                                                  .length >
                                                                              0
                                                                          ? Stack(
                                                                              children: [
                                                                                  Container(
                                                                                    margin: EdgeInsets.only(left: 5),
                                                                                    padding: EdgeInsets.only(top: 2, bottom: 2),
                                                                                    child: Text(
                                                                                      "${_wishListProductList[index].baseMrp}", //"${_wishListProductList[index].varient[0].baseMrp}",
                                                                                      style: TextStyle(fontFamily: global.fontMontserratLight, fontSize: 13, decoration: TextDecoration.lineThrough, color: Colors.grey),
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    margin: EdgeInsets.only(left: 5),
                                                                                    alignment: Alignment.center,
                                                                                    // decoration: BoxDecoration(
                                                                                    //     color: Colors.white.withOpacity(0.6),
                                                                                    //     borderRadius: BorderRadius.circular(5)),
                                                                                    //padding: const EdgeInsets.all(5),
                                                                                    child: Center(
                                                                                      child: Transform.rotate(
                                                                                        angle: 6,
                                                                                        child: Text(
                                                                                          "----",
                                                                                          // '${AppLocalizations.of(context).txt_out_of_stock}',
                                                                                          textAlign: TextAlign.center,
                                                                                          maxLines: 2,
                                                                                          style: TextStyle(fontSize: 13, fontFamily: global.fontRailwayRegular),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ])
                                                                          : SizedBox()
                                                                      : SizedBox(),
                                                                  _wishListProductList[index]
                                                                                  .varient !=
                                                                              null &&
                                                                          _wishListProductList[index]
                                                                                  .varient!
                                                                                  .length >
                                                                              0
                                                                      ? _wishListProductList[index].varient![0].discountper.toString().length >
                                                                                  0 &&
                                                                              _wishListProductList[index].varient![0].baseMrp.toString().length >
                                                                                  0
                                                                          ? Container(
                                                                              margin: EdgeInsets.only(
                                                                                  left:
                                                                                      5),
                                                                              child:
                                                                                  Text(
                                                                                _wishListProductList[index].varient![0].discountper.toString().startsWith("-")
                                                                                    ? "${_wishListProductList[index].varient![0].discountper.toString().substring(1)}% off"
                                                                                    : "${_wishListProductList[index].varient![0].discountper}% off",
                                                                                style: TextStyle(
                                                                                    fontFamily: global.fontMontserratLight,
                                                                                    fontSize: 14,
                                                                                    color: ColorConstants.appColor),
                                                                              ),
                                                                            )
                                                                          : SizedBox()
                                                                      : SizedBox()
                                                                ],
                                                              ),
                                                              Spacer(),
                                                              Container(
                                                                height: (MediaQuery.of(
                                                                                context)
                                                                            .size
                                                                            .width /
                                                                        3) -
                                                                    30,
                                                                child: Align(
                                                                  alignment: Alignment
                                                                      .bottomCenter,
                                                                  child: Container(
                                                                    //height: 40,
                                                                    // decoration: BoxDecoration(
                                                                    //     border: Border.all(
                                                                    //         color:
                                                                    //             ColorConstants.appColor,
                                                                    //         width: 1),
                                                                    //     borderRadius:
                                                                    //         BorderRadius.circular(10)),
                                                                    child: Row(
                                                                      // Previous commented
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () {
                                                                              // callAddToCartApi(
                                                                              //     _wishListProductList[
                                                                              //             index]
                                                                              //         .varientId,
                                                                              //     index);
                                                                              Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (context) => ProductDescriptionScreen(
                                                                                          a: widget.analytics,
                                                                                          o: widget.observer,
                                                                                          productId: _wishListProductList[index].productId,
                                                                                          //isSubscription: categoryProductList[index].isSubscription,
                                  
                                                                                          isHomeSelected: "")));
                                                                              // Get.offAll(() =>
                                                                              //     HomeScreen(
                                                                              //       a: widget
                                                                              //           .analytics,
                                                                              //       o: widget
                                                                              //           .observer,
                                                                              //       selectedIndex:
                                                                              //           2,
                                                                              //     ));
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              width:
                                                                                  120,
                                                                              decoration: BoxDecoration(
                                                                                  color:
                                                                                      ColorConstants.lightGreen,
                                                                                  borderRadius: BorderRadius.circular(10)),
                                                                              padding: EdgeInsets.only(
                                                                                  top:
                                                                                      8,
                                                                                  bottom:
                                                                                      8,
                                                                                  left:
                                                                                      5,
                                                                                  right:
                                                                                      5),
                                                                              margin: EdgeInsets.only(
                                                                                  right:
                                                                                      0.1),
                                                                              // child:
                                                                              //     Icon(
                                                                              //   MdiIcons
                                                                              //       .cart,
                                                                              //   color: ColorConstants
                                                                              //       .white,
                                                                              // ),
                                                                              child:
                                                                                  Text(
                                                                                "View Detail",
                                                                                textAlign:
                                                                                    TextAlign.center,
                                                                                style:
                                                                                    TextStyle(
                                                                                  fontFamily:
                                                                                      fontMontserratMedium,
                                                                                  fontWeight:
                                                                                      FontWeight.bold,
                                                                                  fontSize:
                                                                                      14,
                                                                                  color:
                                                                                      ColorConstants.white,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                          // Aayush : Previous code
                                                                          //                                                                     onTap: () {
                                                                          // _addRemoveWishList(
                                                                          //     _wishListProductList[index]
                                                                          //         .varientId!,
                                                                          //     index);
                                                                          // setState(
                                                                          //     () {});
                                                                          //                                                                     },
                                                                          onTap: () {
                                                                            _addRemoveWishList(
                                                                                _wishListProductList[index]
                                                                                    .varientId!,
                                                                                index);
                                                                            setState(
                                                                                () {});
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            // height: //A
                                                                            //     28, //A
                                  
                                                                            // width: 10,
                                                                            decoration: BoxDecoration(
                                                                                color: ColorConstants
                                                                                    .appColor,
                                                                                borderRadius:
                                                                                    BorderRadius.circular(10)),
                                                                            padding: EdgeInsets.only(
                                                                                left:
                                                                                    5,
                                                                                right:
                                                                                    5,
                                                                                top:
                                                                                    3,
                                                                                bottom:
                                                                                    3),
                                                                            margin: EdgeInsets.only(
                                                                                left:
                                                                                    5), // 8
                                                                            child:
                                                                                Icon(
                                                                              MdiIcons
                                                                                  .delete,
                                                                              color: ColorConstants
                                                                                  .white,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    )),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                ),
                                _isMoreDataLoaded
                                                  ? Center(
                                                      child: CircularProgressIndicator(
                                                        backgroundColor: Colors.white,
                                                        strokeWidth: 1,
                                                      ),
                                                    )
                                                  : SizedBox()                              
                              
                              ],
                            )
                            : Center(
                                child: CircularProgressIndicator(),
                              )
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            color: ColorConstants.colorPageBackground,

                            
                            child: Center(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Text(""),
                                  ),
                                  Text(
                                    'No wishes here! \n"Time to sprinkle some gift magic"',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: global.fontMontserratLight,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w200,
                                        color: ColorConstants.guidlinesGolden),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => HomeScreen(
                                                    a: widget.analytics,
                                                    o: widget.observer,
                                                    selectedIndex: 0,
                                                  )));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      width: MediaQuery.of(context).size.width -
                                          50,
                                      decoration: BoxDecoration(
                                          color: ColorConstants.appColor,
                                          border: Border.all(
                                              color: ColorConstants.appColor,
                                              width: 0.5),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        "GIFT NOW",
                                        textAlign: TextAlign.center,
                                        // "${AppLocalizations.of(context).tle_add_new_address} ",
                                        style: TextStyle(
                                            fontFamily: fontMontserratMedium,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: ColorConstants.white,
                                            letterSpacing: 1),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(""),
                                  ),
                                ],
                              ),
                            ),
                          )),
              ),
            )));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

 
  _getWishListProduct() async {
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        if (_isRecordPending) {
          setState(() {
            _isMoreDataLoaded = true;
          });
          if (_wishListProductList.isEmpty) {
            page = 1;
          } else {
            page++;
          }
        
        await apiHelper
            .getWishListProduct(page, _productFilter, 1)
            .then((result) async {
          if (result != null) {
            if (result.status == "1") {
              List<Product> _tList = result.data;
              if (_tList.isEmpty) {
                _isDataAvailable = false;
                _isRecordPending = false;
              }
              _isDataLoaded = true;
              if (page == 1) {
              _wishListProductList.clear();
            }
            if (_tList.isEmpty) {
              _isRecordPending = false;
            }
              _wishListProductList.addAll(_tList);
              global.wishlistCount = _wishListProductList.length;
              callbackHomescreenSetState!();

              setState(() {
                _isMoreDataLoaded = false;
              });
            } else {
             print("Niks-----------11111111-------_>>>>>>>${_wishListProductList.length}>>>>");

              if(_wishListProductList == null || _wishListProductList.length==0){
              _isDataAvailable = false;
              global.wishlistCount=0;
              callbackHomescreenSetState!();
              }else{
                global.wishlistCount=_wishListProductList.length;
              callbackHomescreenSetState!();
              }
              
                _isRecordPending = false;
                _isMoreDataLoaded=false;
                setState(() { });
            }
          } else {
            _isDataAvailable = false;
            print("Niks-------2222222-----------_>>>>>>>>>>>");

            _isMoreDataLoaded = false;
            _isRecordPending = false;
            setState(() { });
          }
        });
      }
      // _productFilter.maxPriceValue = _wishListProductList.length > 0
      //     ? _wishListProductList[0].maxprice
      //     : 0;
      }
      else {
                        print("Niks------333333------------_>>>>>>>>>>>");

        _isDataAvailable = false;
            _isMoreDataLoaded = false;
        // showNetworkErrorSnackBar(_scaffoldKey!);
      }
      
    } catch (e) {
      _isDataAvailable = false;
            _isMoreDataLoaded = false;
      print("Exception - wishlist_screen.dart - _getWishListProduct():" +
          e.toString());
    }
  }

  _init() async {
    try {
      await _getWishListProduct();
      _scrollController = ScrollController()..addListener(_scrollListener);

      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - wishlist_screen.dart - _init():" + e.toString());
    }
  }

  double boundaryOffset = 0.5;
  int currentpage = 1;
  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent * 0.5 &&
        !_isMoreDataLoaded) {
      bool isTop = _scrollController.position.pixels == 0.0;
      if (isTop) {
        print('At the top');
      } else {
        boundaryOffset = 1 - 1 / (currentpage * 2);
_getWishListProduct();
      
      }
    }
    // if (_scrollController1.position.atEdge) {
    //   bool isTop = _scrollController1.position.pixels == 0;
    //   if (isTop) {
    //     print('At the top');
    //   } else {

    //   }
    // }
  }

  Widget _productShimmer() {
    // AAAC useless code
    try {
      return ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Column(
                children: [
                  SizedBox(
                    height: 110,
                    width: MediaQuery.of(context).size.width,
                    child: Card(),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      print("Exception - wishlist_screen.dart - _productShimmer():" +
          e.toString());
      return SizedBox();
    }
  }

  APIHelper apiHelper = APIHelper();
  _addRemoveWishList(int varientId, int index) async {
    bool _isAddedSuccesFully = false;
    try {
      showOnlyLoaderDialog();
      await apiHelper.addRemoveWishList(varientId).then((result) async {
        if (result != null) {
          print("Wishlist result status${result.status}");
          if (result.status == "1" || result.status == "2") {
            if (result.status == "2") {
              _wishListProductList.clear();
              setState(() {});
              await _init();
            }
            //_isAddedSuccesFully = true;
            Navigator.pop(context);
          } else {
            _isAddedSuccesFully = false;
            Navigator.pop(context);
            showSnackBar(
                snackBarMessage:
                    'Please try again after some time.'); //'${AppLocalizations.of(context).txt_please_try_again_after_sometime} ');
          }
        }
      });
      return _isAddedSuccesFully;
    } catch (e) {
      print("Exception - bundle_offers_menu.dart - addRemoveWishList():" +
          e.toString());
      return _isAddedSuccesFully;
    }
  }
}
