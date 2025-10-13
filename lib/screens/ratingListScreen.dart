import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/controllers/cart_controller.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
//import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/rateModel.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;

class RatingListScreen extends BaseRoute {
  final int varientId;
  RatingListScreen(this.varientId, {a, o})
      : super(a: a, o: o, r: 'RatingListScreen');
  @override
  _RatingListScreenState createState() =>
      new _RatingListScreenState(this.varientId);
}

class _RatingListScreenState extends BaseRouteState {
  int varientId;
  List<Rate> _ratingList = [];
  bool _isDataLoaded = false;
  int page = 1;
  bool _isRecordPending = true;
  bool _isMoreDataLoaded = false;
  GlobalKey<ScaffoldState>? _scaffoldKey;
  ScrollController _scrollController = ScrollController();
  _RatingListScreenState(this.varientId) : super();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      color: Colors.white,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: ColorConstants.appBarColorWhite,
          leading: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: ColorConstants.newAppColor),
        
          centerTitle: false,
          title: Text(
            // "${AppLocalizations.of(context).tle_product_rating}",
            "Product Ratings",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: ColorConstants.pureBlack,
                fontFamily: fontRailwayRegular,
                fontWeight: FontWeight.w200), //textTheme.titleLarge,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: RefreshIndicator(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            color: Theme.of(context).primaryColor,
            onRefresh: () async {
              _isDataLoaded = false;
              _isRecordPending = true;
              _ratingList.clear();
              setState(() {});
              await _init();
            },
            child: _isDataLoaded
                ? _ratingList.length > 0
                    ? SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _ratingList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return
                                    // Column(
                                    //   mainAxisSize: MainAxisSize.min,
                                    //   children: [
                                    //     ListTile(
                                    //       contentPadding: EdgeInsets.all(0),
                                    //       title: Text(
                                    //         _ratingList[index].userName,
                                    //         style: Theme.of(context)
                                    //             .textTheme
                                    //             .subtitle1,
                                    //       ),
                                    //       subtitle: Text(
                                    //           '${_ratingList[index].description}',
                                    //           style: Theme.of(context)
                                    //               .textTheme
                                    //               .bodyText1),
                                    //       trailing: RatingBar.builder(
                                    //         initialRating:
                                    //             _ratingList[index].rating,
                                    //         minRating: 0,
                                    //         direction: Axis.horizontal,
                                    //         allowHalfRating: true,
                                    //         itemCount: 5,
                                    //         itemSize: 25,
                                    //         itemPadding: EdgeInsets.symmetric(
                                    //             horizontal: 1.0),
                                    //         itemBuilder: (context, _) => Icon(
                                    //           Icons.star,
                                    //           color: Theme.of(context).primaryColor,
                                    //         ),
                                    //         ignoreGestures: true,
                                    //         updateOnDrag: false,
                                    //         onRatingUpdate: (val) {},
                                    //         tapOnlyMode: false,
                                    //       ),
                                    //     ),
                                    //     Divider(
                                    //       color:
                                    //           Theme.of(context).dividerTheme.color,
                                    //     ),
                                    //   ],
                                    // );
                                    Container(
                                  width:
                                      (MediaQuery.of(context).size.width / 2) +
                                          70,
                                  child: GetBuilder<CartController>(
                                    // init: cartController,
                                    builder: (value) => Card(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          side: BorderSide(
                                            color: ColorConstants.greyfaint,
                                            width: 0.5,
                                          )),
                                      // shape: RoundedRectangleBorder(
                                      //   side: BorderSide(
                                      //     color: Color(0xffF4F4F4),
                                      //     width: 1.5,
                                      //   ),
                                      //   borderRadius: BorderRadius.circular(4.0),
                                      // ),
                                      elevation: 0,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                top: 10, left: 10),
                                            width: (MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2),

                                            //color: Colors.amber,
                                            child: Text(
                                              "${_ratingList[index].userName!.capitalizeFirst}",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: global
                                                    .fontRailwayRegular,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                top: 10, left: 10),
                                            child: RatingBar.builder(
                                              initialRating:
                                                  _ratingList[index].rating!,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              updateOnDrag: false,
                                              ignoreGestures: true,
                                              itemCount: 5,
                                              itemSize: 20,
                                              itemPadding: EdgeInsets.symmetric(
                                                  horizontal: 0.5),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {
                                                print(rating);
                                              },
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                top: 10, left: 10),
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2) +
                                                50,
                                            height: (MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2) -
                                                150,
                                            //color: Colors.amber,
                                            child: Text(
                                              _ratingList[index].description!,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: global
                                                    .fontRailwayRegular,
                                                fontWeight: FontWeight.w200,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            _isMoreDataLoaded
                                ? Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : SizedBox()
                          ],
                        ),
                      )
                    : Center(
                        child: Text(
                          // "${AppLocalizations.of(context).txt_nothing_to_show}",
                          "Nothing is yet to see here",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: global.fontMontserratLight,
                              fontSize: 20,
                              fontWeight: FontWeight.w200,
                              color: ColorConstants.guidlinesGolden),
                        ),
                      )
                : _shimmerWidget(),
          ),
        ),
      ),
    );
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

  _getData() async {
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        if (_isRecordPending) {
          setState(() {
            _isMoreDataLoaded = true;
          });
          if (_ratingList.isEmpty) {
            page = 1;
          } else {
            page++;
          }
          await apiHelper
              .getProductRating(page, varientId)
              .then((result) async {
            if (result != null) {
              if (result.status == "1") {
                List<Rate> _tList = result.data;
                if (_tList.isEmpty) {
                  _isRecordPending = false;
                }
                _ratingList.addAll(_tList);
                setState(() {
                  _isMoreDataLoaded = false;
                });
              }
            }
          });
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey!);
      }
    } catch (e) {
      print("Exception - RatingListScreen.dart - _getData():" + e.toString());
    }
  }

  _init() async {
    try {
      await _getData();
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent &&
            !_isMoreDataLoaded) {
          setState(() {
            _isMoreDataLoaded = true;
          });
          await _getData();
          setState(() {
            _isMoreDataLoaded = false;
          });
        }
      });
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - RatingListScreen.dart - _init():" + e.toString());
    }
  }

  Widget _shimmerWidget() {
    try {
      return ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
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
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                    child: Card(),
                  ),
                  Divider(
                    color: Theme.of(context).dividerTheme.color,
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      print("Exception - RatingListScreen.dart - _shimmerWidget():" +
          e.toString());
      return SizedBox();
    }
  }
}
