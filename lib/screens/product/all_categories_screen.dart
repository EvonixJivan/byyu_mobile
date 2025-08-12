import 'dart:io';

import 'dart:math';

import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/models/categoryProductModel.dart';
import 'package:byyu/models/productFilterModel.dart';
import 'package:byyu/screens/home_screen.dart';
import 'package:byyu/screens/search_screen.dart';
import 'package:byyu/widgets/products_menu.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

  
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:byyu/constants/image_constants.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/categoryListModel.dart';
import 'package:byyu/screens/address/addressListScreen.dart';
import 'package:byyu/screens/notification_screen.dart';
import 'package:byyu/screens/product/sub_categories_screen.dart';
import 'package:byyu/widgets/select_category_card.dart';

class AllCategoriesScreen extends BaseRoute {
  int? fromHomeScreen;
  AllCategoriesScreen({a, o, this.fromHomeScreen})
      : super(a: a, o: o, r: 'AllCategoriesScreen');

  @override
  _AllCategoriesScreenState createState() => _AllCategoriesScreenState(
      //fromHomeScreen: fromHomeScreen
      );
}

class _AllCategoriesScreenState extends BaseRouteState {
  int _selectedIndex = 0;
  List<CategoryList> _categoryList = [];
  List<int> sortedList = [];
  bool _isDataLoaded = false;
  int? screenId;
  int isSelectedIndex = -1;
  ProductFilter _productFilter = new ProductFilter();
  String errorMessage = "Loading...";
  int? selectedEventID;
  bool isPageination = false;
  List<Product> _productsList = [];
  int? fromHomeScreen;
  ScrollController _scrollController2 = ScrollController();
  bool _isRecordPending = true;
  bool _isMoreDataLoaded = false;
  ScrollController _scrollController = ScrollController();
  int page = 1;
  GlobalKey<ScaffoldState>? _scaffoldKey;
  _AllCategoriesScreenState({this.fromHomeScreen});
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: white,
      appBar: fromHomeScreen == 1
          ? AppBar(
              backgroundColor: ColorConstants.appBrownFaintColor,
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
                fontFamily: global.fontMetropolisRegular,
                fontWeight: FontWeight.w200,
                fontSize: 10,
                color: ColorConstants.pureBlack),
                        )
                      : SizedBox(),
                  GestureDetector(
                    onTap: () async {
                      if (global.lat != null && global.lng != null) {
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
                                : ' No Location',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                fontFamily: global.fontMetropolisRegular,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: ColorConstants.grey),
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
              backgroundColor: ColorConstants.appBrownFaintColor,
              centerTitle: true,
              title: Text(
                  "All Categories"
                  // "${AppLocalizations.of(context).tle_all_category} "
                  ,
                  style: TextStyle(
                      fontFamily: global.fontMetropolisRegular,
                      fontWeight: FontWeight.normal,
                      color: ColorConstants.pureBlack) //textTheme.headline6,
                  ),
              leading: BackButton(
                onPressed: () {
                  if (global.iscatListRouting) {
                    global.iscatListRouting = false;
                    setState(() {});
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreen(
                                  a: widget.analytics,
                                  o: widget.observer,
                                  selectedIndex: 0,
                                )));
                  } else {
                    print("Go back");
                    Navigator.pop(context);
                  }
                },
                //icon: Icon(Icons.keyboard_arrow_left),
                color: ColorConstants.pureBlack,
              ),
            ),
      //AAA--> body
      // body: RefreshIndicator(
      //   onRefresh: () async {
      //     await _onRefresh();
      //   },
      //   child:
      //       // global.appInfo.store_id != null
      //       //     ?
      //       _isDataLoaded
      //           ? _categoryList != null
      //               ? Column(
      //                   children: [
      //                     Container(
      //                         color: ColorConstants.white,
      //                         padding: EdgeInsets.only(bottom: 5),
      //                         width: MediaQuery.of(context).size.width,
      //                         height: 110,
      //                         child:
      //                             _categoryList != null &&
      //                                     _categoryList.length > 0
      //                                 ? ListView.builder(
      //                                     itemCount: _categoryList.length,
      //                                     shrinkWrap: true,
      //                                     scrollDirection: Axis.horizontal,
      //                                     itemBuilder: (context, index) {
      //                                       return Container(
      //                                           decoration: BoxDecoration(
      //                                             borderRadius:
      //                                                 BorderRadius.circular(10),
      //                                           ),
      //                                           width: 80,
      //                                           margin: EdgeInsets.all(5),
      //                                           child: GestureDetector(
      //                                             onTap: () {
      //                                               isSelectedIndex = index;
      //                                               errorMessage = "Loading...";

      //                                               _productFilter =
      //                                                   new ProductFilter();
      //                                               _productsList.clear();

      //                                               selectedEventID =
      //                                                   _categoryList[index]
      //                                                       .catId;
      //                                               setState(() {});
      //                                               _getCategoryProduct(
      //                                                   _categoryList[index]
      //                                                       .catId!);
      //                                             },
      //                                             child: Column(
      //                                               children: [
      //                                                 Container(
      //                                                   width: 80,
      //                                                   height: 60,
      //                                                   child: Card(
      //                                                     elevation: 0,
      //                                                     shadowColor: Colors
      //                                                         .transparent,
      //                                                     shape:
      //                                                         RoundedRectangleBorder(
      //                                                       borderRadius:
      //                                                           BorderRadius
      //                                                               .circular(
      //                                                                   8.0),
      //                                                     ),
      //                                                     margin:
      //                                                         EdgeInsets.only(
      //                                                             left: 1,
      //                                                             right: 1),
      //                                                     child: Column(
      //                                                       children: [
      //                                                         ClipRRect(
      //                                                           borderRadius:
      //                                                               BorderRadius
      //                                                                   .circular(
      //                                                                       8),
      //                                                           child:
      //                                                               Container(
      //                                                             decoration:
      //                                                                 BoxDecoration(
      //                                                               borderRadius:
      //                                                                   BorderRadius.circular(
      //                                                                       10),
      //                                                               border: Border.all(
      //                                                                   color: isSelectedIndex ==
      //                                                                           index
      //                                                                       ? ColorConstants.appColor
      //                                                                       : Colors.white),
      //                                                             ),
      //                                                             width: 60,
      //                                                             height: 60,
      //                                                             child:
      //                                                                 CachedNetworkImage(
      //                                                               height: 40,
      //                                                               width: 40,
      //                                                               imageUrl: catImageBaseUrl +
      //                                                                   _categoryList[index]
      //                                                                       .image!,
      //                                                               imageBuilder:
      //                                                                   (context,
      //                                                                           imageProvider) =>
      //                                                                       Container(
      //                                                                 height: double
      //                                                                     .infinity,
      //                                                                 width: double
      //                                                                     .infinity,
      //                                                                 decoration:
      //                                                                     BoxDecoration(
      //                                                                   // borderRadius: BorderRadius.circular(10),
      //                                                                   image:
      //                                                                       DecorationImage(
      //                                                                     image:
      //                                                                         imageProvider,
      //                                                                     fit: BoxFit
      //                                                                         .contain,
      //                                                                     alignment:
      //                                                                         Alignment.center,
      //                                                                   ),
      //                                                                 ),
      //                                                               ),
      //                                                               placeholder: (context,
      //                                                                       url) =>
      //                                                                   Center(
      //                                                                       child:
      //                                                                           CircularProgressIndicator()),
      //                                                               errorWidget: (context,
      //                                                                       url,
      //                                                                       error) =>
      //                                                                   Container(
      //                                                                 decoration:
      //                                                                     BoxDecoration(
      //                                                                   // borderRadius: BorderRadius.circular(15),
      //                                                                   image:
      //                                                                       DecorationImage(
      //                                                                     image:
      //                                                                         AssetImage(global.catNoImage),
      //                                                                     fit: BoxFit
      //                                                                         .contain,
      //                                                                   ),
      //                                                                 ),
      //                                                               ),
      //                                                             ),
      //                                                           ),
      //                                                         ),
      //                                                       ],
      //                                                     ),
      //                                                   ),
      //                                                 ),
      //                                                 Container(
      //                                                   margin: EdgeInsets.only(
      //                                                       top: 8),
      //                                                   child: Column(
      //                                                     mainAxisAlignment:
      //                                                         MainAxisAlignment
      //                                                             .end,
      //                                                     crossAxisAlignment:
      //                                                         CrossAxisAlignment
      //                                                             .center,
      //                                                     children: [
      //                                                       Container(
      //                                                         padding: EdgeInsets
      //                                                             .only(
      //                                                                 left: 1,
      //                                                                 right: 1),
      //                                                         decoration:
      //                                                             BoxDecoration(
      //                                                                 color: Colors
      //                                                                     .white38),
      //                                                         child: isSelectedIndex ==
      //                                                                 index
      //                                                             ? Container(
      //                                                                 width: 60,
      //                                                                 decoration:
      //                                                                     BoxDecoration(
      //                                                                   color: ColorConstants
      //                                                                       .appColor,
      //                                                                   borderRadius:
      //                                                                       BorderRadius.circular(10),
      //                                                                 ),
      //                                                                 child:
      //                                                                     Text(
      //                                                                   "${_categoryList[index].title}",
      //                                                                   maxLines:
      //                                                                       2,
      //                                                                   textAlign:
      //                                                                       TextAlign.center,
      //                                                                   style: TextStyle(
      //                                                                       fontFamily: global
      //                                                                           .fontMetropolisRegular,
      //                                                                       fontWeight: FontWeight
      //                                                                           .w200,
      //                                                                       fontSize:
      //                                                                           12,
      //                                                                       overflow: TextOverflow
      //                                                                           .ellipsis,
      //                                                                       color: isSelectedIndex == index
      //                                                                           ? Colors.white
      //                                                                           : Colors.black),
      //                                                                 ),
      //                                                               )
      //                                                             : Container(
      //                                                                 // else  condition

      //                                                                 child:
      //                                                                     Text(
      //                                                                   "${_categoryList[index].title}",
      //                                                                   maxLines:
      //                                                                       2,
      //                                                                   textAlign:
      //                                                                       TextAlign.center,
      //                                                                   style: TextStyle(
      //                                                                       fontFamily: global
      //                                                                           .fontMetropolisRegular,
      //                                                                       fontWeight: FontWeight
      //                                                                           .w200,
      //                                                                       fontSize:
      //                                                                           12,
      //                                                                       overflow: TextOverflow
      //                                                                           .ellipsis,
      //                                                                       color: isSelectedIndex == index
      //                                                                           ? ColorConstants.appColor
      //                                                                           : Colors.black),
      //                                                                 ),
      //                                                               ),
      //                                                       ),
      //                                                     ],
      //                                                   ),
      //                                                 ),
      //                                               ],
      //                                             ),
      //                                           ));
      //                                     },
      //                                   )
      //                                 : SizedBox()),
      //                     Expanded(
      //                         child: SingleChildScrollView(
      //                       // controller: _scrollController1,
      //                       physics: NeverScrollableScrollPhysics(),
      //                       child: Container(
      //                           padding: EdgeInsets.only(
      //                               bottom: Platform.isIOS ? 150 : 110),
      //                           height:
      //                               MediaQuery.of(context).size.height - 110,
      //                           width: MediaQuery.of(context).size.width,
      //                           child: _productsList.length > 0
      //                               ? SingleChildScrollView(
      //                                   controller: _scrollController2,
      //                                   child: Column(
      //                                     children: [
      //                                       ProductsMenu(
      //                                         analytics: widget.analytics,
      //                                         observer: widget.observer,
      //                                         categoryProductList:
      //                                             _productsList,
      //                                         isHomeSelected: "events",
      //                                         passdata1: "Events",
      //                                         passdata2: selectedEventID,
      //                                         passdata3: "subscriptionProduct",
      //                                       ),
      //                                       _isMoreDataLoaded
      //                                           ? Center(
      //                                               child:
      //                                                   CircularProgressIndicator(
      //                                                 backgroundColor:
      //                                                     Colors.white,
      //                                                 strokeWidth: 1,
      //                                               ),
      //                                             )
      //                                           : SizedBox()
      //                                     ],
      //                                   ),
      //                                 )
      //                               : Container(
      //                                   width:
      //                                       MediaQuery.of(context).size.width,
      //                                   height:
      //                                       MediaQuery.of(context).size.height /
      //                                           1.5,
      //                                   decoration: BoxDecoration(
      //                                     image: DecorationImage(
      //                                         image: AssetImage(
      //                                             "assets/images/login_bg.png"),
      //                                         fit: BoxFit.cover),
      //                                   ),
      //                                   child: Center(
      //                                     child: Text(
      //                                       errorMessage,
      //                                       textAlign: TextAlign.center,
      //                                       style: TextStyle(
      //                                           fontFamily: fontMontserratLight,
      //                                           fontSize: 20,
      //                                           fontWeight: FontWeight.w200,
      //                                           color: ColorConstants
      //                                               .guidlinesGolden),
      //                                     ),
      //                                   ),
      //                                 )),
      //                     ))
      //                   ],
      //                 )
      //               : Container(
      //                   width: MediaQuery.of(context).size.width,
      //                   height: MediaQuery.of(context).size.height / 1.5,
      //                   decoration: BoxDecoration(
      //                     image: DecorationImage(
      //                         image: AssetImage("assets/images/login_bg.png"),
      //                         fit: BoxFit.cover),
      //                   ),
      //                   child: Center(
      //                     child: Text(
      //                       errorMessage,
      //                       textAlign: TextAlign.center,
      //                       style: TextStyle(
      //                           fontFamily: fontMontserratLight,
      //                           fontSize: 20,
      //                           fontWeight: FontWeight.w200,
      //                           color: ColorConstants.guidlinesGolden),
      //                     ),
      //                   ),
      //                 )
      //           : Column(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               crossAxisAlignment: CrossAxisAlignment.center,
      //               children: [
      //                 Row(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   crossAxisAlignment: CrossAxisAlignment.center,
      //                   children: [
      //                     CircularProgressIndicator(),
      //                   ],
      //                 )
      //               ],
      //             ),
      //   // : Center(
      //   //     child: Padding(
      //   //       padding: const EdgeInsets.all(15),
      //   //       child: Text(global.locationMessage),
      //   //     ),
      //   //   ),
      // ),

      body: RefreshIndicator(
        onRefresh: () async {
          await _onRefresh();
        },
        child: _isDataLoaded
            ? _categoryList != null
                ? ListView.builder(
                    // shrinkWrap: true,
                    // scrollDirection: Axis.vertical,
                    controller: _scrollController,
                    itemCount: _categoryList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) => SelectCategoryCard(
                      key: UniqueKey(),
                      category: _categoryList[index],
                      analytics: widget.analytics,
                      observer: widget.observer,
                      isSelected: _categoryList[index].isSelected,
                      isHomeSelected: "allCat",
                      index: index,
                      //sortedList: sortedList,
                      borderRadius: 0,
                      onPressed: () {
                        print(
                            "Catagory id on click---${_categoryList[index].catId}");
                        setState(() {
                          _categoryList
                              .map((e) => e.isSelected = false)
                              .toList();
                          _selectedIndex = index;
                          if (_selectedIndex == index) {
                            _categoryList[index].isSelected = true;
                          }
                        });

                        print(
                            "Catagory id on click---${_categoryList[index].catId}");
                        global.isSubCatSelected = false;
                        global.isEventProduct = false;

                        global.homeSelectedCatID = _categoryList[index].catId!;
                        global.parentCatID = _categoryList[index].catId!;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SubCategoriesScreen(
                                      a: widget.analytics,
                                      o: widget.observer,
                                      showCategories: true,
                                      screenHeading:
                                          _categoryList[index].title!,
                                      categoryId: _categoryList[index].catId!,
                                      isSubcategory: global.isSubCatSelected,
                                      isEventProducts: false,
                                    )));
                      },
                    ),
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

  @override
  void initState() {
    super.initState();
    _init();
  }

  int getIndex(int i, int length) {
    int third = ((length + 2) / 3).round();
    if (length % 3 == 1 && i >= third) {
      print("nikhil if getindex");
      // spezial, because second third is smaller
      return getIndex(i - 1, length - 1);
    }

    int group = i % third;
    print("nikhil getindex");
    return ((group) * 3 + (i / third)).round();
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

          await apiHelper
              .getCategoryList( page)
              .then((result) async {
            if (result != null) {
              List<CategoryList> _tList = result.data;
              if (_tList.isEmpty) {
                _isRecordPending = false;
              }
              _categoryList.clear();
              _categoryList.addAll(_tList);

              // for (int i = 0; i < (_categoryList.length / 2) - 1; i++) {
              //   print("nikhil----1---");
              //   print("${_categoryList[getIndex(i, _categoryList.length)]}");
              //   if (i == getIndex(i, _categoryList.length)) {
              //     print("nikhil-----if--");
              //     //sortedList.add(i);
              //     _categoryList[i].isgridView = true;
              //   } else {
              //     print("nikhil-----else--");
              //     _categoryList[i].isgridView = false;
              //   }
              // }
              // print(
              //     "This is the sorted list length------------ ${sortedList.length}");

              // if (sortedList.length < _categoryList.length) {
              //   for (int j = sortedList.length; j < _categoryList.length; j++) {
              //     sortedList.add(100);
              //     //print("this is the sorted list   ${sortedList[j]}");
              //   }
              // }
              // if (_categoryList.length > 0) {
              //   _getCategoryProduct(_categoryList[0].catId!);
              //   selectedEventID = _categoryList[0].catId;
              // }

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
      print("Exception - all_categories_screen.dart - _getCategoryList():" +
          e.toString());
    }
  }

  //         await apiHelper
  //             .getCategoryList(_categoryFilter, page)
  //             .then((result) async {
  //           if (result != null) {
  //             List<CategoryList> _tList = result.data;
  //             if (_tList.isEmpty) {
  //               _isRecordPending = false;
  //             }

  //             _categoryList.addAll(_tList);

  //             for (int i = 0; i < (_categoryList.length / 2) - 1; i++) {
  //               print("nikhil----1---");
  //               print("${_categoryList[getIndex(i, _categoryList.length)]}");
  //               if (i == getIndex(i, _categoryList.length)) {
  //                 print("nikhil-----if--");
  //                 //sortedList.add(i);
  //                 _categoryList[i].isgridView = true;
  //               } else {
  //                 print("nikhil-----else--");
  //                 _categoryList[i].isgridView = false;
  //               }
  //             }
  //             print(
  //                 "This is the sorted list length------------ ${sortedList.length}");

  //             if (sortedList.length < _categoryList.length) {
  //               for (int j = sortedList.length; j < _categoryList.length; j++) {
  //                 sortedList.add(100);
  //                 //print("this is the sorted list   ${sortedList[j]}");
  //               }
  //             }

  //             setState(() {
  //               _isMoreDataLoaded = false;
  //             });
  //           }
  //         });
  //       }
  //     } else {
  //       showNetworkErrorSnackBar1(_scaffoldKey!);
  //     }
  //   } catch (e) {
  //     print("Exception - all_categories_screen.dart - _getCategoryList():" +
  //         e.toString());
  //   }
  // }

  _init() async {
    try {
      await _getCategoryList();
      // _scrollController.addListener(() async {
      //   if (_scrollController.position.pixels ==
      //           _scrollController.position.maxScrollExtent &&
      //       !_isMoreDataLoaded) {
      //     setState(() {
      //       _isMoreDataLoaded = true;
      //     });
      //     await _getCategoryList();
      //     setState(() {
      //       _isMoreDataLoaded = false;
      //     });
      //   }
      // });
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - all_categories_screen.dart - _init():" + e.toString());
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
