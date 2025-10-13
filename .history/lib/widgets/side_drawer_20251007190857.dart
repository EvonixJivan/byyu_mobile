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
  String selectedRecipient_ID = '';
  String selectedRelation_ID = '';
  int selectedOccasion_ID = 0;
  String selectedAge = '';

  int _mincurrentValue = 18;
  int _maxcurrentValue = 23;

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
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header
          // DrawerHeader(
          //   decoration: BoxDecoration(
          //     color: ColorConstants.appBrownFaintColor,
          //   ),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     // children: const [
          //     //   CircleAvatar(
          //     //     radius: 28,
          //     //     backgroundColor: Colors.white,
          //     //     child: Icon(Icons.person, size: 40, color: Colors.brown),
          //     //   ),
          //     //   SizedBox(height: 10),
          //     //   Text(
          //     //     "Welcome, User",
          //     //     style: TextStyle(color: Colors.white, fontSize: 18),
          //     //   ),
          //     // ],
          //   ),
          // ),

          // Static Menu Items
          // ListTile(
          //   leading: const Icon(Icons.dashboard),
          //   title: const Text('Dashboard'),
          //   onTap: () => Navigator.pop(context),
          // ),
          // ListTile(
          //   leading: const Icon(Icons.person),
          //   title: const Text('Profile'),
          //   onTap: () => Navigator.pop(context),
          // ),
          // ListTile(
          //   leading: const Icon(Icons.settings),
          //   title: const Text('Settings'),
          //   onTap: () => Navigator.pop(context),
          // ),
          // const Divider(),
          // ListTile(
          //   leading: const Icon(Icons.logout),
          //   title: const Text('Logout'),
          //   onTap: () => Navigator.pop(context),
          // ),

          const SizedBox(height: 40),

          // Gifts Header & Button
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Gifts",
                  style: TextStyle(
                      fontFamily: "Adelia", // replace with global.fontAdelia
                      fontWeight: FontWeight.w200,
                      fontSize: 62,
                      color: ColorConstants.appColor),
                ),
                SizedBox(height: 5),
                Text(
                  "Best for your loved ones!",
                  style: TextStyle(
                      fontFamily: "Metropolis",
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: ColorConstants.pureBlack),
                ),
                const SizedBox(height: 12),
                // Container(
                //   margin: EdgeInsets.only(top: 10),
                //   height: 37,
                //   child: BottomButton(
                //     child: const Text(
                //       "GIFT NOW",
                //       style: TextStyle(
                //           fontFamily: "MontserratMedium", // replace
                //           fontWeight: FontWeight.bold,
                //           fontSize: 16,
                //           color: Colors.white,
                //           letterSpacing: 1),
                //     ),
                //     loadingState: false,
                //     disabledState: true,
                //     onPressed: () {
                //       showRecipientField = !showRecipientField;
                //       // Reset selections
                //       for (var item in maleRelation)
                //         item.selectedRelation = false;
                //       for (var item in femaleRelation)
                //         item.selectedRelation = false;
                //       if (selectionData != null) {
                //         selectionData.searchRelationship
                //             ?.forEach((r) => r.selectedRelation = false);
                //         selectionData.searchAge
                //             ?.forEach((a) => a.selectedAge = false);
                //         selectionData.searchGender
                //             ?.forEach((g) => g.selectedGender = false);
                //       }
                //       setState(() {});
                //     },
                //   ),
                // ),
              ],
            ),
          ),

          // Recipient Selection
          
            Wrap(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  margin:
                                      EdgeInsets.only(top: 10, right: 5, left: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: ColorConstants.allBorderColor)),
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
                                        height: 8,
                                      ),
                                      GridView.builder(
                                          shrinkWrap: true,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  childAspectRatio: 1.7),
                                          scrollDirection: Axis.vertical,
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
                                                      // hideRecipientField = true;
                                                      recipient = selectionData
                                                          .searchGender![index]
                                                          .name!;
                                                      selectedRecipient_ID =
                                                          selectionData
                                                              .searchGender![index]
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
                                                      height: 70,
                                                      margin: EdgeInsets.only(
                                                          left: 5, right: 5),
                                                      padding: EdgeInsets.only(
                                                          top: 5,
                                                          bottom: 5,
                                                          right: 40,
                                                          left: 40),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  8),
                                                          border: Border.all(
                                                              color: selectionData
                                                                      .searchGender![
                                                                          index]
                                                                      .selectedGender!
                                                                  ? ColorConstants
                                                                      .appColor
                                                                  : ColorConstants
                                                                      .allBorderColor)),
                                                      child: Container(
                                                        padding: EdgeInsets.only(
                                                            left: 5,
                                                            right: 5,
                                                            top: 5),
                                                        width: 60,
                                                        height: 50,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(100),
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
                                                            height: 100,
                                                            width: 100,
                                                            decoration:
                                                                BoxDecoration(
                                                              // borderRadius: BorderRadius.circular(10),
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit.contain,
                                                                alignment: Alignment
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
                                                            width: 100.0,
                                                            height: 100.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              // borderRadius: BorderRadius.circular(15),
                                                              image:
                                                                  DecorationImage(
                                                                image: AssetImage(
                                                                    "assets/images/male_icon.png"),
                                                                fit: BoxFit.contain,
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
          
        ],
      ),
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
