//import 'dart:async';

//import 'dart:ffi';
// import 'dart:js_util';

import 'package:byyu/models/businessLayer/apiHelper.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/models/categoryListModel.dart';
import 'package:byyu/models/filterModelsNew.dart';
import 'package:byyu/screens/auth/login_screen.dart';
import 'package:byyu/screens/filter_screen.dart';
import 'package:byyu/screens/home_screen.dart';
import 'package:byyu/screens/product/wishlist_screen.dart';
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
  int? DeliveryType;
  // bool? xpressProducts;

  SubCategoriesScreen(
      {a,
      o,
      this.screenHeading,
      this.categoryId,
      this.isSubcategory,
      this.isEventProducts,
      this.showCategories,
      this.minAge,
      this.maxAge,
      this.recipientId,
      this.DeliveryType
      // this.xpressProducts,
      })
      : super(a: a, o: o, r: 'SubCategoriesScreen');

  @override
  _SubCategoriesScreenState createState() => _SubCategoriesScreenState(
      categoryId: categoryId,
      screenHeading: screenHeading,
      isEventProducts: isEventProducts,
      showCategories: showCategories,
      isSubcategory: isSubcategory,
      minAge: minAge,
      maxAge: maxAge,
      recipientId: recipientId,
      deliveryType: DeliveryType);
}

class _SubCategoriesScreenState extends BaseRouteState {
  int? deliveryType;
  int? categoryId;
  int? minAge;
  int? maxAge;
  int? recipientId;
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
  bool filtersDrawer = false;
  final List<String> SelectedOptionsFilters = [];
  List<FilterCategory> filterList = [];
  List<String> selectedOccasionIds = [];
  List<String> selecteddeliveryIds = [];
  List<String> selectedcolorsIds = [];
  List<String> selectedpacksIds = [];
  List<String> selectedplantsIds = [];
  List<String> selectedflavoursIds = [];
  List<String> selectedvariantsIds = [];
  List<String> selectedtypesIds = [];
  List<String> selectedSubCatID = [];
  Map<String, Set<String>> selectedMap = {};
  double Slider1 = 0;
  double Slider2 = 3999;
  List<Map<String, dynamic>> sortOptions = [
    {"title": "New", "isSelected": false, "id": "13"},
    {"title": "Low to High Price", "isSelected": false, "id": "16"},
    {"title": "High to Low Price", "isSelected": false, "id": "17"},
    {"title": "A - Z", "isSelected": false, "id": "14"},
    {"title": "Z - A", "isSelected": false, "id": "15"},
  ];
  String drawerSelectedOption = "filters";
  String selectedSortID = "";

  _SubCategoriesScreenState(
      {this.categoryId,
      this.screenHeading,
      this.isSubcategory,
      this.showCategories,
      this.isEventProducts,
      this.maxAge,
      this.minAge,
      this.recipientId,
      this.deliveryType});

  @override
  bool? ischecked = false;
  int? _value = 1; // for sort by radio button
  int isIndexSelected = 0;

  Widget build(BuildContext context) {
    // TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      key: _scaffoldKey,
      drawerEnableOpenDragGesture: true, // optional

  drawer: SizedBox(
  width: MediaQuery.of(context).size.width,
  child: SafeArea(
    child: drawerSelectedOption == "filters"
        ? buildFiltersDrawerExpansion(
            context,
            productsFound: 5191,
            onApply: (selected) {},
          )
        : sortDrawer(
  options: sortOptions,

  // 📌 called first → update ID + call API
  onIdSelected: (selectedId) {
    selectedSortID = selectedId;
    print("Selected sort ID = $selectedSortID");

    Navigator.pop(context);   // close drawer

    page = 1;
    _productsList.clear();

    if (global.isSubCatSelected == true) {
      print("subcategoriesssss APIIII");
      _getSubCategoryProduct(selectedSubCatID);
    } else {
      print("categoriesssss APIIII");
      _getCategoryProduct(global.homeSelectedCatID);
    }

    setState(() {});
  },

  onBack: () {
    drawerSelectedOption = "";
    setState(() {});
    Navigator.pop(context);
  },

  onClear: () {
    selectedSortID = "";
    for (var e in sortOptions) {
      e["isSelected"] = false;
    }
    if (global.isSubCatSelected == true) {
      print("subcategoriesssss APIIII");
      _getSubCategoryProduct(selectedSubCatID);
      setState(() {});
    } else {
      print("categoriesssss APIIII");
      _getCategoryProduct(global.homeSelectedCatID);
      setState(() {});
    }

    // setState(() {});
    
    Navigator.pop(context);
  },

  // 📌 only for UI logs / selected name — NO API HERE
  onSelectionChanged: (selectedName) {
    print("SORT SELECTED → $selectedName");
    print("SORT ID → $selectedSortID");
  },
),

  ),
),


     

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
            width: 5,
          ),


          InkWell(
                onTap: () {
                  if (global.stayLoggedIN == null || !global.stayLoggedIN!) {
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WishListScreen(
                          a: widget.analytics,
                          o: widget.observer,
                     
        callbackHomescreenSetState: callHomeScreenSetState,
        onAppDrawerButtonPressed: () {},
                        ),
                      ),
                    );
                    global.wishlistNav = true;
                  }
                  global.routingProductID = 0;
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => WishListScreen(
                  //           a: widget.analytics,
                  //           o: widget.observer,
                  //           // fromBottomNvigation: false,
                  //         )));
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 16, left: 8),
                  child: Image.asset(
                    "assets/images/ic_nav_favorites.png",
                    fit: BoxFit.contain,
                    height: 28,
                    alignment: Alignment.center,
                  ),
                ),
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
           SizedBox(
            width: 5,
          ),

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
                                              itemCount:
                                                  _subCategoryList.length,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              // itemBuilder: (context, index) {
                                              //   return Container(

                                              //       // width: 65,
                                              //       margin: EdgeInsets.all(5),
                                              //       child: GestureDetector(
                                              //         onTap: () {
                                              //           subCateSelectIndex =
                                              //               index;
                                              //           _productsList.clear();
                                              //           global.isSubCatSelected =
                                              //               true;
                                              //           if (!_isRecordPending) {
                                              //             _isRecordPending = true;
                                              //           }

                                              //           // _getSubCategoryProduct(
                                              //           //     _subCategoryList[index]
                                              //           //         .catId!);
                                              //           // if (!global
                                              //           //     .isEventProduct) {
                                              //           global.homeSelectedCatID =
                                              //               _subCategoryList[
                                              //                       index]
                                              //                   .catId!;
                                              //           if (_productsList !=
                                              //                   null &&
                                              //               _productsList.length >
                                              //                   0) {
                                              //             _productsList.clear();
                                              //           }

                                              //           _getSubCategoryProduct(
                                              //               global
                                              //                   .homeSelectedCatID);

                                              //           setState(() {});
                                              //         },
                                              //         child: Column(
                                              //           children: [
                                              //             Container(
                                              //               margin:
                                              //                   EdgeInsets.only(
                                              //                       top: 4),
                                              //               child: Column(
                                              //                 mainAxisAlignment:
                                              //                     MainAxisAlignment
                                              //                         .end,
                                              //                 crossAxisAlignment:
                                              //                     CrossAxisAlignment
                                              //                         .center,
                                              //                 children: [
                                              //                   Container(
                                              //                       padding: EdgeInsets
                                              //                           .only(
                                              //                               left:
                                              //                                   1,
                                              //                               right:
                                              //                                   1),
                                              //                       child: subCateSelectIndex ==
                                              //                               index
                                              //                           ? Container(
                                              //                               // width:
                                              //                               //     165,
                                              //                               padding: EdgeInsets.only(
                                              //                                   top: 5,
                                              //                                   bottom: 5,
                                              //                                   left: 8,
                                              //                                   right: 8),
                                              //                               decoration: BoxDecoration(
                                              //                                   color: ColorConstants.white,
                                              //                                   border: Border.all(color: ColorConstants.appColor, width: 0.8),
                                              //                                   borderRadius: BorderRadius.circular(8)),

                                              //                               child:
                                              //                                   Row(
                                              //                                 mainAxisSize:
                                              //                                     MainAxisSize.min,
                                              //                                 mainAxisAlignment:
                                              //                                     MainAxisAlignment.start,
                                              //                                 crossAxisAlignment:
                                              //                                     CrossAxisAlignment.center,
                                              //                                 children: [
                                              //                                   //   ----------- Circle 20px -----------
                                              //                                   Container(
                                              //                                     width: 8,
                                              //                                     height: 8,
                                              //                                     decoration: const BoxDecoration(
                                              //                                       color: ColorConstants.appColor, // change if needed
                                              //                                       shape: BoxShape.circle,
                                              //                                     ),
                                              //                                   ),

                                              //                                   const SizedBox(width: 8),

                                              //                                   // ----------- Text -----------

                                              //                                   Text(
                                              //                                     "${_subCategoryList[index].title}",
                                              //                                     maxLines: 2,
                                              //                                     textAlign: TextAlign.center,
                                              //                                     style: TextStyle(fontFamily: global.fontRailwayRegular, fontWeight: FontWeight.w200, fontSize: 12, overflow: TextOverflow.ellipsis, color: ColorConstants.appColor),
                                              //                                   ),
                                              //                                 ],
                                              //                               ),
                                              //                             )
                                              //                           : Container(
                                              //                               // width:
                                              //                               //     165,
                                              //                               padding: EdgeInsets.only(
                                              //                                   top: 5,
                                              //                                   bottom: 5,
                                              //                                   left: 8,
                                              //                                   right: 8),
                                              //                               decoration: BoxDecoration(
                                              //                                   color: ColorConstants.white,
                                              //                                   border: Border.all(color: ColorConstants.appColor, width: 0.2),
                                              //                                   borderRadius: BorderRadius.circular(8)),

                                              //                               child:
                                              //                                   Row(
                                              //                                 mainAxisSize:
                                              //                                     MainAxisSize.min,
                                              //                                 mainAxisAlignment:
                                              //                                     MainAxisAlignment.start,
                                              //                                 crossAxisAlignment:
                                              //                                     CrossAxisAlignment.center,
                                              //                                 children: [
                                              //                                   //   ----------- Circle 20px -----------
                                              //                                   Container(
                                              //                                     width: 8,
                                              //                                     height: 8,
                                              //                                     decoration: BoxDecoration(
                                              //                                       color: ColorConstants.white, // change if needed
                                              //                                       shape: BoxShape.circle,
                                              //                                       border: Border.all(color: ColorConstants.appColor, width: 0.2),
                                              //                                     ),
                                              //                                   ),

                                              //                                   const SizedBox(width: 8),

                                              //                                   // ----------- Text -----------

                                              //                                   Text(
                                              //                                     "${_subCategoryList[index].title}",
                                              //                                     maxLines: 2,
                                              //                                     textAlign: TextAlign.center,
                                              //                                     style: TextStyle(fontFamily: global.fontRailwayRegular, fontWeight: FontWeight.w200, fontSize: 12, overflow: TextOverflow.ellipsis, color: ColorConstants.appColor),
                                              //                                   ),
                                              //                                 ],
                                              //                               ),
                                              //                             )),
                                              //                 ],
                                              //               ),
                                              //             ),
                                              //           ],
                                              //         ),
                                              //       ));
                                              // },

                                              itemBuilder: (context, index) {
                                                final item =
                                                    _subCategoryList[index];
                                                final bool isSelected =
                                                    selectedSubCatID.contains(
                                                        item.catId.toString());

                                                return Container(
                                                  margin:
                                                      const EdgeInsets.all(5),
                                                  child: GestureDetector(
                                                    // onTap: () {
                                                    //   setState(() {
                                                    //     if (isSelected) {
                                                    //       selectedSubCatID
                                                    //           .remove(item.catId
                                                    //               .toString());
                                                    //       print(
                                                    //           "REMOVED SUBCAT → $selectedSubCatID");
                                                    //     } else {
                                                    //       selectedSubCatID.add(
                                                    //           item.catId
                                                    //               .toString());
                                                    //       print(
                                                    //           "ADDED SUBCAT → $selectedSubCatID");
                                                    //     }

                                                    //     _productsList.clear();
                                                    //     global.isSubCatSelected =
                                                    //         true;
                                                    //     global.homeSelectedCatID =
                                                    //         item.catId!;
                                                    //     _getSubCategoryProduct(
                                                    //         global
                                                    //             .homeSelectedCatID);
                                                    //   });
                                                    // },
                                                    onTap: () {
  setState(() {
    // -------------------------
    // REMOVE subcategory (if already selected)
    // -------------------------
    if (isSelected) {
      selectedSubCatID.remove(item.catId.toString());
      print("REMOVED SUBCAT → $selectedSubCatID");
      if (selectedSubCatID.isNotEmpty) {
        // still have some selected subcategories
        _productsList.clear();
        global.isSubCatSelected = true;
        global.homeSelectedCatID = item.catId!;
        _getSubCategoryProduct(global.homeSelectedCatID);
         print("checkkkk id 22222222222222 ${ global.selectedDrawerCatID!}");
      } else {
        // no subcategories left
        _productsList.clear();
        global.isSubCatSelected = false; // since no subcategory chosen
        global.homeSelectedCatID = item.catId!;

        print("checkkkk id 11111111111 ${ global.selectedDrawerCatID!}");
_getCategoryProduct(
  global.selectedDrawerCatID!
);
      }
    }
    // -------------------------
    // ADD subcategory (not selected before)
    // -------------------------
    else {
      selectedSubCatID.add(item.catId.toString());
      print("ADDED SUBCAT → $selectedSubCatID");
      _productsList.clear();
      global.isSubCatSelected = true;
      global.homeSelectedCatID = item.catId!;
      _getSubCategoryProduct(global.homeSelectedCatID);
    }
  });
},
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 14,
                                                          vertical: 6),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        border: Border.all(
                                                          color: isSelected
                                                              ? ColorConstants
                                                                  .appColor
                                                              : ColorConstants
                                                                  .appColor
                                                                  .withOpacity(
                                                                      0.3),
                                                          width: isSelected
                                                              ? 1.2
                                                              : 0.7,
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            isSelected
                                                                ? Icons
                                                                    .check_box
                                                                : Icons
                                                                    .check_box_outline_blank,
                                                            size: 17,
                                                            color:
                                                                ColorConstants
                                                                    .appColor,
                                                          ),
                                                          const SizedBox(
                                                              width: 6),
                                                          Text(
                                                            item.title ?? "",
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  ColorConstants
                                                                      .appColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
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

                    isEventProducts != true
                        ? Container(
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
                                        "Filters & Sort",
                                        style: TextStyle(
                                            fontFamily:
                                                global.fontRailwayRegular,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            color: ColorConstants.pureBlack),
                                      ),
                                    ),
                                  ),

                                  Container(
                                    height: ColorConstants.filterdividerheight,
                                    width: ColorConstants.filterdividerWidth,
                                    color: ColorConstants.filterDivderColor,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),

                                  InkWell(
                                    onTap: () {
                                      drawerSelectedOption = "filters";
                                      setState( () {});
                                      print(drawerSelectedOption);
                                      print("2222>>>>>>>>>>>>>>>>>>>>>>>>>>");
                                      filtersDrawer = true;
                                      _scaffoldKey.currentState?.openDrawer();
                                      newfiltersAPICALL(selectedCatID);
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 95,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      decoration: BoxDecoration(
                                        color: ColorConstants.white,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        border: Border.all(
                                          color: (selectedOccasionIds.isEmpty &&
                                                  selecteddeliveryIds.isEmpty &&
                                                  selectedcolorsIds.isEmpty &&
                                                  selectedpacksIds.isEmpty &&
                                                  selectedplantsIds.isEmpty &&
                                                  selectedflavoursIds.isEmpty &&
                                                  selectedvariantsIds.isEmpty &&
                                                  selectedtypesIds.isEmpty)
                                              ? const Color.fromARGB(
                                                  255, 209, 208, 208)
                                              : ColorConstants.appColor,
                                          width: 1.0,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                           
                                          Image.asset(
                                            "assets/images/slider.png", // <-- your image path
                                            height: 14,
                                            width: 16,
                                            fit: BoxFit.contain,
                                          ),
                                           SizedBox(width: 6),
                                          InkWell(
                                            child: Text(
                                              "Filters",
                                              style: TextStyle(
                                                fontFamily:
                                                    global.fontRailwayRegular,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                                color: ColorConstants.appColor,
                                              ),
                                            ),
                                          ),
                                        
                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      drawerSelectedOption = "SORT";
                                      print(drawerSelectedOption);
                                      print("11>>>>>>>>>>>>>>>>>>>>>>>>>>");
                                      filtersDrawer = true;
                                      _scaffoldKey.currentState?.openDrawer();

                                      // action
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 95,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      decoration: BoxDecoration(
                                        color: ColorConstants.white,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        border: Border.all(
                                               color: (selectedSortID.isEmpty
                                                  )
                                              ? const Color.fromARGB(
                                                  255, 209, 208, 208)
                                              : ColorConstants.appColor,
                                          width: 1.0,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                           
                                          Image.asset(
                                            "assets/images/sort.png", // <-- your image path
                                            height: 16,
                                            width: 18,
                                            fit: BoxFit.contain,
                                          ),
                                           SizedBox(width: 6),
                                          Text(
                                            "Sort",
                                            style: TextStyle(
                                              fontFamily:
                                                  global.fontRailwayRegular,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              color: ColorConstants.appColor,
                                            ),
                                          ),
                                        
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Expanded(
                                  //   child: Container(
                                  //     height: 25,
                                  //     child: ListView.builder(
                                  //         controller: _scrollController,
                                  //         physics: AlwaysScrollableScrollPhysics(),
                                  //         itemCount: appliedFilter.length,
                                  //         scrollDirection: Axis.horizontal,
                                  //         itemBuilder: (context, index) => InkWell(
                                  //               onTap: () {
                                  //                 if (!appliedFilter[index]
                                  //                     .isFilterValue!) {
                                  //                   showModalBottomSheet(
                                  //                     // isDismissible: false,
                                  //                     backgroundColor: Colors.white,
                                  //                     shape: RoundedRectangleBorder(
                                  //                       borderRadius:
                                  //                           BorderRadius.only(
                                  //                         topLeft:
                                  //                             Radius.circular(20),
                                  //                         topRight:
                                  //                             Radius.circular(20),
                                  //                       ),
                                  //                     ),
                                  //                     context: context,
                                  //                     builder:
                                  //                         (BuildContext context) {
                                  //                       return FilterCustomSheet(
                                  //                         showFilters: _productFilter,
                                  //                         filterTypeIndex: index,
                                  //                       );
                                  //                     },
                                  //                   ).then((value) => {
                                  //                         if (value != null)
                                  //                           {
                                  //                             _productFilter = value,
                                  //                             // print(value),
                                  //                             appliedFilter.clear(),
                                  //                             appliedFilter.add(
                                  //                                 new AppliedFilterList(
                                  //                                     type: "0",
                                  //                                     name: "Price",
                                  //                                     isFilterValue:
                                  //                                         false)),
                                  //                             appliedFilter.add(
                                  //                                 new AppliedFilterList(
                                  //                                     type: "0",
                                  //                                     name:
                                  //                                         "Discount",
                                  //                                     isFilterValue:
                                  //                                         false)),
                                  //                             appliedFilter.add(
                                  //                                 new AppliedFilterList(
                                  //                                     type: "0",
                                  //                                     name: "Sort",
                                  //                                     isFilterValue:
                                  //                                         false)),
                                  //                             if (!global
                                  //                                 .isEventProduct)
                                  //                               {
                                  //                                 appliedFilter.add(
                                  //                                     new AppliedFilterList(
                                  //                                         type: "0",
                                  //                                         name:
                                  //                                             "Occasion",
                                  //                                         isFilterValue:
                                  //                                             false)),
                                  //                               },
                                  //                             if (_productFilter
                                  //                                         .filterPriceValue !=
                                  //                                     null &&
                                  //                                 _productFilter
                                  //                                         .filterPriceValue!
                                  //                                         .length >
                                  //                                     0)
                                  //                               {
                                  //                                 appliedFilter.add(
                                  //                                     new AppliedFilterList(
                                  //                                         type: "1",
                                  //                                         name: _productFilter
                                  //                                             .filterPriceValue!,
                                  //                                         isFilterValue:
                                  //                                             true)),
                                  //                               },
                                  //                             if (_productFilter
                                  //                                         .filterDiscountValue !=
                                  //                                     null &&
                                  //                                 _productFilter
                                  //                                         .filterDiscountValue!
                                  //                                         .length >
                                  //                                     0)
                                  //                               {
                                  //                                 appliedFilter.add(
                                  //                                     new AppliedFilterList(
                                  //                                         type: "2",
                                  //                                         name: _productFilter
                                  //                                             .filterDiscountValue!,
                                  //                                         isFilterValue:
                                  //                                             true)),
                                  //                               },
                                  //                             if (_productFilter
                                  //                                         .filterSortID !=
                                  //                                     null &&
                                  //                                 _productFilter
                                  //                                         .filterSortID!
                                  //                                         .length >
                                  //                                     0)
                                  //                               {
                                  //                                 appliedFilter.add(
                                  //                                     new AppliedFilterList(
                                  //                                         type: "3",
                                  //                                         name: _productFilter
                                  //                                             .filterSortValue!,
                                  //                                         isFilterValue:
                                  //                                             true)),
                                  //                               },
                                  //                             if (_productFilter
                                  //                                         .filterOcassionValue !=
                                  //                                     null &&
                                  //                                 _productFilter
                                  //                                         .filterOcassionValue!
                                  //                                         .length >
                                  //                                     0)
                                  //                               {
                                  //                                 appliedFilter.add(
                                  //                                     new AppliedFilterList(
                                  //                                         type: "4",
                                  //                                         name: _productFilter
                                  //                                             .filterOcassionValue!,
                                  //                                         isFilterValue:
                                  //                                             true)),
                                  //                               },
                                  //                             if (_productsList !=
                                  //                                     null &&
                                  //                                 _productsList
                                  //                                         .length >
                                  //                                     0)
                                  //                               {
                                  //                                 _productsList
                                  //                                     .clear(),
                                  //                                 // _isDataLoaded =
                                  //                                 //     false,
                                  //                               },
                                  //                             if (!global
                                  //                                 .isEventProduct)
                                  //                               {
                                  //                                 // if (_productsList !=
                                  //                                 //         null &&
                                  //                                 //     _productsList
                                  //                                 //             .length >
                                  //                                 //         0)
                                  //                                 //   {
                                  //                                 //     _productsList
                                  //                                 //         .clear(),
                                  //                                 //     // _isDataLoaded =
                                  //                                 //     //     false,
                                  //                                 //   },
                                  //                                 if (!global
                                  //                                     .isSubCatSelected)
                                  //                                   {
                                  //                                     // print(
                                  //                                     //     "This is category id---- ${categoryId}"),
                                  //                                     _getCategoryProduct(
                                  //                                         global
                                  //                                             .homeSelectedCatID), // _init();
                                  //                                   }
                                  //                                 else
                                  //                                   {
                                  //                                     // print(
                                  //                                     //     "This is Subcategory id---- ${categoryId}"),
                                  //                                     _getSubCategoryProduct(
                                  //                                         global
                                  //                                             .homeSelectedCatID),
                                  //                                   },
                                  //                                 isSelectedCat = 0,
                                  //                               }
                                  //                             else
                                  //                               {
                                  //                                 // print(
                                  //                                 //     "niks This is _getEventProduct cat id---- ${categoryId}"),
                                  //                                 _getEventProduct(global
                                  //                                     .homeSelectedCatID),
                                  //                               },
                                  //                           }
                                  //                         else
                                  //                           {
                                  //                             print(
                                  //                                 "Clear all or dismissed"),
                                  //                           }
                                  //                       });
                                  //                 }
                                  //               },
                                  //               child: Container(
                                  //                 padding: EdgeInsets.only(
                                  //                     left: 8, right: 8),
                                  //                 margin: EdgeInsets.only(right: 10),
                                  //                 decoration: BoxDecoration(
                                  //                     border: Border.all(
                                  //                         color: ColorConstants
                                  //                             .colorAllHomeTitle,
                                  //                         width: 0.5),
                                  //                     borderRadius:
                                  //                         BorderRadius.circular(8)),
                                  //                 child: Row(
                                  //                   children: [
                                  //                     Align(
                                  //                       alignment: Alignment.center,
                                  //                       child: Text(
                                  //                         appliedFilter[index].name!,
                                  //                         style: TextStyle(
                                  //                             fontFamily: global
                                  //                                 .fontRailwayRegular,
                                  //                             fontWeight:
                                  //                                 FontWeight.w200,
                                  //                             fontSize: 12,
                                  //                             color: ColorConstants
                                  //                                 .pureBlack),
                                  //                       ),
                                  //                     ),
                                  //                     appliedFilter[index]
                                  //                             .isFilterValue!
                                  //                         ? SizedBox(
                                  //                             width: 8,
                                  //                           )
                                  //                         : SizedBox(),
                                  //                     appliedFilter[index]
                                  //                             .isFilterValue!
                                  //                         ? InkWell(
                                  //                             onTap: () {
                                  //                               if (appliedFilter[
                                  //                                           index]
                                  //                                       .type ==
                                  //                                   "1") {
                                  //                                 _productFilter
                                  //                                     .filterPriceID = "";
                                  //                                 _productFilter
                                  //                                     .filterPriceValue = "";
                                  //                               }
                                  //                               if (appliedFilter[
                                  //                                           index]
                                  //                                       .type ==
                                  //                                   "2") {
                                  //                                 _productFilter
                                  //                                     .filterDiscountID = "";
                                  //                                 _productFilter
                                  //                                     .filterDiscountValue = "";
                                  //                               }
                                  //                               if (appliedFilter[
                                  //                                           index]
                                  //                                       .type ==
                                  //                                   "3") {
                                  //                                 _productFilter
                                  //                                     .filterSortID = "";
                                  //                                 _productFilter
                                  //                                     .filterSortValue = "";
                                  //                               }
                                  //                               if (appliedFilter[
                                  //                                           index]
                                  //                                       .type ==
                                  //                                   "4") {
                                  //                                 _productFilter
                                  //                                     .filterOcassionID = "";
                                  //                                 _productFilter
                                  //                                     .filterOcassionValue = "";
                                  //                               }
                                  //                               if (_productsList !=
                                  //                                       null &&
                                  //                                   _productsList
                                  //                                           .length >
                                  //                                       0) {
                                  //                                 _productsList
                                  //                                     .clear();
                                  //                                 // _isDataLoaded =
                                  //                                 //     false;
                                  //                               }
                                  //                               appliedFilter
                                  //                                   .removeAt(index);
                                  //                               // if (appliedFilter
                                  //                               //         .length ==
                                  //                               //     0) {
                                  //                               //   isfilterApplied =
                                  //                               //       false;
                                  //                               //   setState(() {});
                                  //                               // }
                                  //                               if (!global
                                  //                                   .isEventProduct) {
                                  //                                 if (_productsList !=
                                  //                                         null &&
                                  //                                     _productsList
                                  //                                             .length >
                                  //                                         0) {
                                  //                                   _productsList
                                  //                                       .clear();
                                  //                                   // _isDataLoaded =
                                  //                                   //     false;
                                  //                                 }
                                  //                                 if (!global
                                  //                                     .isSubCatSelected) {
                                  //                                   // print(
                                  //                                   //     "This is category id---- ${categoryId}");
                                  //                                   _getCategoryProduct(
                                  //                                       global
                                  //                                           .homeSelectedCatID); // _init();
                                  //                                 } else {
                                  //                                   // print(
                                  //                                   //     "This is Subcategory id---- ${categoryId}");
                                  //                                   _getSubCategoryProduct(
                                  //                                       global
                                  //                                           .homeSelectedCatID);
                                  //                                 }
                                  //                                 isSelectedCat = 0;
                                  //                               } else {
                                  //                                 // print(
                                  //                                 //     "niks This is _getEventProduct cat id---- ${categoryId}");
                                  //                                 _getEventProduct(global
                                  //                                     .homeSelectedCatID);
                                  //                               }
                                  //                             },
                                  //                             child: Icon(
                                  //                               Icons.cancel,
                                  //                               size: 20,
                                  //                               color: ColorConstants
                                  //                                   .newAppColor,
                                  //                             ),
                                  //                           )
                                  //                         : SizedBox(),
                                  //                   ],
                                  //                 ),
                                  //               ),
                                  //             )),
                                  //   ),

                                  // ),
                                ],
                              ),
                            ),
                          )
                        : Container(),

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
                                          isEventProducts = false;
                                          selectedSubCatID.clear();

                                          print(
                                              "checkkkkkkk clear value ${selectedSubCatID}");
                                          categoriesSelectedIndex = index;
                                          subCateSelectIndex = -1;
                                          selectedCatID =
                                              _categoryList[index].catId;
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

                                          // if (!global.isEventProduct) {
                                          //   global.homeSelectedCatID =
                                          //       _categoryList[
                                          //               categoriesSelectedIndex!]
                                          //           .catId!;
                                          // _getCategoryProduct(
                                          //     global.homeSelectedCatID);
                                          // if (_productsList != null &&
                                          //     _productsList.length > 0) {
                                          //   _productsList.clear();
                                          //   // _isDataLoaded =
                                          //   //     false,
                                          // }
                                          if (!global.isSubCatSelected) {
                                            // print(
                                            //     "This is category id---- ${categoryId}");
                                            _getCategoryProduct(
                                                _categoryList[index].catId!);
                                          } else {
                                            // print(
                                            //     "This is Subcategory id---- ${categoryId}");
                                            _getSubCategoryProduct(
                                                global.homeSelectedCatID);
                                          }
                                          isSelectedCat = 0;
                                          // } else {
                                          //   selectedCatID = _categoryList[
                                          //           categoriesSelectedIndex!]
                                          //       .catId!;
                                          //   // print(
                                          //   //     "niks This is _getEventProduct cat id---- ${categoryId}");
                                          //   _getEventProduct(
                                          //       global.homeSelectedCatID);
                                          // }
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
    );
  }

  bool isSortOpen = false;
  String loadingOrError = "loading";

  @override
  void initState() {
    print(categoryId);
    print("checkkkkkkkk1111>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    print(selectedSubCatID);
    

//     print("${minAge}, ${maxAge}, 0, 0, , 0, page, null, null, ${deliveryType}");
//  print("checkkkkkkkk1111>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${deliveryType}");
//     print("checkkkkkkkk1111>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.${global.isSubCatSelected}");
// //  getFilteredProductsAPICall(deliveryType);
//     print("CHECK IDDDDDDDDDD>>>>>>>>>>>>>>>>>${categoryId}");
    super.initState();
   
    selectedCatID = categoryId;
    _getCategoryList();
    _productsList.clear();
    _init();
    global.total_delivery_count = 1;
    if (!global.isEventProduct) {
      // _getCategoryList();
      _isProductLoaded = false;
      // _getSubCategoryList(global.parentCatID);
      if (!global.isSubCatSelected) {
        print("555555555>>>>>>>>");
        _getCategoryProduct(categoryId!); 
        // _init();
      } else if (global.isSubCatSelected =
          true && screenHeading != "Express" && screenHeading != "recipients") {
            selectedSubCatID.add(categoryId.toString()); 
        print("666666666666666666>>>>>>>>");
        print(_subCategoryList);
        _getSubCategoryProduct(global.homeSelectedCatID);
      } else if (screenHeading == "Express" && screenHeading != "recipients") {
        // productFilterDelivery();
        print("666666666666666666>>>>>>>>------");

        getFilteredProductsAPICall(deliveryType);
      } else if (screenHeading == "recipients") {
        getFilteredProductsAPICall(deliveryType);
      }

      isSelectedCat = 0;
    } else {
      _isProductLoaded = true;
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

  void saveSelectedIds(String category, List<String> ids) {
    print("G1----->$category &&&& $ids");
    switch (category) {
      case "Occasion":
        selectedOccasionIds = ids;
        break;
      case "Delivery Type": // must match selectedMap keySelected 111111111
        selecteddeliveryIds = ids;
        break;
      case "Color Palette":
        selectedcolorsIds = ids;
        break;
      case "Packaging": // must match selectedMap key
        selectedpacksIds = ids;
        break;
      case "Plants":
        selectedplantsIds = ids;
        break;
      case "Flavours":
        selectedflavoursIds = ids;
        break;
      case "Variants":
        selectedvariantsIds = ids;
        break;
      case "Type":
        selectedtypesIds = ids;
        break;
    }
  }

//FILTER EXPANDED UI BELOW 22222222
  Widget buildFiltersDrawerExpansion(
    BuildContext context, {
    int productsFound = 0,
    required void Function(Map<String, List<String>> selectedFilters) onApply,
  }) {
    final List<FilterCategory> categories = filterList
        .map<FilterCategory>((v) {
          if (v is FilterCategory) return v;
          if (v is Map<String, dynamic>)
            return FilterCategory.fromJson(v.items as Map<String, dynamic>);
          try {
            return FilterCategory.fromJson(Map<String, dynamic>.from(v as Map));
          } catch (_) {
            return FilterCategory(title: null, items: []);
          }
        })
        .where((c) => (c.items != null && c.items!.isNotEmpty))
        .toList();

    /// 🔥 Each category holds SET of SELECTED ITEM IDs
    // final Map<String, Set<String>> selectedOptions = {
    //   for (var c in categories) (c.title ?? "Unknown"): <String>{}
    // };
    final Map<String, Set<String>> selectedOptions = {
      for (var c in categories)
        (c.title ?? "Unknown"): {
          if (c.title == "Occasion") ...selectedOccasionIds,
          if (c.title == "Delivery Type") ...selecteddeliveryIds,
          if (c.title == "Color Palette") ...selectedcolorsIds,
          if (c.title == "Packaging") ...selectedpacksIds,
          if (c.title == "Plants") ...selectedplantsIds,
          if (c.title == "Flavours") ...selectedflavoursIds,
          if (c.title == "Variants") ...selectedvariantsIds,
          if (c.title == "Type") ...selectedtypesIds,
        }
    };

    final Map<String, bool> expansionState = {
      for (var c in categories) (c.title ?? "Unknown"): false
    };

    const int maxVisibleItems = 8;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Drawer(
        elevation: 8,
        child: SafeArea(
          child: StatefulBuilder(builder: (context, setState) {
            /// ✔ Toggle check/uncheck using ID
            void toggleOption(String category, String itemId) {
              final set = selectedOptions[category]!;
              setState(() {
                set.contains(itemId) ? set.remove(itemId) : set.add(itemId);
                print("Selected 111111111→ $category -> ${set.toList()}");
                saveSelectedIds(category, set.toList());
              });
            }

            void clearAll() {
              setState(() {
                selectedOptions.forEach((key, set) => set.clear());
              });
            }

            /// 🎯 Expansion per Category
            Widget buildCategory(FilterCategory cat) {
              final categoryTitle = cat.title ?? "Unknown";

              /// 🔥 Convert category items → map of id → name
              final List<Map<String, String>> optionList =
                  (cat.items ?? <FilterItem>[])
                      .map((it) {
                        return {
                          "id": (it.id?.toString() ?? ""),
                          "name": (it.name ?? it.type?.toString() ?? "")
                        };
                      })
                      .where((m) => m["id"]!.isNotEmpty)
                      .toList();

              final visibleCount = optionList.length <= maxVisibleItems
                  ? optionList.length
                  : maxVisibleItems;

              return Padding(
                padding: const EdgeInsets.only(top: 5, right: 5, left: 5),
                child: ExpansionTile(
                  key: PageStorageKey('exp_$categoryTitle'),
                  initiallyExpanded: expansionState[categoryTitle] ?? false,
                  title: Text(categoryTitle,
                      style: TextStyle(
                          color: const Color(0xff8B4A26),
                          fontFamily: fontRalewayMedium,
                          fontWeight: FontWeight.w700)),
                  iconColor: const Color(0xff8B4A26),
                  collapsedIconColor: const Color(0xff8B4A26),
                  childrenPadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  children: [
                    for (int idx = 0; idx < visibleCount; idx++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: _buildCheckboxTile(
                          category: categoryTitle,
                          optionName: optionList[idx]["name"]!,
                          itemId: optionList[idx]["id"]!,
                          checked: selectedOptions[categoryTitle]!
                              .contains(optionList[idx]["id"]!),
                          onToggle: () => toggleOption(
                              categoryTitle, optionList[idx]["id"]!),
                        ),
                      ),
                  ],
                  onExpansionChanged: (bool open) =>
                      setState(() => expansionState[categoryTitle] = open),
                ),
              );
            }

            return Column(
              children: [
                /// Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Color(0xff8B4A26), size: 20),
                        onPressed: () {
                          drawerSelectedOption = "";
                          // clearAll();
                          Navigator.of(context).maybePop();

                          // selectedOccasionIds.clear();
                          // selecteddeliveryIds.clear();
                          // selectedcolorsIds.clear();
                          // selectedpacksIds.clear();
                          // selectedplantsIds.clear();
                          // selectedflavoursIds.clear();
                          // selectedvariantsIds.clear();
                          // selectedtypesIds.clear();
                          // Slider1 = 0;
                          // Slider2 = 3999;

                          setState(() {
                            _getCategoryProduct(selectedCatID!);
                          }); // if you want UI to refresh
                        },
                      ),
                      const SizedBox(width: 8),
                      const Text('Filters',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff8B4A26))),
                      const Spacer(),
                      // TextButton(
                      //   onPressed: () {
                      //     clearAll();
                      //     selectedOccasionIds.clear();
                      //     selecteddeliveryIds.clear();
                      //     selectedcolorsIds.clear();
                      //     selectedpacksIds.clear();
                      //     selectedplantsIds.clear();
                      //     selectedflavoursIds.clear();
                      //     selectedvariantsIds.clear();
                      //     selectedtypesIds.clear();

                      //     Slider1 = 0;
                      //     Slider2 = 3999;

                      //     setState(() {}); // refresh UI
                      //   },
                      //   child: const Text("Clear All"),
                      // ),
                    ],
                  ),
                ),
//CHECK NEW SLIDER PRICE
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Price",
                        style: TextStyle(
                          color: ColorConstants.newAppColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // Slider (use a constrained width)
                      SizedBox(
                        height: 40,
                        width: 230,
                        child: RangeSlider(
                          values: RangeValues(
                            Slider1,
                            Slider2,
                          ),
                          min: 0,
                          max: 5000,
                          divisions: 5000, // optional: makes each step = 1
                          activeColor: ColorConstants.newAppColor,
                          inactiveColor: Colors.brown.shade100,
                          labels: RangeLabels(
                            'AED ${Slider1.round()}',
                            'AED ${Slider2.round()}',
                          ),
                          onChanged: (RangeValues values) {
                            setState(() {
                              double start = values.start;
                              double end = values.end;

                              // Ensure start is never greater than end
                              if (end < start) end = start;

                              Slider1 = start;
                              Slider2 = end;
                            });

                            print("Selected Min Price = ${Slider1.round()}");
                            print("Selected Max Price = ${Slider2.round()}");
                          },
                        ),
                      ),
                      Text(
                        'AED ${Slider1.round()} - AED ${Slider2!.round()}',
                        style: const TextStyle(
                          fontFamily: fontRalewayMedium,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: ColorConstants.newAppColor,
                        ),
                      ),
                    ],
                  ),
                ),

                ///CHECKKKKKKK NEW SLIDER >>>>>>>>>>>>>>>>>>>>
                Divider(height: 1, color: Colors.grey.shade300),

                Expanded(
                  child: categories.isEmpty
                      ? Center(child: Text("Loading..."))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: categories.length,
                          itemBuilder: (c, i) => buildCategory(categories[i]),
                        ),
                ),

                /// Footer
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    border:
                        Border(top: BorderSide(color: Colors.grey.shade200)),
                  ),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          clearAll();
                          // Navigator.of(context).maybePop();

                          selectedOccasionIds.clear();
                          selecteddeliveryIds.clear();
                          selectedcolorsIds.clear();
                          selectedpacksIds.clear();
                          selectedplantsIds.clear();
                          selectedflavoursIds.clear();
                          selectedvariantsIds.clear();
                          selectedtypesIds.clear();
                          Slider1 = 0;
                          Slider2 = 3999;

                          setState(() {
                            _getCategoryProduct(selectedCatID!);
                          }); // if you want UI to refresh
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize: const Size(140, 46),
                          side: const BorderSide(color: Colors.black12),
                        ),
                        child: const Text('Clear filter',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black)),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {

                          // Save IDs into arrays
                          selectedMap.forEach((category, set) {
                            print("G1------->$category    && $set");
                    
                            // saveSelectedIds(category, set.toList());
                          });
                         

                          // Debug print
                          print("Occasion       → $selectedOccasionIds");
                          print("Delivery       → $selecteddeliveryIds");
                          print("Colors         → $selectedcolorsIds");
                          print("Packs          → $selectedpacksIds");
                          print("Plants         → $selectedplantsIds");
                          print("Flavour        → $selectedflavoursIds");
                          print("Variants       → $selectedvariantsIds");
                          print("Types          → $selectedtypesIds");

                          Navigator.pop(context);
                          _productsList.clear;
                          page = 1;
                          _productsList = [];

                          if (global.isSubCatSelected == true) {
                            print("subcategoriesssss APIIII");

                            _getSubCategoryProduct(global.homeSelectedCatID);
                            setState(() {});
                          } else {
                            print("categoriesssss APIIII");
                            _getCategoryProduct(global.homeSelectedCatID);
                            setState(() {});
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstants.appColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                        ),
                        child: const Text(
                          "APPLY",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  /// ✔ Updated checkbox builder (shows name, stores ID)
  Widget _buildCheckboxTile({
    required String category,
    required String optionName,
    required String itemId,
    required bool checked,
    required VoidCallback onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: checked ? Color(0xffF5ECE6) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: checked ? ColorConstants.appColor : Colors.grey.shade300,
          width: 0.5,
        ),
      ),
      child: CheckboxListTile(
        value: checked,
        onChanged: (_) => onToggle(),
        activeColor: ColorConstants.appColor,
        checkColor: Colors.white,
        title: Text(optionName,
            style: TextStyle(
                color: checked ? ColorConstants.appColor : Colors.black87)),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      ),
    );
  }

  Widget sortDrawer({
    required List<Map<String, dynamic>> options,
    required Function(String selectedName) onSelectionChanged,
    required Function(String selectedId) onIdSelected,
    required VoidCallback onBack,
    required VoidCallback onClear,
  }) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 18),

            // Header Row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onBack,
                    // child: const Icon(Icons.arrow_back, size: 26),
                    child: const Icon(Icons.arrow_back_ios,
                        color: Color(0xff8B4A26), size: 20),
                  ),
                  const SizedBox(width: 20),
                  const Text("Sort",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: ColorConstants.newAppColor)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      for (var e in options) {
                        e["isSelected"] = false;
                      }
                      onClear();
                    },
                    child: const Text(
                      "Clear All",
                      style: TextStyle(
                        color: ColorConstants.appColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: options.length,
                separatorBuilder: (_, __) => const SizedBox(height: 15),
                itemBuilder: (context, index) {
                  final item = options[index];
                  final bool checked = item["isSelected"];

                  return Container(
                    decoration: BoxDecoration(
                      color: checked
                          ? const Color(0xffF5ECE6)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: checked
                            ? ColorConstants.appColor
                            : Colors.grey.shade300,
                        width: 0.8,
                      ),
                    ),
                    child: CheckboxListTile(
                      title: Text(
                        item["title"],
                        style: TextStyle(
                          color:
                              // checked ? Colors.brown : Colors.black,
                              ColorConstants.appColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      value: checked,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: ColorConstants.appColor,
                      onChanged: (_) {
                        // allow only 1 selection
                        for (var e in options) {
                          e["isSelected"] = false;
                        }
                        options[index]["isSelected"] = true;

                        onSelectionChanged(
                            item["title"]); // return selected name
                        onIdSelected(item["id"]); // return selected ID
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }

  // /// ------------------------------------------------------------

  // Widget _buildCheckboxTile({

  //   required String category,
  //   required String option,
  //   required bool checked,
  //   required VoidCallback onToggle,
  // }) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: checked ? Color(0xffF5ECE6) : Colors.transparent,
  //       borderRadius: BorderRadius.circular(8),
  //       border: Border.all(
  //         color: checked ? ColorConstants.appColor : Colors.grey.shade300,
  //         width: 0.5,
  //       ),
  //     ),
  //     child: CheckboxListTile(
  //       value: checked,
  //       onChanged: (_) => onToggle(),

  //       // Checkbox styling
  //       activeColor: ColorConstants.appColor,
  //       checkColor: Colors.white,

  //       title: Text(
  //         option,
  //         style: TextStyle(
  //           color: checked ? ColorConstants.appColor : Colors.black87,
  //           fontSize: 14,
  //           fontWeight: checked ? FontWeight.w600 : FontWeight.w400,
  //         ),
  //       ),

  //       controlAffinity: ListTileControlAffinity.leading,
  //       contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  //     ),
  //   );
  // }

  void callProductList() {
    _productsList.clear();
    global.total_delivery_count = 1;
    if (!global.isEventProduct) {
      _isProductLoaded = false;
      // _getSubCategoryList(global.parentCatID);
      if (!global.isSubCatSelected) {
        _getCategoryProduct(global.homeSelectedCatID); // _init();
      } else {
    selectedSubCatID.add(categoryId.toString()); 
    selectedSubCatID.add(categoryId.toString()); 
        _getSubCategoryProduct(selectedSubCatID);
      }

      isSelectedCat = 0;
    } else {
      _isProductLoaded = true;

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
              // print(_categoryList.toString());
              // print(
              //     "Niks all global.isSubCatSelected------------>${global.isSubCatSelected}  ");

              if (!global.isSubCatSelected) {
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
                      if (global.homeSelectedCatID ==
                          _categoryList[i].subcategory![j].catId) {
                        categoriesSelectedIndex = i;
                      }
                    }
                  }
                }
              }

              _subCategoryList.clear();
              if (categoriesSelectedIndex != null &&
                  categoriesSelectedIndex! >= 0) {
                for (int i = 0;
                    i <
                        _categoryList[categoriesSelectedIndex!]
                            .subcategory!
                            .length;
                    i++) {
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
    loadingOrError = "No product found";
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
      print("n1-------------3---------$page");

      // print("NIKS:---TOTAL>${subCatID}");
      List<Product> _tList = [];
      await apiHelper
          .getCategoryProducts(
              subCatID,
              page,
              _productFilter,
              global.isSubscription!,
              selectedOccasionIds,
              selecteddeliveryIds,
              selectedflavoursIds,
              selectedplantsIds,
              selectedpacksIds,
              selectedtypesIds,
              selectedcolorsIds,
              Slider1.toString(),
              Slider2.toString(),
              selectedSortID)
          .then((result) async {
        if (result.status == "1") {
          if (result != null) {
            // if (result.status == "1") {
            // List<Product> _tList = result.data;
            print(result);

            _tList.clear();
            _tList = result.data;
            if (page == 1) {
              print("n1-------------1---------");

              _productsList.clear();
            }
            if (_tList.isEmpty) {
              _isRecordPending = false;
            }
            _isMoreDataLoaded = false;

            if (_tList.length > 0) {
              print("n1------------------2----");

              _productsList.addAll(_tList);

              //_productsList.addAll(_tList);
              print("n1------------------2----${_productsList.length}");
              _isDataLoaded = true;
              _isProductLoaded = true;
              setState(() {
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

  _getSubCategoryProduct(dynamic subCatID) async {
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
      List<Product> _tList = [];
      await apiHelper
          .getSubCategoryProducts(
              selectedSubCatID,
              page,
              _productFilter,
              global.isSubscription!,
              selectedOccasionIds,
              selecteddeliveryIds,
              selectedflavoursIds,
              selectedplantsIds,
              selectedpacksIds,
              selectedtypesIds,
              selectedcolorsIds,
              Slider1.toString(),
              Slider2.toString(),
              selectedSortID)
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
              _isDataLoaded = true;
              _isProductLoaded = true;

              setState(() {
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
      List<Product> _tList = [];
      await apiHelper
          .getEventFilteredProducts(
              eventID = categoryId!.toInt(),
              page,
              // selectedCatID != null ? selectedCatID.toString() :
              "",
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

                _isDataLoaded = true;

                setState(() {
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
                  loadingOrError = "No products Found>>";
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

            _subCategoryList.clear();
            _subCategoryList.addAll(_tList);

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

//product filter xpresssssssss code abhishek below
  // productFilterDelivery() async {
  //   // showOnlyLoaderDialog();

  //   try {
  //     final result = await apiHelper.productfilterExpress(
  //       userId: global.currentUser.id?.toString() ?? "",
  //     );
  //     List<Product> _tList = [];
  //     if (result.status == "1") {
  //       if (result != null) {
  //         // if (result.status == "1") {
  //         // List<Product> _tList = result.data;
  //         _tList.clear();
  //         _tList = result.data;
  //         if (page == 1) {
  //           _productsList.clear();
  //         }
  //         if (_tList.isEmpty) {
  //           _isRecordPending = false;
  //         }
  //         _isMoreDataLoaded = false;

  //         if (_tList.length > 0) {
  //           _productsList.addAll(_tList);

  //           //_productsList.addAll(_tList);

  //           _isDataLoaded = true;
  //           _isProductLoaded = true;
  //           setState(() {
  //             _isMoreDataLoaded = false;
  //           });
  //         }
  //         // }
  //         else {
  //           if (_productsList.length != null &&
  //               _productsList.length == 0 &&
  //               _productFilter != null &&
  //               (_productFilter.filterDiscountID != null ||
  //                   _productFilter.filterOcassionID != null ||
  //                   _productFilter.filterPriceID != null ||
  //                   _productFilter.filterSortID != null)) {
  //             loadingOrError = "No products Found";
  //           }
  //           setState(() {
  //             _isDataLoaded = true;
  //             _isProductLoaded = true;
  //             _isMoreDataLoaded = false;
  //           });
  //         }
  //       } else {
  //         _isDataLoaded = true;
  //         _isProductLoaded = true;
  //         _isDataAvailable = true;
  //         if (_productsList.length != null && _productsList.length != 0) {
  //           _isRecordPending = false;

  //           loadingOrError = "Out of stock for now. \nCheck back soon for more";
  //         } else if (_productFilter != null &&
  //             (_productFilter.filterDiscountID != null ||
  //                 _productFilter.filterOcassionID != null ||
  //                 _productFilter.filterPriceID != null ||
  //                 _productFilter.filterSortID != null)) {
  //           loadingOrError = "No products Found";
  //         }
  //         setState(() {});
  //       }
  //     } else {
  //       print("=== PRODUCT FILTER EXPRESS FAILED ===");
  //     }

  //     // hideLoader();
  //   } catch (e) {
  //     print("PRODUCT DELIVERY EXPRESS ERROR: $e");
  //     // hideLoader();
  //   }
  // }

//getFilteredProductsAPICall...G1
  getFilteredProductsAPICall(deliverytype) async {
    print("G1-------01");

    print(
        "${minAge}, ${maxAge}, 0, 0, ${recipientId ?? 0}, 0, page, null, null, ${deliverytype}");
    // showOnlyLoaderDialog();

    try {
      final result = await apiHelper.getFilteredProducts(minAge, maxAge, 0, 0,
          recipientId ?? 0, 0, page, null, null, deliverytype);
      ;

      List<Product> _tList = [];
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

            loadingOrError = "Out of stock for now. \nCheck back soon for more";
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
      }

      // hideLoader();
    } catch (e) {
      print("PRODUCT DELIVERY EXPRESS ERROR: $e");
      // hideLoader();
    }
  }

  newfiltersAPICALL(categoryId) async {
    try {
      final result = await apiHelper.newFilters(categoryId.toString());
     
      print("G1----->1");

      if (result != null && result.status == "1") {
        print("G1----->2");
        filterList.clear();

        // result.data is List<FilterCategory>
        final List<FilterCategory> categories = result.data ?? [];

        print("G1----->${categories}");

        filterList = categories;
        print("G1----->${filterList.length}");

        if (filterList.isNotEmpty) {
          _isDataLoaded = true;
          _isProductLoaded = true;
          setState(() {
            _isMoreDataLoaded = false;
          });
        } else {
          _isDataLoaded = true;
          _isProductLoaded = true;
          _isDataAvailable = true;
          setState(() {});
        }
      } else {
        // failure or empty
        _isDataLoaded = true;
        _isProductLoaded = true;
        _isDataAvailable = true;
        _isMoreDataLoaded = false;
        setState(() {});
      }
    } catch (e) {
      print("filter apiii>>>>>>>>>>>>>${e}");
    }
  }

  // newfiltersAPICALL1(categoryId) async {
  //   // showOnlyLoaderDialog();

  //   try {
  //     await apiHelper
  //         .newFilters(
  //       categoryId.toString(),
  //     )
  //         .then((result) async {
  //       print("G1----->1");

  //       if (result.status == "1") {
  //         print("G1----->2");
  //         if (result != null) {
  //           filterList.clear();
  //           print("G1----->${result.data}");

  //           filterList = result.data;
  //           print("G1----->${filterList.length}");

  //           if (filterList.length > 0) {
  //             //_productsList.addAll(_tList);

  //             _isDataLoaded = true;
  //             _isProductLoaded = true;
  //             setState(() {
  //               _isMoreDataLoaded = false;
  //             });
  //           }
  //         } else {
  //           _isDataLoaded = true;
  //           _isProductLoaded = true;
  //           _isDataAvailable = true;

  //           setState(() {});

  //           // page++;
  //         }
  //       } else {
  //         _isDataLoaded = true;
  //         _isProductLoaded = true;
  //         _isDataAvailable = true;
  //         _isMoreDataLoaded = false;
  //         setState(() {});
  //       }
  //     });
  //   } catch (e) {
  //     // hideLoader();
  //     print("filter apiii>>>>>>>>>>>>>${e}");
  //   }
  // }
 callHomeScreenSetState() {
    print("this is home screen setState called");

    setState(() {});
  }
//product filter xpressss code above abhishek
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
//save selected ID's in Array function code
