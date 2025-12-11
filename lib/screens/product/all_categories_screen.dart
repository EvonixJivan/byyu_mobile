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
  bool? fromNavBar;
  AllCategoriesScreen({a, o, this.fromHomeScreen,this.fromNavBar})
      : super(a: a, o: o, r: 'AllCategoriesScreen');

  @override
  _AllCategoriesScreenState createState() => _AllCategoriesScreenState(
      fromNavBar: fromNavBar
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
  bool? fromNavBar;
  _AllCategoriesScreenState({this.fromNavBar});
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: ColorConstants.colorPageBackground,
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
                fontFamily: global.fontRailwayRegular,
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
  backgroundColor: ColorConstants.white,
  centerTitle: true,
  automaticallyImplyLeading: false,

  // Back Icon
  leading: IconButton(
    icon: Icon(Icons.arrow_back,  color: ColorConstants.appColor,),
    onPressed: () {
      Navigator.pop(context);
    },
  ),

  // Center Title
  title: Text(
    "All Categories",
    style: TextStyle(
      fontFamily: global.fontRailwayRegular,
      fontWeight: FontWeight.normal,
      color: ColorConstants.appColor,
    ),
  ),
),
   

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

 
  _init() async {
    try {
      await _getCategoryList();
  
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
