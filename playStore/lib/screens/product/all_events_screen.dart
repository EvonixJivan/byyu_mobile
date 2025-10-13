import 'dart:io';
import 'dart:math';

import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/models/categoryListModel.dart';
import 'package:byyu/models/categoryProductModel.dart';
import 'package:byyu/models/eventsListModel.dart';
import 'package:byyu/models/subCategoryModel.dart';
import 'package:byyu/screens/filter_screen.dart';
import 'package:byyu/widgets/products_menu.dart';
//import 'package:byyu/widgets/select_events_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
//import 'package:get/get.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:byyu/constants/image_constants.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;

import 'package:byyu/screens/address/addressListScreen.dart';
import 'package:byyu/screens/notification_screen.dart';

import '../../models/productFilterModel.dart';
import '../filter_screen.dart';

class AllEventsScreen extends BaseRoute {
  int? fromHomeScreen;
  AllEventsScreen({a, o, this.fromHomeScreen})
      : super(a: a, o: o, r: 'AllEventsScreen');

  @override
  _AllEventsScreenState createState() =>
      _AllEventsScreenState(fromHomeScreen: fromHomeScreen);
}

class _AllEventsScreenState extends BaseRouteState {
  int _selectedIndex = 0;
  List<EventsData> _eventsList = [];
  bool _isDataLoaded = false;
  bool _isDataLoading = false;
  int? screenId;
  int? fromHomeScreen;
  bool _isRecordPending = true;
  bool _isMoreDataLoaded = false;
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController1 = ScrollController();
  ScrollController _scrollController2 = ScrollController();
  List<Product> _productsList = [];
  int? selectedEventID;
  int isSelectedIndex = -1;
  bool isPageination = false;
  bool _isFilterApplied = false;
  List<AppliedFilterList> appliedFilter = [];

  String errorMessage = "Loading...";

  int page = 1;
  GlobalKey<ScaffoldState>? _scaffoldKey;
  ProductFilter _productFilter = new ProductFilter();
  _AllEventsScreenState({this.fromHomeScreen});
  int? _value = 1;

  bool _issubCatDataLoaded = false;
  int? subCateSelectIndex;
  int? categoriesSelectedIndex;
  bool isfilterApplied = false;
  int? catID;
  bool isSubcategory = false;
  List<CategoryList> _categoryList = [];
  List<SubCateeList> _subCategoryList = [];

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
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
      backgroundColor: ColorConstants.white,
      appBar: fromHomeScreen == 1
          ? AppBar(
              backgroundColor: ColorConstants.white,
              automaticallyImplyLeading: false,
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  global.currentLocation != null
                      ? Text(
                          // "${AppLocalizations.of(context).txt_deliver}",
                          "Deliver to",
                          style: TextStyle(
                              fontFamily: global.fontRailwayRegular,
                              fontWeight: FontWeight.w200,
                              fontSize: 10,
                              color: ColorConstants.pureBlack),
                        )
                      : SizedBox(),
                  GestureDetector(
                    onTap: () async {
                      if (global.lat != null && global.lng != null) {
                        // Get.to(() => LocationScreen(
                        //       a: widget.analytics,
                        //       o: widget.observer,
                        //     ));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddressListScreen(
                                      a: widget.analytics,
                                      o: widget.observer,
                                    )));
                      } else {
                        await getCurrentPosition().then((_) async {
                          if (global.lat != null && global.lng != null) {
                            // Get.to(() => LocationScreen(
                            //       a: widget.analytics,
                            //       o: widget.observer,
                            //     ));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddressListScreen(
                                          a: widget.analytics,
                                          o: widget.observer,
                                        )));
                          }
                        });
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 135,
                          child: Text(
                            global.currentLocation != null
                                ? global.currentLocation!
                                : 'No Location',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontFamily: fontRailwayRegular,
                                fontWeight: FontWeight.normal,
                                color: ColorConstants.pureBlack,
                                fontSize: 14),
                          ),
                        ),
                        Transform.rotate(
                          angle: pi / 2,
                          child: Icon(Icons.chevron_right,
                              color: global.bgCompletedColor),
                        )
                      ],
                    ),
                  )
                ],
              ),
              actions: [
                global.currentUser.id != null
                    ? InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationScreen(
                                      a: widget.analytics,
                                      o: widget.observer,
                                    ))),
                        child: Container(
                          height: 22,
                          width: 20,
                          margin: EdgeInsets.only(
                              left: 10, right: 20, top: 5, bottom: 5),
                          child: SvgPicture.asset(
                            ImageConstants.NOTIFICATION_BELL,
                            color: global.bgCompletedColor,
                            height: 22,
                            width: 20,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      )
                    : SizedBox()
              ],
            )
          : AppBar(
              backgroundColor: ColorConstants.white,
              centerTitle: false,
              title: Text(
                  "Special Occasions"
                  // "${AppLocalizations.of(context).tle_all_category} "
                  ,
                  style: TextStyle(
                      fontFamily: global.fontMontserratMedium,
                      fontWeight: FontWeight.normal,
                      color: ColorConstants.pureBlack) //textTheme.titleLarge,
                  ),
              leading: BackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                //icon: Icon(Icons.keyboard_arrow_left),
                color: ColorConstants.pureBlack,
              ),
            ),
      body: RefreshIndicator(
          onRefresh: () async {
            await _onRefresh();
          },
          child:
              // global.appInfo.store_id != null
              //     ?
              _isDataLoaded
                  // ? _eventsList != null
                  ? Column(
                      children: [
                        _issubCatDataLoaded
                            ? categoriesSelectedIndex != null &&
                                    categoriesSelectedIndex! >= 0 &&
                                    _subCategoryList != null &&
                                    _subCategoryList.length > 0
                                ? Container(
                                    color: ColorConstants.filterColor,
                                    height:
                                        MediaQuery.of(context).size.width / 5.4,
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        categoriesSelectedIndex != null &&
                                                categoriesSelectedIndex! >= 0
                                            ? SizedBox(
                                                height: 8,
                                              )
                                            : SizedBox(),
                                        categoriesSelectedIndex != null &&
                                                categoriesSelectedIndex! >= 0
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
                                                            .fontRailwayRegular,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 13,
                                                        color: ColorConstants
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
                                              padding: EdgeInsets.only(
                                                  top: 1, bottom: 5),
                                              child: ListView.builder(
                                                itemCount:
                                                    _subCategoryList.length,
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  return Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      // width: 65,
                                                      margin: EdgeInsets.all(5),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          subCateSelectIndex =
                                                              index;
                                                          _productsList.clear();
                                                          global.isSubCatSelected =
                                                              true;
                                                          isSubcategory = true;
                                                          catID =
                                                              _subCategoryList[
                                                                      index]
                                                                  .catId!;
                                                          _isDataLoading = true;
                                                          _getEventProduct(
                                                              selectedEventID);
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
                                                                  .only(top: 4),
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
                                                                        left: 1,
                                                                        right:
                                                                            1),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            color:
                                                                                Colors.white38),
                                                                    child: subCateSelectIndex ==
                                                                            index
                                                                        ? Container(
                                                                            // width: 65,
                                                                            padding: EdgeInsets.only(
                                                                                top: 5,
                                                                                bottom: 5,
                                                                                left: 8,
                                                                                right: 8),
                                                                            decoration: BoxDecoration(
                                                                                color: ColorConstants.appColor,
                                                                                border: Border.all(color: ColorConstants.grey, width: 0.5),
                                                                                borderRadius: BorderRadius.circular(8)),
                                                                            child:
                                                                                Text(
                                                                              "${_subCategoryList[index].title}",
                                                                              maxLines: 2,
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(fontFamily: global.fontRailwayRegular, fontWeight: FontWeight.w200, fontSize: 12, overflow: TextOverflow.ellipsis, color: subCateSelectIndex == index ? Colors.white : Colors.black),
                                                                            ),
                                                                          )
                                                                        : Container(
                                                                            // else  condition

                                                                            // width: 55,
                                                                            padding: EdgeInsets.only(
                                                                                top: 5,
                                                                                bottom: 5,
                                                                                left: 8,
                                                                                right: 8),
                                                                            decoration:
                                                                                BoxDecoration(border: Border.all(color: ColorConstants.grey, width: 0.5), borderRadius: BorderRadius.circular(8)),
                                                                            child:
                                                                                Text(
                                                                              "${_subCategoryList[index].title}",
                                                                              maxLines: 1,
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(fontFamily: global.fontRailwayRegular, fontWeight: FontWeight.w200, fontSize: 12, overflow: TextOverflow.ellipsis, color: subCateSelectIndex == index ? ColorConstants.appColor : Colors.black),
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
                            color: ColorConstants.white,
                            padding: EdgeInsets.only(bottom: 5),
                            width: MediaQuery.of(context).size.width,
                            height: 110,
                            child: _eventsList != null && _eventsList.length > 0
                                ? ListView.builder(
                                    itemCount: _eventsList.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          width: 80,
                                          margin: EdgeInsets.all(5),
                                          child: GestureDetector(
                                            onTap: () {
                                              _isFilterApplied = false;
                                              isSelectedIndex = index;
                                              errorMessage = "Loading...";
                                              _productFilter =
                                                  new ProductFilter();
                                              _productsList.clear();

                                              selectedEventID =
                                                  _eventsList[index].id;
                                              _isDataLoading = true;
                                              setState(() {});
                                              _getEventProduct(
                                                  _eventsList[index].id);
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
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    margin: EdgeInsets.only(
                                                        left: 1, right: 1),
                                                    child: Column(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
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
                                                            child: Container(
                                                              color: _eventsList[
                                                                              index]
                                                                          .colorcode !=
                                                                      null
                                                                  ? hexToColor(
                                                                      _eventsList[
                                                                              index]
                                                                          .colorcode!)
                                                                  : Colors
                                                                      .white,
                                                              child:
                                                                  CachedNetworkImage(
                                                                height: 40,
                                                                width: 40,
                                                                imageUrl: imageBaseUrl +
                                                                    _eventsList[
                                                                            index]
                                                                        .eventImage!,
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
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .white38),
                                                        child:
                                                            isSelectedIndex ==
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
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    child: Text(
                                                                      "${_eventsList[index].eventName}",
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
                                                                              10,
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          color: isSelectedIndex == index
                                                                              ? Colors.white
                                                                              : Colors.black),
                                                                    ),
                                                                  )
                                                                : Container(
                                                                    // else  condition
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(3),
                                                                    child: Text(
                                                                      "${_eventsList[index].eventName}",
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
                                                                              10,
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          color: isSelectedIndex == index
                                                                              ? ColorConstants.appColor
                                                                              : Colors.black),
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
                                  )
                                : SizedBox()),
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
                                        fontFamily: global.fontRailwayRegular,
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
                                                          // appliedFilter.add(
                                                          //     new AppliedFilterList(
                                                          //         type: "0",
                                                          //         name:
                                                          //             "Occasion",
                                                          //         isFilterValue:
                                                          //             false)),
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
                                                                      .filterOcassionID !=
                                                                  null &&
                                                              _productFilter
                                                                      .filterOcassionID!
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
                                                              _isDataLoaded =
                                                                  false,
                                                            },
                                                          _isDataLoading =
                                                              false,
                                                          setState(() {}),
                                                          _getEventProduct(
                                                              selectedEventID),
                                                          // setState(() {}),
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
                                                      BorderRadius.circular(8)),
                                              child: Row(
                                                children: [
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      appliedFilter[index]
                                                          .name!,
                                                      style: TextStyle(
                                                          fontFamily: global
                                                              .fontRailwayRegular,
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          fontSize: 13,
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
                                                            _isDataLoading =
                                                                true;

                                                            _getEventProduct(
                                                                selectedEventID);
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
                                      width: MediaQuery.of(context).size.width -
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
                                                                .fontRailwayRegular,
                                                            fontWeight:
                                                                FontWeight.w200,
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
                                                        if (appliedFilter[index]
                                                                .type ==
                                                            "1") {
                                                          _productFilter
                                                              .filterPriceID = "";
                                                        }
                                                        if (appliedFilter[index]
                                                                .type ==
                                                            "2") {
                                                          _productFilter
                                                              .filterDiscountID = "";
                                                        }
                                                        if (appliedFilter[index]
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
                                                          _productsList.clear();
                                                          _isDataLoaded = false;
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
                                                          _productsList.clear();
                                                          _isDataLoaded = false;
                                                        }
                                                        _isDataLoading = true;
                                                        _getEventProduct(
                                                            selectedEventID);
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
                                        _isDataLoading = true;
                                        _getEventProduct(selectedEventID);
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
                        Expanded(
                          child: Row(
                            children: [
                              Visibility(
                                visible: true,
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
                                              global.homeSelectedCatID =
                                                  _categoryList[
                                                          categoriesSelectedIndex!]
                                                      .catId!;
                                              _productsList.clear();
                                              // _eventsList.clear();

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
                                              global.isSubCatSelected = false;
                                              isSubcategory = false;
                                              catID = _categoryList[
                                                      categoriesSelectedIndex!]
                                                  .catId!;
                                              print("Hello");
                                              _isDataLoading = true;
                                              _getEventProduct(selectedEventID);
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
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    margin: EdgeInsets.only(
                                                        left: 1, right: 1),
                                                    child: Column(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
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
                                                              errorWidget:
                                                                  (context, url,
                                                                          error) =>
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
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .white38),
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
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    child: Text(
                                                                      "${_categoryList[index].title}",
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
                                                                              10,
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          color: categoriesSelectedIndex == index
                                                                              ? Colors.white
                                                                              : Colors.black),
                                                                    ),
                                                                  )
                                                                : Container(
                                                                    // else  condition
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(3),
                                                                    child: Text(
                                                                      "${_categoryList[index].title}",
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
                                                                              10,
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          color: categoriesSelectedIndex == index
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
                              Expanded(
                                child: _isDataLoaded
                                    ? _productsList != null &&
                                            _productsList.length > 0
                                        ? Container(
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            child: SingleChildScrollView(
                                              controller: _scrollController1,
                                              // physics: AlwaysScrollableScrollPhysics(),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  _isDataLoaded
                                                      ? ProductsMenu(
                                                          isSubCatgoriesScreen:
                                                              true,
                                                          analytics:
                                                              widget.analytics,
                                                          observer:
                                                              widget.observer,
                                                          categoryProductList:
                                                              _productsList,
                                                          isHomeSelected:
                                                              "SearchScreen",
                                                        )
                                                      : SizedBox(),
                                                  _isMoreDataLoaded
                                                      ? Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            backgroundColor:
                                                                Colors.white,
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
                                              padding: const EdgeInsets.only(
                                                  top: 200, bottom: 200),
                                              child: Center(
                                                  child: Text(
                                                _isDataLoading
                                                    ? "Loading..."
                                                    : "No products found",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily:
                                                        fontMontserratLight,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w200,
                                                    color: ColorConstants
                                                        .guidlinesGolden),
                                              )),
                                            ),
                                          )
                                    : SizedBox(),
                              ),
                            ],
                          ),
                        ),

                        // Expanded(
                        //     child: SingleChildScrollView(
                        //   // controller: _scrollController1,
                        //   physics: NeverScrollableScrollPhysics(),
                        //   child: Container(

                        //       padding: EdgeInsets.only(
                        //           bottom: Platform.isIOS ? 150 : 110),
                        //       height: MediaQuery.of(context).size.height - 110,
                        //       width: MediaQuery.of(context).size.width,
                        //       child: _productsList.length > 0
                        //           ? SingleChildScrollView(
                        //               controller: _scrollController2,
                        //               child: Column(
                        //                 children: [

                        //                   Row(
                        //                     children: [
                        //                       Visibility(
                        //                         visible: true,
                        //                         child: Container(
                        //                           width: MediaQuery.of(context)
                        //                                   .size
                        //                                   .width /
                        //                               5,
                        //                           child: ListView.builder(
                        //                             itemCount:
                        //                                 _categoryList.length,
                        //                             shrinkWrap: true,
                        //                             scrollDirection:
                        //                                 Axis.vertical,
                        //                             physics: AlwaysScrollableScrollPhysics(),
                        //                             itemBuilder:
                        //                                 (context, index) {
                        //                               return Container(
                        //                                   width: 80,
                        //                                   margin:
                        //                                       EdgeInsets.all(5),
                        //                                   child:
                        //                                       GestureDetector(
                        //                                     onTap: () {
                        //                                       categoriesSelectedIndex =
                        //                                           index;
                        //                                       subCateSelectIndex =
                        //                                           -1;
                        //                                       global.homeSelectedCatID =
                        //                                           _categoryList[
                        //                                                   categoriesSelectedIndex!]
                        //                                               .catId!;
                        //                                       _eventsList
                        //                                           .clear();

                        //                                       if (_categoryList[
                        //                                                       categoriesSelectedIndex!]
                        //                                                   .subcategory !=
                        //                                               null &&
                        //                                           _categoryList[
                        //                                                       categoriesSelectedIndex!]
                        //                                                   .subcategory!
                        //                                                   .length >
                        //                                               0) {
                        //                                         _subCategoryList
                        //                                             .clear();
                        //                                         for (int i = 0;
                        //                                             i <
                        //                                                 _categoryList[categoriesSelectedIndex!]
                        //                                                     .subcategory!
                        //                                                     .length;
                        //                                             i++) {
                        //                                           _subCategoryList.add(new SubCateeList(
                        //                                               catId: _categoryList[
                        //                                                       categoriesSelectedIndex!]
                        //                                                   .subcategory![
                        //                                                       i]
                        //                                                   .catId,
                        //                                               title: _categoryList[
                        //                                                       categoriesSelectedIndex!]
                        //                                                   .subcategory![
                        //                                                       i]
                        //                                                   .title,
                        //                                               image: _categoryList[
                        //                                                       categoriesSelectedIndex!]
                        //                                                   .subcategory![
                        //                                                       i]
                        //                                                   .image,
                        //                                               parent: _categoryList[
                        //                                                       categoriesSelectedIndex!]
                        //                                                   .subcategory![
                        //                                                       i]
                        //                                                   .parent));
                        //                                         }
                        //                                       } else {
                        //                                         for (int i = 0;
                        //                                             i <
                        //                                                 _categoryList[categoriesSelectedIndex!]
                        //                                                     .subcategory!
                        //                                                     .length;
                        //                                             i++) {
                        //                                           _subCategoryList.add(new SubCateeList(
                        //                                               catId: _categoryList[
                        //                                                       categoriesSelectedIndex!]
                        //                                                   .subcategory![
                        //                                                       i]
                        //                                                   .catId,
                        //                                               title: _categoryList[
                        //                                                       categoriesSelectedIndex!]
                        //                                                   .subcategory![
                        //                                                       i]
                        //                                                   .title,
                        //                                               image: _categoryList[
                        //                                                       categoriesSelectedIndex!]
                        //                                                   .subcategory![
                        //                                                       i]
                        //                                                   .image,
                        //                                               parent: _categoryList[
                        //                                                       categoriesSelectedIndex!]
                        //                                                   .subcategory![
                        //                                                       i]
                        //                                                   .parent));
                        //                                         }
                        //                                       }
                        //                                       global.isSubCatSelected =
                        //                                           false;

                        //                                       setState(() {});
                        //                                     },
                        //                                     child: Column(
                        //                                       children: [
                        //                                         Container(
                        //                                           width: 80,
                        //                                           height: 60,
                        //                                           child: Card(
                        //                                             elevation:
                        //                                                 0,
                        //                                             shadowColor:
                        //                                                 Colors
                        //                                                     .transparent,
                        //                                             shape:
                        //                                                 RoundedRectangleBorder(
                        //                                               borderRadius:
                        //                                                   BorderRadius.circular(
                        //                                                       8.0),
                        //                                             ),
                        //                                             margin: EdgeInsets.only(
                        //                                                 left: 1,
                        //                                                 right:
                        //                                                     1),
                        //                                             child:
                        //                                                 Column(
                        //                                               children: [
                        //                                                 ClipRRect(
                        //                                                   borderRadius:
                        //                                                       BorderRadius.circular(8),
                        //                                                   child:
                        //                                                       Container(
                        //                                                     decoration:
                        //                                                         BoxDecoration(
                        //                                                       color: Colors.transparent,
                        //                                                       borderRadius: BorderRadius.circular(10),
                        //                                                       // border: Border.all(
                        //                                                       //     color: isSelectedIndex == index
                        //                                                       //         ? ColorConstants.appColor
                        //                                                       //         : Colors.white),
                        //                                                     ),
                        //                                                     width:
                        //                                                         60,
                        //                                                     height:
                        //                                                         60,
                        //                                                     child:
                        //                                                         CachedNetworkImage(
                        //                                                       height: 40,
                        //                                                       width: 40,
                        //                                                       imageUrl: imageBaseUrl + _categoryList[index].image!,
                        //                                                       imageBuilder: (context, imageProvider) => Container(
                        //                                                         height: double.infinity,
                        //                                                         width: double.infinity,
                        //                                                         decoration: BoxDecoration(
                        //                                                           color: Colors.transparent,
                        //                                                           // borderRadius: BorderRadius.circular(10),
                        //                                                           image: DecorationImage(
                        //                                                             image: imageProvider,
                        //                                                             fit: BoxFit.contain,
                        //                                                             alignment: Alignment.center,
                        //                                                           ),
                        //                                                         ),
                        //                                                       ),
                        //                                                       placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        //                                                       errorWidget: (context, url, error) => Container(
                        //                                                         decoration: BoxDecoration(
                        //                                                           // borderRadius: BorderRadius.circular(15),
                        //                                                           image: DecorationImage(
                        //                                                             image: AssetImage(global.catNoImage),
                        //                                                             fit: BoxFit.contain,
                        //                                                           ),
                        //                                                         ),
                        //                                                       ),
                        //                                                     ),
                        //                                                   ),
                        //                                                 ),
                        //                                               ],
                        //                                             ),
                        //                                           ),
                        //                                         ),
                        //                                         Container(
                        //                                           margin: EdgeInsets
                        //                                               .only(
                        //                                                   top:
                        //                                                       8),
                        //                                           child: Column(
                        //                                             mainAxisAlignment:
                        //                                                 MainAxisAlignment
                        //                                                     .end,
                        //                                             crossAxisAlignment:
                        //                                                 CrossAxisAlignment
                        //                                                     .center,
                        //                                             children: [
                        //                                               Container(
                        //                                                 padding: EdgeInsets.only(
                        //                                                     left:
                        //                                                         1,
                        //                                                     right:
                        //                                                         1),
                        //                                                 decoration:
                        //                                                     BoxDecoration(color: Colors.white38),
                        //                                                 child: categoriesSelectedIndex ==
                        //                                                         index
                        //                                                     ? Container(
                        //                                                         padding: EdgeInsets.all(3),
                        //                                                         decoration: BoxDecoration(
                        //                                                           color: ColorConstants.appColor,
                        //                                                           borderRadius: BorderRadius.circular(10),
                        //                                                         ),
                        //                                                         child: Text(
                        //                                                           "${_categoryList[index].title}",
                        //                                                           maxLines: 2,
                        //                                                           textAlign: TextAlign.center,
                        //                                                           style: TextStyle(fontFamily: global.fontRailwayRegular, fontWeight: FontWeight.w200, fontSize: 10, overflow: TextOverflow.ellipsis, color: categoriesSelectedIndex == index ? Colors.white : Colors.black),
                        //                                                         ),
                        //                                                       )
                        //                                                     : Container(
                        //                                                         // else  condition
                        //                                                         padding: EdgeInsets.all(3),
                        //                                                         child: Text(
                        //                                                           "${_categoryList[index].title}",
                        //                                                           maxLines: 2,
                        //                                                           textAlign: TextAlign.center,
                        //                                                           style: TextStyle(fontFamily: global.fontRailwayRegular, fontWeight: FontWeight.w200, fontSize: 10, overflow: TextOverflow.ellipsis, color: categoriesSelectedIndex == index ? ColorConstants.appColor : Colors.black),
                        //                                                         ),
                        //                                                       ),
                        //                                               ),

                        //                                               // Container(
                        //                                               //   padding: EdgeInsets
                        //                                               //       .only(
                        //                                               //           left: 1,
                        //                                               //           right: 1),
                        //                                               //   decoration:
                        //                                               //       BoxDecoration(
                        //                                               //           color: Colors
                        //                                               //               .white38),
                        //                                               //   child: Text(
                        //                                               //     "${_eventsList[index].eventName}",
                        //                                               //     maxLines: 2,
                        //                                               //     textAlign:
                        //                                               //         TextAlign
                        //                                               //             .center,
                        //                                               //     style: TextStyle(
                        //                                               //         fontFamily: global
                        //                                               //             .fontRailwayRegular,
                        //                                               //         fontWeight:
                        //                                               //             FontWeight
                        //                                               //                 .w200,
                        //                                               //         fontSize:
                        //                                               //             12,
                        //                                               //         overflow:
                        //                                               //             TextOverflow
                        //                                               //                 .ellipsis,
                        //                                               //         color: isSelectedIndex ==
                        //                                               //                 index
                        //                                               //             ? ColorConstants
                        //                                               //                 .appColor
                        //                                               //             : Colors
                        //                                               //                 .black),
                        //                                               //   ),
                        //                                               // ),
                        //                                             ],
                        //                                           ),
                        //                                         ),
                        //                                       ],
                        //                                     ),
                        //                                   ));
                        //                             },
                        //                           ),
                        //                         ),
                        //                       ),
                        //                       Expanded(
                        //                         child: _isDataLoaded
                        //                             ? _eventsList != null &&
                        //                                     _eventsList.length >
                        //                                         0
                        //                                 ? Container(
                        //                                   color: Colors.amber,
                        //                                     height:
                        //                                         MediaQuery.of(
                        //                                                 context)
                        //                                             .size
                        //                                             .height,
                        //                                     child:
                        //                                         SingleChildScrollView(
                        //                                       controller:
                        //                                           _scrollController1,
                        //                                       // physics: AlwaysScrollableScrollPhysics(),
                        //                                       child: Column(
                        //                                         crossAxisAlignment:
                        //                                             CrossAxisAlignment
                        //                                                 .start,
                        //                                         children: [
                        //                                           _isDataLoaded
                        //                                               ? ProductsMenu(
                        //                                                   isSubCatgoriesScreen:
                        //                                                       true,
                        //                                                   analytics:
                        //                                                       widget.analytics,
                        //                                                   observer:
                        //                                                       widget.observer,
                        //                                                   categoryProductList:
                        //                                                       _productsList,
                        //                                                   isHomeSelected:
                        //                                                       "events",
                        //                                                   passdata1:
                        //                                                       "Events",
                        //                                                   passdata2:
                        //                                                       selectedEventID,
                        //                                                   passdata3:
                        //                                                       "subscriptionProduct",
                        //                                                 )
                        //                                               : Container(
                        //                                                   width: MediaQuery.of(context)
                        //                                                       .size
                        //                                                       .width,
                        //                                                   height: MediaQuery.of(context)
                        //                                                       .size
                        //                                                       .height,
                        //                                                   decoration:
                        //                                                       BoxDecoration(
                        //                                                     image:
                        //                                                         DecorationImage(image: AssetImage("assets/images/login_bg.png"), fit: BoxFit.cover),
                        //                                                   ),
                        //                                                   child:
                        //                                                       Padding(
                        //                                                     padding:
                        //                                                         const EdgeInsets.only(top: 200, bottom: 200),
                        //                                                     child: Center(
                        //                                                         child: Text(
                        //                                                       "No products found",
                        //                                                       textAlign: TextAlign.center,
                        //                                                       style: TextStyle(fontFamily: fontMontserratLight, fontSize: 20, fontWeight: FontWeight.w200, color: ColorConstants.guidlinesGolden),
                        //                                                     )),
                        //                                                   ),
                        //                                                 ),
                        //                                           _isMoreDataLoaded
                        //                                               ? Center(
                        //                                                   child:
                        //                                                       CircularProgressIndicator(
                        //                                                     backgroundColor:
                        //                                                         Colors.white,
                        //                                                     strokeWidth:
                        //                                                         1,
                        //                                                   ),
                        //                                                 )
                        //                                               : SizedBox()
                        //                                         ],
                        //                                       ),
                        //                                     ),
                        //                                   )
                        //                                 : Container(
                        //                                     width:
                        //                                         MediaQuery.of(
                        //                                                 context)
                        //                                             .size
                        //                                             .width,
                        //                                     height:
                        //                                         MediaQuery.of(
                        //                                                 context)
                        //                                             .size
                        //                                             .height,
                        //                                     decoration:
                        //                                         BoxDecoration(
                        //                                       image: DecorationImage(
                        //                                           image: AssetImage(
                        //                                               "assets/images/login_bg.png"),
                        //                                           fit: BoxFit
                        //                                               .cover),
                        //                                     ),
                        //                                     child: Padding(
                        //                                       padding:
                        //                                           const EdgeInsets
                        //                                               .only(
                        //                                               top: 200,
                        //                                               bottom:
                        //                                                   200),
                        //                                       child: Center(
                        //                                           child: Text(
                        //                                         "No products found",
                        //                                         textAlign:
                        //                                             TextAlign
                        //                                                 .center,
                        //                                         style: TextStyle(
                        //                                             fontFamily:
                        //                                                 fontMontserratLight,
                        //                                             fontSize:
                        //                                                 20,
                        //                                             fontWeight:
                        //                                                 FontWeight
                        //                                                     .w200,
                        //                                             color: ColorConstants
                        //                                                 .guidlinesGolden),
                        //                                       )),
                        //                                     ),
                        //                                   )
                        //                             : SizedBox(),
                        //                       ),

                        //                     ],
                        //                   ),
                        //                 ],
                        //               ),
                        //             )
                        //           : Container(
                        //               width: MediaQuery.of(context).size.width,
                        //               height:
                        //                   MediaQuery.of(context).size.height /
                        //                       1.5,
                        //               decoration: BoxDecoration(
                        //                 image: DecorationImage(
                        //                     image: AssetImage(
                        //                         "assets/images/login_bg.png"),
                        //                     fit: BoxFit.cover),
                        //               ),
                        //               child: Center(
                        //                 child: Text(
                        //                   errorMessage,
                        //                   textAlign: TextAlign.center,
                        //                   style: TextStyle(
                        //                       fontFamily: fontMontserratLight,
                        //                       fontSize: 20,
                        //                       fontWeight: FontWeight.w200,
                        //                       color: ColorConstants
                        //                           .guidlinesGolden),
                        //                 ),
                        //               ),
                        //             )),
                        // ))
                      ],
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 1.5,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/login_bg.png"),
                            fit: BoxFit.cover),
                      ),
                      child: Center(
                        child: Text(
                          errorMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: fontMontserratLight,
                              fontSize: 20,
                              fontWeight: FontWeight.w200,
                              color: ColorConstants.guidlinesGolden),
                        ),
                      ),
                    )),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  showOnlyLoaderDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Center(
              child: new CircularProgressIndicator(
            strokeWidth: 1,
          )),
        );
      },
    );
  }

  void hideloadershowing() {
    Navigator.pop(context);
  }

  double boundaryOffset = 0.5;
  int currentpage = 1;
  void _scrollListener() {
    print("Scrollcontroller Called");
    if (_scrollController1.offset >=
            _scrollController1.position.maxScrollExtent * 0.5 &&
        !_isMoreDataLoaded) {
      bool isTop = _scrollController1.position.pixels == 0.0;
      if (isTop) {
        print('At the top');
      } else {
        isPageination = true;
        boundaryOffset = 1 - 1 / (currentpage * 2);
        _getEventProduct(selectedEventID);
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

  void _scrollListener2() {
    print("Scrollcontroller Called");
    if (_scrollController2.offset >=
            _scrollController2.position.maxScrollExtent * 0.5 &&
        !_isMoreDataLoaded) {
      bool isTop = _scrollController2.position.pixels == 0.0;
      if (isTop) {
        print('At the top');
      } else {
        boundaryOffset = 1 - 1 / (currentpage * 2);
        isPageination = true;
        _getEventProduct(selectedEventID);
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

  _getEventProduct(eventID) async {
    if (!isPageination) {
      showOnlyLoaderDialog();
    }
    print("Sub Category Product----------${eventID}---------");
    try {
      setState(() {
        errorMessage = "Loading...";
        _isMoreDataLoaded = true;
      });
      List<Product> _tList = [];
      if (_productsList == null || _productsList.length == 0) {
        print(" _getEventProduct Emptyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy");
        page = 1;
      } else if (_isRecordPending) {
        page = page + 1;
      }
      await apiHelper
          .getEventFilteredProducts(
              eventID,
              page,
              catID != null ? catID!.toString() : "",
              isSubCatSelected && (catID != null && catID! > 0)
                  ? "sub"
                  : !isSubCatSelected && (catID != null && catID! > 0)
                      ? "parent"
                      : "",
              _productFilter)
          .then((result) async {
        print(result);
        if (result != null) {
          print("Nikhil 1");

          if (result.data != null) {
            print("nikhil result---->result---->${result.data}");
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
            _isDataLoading = false;
            // if (isSelectedCat == 0) {
            //   _subCategoryList[0].isSelected = true;
            // }
            print('Product api  count:--->${_tList.length} &&& page--->$page');
            print('Product count1:--->${_productsList.length}');

            if (_tList.length > 0) {
              if (page == 1) {
                _productsList.clear();
              }
              _productsList.addAll(_tList);
              print(_productsList[0].productName);
              errorMessage = "";
              print('Product count1:--->${_productsList.length}');

              setState(() {
                _isDataLoaded = true;
                _isDataLoading = false;
                if (!isPageination) {
                  hideLoader();
                }
                errorMessage =
                    "Out of stock for now. \nCheck back soon for more";
                _isMoreDataLoaded = false;
              });
            }
            // }
            else {
              print("else1");
              setState(() {
                if (page == 1) {
                  _productsList.clear();
                }
                _isDataLoading = false;
                errorMessage =
                    "Out of stock for now. \nCheck back soon for more";
                if (!isPageination) {
                  hideLoader();
                }
                _isMoreDataLoaded = false;
              });
            }
          } else {
            _isDataLoading = false;
            _isDataLoaded = true;
            print("else2");
            if (page == 1) {
              _productsList.clear();
            }
            //
            errorMessage = "Out of stock for now. \nCheck back soon for more";
            setState(() {
              if (!isPageination) {
                hideLoader();
              }
              _isMoreDataLoaded = false;
            });
          }
        } else {
          print("else3");
          _productsList.clear();
          if (!isPageination) {
            hideLoader();
          }
          _isDataLoading = false;
          _isDataLoaded = true;
          // page++;
          errorMessage = "Out of stock for now. \nCheck back soon for more";
          setState(() {});
        }
      });
      // }
    } catch (e) {
      print("catch ");
      _productsList.clear();
      _isDataLoading = false;
      if (!isPageination) {
        hideLoader();
      }
      errorMessage = "Out of stock for now. \nCheck back soon for more";
      print("Exception - AllEventsScreen.dart - _getEventProduct():" +
          e.toString());
    }
  }

  _getEventsList() async {
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        if (_isRecordPending) {
          setState(() {
            _isMoreDataLoaded = true;
          });
          if (_eventsList.isEmpty) {
            page = 1;
          } else {
            page++;
          }
          await apiHelper.getEventsList().then((result) async {
            if (result != null) {
              List<EventsData> _tList = result.data;
              if (_tList.isEmpty) {
                _isRecordPending = false;
              }
              _eventsList.clear();
              _eventsList.addAll(_tList);
              if (_eventsList.length > 0) {
                _getEventProduct(_eventsList[0].id);
                selectedEventID = _eventsList[0].id;
              }
              setState(() {
                _isMoreDataLoaded = false;
              });
            }
          });
        }
      } else {
        showNetworkErrorSnackBar1(_scaffoldKey!);
      }
    } catch (e) {
      print("Exception - all_categories_screen.dart - _getEventsList():" +
          e.toString());
    }
  }

  _init() async {
    try {
      _getCategoryList();
      await _getEventsList();
      appliedFilter.add(new AppliedFilterList(
          type: "0", name: "Price", isFilterValue: false));
      appliedFilter.add(new AppliedFilterList(
          type: "0", name: "Discount", isFilterValue: false));
      appliedFilter.add(
          new AppliedFilterList(type: "0", name: "Sort", isFilterValue: false));
      // appliedFilter.add(new AppliedFilterList(
      //     type: "0", name: "Occasion", isFilterValue: false));
      _scrollController1 = ScrollController()..addListener(_scrollListener);
      _scrollController2 = ScrollController()..addListener(_scrollListener2);
    } catch (e) {
      print("Exception - allEVENTSSCREEN.dart - _init():" + e.toString());
    }
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

  _onRefresh() async {
    try {
      _isDataLoaded = false;
      _isRecordPending = true;
      setState(() {});
      await _init();
    } catch (e) {
      print("Exception - all_categories_screen.dart - _onRefresh():" +
          e.toString());
    }
  }

  // _shimmer() {
  //AAAC useless code
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Shimmer.fromColors(
  //         baseColor: Colors.grey.shade300,
  //         highlightColor: Colors.grey.shade100,
  //         child: GridView.builder(
  //             itemCount: 12,
  //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //               crossAxisCount: 3,
  //               mainAxisSpacing: 16.0,
  //               crossAxisSpacing: 12.0,
  //               childAspectRatio: 0.7,
  //             ),
  //             itemBuilder: (context, index) =>
  //                 SizedBox(height: 130, width: 90, child: Card()))),
  //   );
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
}
