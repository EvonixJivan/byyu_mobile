import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/screens/product/sub_categories_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:byyu/constants/image_constants.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/categoryListModel.dart';
import 'package:byyu/models/subCategoryModel.dart';

import '../models/businessLayer/global.dart';

class SelectCategoryCard extends StatefulWidget {
  final CategoryList? category;
  final String? isHomeSelected;
  final Function? onPressed;
  final bool? isSelected;
  final double? borderRadius;
  final SubCategory? subCategory;
  final key;
  final int? screenId;
  final int? index;
  final dynamic analytics;
  final dynamic observer;
  //final int sortedList;
  SelectCategoryCard(
      {this.analytics,
      this.observer,
      this.category,
      @required this.isSelected,
      @required this.onPressed,
      this.borderRadius,
      this.key,
      this.subCategory,
      this.screenId,
      this.index,
      //this.sortedList,
      this.isHomeSelected})
      : super();

  @override
  _SelectCategoryCardState createState() => _SelectCategoryCardState(
      analytics: analytics,
      observer: observer,
      category: category,
      isSelected: isSelected,
      onPressed: onPressed,
      borderRadius: borderRadius,
      key: key,
      subCategory: subCategory,
      screenId: screenId,
      index: index,
      //sortedList: sortedList,
      isHomeSelected: isHomeSelected);
}

class _SelectCategoryCardState extends State<SelectCategoryCard> {
  CategoryList? category;
  Function? onPressed;
  bool? isSelected;
  double? borderRadius;
  SubCategory? subCategory;
  var key;
  String? isHomeSelected;
  int? screenId;
  int? index;
  final dynamic analytics;
  final dynamic observer;
  //int sortedList;
  _SelectCategoryCardState(
      {this.analytics,
      this.observer,
      this.category,
      @required this.isSelected,
      @required this.onPressed,
      this.borderRadius,
      this.key,
      this.subCategory,
      this.screenId,
      this.index,

      // this.sortedList,
      this.isHomeSelected});

  @override
  Widget build(BuildContext context) {
    // double containerWidth;

  

    return InkWell(
        onTap: () {
          onPressed!();
        },
        child: index! % 2 == 0
            ? Container(
                margin: EdgeInsets.only(top: 3, bottom: 3, right: 8, left: 8),
                color: Colors.transparent,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: (MediaQuery.of(context).size.width / 2),
                    child: Row(children: [
                      Container(
                        width: (MediaQuery.of(context).size.width / 2) - 10,
                        child: CachedNetworkImage(
                          imageUrl: imageBaseUrl + category!.image!,
                          imageBuilder: (context, imageProvider) => Container(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  // topRight: Radius.circular(8),
                                  // bottomRight: Radius.circular(8)),
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover)),
                            ),
                          ),
                          placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                            strokeWidth: 1.0,
                          )),
                          errorWidget: (context, url, error) => Container(
                            //height: 100,
                            width: (MediaQuery.of(context).size.width / 2) - 50,
                            child: Image.asset(global.noImage),
                          ),
                        ),
                      ),
                      Container(
                        //color: Colors.amber,
                        width: (MediaQuery.of(context).size.width / 2) - 30,
                        height: (MediaQuery.of(context).size.width / 2),
                        margin: EdgeInsets.only(top: 10, left: 14, bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: (MediaQuery.of(context).size.width / 2),
                              child: Text(
                                "${category!.title}",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontFamily: global.fontRailwaySemibold,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w200,
                                    overflow: TextOverflow.ellipsis,
                                    color: ColorConstants.newTextHeadingFooter),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              width: (MediaQuery.of(context).size.width / 2),
                              height: (MediaQuery.of(context).size.width / 2.8),
                              child: ListView.builder(
                                  itemCount: category!.subcategory!.length > 5
                                      ? 5
                                      : category!.subcategory!.length,
                                  scrollDirection: Axis.vertical,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) => InkWell(
                                        onTap: () {
                                          print(
                                              "Catagory id on click---${category!.catId}");
                                          // setState(() {
                                          //   category.map((e) => e.isSelected = false).toList();
                                          //   category = index;
                                          //   if (_selectedIndex == index) {
                                          //     _categoryList[index].isSelected = true;
                                          //   }
                                          // });

                                        
                                          print(
                                              "SubCategory id on click---${category!.subcategory![index].catId}");
                                          setState(() {});

                                          print(
                                              "SubCategory id on click---${category!.subcategory![index].catId}");
                                          global.isSubCatSelected = true;
                                          global.homeSelectedCatID = category!
                                              .subcategory![index].catId!;
                                          global.parentCatID = category!.catId!;
                                          global.isEventProduct = false;
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SubCategoriesScreen(
                                                        a: analytics,
                                                        o: observer,
                                                        showCategories: true,
                                                        screenHeading: category!
                                                            .subcategory![index]
                                                            .title,
                                                        categoryId: category!
                                                            .subcategory![index]
                                                            .catId,
                                                        isSubcategory: global
                                                            .isSubCatSelected,
                                                        isEventProducts: false,
                                                        //subscriptionProduct: 1,
                                                      )));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(top: 10),
                                          child: Text(
                                            "${category!.subcategory![index].title}",
                                            style: TextStyle(
                                                fontFamily: global
                                                    .fontRailwaySemibold,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                overflow: TextOverflow.ellipsis,
                                                color:
                                                    ColorConstants.newTextHeadingFooter),
                                          ),
                                        ),
                                      )),
                            )
                          ],
                        ),
                      )
                    ]),
                  ),
                ))
            : Container(
                margin: EdgeInsets.only(top: 3, bottom: 3, right: 8, left: 8),
                color: Colors.transparent,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: (MediaQuery.of(context).size.width / 2),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: (MediaQuery.of(context).size.width / 2) - 30,
                            height: (MediaQuery.of(context).size.width / 2),
                            margin: EdgeInsets.only(top: 10, left: 14),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width:
                                      (MediaQuery.of(context).size.width / 2),
                                  child: Text(
                                    "${category!.title}",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontFamily: global.fontRailwaySemibold,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w200,
                                        overflow: TextOverflow.ellipsis,
                                        color: ColorConstants.newTextHeadingFooter),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 8),
                                  width:
                                      (MediaQuery.of(context).size.width / 2),
                                  height:
                                      (MediaQuery.of(context).size.width / 2.8),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          category!.subcategory!.length > 5
                                              ? 5
                                              : category!.subcategory!.length,
                                      scrollDirection: Axis.vertical,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) => InkWell(
                                            onTap: () {
                             

                                              print(
                                                  "SubCategory id on click---${category!.subcategory![index].catId}");
                                              setState(() {});

                                              print(
                                                  "SubCategory id on click---${category!.subcategory![index].catId}");
                                              global.isSubCatSelected = true;
                                              global.homeSelectedCatID =
                                                  category!.subcategory![index]
                                                      .catId!;
                                              global.parentCatID =
                                                  category!.catId!;
                                              global.isEventProduct = false;
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SubCategoriesScreen(
                                                            a: analytics,
                                                            o: observer,
                                                            showCategories: true,
                                                            screenHeading:
                                                                category!
                                                                    .subcategory![
                                                                        index]
                                                                    .title,
                                                            categoryId: category!
                                                                .subcategory![
                                                                    index]
                                                                .catId,
                                                            isSubcategory: global
                                                                .isSubCatSelected,
                                                            isEventProducts:
                                                                false,
                                                            //subscriptionProduct: 1,
                                                          )));
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(top: 10),
                                              child: Text(
                                            "${category!.subcategory![index].title}",
                                            style: TextStyle(
                                                fontFamily: global
                                                    .fontRailwaySemibold,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                overflow: TextOverflow.ellipsis,
                                                color:
                                                    ColorConstants.newTextHeadingFooter),
                                          ),
                                            ),
                                          )),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: (MediaQuery.of(context).size.width / 2) - 10,
                            child: CachedNetworkImage(
                              imageUrl: imageBaseUrl + category!.image!,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    // topRight: Radius.circular(8),
                                    // bottomRight: Radius.circular(8)),
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover)),
                              ),
                              placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(
                                strokeWidth: 1.0,
                              )),
                              errorWidget: (context, url, error) => Container(
                                //height: 100,
                                width: (MediaQuery.of(context).size.width / 2) -
                                    50,
                                child: Image.asset(global.noImage),
                              ),
                            ),
                          ),
                        ]),
                  ),
                )));
  }

  @override
  void initState() {
    super.initState();
  }
}
