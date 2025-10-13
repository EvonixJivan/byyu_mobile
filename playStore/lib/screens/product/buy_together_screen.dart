import 'dart:io';

import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/screens/auth/login_screen.dart';
import 'package:byyu/screens/filter_screen.dart';
import 'package:byyu/screens/home_screen.dart';
import 'package:byyu/screens/product/all_categories_screen.dart';
import 'package:byyu/widgets/bottom_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:byyu/controllers/cart_controller.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';

import 'package:byyu/models/categoryProductModel.dart';
import 'package:byyu/models/productFilterModel.dart';

import 'package:byyu/widgets/products_menu.dart';

class BuyTogetherScreen extends BaseRoute {
  double? totalCartPrice;
  BuyTogetherScreen({
    a,
    o,
    this.totalCartPrice
  }) : super(a: a, o: o, r: 'BuyTogetherScreen');

  @override
  _BuyTogetherScreenState createState() => _BuyTogetherScreenState(this.totalCartPrice);
}

class _BuyTogetherScreenState extends BaseRouteState {
  // final CartController cartController = Get.put(CartController());
  List<AddOnProduct> _productsList = [];
  bool _isDataLoaded = false;
  ScrollController _scrollController = ScrollController();
  String apiResponseMessage = "";
  int page = 1;
  bool _isMoreDataLoaded = false, _isRecordPending = false;
  double? grandTotal;
  double subTotal = 329.5;
  String? responseMessage;
  int _qty = 1;
  double? totalCartPrice;

  _BuyTogetherScreenState(this.totalCartPrice);

  @override
  Widget build(BuildContext context) {
    //TextTheme textTheme = Theme.of(context).textTheme;c
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorConstants.white,
        // centerTitle: true,
        leadingWidth: 50,
        centerTitle: false,
        toolbarHeight: 60,
        titleSpacing: 0,
        title: Container(
          // width: 450,
          child: Text(
            "Buy Together",
            // style: textTheme.titleLarge, maxLines: 1,
            style: TextStyle(
                color: ColorConstants.pureBlack,
                fontFamily: global.fontRailwayRegular,
                fontWeight: FontWeight
                    .w200), //TextStyle(fontSize: 16, color: global.indigoColor, fontWeight: FontWeight.bold),
          ),
        ),
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
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
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: GridView.builder(
                        controller: _scrollController,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 0,
                            childAspectRatio: (Platform.isIOS &&
                                    MediaQuery.of(context).size.height < 700
                                ? (MediaQuery.of(context).size.width + 10) /
                                    (MediaQuery.of(context).size.height / 1.49)
                                : Platform.isIOS
                                    ? (MediaQuery.of(context).size.width + 10) /
                                        (MediaQuery.of(context).size.height /
                                            1.85)
                                    : (MediaQuery.of(context).size.width + 10) /
                                        (MediaQuery.of(context).size.height /
                                            1.65))),
                        itemCount: _productsList.length,
                        shrinkWrap: false,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {},
                            child: Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    showModalBottomSheet<void>(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              topLeft: Radius.circular(20))),
                                      isScrollControlled: true,
                                      isDismissible: true,
                                      useSafeArea: true,
                                      context: context,
                                      builder: (BuildContext Ncontext) {
                                        return Container(
                                          height: MediaQuery.of(Ncontext)
                                                  .copyWith()
                                                  .size
                                                  .height *
                                              0.65,
                                          child: StatefulBuilder(
                                            builder: (stfContext, stfSetState) {
                                              return Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.of(Ncontext)
                                                              .pop();
                                                              
                                                          stfSetState(() {});
                                                        },
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 10, top: 10),
                                                          width: 22,
                                                          height: 22,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  ColorConstants
                                                                      .pureBlack,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              30))),
                                                          child: Icon(
                                                            MdiIcons.close,
                                                            size: 20,
                                                            color:
                                                                ColorConstants
                                                                    .white,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Expanded(
                                                    child:
                                                        SingleChildScrollView(
                                                            child: Stack(
                                                      children: [
                                                        Container(
                                                          width:
                                                              MediaQuery.sizeOf(
                                                                      Ncontext)
                                                                  .width,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: <Widget>[
                                                                Image.asset(
                                                                  _productsList[
                                                                          index]
                                                                      .productImage!,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  height: MediaQuery.of(
                                                                              Ncontext)
                                                                          .copyWith()
                                                                          .size
                                                                          .height *
                                                                      0.35,
                                                                  width: MediaQuery.of(
                                                                          Ncontext)
                                                                      .size
                                                                      .width,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                ),
                                                                SizedBox(
                                                                    height: 20),
                                                                Text(
                                                                  "${_productsList[index].productName}",
                                                                  maxLines:
                                                                      null,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          global
                                                                              .fontMontserratMedium,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w200,
                                                                      fontSize:
                                                                          20,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                SizedBox(
                                                                    height: 10),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          right:
                                                                              8),
                                                                      child:
                                                                          Text(
                                                                        "AED ",
                                                                        style: TextStyle(
                                                                            fontFamily: global
                                                                                .fontRailwayRegular,
                                                                            fontWeight: FontWeight
                                                                                .w200,
                                                                            fontSize:
                                                                                18,
                                                                            color:
                                                                                ColorConstants.pureBlack),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      "${_productsList[index].price!.toStringAsFixed(2)}",
                                                                      style: TextStyle(
                                                                          fontFamily: global
                                                                              .fontRailwayRegular,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize:
                                                                              24,
                                                                          color:
                                                                              ColorConstants.pureBlack),
                                                                    ),
                                                                    _productsList[index].price! <
                                                                            _productsList[index]
                                                                                .mrp!
                                                                        ? Stack(
                                                                            children: [
                                                                                Container(
                                                                                  margin: EdgeInsets.only(left: 5),
                                                                                  padding: EdgeInsets.only(top: 2, bottom: 2),
                                                                                  child: Text(
                                                                                    int.parse(_productsList[index].mrp.toString().substring(_productsList[index].mrp.toString().indexOf(".") + 1)) > 0 ? "${_productsList[index].mrp!.toStringAsFixed(2)}" : "${_productsList[index].mrp.toString().substring(0, _productsList[index].mrp.toString().indexOf("."))}",
                                                                                    style: TextStyle(fontFamily: global.fontRailwayRegular, fontWeight: FontWeight.w200, fontSize: 11, color: Colors.grey),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  margin: EdgeInsets.only(left: 5),
                                                                                  child: Center(
                                                                                    child: Transform.rotate(
                                                                                      angle: 0,
                                                                                      child: Text(
                                                                                        "----",
                                                                                        textAlign: TextAlign.center,
                                                                                        maxLines: 1,
                                                                                        style: TextStyle(fontFamily: global.fontRailwayRegular, fontWeight: FontWeight.w200, fontSize: 11, color: Colors.grey),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ])
                                                                        : Container(),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height: 10),
                                                                Text(
                                                                  "${_productsList[index].description}",
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        global
                                                                            .fontRailwayRegular,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w200,
                                                                    fontSize:
                                                                        14,
                                                                    color: ColorConstants
                                                                        .pureBlack,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Row(
                                                      children: [
                                                        // Expanded(
                                                        //     child: Text("")),
                                                        Visibility(
                                                          visible: _productsList[
                                                                          index]
                                                                      .isAdded !=
                                                                  null
                                                              ? !_productsList[
                                                                      index]
                                                                  .isAdded!
                                                              : false,
                                                          child: InkWell(
                                                            onTap: () {
                                                              _productsList[
                                                                      index]
                                                                  .qty = 1;
                                                              _productsList[
                                                                      index]
                                                                  .cartQty = 1;
                                                              _productsList[
                                                                          index]
                                                                      .isAdded =
                                                                  true;
                                                              calculateTotal();
                                                              Navigator.of(Ncontext)
                                                              .pop();
                                                              
                                                              // stfSetState(
                                                              //     () {});
                                                            },
                                                            child: Container(
                                                              height: 35,
                                                              width: MediaQuery.of(
                                                                          Ncontext)
                                                                      .size
                                                                      .width -
                                                                  20,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  color: ColorConstants
                                                                      .appColor,
                                                                  border: Border.all(
                                                                      width:
                                                                          0.5,
                                                                      color: ColorConstants
                                                                          .appColor)),
                                                              child: Center(
                                                                child: Text(
                                                                    "ADD",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          fontMontserratMedium,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          16,
                                                                      color: ColorConstants
                                                                          .white,
                                                                      letterSpacing:
                                                                          1,
                                                                    )),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Visibility(
                                                          visible: _productsList[
                                                                          index]
                                                                      .isAdded !=
                                                                  null
                                                              ? _productsList[
                                                                      index]
                                                                  .isAdded!
                                                              : false,
                                                          child: Container(
                                                            width: MediaQuery.of(
                                                                        Ncontext)
                                                                    .size
                                                                    .width -
                                                                20,
                                                            // margin: EdgeInsets
                                                            //     .only(
                                                            //         top:
                                                            //             8),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                 "Quantity:  ",
                                                                
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        global
                                                                            .fontRailwayRegular,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w200,
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    _productsList[
                                                                            index]
                                                                        .cartQty = _productsList[index]
                                                                            .cartQty! -
                                                                        1;

                                                                    
                                                                    if (_productsList[index].cartQty !=
                                                                            null &&
                                                                        _productsList[index].cartQty ==
                                                                            0) {
                                                                      _productsList[
                                                                              index]
                                                                          .cartQty = 0;
                                                                      _productsList[index]
                                                                              .isAdded =
                                                                          false;
                                                                      stfSetState(
                                                                          () {});
                                                                    }
                                                                    calculateTotal();
                                                                    stfSetState(
                                                                        () {});
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            right:
                                                                                5),
                                                                    width: 22,
                                                                    height: 22,
                                                                    decoration: BoxDecoration(
                                                                        color: ColorConstants
                                                                            .appColor,
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(5))),
                                                                    child: Icon(
                                                                      _productsList[index].cartQty != null &&
                                                                              _productsList[index].cartQty! >
                                                                                  1
                                                                          ? MdiIcons
                                                                              .minus
                                                                          : MdiIcons
                                                                              .trashCan,
                                                                      size: 20,
                                                                      color: ColorConstants
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  _productsList[index].cartQty !=
                                                                              null &&
                                                                          _productsList[index].cartQty! >
                                                                              0
                                                                      ? "${_productsList[index].cartQty}"
                                                                      : "1",
                                                                  // _qty != null
                                                                  //     ? "1"
                                                                  //     : "${product.cartQty}",
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        global
                                                                            .fontRailwayRegular,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w200,
                                                                    fontSize:
                                                                        18,
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    _productsList[
                                                                            index]
                                                                        .cartQty = _productsList[index]
                                                                            .cartQty! +
                                                                        1;
                                                                    calculateTotal();
                                                                    stfSetState(
                                                                        () {});
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                5),
                                                                    width: 22,
                                                                    height: 22,
                                                                    decoration: BoxDecoration(
                                                                        color: ColorConstants
                                                                            .appColor,
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(5))),
                                                                    child: Icon(
                                                                      MdiIcons
                                                                          .plus,
                                                                      size: 20,
                                                                      color: ColorConstants
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                    child: Text(
                                                                        "")),
                                                                InkWell(
                                                                  onTap: () {
                                                                    _productsList[
                                                                            index]
                                                                        .cartQty = 0;
                                                                    _productsList[index]
                                                                              .isAdded =
                                                                          false;
                                                                    calculateTotal();
                                                                    
                                                                    stfSetState(
                                                                        () {});
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height: 35,
                                                                    width: MediaQuery.of(Ncontext)
                                                                            .size
                                                                            .width /
                                                                        2.5,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10),
                                                                        color: ColorConstants
                                                                            .appColor,
                                                                        border: Border.all(
                                                                            width:
                                                                                0.5,
                                                                            color:
                                                                                ColorConstants.appColor)),
                                                                    child:
                                                                        Center(
                                                                      child: Text(
                                                                          "REMOVE",
                                                                          textAlign: TextAlign
                                                                              .center,
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                fontMontserratMedium,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                ColorConstants.white,
                                                                            letterSpacing:
                                                                                1,
                                                                          )),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ).then((value) => calculateTotal());
                                  },
                                  child: Container(
                                      width: 195,
                                      child: Card(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            side: BorderSide(
                                              color: ColorConstants.greyfaint,
                                              width: 0.5,
                                            )),
                                        elevation: 0,
                                        child: Stack(
                                          children: [
                                            Column(
                                              children: [
                                                Card(
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: Container(
                                                    height: 120,
                                                    alignment: Alignment.center,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      child: Stack(children: [
                                                        // CachedNetworkImage(
                                                        //   width:
                                                        //       MediaQuery.of(context)
                                                        //           .size
                                                        //           .width,
                                                        //   height:
                                                        //       MediaQuery.of(context)
                                                        //           .size
                                                        //           .height,
                                                        //   fit: BoxFit.contain,
                                                        //   imageUrl:

                                                        //       global.imageBaseUrl +
                                                        //           _productsList[
                                                        //                   index]
                                                        //               .productImage! +
                                                        //           "?width=500&height=500",
                                                        //   placeholder: (context,
                                                        //           url) =>
                                                        //       Center(
                                                        //           child:
                                                        //               CircularProgressIndicator(
                                                        //     strokeWidth: 1.0,
                                                        //   )),
                                                        //   errorWidget: (context, url,
                                                        //           error) =>
                                                        //       Container(
                                                        //           child: Image.asset(
                                                        //     global.noImage,
                                                        //     fit: BoxFit.fill,
                                                        //     width: 175,
                                                        //     height: 110,
                                                        //     alignment:
                                                        //         Alignment.center,
                                                        //   )),
                                                        // ),

                                                        Image.asset(
                                                          _productsList[index]
                                                              .productImage!,
                                                          fit: BoxFit.contain,
                                                          height: 120,
                                                          width: 175,
                                                          alignment:
                                                              Alignment.center,
                                                        ),
                                                        Visibility(
                                                          visible: false,
                                                          child: Container(
                                                            width: 175,
                                                            height: 200,
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .bottomLeft,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    width: 45,
                                                                    height: 22,
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(2),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.only(
                                                                            bottomLeft: Radius.circular(
                                                                                8)),
                                                                        color: ColorConstants
                                                                            .ratingContainerColor),
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .star,
                                                                          size:
                                                                              18,
                                                                          color: Colors
                                                                              .yellow
                                                                              .shade400,
                                                                        ),
                                                                        Text(
                                                                          "${_productsList[index].rating}",
                                                                          style: TextStyle(
                                                                              fontFamily: global.fontRailwayRegular,
                                                                              fontSize: 11,
                                                                              fontWeight: FontWeight.w200,
                                                                              color: ColorConstants.white),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    height: 22,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.only(
                                                                            bottomRight: Radius.circular(
                                                                                8)),
                                                                        color: Colors
                                                                            .black38),
                                                                    padding: EdgeInsets.only(
                                                                        bottom:
                                                                            5,
                                                                        top: 5,
                                                                        left: 6,
                                                                        right:
                                                                            6),
                                                                    child: Text(
                                                                        "${_productsList[index].countrating} Reviews",
                                                                        style: TextStyle(
                                                                            fontFamily: global
                                                                                .fontRailwayRegular,
                                                                            fontSize:
                                                                                11,
                                                                            fontWeight:
                                                                                FontWeight.w200,
                                                                            color: ColorConstants.white)),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Visibility(
                                                          visible: _productsList[
                                                                          index]
                                                                      .stock! >
                                                                  0
                                                              ? false
                                                              : true,
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            child: Center(
                                                              child: Transform
                                                                  .rotate(
                                                                angle: 12,
                                                                child: Text(
                                                                  "Currently Product\nis Unavailable",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  maxLines: 2,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          global
                                                                              .fontMontserratLight,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w200,
                                                                      fontSize:
                                                                          14,
                                                                      color: ColorConstants
                                                                          .appColor),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                    ),
                                                  ),
                                                ),
                                                //paste from here
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: 5, right: 5),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Flexible(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(top: 8),
                                                              child: Text(
                                                                "${_productsList[index].productName}",
                                                                maxLines: 1,
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
                                                                        16,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    color: ColorConstants
                                                                        .pureBlack),
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(top: 5),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            right:
                                                                                8),
                                                                    child: Text(
                                                                      "AED ",
                                                                      style: TextStyle(
                                                                          fontFamily: global
                                                                              .fontRailwayRegular,
                                                                          fontWeight: FontWeight
                                                                              .w200,
                                                                          fontSize:
                                                                              13,
                                                                          color:
                                                                              ColorConstants.pureBlack),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "${_productsList[index].price!.toStringAsFixed(2)}",
                                                                    // int.parse(_productsList[
                                                                    //                 index].
                                                                    //             price
                                                                    //             .toString()) ==
                                                                    //         0
                                                                    //     ? "${_productsList[index].price}"
                                                                    //     : int.parse(_productsList[index]

                                                                    //                 .price
                                                                    //                 .toString()
                                                                    //                 .substring(_productsList[index].price.toString().indexOf(".") + 1)) >
                                                                    //             0
                                                                    //         ? "${_productsList[index].price!.toStringAsFixed(2)}"
                                                                    //         : "${_productsList[index].price.toString().substring(0, _productsList[index].price.toString().indexOf("."))}",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            global
                                                                                .fontRailwayRegular,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontSize:
                                                                            15,
                                                                        color: ColorConstants
                                                                            .pureBlack),
                                                                  ),
                                                                  _productsList[index]
                                                                              .price! <
                                                                          _productsList[index]
                                                                              .mrp!
                                                                      ? Stack(
                                                                          children: [
                                                                              Container(
                                                                                margin: EdgeInsets.only(left: 5),
                                                                                padding: EdgeInsets.only(top: 2, bottom: 2),
                                                                                child: Text(
                                                                                  int.parse(_productsList[index].mrp.toString().substring(_productsList[index].mrp.toString().indexOf(".") + 1)) > 0 ? "${_productsList[index].mrp!.toStringAsFixed(2)}" : "${_productsList[index].mrp.toString().substring(0, _productsList[index].mrp.toString().indexOf("."))}",
                                                                                  style: TextStyle(fontFamily: global.fontRailwayRegular, fontWeight: FontWeight.w200, fontSize: 11, color: Colors.grey),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                margin: EdgeInsets.only(left: 5),
                                                                                alignment: Alignment.center,
                                                                                child: Center(
                                                                                  child: Transform.rotate(
                                                                                    angle: 0,
                                                                                    child: Text(
                                                                                      "----",
                                                                                      textAlign: TextAlign.center,
                                                                                      maxLines: 1,
                                                                                      style: TextStyle(fontFamily: global.fontRailwayRegular, fontWeight: FontWeight.w200, fontSize: 11, color: Colors.grey),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ])
                                                                      : Container(),
                                                                ],
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                    child: Text(
                                                                        "")),
                                                                Visibility(
                                                                  visible: _productsList[index]
                                                                              .isAdded !=
                                                                          null
                                                                      ? !_productsList[
                                                                              index]
                                                                          .isAdded!
                                                                      : false,
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      _productsList[
                                                                              index]
                                                                          .qty = 1;
                                                                      _productsList[
                                                                              index]
                                                                          .cartQty = 1;
                                                                      _productsList[index]
                                                                              .isAdded =
                                                                          true;
                                                                      calculateTotal();
                                                                      
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              8,
                                                                          right:
                                                                              8,
                                                                          top:
                                                                              5,
                                                                          bottom:
                                                                              5),
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                              top: 8),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        color: ColorConstants
                                                                            .appColor,
                                                                      ),
                                                                      child: Text(
                                                                          "ADD",
                                                                          maxLines:
                                                                              1,
                                                                          textAlign: TextAlign
                                                                              .center,
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                fontMontserratMedium,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                ColorConstants.white,
                                                                            letterSpacing:
                                                                                1,
                                                                          )),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Visibility(
                                                                  visible: _productsList[index]
                                                                              .isAdded !=
                                                                          null
                                                                      ? _productsList[
                                                                              index]
                                                                          .isAdded!
                                                                      : false,
                                                                  child:
                                                                      Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        3,
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                8),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            _productsList[index].cartQty =
                                                                                _productsList[index].cartQty! - 1;

                                                                            
                                                                            if (_productsList[index].cartQty != null &&
                                                                                _productsList[index].cartQty == 0) {
                                                                              _productsList[index].cartQty = 0;
                                                                              _productsList[index].isAdded = false;
                                                                              setState(() {});
                                                                            }
                                                                            calculateTotal();
                                                                            
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            margin:
                                                                                EdgeInsets.only(right: 5),
                                                                            width:
                                                                                22,
                                                                            height:
                                                                                22,
                                                                            decoration:
                                                                                BoxDecoration(color: ColorConstants.appColor, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                            child:
                                                                                Icon(
                                                                              _productsList[index].cartQty != null && _productsList[index].cartQty! > 1 ? MdiIcons.minus : MdiIcons.trashCan,
                                                                              size: 20,
                                                                              color: ColorConstants.white,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          _productsList[index].cartQty != null && _productsList[index].cartQty! > 0
                                                                              ? "${_productsList[index].cartQty}"
                                                                              : "1",
                                                                          // _qty != null
                                                                          //     ? "1"
                                                                          //     : "${product.cartQty}",
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                global.fontRailwayRegular,
                                                                            fontWeight:
                                                                                FontWeight.w200,
                                                                            fontSize:
                                                                                16,
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            _productsList[index].cartQty =
                                                                                _productsList[index].cartQty! + 1;
                                                                            calculateTotal();
                                                                            
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            margin:
                                                                                EdgeInsets.only(left: 5),
                                                                            width:
                                                                                22,
                                                                            height:
                                                                                22,
                                                                            decoration:
                                                                                BoxDecoration(color: ColorConstants.appColor, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                            child:
                                                                                Icon(
                                                                              MdiIcons.plus,
                                                                              size: 20,
                                                                              color: ColorConstants.white,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            _productsList[index].stock! > 0
                                                ? Container()
                                                : Container(
                                                    alignment: Alignment.center,
                                                    decoration:
                                                        new BoxDecoration(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.7)),
                                                  ),
                                          ],
                                        ),
                                      )),
                                ),
                                _productsList[index].stock! > 0
                                    ? Positioned(
                                        left: 4,
                                        top: 3,
                                        child: Padding(
                                          padding: const EdgeInsets.all(1),
                                          child: _productsList[index]
                                                          .discount !=
                                                      null &&
                                                  _productsList[index]
                                                          .discount! >
                                                      0
                                              ? Container(
                                                  height: 35,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    8)),
                                                    image: new DecorationImage(
                                                      image: new AssetImage(
                                                          'assets/images/discount_label_bg.png'),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "${_productsList[index].discount}%\nOFF",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          fontSize: 10,
                                                          fontFamily: global
                                                              .fontRailwayRegular,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                )
                                              : SizedBox(
                                                  height: 1,
                                                  width: 1,
                                                ),
                                        ),
                                      )
                                    : Positioned(
                                        bottom: 20,
                                        child: Padding(
                                          padding: const EdgeInsets.all(1),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: Center(
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: ColorConstants.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    border: Border.all(
                                                        color: ColorConstants
                                                            .allBorderColor)),
                                                child: Text(
                                                  "Sold Out",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w200,
                                                      fontSize: 15,
                                                      fontFamily: global
                                                          .fontRailwayRegular,
                                                      color:
                                                          ColorConstants.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          );
                        }),
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
                      "No Products Available",
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
      bottomNavigationBar: Container(
        height:itemsAddedCount>0?99: 60,
        color: Colors.transparent,
        padding: EdgeInsets.only(bottom: 10, top: itemsAddedCount>0?1:5),
        child: Column(
          children: [
            Visibility(
              visible: itemsAddedCount>0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: ColorConstants.appreddimColor,

                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 15,
                        color: ColorConstants.pureBlack,
                      ),
                      SizedBox(width: 5,),
                      Text(
                        "${itemsAddedCount} ${itemsAddedCount>1?"items":"item"} added to your cart",
                        style: TextStyle(
                          fontFamily: global.fontRailwayRegular,
                          fontWeight: FontWeight.w400,
                          color: ColorConstants.pureBlack,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: itemsAddedCount>0?8:0,),
            Container(
              margin: EdgeInsets.only(left: 10,right: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(
                            fontFamily: global.fontMontserratLight,
                            fontWeight: FontWeight.w200,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "AED ${grandTotal}",
                          style: TextStyle(
                            fontFamily: global.fontMontserratLight,
                            fontWeight: FontWeight.w200,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  BottomButton(
                    loadingState: false,
                    disabledState: false,
                    onPressed: () {
                      if (global.currentUser.id != null) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomeScreen(
                                  a: widget.analytics,
                                  o: widget.observer,
                                  selectedIndex: 2,
                                )));
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginScreen(
                                  a: widget.analytics,
                                  o: widget.observer,
                                )));
                      }
                    },
                    child: Text(
                      'SKIP & CONTINUE',
                      style: TextStyle(
                          fontFamily: fontMontserratMedium,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: ColorConstants.white,
                          letterSpacing: 1),
                    ),
                  ),
                ],
              ),
            ),
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

  _getBuyTogetherProductList() async {
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
      List<AddOnProduct> _tList = [];
      await apiHelper
          .getCategoryProducts(5, page, new ProductFilter(), 1)
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
              // _productsList.addAll(_tList);
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
      // await _getBuyTogetherProductList();
      subTotal=totalCartPrice!;
      grandTotal = subTotal;
      _productsList.add(new AddOnProduct(
          "10 Red Heart Shape Balloons",
          "assets/images/1.jpg",
          2260.0,
          1999.00,
          10,
          100,
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          1));
      _productsList.add(new AddOnProduct(
          "Anniversay Bottle",
          "assets/images/2.jpg",
          2032.0,
          1199.00,
          10,
          100,
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          1));
      _productsList.add(new AddOnProduct(
          "Balloon Birthday 3pcs",
          "assets/images/3.jpg",
          890.0,
          690.00,
          10,
          100,
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          1));
      _productsList.add(new AddOnProduct(
          "Best Wishes Bamboo In Mug",
          "assets/images/4.jpg",
          1575.0,
          1299.00,
          10,
          100,
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          1));
      _productsList.add(new AddOnProduct(
          "Birthday Card and Ferrero",
          "assets/images/5.jpg",
          570.0,
          459.00,
          10,
          100,
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          1));
      _productsList.add(new AddOnProduct(
          "Chocolate Medley Box 9 Pc",
          "assets/images/6.jpg",
          2489.0,
          2199.00,
          10,
          100,
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          1));
      _productsList.add(new AddOnProduct(
          "Chocolate Mono Cake Combo",
          "assets/images/7.jpg",
          2260.0,
          1989.00,
          10,
          100,
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          1));
      _productsList.add(new AddOnProduct(
          "Greeting Card As Per Occasion",
          "assets/images/8.jpg",
          342.0,
          290.00,
          10,
          100,
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          1));
      _productsList.add(new AddOnProduct(
          "Happy Birthday Cup Cake 4 Pcs",
          "assets/images/9.jpg",
          1804.0,
          1700.00,
          10,
          100,
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          1));
      _productsList.add(new AddOnProduct(
          "It's All About You Premium Mug",
          "assets/images/10.jpg",
          2489.0,
          2302.00,
          10,
          100,
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          1));
      _productsList.add(new AddOnProduct(
          "Mango Goodness By Feel good Tea",
          "assets/images/11.jpg",
          1347.0,
          1199.00,
          10,
          100,
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          1));
      _productsList.add(new AddOnProduct(
          "Red Flower Teddy Bear",
          "assets/images/12.jpg",
          3402.0,
          1199.00,
          10,
          100,
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          1));
      _scrollController = ScrollController()..addListener(_scrollListener);
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - productlist_screen.dart - _init():" + e.toString());
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
        // _getBuyTogetherProductList();
      }
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

  showBottomSheet() {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.width / 2.5,
          decoration: const BoxDecoration(
              color: ColorConstants.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25), topLeft: Radius.circular(25))),
          child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [],
              )),
        );
      },
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
 int itemsAddedCount=0;
  void calculateTotal() {
    double calculate=0;
    itemsAddedCount=0;
    print("this is item addedcount -------${itemsAddedCount}");
    grandTotal=0;
    for (int i = 0; i < _productsList.length; i++) {
      if (_productsList[i].isAdded != null && _productsList[i].isAdded!) {
        print("hello");
        itemsAddedCount=itemsAddedCount+1;
        calculate=0;
        calculate=(_productsList[i].cartQty! * _productsList[i].price!);
        grandTotal =
             grandTotal!+calculate; 
      }
    }
    grandTotal=grandTotal!+subTotal;
    print("this is item addedcount -------${itemsAddedCount}");
    setState(() {});
  }
}
