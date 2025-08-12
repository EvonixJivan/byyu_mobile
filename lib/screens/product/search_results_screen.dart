//import 'package:byyu/constants/analytics_GA4.dart';
import 'package:byyu/constants/color_constants.dart';
//import 'package:byyu/models/appInfoModel.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/models/categoryListModel.dart';
import 'package:byyu/models/productDetailModel.dart';
import 'package:byyu/models/subCategoryModel.dart';
import 'package:byyu/screens/filter_screen.dart';
import 'package:byyu/screens/home_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
//import 'package:byyu/screens/home_screen.dart';
//import 'package:byyu/screens/product/productlist_screen.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:byyu/controllers/cart_controller.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/categoryProductModel.dart';
import 'package:byyu/models/productFilterModel.dart';

//import 'package:byyu/screens/search_screen.dart';
import 'package:byyu/theme/style.dart';

import 'package:byyu/widgets/products_menu.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:sms_autofill/sms_autofill.dart';

class SearchResultsScreen extends BaseRoute {
  @required
  final String? searchParams, subCatName;
  final searchScreen;
  final subCatID;

  SearchResultsScreen(
      {a,
      o,
      this.searchParams,
      this.searchScreen,
      this.subCatID,
      this.subCatName})
      : super(a: a, o: o, r: 'SearchResultsScreen');

  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState(
      searchParams: searchParams!,
      searchScreen: searchScreen,
      subCatID: subCatID,
      subCatName: subCatName ?? "");
}

class _SearchResultsScreenState extends BaseRouteState {
  String? searchParams, subCatName;
  String? searchScreen;
  List<Product> _productSearchResult = [];
  ProductFilter _productFilter = new ProductFilter();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDataLoaded = false;
  bool _isDataLoding = false;
  bool _isFilterApplied = false;
  TextEditingController _cSearch = new TextEditingController();
  int page = 1;
  int? subCatID;
  int? subCateSelectIndex;
  ScrollController _scrollController1 = ScrollController();
  bool _isMoreDataLoaded = false;
  ProductDetail _productDetail = new ProductDetail();
  List<String> _productImages = [];
  int? productId;
  ScrollController _scrollController = ScrollController();
  List<AppliedFilterList> appliedFilter = [];
  int? selectedCatID;
  final CartController cartController = Get.put(CartController());

  _SearchResultsScreenState({
    required this.searchParams,
    required searchScreen,
    required subCatID,
    required String subCatName,
  });
  int? _value = 1;

  updateData() {
    setState(() {});
    print("00000000");
    _productFilter = new ProductFilter();
    _isFilterApplied = false;
    appliedFilter.clear();
    appliedFilter.add(
        new AppliedFilterList(type: "0", name: "Price", isFilterValue: false));
    appliedFilter.add(new AppliedFilterList(
        type: "0", name: "Discount", isFilterValue: false));
    appliedFilter.add(
        new AppliedFilterList(type: "0", name: "Sort", isFilterValue: false));
    appliedFilter.add(new AppliedFilterList(
        type: "0", name: "Occasion", isFilterValue: false));
    if (_productSearchResult != null && _productSearchResult.length > 0) {
      _productSearchResult.clear();
      _isDataLoaded = false;
    }

    if (_productSearchResult != null && _productSearchResult.length > 0) {
      _productSearchResult.clear();
      _isDataLoaded = false;
    }
    print("G1---->Click");
    _getProductSearchResult();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () async {
        if (global.productSearchText != null &&
            global.productSearchText.length > 0) {
          print("Niks---------Search Result-----onWillPop--------------?");
          global.productSearchText = "";
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomeScreen(
                    a: widget.analytics,
                    o: widget.observer,
                    selectedIndex: 0,
                  )));
        } else {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
        return true;
        // if (searchScreen != 'sub_cat') {
        // return Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => SearchScreen(
        //               a: widget.analytics,
        //               o: widget.observer,
        //             )));
        // } else {
        //   Navigator.pop(context);
        // }
      },
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/login_bg.png"),
                    fit: BoxFit.cover)),
            child: Stack(
              children: [
                SafeArea(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await _onRefresh();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1.0),
                      child: GetBuilder<CartController>(
                        init: cartController,
                        builder: (value) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                ),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    BackButton(
                                        onPressed: () {
                                          // Get.to(() => HomeScreen(
                                          //       a: widget.analytics,
                                          //       o: widget.observer,
                                          //       selectedIndex: 0,
                                          //     ));
                                          if (global.productSearchText !=
                                                  null &&
                                              global.productSearchText.length >
                                                  0) {
                                            print(
                                                "Niks----------------------------?");
                                            global.productSearchText = "";
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            HomeScreen(
                                                              a: widget
                                                                  .analytics,
                                                              o: widget
                                                                  .observer,
                                                              selectedIndex: 0,
                                                            )));
                                          } else {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        //icon: Icon(Icons.keyboard_arrow_left),
                                        color: ColorConstants.pureBlack),

                                    SizedBox(width: 16),
                                    Expanded(
                                      child: TextFormField(
                                        cursorColor: Colors.grey[800],
                                        autofocus: false,
                                        controller: _cSearch,
                                        style: TextStyle(
                                            fontFamily: fontMetropolisRegular,
                                            color: ColorConstants.pureBlack),
                                        keyboardType: TextInputType.text,
                                        textCapitalization:
                                            TextCapitalization.none,
                                        obscureText: false,
                                        readOnly: false,
                                        maxLines: 1,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor:
                                              ColorConstants.appfaintColor,
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            borderSide: BorderSide(
                                                width: 0,
                                                color: ColorConstants.appColor,
                                                style: BorderStyle.none),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            borderSide: BorderSide(
                                                width: 0,
                                                color: ColorConstants.appColor,
                                                style: BorderStyle.none),
                                          ),
                                          suffixIcon: InkWell(
                                            onTap: () {
                                              // if (searchScreen == 'subCat') {
                                              // } else {
                                              _cSearch.clear();
                                              // }
                                            },
                                            child:
                                                // searchScreen == 'subCat'
                                                //     ? Text("")
                                                // :
                                                _cSearch.text != ""
                                                    ? Icon(Icons.cancel,
                                                        color: ColorConstants
                                                            .pureBlack)
                                                    : Text(""),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.search_outlined,
                                            color: ColorConstants.pureBlack,
                                          ),
                                          hintText: "Search product",
                                          //"${AppLocalizations.of(context).hnt_search_product}",
                                          hintStyle:
                                              textFieldHintStyle(context),
                                          contentPadding:
                                              EdgeInsets.only(bottom: 12.0),
                                        ),
                                        onFieldSubmitted: (val) async {
                                          if (val != null && val != '') {
                                            setState(() {
                                              print("G1---420");
                                              _productDetail.similarProductList!
                                                  .clear();
                                              _isDataLoaded = false;
                                              if (val != searchParams) {
                                                _isFilterApplied = false;
                                              }
                                              searchParams = val;
                                              _onRefresh();
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                    // Container(
                                    //   margin: EdgeInsets.only(left: 0.0, right: 5),
                                    //   child: IconButton(
                                    //     onPressed: () {
                                    //       _applyFilters();
                                    //     },
                                    //     icon: Icon(
                                    //       Icons.filter_alt,
                                    //       color: global.indigoColor,
                                    //       size: 30,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                )),
                            _productSearchResult != null &&
                                    _productSearchResult.length > 0
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 16.0, left: 5),
                                    child: _isDataLoaded
                                        ? Text(
                                            _productSearchResult != null &&
                                                    _productSearchResult
                                                            .length >
                                                        0
                                                ? "${_productSearchResult.length} Items Found"
                                                : "",
                                            style: TextStyle(
                                                fontFamily:
                                                    fontMetropolisRegular,
                                                fontSize: 16))
                                        : SizedBox(),
                                  )
                                : SizedBox(),
                            _issubCatDataLoaded
                                ? categoriesSelectedIndex != null &&
                                        categoriesSelectedIndex! >= 0 && _subCategoryList!=null && _subCategoryList.length>0
                                    ? Container(
                                        color: ColorConstants.filterColor,
                                        height:
                                            MediaQuery.of(context).size.width /
                                                5.4,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            categoriesSelectedIndex != null &&
                                                    categoriesSelectedIndex! >=
                                                        0
                                                ? SizedBox(
                                                    height: 8,
                                                  )
                                                : SizedBox(),
                                            categoriesSelectedIndex != null &&
                                                    categoriesSelectedIndex! >=
                                                        0
                                                ? Container(
                                                    padding: EdgeInsets.only(
                                                        left: 8, right: 8),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        _categoryList[
                                                                categoriesSelectedIndex!]
                                                            .title!,
                                                        style: TextStyle(
                                                            fontFamily: global
                                                                .fontMetropolisRegular,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 13,
                                                            color:
                                                                ColorConstants
                                                                    .pureBlack),
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
                                                    categoriesSelectedIndex! >=
                                                        0
                                                ? SizedBox(
                                                    width: 10,
                                                  )
                                                : SizedBox(),
                                            Expanded(
                                              child: Visibility(
                                                visible: _subCategoryList!=null && _subCategoryList.length>0,
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      top: 1, bottom: 5),
                                                  child: ListView.builder(
                                                    itemCount:
                                                        _subCategoryList.length,
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10),
                                                          ),
                                                          // width: 65,
                                                          margin:
                                                              EdgeInsets.all(5),
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              subCateSelectIndex =
                                                                  index;
                                                              _productSearchResult
                                                                  .clear();
                                                              global.isSubCatSelected =
                                                                  true;
                                                                  selectedCatID=
                                                        _categoryList[
                                                                categoriesSelectedIndex!].subcategory![subCateSelectIndex!]
                                                            .catId!;
                                                            // showToastMSG(selectedCatID.toString());
                                                          _getProductSearchResult();
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
                                                                  margin: EdgeInsets
                                                                      .only(
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
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                1,
                                                                            right:
                                                                                1),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                                color: Colors.white38),
                                                                        child: subCateSelectIndex ==
                                                                                index
                                                                            ? Container(
                                                                                // width: 65,
                                                                                padding: EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
                                                                                decoration: BoxDecoration(color: ColorConstants.appColor, border: Border.all(color: ColorConstants.grey, width: 0.5), borderRadius: BorderRadius.circular(8)),
                                                                                child: Text(
                                                                                  "${_subCategoryList[index].title}",
                                                                                  maxLines: 2,
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(fontFamily: global.fontMetropolisRegular, fontWeight: FontWeight.w200, fontSize: 12, overflow: TextOverflow.ellipsis, color: subCateSelectIndex == index ? Colors.white : Colors.black),
                                                                                ),
                                                                              )
                                                                            : Container(
                                                                                // else  condition
                                                
                                                                                // width: 55,
                                                                                padding: EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
                                                                                decoration: BoxDecoration(border: Border.all(color: ColorConstants.grey, width: 0.5), borderRadius: BorderRadius.circular(8)),
                                                                                child: Text(
                                                                                  "${_subCategoryList[index].title}",
                                                                                  maxLines: 1,
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(fontFamily: global.fontMetropolisRegular, fontWeight: FontWeight.w200, fontSize: 12, overflow: TextOverflow.ellipsis, color: subCateSelectIndex == index ? ColorConstants.appColor : Colors.black),
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
                                    height:
                                        MediaQuery.of(context).size.width / 5.5,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                            Container(
                              height: 60,
                              color: ColorConstants.white,
                              padding: EdgeInsets.only(
                                  bottom: 5, left: 10, right: 10),
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  Container(
                                    height: 50,
                                    padding: EdgeInsets.all(10),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Filters",
                                        style: TextStyle(
                                            fontFamily:
                                                global.fontMetropolisRegular,
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
                                  Expanded(
                                    child: Container(
                                      height: 30,
                                      child: ListView.builder(
                                          controller: _scrollController,
                                          physics:
                                              AlwaysScrollableScrollPhysics(),
                                          itemCount: appliedFilter.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) =>
                                              InkWell(
                                                onTap: () {
                                                  if (!appliedFilter[index]
                                                      .isFilterValue!) {
                                                    showModalBottomSheet(
                                                      // isDismissible: false,
                                                      backgroundColor:
                                                          Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20),
                                                          topRight:
                                                              Radius.circular(
                                                                  20),
                                                        ),
                                                      ),
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return FilterCustomSheet(
                                                          showFilters:
                                                              _productFilter,
                                                          filterTypeIndex:
                                                              index,
                                                        );
                                                      },
                                                    ).then((value) => {
                                                          if (value != null)
                                                            {
                                                              _productFilter =
                                                                  value,
                                                              print(value),
                                                              appliedFilter
                                                                  .clear(),
                                                              appliedFilter.add(
                                                                  new AppliedFilterList(
                                                                      type: "0",
                                                                      name:
                                                                          "Price",
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
                                                                      name:
                                                                          "Sort",
                                                                      isFilterValue:
                                                                          false)),
                                                              appliedFilter.add(
                                                                  new AppliedFilterList(
                                                                      type: "0",
                                                                      name:
                                                                          "Occasion",
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
                                                                  appliedFilter.add(new AppliedFilterList(
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
                                                                  appliedFilter.add(new AppliedFilterList(
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
                                                                  appliedFilter.add(new AppliedFilterList(
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
                                                                  appliedFilter.add(new AppliedFilterList(
                                                                      type: "4",
                                                                      name: _productFilter
                                                                          .filterOcassionValue!,
                                                                      isFilterValue:
                                                                          true)),
                                                                },
                                                              if (_productSearchResult !=
                                                                      null &&
                                                                  _productSearchResult
                                                                          .length >
                                                                      0)
                                                                {
                                                                  _productSearchResult
                                                                      .clear(),
                                                                  _isDataLoaded =
                                                                      false,
                                                                },
                                                              _getProductSearchResult(),
                                                              setState(() {}),
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
                                                      top: 5,
                                                      bottom: 5,
                                                      left: 8,
                                                      right: 8),
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: ColorConstants
                                                              .grey,
                                                          width: 0.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: Row(
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          appliedFilter[index]
                                                              .name!,
                                                          style: TextStyle(
                                                              fontFamily: global
                                                                  .fontMetropolisRegular,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200,
                                                              fontSize: 13,
                                                              color:
                                                                  ColorConstants
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
                                                                if (_productSearchResult !=
                                                                        null &&
                                                                    _productSearchResult
                                                                            .length >
                                                                        0) {
                                                                  _productSearchResult
                                                                      .clear();
                                                                  _isDataLoaded =
                                                                      false;
                                                                }
                                                                appliedFilter
                                                                    .removeAt(
                                                                        index);

                                                                _getProductSearchResult();
                                                                setState(() {});
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
                                                  _productSearchResult.clear();

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
                                                  _getProductSearchResult();
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
                                                                              fontFamily: global.fontMetropolisRegular,
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
                                                                              fontFamily: global.fontMetropolisRegular,
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
                                                          //             .fontMetropolisRegular,
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
                                  _isDataLoding?Expanded(child: Container(
                                    height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                    child: Center(child: Container(height:30,width:30, child: CircularProgressIndicator())),
                                  )):Expanded(
                                    child: _isDataLoaded
                                        ? _productSearchResult != null && 
                                                _productSearchResult.length > 0
                                            ? Container(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                child: SingleChildScrollView(
                                                  controller:
                                                      _scrollController1,
                                                  // physics: AlwaysScrollableScrollPhysics(),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      _isDataLoaded
                                                          ? ProductsMenu(
                                                              isSubCatgoriesScreen:
                                                                  true,
                                                              analytics: widget
                                                                  .analytics,
                                                              observer: widget
                                                                  .observer,
                                                              categoryProductList:
                                                                  _productSearchResult,
                                                              isHomeSelected:
                                                                  "SearchScreen",
                                                            )
                                                          : SizedBox(),
                                                      _isMoreDataLoaded
                                                          ? Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                strokeWidth: 1,
                                                              ),
                                                            )
                                                          : SizedBox()
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/images/login_bg.png"),
                                                      fit: BoxFit.cover),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 200,
                                                          bottom: 200),
                                                  child: Center(
                                                      child: Text(
                                                    "No products found",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            fontMontserratLight,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        color: ColorConstants
                                                            .guidlinesGolden),
                                                  )),
                                                ),
                                              )
                                        : _shimmer(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // floatingActionButton: (_productSearchResult != null &&
        //             _productSearchResult.length > 0) ||
        //         (_isFilterApplied)
        //     ? FloatingActionButton(
        //         backgroundColor: Colors.white,
        //         //   shape: RoundedRectangleBorder(),
        //         onPressed: () {
        //           FocusScope.of(context).requestFocus(new FocusNode());
        //           showModalBottomSheet(
        //             backgroundColor: Colors.white,
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.only(
        //                 topLeft: Radius.circular(20),
        //                 topRight: Radius.circular(20),
        //               ),
        //             ),
        //             context: context,
        //             builder: (BuildContext context) {
        //               return FilterCustomSheet(
        //                 showFilters: _productFilter,
        //               );
        //             },
        //           ).then((value) => {
        //                 if (value != null)
        //                   {
        //                     _isDataLoaded = false,
        //                     _productFilter = value,
        //                     _isFilterApplied = true,
        //                     print(value),
        //                     _productSearchResult.clear(),
        //                     setState(() {}),
        //                     appliedFilter.clear(),
        //                     appliedFilter.add(new AppliedFilterList(
        //                         type: "0",
        //                         name: "Price",
        //                         isFilterValue: false)),
        //                     appliedFilter.add(new AppliedFilterList(
        //                         type: "0",
        //                         name: "Discount",
        //                         isFilterValue: false)),
        //                     appliedFilter.add(new AppliedFilterList(
        //                         type: "0", name: "Sort", isFilterValue: false)),
        //                     if (_productFilter.filterPriceValue != null &&
        //                         _productFilter.filterPriceValue!.length > 0)
        //                       {
        //                         appliedFilter.add(new AppliedFilterList(
        //                             type: "1",
        //                             name: _productFilter.filterPriceValue!)),
        //                       },
        //                     if (_productFilter.filterDiscountValue != null &&
        //                         _productFilter.filterDiscountValue!.length > 0)
        //                       {
        //                         appliedFilter.add(new AppliedFilterList(
        //                             type: "2",
        //                             name: _productFilter.filterDiscountValue!)),
        //                       },
        //                     if (_productFilter.filterSortID != null &&
        //                         _productFilter.filterSortID!.length > 0)
        //                       {
        //                         appliedFilter.add(new AppliedFilterList(
        //                             type: "3",
        //                             name: _productFilter.filterSortValue!)),
        //                       },
        //                     if (_productSearchResult != null &&
        //                         _productSearchResult.length > 0)
        //                       {
        //                         // _productsList.clear();
        //                         _isDataLoaded = false,
        //                       }
        //                     else
        //                       {
        //                         if (appliedFilter != null &&
        //                             appliedFilter.length > 0)
        //                           {
        //                             _isFilterApplied = true,
        //                           }
        //                         else
        //                           {
        //                             _isFilterApplied = false,
        //                           },
        //                         print("Clear all or dismissed"),
        //                       },
        //                     _getProductSearchResult(),
        //                   }
        //                 else
        //                   {
        //                     if (appliedFilter != null &&
        //                         appliedFilter.length > 0)
        //                       {
        //                         _isFilterApplied = true,
        //                       }
        //                     else
        //                       {
        //                         _isFilterApplied = false,
        //                       },
        //                     print("Clear all or dismissed"),
        //                   }
        //               });
        //         },
        //         child: Icon(
        //           MdiIcons.filterOutline,
        //           color: Colors.red,
        //           size: 30,
        //         ),
        //       )
        //     : SizedBox(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _cSearch.text = searchParams!;
    _init(0);
    appliedFilter.add(
        new AppliedFilterList(type: "0", name: "Price", isFilterValue: false));
    appliedFilter.add(new AppliedFilterList(
        type: "0", name: "Discount", isFilterValue: false));
    appliedFilter.add(
        new AppliedFilterList(type: "0", name: "Sort", isFilterValue: false));
    appliedFilter.add(new AppliedFilterList(
        type: "0", name: "Occasion", isFilterValue: false));
    _scrollController1 = ScrollController()..addListener(_scrollListener);
  }

  _init(int loadTag) async {
    try {
      // if (searchScreen == 'subCat') {
      //   _cSearch.text = subCatName!;
      //   await _getProductSearchbySubcatResult();
      // } else if (searchScreen == 'dsearch') {
      //   if (loadTag == 1) {
      //     await _getProductSearchbyUniversalSearch();
      //   }
      // } else if (searchScreen == 'dsearch1') {
      //   await _getProductSearchbyUniversalSearch();
      // } else {

      // }
      _getCategoryList();
      await _getProductSearchResult();
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - search_results_screen.dart - _init():" + e.toString());
    }
  }

  List<CategoryList> _categoryList = [];
  bool _isRecordPending = true;
  int? categoriesSelectedIndex = -1;
  List<SubCateeList> _subCategoryList = [];
  bool _issubCatDataLoaded = false;

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

  void _scrollListener() {
    if (_scrollController1.position.atEdge) {
      bool isTop = _scrollController1.position.pixels == 0;
      if (isTop) {
        print('At the top');
        if (searchScreen == "dsearch") {
          _init(1);
        } else {
          _init(0);
        }
      } else {
        print('At the bottom');
        // _getCategoryProduct(selectedCardID);
        print("G1------>click 1");
        
      }
    }
  }

  //this is actually used search in this
  _getProductSearchResult() async {
    _isDataLoding=true;
    setState(() { });
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        await apiHelper
            .getproductSearchResult(searchParams!, _productFilter,selectedCatID!=null?selectedCatID.toString():"",global.isSubCatSelected?"sub":!global.isSubCatSelected && (selectedCatID != null && selectedCatID!>0) ?"parent":"")
            .then((result) async {
          if (result != null) {
            if (result.status == "1") {
              _isDataLoding=false;
              _productSearchResult = [];
              _productSearchResult.clear();
              _productSearchResult = result.data;

              _isDataLoaded = true;
              _isMoreDataLoaded = false;
              setState(() {});
            } else {
              _isDataLoding=false;
              _productSearchResult.clear();
              _isMoreDataLoaded = false;
              _isDataLoaded = true;
              setState(() {});
            }
          }
          _isDataLoding=false;
        });
      } else {
        _isDataLoding=false;
        _isMoreDataLoaded = false;
        showNetworkErrorSnackBar1(_scaffoldKey);
      }
    } catch (e) {
      _isDataLoding=false;
      _isMoreDataLoaded = false;
      print(
          "Exception - search_results_screen.dart1 - _getProductSearchResult():" +
              e.toString());
    }
  }

  _onRefresh() async {
    try {
      _isDataLoaded = false;
      setState(() {});
      await _init(1);
    } catch (e) {
      print("Exception - search_results_screen.dart - _onRefresh():" +
          e.toString());
    }
  }

  _shimmer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: 8,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                    height: 100 * MediaQuery.of(context).size.height / 830,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      elevation: 0,
                    ));
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
