import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/screens/product/filtered_sub_categories_screen.dart';
import 'package:byyu/widgets/bottom_button.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:numberpicker/numberpicker.dart';
import '../constants/color_constants.dart'; // adjust path if needed
// import your BottomButton and FilteredSubCategoriesScreen here

class SideDrawer extends StatefulWidget {
  final dynamic analytics;
  final dynamic observer;

  const SideDrawer({super.key, this.analytics, this.observer});

  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  // Visibility flags
  bool showRecipientField = true;
  bool showRelationField = false;
  bool showAgeField = false;
  bool showOcassionField = false;

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
                      fontFamily:
                          "Metropolis", // replace with global.fontMetropolisRegular
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: ColorConstants.pureBlack),
                ),
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
          if (showRecipientField)
            Wrap(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: ColorConstants.allBorderColor),
                  ),
                  child: Column(
                    children: [
                      // const Text("Choose Recipient",
                      //     style: TextStyle(
                      //         fontWeight: FontWeight.w600,
                      //         fontSize: 15,
                      //         color: Colors.black),
                      //         ),

                      // const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          // Your tap action here
                          showRelationField = true;
                          setState(() {}); // If inside a StatefulWidget
                        },
                        child: const Text(
                          "Choose Recipient",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, childAspectRatio: 1.7),
                        itemCount: selectionData?.searchGender?.length ?? 0,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var gender = selectionData.searchGender[index];
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  recipient = gender.name;
                                  selectedRecipient_ID = gender.id.toString();
                                  showRelationField = true;
                                  setState(() {});
                                },
                                child: Container(
                                  height: 70,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: gender.selectedGender!
                                              ? ColorConstants.appColor
                                              : ColorConstants.allBorderColor)),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        global.imageBaseUrl + gender.icon!,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(gender.name, textAlign: TextAlign.center),
                            ],
                          );
                        },
                      ),

                      // Relation Selection
                      if (showRelationField)
                        Column(
                          children: [
                            const Text("Choose Relation",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Colors.black)),
                            const SizedBox(height: 8),
                            // You can use the same GridView.builder logic for relations here
                          ],
                        ),

                      // Age Picker
                      if (showAgeField)
                        Column(
                          children: [
                            const Text("Choose Age",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Colors.black)),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                NumberPicker(
                                  minValue: 18,
                                  maxValue: 113,
                                  step: 5,
                                  value: _mincurrentValue,
                                  onChanged: (value) {
                                    _mincurrentValue = value;
                                    _maxcurrentValue = _mincurrentValue + 5;
                                    selectedAge =
                                        "$_mincurrentValue - $_maxcurrentValue";
                                    showOcassionField = true;
                                    setState(() {});
                                  },
                                ),
                                const Text("TO"),
                                NumberPicker(
                                  minValue: 23,
                                  maxValue: 118,
                                  step: 5,
                                  value: _maxcurrentValue,
                                  onChanged: (value) {
                                    _maxcurrentValue = value;
                                    _mincurrentValue = _maxcurrentValue - 5;
                                    selectedAge =
                                        "$_mincurrentValue - $_maxcurrentValue";
                                    showOcassionField = true;
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),

                      // Occasion Selection
                      if (showOcassionField)
                        GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, childAspectRatio: 1),
                          itemCount: selectionData?.searchOccasion?.length ?? 0,
                          itemBuilder: (context, index) {
                            var occ = selectionData.searchOccasion[index];
                            return InkWell(
                              onTap: () {
                                ocassion = occ.id.toString();
                                selectedOccasion_ID = occ.id;
                                // Navigate to filtered screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FilteredSubCategoriesScreen(
                                      a: widget.analytics,
                                      o: widget.observer,
                                      minAge: _mincurrentValue,
                                      maxAge: _maxcurrentValue,
                                      // genderID: selectedRecipient_ID,
                                      // relationID: selectedRelation_ID,
                                      ocassionID: selectedOccasion_ID,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: global.imageBaseUrl + occ.icon!,
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(occ.name, textAlign: TextAlign.center),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),

          // Footer Image
          // Container(
          //   margin: const EdgeInsets.only(top: 10),
          //   color: Colors.transparent,
          //   child: Image.asset(
          //     "assets/images/iv_cakes_card.png",
          //     fit: BoxFit.cover,
          //     height: 185,
          //     width: MediaQuery.of(context).size.width,
          //   ),
          // ),
        ],
      ),
    );
  }
}
