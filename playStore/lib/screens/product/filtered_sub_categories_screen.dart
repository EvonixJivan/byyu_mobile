//import 'dart:async';

import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/models/categoryListModel.dart';
import 'package:byyu/screens/filter_screen.dart';
import 'package:byyu/screens/home_screen.dart';
import 'package:byyu/screens/search_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:shimmer/shimmer.dart';
import 'package:byyu/constants/color_constants.dart';

import 'package:byyu/controllers/cart_controller.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/categoryProductModel.dart';
import 'package:byyu/models/homeScreenDataModel.dart';
import 'package:byyu/models/productFilterModel.dart';
import 'package:byyu/models/subCategoryModel.dart';

import 'package:byyu/widgets/products_menu.dart';

import 'package:byyu/models/businessLayer/global.dart' as global;

class FilteredSubCategoriesScreen extends BaseRoute {
  final int? minAge;
  final int? maxAge;
  final int? genderID;
  final int? relationID;
  final int? ocassionID;

  @required
  int? subscriptionProduct;

  FilteredSubCategoriesScreen({
    a,
    o,
    this.minAge,
    this.maxAge,
    this.genderID,
    this.relationID,
    this.ocassionID,
  }) : super(a: a, o: o, r: 'SubCategoriesScreen');

  @override
  _FilteredSubCategoriesScreenState createState() =>
      _FilteredSubCategoriesScreenState(
          minAge: minAge,
          maxAge: maxAge,
          genderID: genderID,
          relationID: relationID,
          ocassionID: ocassionID);
}

class _FilteredSubCategoriesScreenState extends BaseRouteState {
  int? categoryId;
  int _selectedIndex = 0;
  int? subscriptionProduct;
  bool _isDataLoaded = false;
  bool _isDataLoading = false;
  int? screenId;
  String? screenHeading;
  bool _isRecordPending = true;
  bool _isMoreDataLoaded = false;
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController1 = ScrollController();

  int selectedCardID = 0;
  String selctedSubCat = "";
  int page = 1;
  int isSelectedCat = 0;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Product> _trendingSearchBrand = [];
  bool? isSubcategory;
  bool? isEventProducts;
  String errorMessage = "Loading...";

  final int? minAge;
  final int? maxAge;
  final int? genderID;
  final int? relationID;
  final int? ocassionID;

  int? subCateSelectIndex;
  int? categoriesSelectedIndex;
  int? selectedCatID;
  bool isfilterApplied = false;
  bool _issubCatDataLoaded = false;
  List<CategoryList> _categoryList = [];
  List<SubCateeList> _subCategoryList = [];
   List<AppliedFilterList> appliedFilter = [];
  List<String> filterTypes = [];

  _FilteredSubCategoriesScreenState(
      {this.minAge,
      this.maxAge,
      this.genderID,
      this.relationID,
      this.ocassionID});

  @override
  Widget build(BuildContext context) {
    // TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: global.whitebackground,
      appBar: AppBar(
        backgroundColor: ColorConstants.white,
        centerTitle: false,
        title: InkWell(
          onTap: () {
            print("###################################################");
        global.occasionName="";
        global.genderID="";
        global.relationshipID= "";
        global.maxAge ="";
        global.minAge ="";
        global.occasionID ="";
            Navigator.of(context).push(MaterialPageRoute(
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
              if((global.occasionName!=null && global.occasionName.length>0) &&
        (global.genderID !=null && global.occasionName.length>0) &&
        (global.relationshipID !=null && global.relationshipID.length>0) &&
        (global.maxAge !=null && global.maxAge.length>0) &&
        (global.minAge !=null && global.minAge.length>0) &&
        (global.occasionID !=null && global.occasionID.length>0)
       ){
              global.occasionName="";
        global.genderID="";
        global.relationshipID= "";
        global.maxAge ="";
        global.minAge ="";
        global.occasionID ="";
        Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomeScreen(
                      a: widget.analytics,
                      o: widget.observer,
                      selectedIndex: 0,
                    )));
        }else{
              Navigator.of(context).pop();
        }
            },
            //icon: Icon(Icons.keyboard_arrow_left),
            color: ColorConstants.pureBlack),
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SearchScreen(
                        a: widget.analytics,
                        o: widget.observer,
                      )));
            },
            child: Icon(
              Icons.search,
              size: 25,
              color: ColorConstants.allIconsBlack45,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Stack(
            children: [
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomeScreen(
                              a: widget.analytics,
                              o: widget.observer,
                              selectedIndex: 2,
                            )));
                  },
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    size: 25,
                    color: ColorConstants.allIconsBlack45,
                  ),
                ),
              ),
              global.cartCount != 0 && global.cartCount <= 10
                  ? new Positioned(
                      right: 1,
                      top: 8,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
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
          padding: const EdgeInsets.only(left: 1, right: 1, top: 5, bottom: 0),
          child: _isDataLoaded
              ? 
              
              Column(
                children: [
                      _issubCatDataLoaded
                            ? categoriesSelectedIndex !=null && categoriesSelectedIndex!>=0 && _subCategoryList!=null && _subCategoryList.length>0?Container(
                              color: ColorConstants.filterColor,
                                height: MediaQuery.of(context).size.width / 5.4,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    categoriesSelectedIndex!=null && categoriesSelectedIndex!>=0?SizedBox(height: 8,):SizedBox(),
                                    categoriesSelectedIndex!=null && categoriesSelectedIndex!>=0?Container(
                              padding: EdgeInsets.only(left: 8,right: 8),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _categoryList[categoriesSelectedIndex!].title!,
                                  style: TextStyle(
                                      fontFamily: global.fontRailwayRegular,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: ColorConstants.pureBlack),
                                ),
                              ),
                            ):SizedBox(),
                            // categoriesSelectedIndex!=null && categoriesSelectedIndex!>=0?Container(
                            //   height: ColorConstants.filterdividerheight,
                            //   width: ColorConstants.filterdividerWidth,
                            //   color: ColorConstants.filterDivderColor,
                            // ):SizedBox(),
                            categoriesSelectedIndex!=null && categoriesSelectedIndex!>=0?SizedBox(
                              width: 10,
                            ):SizedBox(),
                                    Expanded(
                                      child: Visibility(
                                        visible: _subCategoryList!=null && _subCategoryList.length>0,
                                        child: Container(
                                          padding: EdgeInsets.only(top: 1,bottom: 5),
                                          child: ListView.builder(
                                            itemCount: _subCategoryList.length,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                  ),
                                                  // width: 65,
                                                  margin: EdgeInsets.all(5),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      subCateSelectIndex = index;
                                                      _productsList.clear();
                                                      global.isSubCatSelected=true;
                                                      selectedCatID=_categoryList[categoriesSelectedIndex!].subcategory![subCateSelectIndex!].catId!;
                                                      _isDataLoading=false;
                                                      _getCategoryProduct();
                                                      setState(() {});
                                                    },
                                                    child: Column(
                                                      children: [
                                                        
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(top: 4),
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
                                                                decoration:
                                                                    BoxDecoration(
                                                                        color: Colors
                                                                            .white38),
                                                                child:
                                                                    subCateSelectIndex ==
                                                                            index
                                                                        ? Container(
                                                                            // width: 65,
                                                                            padding: EdgeInsets.only(
                                                                                top: 5,
                                                                                bottom:
                                                                                    5,
                                                                                left: 8,
                                                                                right:
                                                                                    8),
                                                                            decoration: BoxDecoration(
                                                                                color: ColorConstants
                                                                                    .appColor,
                                                                                border: Border.all(
                                                                                    color: ColorConstants
                                                                                        .grey,
                                                                                    width:
                                                                                        0.5),
                                                                                borderRadius:
                                                                                    BorderRadius.circular(8)),
                                                                            child: Text(
                                                                              "${_subCategoryList[index].title}",
                                                                              maxLines:
                                                                                  2,
                                                                              textAlign:
                                                                                  TextAlign
                                                                                      .center,
                                                                              style: TextStyle(
                                                                                  fontFamily: global
                                                                                      .fontRailwayRegular,
                                                                                  fontWeight: FontWeight
                                                                                      .w200,
                                                                                  fontSize:
                                                                                      12,
                                                                                  overflow: TextOverflow
                                                                                      .ellipsis,
                                                                                  color: subCateSelectIndex == index
                                                                                      ? Colors.white
                                                                                      : Colors.black),
                                                                            ),
                                                                          )
                                                                        : Container(
                                                                            // else  condition
                                          
                                                                            // width: 55,
                                                                            padding: EdgeInsets.only(
                                                                                top: 5,
                                                                                bottom:
                                                                                    5,
                                                                                left: 8,
                                                                                right:
                                                                                    8),
                                                                            decoration: BoxDecoration(
                                                                                border: Border.all(
                                                                                    color: ColorConstants
                                                                                        .grey,
                                                                                    width:
                                                                                        0.5),
                                                                                borderRadius:
                                                                                    BorderRadius.circular(8)),
                                                                            child: Text(
                                                                              "${_subCategoryList[index].title}",
                                                                              maxLines:
                                                                                  1,
                                                                              textAlign:
                                                                                  TextAlign
                                                                                      .center,
                                                                              style: TextStyle(
                                                                                  fontFamily: global
                                                                                      .fontRailwayRegular,
                                                                                  fontWeight: FontWeight
                                                                                      .w200,
                                                                                  fontSize:
                                                                                      12,
                                                                                  overflow: TextOverflow
                                                                                      .ellipsis,
                                                                                  color: subCateSelectIndex == index
                                                                                      ? ColorConstants.appColor
                                                                                      : Colors.black),
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
                            :SizedBox(): Container(
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
                                height: 30,
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
                                                        print(value),
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
                                                                    appliedFilter.add(
                                                            new AppliedFilterList(
                                                                type: "0",
                                                                name: "Occasion",
                                                                isFilterValue:
                                                                    false)),
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
                                                          _isDataLoading=false,
                                                        _getCategoryProduct(),
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
                                                top: 3,
                                                bottom: 3,
                                                left: 8,
                                                right: 8),
                                            margin: EdgeInsets.only(right: 10),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: ColorConstants.grey,
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
                                                        fontFamily: global.fontRailwayRegular,
                                                                                fontWeight: FontWeight
                                                                                    .w200,
                                                                                fontSize:
                                                                                    12,
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
                                                            _productFilter.filterPriceValue="";    
                                                          }
                                                          if (appliedFilter[
                                                                      index]
                                                                  .type ==
                                                              "2") {
                                                            _productFilter
                                                                .filterDiscountID = "";
                                                                _productFilter.filterDiscountValue=""; 
                                                          }
                                                          if (appliedFilter[
                                                                      index]
                                                                  .type ==
                                                              "3") {
                                                            _productFilter
                                                                .filterSortID = "";
                                                                _productFilter.filterSortValue=""; 
                                                          }
                                                          if (appliedFilter[
                                                                      index]
                                                                  .type ==
                                                              "4") {
                                                            _productFilter
                                                                .filterOcassionID = "";
                                                                _productFilter.filterOcassionValue=""; 
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
                                                          _isDataLoading=false;
                                                          _getCategoryProduct();
                                                        },
                                                        child: Icon(
                                                          Icons.cancel,
                                                          size: 20,
                                                          color: ColorConstants
                                                              .pureBlack,
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
                    // Expanded(
                    //           child: Row(
                    //             children: [
                    //               Visibility(
                    //                 visible: true,
                    //                 child: Container(
                    //                   width:
                    //                       MediaQuery.of(context).size.width / 5,
                    //                   child: ListView.builder(
                    //                     itemCount: _categoryList.length,
                    //                     shrinkWrap: true,
                    //                     scrollDirection: Axis.vertical,
                    //                     itemBuilder: (context, index) {
                    //                       return Container(
                    //                           width: 80,
                    //                           margin: EdgeInsets.all(5),
                    //                           child: GestureDetector(
                    //                             onTap: () {
                    //                               categoriesSelectedIndex =
                    //                                   index;
                    //                               subCateSelectIndex = -1;
                                                  
                    //                                selectedCatID=
                    //                                   _categoryList[
                    //                                           index]
                    //                                       .catId!;
                    //                               _productsList.clear();

                    //                               if (_categoryList[
                    //                                               categoriesSelectedIndex!]
                    //                                           .subcategory !=
                    //                                       null &&
                    //                                   _categoryList[
                    //                                               categoriesSelectedIndex!]
                    //                                           .subcategory!
                    //                                           .length >
                    //                                       0) {
                    //                                 _subCategoryList.clear();
                    //                                 for (int i = 0;
                    //                                     i <
                    //                                         _categoryList[
                    //                                                 categoriesSelectedIndex!]
                    //                                             .subcategory!
                    //                                             .length;
                    //                                     i++) {
                    //                                   _subCategoryList.add(new SubCateeList(
                    //                                       catId: _categoryList[
                    //                                               categoriesSelectedIndex!]
                    //                                           .subcategory![i]
                    //                                           .catId,
                    //                                       title: _categoryList[
                    //                                               categoriesSelectedIndex!]
                    //                                           .subcategory![i]
                    //                                           .title,
                    //                                       image: _categoryList[
                    //                                               categoriesSelectedIndex!]
                    //                                           .subcategory![i]
                    //                                           .image,
                    //                                       parent: _categoryList[
                    //                                               categoriesSelectedIndex!]
                    //                                           .subcategory![i]
                    //                                           .parent));
                    //                                 }
                    //                               } else {
                    //                                 for (int i = 0;
                    //                                     i <
                    //                                         _categoryList[
                    //                                                 categoriesSelectedIndex!]
                    //                                             .subcategory!
                    //                                             .length;
                    //                                     i++) {
                    //                                   _subCategoryList.add(new SubCateeList(
                    //                                       catId: _categoryList[
                    //                                               categoriesSelectedIndex!]
                    //                                           .subcategory![i]
                    //                                           .catId,
                    //                                       title: _categoryList[
                    //                                               categoriesSelectedIndex!]
                    //                                           .subcategory![i]
                    //                                           .title,
                    //                                       image: _categoryList[
                    //                                               categoriesSelectedIndex!]
                    //                                           .subcategory![i]
                    //                                           .image,
                    //                                       parent: _categoryList[
                    //                                               categoriesSelectedIndex!]
                    //                                           .subcategory![i]
                    //                                           .parent));
                    //                                 }
                    //                               }
                    //                               global.isSubCatSelected =
                    //                                   false;
                    //                                   _isDataLoading=false;
                    //                               _getCategoryProduct();
                    //                               setState(() {});
                    //                             },
                    //                             child: Column(
                    //                               children: [
                    //                                 Container(
                    //                                   width: 80,
                    //                                   height: 60,
                    //                                   child: Card(
                    //                                     elevation: 0,
                    //                                     shadowColor:
                    //                                         Colors.transparent,
                    //                                     shape:
                    //                                         RoundedRectangleBorder(
                    //                                       borderRadius:
                    //                                           BorderRadius
                    //                                               .circular(
                    //                                                   8.0),
                    //                                     ),
                    //                                     margin: EdgeInsets.only(
                    //                                         left: 1, right: 1),
                    //                                     child: Column(
                    //                                       children: [
                    //                                         ClipRRect(
                    //                                           borderRadius:
                    //                                               BorderRadius
                    //                                                   .circular(
                    //                                                       8),
                    //                                           child: Container(
                    //                                             decoration:
                    //                                                 BoxDecoration(
                    //                                               color: Colors
                    //                                                   .transparent,
                    //                                               borderRadius:
                    //                                                   BorderRadius
                    //                                                       .circular(
                    //                                                           10),
                    //                                               // border: Border.all(
                    //                                               //     color: isSelectedIndex == index
                    //                                               //         ? ColorConstants.appColor
                    //                                               //         : Colors.white),
                    //                                             ),
                    //                                             width: 60,
                    //                                             height: 60,
                    //                                             child:
                    //                                                 CachedNetworkImage(
                    //                                               height: 40,
                    //                                               width: 40,
                    //                                               imageUrl: imageBaseUrl +
                    //                                                   _categoryList[
                    //                                                           index]
                    //                                                       .image!,
                    //                                               imageBuilder:
                    //                                                   (context,
                    //                                                           imageProvider) =>
                    //                                                       Container(
                    //                                                 height: double
                    //                                                     .infinity,
                    //                                                 width: double
                    //                                                     .infinity,
                    //                                                 decoration:
                    //                                                     BoxDecoration(
                    //                                                   color: Colors
                    //                                                       .transparent,
                    //                                                   // borderRadius: BorderRadius.circular(10),
                    //                                                   image:
                    //                                                       DecorationImage(
                    //                                                     image:
                    //                                                         imageProvider,
                    //                                                     fit: BoxFit
                    //                                                         .contain,
                    //                                                     alignment:
                    //                                                         Alignment.center,
                    //                                                   ),
                    //                                                 ),
                    //                                               ),
                    //                                               placeholder: (context,
                    //                                                       url) =>
                    //                                                   Center(
                    //                                                       child:
                    //                                                           CircularProgressIndicator()),
                    //                                               errorWidget: (context,
                    //                                                       url,
                    //                                                       error) =>
                    //                                                   Container(
                    //                                                 decoration:
                    //                                                     BoxDecoration(
                    //                                                   // borderRadius: BorderRadius.circular(15),
                    //                                                   image:
                    //                                                       DecorationImage(
                    //                                                     image: AssetImage(
                    //                                                         global.catNoImage),
                    //                                                     fit: BoxFit
                    //                                                         .contain,
                    //                                                   ),
                    //                                                 ),
                    //                                               ),
                    //                                             ),
                    //                                           ),
                    //                                         ),
                    //                                       ],
                    //                                     ),
                    //                                   ),
                    //                                 ),
                    //                                 Container(
                    //                                   margin: EdgeInsets.only(
                    //                                       top: 8),
                    //                                   child: Column(
                    //                                     mainAxisAlignment:
                    //                                         MainAxisAlignment
                    //                                             .end,
                    //                                     crossAxisAlignment:
                    //                                         CrossAxisAlignment
                    //                                             .center,
                    //                                     children: [
                    //                                       Container(
                    //                                         padding:
                    //                                             EdgeInsets.only(
                    //                                                 left: 1,
                    //                                                 right: 1),
                    //                                         decoration:
                    //                                             BoxDecoration(
                    //                                                 color: Colors
                    //                                                     .white38),
                    //                                         child:
                    //                                             categoriesSelectedIndex ==
                    //                                                     index
                    //                                                 ? Container(
                    //                                                     padding:
                    //                                                         EdgeInsets.all(3),
                    //                                                     decoration:
                    //                                                         BoxDecoration(
                    //                                                       color:
                    //                                                           ColorConstants.appColor,
                    //                                                       borderRadius:
                    //                                                           BorderRadius.circular(10),
                    //                                                     ),
                    //                                                     child:
                    //                                                         Text(
                    //                                                       "${_categoryList[index].title}",
                    //                                                       maxLines:
                    //                                                           2,
                    //                                                       textAlign:
                    //                                                           TextAlign.center,
                    //                                                       style: TextStyle(
                    //                                                           fontFamily: global.fontRailwayRegular,
                    //                                                           fontWeight: FontWeight.w200,
                    //                                                           fontSize: 10,
                    //                                                           overflow: TextOverflow.ellipsis,
                    //                                                           color: categoriesSelectedIndex == index ? Colors.white : Colors.black),
                    //                                                     ),
                    //                                                   )
                    //                                                 : Container(
                    //                                                     // else  condition
                    //                                                     padding:
                    //                                                         EdgeInsets.all(3),
                    //                                                     child:
                    //                                                         Text(
                    //                                                       "${_categoryList[index].title}",
                    //                                                       maxLines:
                    //                                                           2,
                    //                                                       textAlign:
                    //                                                           TextAlign.center,
                    //                                                       style: TextStyle(
                    //                                                           fontFamily: global.fontRailwayRegular,
                    //                                                           fontWeight: FontWeight.w200,
                    //                                                           fontSize: 10,
                    //                                                           overflow: TextOverflow.ellipsis,
                    //                                                           color: categoriesSelectedIndex == index ? ColorConstants.appColor : Colors.black),
                    //                                                     ),
                    //                                                   ),
                    //                                       ),

                    //                                       // Container(
                    //                                       //   padding: EdgeInsets
                    //                                       //       .only(
                    //                                       //           left: 1,
                    //                                       //           right: 1),
                    //                                       //   decoration:
                    //                                       //       BoxDecoration(
                    //                                       //           color: Colors
                    //                                       //               .white38),
                    //                                       //   child: Text(
                    //                                       //     "${_eventsList[index].eventName}",
                    //                                       //     maxLines: 2,
                    //                                       //     textAlign:
                    //                                       //         TextAlign
                    //                                       //             .center,
                    //                                       //     style: TextStyle(
                    //                                       //         fontFamily: global
                    //                                       //             .fontRailwayRegular,
                    //                                       //         fontWeight:
                    //                                       //             FontWeight
                    //                                       //                 .w200,
                    //                                       //         fontSize:
                    //                                       //             12,
                    //                                       //         overflow:
                    //                                       //             TextOverflow
                    //                                       //                 .ellipsis,
                    //                                       //         color: isSelectedIndex ==
                    //                                       //                 index
                    //                                       //             ? ColorConstants
                    //                                       //                 .appColor
                    //                                       //             : Colors
                    //                                       //                 .black),
                    //                                       //   ),
                    //                                       // ),
                    //                                     ],
                    //                                   ),
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                           ));
                    //                     },
                    //                   ),
                    //                 ),
                    //               ),
                                  
                    //               _isDataLoading?Expanded(child: Container(
                    //                 height: MediaQuery.of(context)
                    //                                 .size
                    //                                 .height,
                    //                                 child: Center(child: Container(height:30,width:30, child: CircularProgressIndicator())),
                    //               )):
                    //               Expanded(
                    //                 child: _isDataLoaded
                    //                     ? _productsList != null && 
                    //                             _productsList.length > 0
                    //                         ? Container(
                    //                             height: MediaQuery.of(context).size.height,
                    //                     child: SingleChildScrollView(
                    //                       scrollDirection: Axis.vertical,
                    //                       physics: AlwaysScrollableScrollPhysics(),
                    //                               controller:
                    //                                   _scrollController1,
                    //                               // physics: AlwaysScrollableScrollPhysics(),
                    //                               child: Column(
                    //                                 mainAxisAlignment: MainAxisAlignment.start,
                    //                         crossAxisAlignment: CrossAxisAlignment.start,
                    //                                 children: [
                    //                                   _isDataLoaded
                    //                                       ? ProductsMenu(
                    //                                           isSubCatgoriesScreen:
                    //                                               true,
                    //                                           analytics: widget
                    //                                               .analytics,
                    //                                           observer: widget
                    //                                               .observer,
                    //                                           categoryProductList:
                    //                                               _productsList,
                    //                                           isHomeSelected:
                    //                                               "SearchScreen",
                    //                                         )
                    //                                       : SizedBox(),
                    //                                   _isMoreDataLoaded
                    //                                       ? Center(
                    //                                           child:
                    //                                               CircularProgressIndicator(
                    //                                             backgroundColor:
                    //                                                 Colors
                    //                                                     .white,
                    //                                             strokeWidth: 1,
                    //                                           ),
                    //                                         )
                    //                                       : SizedBox()
                    //                                 ],
                    //                               ),
                    //                             ),
                    //                           )
                    //                         : Container(
                    //                             width: MediaQuery.of(context)
                    //                                 .size
                    //                                 .width,
                    //                             height: MediaQuery.of(context)
                    //                                 .size
                    //                                 .height,
                    //                             decoration: BoxDecoration(
                    //                               image: DecorationImage(
                    //                                   image: AssetImage(
                    //                                       "assets/images/login_bg.png"),
                    //                                   fit: BoxFit.cover),
                    //                             ),
                    //                             child: Padding(
                    //                               padding:
                    //                                   const EdgeInsets.only(
                    //                                       top: 200,
                    //                                       bottom: 200),
                    //                               child: Center(
                    //                                   child: Text(
                    //                                 "No products found",
                    //                                 textAlign: TextAlign.center,
                    //                                 style: TextStyle(
                    //                                     fontFamily:
                    //                                         fontMontserratLight,
                    //                                     fontSize: 20,
                    //                                     fontWeight:
                    //                                         FontWeight.w200,
                    //                                     color: ColorConstants
                    //                                         .guidlinesGolden),
                    //                               )),
                    //                             ),
                    //                           )
                    //                     : Center(
                    //                           child: CircularProgressIndicator(),
                    //                         ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                       
                  Expanded(
                    child: Row(
                      children: [
                        Visibility(
                                      visible: true,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width / 5,
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
                                                    categoriesSelectedIndex =
                                                        index;
                                                    subCateSelectIndex = -1;
                                                    
                                                     selectedCatID=
                                                        _categoryList[
                                                                index]
                                                            .catId!;
                                                            
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
                                                    global.isSubCatSelected =
                                                        false;
                                                        _isDataLoading=false;
                                                    _getCategoryProduct();
                                                    setState(() {});
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: 80,
                                                        height: 60,
                                                        child: Card(
                                                          elevation: 0,
                                                          shadowColor:
                                                              Colors.transparent,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          margin: EdgeInsets.only(
                                                              left: 1, right: 1),
                                                          child: Column(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                child: Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .transparent,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                10),
                                                                    // border: Border.all(
                                                                    //     color: isSelectedIndex == index
                                                                    //         ? ColorConstants.appColor
                                                                    //         : Colors.white),
                                                                  ),
                                                                  width: 60,
                                                                  height: 60,
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    height: 40,
                                                                    width: 40,
                                                                    imageUrl: imageBaseUrl +
                                                                        _categoryList[
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
                                                                        color: Colors
                                                                            .transparent,
                                                                        // borderRadius: BorderRadius.circular(10),
                                                                        image:
                                                                            DecorationImage(
                                                                          image:
                                                                              imageProvider,
                                                                          fit: BoxFit
                                                                              .contain,
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
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        // borderRadius: BorderRadius.circular(15),
                                                                        image:
                                                                            DecorationImage(
                                                                          image: AssetImage(
                                                                              global.catNoImage),
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
                                                              padding:
                                                                  EdgeInsets.only(
                                                                      left: 1,
                                                                      right: 1),
                                                              decoration:
                                                                  BoxDecoration(
                                                                      color: Colors
                                                                          .white38),
                                                              child:
                                                                  categoriesSelectedIndex ==
                                                                          index
                                                                      ? Container(
                                                                          padding:
                                                                              EdgeInsets.all(3),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                ColorConstants.appColor,
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          child:
                                                                              Text(
                                                                            "${_categoryList[index].title}",
                                                                            maxLines:
                                                                                2,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: TextStyle(
                                                                                fontFamily: global.fontRailwayRegular,
                                                                                fontWeight: FontWeight.w200,
                                                                                fontSize: 10,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                color: categoriesSelectedIndex == index ? Colors.white : Colors.black),
                                                                          ),
                                                                        )
                                                                      : Container(
                                                                          // else  condition
                                                                          padding:
                                                                              EdgeInsets.all(3),
                                                                          child:
                                                                              Text(
                                                                            "${_categoryList[index].title}",
                                                                            maxLines:
                                                                                2,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: TextStyle(
                                                                                fontFamily: global.fontRailwayRegular,
                                                                                fontWeight: FontWeight.w200,
                                                                                fontSize: 10,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                color: categoriesSelectedIndex == index ? ColorConstants.appColor : Colors.black),
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
                                   
                        _isDataLoading 
                            ? _productsList.length > 0
                                ? Expanded(
                                  child: Container(
                                    height: MediaQuery.of(context)
                                                      .size
                                                      .height,
                                    child: SingleChildScrollView(
                                        controller: _scrollController1,
                                        child: Column(
                                          children: [
                                            ProductsMenu(
                                              isSubCatgoriesScreen: true,           
                                              analytics: widget.analytics,
                                              observer: widget.observer,
                                              categoryProductList: _productsList,
                                              isHomeSelected: "subCat",
                                              passdata1: screenHeading,
                                              passdata2: categoryId,
                                              passdata3: subscriptionProduct,
                                            ),
                                          ],
                                        ),
                                      ),
                                  ),
                                )
                                : Expanded(
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.height,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage("assets/images/login_bg.png"),
                                            fit: BoxFit.cover),
                                      ),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Text(""),
                                            ),
                                            Text(
                                              'No Products Found',
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
                                                width:
                                                    MediaQuery.of(context).size.width - 50,
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
                                    ),
                                )
                            : Expanded(
                              child: Center(
                                                child: CircularProgressIndicator(),
                                              ),
                            ) 
                            ],
                    ),
                  ),
                ],
              )
              
              : Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }

  bool isSortOpen = false;

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

  @override
  void initState() {
    super.initState();

    _getCategoryList();

    _getCategoryProduct();
       appliedFilter.add(
        new AppliedFilterList(type: "0", name: "Price", isFilterValue: false));
    appliedFilter.add(new AppliedFilterList(
        type: "0", name: "Discount", isFilterValue: false));
    appliedFilter.add(
        new AppliedFilterList(type: "0", name: "Sort", isFilterValue: false));
    appliedFilter.add(
        new AppliedFilterList(type: "0", name: "Occasion", isFilterValue: false));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  _init() async {
    try {
      _productsList.clear();

      _scrollController1 = ScrollController()..addListener(_scrollListener);
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent &&
            !_isMoreDataLoaded) {
          setState(() {
            _isMoreDataLoaded = true;
          });
          setState(() {
            _isMoreDataLoaded = false;
          });
        }
      });

      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - sub_categories_screen.dart - _init():" + e.toString());
    }
  }

  double boundaryOffset = 0.5;
  int currentpage = 1;
  void _scrollListener() {
    print(_scrollController1.position.pixels);
    if (_scrollController1.offset >=
            _scrollController1.position.maxScrollExtent * 0.5 &&
        !_isMoreDataLoaded) {
      bool isTop = _scrollController1.position.pixels == 0.0;
      if (isTop) {
        print('At the top');
      } else {
        boundaryOffset = 1 - 1 / (currentpage * 2);
        _getCategoryProduct();
      }
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
  ProductFilter _productFilter = new ProductFilter();

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
             
              if (categoriesSelectedIndex != null &&
                  categoriesSelectedIndex! >= 0) {
                for (int i = 0;
                    i <
                        _categoryList[categoriesSelectedIndex!]
                            .subcategory!
                            .length;
                    i++) {
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

              setState(() {
                _isDataLoaded=true;
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
      print("Exception - searchScreenResult.dart - _getCategoryList():" +
          e.toString());
    }
  }


  _getCategoryProduct() async {
    print("Result");
    try {
      // if (_isRecordPending) {
      setState(() {
        
        _isMoreDataLoaded = true;
      });
      if (_productsList.isEmpty) {
        page = 1;
      } else {
        page = page + 1;
        _isDataLoading=false;
      }
      // print("G1:---TOTAL>${_productsList.length}");
      List<Product> _tList = [];
      await apiHelper
          .getFilteredProducts(
              minAge!, maxAge!, genderID!, ocassionID!, relationID!,page,_productFilter,selectedCatID!=null?selectedCatID.toString():"",global.isSubCatSelected?"sub":!global.isSubCatSelected && (selectedCatID != null && selectedCatID!>0) ?"parent":"")
          .then((result) async {
        if (result!=null && result.data != null) {
          // if (result.status == "1") {
          // List<Product> _tList = result.data;
          _tList.clear();
          _tList = result.data;
          _isDataLoaded = true;
          _isDataLoading = true;
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
            _isDataLoading = true;
            setState(() {
              _isMoreDataLoaded = true;
            });
            _isDataLoaded = true;
            _isDataLoading = true;
          }
          // }
          else {
            setState(() {
              _productsList.clear();
              _isDataLoaded = true;
              _isDataLoading = true;
              _isMoreDataLoaded = false;
            });
          }
        } else {
          _productsList.clear();
          _isDataLoaded = true;
          _isDataLoading = true;
          setState(() {});
        }
      });
      // }
    } catch (e) {
      _productsList.clear();
      _isDataLoaded = true;
      _isDataLoading = true;
      setState(() { });
      print("Exception - filteredsubCategoriesScreen.dart - _getCategoryProduct():" +
          e.toString());
    }
  }

  
  // show cart items
  final CartController cartController = Get.put(CartController());

  // API call for trending brand...
  
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
