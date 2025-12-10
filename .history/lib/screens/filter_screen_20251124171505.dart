import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/apiHelper.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
//
import 'package:byyu/models/categoryListModel.dart';
import 'package:byyu/models/productFilterModel.dart';
import 'package:flutter/material.dart';
import '../models/businessLayer/global.dart';
import '../models/businessLayer/global.dart' as global;

class FilterCustomSheet extends StatefulWidget {
  ProductFilter? showFilters;
  int? filterTypeIndex;

  FilterCustomSheet({
    this.showFilters,
    this.filterTypeIndex,
  });

  @override
  State<FilterCustomSheet> createState() => _FilterCustomSheetState(
      showFilters: showFilters, filterTypeIndex: filterTypeIndex);
}

class _FilterCustomSheetState extends State<FilterCustomSheet> {
  int isIndexSelected = 0;

  ProductFilter? showFilters;
  int? filterTypeIndex;

  bool _isDataLoaded = false;
  APIHelper apiHelper = new APIHelper();
  _FilterCustomSheetState({this.showFilters, this.filterTypeIndex});
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("nikhil filter initstate");
    print(showFilters);
    if (showFilters != null) {
      print(showFilters!.filterDiscountID);
      print(showFilters!.filterPriceID);
      print(showFilters!.filterSortID);
    }
    callShowFiltersAPI();
    // if (global.globalShowFilters.message == null) {

    // } else {
    //   _isDataLoaded = true;
    // }
    // callShowFiltersAPI();
  }

  callShowFiltersAPI() async {
    try {
      // if (_isRecordPending) {

      await apiHelper.getShowFiltersData().then((result) async {
        // ye apna class se api wala function call kera hai
        if (result != null) {
          if (result.data != null) {
            global.globalShowFilters = result.data;

            for (int i = 0; i < global.globalShowFilters.sort!.length; i++) {
              if (showFilters != null &&
                  showFilters!.filterSortID != null &&
                  showFilters!.filterSortID!.length > 0 &&
                  int.parse(showFilters!.filterSortID!) ==
                      global.globalShowFilters.sort![i].id) {
                global.globalShowFilters.sort![i].isSortSelected = i + 1;
                print(global.globalShowFilters.sort![i].isSortSelected);
              }
            }
            for (int i = 0;
                i < global.globalShowFilters.filterPrice!.length;
                i++) {
              if (showFilters != null &&
                  showFilters!.filterPriceID != null &&
                  showFilters!.filterPriceID!.length > 0 &&
                  int.parse(showFilters!.filterPriceID!) ==
                      global.globalShowFilters.filterPrice![i].id) {
                global.globalShowFilters.filterPrice![i].isPriceChecked = i + 1;
                print(global.globalShowFilters.filterPrice![i].isPriceChecked);
              }
            }
            for (int i = 0;
                i < global.globalShowFilters.filterDiscount!.length;
                i++) {
              if (showFilters != null &&
                  showFilters!.filterDiscountID != null &&
                  showFilters!.filterDiscountID!.length > 0 &&
                  int.parse(showFilters!.filterDiscountID!) ==
                      global.globalShowFilters.filterDiscount![i].id) {
                global.globalShowFilters.filterDiscount![i].isDiscountChecked =
                    i + 1;
                print(global
                    .globalShowFilters.filterDiscount![i].isDiscountChecked);
              }
            }
            for (int i = 0;
                i < global.globalShowFilters.filterOcassion!.length;
                i++) {
              if (showFilters != null &&
                  showFilters!.filterOcassionID != null &&
                  showFilters!.filterOcassionID!.length > 0 &&
                  int.parse(showFilters!.filterOcassionID!) ==
                      global.globalShowFilters.filterOcassion![i].id) {
                global.globalShowFilters.filterOcassion![i].isOcassionChecked =
                    i + 1;
                print(global
                    .globalShowFilters.filterOcassion![i].isOcassionChecked);
              }
            }
            setState(() {
              _isDataLoaded = true;
            });
          }
        } else {
          _isDataLoaded = false;
        }
      });
      // }
    } catch (e) {
      _isDataLoaded = true;
      print("Exception - Filter.dart - _getEventProduct():" + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isDataLoaded
        ? Container(
            // color: Colors.white,
            padding: EdgeInsets.fromLTRB(
              0,
              0,
              0,
              MediaQuery.of(context).viewPadding.bottom +
                  5, // Prevents bottom overlap
            ),
            height: MediaQuery.of(context).size.height * 10,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Text(
                    "Filter",
                    style: TextStyle(
                        fontSize: 17,
                        fontFamily: fontRailwayRegular,
                        fontWeight: FontWeight.w600,
                        color: ColorConstants.newTextHeadingFooter),
                  ),
                ),
                // Divider(
                //   color: Colors.pink,
                // ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Container(
                      //   width: MediaQuery.of(context).size.width / 2.8,
                      //   decoration: BoxDecoration(
                      //       border: Border.all(color: ColorConstants.greyDull)),
                      //   child: Column(
                      //     children: List.generate(3, (index) {
                      //       return GestureDetector(
                      //         onTap: () {
                      //           setState(() {
                      //             isIndexSelected = index;
                      //           });
                      //         },
                      //         child: Container(
                      //           height: 40,
                      //           padding: EdgeInsets.only(left: 10),
                      //           color: isIndexSelected == index
                      //               ? ColorConstants.appColor
                      //               : Colors.white,
                      //           child: Center(
                      //             child: Row(
                      //               children: [
                      //                 Container(
                      //                   height: 40,
                      //                   width: 5,
                      //                   color: isIndexSelected == index
                      //                       ? ColorConstants.appColor
                      //                       : Colors.white,
                      //                 ),
                      //                 index == 0
                      //                     ? Text(
                      //                         "Price",
                      //                         style: TextStyle(
                      //                           color: isIndexSelected == 0
                      //                               ? ColorConstants.white
                      //                               : ColorConstants.pureBlack,
                      //                           fontSize: 15,
                      //                           fontFamily:
                      //                               fontRailwayRegular,
                      //                           fontWeight: FontWeight.normal,
                      //                         ),
                      //                       )
                      //                     : Text(""),
                      //                 index == 1
                      //                     ? Text(
                      //                         "Discounts",
                      //                         style: TextStyle(
                      //                           color: isIndexSelected == 1
                      //                               ? ColorConstants.white
                      //                               : ColorConstants.pureBlack,
                      //                           fontSize: 15,
                      //                           fontFamily:
                      //                               fontRailwayRegular,
                      //                           fontWeight: FontWeight.normal,
                      //                         ),
                      //                       )
                      //                     : Text(""),
                      //                 index == 2
                      //                     ? Text(
                      //                         "Sort By",
                      //                         style: TextStyle(
                      //                           color: isIndexSelected == 2
                      //                               ? ColorConstants.white
                      //                               : ColorConstants.pureBlack,
                      //                           fontSize: 15,
                      //                           fontFamily:
                      //                               fontRailwayRegular,
                      //                           fontWeight: FontWeight.normal,
                      //                         ),
                      //                       )
                      //                     : Text(""),
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       );
                      //     }),
                      //   ),
                      // ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      color: ColorConstants.greyDull),
                                  bottom: BorderSide(
                                      color: ColorConstants.greyDull))),
                          child: Column(
                            children: [
                              filterTypeIndex == 0
                                  ? Container(
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: global.globalShowFilters
                                              .filterPrice!.length,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Container(
                                              height: 30,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.3,
                                              child: RadioListTile(
                                                controlAffinity:
                                                    ListTileControlAffinity
                                                        .leading,
                                                activeColor:
                                                    ColorConstants.appColor,
                                                title: Transform.translate(
                                                  offset: const Offset(-15, 0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        global
                                                            .globalShowFilters
                                                            .filterPrice![index]
                                                            .name!,
                                                        style: TextStyle(
                                                          color: ColorConstants
                                                              .pureBlack,
                                                          fontSize: 12,
                                                          fontFamily:
                                                              fontOufitMedium,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                value: index + 1,
                                                groupValue: global
                                                    .globalShowFilters
                                                    .filterPrice![index]
                                                    .isPriceChecked,
                                                onChanged: (value) {
                                                  setState(
                                                    () {
                                                      print(value);
                                                      for (int i = 0;
                                                          i <
                                                              global
                                                                  .globalShowFilters
                                                                  .filterPrice!
                                                                  .length;
                                                          i++) {
                                                        if (index ==
                                                            value! - 1) {
                                                          showFilters!
                                                                  .filterPriceID =
                                                              global
                                                                  .globalShowFilters
                                                                  .filterPrice![
                                                                      index]
                                                                  .id
                                                                  .toString();
                                                          showFilters!
                                                                  .filterPriceValue =
                                                              globalShowFilters
                                                                  .filterPrice![
                                                                      index]
                                                                  .name!;
                                                          print(
                                                              "SelectedID is ${showFilters!.filterPriceID}");
                                                          global
                                                              .globalShowFilters
                                                              .filterPrice![i]
                                                              .isPriceChecked = value;
                                                        } else {
                                                          print(
                                                              "Else Value is ${value}");
                                                          global
                                                              .globalShowFilters
                                                              .filterPrice![i]
                                                              .isPriceChecked = 0;
                                                        }
                                                      }
                                                    },
                                                  );
                                                  setState(() {});
                                                },
                                              ),
                                            );
                                          }),
                                    )
                                  : Container(),
                              filterTypeIndex == 1
                                  ? Container(
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: global.globalShowFilters
                                              .filterDiscount!.length,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Container(
                                              height: 40,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.3,
                                              child: RadioListTile(
                                                controlAffinity:
                                                    ListTileControlAffinity
                                                        .leading,
                                                activeColor:
                                                    ColorConstants.newAppColor,
                                                title: Transform.translate(
                                                  offset: const Offset(-15, 0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        global
                                                            .globalShowFilters
                                                            .filterDiscount![
                                                                index]
                                                            .name!,
                                                        style: TextStyle(
                                                          color: ColorConstants
                                                              .pureBlack,
                                                          fontSize: 12,
                                                          fontFamily:
                                                              fontOufitMedium,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                value: index + 1,
                                                groupValue: global
                                                    .globalShowFilters
                                                    .filterDiscount![index]
                                                    .isDiscountChecked,
                                                onChanged: (value) {
                                                  setState(
                                                    () {
                                                      print(value);
                                                      for (int i = 0;
                                                          i <
                                                              global
                                                                  .globalShowFilters
                                                                  .filterDiscount!
                                                                  .length;
                                                          i++) {
                                                        if (index ==
                                                            value! - 1) {
                                                          print(
                                                              "Value is ${value}");
                                                          showFilters!
                                                                  .filterDiscountID =
                                                              global
                                                                  .globalShowFilters
                                                                  .filterDiscount![
                                                                      index]
                                                                  .id
                                                                  .toString();
                                                          showFilters!
                                                                  .filterDiscountValue =
                                                              globalShowFilters
                                                                  .filterDiscount![
                                                                      index]
                                                                  .name!;

                                                          global
                                                              .globalShowFilters
                                                              .filterDiscount![
                                                                  i]
                                                              .isDiscountChecked = value;
                                                        } else {
                                                          global
                                                              .globalShowFilters
                                                              .filterDiscount![
                                                                  i]
                                                              .isDiscountChecked = 0;
                                                        }
                                                      }
                                                    },
                                                  );
                                                  setState(() {});
                                                },
                                              ),
                                            );
                                          }),
                                    )
                                  : Container(),
                              filterTypeIndex == 2
                                  ? Container(
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: global
                                              .globalShowFilters.sort!.length,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Container(
                                              height: 30,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.3,
                                              child: RadioListTile(
                                                controlAffinity:
                                                    ListTileControlAffinity
                                                        .leading,
                                                activeColor:
                                                    ColorConstants.appColor,
                                                title: Transform.translate(
                                                  offset: const Offset(-15, 0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        global.globalShowFilters
                                                            .sort![index].name!,
                                                        style: TextStyle(
                                                          color: ColorConstants
                                                              .pureBlack,
                                                          fontSize: 12,
                                                          fontFamily:
                                                              fontOufitMedium,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                groupValue: global
                                                    .globalShowFilters
                                                    .sort![index]
                                                    .isSortSelected,
                                                value: index + 1,
                                                onChanged: (value) {
                                                  setState(
                                                    () {
                                                      print(value);
                                                      for (int i = 0;
                                                          i <
                                                              global
                                                                  .globalShowFilters
                                                                  .sort!
                                                                  .length;
                                                          i++) {
                                                        if (index ==
                                                            value! - 1) {
                                                          showFilters!
                                                                  .filterSortID =
                                                              global
                                                                  .globalShowFilters
                                                                  .sort![index]
                                                                  .id
                                                                  .toString();

                                                          showFilters!
                                                                  .filterSortValue =
                                                              globalShowFilters
                                                                  .sort![index]
                                                                  .name!;
                                                          global
                                                              .globalShowFilters
                                                              .sort![i]
                                                              .isSortSelected = value;
                                                        } else {
                                                          global
                                                              .globalShowFilters
                                                              .sort![i]
                                                              .isSortSelected = 0;
                                                        }
                                                      }
                                                    },
                                                  );
                                                  setState(() {});
                                                },
                                              ),
                                            );
                                          }),
                                    )
                                  : Container(),
                              filterTypeIndex == 3
                                  ? Container(
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: global.globalShowFilters
                                              .filterOcassion!.length,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Container(
                                              height: 30,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.3,
                                              child: RadioListTile(
                                                controlAffinity:
                                                    ListTileControlAffinity
                                                        .leading,
                                                activeColor:
                                                    ColorConstants.newAppColor,
                                                title: Transform.translate(
                                                  offset: const Offset(-15, 0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        global
                                                            .globalShowFilters
                                                            .filterOcassion![
                                                                index]
                                                            .name!,
                                                        style: TextStyle(
                                                          color: ColorConstants
                                                              .pureBlack,
                                                          fontSize: 12,
                                                          fontFamily:
                                                              fontOufitMedium,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                groupValue: global
                                                    .globalShowFilters
                                                    .filterOcassion![index]
                                                    .isOcassionChecked,
                                                value: index + 1,
                                                onChanged: (value) {
                                                  setState(
                                                    () {
                                                      print(value);
                                                      for (int i = 0;
                                                          i <
                                                              global
                                                                  .globalShowFilters
                                                                  .filterOcassion!
                                                                  .length;
                                                          i++) {
                                                        if (index ==
                                                            value! - 1) {
                                                          showFilters!
                                                                  .filterOcassionID =
                                                              global
                                                                  .globalShowFilters
                                                                  .filterOcassion![
                                                                      index]
                                                                  .id
                                                                  .toString();

                                                          showFilters!
                                                                  .filterOcassionValue =
                                                              globalShowFilters
                                                                  .filterOcassion![
                                                                      index]
                                                                  .name!;
                                                          global
                                                              .globalShowFilters
                                                              .filterOcassion![
                                                                  i]
                                                              .isOcassionChecked = value;
                                                        } else {
                                                          global
                                                              .globalShowFilters
                                                              .filterOcassion![
                                                                  i]
                                                              .isOcassionChecked = 0;
                                                        }
                                                      }
                                                    },
                                                  );
                                                  setState(() {});
                                                },
                                              ),
                                            );
                                          }),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 28),
                    InkWell(
                      onTap: () {
                        for (int i = 0;
                            i < global.globalShowFilters.sort!.length;
                            i++) {
                          global.globalShowFilters.sort![i].isSortSelected = 0;
                        }
                        for (int i = 0;
                            i < global.globalShowFilters.filterPrice!.length;
                            i++) {
                          global.globalShowFilters.filterPrice![i]
                              .isPriceChecked = 0;
                        }
                        for (int i = 0;
                            i < global.globalShowFilters.filterDiscount!.length;
                            i++) {
                          global.globalShowFilters.filterDiscount![i]
                              .isDiscountChecked = 0;
                        }
                        Navigator.of(context).pop(new ProductFilter());
                        setState(() {});
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                            color: Colors.white,
                            border: Border.all(
                              color: ColorConstants.appColor,
                            )),
                        child: Center(
                          child: Text(
                            "CLEAR ALL",
                            style: TextStyle(
                              fontFamily: fontOufitMedium,
                              color: ColorConstants.newTextHeadingFooter,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop(showFilters);
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        width: MediaQuery.of(context).size.width / 2.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                          color: ColorConstants.newAppColor,
                        ),
                        child: Center(
                          child: Text(
                            "APPLY",
                            style: TextStyle(
                              fontFamily: fontOufitMedium,
                              color: ColorConstants.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
