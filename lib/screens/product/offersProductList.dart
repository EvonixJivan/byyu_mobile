import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/screens/filter_screen.dart';
import 'package:flutter/material.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:byyu/controllers/cart_controller.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';

import 'package:byyu/models/categoryProductModel.dart';
import 'package:byyu/models/productFilterModel.dart';

import 'package:byyu/widgets/products_menu.dart';

class OffersProductListScreen extends BaseRoute {
  OffersProductListScreen({
    a,
    o,
  }) : super(a: a, o: o, r: 'OffersProductListScreen');

  @override
  _OffersProductListScreenState createState() =>
      _OffersProductListScreenState();
}

class _OffersProductListScreenState extends BaseRouteState {
  final CartController cartController = Get.put(CartController());
  List<Product> _productsList = [];
  bool _isDataLoaded = false;
  int? screenId;
  int? categoryId;
  String? categoryName;
  bool _isRecordPending = true;
  bool _isMoreDataLoaded = false;
  String? isHomeSelected;

  ProductFilter _productFilter = new ProductFilter();
  ShowFilters _showFilter = new ShowFilters();

  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController1 = ScrollController();
  String apiResponseMessage = "";
  int page = 1;
  bool _isFilterApplied = false;
  List<AppliedFilterList> appliedFilter = [];

  _OffersProductListScreenState();
  int? _value = 1;
  @override
  Widget build(BuildContext context) {
    //TextTheme textTheme = Theme.of(context).textTheme;c
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.white,
      //   //   shape: RoundedRectangleBorder(),
      //   onPressed: () {
      //     showModalBottomSheet(
      //       backgroundColor: Colors.white,
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.only(
      //           topLeft: Radius.circular(20),
      //           topRight: Radius.circular(20),
      //         ),
      //       ),
      //       context: context,
      //       builder: (BuildContext context) {
      //         return FilterCustomSheet();
      //       },
      //     );
      //   },
      //   child: Icon(
      //     MdiIcons.filterOutline,
      //     color: Colors.red,
      //     size: 30,
      //   ),
      // ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorConstants.appBrownFaintColor,
        // centerTitle: true,
        leadingWidth: 50,
        centerTitle: true,
        toolbarHeight: 60,
        titleSpacing: 0,
        title: Container(
          // width: 450,
          child: Text(
            "Offers",
            // style: textTheme.headline6, maxLines: 1,
            style: TextStyle(
                color: ColorConstants.pureBlack,
                fontFamily: global.fontMetropolisRegular,
                fontWeight: FontWeight
                    .w200), //TextStyle(fontSize: 16, color: global.indigoColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      backgroundColor: global.white,
      body: _isDataLoaded
          ? _productsList != null && _productsList.length > 0
              ? RefreshIndicator(
                  // backgroundColor: Colors.deepOrange,
                  onRefresh: () async {
                    await _onRefresh();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            color: ColorConstants.white,
                            padding:
                                EdgeInsets.only(bottom: 5, left: 10, right: 10),
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
                                  height: 50,
                                  width: 2,
                                  color: ColorConstants.grey,
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
                                                            Radius.circular(20),
                                                        topRight:
                                                            Radius.circular(20),
                                                      ),
                                                    ),
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return FilterCustomSheet(
                                                        showFilters:
                                                            _productFilter,
                                                        filterTypeIndex: index,
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
                                                              if (_productFilter.filterOcassionID != null && _productFilter.filterOcassionID!.length > 0)
                                                                                    {
                                                                                      appliedFilter.add(new AppliedFilterList(type: "4", name: _productFilter.filterOcassionValue!, isFilterValue: true)),
                                                                                    },
                                                          //     if (_productFilter
                                                          //           .filterOcassionValue !=
                                                          //       null &&
                                                          //   _productFilter
                                                          //           .filterOcassionValue!
                                                          //           .length >
                                                          //       0)
                                                          // {
                                                          //   appliedFilter.add(
                                                          //       new AppliedFilterList(
                                                          //           type: "4",
                                                          //           name: _productFilter
                                                          //               .filterOcassionValue!,
                                                          //           isFilterValue:
                                                          //               true)),
                                                          // },
                                                            if (_productsList !=
                                                                    null &&
                                                                _productsList
                                                                        .length >
                                                                    0)
                                                              {
                                                                _productsList
                                                                    .clear(),
                                                                _isDataLoaded =
                                                                    false,
                                                              },
                                                            if (!global
                                                                .isEventProduct)
                                                              {
                                                                if (_productsList !=
                                                                        null &&
                                                                    _productsList
                                                                            .length >
                                                                        0)
                                                                  {
                                                                    _productsList
                                                                        .clear(),
                                                                    _isDataLoaded =
                                                                        false,
                                                                  },
                                                              },
                                                            _getProductList(),
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
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color:
                                                            ColorConstants.grey,
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
                                                                FontWeight.w200,
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
                                                              if (_productsList !=
                                                                      null &&
                                                                  _productsList
                                                                          .length >
                                                                      0) {
                                                                _productsList
                                                                    .clear();
                                                                _isDataLoaded =
                                                                    false;
                                                              }
                                                              appliedFilter
                                                                  .removeAt(
                                                                      index);
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
                                                                  _isDataLoaded =
                                                                      false;
                                                                }
                                                              }
                                                              _getProductList();
                                                              setState(() {});
                                                            },
                                                            child: Icon(
                                                              Icons.cancel,
                                                              size: 20,
                                                              color:
                                                                  ColorConstants
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
                          _isFilterApplied
                              ? Container(
                                  height: 60,
                                  color: ColorConstants.appBrownFaintColor,
                                  padding: EdgeInsets.only(
                                      bottom: 5, left: 10, right: 10),
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                80,
                                        height: 30,
                                        child: ListView.builder(
                                            controller: _scrollController,
                                            physics:
                                                AlwaysScrollableScrollPhysics(),
                                            itemCount: appliedFilter.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) =>
                                                Container(
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
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          if (appliedFilter[
                                                                      index]
                                                                  .type ==
                                                              "1") {
                                                            _productFilter
                                                                .filterPriceID = "";
                                                          }
                                                          if (appliedFilter[
                                                                      index]
                                                                  .type ==
                                                              "2") {
                                                            _productFilter
                                                                .filterDiscountID = "";
                                                          }
                                                          if (appliedFilter[
                                                                      index]
                                                                  .type ==
                                                              "3") {
                                                            _productFilter
                                                                .filterSortID = "";
                                                          }
                                                          if (_productsList !=
                                                                  null &&
                                                              _productsList
                                                                      .length >
                                                                  0) {
                                                            _productsList
                                                                .clear();
                                                            _isDataLoaded =
                                                                false;
                                                          }
                                                          appliedFilter
                                                              .removeAt(index);
                                                          if (appliedFilter
                                                                  .length ==
                                                              0) {
                                                            _isFilterApplied =
                                                                false;
                                                            setState(() {});
                                                          }

                                                          if (_productsList !=
                                                                  null &&
                                                              _productsList
                                                                      .length >
                                                                  0) {
                                                            _productsList
                                                                .clear();
                                                            _isDataLoaded =
                                                                false;
                                                          }
                                                          _getProductList();
                                                          setState(() {});
                                                        },
                                                        child: Icon(
                                                          Icons.cancel,
                                                          size: 20,
                                                          color: ColorConstants
                                                              .pureBlack,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                      ),
                                      Expanded(child: Text("")),
                                      InkWell(
                                        onTap: () {
                                          _productFilter = new ProductFilter();
                                          _isFilterApplied = false;
                                          appliedFilter.clear();
                                          if (_productsList != null &&
                                              _productsList.length > 0) {
                                            _productsList.clear();
                                            _isDataLoaded = false;
                                          }

                                          if (_productsList != null &&
                                              _productsList.length > 0) {
                                            _productsList.clear();
                                            _isDataLoaded = false;
                                          }
                                          _getProductList();
                                          setState(() {});
                                        },
                                        child: Icon(
                                          Icons.close,
                                          color: ColorConstants.appColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(),
                          ProductsMenu(
                                                                          isSubCatgoriesScreen: false,

                            analytics: widget.analytics,
                            observer: widget.observer,
                            categoryProductList: _productsList,
                          ),
                          _isMoreDataLoaded
                              ? Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 2,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/login_bg.png"),
                        fit: BoxFit.cover),
                  ),
                  child: Center(
                    child: Text(
                      "Out of stock for now. \nCheck back soon for more",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: global.fontMontserratLight,
                          fontSize: 20,
                          fontWeight: FontWeight.w200,
                          color: ColorConstants.guidlinesGolden),
                    ),
                  ),
                )
          : Center(
              child: CircularProgressIndicator(),
            ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.white,
      //   //   shape: RoundedRectangleBorder(),
      //   onPressed: () {
      //     showModalBottomSheet(
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
      //           print(value),
      //           if (value != null)
      //             {
      //               print(value),
      //               _productFilter = value,
      //               _isFilterApplied = true,
      //               if (_productsList != null && _productsList.length > 0)
      //                 {
      //                   _productsList.clear(),
      //                   _isDataLoaded = false,
      //                 },
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
      //                   // _productsList.clear();
      //                   _isDataLoaded = false,
      //                 }
      //               else
      //                 {
      //                   if (appliedFilter != null && appliedFilter.length > 0)
      //                     {
      //                       _isFilterApplied = true,
      //                     }
      //                   else
      //                     {
      //                       _isFilterApplied = false,
      //                     },
      //                   print("Clear all or dismissed"),
      //                 },
      //               _getProductList(),
      //             }
      //           else
      //             {
      //               if (appliedFilter != null && appliedFilter.length > 0)
      //                 {
      //                   _isFilterApplied = true,
      //                 }
      //               else
      //                 {
      //                   _isFilterApplied = false,
      //                 },
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

  @override
  void initState() {
    super.initState();
    _init();
  }

  _getProductList() async {
    _isDataLoaded = false;
    print("Sub Category Product-------------------");
    try {
      // if (_isRecordPending) {
      _productsList.clear();
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
          .getProductswithOffers(_productFilter)
          .then((result) async {
        if (result != null) {
          if (result.data != null) {
            print("nikhil result---->result---->${result.data}");

            _tList.clear();
            _tList = result.data;
            if (page == 1) {
              _productsList.clear();
            }
            if (_tList.isEmpty) {
              _isRecordPending = false;
            }
            _isMoreDataLoaded = false;

            print('Product api  count:--->${_tList.length} &&& page--->$page');
            print('Product count1:--->${_productsList.length}');

            if (_tList.length > 0) {
              _productsList.addAll(_tList);
              print('Product count1:--->${_productsList.length}');
              _isDataLoaded = true;

              setState(() {
                _isDataLoaded = true;
                _isMoreDataLoaded = true;
              });
            }
            // }
            else {
              setState(() {
                _isMoreDataLoaded = false;
              });
            }
          } else {
            _isDataLoaded = true;
            _productsList = _productsList;
            setState(() {
              _isMoreDataLoaded = false;
            });
          }
        } else {
          page++;
        }
      });
      // }
    } catch (e) {
      print("Exception - offers.dart - _getEventProduct():" + e.toString());
    }
  }

  _init() async {
    try {
      await _getProductList();
      appliedFilter.add(new AppliedFilterList(
          type: "0", name: "Price", isFilterValue: false));
      appliedFilter.add(new AppliedFilterList(
          type: "0", name: "Discount", isFilterValue: false));
      appliedFilter.add(
          new AppliedFilterList(type: "0", name: "Sort", isFilterValue: false));
      appliedFilter.add(
          new AppliedFilterList(type: "0", name: "Occasion", isFilterValue: false));
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - productlist_screen.dart - _init():" + e.toString());
    }
  }

  _onRefresh() async {
    try {
      _productsList.clear();
      _isDataLoaded = false;
      _isRecordPending = true;
      setState(() {});
      await _init();
    } catch (e) {
      print(
          "Exception - productlist_screen.dart - _onRefresh():" + e.toString());
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
              itemCount: 15,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                    height: 100 * MediaQuery.of(context).size.height / 830,
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
                  'No internet-------------available',
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
              setState(() {
                // _onLoading();
                _init();
              });
              setState(() {
                print("reload1");
                {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => super.widget),
                  );
                }
              });
            }),
        backgroundColor: Colors.grey,
      ));
    } catch (e) {
      print("Exception -  base.dart - showNetworkErrorSnackBar1():" +
          e.toString());
    }
  }
}
