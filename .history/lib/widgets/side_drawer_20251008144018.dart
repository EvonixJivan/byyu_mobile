import 'package:byyu/models/businessLayer/apiHelper.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/screens/product/filtered_sub_categories_screen.dart';
import 'package:byyu/widgets/bottom_button.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:numberpicker/numberpicker.dart';
import '../constants/color_constants.dart';
// import 'package:byyu/models/businessLayer/baseRoute.dart';
// import 'package:byyu/models/businessLayer/global.dart';
// adjust path if needed
// import your BottomButton and FilteredSubCategoriesScreen here

class SideDrawer extends StatefulWidget {
  final dynamic analytics;
  final dynamic observer;

  const SideDrawer({super.key, this.analytics, this.observer});

  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  APIHelper apiHelper = APIHelper();
  // Visibility flags
  bool showRecipientField = true;
  bool showRelationField = false;
  bool showAgeField = false;
  bool showOcassionField = false;
  bool _isDataLoaded = false, _isLoading = false;

  // Selection variables
  String recipient = '';
  String relation = '';
  String ocassion = '';
  bool hideRecipientField = false;

  String selectedAge = '';

  int _mincurrentValue = 18;
  int _maxcurrentValue = 23;

  int? selectedRecipient_ID,
      selectedRelation_ID,
      selectedOccasion_ID,
      selectedAge_ID;

  // Data lists (replace dynamic with actual types)
  dynamic selectionData;
  List<dynamic> maleRelation = [];
  List<dynamic> femaleRelation = [];
  @override
  void initState() {
    // TODO: implement initState
    callFiltersApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85, // 80% of screen width
      child: showRecipientField
          ? SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 40),
                  // Container(
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Text(
                  //         "Gifts",
                  //         style: TextStyle(
                  //           fontFamily:
                  //               "Adelia", // replace with global.fontAdelia
                  //           fontWeight: FontWeight.w200,
                  //           fontSize: 62,
                  //           color: ColorConstants.appColor,
                  //         ),
                  //       ),
                  //       SizedBox(height: 5),
                  //       Text(
                  //         "Best for your loved ones!",
                  //         style: TextStyle(
                  //           fontFamily:
                  //               "Metropolis", // replace with global.fontMetropolisRegular
                  //           fontWeight: FontWeight.w500,
                  //           fontSize: 17,
                  //           color: ColorConstants.pureBlack,
                  //         ),
                  //       ),
                  //       SizedBox(height: 12),
                  //       // You can add more widgets here if needed
                  //     ],
                  //   ),
                  // ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Menu icon container
                      Container(
                        margin: const EdgeInsets.only(
                            left: 10, right: 5, top: 5, bottom: 5),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop(); // 👈 closes the drawer
                          },
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 25,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Image.asset(
                            "assets/images/new_logo.png",
                            fit: BoxFit.contain,
                            height: 25,
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                      // “Gifts” text container
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Text(
                      "Best for your loved ones!",
                      style: TextStyle(
                        fontFamily: global
                            .fontRalewayMedium, // replace with global.fontMetropolisRegular
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                        color: ColorConstants.newTextHeadingFooter,
                      ),
                    ),
                  ),

                  _isDataLoaded
                      ? Wrap(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              margin:
                                  EdgeInsets.only(top: 10, right: 5, left: 5),
                              // decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(8),
                              //     border: Border.all(
                              //         color: ColorConstants.allBorderColor)),
                              child: Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      // hideRecipientField
                                      //     ? "Recipient; ${recipient}"
                                      //     :
                                      "Choose Recipient",
                                      style: TextStyle(
                                          fontFamily:
                                              global.fontMontserratLight,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: Colors.black),
                                    ),
                                  ),

                                  SizedBox(
                                    height: 130,
                                    child: GridView.builder(
                                        shrinkWrap: true,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          childAspectRatio: 1,
                                          crossAxisSpacing: 8,
                                          mainAxisSpacing: 8,
                                        ),
                                        // scrollDirection: Axis.vertical,
                                        itemCount:
                                            selectionData.searchGender!.length,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.1,
                                            child: Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    // openedContainerHeight = 2;
                                                    showRelationField = true;
                                                    hideRecipientField = true;
                                                    recipient = selectionData
                                                        .searchGender![index]
                                                        .name!;
                                                    selectedRecipient_ID =
                                                        selectionData
                                                            .searchGender![
                                                                index]
                                                            .id!;
                                                    for (int i = 0;
                                                        i <
                                                            selectionData
                                                                .searchGender!
                                                                .length;
                                                        i++) {
                                                      if (i == index) {
                                                        selectionData
                                                                .searchGender![i]
                                                                .selectedGender =
                                                            true;
                                                      } else {
                                                        selectionData
                                                                .searchGender![i]
                                                                .selectedGender =
                                                            false;
                                                        for (int i = 0;
                                                            i <
                                                                selectionData
                                                                    .searchRelationship!
                                                                    .length;
                                                            i++) {
                                                          if (i == index) {
                                                            selectionData
                                                                .searchRelationship![
                                                                    i]
                                                                .selectedRelation = false;
                                                          }
                                                        }
                                                        for (int i = 0;
                                                            i <
                                                                maleRelation
                                                                    .length;
                                                            i++) {
                                                          maleRelation[i]
                                                                  .selectedRelation =
                                                              false;
                                                        }
                                                        for (int i = 0;
                                                            i <
                                                                femaleRelation
                                                                    .length;
                                                            i++) {
                                                          femaleRelation[i]
                                                                  .selectedRelation =
                                                              false;
                                                        }
                                                        for (int i = 0;
                                                            i <
                                                                selectionData
                                                                    .searchRelationship!
                                                                    .length;
                                                            i++) {
                                                          selectionData
                                                              .searchRelationship![
                                                                  i]
                                                              .selectedRelation = false;
                                                        }
                                                        for (int i = 0;
                                                            i <
                                                                selectionData
                                                                    .searchAge!
                                                                    .length;
                                                            i++) {
                                                          selectionData
                                                                  .searchAge![i]
                                                                  .selectedAge =
                                                              false;
                                                        }
                                                      }
                                                    }

                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                    height: 60,
                                                    margin: EdgeInsets.only(
                                                        left: 5, right: 5),
                                                    padding: EdgeInsets.only(
                                                      top: 5,
                                                      bottom: 5,
                                                    ),
                                                    // decoration: BoxDecoration(
                                                    //     borderRadius:
                                                    //         BorderRadius.circular(8),
                                                    //     border: Border.all(
                                                    //         color: selectionData
                                                    //                 .searchGender![
                                                    //                     index]
                                                    //                 .selectedGender!
                                                    //             ? ColorConstants
                                                    //                 .appColor
                                                    //             : ColorConstants
                                                    //                 .allBorderColor)),
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          left: 5,
                                                          right: 5,
                                                          top: 5),
                                                      width: 50,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                          color: selectionData
                                                                  .searchGender![
                                                                      index]
                                                                  .selectedGender!
                                                              ? ColorConstants
                                                                  .orderDtailBorder
                                                              : ColorConstants
                                                                  .white),
                                                      child: CachedNetworkImage(
                                                        // height: 200,
                                                        imageUrl: global
                                                                .imageBaseUrl +
                                                            selectionData
                                                                .searchGender![
                                                                    index]
                                                                .icon!,
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          height: 50,
                                                          width: 50,
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
                                                                url, error) =>
                                                            Container(
                                                          width: 50.0,
                                                          height: 50.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            // borderRadius: BorderRadius.circular(15),
                                                            image:
                                                                DecorationImage(
                                                              image: AssetImage(
                                                                  "assets/images/male_icon.png"),
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    // Image.asset(
                                                    //   //"assets/images/loation_pin_green.png",
                                                    //   "assets/images/male_icon.png",
                                                    //   height: Platform.isIOS
                                                    //       ? 60
                                                    //       : 60,
                                                    //   width: Platform.isIOS
                                                    //       ? 60
                                                    //       : 60,
                                                    // ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Container(
                                                  height: 14,
                                                  child: Text(
                                                    "${selectionData.searchGender![index].name}",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontFamily: global
                                                            .fontMontserratLight,
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        fontSize: 13,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
                                  // : Container(
                                  //     width:
                                  //         MediaQuery.of(context).size.width,
                                  //     child: Text(
                                  //       "Gender : ${recipient}",
                                  //       style: TextStyle(
                                  //           fontFamily:
                                  //               global.fontMontserratLight,
                                  //           fontWeight: FontWeight.w600,
                                  //           fontSize: 15,
                                  //           color: Colors.black),
                                  //     ),
                                  //   ),

                                  SizedBox(height: 30),
                                  showRelationField
                                      ? Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Text(
                                                  "Choose Relation",
                                                  style: TextStyle(
                                                      fontFamily: global
                                                          .fontMontserratLight,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15,
                                                      color: Colors.black),
                                                ),
                                              ),
                                              // SizedBox(
                                              //   height: 8,
                                              // ),
                                              recipient.toLowerCase() ==
                                                          "male" ||
                                                      recipient.toLowerCase() ==
                                                          "female"
                                                  ? SizedBox(
                                                      height: recipient
                                                                  .toLowerCase() ==
                                                              "female"
                                                          ? 320
                                                          : 410,
                                                      child: GridView.builder(
                                                          shrinkWrap: true,
                                                          gridDelegate:
                                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                                  crossAxisCount:
                                                                      3,
                                                                  childAspectRatio:
                                                                      1.2,
                                                                  crossAxisSpacing:
                                                                      0,
                                                                  mainAxisSpacing:
                                                                      8),
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          itemCount: recipient
                                                                      .toLowerCase() ==
                                                                  "male"
                                                              ? maleRelation
                                                                  .length
                                                              : femaleRelation
                                                                  .length,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          itemBuilder:
                                                              (context, index) {
                                                            return Column(
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    showAgeField =
                                                                        true;
                                                                    showOcassionField =
                                                                        true;
                                                                    for (int i =
                                                                            0;
                                                                        i < selectionData.searchRelationship!.length;
                                                                        i++) {
                                                                      if (i ==
                                                                          index) {
                                                                        selectionData
                                                                            .searchRelationship![i]
                                                                            .selectedRelation = false;
                                                                      }
                                                                    }
                                                                    if (recipient
                                                                            .toLowerCase() ==
                                                                        "male") {
                                                                      relation =
                                                                          maleRelation[index]
                                                                              .name!;
                                                                      selectedRelation_ID =
                                                                          maleRelation[index]
                                                                              .id!;
                                                                      for (int i =
                                                                              0;
                                                                          i < femaleRelation.length;
                                                                          i++) {
                                                                        femaleRelation[i].selectedRelation =
                                                                            false;
                                                                      }
                                                                      for (int i =
                                                                              0;
                                                                          i < maleRelation.length;
                                                                          i++) {
                                                                        if (i ==
                                                                            index) {
                                                                          maleRelation[i].selectedRelation =
                                                                              true;
                                                                        } else {
                                                                          maleRelation[i].selectedRelation =
                                                                              false;
                                                                        }
                                                                      }
                                                                    } else {
                                                                      relation =
                                                                          femaleRelation[index]
                                                                              .name!;
                                                                      selectedRelation_ID =
                                                                          femaleRelation[index]
                                                                              .id!;
                                                                      for (int i =
                                                                              0;
                                                                          i < maleRelation.length;
                                                                          i++) {
                                                                        maleRelation[i].selectedRelation =
                                                                            false;
                                                                      }
                                                                      for (int i =
                                                                              0;
                                                                          i < femaleRelation.length;
                                                                          i++) {
                                                                        if (i ==
                                                                            index) {
                                                                          femaleRelation[i].selectedRelation =
                                                                              true;
                                                                        } else {
                                                                          femaleRelation[i].selectedRelation =
                                                                              false;
                                                                        }
                                                                      }
                                                                    }
                                                                    for (int i =
                                                                            0;
                                                                        i < selectionData.searchAge!.length;
                                                                        i++) {
                                                                      selectionData
                                                                          .searchAge![
                                                                              i]
                                                                          .selectedAge = false;
                                                                    }

                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets.only(
                                                                        top: 5,
                                                                        bottom:
                                                                            5,
                                                                        right:
                                                                            20,
                                                                        left:
                                                                            20),
                                                                    // decoration:
                                                                    //     // BoxDecoration(
                                                                    //     //     borderRadius:
                                                                    //     //         BorderRadius
                                                                    //     //             .circular(
                                                                    //     //                 8),
                                                                    //     //     border: recipient
                                                                    //     //                 .toLowerCase() ==
                                                                    //     //             "male"
                                                                    //     //         ? Border
                                                                    //     //             .all(
                                                                    //     //             color: maleRelation[index].selectedRelation!
                                                                    //     //                 ? ColorConstants.appColor
                                                                    //     //                 : ColorConstants.allBorderColor,
                                                                    //     //             // color: recipient.toLowerCase() == "male" && maleRelation[index].selectedRelation
                                                                    //     //             //     ? ColorConstants.appColor
                                                                    //     //             //     : recipient.toLowerCase() == "female" && femaleRelation[index].selectedRelation
                                                                    //     //             //         ? ColorConstants.appColor
                                                                    //     //             //         : ColorConstants.allBorderColor
                                                                    //     //           )
                                                                    //     //         : Border
                                                                    //     //             .all(
                                                                    //     //             color: femaleRelation[index].selectedRelation!
                                                                    //     //                 ? ColorConstants.appColor
                                                                    //     //                 : ColorConstants.allBorderColor,
                                                                    //     //             // color: recipient.toLowerCase() == "male" && maleRelation[index].selectedRelation
                                                                    //     //             //     ? ColorConstants.appColor
                                                                    //     //             //     : recipient.toLowerCase() == "female" && femaleRelation[index].selectedRelation
                                                                    //     //             //         ? ColorConstants.appColor
                                                                    //     //             //         : ColorConstants.allBorderColor
                                                                    //     //           )),
                                                                    child:
                                                                        Container(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              5,
                                                                          right:
                                                                              5,
                                                                          top:
                                                                              5),
                                                                      width: 50,
                                                                      height:
                                                                          50,
                                                                      decoration: recipient.toLowerCase() ==
                                                                              "male"
                                                                          ? BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(100),
                                                                              color: maleRelation[index].selectedRelation! ? ColorConstants.orderDtailBorder : ColorConstants.white)
                                                                          : BoxDecoration(borderRadius: BorderRadius.circular(100), color: femaleRelation[index].selectedRelation! ? ColorConstants.orderDtailBorder : ColorConstants.white),
                                                                      child:
                                                                          CachedNetworkImage(
                                                                        // height: 200,

                                                                        imageUrl: recipient.toLowerCase() ==
                                                                                "male"
                                                                            ? global.imageBaseUrl +
                                                                                maleRelation[index].icon!
                                                                            : global.imageBaseUrl + femaleRelation[index].icon!,
                                                                        imageBuilder:
                                                                            (context, imageProvider) =>
                                                                                Container(
                                                                          height:
                                                                              100,
                                                                          width:
                                                                              double.infinity,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            // borderRadius: BorderRadius.circular(10),
                                                                            image:
                                                                                DecorationImage(
                                                                              image: imageProvider,
                                                                              fit: BoxFit.contain,
                                                                              alignment: Alignment.center,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        placeholder:
                                                                            (context, url) =>
                                                                                Center(child: CircularProgressIndicator()),
                                                                        errorWidget: (context,
                                                                                url,
                                                                                error) =>
                                                                            Container(
                                                                          width:
                                                                              100.0,
                                                                          height:
                                                                              100.0,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            // borderRadius: BorderRadius.circular(15),
                                                                            image:
                                                                                DecorationImage(
                                                                              image: AssetImage("assets/images/male_icon.png"),
                                                                              fit: BoxFit.contain,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 8,
                                                                ),
                                                                Container(
                                                                  child: Text(
                                                                    recipient.toLowerCase() ==
                                                                            "male"
                                                                        ? "${maleRelation[index].name}"
                                                                        : "${femaleRelation[index].name}",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            global
                                                                                .fontMontserratLight,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w200,
                                                                        fontSize:
                                                                            13,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          }),
                                                    )
                                                  : SizedBox(
                                                      height: 750,
                                                      child: GridView.builder(
                                                        shrinkWrap: true,
                                                        gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount:
                                                                    3,
                                                                childAspectRatio:
                                                                    1,
                                                                crossAxisSpacing:
                                                                    0,
                                                                mainAxisSpacing:
                                                                    0),
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        itemCount: selectionData
                                                            .searchRelationship!
                                                            .length,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Column(
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  showAgeField =
                                                                      true;
                                                                  showOcassionField =
                                                                      true;
                                                                  relation = selectionData
                                                                      .searchRelationship![
                                                                          index]
                                                                      .id
                                                                      .toString();
                                                                  selectedRelation_ID =
                                                                      selectionData
                                                                          .searchRelationship![
                                                                              index]
                                                                          .id!;
                                                                  for (int i =
                                                                          0;
                                                                      i <
                                                                          femaleRelation
                                                                              .length;
                                                                      i++) {
                                                                    femaleRelation[i]
                                                                            .selectedRelation =
                                                                        false;
                                                                  }
                                                                  for (int i =
                                                                          0;
                                                                      i <
                                                                          maleRelation
                                                                              .length;
                                                                      i++) {
                                                                    maleRelation[i]
                                                                            .selectedRelation =
                                                                        false;
                                                                  }
                                                                  for (int i =
                                                                          0;
                                                                      i <
                                                                          selectionData
                                                                              .searchRelationship!
                                                                              .length;
                                                                      i++) {
                                                                    if (i ==
                                                                        index) {
                                                                      selectionData
                                                                          .searchRelationship![
                                                                              i]
                                                                          .selectedRelation = true;
                                                                    } else {
                                                                      selectionData
                                                                          .searchRelationship![
                                                                              i]
                                                                          .selectedRelation = false;
                                                                    }
                                                                  }
                                                                  for (int i =
                                                                          0;
                                                                      i <
                                                                          selectionData
                                                                              .searchAge!
                                                                              .length;
                                                                      i++) {
                                                                    selectionData
                                                                        .searchAge![
                                                                            i]
                                                                        .selectedAge = false;
                                                                  }

                                                                  setState(
                                                                      () {});
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets.only(
                                                                      top: 10,
                                                                      bottom:
                                                                          10,
                                                                      right: 20,
                                                                      left: 20),
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets.only(
                                                                        left: 5,
                                                                        right:
                                                                            5,
                                                                        top: 5),
                                                                    width: 50,
                                                                    height: 50,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                100),
                                                                        color: selectionData.searchRelationship![index].selectedRelation!
                                                                            ? ColorConstants.orderDtailBorder
                                                                            : ColorConstants.white),
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      // height: 200,

                                                                      imageUrl: global
                                                                              .imageBaseUrl +
                                                                          selectionData
                                                                              .searchRelationship![index]
                                                                              .icon!,
                                                                      imageBuilder:
                                                                          (context, imageProvider) =>
                                                                              Container(
                                                                        height:
                                                                            100,
                                                                        width: double
                                                                            .infinity,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          // borderRadius: BorderRadius.circular(10),
                                                                          image:
                                                                              DecorationImage(
                                                                            image:
                                                                                imageProvider,
                                                                            fit:
                                                                                BoxFit.contain,
                                                                            alignment:
                                                                                Alignment.center,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      placeholder: (context,
                                                                              url) =>
                                                                          Center(
                                                                              child: CircularProgressIndicator()),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          Container(
                                                                        width:
                                                                            100.0,
                                                                        height:
                                                                            100.0,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          // borderRadius: BorderRadius.circular(15),
                                                                          image:
                                                                              DecorationImage(
                                                                            image:
                                                                                AssetImage("assets/images/male_icon.png"),
                                                                            fit:
                                                                                BoxFit.contain,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 8,
                                                              ),
                                                              Container(
                                                                child: Text(
                                                                  "${selectionData.searchRelationship![index].name}",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          global
                                                                              .fontMontserratLight,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w200,
                                                                      fontSize:
                                                                          13,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        )
                                      : Container(),

                                  showAgeField
                                      ? Container(
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Text(
                                                  "Choose Age",
                                                  style: TextStyle(
                                                      fontFamily: global
                                                          .fontMontserratLight,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15,
                                                      color: Colors.black),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Wrap(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                          child: NumberPicker(
                                                        // value: _currentValue,
                                                        textStyle: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                ColorConstants
                                                                    .grey),
                                                        selectedTextStyle: TextStyle(
                                                            fontSize: 18,
                                                            color:
                                                                ColorConstants
                                                                    .appColor),
                                                        minValue: 18,
                                                        maxValue: 113,
                                                        step: 5,
                                                        value: _mincurrentValue,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                              top: BorderSide(
                                                                  color: ColorConstants
                                                                      .pureBlack,
                                                                  width: 1),
                                                              bottom: BorderSide(
                                                                  color: ColorConstants
                                                                      .pureBlack,
                                                                  width: 1)),
                                                        ),
                                                        onChanged: (value) {
                                                          _mincurrentValue =
                                                              value;
                                                          _maxcurrentValue =
                                                              _mincurrentValue +
                                                                  5;
                                                          selectedAge =
                                                              "${_mincurrentValue} - ${_maxcurrentValue}";
                                                          showOcassionField =
                                                              true;

                                                          setState(() {});
                                                        },
                                                      )),
                                                      Container(
                                                        child: Text(
                                                          "TO",
                                                          style: TextStyle(
                                                              fontFamily: global
                                                                  .fontMontserratLight,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      Container(
                                                          child: NumberPicker(
                                                        // value: _currentValue,
                                                        textStyle: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                ColorConstants
                                                                    .grey),
                                                        selectedTextStyle: TextStyle(
                                                            fontSize: 18,
                                                            color:
                                                                ColorConstants
                                                                    .appColor),
                                                        minValue: 23,
                                                        step: 5,
                                                        maxValue: 118,
                                                        value: _maxcurrentValue,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                              top: BorderSide(
                                                                  color: ColorConstants
                                                                      .pureBlack,
                                                                  width: 1),
                                                              bottom: BorderSide(
                                                                  color: ColorConstants
                                                                      .pureBlack,
                                                                  width: 1)),
                                                        ),
                                                        onChanged: (value) {
                                                          _maxcurrentValue =
                                                              value;
                                                          _mincurrentValue =
                                                              _maxcurrentValue -
                                                                  5;
                                                          selectedAge =
                                                              "${_mincurrentValue} - ${_maxcurrentValue}";
                                                          showOcassionField =
                                                              true;

                                                          setState(() {});
                                                        },
                                                      )),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),

                                  showOcassionField
                                      ? Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Text(
                                                  "Choose Occassion",
                                                  style: TextStyle(
                                                      fontFamily: global
                                                          .fontMontserratLight,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15,
                                                      color: Colors.black),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              GridView.builder(
                                                  shrinkWrap: true,
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 3,
                                                          childAspectRatio: 1),
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemCount: selectionData
                                                      .searchOccasion!.length,
                                                  physics: ScrollPhysics(),
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Column(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            ocassion = selectionData
                                                                .searchOccasion![
                                                                    index]
                                                                .id
                                                                .toString();
                                                            selectedOccasion_ID =
                                                                selectionData
                                                                    .searchOccasion![
                                                                        index]
                                                                    .id!;
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            FilteredSubCategoriesScreen(
                                                                              a: widget.analytics,
                                                                              o: widget.observer,
                                                                              minAge: _mincurrentValue,
                                                                              maxAge: _maxcurrentValue,
                                                                              genderID: selectedRecipient_ID,
                                                                              relationID: selectedRelation_ID,
                                                                              ocassionID: selectedOccasion_ID,
                                                                            )));

                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 10,
                                                                    bottom: 10,
                                                                    right: 20,
                                                                    left: 20),
                                                            // decoration: BoxDecoration(
                                                            //     borderRadius:
                                                            //         BorderRadius
                                                            //             .circular(8),
                                                            //     border: Border.all(
                                                            //         color: ColorConstants
                                                            //             .allBorderColor)),
                                                            child:
                                                                CachedNetworkImage(
                                                              // height: 200,
                                                              height: 50,
                                                              width: 50,
                                                              imageUrl: global
                                                                      .imageBaseUrl +
                                                                  selectionData
                                                                      .searchOccasion![
                                                                          index]
                                                                      .icon!,
                                                              imageBuilder:
                                                                  (context,
                                                                          imageProvider) =>
                                                                      Container(
                                                                height: 100,
                                                                width: 100,
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
                                                              errorWidget:
                                                                  (context, url,
                                                                          error) =>
                                                                      Container(
                                                                width: 100.0,
                                                                height: 100.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  // borderRadius: BorderRadius.circular(15),
                                                                  image:
                                                                      DecorationImage(
                                                                    image: AssetImage(
                                                                        "assets/images/male_icon.png"),
                                                                    fit: BoxFit
                                                                        .contain,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 8,
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 5),
                                                            child: Text(
                                                              "${selectionData.searchOccasion![index].name}",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontFamily: global
                                                                      .fontMontserratLight,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w200,
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                              SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                ],
              ),
            )
          : Container(),
    );
  }

  callFiltersApi() async {
    try {
      print('HomeScreen data');

      await apiHelper.getFiltersRelations().then((result) async {
        if (result != null) {
          selectionData = result.data;
          print("${result}");
          maleRelation.clear();
          femaleRelation.clear();
          for (int i = 0; i < selectionData.searchRelationship!.length; i++) {
            if (selectionData.searchRelationship![i].type != null &&
                selectionData.searchRelationship![i].type!.toLowerCase() ==
                    "m") {
              maleRelation.add(selectionData.searchRelationship![i]);
            } else if (selectionData.searchRelationship![i].type != null &&
                selectionData.searchRelationship![i].type!.toLowerCase() ==
                    "f") {
              femaleRelation.add(selectionData.searchRelationship![i]);
            }
          }
          //selectionData = selectionFilterModel.selectionData;
          setState(() {
            _isLoading = false;
            _isDataLoaded = true;
          });
        }
      });
    } catch (e) {
      print(
          "Exception - dashboard_screen.dart callFiltersApi- _getHomeScreenData():" +
              e.toString());
    }
  }
}
