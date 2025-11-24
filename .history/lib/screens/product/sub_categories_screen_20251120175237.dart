//import 'dart:async';

//import 'dart:ffi';
// import 'dart:js_util';

import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/models/categoryListModel.dart';
import 'package:byyu/screens/filter_screen.dart';
import 'package:byyu/screens/home_screen.dart';
import 'package:byyu/screens/search_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
//import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';

// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
//import 'package:provider/provider.dart';
//
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:byyu/constants/color_constants.dart';
//import 'package:byyu/constants/image_constants.dart';
import 'package:byyu/controllers/cart_controller.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/categoryProductModel.dart';
import 'package:byyu/models/homeScreenDataModel.dart';
import 'package:byyu/models/productFilterModel.dart';
import 'package:byyu/models/subCategoryModel.dart';
// import 'package:byyu/screens/cart_screen/cart_screen.dart';
// import 'package:byyu/screens/auth/login_screen.dart';
// import 'package:byyu/screens/filter_screen.dart';
// import 'package:byyu/screens/product/product_description_screen.dart';
// import 'package:byyu/screens/product/search_results_screen.dart';
// import 'package:byyu/utils/navigation_utils.dart';
// import 'package:byyu/widgets/cart_item_count_button.dart';
import 'package:byyu/widgets/products_menu.dart';
//import 'package:byyu/widgets/select_category_card.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;

class SubCategoriesScreen extends BaseRoute {
  final String? screenHeading;

  final int? categoryId;
  bool? isSubcategory;
  bool? isEventProducts;
  bool? aayush;
  @required
  int? subscriptionProduct;
  bool? showCategories;
  int? minAge;
  int? maxAge;
  int? recipientId;

  SubCategoriesScreen({
    a,
    o,
    this.screenHeading,
    this.categoryId,
    this.isSubcategory,
    this.isEventProducts,
    this.showCategories,
    this.minAge,
    this.maxAge,
    this.recipientId,
  }) : super(a: a, o: o, r: 'SubCategoriesScreen');

  @override
  _SubCategoriesScreenState createState() => _SubCategoriesScreenState(
      categoryId: categoryId,
      screenHeading: screenHeading,
      isEventProducts: isEventProducts,
      showCategories: showCategories,
      isSubcategory: isSubcategory);
}

class _SubCategoriesScreenState extends BaseRouteState {
  int? categoryId;
  int? _selectedIndex;
  int? subscriptionProduct;
  bool _isDataLoaded = false;
  bool _isProductLoaded = false;
  bool _issubCatDataLoaded = false;
  bool _isDataAvailable = true;
  int? screenId;
  String? screenHeading;
  bool _isRecordPending = true;
  bool _isMoreDataLoaded = false;
  bool? showCategories;
  ScrollController _scrollController1 = ScrollController();
  ScrollController _scrollController = ScrollController();
  bool isSorted = false;
  int selectedCardID = 0;
  String selectedSubCat = "";
  int page = 1;
  int isSelectedCat = 0;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Product> _trendingSearchBrand = [];
  bool? isSubcategory;
  bool? isEventProducts;
  int? sortSelectedValue;
  int? subCateSelectIndex;
  int? selectedCatID;
  int? categoriesSelectedIndex;
  bool isfilterApplied = false;
  List<CategoryList> _categoryList = [];
  List<SubCateeList> _subCategoryList = [];

  _SubCategoriesScreenState(
      {this.categoryId,
      this.screenHeading,
      this.isSubcategory,
      this.showCategories,
      this.isEventProducts});

  @override
  bool? ischecked = false;
  int? _value = 1; // for sort by radio button
  int isIndexSelected = 0;

  Widget build(BuildContext context) {
    // TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(bottom: 10), // <-- padding from bottom
      //   child: FloatingActionButton(
      //     onPressed: () {
      //       print("Filter FAB tapped");
      //     },
      //     backgroundColor: ColorConstants.newAppColor,
      //     elevation: 3,
      //     child: const Icon(
      //       Icons.filter_list,
      //       size: 22,
      //       color: Colors.white,
      //     ),
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      backgroundColor: global.whitebackground,
      appBar: AppBar(
        backgroundColor: ColorConstants.white,
        centerTitle: false,
        title: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreen(
                          a: widget.analytics,
                          o: widget.observer,
                          selectedIndex: 0,
                        )));
          },
          child: Image.asset(
            "assets/images/new_logo.png",
            fit: BoxFit.contain,
            height: 25,
            alignment: Alignment.center,
          ),
        ),
        leading: BackButton(
            onPressed: () {
              // Navigator.pop(context);
              if (global.routingCategoryID != 0 || global.routingEventID != 0) {
                global.routingCategoryID = 0;
                global.routingEventID = 0;
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => HomeScreen(
                          a: widget.analytics,
                          o: widget.observer,
                          selectedIndex: 0,
                        )));
              } else {
                Navigator.of(context).pop();
              }
            },
            //icon: Icon(Icons.keyboard_arrow_left),
            color: ColorConstants.newAppColor),
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SearchScreen(
                        a: widget.analytics,
                        o: widget.observer,
                        fromBottomNvigation: false,
                      )));
            },
            child: Padding(
              padding: EdgeInsets.only(top: 18, bottom: 18),
              child: Image.asset(
                "assets/images/search.png",
                fit: BoxFit.contain,
                height: 25,
                alignment: Alignment.center,
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          // Center(
          //   child: InkWell(
          //     onTap: () {
          //       showFilterBottomSheet();
          //     },
          //     child: Icon(
          //       Icons.filter_alt_outlined,
          //       size: 25,
          //       color: ColorConstants.allIconsBlack45,
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   width: 8,
          // ),
          Stack(
            children: [
              Center(
                child: InkWell(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => HomeScreen(
                    //           a: widget.analytics,
                    //           o: widget.observer,
                    //           selectedIndex: 2,
                    //         )));
                    global.showCartBottomSheet(context, widget.analytics,
                        widget.observer, callProductList);
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 15, bottom: 15, right: 10),
                    child: Image.asset(
                      'assets/images/ic_nav_cart.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              global.cartCount != 0 && global.cartCount <= 10
                  ? new Positioned(
                      right: 6,
                      top: 10,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: ColorConstants.newAppColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          '${global.cartCount}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontFamily: fontOufitMedium,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : new Container()
            ],
          ),
          SizedBox(
            width: 8,
          ),
        ],
      ),
      // floatingActionButton: Padding(
      //     padding: const EdgeInsets.only(bottom: 20.0, right: 20),
      //     child: Container(
      //       height: 50,
      //       width: 50,
      //       decoration: BoxDecoration(
      //         color: global.indigoColor,
      //         borderRadius: BorderRadius.circular(30.0),
      //       ),
      //       child: IconButton(
      //         icon: Icon(
      //           Icons.filter_alt,
      //           color: global.white,
      //           size: 30,
      //         ),
      //       ),
      //     )),
      body: Padding(
          padding: const EdgeInsets.only(left: 1, right: 1),
          child: _isDataLoaded
              ? Column(
                  children: [
                    // isfilterApplied
                    //     ?
                    // !global.isEventProduct
                    _issubCatDataLoaded
                        ? categoriesSelectedIndex != null &&
                                categoriesSelectedIndex! >= 0 &&
                                _subCategoryList != null &&
                                _subCategoryList.length > 0
                            ? Container(
                                color: ColorConstants.colorHomePageSectiondim,
                                height: MediaQuery.of(context).size.width / 5.2,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    categoriesSelectedIndex != null &&
                                            categoriesSelectedIndex! >= 0
                                        ? SizedBox(
                                            height: 10,
                                          )
                                        : SizedBox(),
                                    categoriesSelectedIndex != null &&
                                            categoriesSelectedIndex! >= 0
                                        ? Container(
                                            padding: EdgeInsets.only(
                                                left: 8, right: 8),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                _categoryList[
                                                        categoriesSelectedIndex!]
                                                    .title!,
                                                style: TextStyle(
                                                    fontFamily: global
                                                        .fontRailwayRegular,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13,
                                                    color: ColorConstants
                                                        .newTextHeadingFooter),
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                    // categoriesSelectedIndex!=null && categoriesSelectedIndex!>=0?Container(
                                    //   height: ColorConstants.filterdividerheight,
                                    //   width: ColorConstants.filterdividerWidth,
                                    //   color: ColorConstants.filterDivderColor,
                                    // ):SizedBox(),
                                    categoriesSelectedIndex != null &&
                                            categoriesSelectedIndex! >= 0
                                        ? SizedBox(
                                            width: 10,
                                          )
                                        : SizedBox(),
                                    Expanded(
                                      child: Visibility(
                                        visible: _subCategoryList != null &&
                                            _subCategoryList.length > 0,
                                        child: Container(
                                          color: Colors.transparent,
                                          padding: EdgeInsets.only(
                                              top: 1, bottom: 5),
                                          child: ListView.builder(
                                            itemCount: _subCategoryList.length,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return Container(

                                                  // width: 65,
                                                  margin: EdgeInsets.all(5),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      subCateSelectIndex =
                                                          index;
                                                      _productsList.clear();
                                                      global.isSubCatSelected =
                                                          true;
                                                      if (!_isRecordPending) {
                                                        _isRecordPending = true;
                                                      }

                                                      // _getSubCategoryProduct(
                                                      //     _subCategoryList[index]
                                                      //         .catId!);
                                                      if (!global
                                                          .isEventProduct) {
                                                        global.homeSelectedCatID =
                                                            _subCategoryList[
                                                                    index]
                                                                .catId!;
                                                        if (_productsList !=
                                                                null &&
                                                            _productsList
                                                                    .length >
                                                                0) {
                                                          _productsList.clear();
                                                          // _isDataLoaded =
                                                          //     false,
                                                        }
                                                        if (!global
                                                            .isSubCatSelected) {
                                                          // print(
                                                          //     "This is category id---- ${categoryId}");
                                                          _getCategoryProduct(global
                                                              .homeSelectedCatID); // _init();
                                                        } else {
                                                          // print(
                                                          //     "This is Subcategory id---- ${categoryId}");
                                                          _getSubCategoryProduct(
                                                              global
                                                                  .homeSelectedCatID);
                                                        }
                                                        ;
                                                        isSelectedCat = 0;
                                                      } else {
                                                        selectedCatID =
                                                            _subCategoryList[
                                                                    index]
                                                                .catId!;
                                                        // print(
                                                        //     "niks This is _getEventProduct cat id---- ${categoryId}");
                                                        _getEventProduct(global
                                                            .homeSelectedCatID);
                                                      }
                                                      setState(() {});
                                                    },
                                                    child: Column(
                                                      children: [
                                                        // Container(
                                                        //   width: 60,
                                                        //   height: 60,
                                                        //   color: Colors.transparent,
                                                        //   child: Column(
                                                        //     children: [
                                                        //       ClipRRect(
                                                        //         borderRadius:
                                                        //             BorderRadius.circular(
                                                        //                 8),
                                                        //         child: Container(
                                                        //           // decoration: BoxDecoration(
                                                        //           //   borderRadius:
                                                        //           //       BorderRadius.circular(
                                                        //           //           10),
                                                        //           //   border: Border.all(
                                                        //           //       color:
                                                        //           //           subCateSelectIndex ==
                                                        //           //                   index
                                                        //           //               ? ColorConstants
                                                        //           //                   .appColor
                                                        //           //               : Colors
                                                        //           //                   .transparent),
                                                        //           // ),
                                                        //           width: 60,
                                                        //           height: 60,
                                                        //           child:
                                                        //               CachedNetworkImage(
                                                        //             height: 40,
                                                        //             width: 40,
                                                        //             imageUrl: imageBaseUrl +
                                                        //                 _subCategoryList[
                                                        //                         index]
                                                        //                     .image!,
                                                        //             imageBuilder: (context,
                                                        //                     imageProvider) =>
                                                        //                 Container(
                                                        //               height:
                                                        //                   double.infinity,
                                                        //               width:
                                                        //                   double.infinity,
                                                        //               decoration:
                                                        //                   BoxDecoration(
                                                        //                 // borderRadius: BorderRadius.circular(10),
                                                        //                 image:
                                                        //                     DecorationImage(
                                                        //                   image:
                                                        //                       imageProvider,
                                                        //                   fit:
                                                        //                       BoxFit.fill,
                                                        //                   alignment:
                                                        //                       Alignment
                                                        //                           .center,
                                                        //                 ),
                                                        //               ),
                                                        //             ),
                                                        //             placeholder: (context,
                                                        //                     url) =>
                                                        //                 Center(
                                                        //                     child:
                                                        //                         CircularProgressIndicator()),
                                                        //             errorWidget: (context,
                                                        //                     url, error) =>
                                                        //                 Container(
                                                        //               decoration:
                                                        //                   BoxDecoration(
                                                        //                 // borderRadius: BorderRadius.circular(15),
                                                        //                 image:
                                                        //                     DecorationImage(
                                                        //                   image: AssetImage(
                                                        //                       global
                                                        //                           .catNoImage),
                                                        //                   fit: BoxFit
                                                        //                       .contain,
                                                        //                 ),
                                                        //               ),
                                                        //             ),
                                                        //           ),
                                                        //         ),
                                                        //       ),
                                                        //     ],
                                                        //   ),
                                                        // ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 4),
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
                                                                        right:
                                                                            1),
                                                                child: subCateSelectIndex ==
                                                                        index
                                                                    ? Container(
                                                                        // width: 65,
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                5,
                                                                            bottom:
                                                                                5,
                                                                            left:
                                                                                8,
                                                                            right:
                                                                                8),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                ColorConstants.appColor,
                                                                            border: Border.all(color: ColorConstants.appColor, width: 0.5),
                                                                            borderRadius: BorderRadius.circular(8)),
                                                                        child:
                                                                            Text(
                                                                          "${_subCategoryList[index].title}",
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: TextStyle(
                                                                              fontFamily: global.fontRailwayRegular,
                                                                              fontWeight: FontWeight.w200,
                                                                              fontSize: 12,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              color: subCateSelectIndex == index ? Colors.white : ColorConstants.newTextHeadingFooter),
                                                                        ),
                                                                      )
                                                                    : Container(
                                                                        // else  condition

                                                                        // width: 55,
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                5,
                                                                            bottom:
                                                                                5,
                                                                            left:
                                                                                8,
                                                                            right:
                                                                                8),
                                                                        decoration: BoxDecoration(
                                                                            border:
                                                                                Border.all(color: ColorConstants.colorAllHomeTitle, width: 0.5),
                                                                            borderRadius: BorderRadius.circular(8)),
                                                                        child:
                                                                            Text(
                                                                          "${_subCategoryList[index].title}",
                                                                          maxLines:
                                                                              1,
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: TextStyle(
                                                                              fontFamily: global.fontRailwayRegular,
                                                                              fontWeight: FontWeight.w200,
                                                                              fontSize: 12,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              color: subCateSelectIndex == index ? ColorConstants.appColor : ColorConstants.newTextHeadingFooter),
                                                                        ),
                                                                      ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ));
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox()
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width / 5.5,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),

                    Container(
                      height: MediaQuery.of(context).size.width / 7.5,
                      color: ColorConstants.white,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Filters",
                                  style: TextStyle(
                                      fontFamily: global.fontRailwayRegular,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: ColorConstants.pureBlack),
                                ),
                              ),
                            ),
                            // Container(
                            //   padding: EdgeInsets.all(10),
                            //   child: Align(
                            //     alignment: Alignment.center,
                            //     child: Icon(
                            //       Icons.filter_alt_outlined,
                            //       size: 25,
                            //     ),
                            //   ),
                            // ),

                            Container(
                              height: ColorConstants.filterdividerheight,
                              width: ColorConstants.filterdividerWidth,
                              color: ColorConstants.filterDivderColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                height: 25,
                                child: ListView.builder(
                                    controller: _scrollController,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemCount: appliedFilter.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) => InkWell(
                                          onTap: () {
                                            if (!appliedFilter[index]
                                                .isFilterValue!) {
                                              showModalBottomSheet(
                                                // isDismissible: false,
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    topRight:
                                                        Radius.circular(20),
                                                  ),
                                                ),
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return FilterCustomSheet(
                                                    showFilters: _productFilter,
                                                    filterTypeIndex: index,
                                                  );
                                                },
                                              ).then((value) => {
                                                    if (value != null)
                                                      {
                                                        _productFilter = value,
                                                        // print(value),
                                                        appliedFilter.clear(),
                                                        appliedFilter.add(
                                                            new AppliedFilterList(
                                                                type: "0",
                                                                name: "Price",
                                                                isFilterValue:
                                                                    false)),
                                                        appliedFilter.add(
                                                            new AppliedFilterList(
                                                                type: "0",
                                                                name:
                                                                    "Discount",
                                                                isFilterValue:
                                                                    false)),
                                                        appliedFilter.add(
                                                            new AppliedFilterList(
                                                                type: "0",
                                                                name: "Sort",
                                                                isFilterValue:
                                                                    false)),
                                                        if (!global
                                                            .isEventProduct)
                                                          {
                                                            appliedFilter.add(
                                                                new AppliedFilterList(
                                                                    type: "0",
                                                                    name:
                                                                        "Occasion",
                                                                    isFilterValue:
                                                                        false)),
                                                          },
                                                        if (_productFilter
                                                                    .filterPriceValue !=
                                                                null &&
                                                            _productFilter
                                                                    .filterPriceValue!
                                                                    .length >
                                                                0)
                                                          {
                                                            appliedFilter.add(
                                                                new AppliedFilterList(
                                                                    type: "1",
                                                                    name: _productFilter
                                                                        .filterPriceValue!,
                                                                    isFilterValue:
                                                                        true)),
                                                          },
                                                        if (_productFilter
                                                                    .filterDiscountValue !=
                                                                null &&
                                                            _productFilter
                                                                    .filterDiscountValue!
                                                                    .length >
                                                                0)
                                                          {
                                                            appliedFilter.add(
                                                                new AppliedFilterList(
                                                                    type: "2",
                                                                    name: _productFilter
                                                                        .filterDiscountValue!,
                                                                    isFilterValue:
                                                                        true)),
                                                          },
                                                        if (_productFilter
                                                                    .filterSortID !=
                                                                null &&
                                                            _productFilter
                                                                    .filterSortID!
                                                                    .length >
                                                                0)
                                                          {
                                                            appliedFilter.add(
                                                                new AppliedFilterList(
                                                                    type: "3",
                                                                    name: _productFilter
                                                                        .filterSortValue!,
                                                                    isFilterValue:
                                                                        true)),
                                                          },
                                                        if (_productFilter
                                                                    .filterOcassionValue !=
                                                                null &&
                                                            _productFilter
                                                                    .filterOcassionValue!
                                                                    .length >
                                                                0)
                                                          {
                                                            appliedFilter.add(
                                                                new AppliedFilterList(
                                                                    type: "4",
                                                                    name: _productFilter
                                                                        .filterOcassionValue!,
                                                                    isFilterValue:
                                                                        true)),
                                                          },
                                                        if (_productsList !=
                                                                null &&
                                                            _productsList
                                                                    .length >
                                                                0)
                                                          {
                                                            _productsList
                                                                .clear(),
                                                            // _isDataLoaded =
                                                            //     false,
                                                          },
                                                        if (!global
                                                            .isEventProduct)
                                                          {
                                                            // if (_productsList !=
                                                            //         null &&
                                                            //     _productsList
                                                            //             .length >
                                                            //         0)
                                                            //   {
                                                            //     _productsList
                                                            //         .clear(),
                                                            //     // _isDataLoaded =
                                                            //     //     false,
                                                            //   },
                                                            if (!global
                                                                .isSubCatSelected)
                                                              {
                                                                // print(
                                                                //     "This is category id---- ${categoryId}"),
                                                                _getCategoryProduct(
                                                                    global
                                                                        .homeSelectedCatID), // _init();
                                                              }
                                                            else
                                                              {
                                                                // print(
                                                                //     "This is Subcategory id---- ${categoryId}"),
                                                                _getSubCategoryProduct(
                                                                    global
                                                                        .homeSelectedCatID),
                                                              },
                                                            isSelectedCat = 0,
                                                          }
                                                        else
                                                          {
                                                            // print(
                                                            //     "niks This is _getEventProduct cat id---- ${categoryId}"),
                                                            _getEventProduct(global
                                                                .homeSelectedCatID),
                                                          },
                                                      }
                                                    else
                                                      {
                                                        print(
                                                            "Clear all or dismissed"),
                                                      }
                                                  });
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                left: 8, right: 8),
                                            margin: EdgeInsets.only(right: 10),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: ColorConstants
                                                        .colorAllHomeTitle,
                                                    width: 0.5),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Row(
                                              children: [
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    appliedFilter[index].name!,
                                                    style: TextStyle(
                                                        fontFamily: global
                                                            .fontRailwayRegular,
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        fontSize: 12,
                                                        color: ColorConstants
                                                            .pureBlack),
                                                  ),
                                                ),
                                                appliedFilter[index]
                                                        .isFilterValue!
                                                    ? SizedBox(
                                                        width: 8,
                                                      )
                                                    : SizedBox(),
                                                appliedFilter[index]
                                                        .isFilterValue!
                                                    ? InkWell(
                                                        onTap: () {
                                                          if (appliedFilter[
                                                                      index]
                                                                  .type ==
                                                              "1") {
                                                            _productFilter
                                                                .filterPriceID = "";
                                                            _productFilter
                                                                .filterPriceValue = "";
                                                          }
                                                          if (appliedFilter[
                                                                      index]
                                                                  .type ==
                                                              "2") {
                                                            _productFilter
                                                                .filterDiscountID = "";
                                                            _productFilter
                                                                .filterDiscountValue = "";
                                                          }
                                                          if (appliedFilter[
                                                                      index]
                                                                  .type ==
                                                              "3") {
                                                            _productFilter
                                                                .filterSortID = "";
                                                            _productFilter
                                                                .filterSortValue = "";
                                                          }
                                                          if (appliedFilter[
                                                                      index]
                                                                  .type ==
                                                              "4") {
                                                            _productFilter
                                                                .filterOcassionID = "";
                                                            _productFilter
                                                                .filterOcassionValue = "";
                                                          }
                                                          if (_productsList !=
                                                                  null &&
                                                              _productsList
                                                                      .length >
                                                                  0) {
                                                            _productsList
                                                                .clear();
                                                            // _isDataLoaded =
                                                            //     false;
                                                          }
                                                          appliedFilter
                                                              .removeAt(index);
                                                          // if (appliedFilter
                                                          //         .length ==
                                                          //     0) {
                                                          //   isfilterApplied =
                                                          //       false;
                                                          //   setState(() {});
                                                          // }
                                                          if (!global
                                                              .isEventProduct) {
                                                            if (_productsList !=
                                                                    null &&
                                                                _productsList
                                                                        .length >
                                                                    0) {
                                                              _productsList
                                                                  .clear();
                                                              // _isDataLoaded =
                                                              //     false;
                                                            }
                                                            if (!global
                                                                .isSubCatSelected) {
                                                              // print(
                                                              //     "This is category id---- ${categoryId}");
                                                              _getCategoryProduct(
                                                                  global
                                                                      .homeSelectedCatID); // _init();
                                                            } else {
                                                              // print(
                                                              //     "This is Subcategory id---- ${categoryId}");
                                                              _getSubCategoryProduct(
                                                                  global
                                                                      .homeSelectedCatID);
                                                            }
                                                            isSelectedCat = 0;
                                                          } else {
                                                            // print(
                                                            //     "niks This is _getEventProduct cat id---- ${categoryId}");
                                                            _getEventProduct(global
                                                                .homeSelectedCatID);
                                                          }
                                                        },
                                                        child: Icon(
                                                          Icons.cancel,
                                                          size: 20,
                                                          color: ColorConstants
                                                              .newAppColor,
                                                        ),
                                                      )
                                                    : SizedBox(),
                                              ],
                                            ),
                                          ),
                                        )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: Row(
                        children: [
                          Visibility(
                            visible: showCategories! &&
                                _categoryList != null &&
                                _categoryList.length > 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width / 5,
                              child: ListView.builder(
                                itemCount: _categoryList.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return Container(
                                      width: 80,
                                      margin: EdgeInsets.all(5),
                                      child: GestureDetector(
                                        onTap: () {
                                          categoriesSelectedIndex = index;
                                          subCateSelectIndex = -1;

                                          _productsList.clear();

                                          if (_categoryList[
                                                          categoriesSelectedIndex!]
                                                      .subcategory !=
                                                  null &&
                                              _categoryList[
                                                          categoriesSelectedIndex!]
                                                      .subcategory!
                                                      .length >
                                                  0) {
                                            _subCategoryList.clear();

                                            for (int i = 0;
                                                i <
                                                    _categoryList[
                                                            categoriesSelectedIndex!]
                                                        .subcategory!
                                                        .length;
                                                i++) {
                                              // print(
                                              //     "###############################------1 addddddd");
                                              _subCategoryList.add(new SubCateeList(
                                                  catId: _categoryList[
                                                          categoriesSelectedIndex!]
                                                      .subcategory![i]
                                                      .catId,
                                                  title: _categoryList[
                                                          categoriesSelectedIndex!]
                                                      .subcategory![i]
                                                      .title,
                                                  image: _categoryList[
                                                          categoriesSelectedIndex!]
                                                      .subcategory![i]
                                                      .image,
                                                  parent: _categoryList[
                                                          categoriesSelectedIndex!]
                                                      .subcategory![i]
                                                      .parent));
                                            }
                                          } else {
                                            for (int i = 0;
                                                i <
                                                    _categoryList[
                                                            categoriesSelectedIndex!]
                                                        .subcategory!
                                                        .length;
                                                i++) {
                                              // print(
                                              //     "###############################------2 addddddd");

                                              _subCategoryList.add(new SubCateeList(
                                                  catId: _categoryList[
                                                          categoriesSelectedIndex!]
                                                      .subcategory![i]
                                                      .catId,
                                                  title: _categoryList[
                                                          categoriesSelectedIndex!]
                                                      .subcategory![i]
                                                      .title,
                                                  image: _categoryList[
                                                          categoriesSelectedIndex!]
                                                      .subcategory![i]
                                                      .image,
                                                  parent: _categoryList[
                                                          categoriesSelectedIndex!]
                                                      .subcategory![i]
                                                      .parent));
                                            }
                                          }
                                          global.isSubCatSelected = false;

                                          if (!global.isEventProduct) {
                                            global.homeSelectedCatID =
                                                _categoryList[
                                                        categoriesSelectedIndex!]
                                                    .catId!;
                                            // _getCategoryProduct(
                                            //     global.homeSelectedCatID);
                                            if (_productsList != null &&
                                                _productsList.length > 0) {
                                              _productsList.clear();
                                              // _isDataLoaded =
                                              //     false,
                                            }
                                            if (!global.isSubCatSelected) {
                                              // print(
                                              //     "This is category id---- ${categoryId}");
                                              _getCategoryProduct(global
                                                  .homeSelectedCatID); // _init();
                                            } else {
                                              // print(
                                              //     "This is Subcategory id---- ${categoryId}");
                                              _getSubCategoryProduct(
                                                  global.homeSelectedCatID);
                                            }
                                            isSelectedCat = 0;
                                          } else {
                                            selectedCatID = _categoryList[
                                                    categoriesSelectedIndex!]
                                                .catId!;
                                            // print(
                                            //     "niks This is _getEventProduct cat id---- ${categoryId}");
                                            _getEventProduct(
                                                global.homeSelectedCatID);
                                          }
                                          setState(() {});
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 80,
                                              height: 60,
                                              child: Card(
                                                color: Colors.transparent,
                                                elevation: 0,
                                                shadowColor: Colors.transparent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                margin: EdgeInsets.only(
                                                    left: 1, right: 1),
                                                child: Column(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          // border: Border.all(
                                                          //     color: isSelectedIndex == index
                                                          //         ? ColorConstants.appColor
                                                          //         : Colors.white),
                                                        ),
                                                        width: 60,
                                                        height: 60,
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              imageBaseUrl +
                                                                  _categoryList[
                                                                          index]
                                                                      .image!,
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            height:
                                                                double.infinity,
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                              // borderRadius: BorderRadius.circular(10),
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .fitWidth,
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
                                                                  url, error) =>
                                                              Container(
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
                                              margin: EdgeInsets.only(top: 8),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 1, right: 1),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white38),
                                                    child:
                                                        categoriesSelectedIndex ==
                                                                index
                                                            ? Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(3),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: ColorConstants
                                                                      .appColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                child: Text(
                                                                  "${_categoryList[index].title}",
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
                                                                          10,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      color: categoriesSelectedIndex ==
                                                                              index
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .black),
                                                                ),
                                                              )
                                                            : Container(
                                                                // else  condition
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(3),
                                                                child: Text(
                                                                  "${_categoryList[index].title}",
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
                                                                          10,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      color: categoriesSelectedIndex ==
                                                                              index
                                                                          ? ColorConstants
                                                                              .appColor
                                                                          : Colors
                                                                              .black),
                                                                ),
                                                              ),
                                                  ),

                                                  // Container(
                                                  //   padding: EdgeInsets
                                                  //       .only(
                                                  //           left: 1,
                                                  //           right: 1),
                                                  //   decoration:
                                                  //       BoxDecoration(
                                                  //           color: Colors
                                                  //               .white38),
                                                  //   child: Text(
                                                  //     "${_eventsList[index].eventName}",
                                                  //     maxLines: 2,
                                                  //     textAlign:
                                                  //         TextAlign
                                                  //             .center,
                                                  //     style: TextStyle(
                                                  //         fontFamily: global
                                                  //             .fontRailwayRegular,
                                                  //         fontWeight:
                                                  //             FontWeight
                                                  //                 .w200,
                                                  //         fontSize:
                                                  //             12,
                                                  //         overflow:
                                                  //             TextOverflow
                                                  //                 .ellipsis,
                                                  //         color: isSelectedIndex ==
                                                  //                 index
                                                  //             ? ColorConstants
                                                  //                 .appColor
                                                  //             : Colors
                                                  //                 .black),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ));
                                },
                              ),
                            ),
                          ),
                          _isProductLoaded
                              ? _productsList != null &&
                                      _productsList.length > 0
                                  ? Expanded(
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        padding: EdgeInsets.only(top: 8),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          physics:
                                              AlwaysScrollableScrollPhysics(),
                                          controller: _scrollController1,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              isSorted
                                                  ? ProductsMenu(
                                                      isSubCatgoriesScreen:
                                                          showCategories,
                                                      analytics:
                                                          widget.analytics,
                                                      observer: widget.observer,
                                                      categoryProductList:
                                                          sortedProductList,
                                                      isHomeSelected: "subCat",
                                                      passdata1: screenHeading,
                                                      passdata2: categoryId,
                                                      passdata3:
                                                          subscriptionProduct,
                                                      refreshProductList:
                                                          callProductList)
                                                  : ProductsMenu(
                                                      isSubCatgoriesScreen:
                                                          showCategories,
                                                      analytics:
                                                          widget.analytics,
                                                      observer: widget.observer,
                                                      categoryProductList:
                                                          _productsList,
                                                      isHomeSelected: "subCat",
                                                      passdata1: screenHeading,
                                                      passdata2: categoryId,
                                                      passdata3:
                                                          subscriptionProduct,
                                                      refreshProductList:
                                                          callProductList),
                                              _isMoreDataLoaded
                                                  ? Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        backgroundColor:
                                                            ColorConstants
                                                                .colorPageBackground,
                                                        strokeWidth: 1,
                                                      ),
                                                    )
                                                  : SizedBox()
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : Expanded(
                                      child: Container(
                                        color:
                                            ColorConstants.colorPageBackground,
                                        child: Center(
                                          child: Text(
                                            loadingOrError,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: fontMontserratLight,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w200,
                                                color: ColorConstants
                                                    .guidlinesGolden),
                                          ),
                                        ),
                                      ),
                                    )
                              : Expanded(
                                  child: Container(
                                    color: ColorConstants.colorPageBackground,
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  ),
                                ),
                        ],
                      ),
                    )
                  ],
                )

              // : Container(
              //     width: MediaQuery.of(context).size.width,
              //     height: MediaQuery.of(context).size.height * 2,
              //     decoration: BoxDecoration(
              //       image: DecorationImage(
              //           image: AssetImage("assets/images/login_bg.png"),
              //           fit: BoxFit.cover),
              //     ),
              //     child: Center(
              //       child: Text(
              //         "Out of stock for now. \nCheck back soon for more",
              //         textAlign: TextAlign.center,
              //         style: TextStyle(
              //             fontFamily: fontMontserratLight,
              //             fontSize: 20,
              //             fontWeight: FontWeight.w200,
              //             color: ColorConstants.guidlinesGolden),
              //       ),
              //     ),
              // )
              : Center(
                  child: CircularProgressIndicator(),
                )),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.white,

      //   //   shape: RoundedRectangleBorder(),
      //   onPressed: () {
      //     showModalBottomSheet(
      //       // isDismissible: false,
      //       backgroundColor: Colors.white,
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.only(
      //           topLeft: Radius.circular(20),
      //           topRight: Radius.circular(20),
      //         ),
      //       ),
      //       context: context,
      //       builder: (BuildContext context) {
      //         return FilterCustomSheet(
      //           showFilters: _productFilter,
      //         );
      //       },
      //     ).then((value) => {
      //           if (value != null)
      //             {
      //               _productFilter = value,
      //               print(value),
      //               appliedFilter.clear(),
      //               if (_productFilter.filterPriceValue != null &&
      //                   _productFilter.filterPriceValue!.length > 0)
      //                 {
      //                   appliedFilter.add(new AppliedFilterList(
      //                       type: "1", name: _productFilter.filterPriceValue!)),
      //                 },
      //               if (_productFilter.filterDiscountValue != null &&
      //                   _productFilter.filterDiscountValue!.length > 0)
      //                 {
      //                   appliedFilter.add(new AppliedFilterList(
      //                       type: "2",
      //                       name: _productFilter.filterDiscountValue!)),
      //                 },
      //               if (_productFilter.filterSortID != null &&
      //                   _productFilter.filterSortID!.length > 0)
      //                 {
      //                   appliedFilter.add(new AppliedFilterList(
      //                       type: "3", name: _productFilter.filterSortValue!)),
      //                 },
      //               if (_productsList != null && _productsList.length > 0)
      //                 {
      //                   _productsList.clear(),
      //                   _isDataLoaded = false,
      //                 },
      //               if (!global.isEventProduct)
      //                 {
      //                   if (_productsList != null && _productsList.length > 0)
      //                     {
      //                       _productsList.clear(),
      //                       _isDataLoaded = false,
      //                     },
      //                   if (!global.isSubCatSelected)
      //                     {
      //                       print("This is category id---- ${categoryId}"),
      //                       _getCategoryProduct(
      //                           global.homeSelectedCatID), // _init();
      //                     }
      //                   else
      //                     {
      //                       print("This is Subcategory id---- ${categoryId}"),
      //                       _getSubCategoryProduct(global.homeSelectedCatID),
      //                     },
      //                   isSelectedCat = 0,
      //                 }
      //               else
      //                 {
      //                   print(
      //                       "This is _getEventProduct cat id---- ${categoryId}"),
      //                   _getEventProduct(global.homeSelectedCatID),
      //                 },
      //               if (appliedFilter != null && appliedFilter.length > 0)
      //                 {
      //                   isfilterApplied = true,
      //                 }
      //               else
      //                 {
      //                   isfilterApplied = false,
      //                 }
      //             }
      //           else
      //             {
      //               if (_productFilter != null &&
      //                   ((_productFilter.filterDiscountID != null &&
      //                           _productFilter.filterDiscountID!.length > 0) ||
      //                       (_productFilter.filterPriceID != null &&
      //                           _productFilter.filterPriceID!.length > 0) ||
      //                       (_productFilter.filterSortID != null &&
      //                           _productFilter.filterSortID!.length > 0)))
      //                 {
      //                   isfilterApplied = true,
      //                 }
      //               else
      //                 {
      //                   isfilterApplied = false,
      //                 },
      //               print("Clear all or dismissed"),
      //             }
      //         });
      //   },
      //   child: Icon(
      //     MdiIcons.filterOutline,
      //     color: Colors.red,
      //     size: 30,
      //   ),
      // ),
    );
  }

  bool isSortOpen = false;
  String loadingOrError = "loading";

  @override
  void initState() {
    super.initState();
    // print("nikhil-----------------------${showCategories}");
    _getCategoryList();
    _productsList.clear();
    _init();
    global.total_delivery_count = 1;
    if (!global.isEventProduct) {
      _isProductLoaded = false;
      // _getSubCategoryList(global.parentCatID);
      if (!global.isSubCatSelected) {
        print("This is category id-yr--- ${categoryId}");
        _getCategoryProduct(categoryId!); // _init();
      } else {
        // print("This is Subcategory id---- ${categoryId}");
        // _getSubCategoryProduct(global.homeSelectedCatID);
      }

      isSelectedCat = 0;
    } else {
      _isProductLoaded = true;
      print("niks This is _getEventProduct cat id---- ${categoryId}");
      _getEventProduct(global.homeSelectedCatID);
    }
    appliedFilter.add(
        new AppliedFilterList(type: "0", name: "Price", isFilterValue: false));
    appliedFilter.add(new AppliedFilterList(
        type: "0", name: "Discount", isFilterValue: false));
    appliedFilter.add(
        new AppliedFilterList(type: "0", name: "Sort", isFilterValue: false));
    if (!global.isEventProduct) {
      appliedFilter.add(new AppliedFilterList(
          type: "0", name: "Occasion", isFilterValue: false));
    }
    // callShowFiltersAPI();
  }

  void callProductList() {
    _productsList.clear();
    global.total_delivery_count = 1;
    if (!global.isEventProduct) {
      _isProductLoaded = false;
      // _getSubCategoryList(global.parentCatID);
      if (!global.isSubCatSelected) {
        // print("This is category id-yr--- ${categoryId}");
        _getCategoryProduct(global.homeSelectedCatID); // _init();
      } else {
        // print("This is Subcategory id---- ${categoryId}");
        _getSubCategoryProduct(global.homeSelectedCatID);
      }

      isSelectedCat = 0;
    } else {
      _isProductLoaded = true;
      // print("niks This is _getEventProduct cat id---- ${categoryId}");
      _getEventProduct(global.homeSelectedCatID);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController1.dispose();
    super.dispose();
  }

  _init() async {
    try {
      _scrollController1 = ScrollController()..addListener(_scrollListener);

      setState(() {});
    } catch (e) {
      print("Exception - sub_categories_screen.dart - _init():" + e.toString());
    }
  }

//_scrollController.position.pixels == _scrollController.position.maxScrollExtent * 0.75
  double boundaryOffset = 0.5;
  int currentpage = 1;

  void _scrollListener() {
    if (_scrollController1.offset >=
            _scrollController1.position.maxScrollExtent * 0.5 &&
        !_isMoreDataLoaded) {
      bool isTop = _scrollController1.position.pixels == 0.0;
      if (isTop) {
        // print('At the top');
      } else {
        boundaryOffset = 1 - 1 / (currentpage * 2);

        if (!global.isEventProduct) {
          if (!global.isSubCatSelected) {
            if (_isRecordPending) {
              // print("This is category id---- ${categoryId}"); // id no 77 line
              _getCategoryProduct(global.homeSelectedCatID); // _init();
            }
          } else {
            if (_isRecordPending) {
              // print("This is Subcategory id---- ${categoryId}");
              _getSubCategoryProduct(global.homeSelectedCatID);
            }
          }
          isSelectedCat = 0;
        } else {
          if (_isRecordPending) {
            _getEventProduct(global.homeSelectedCatID);
          }
        }
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

  _getCategoryList() async {
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        if (_isRecordPending) {
          setState(() {
            _isMoreDataLoaded = true;
          });
          if (_categoryList.isEmpty) {
            page = 1;
          } else {
            page++;
          }

          await apiHelper.getCategoryList(page).then((result) async {
            if (result != null) {
              List<CategoryList> _tList = result.data;
              if (_tList.isEmpty) {
                _isRecordPending = false;
              }

              _categoryList.clear();
              _categoryList.addAll(_tList);
              // print(
              //     "Niks all global.isSubCatSelected------------>${global.isSubCatSelected}  ");
              print("G1---------------0--->$categoryId");
              if (!global.isSubCatSelected) {
                print("G1---------------1--->$categoryId");
                if (!global.isEventProduct) {
                  for (int i = 0; i < _categoryList.length; i++) {
                    if (global.homeSelectedCatID != null &&
                        global.homeSelectedCatID > 0 &&
                        global.homeSelectedCatID == _categoryList[i].catId) {
                      categoriesSelectedIndex = i;
                    } else {
                      if (categoriesSelectedIndex != null &&
                          categoriesSelectedIndex! < 0) {
                        categoriesSelectedIndex = global.routingCategoryID;
                      }
                      if (categoryId == _categoryList[i].catId) {
                        print(
                            "G1---------------8--->$categoryId   && ${_categoryList[i].catId}");
                        categoriesSelectedIndex = i;
                      }
                    }
                  }
                }
              } else {
                if (!global.isEventProduct) {
                  for (int i = 0; i < _categoryList.length; i++) {
                    for (int j = 0;
                        j < _categoryList[i].subcategory!.length;
                        j++) {
                      // print(global.homeSelectedCatID);
                      // print(_categoryList[i].subcategory![j].catId);
                      if (global.homeSelectedCatID ==
                          _categoryList[i].subcategory![j].catId) {
                        categoriesSelectedIndex = i;
                      }
                    }
                  }
                }
              }

              // print(
              //     "nikhil--------------categoriesSelectedIndex-------------${categoriesSelectedIndex}");
              _subCategoryList.clear();
              if (categoriesSelectedIndex != null &&
                  categoriesSelectedIndex! >= 0) {
                for (int i = 0;
                    i <
                        _categoryList[categoriesSelectedIndex!]
                            .subcategory!
                            .length;
                    i++) {
                  // print(_categoryList[categoriesSelectedIndex!]
                  //     .subcategory![i]
                  //     .catId);
                  // print("###############################------3 ");

                  if (global.homeSelectedCatID ==
                      _categoryList[categoriesSelectedIndex!]
                          .subcategory![i]
                          .catId) {
                    subCateSelectIndex = i;
                  }
                  _subCategoryList.add(new SubCateeList(
                      catId: _categoryList[categoriesSelectedIndex!]
                          .subcategory![i]
                          .catId,
                      title: _categoryList[categoriesSelectedIndex!]
                          .subcategory![i]
                          .title,
                      image: _categoryList[categoriesSelectedIndex!]
                          .subcategory![i]
                          .image,
                      parent: _categoryList[categoriesSelectedIndex!]
                          .subcategory![i]
                          .parent));
                }
              }
              // if (!global.isEventProduct) {

              //   _getSubCategoryList(global.parentCatID);
              // }

              setState(() {
                _issubCatDataLoaded = true;
                _isMoreDataLoaded = false;
              });
            }
          });
        }
      } else {
        showNetworkErrorSnackBar1(_scaffoldKey!);
      }
    } catch (e) {
      print("Exception - sub_categories_screen.dart - _getCategoryList()1:" +
          e.toString());
    }
  }

  _onRefresh() async {
    try {
      _isDataLoaded = false;
      _isRecordPending = false;
      setState(() {});
      await _init();
    } catch (e) {
      print("Exception - sub_categories_screen.dart - _onRefresh():" +
          e.toString());
    }
  }

  HomeScreenData? _homeScreenData;
  int _selectedIndexCat = 0;
  int _currentIndex = 0;

  List<Product> _productsList = [];
  List<Product> sortedProductList = [];
  ProductFilter _productFilter = new ProductFilter();
  List<AppliedFilterList> appliedFilter = [];
  List<String> filterTypes = [];
  _getCategoryProduct(int subCatID) async {
    // print("Result123");
    loadingOrError = "loading";
    try {
      // if (_isRecordPending) {
      setState(() {
        _isMoreDataLoaded = true;
      });
      if (_productsList.isEmpty) {
        _isProductLoaded = false;
        page = 1;
      } else {
        page = page + 1;
      }
      print("NIKS:---TOTAL>${subCatID}");
      List<Product> _tList = [];
      await apiHelper
          .getCategoryProducts(
              subCatID, page, _productFilter, global.isSubscription!)
          .then((result) async {
        if (result.status == "1") {
          if (result != null) {
            // if (result.status == "1") {
            // List<Product> _tList = result.data;
            _tList.clear();
            _tList = result.data;
            if (page == 1) {
              _productsList.clear();
            }
            if (_tList.isEmpty) {
              _isRecordPending = false;
            }
            _isMoreDataLoaded = false;

            if (_tList.length > 0) {
              _productsList.addAll(_tList);

              //_productsList.addAll(_tList);

              _isDataLoaded = true;
              _isProductLoaded = true;
              setState(() {
                _isMoreDataLoaded = false;
              });
            }
            // }
            else {
              // print(
              //     "########################## HELLO   #########%%%%%%%%%%%%%%%%%%%%%");

              if (_productsList.length != null &&
                  _productsList.length == 0 &&
                  _productFilter != null &&
                  (_productFilter.filterDiscountID != null ||
                      _productFilter.filterOcassionID != null ||
                      _productFilter.filterPriceID != null ||
                      _productFilter.filterSortID != null)) {
                loadingOrError = "No products Found";
              }
              setState(() {
                _isDataLoaded = true;
                _isProductLoaded = true;
                _isMoreDataLoaded = false;
              });
            }
          } else {
            _isDataLoaded = true;
            _isProductLoaded = true;
            _isDataAvailable = true;
            if (_productsList.length != null && _productsList.length != 0) {
              _isRecordPending = false;

              loadingOrError =
                  "Out of stock for now. \nCheck back soon for more";
            } else if (_productFilter != null &&
                (_productFilter.filterDiscountID != null ||
                    _productFilter.filterOcassionID != null ||
                    _productFilter.filterPriceID != null ||
                    _productFilter.filterSortID != null)) {
              loadingOrError = "No products Found";
            }
            setState(() {});

            // page++;
          }
        } else {
          // print(
          //     "########################## HELLO   NIKS#########%%%%%%%%%%%%%%%%%%%%%");
          if (_productsList != null && _productsList.length == 0) {
            loadingOrError = "Out of stock for now. \nCheck back soon for more";
          } else {
            loadingOrError = "No products found";
          }
          _isDataLoaded = true;
          _isProductLoaded = true;
          _isDataAvailable = true;
          _isMoreDataLoaded = false;
          setState(() {});
        }
      });
      // }
    } catch (e) {
      if (_productsList != null && _productsList.length == 0) {
        loadingOrError = "Out of stock for now. \nCheck back soon for more";
      } else {
        loadingOrError = "No products found";
      }
      _isDataLoaded = false;
      _isProductLoaded = false;
      _isDataAvailable = false;
      _isMoreDataLoaded = false;
      setState(() {});
      print("Exception - productlist_screen.dart - _getCategoryProduct():" +
          e.toString());
    }
  }

  _getSubCategoryProduct(int subCatID) async {
    loadingOrError = "loading";
    // print("Sub Category Product-------------------");
    try {
      // if (_isRecordPending) {
      setState(() {
        _isMoreDataLoaded = true;
      });
      if (_productsList.isEmpty) {
        _isProductLoaded = false;
        page = 1;
      } else {
        page = page + 1;
      }
      // print("G1:---TOTAL>${_productsList.length}");
      List<Product> _tList = [];
      await apiHelper
          .getSubCategoryProducts(
              subCatID, page, _productFilter, global.isSubscription!)
          .then((result) async {
        if (result.status == "1") {
          if (result != null) {
            // if (result.status == "1") {
            // List<Product> _tList = result.data;
            _tList.clear();
            _tList = result.data;
            if (page == 1) {
              _productsList.clear();
            }
            if (_tList.isEmpty) {
              _isRecordPending = false;
            }
            _isMoreDataLoaded = false;
            // if (isSelectedCat == 0) {
            //   _subCategoryList[0].isSelected = true;
            // }
            // print("niks-------------------------------_>");
            // print(_tList.length);
            if (_tList.length > 0) {
              _productsList.addAll(_tList);
              //_productsList.addAll(_tList);
              _isDataLoaded = true;
              _isProductLoaded = true;

              // print('Product api  count:--->${_tList.length} &&& page--->$page');
              // print('Product count1:--->${_productsList.length}');

              // for (Product model in _tList) {
              //   print(
              //       'Product name --->${model.productName} && ${model.productId}');
              // }
              // print('Product count:--->${_productsList.length}');
              setState(() {
                // _            ? _subCategoryList != null && _subCategoryList.length > 0

                _isMoreDataLoaded = false;
              });
            }
            // }
            else {
              if (_productsList.length != null &&
                  _productsList.length == 0 &&
                  _productFilter != null &&
                  (_productFilter.filterDiscountID != null ||
                      _productFilter.filterOcassionID != null ||
                      _productFilter.filterPriceID != null ||
                      _productFilter.filterSortID != null)) {
                loadingOrError = "No products Found";
              }
              setState(() {
                _isDataLoaded = true;
                _isProductLoaded = true;
                _isMoreDataLoaded = false;
              });
            }
          } else {
            if (_productsList.length != null && _productsList.length != 0) {
              loadingOrError =
                  "Out of stock for now. \nCheck back soon for more";
            } else if (_productFilter != null &&
                (_productFilter.filterDiscountID != null ||
                    _productFilter.filterOcassionID != null ||
                    _productFilter.filterPriceID != null ||
                    _productFilter.filterSortID != null)) {
              loadingOrError = "No products found";
            }
            _isDataLoaded = true;
            _isProductLoaded = true;
            _isDataAvailable = true;
            _isMoreDataLoaded = false;
            setState(() {});
            // page++;
          }
        } else {
          _isDataLoaded = true;
          _isProductLoaded = true;
          _isDataAvailable = true;
          _isMoreDataLoaded = false;
          if (_productsList.length != null && _productsList.length != 0) {
            _isRecordPending = false;

            loadingOrError = "Out of stock for now. \nCheck back soon for more";
          } else {
            loadingOrError = "No products found";
          }
          setState(() {});
        }
      });
      // }
    } catch (e) {
      if (_productsList != null && _productsList.length == 0) {
        loadingOrError = "Out of stock for now. \nCheck back soon for more";
      } else {
        loadingOrError = "No products found";
      }
      _isDataLoaded = false;
      _isProductLoaded = false;
      _isDataAvailable = false;
      _isMoreDataLoaded = false;
      setState(() {});
      print("Exception - productlist_screen.dart - _getSubCategoryProduct():" +
          e.toString());
    }
  }

  _getEventProduct(eventID) async {
    loadingOrError = "Loading...";
    // print("Sub Category Product-------------------");
    try {
      // if (_isRecordPending) {
      setState(() {
        _isMoreDataLoaded = true;
      });
      if (_productsList.isEmpty) {
        page = 1;
      } else {
        page = page + 1;
      }
      // print("G1:---TOTAL>${_productsList.length}");
      List<Product> _tList = [];
      await apiHelper
          .getEventFilteredProducts(
              eventID,
              page,
              selectedCatID != null ? selectedCatID.toString() : "",
              global.isSubCatSelected
                  ? "sub"
                  : !global.isSubCatSelected &&
                          (selectedCatID != null && selectedCatID! > 0)
                      ? "parent"
                      : "",
              _productFilter)
          .then((result) async {
        if (result.status == "1") {
          if (result != null) {
            if (result.data != null) {
              // print("nikhil result---->result---->${result.data}");
              // if (result.status == "1") {
              // List<Product> _tList = result.data;
              _tList.clear();
              _tList = result.data;
              if (page == 1) {
                _productsList.clear();
              }
              if (_tList.isEmpty) {
                _isRecordPending = false;
              }
              _isMoreDataLoaded = false;
              // if (isSelectedCat == 0) {
              //   _subCategoryList[0].isSelected = true;
              // }
              // print(
              //     'Product api  count:--->${_tList.length} &&& page--->$page');
              // print('Product count1:--->${_productsList.length}');

              if (_tList.length > 0) {
                _productsList.addAll(_tList);
                //_productsList.addAll(_tList);
                // print('Product count1:--->${_productsList.length}');
                _isDataLoaded = true;
                // print('Product api  count:--->${_tList.length} &&& page--->$page');
                // print('Product count1:--->${_productsList.length}');

                // for (Product model in _tList) {
                //   print(
                //       'Product name --->${model.productName} && ${model.productId}');
                // }
                // print('Product count:--->${_productsList.length}');
                setState(() {
                  // _            ? _subCategoryList != null && _subCategoryList.length > 0
                  _isDataLoaded = true;
                  _isMoreDataLoaded = false;
                });
              }
              // }
              else {
                if (_productsList != null &&
                    _productsList.length == 0 &&
                    _productFilter != null &&
                    (_productFilter.filterDiscountID != null ||
                        _productFilter.filterOcassionID != null ||
                        _productFilter.filterPriceID != null ||
                        _productFilter.filterSortID != null)) {
                  loadingOrError = "No products Found";
                } else {
                  loadingOrError = "No products Found";
                }
                setState(() {
                  _isDataLoaded = true;
                  _isMoreDataLoaded = false;
                });
              }
            } else {
              if (_productsList.length != null && _productsList.length != 0) {
                loadingOrError =
                    "Out of stock for now. \nCheck back soon for more";
              } else if (_productFilter != null &&
                  (_productFilter.filterDiscountID != null ||
                      _productFilter.filterOcassionID != null ||
                      _productFilter.filterPriceID != null ||
                      _productFilter.filterSortID != null)) {
                loadingOrError = "No products Found";
              }
              _isDataLoaded = true;
              _productsList = _productsList;
              setState(() {
                _isMoreDataLoaded = false;
              });
            }
          } else {
            if (_productsList.length != null && _productsList.length != 0) {
              loadingOrError =
                  "Out of stock for now. \nCheck back soon for more";
            } else if (_productFilter != null &&
                (_productFilter.filterDiscountID != null ||
                    _productFilter.filterOcassionID != null ||
                    _productFilter.filterPriceID != null ||
                    _productFilter.filterSortID != null)) {
              loadingOrError = "No products Found";
            }
            _isDataLoaded = true;
            _isDataAvailable = true;
            _isMoreDataLoaded = false;
            setState(() {});
            // page++;
          }
        } else {
          if (_productsList != null && _productsList.length == 0) {
            loadingOrError = "Out of stock for now. \nCheck back soon for more";
          } else {
            loadingOrError = "No products found";
          }
          _isDataLoaded = true;
          _isDataAvailable = true;
          _isMoreDataLoaded = false;
          if (_productsList.length != null && _productsList.length != 0) {
            _isRecordPending = false;
          }
          setState(() {});
        }
      });
      // }
    } catch (e) {
      if (_productsList != null && _productsList.length == 0) {
        loadingOrError = "Out of stock for now. \nCheck back soon for more";
      } else {
        loadingOrError = "No products found";
      }
      _isDataLoaded = false;
      _isDataAvailable = false;
      setState(() {});
      print("Exception - subCategories.dart - _getEventProduct():" +
          e.toString());
    }
  }

  // show cart items
  final CartController cartController = Get.put(CartController());

  _getSubCategoryList(int parentCatId) async {
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        await apiHelper.getSubCatList(parentCatId).then((result) async {
          if (result != null) {
            List<SubCateeList> _tList = result.data;
            // if (_tList.isEmpty) {
            //   _isRecordPending = false;
            // }
            // print("###############################------4 addddddd");

            // _subCategoryList.clear();
            // Combine old and new, then remove duplicates
            // List<SubCateeList> combinedList = [..._subCategoryList, ..._tList];
            // final uniqueMap = {
            //   for (var item in combinedList) item.catId: item
            // };
            // print(uniqueMap.values.toList());
            _subCategoryList.clear();
            _subCategoryList.addAll(_tList);
            // print("################NEW#########");
            // print(_subCategoryList);
            // print("################NEW#########");

            _issubCatDataLoaded = true;
            if (global.isSubCatSelected &&
                _subCategoryList != null &&
                _subCategoryList.length > 0) {
              for (int i = 0; i < _subCategoryList.length; i++) {
                if (categoryId == _subCategoryList[i].catId) {
                  subCateSelectIndex = i;
                }
              }
            }
            setState(() {});
          }
        });
      } else {
        showNetworkErrorSnackBar1(_scaffoldKey!);
      }
    } catch (e) {
      print("Exception - sub_categories_screen.dart - _getSubCategoryList():" +
          e.toString());
    }
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
