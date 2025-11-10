import 'dart:io';

import 'package:banner_image/banner_image.dart';
import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/screens/home_screen.dart';
import 'package:byyu/screens/web_view/web_view.dart';
import 'package:byyu/widgets/side_drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_picker/country_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_captcha/local_captcha.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:material_text_fields/material_text_fields.dart';
import 'package:material_text_fields/theme/material_text_field_theme.dart';
import 'package:url_launcher/url_launcher.dart';

final _formCorporateGiftsKey = GlobalKey<FormState>();

class CorporateGiftsScreen extends BaseRoute {
  CorporateGiftsScreen({a, o}) : super(a: a, o: o, r: 'CorporateGiftsScreen');
  @override
  _CorporateGiftsScreenState createState() => new _CorporateGiftsScreenState();
}

class _CorporateGiftsScreenState extends BaseRouteState {
  bool _isDataLoaded = false;
  List<String> bannerImageURL = [];
  List<String> trustUsImageURL = [];
  List<String> sampleProductsImageURL = [];
  List<String> bottomImageURI = [];
  List<int> sampleleng = [];
  double sizedboxHeight8 = 8.0;
  double sizedboxHeight14 = 10.0;
  double sizedboxWidth8 = 8.0;
  double sizedboxWidth14 = 14.0;
  double infinityHeight = 0.0;
  double infinityWidth = 0.0;
  int sampleProductLength = 0;
  TextEditingController _firstNameTextController = TextEditingController();
  FocusNode _fPhone = FocusNode();
  TextEditingController _lastNameTextController = TextEditingController();
  TextEditingController _captchaTextController = TextEditingController();
  TextEditingController _emailIDTextController = TextEditingController();
  TextEditingController _mobileTextController = TextEditingController();
  TextEditingController _messageTextController = TextEditingController();

  bool submitClicked = false;
  bool mobileValid = true;

  int _phonenumMaxLength1 = 0;
  String? countryCodeSelected, countryCodeFlg = "🇦🇪";
  String countryCode = "+971";
  String submitMessage = "";
  bool boolSubmitMessage = false;

    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  _CorporateGiftsScreenState() : super();
  @override
  Widget build(BuildContext context) {
    infinityHeight = MediaQuery.of(context).size.height;
    infinityWidth = MediaQuery.of(context).size.width;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: ColorConstants.colorPageBackground,
      drawerEnableOpenDragGesture: true,
      drawer: SideDrawer(
        analytics: widget.analytics,
        observer: widget.observer,
      ),
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: ColorConstants.white,
        automaticallyImplyLeading: false,
        leading: BackButton(
              onPressed: () {
                print("Go back");
                Navigator.pop(context);
              },
              color: ColorConstants.appColor,
            ),
        title: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomeScreen(
                      a: widget.analytics,
                      o: widget.observer,
                      selectedIndex: 0,
                    )));
          },
          child: Image.asset(
            "assets/images/new_logo.png",
            fit: BoxFit.contain,
            height: 25,
            alignment: Alignment.center,
          ),
        ),
        centerTitle: false,
      ),
      body: _isDataLoaded
          ? GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 130,
                      child: Image.asset(
                        "assets/images/corporate_banner.png",
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                      // CachedNetworkImage(
                      //   imageUrl: bannerImageURL[0],
                      //   fit: BoxFit.contain,
                      //   errorWidget: (context, child, loadingProgress) {
                      //     return Container(
                      //       height: 10,
                      //       width: 10,
                      //       child: CircularProgressIndicator(),
                      //     );
                      //   },
                      // ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: infinityWidth,
                      child: Text("Our Sample Products",
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: global.fontMontserratLight,
                              fontWeight: FontWeight.w200,
                              fontSize: 19,
                              color: Colors.black)),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      height: (infinityWidth / 2) - 50,
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: (infinityWidth / 2) - 30,
                            height: (infinityWidth / 2) - 30,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                "assets/images/corporate_product_img3.png",
                                fit: BoxFit.fill,
                                alignment: Alignment.center,
                              ),
                              // CachedNetworkImage(
                              //     imageUrl: sampleProductsImageURL[0],
                              //     fit: BoxFit.cover,
                              //     errorWidget:
                              //         (context, child, loadingProgress) {
                              //       return Container(
                              //         height: 10,
                              //         width: 10,
                              //         child: CircularProgressIndicator(),
                              //       );
                              //     }),
                            ),
                          ),
                          sampleProductsImageURL.length >= 2
                              ? Container(
                                  width: (infinityWidth / 2) - 30,
                                  height: (infinityWidth / 2) - 30,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      "assets/images/corporate_product_img15.jpg",
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                    ),
                                    //  CachedNetworkImage(
                                    //     imageUrl: sampleProductsImageURL[1],
                                    //     fit: BoxFit.cover,
                                    //     errorWidget: (context, child,
                                    //         loadingProgress) {
                                    //       return Container(
                                    //         height: 10,
                                    //         width: 10,
                                    //         child:
                                    //             CircularProgressIndicator(),
                                    //       );
                                    //     }),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: (infinityWidth / 2) - 50,
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          sampleProductsImageURL.length >= 3
                              ? Container(
                                  width: (infinityWidth / 2) - 30,
                                  height: (infinityWidth / 2) - 30,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      "assets/images/corporate_product_img1.png",
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                    ),
                                    // CachedNetworkImage(
                                    //     imageUrl: sampleProductsImageURL[2],
                                    //     fit: BoxFit.cover,
                                    //     errorWidget: (context, child,
                                    //         loadingProgress) {
                                    //       return Container(
                                    //         height: 10,
                                    //         width: 10,
                                    //         child:
                                    //             CircularProgressIndicator(),
                                    //       );
                                    //     }),
                                  ),
                                )
                              : SizedBox(),
                          sampleProductsImageURL.length >= 4
                              ? Container(
                                  width: (infinityWidth / 2) - 30,
                                  height: (infinityWidth / 2) - 30,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      "assets/images/corporate_product_img11.jpg",
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                    ),
                                    //  CachedNetworkImage(
                                    //     imageUrl: sampleProductsImageURL[1],
                                    //     fit: BoxFit.cover,
                                    //     errorWidget: (context, child,
                                    //         loadingProgress) {
                                    //       return Container(
                                    //         height: 10,
                                    //         width: 10,
                                    //         child:
                                    //             CircularProgressIndicator(),
                                    //       );
                                    //     }),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                    //Added by sahil on 20-09-2024
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          color: ColorConstants.appColor,
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: Colors.transparent, width: 1),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => WebViewScreen(
                                  userid: global.currentUser.id.toString(),
                                  platform: Platform.isIOS,
                                  paymentURL:
                                      "https://www.thegiftscatalog.com/corporate-gifts-2024/",
                                  a: widget.analytics,
                                  o: widget.observer,
                                  totalAmount: "0",
                                  // order: order,
                                ),
                                //     TapPaymentScreen(
                                //   a: widget.analytics,
                                //   o: widget.observer,
                                // ),
                              ),
                            );
                          },
                          child: Text(
                            "VIEW CATALOG",
                            style: TextStyle(
                                fontFamily: fontMontserratMedium,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: ColorConstants.white,
                                letterSpacing: 1),
                          ),
                        ),
                      ),
                    ),
                    //End
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            color: ColorConstants.corporateYellow,
                            borderRadius: BorderRadius.circular(10)),
                        width: infinityWidth,
                        child: Column(
                          children: [
                            SizedBox(
                              height: sizedboxHeight14,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("BRAND THAT",
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily:
                                            global.fontMontserratLight,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("TRUST US",
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily:
                                            global.fontMontserratLight,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: ColorConstants.appColor)),
                              ],
                            ),
    
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              height: 75,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: trustUsImageURL.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.only(
                                        left: 5, right: 5, top: 5),
                                    padding: EdgeInsets.all(10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        width: 70,
                                        height: 70,
                                        trustUsImageURL[index],
                                        fit: BoxFit.contain,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            // Container(
                            //   height: 220,
                            //   margin: EdgeInsets.only(left: 20, right: 20),
                            //   child: GridView.builder(
                            //     physics: NeverScrollableScrollPhysics(),
                            //     itemCount: trustUsImageURL.length,
                            //     shrinkWrap: true,
                            //     gridDelegate:
                            //         SliverGridDelegateWithFixedCrossAxisCount(
                            //             crossAxisCount: 2,
                            //             childAspectRatio: 1.5),
                            //     scrollDirection: Axis.vertical,
                            //     itemBuilder:
                            //         (BuildContext context, int index) {
                            //       return Container(
                            //         margin: EdgeInsets.only(
                            //             left: 5, right: 5, top: 8),
                            //         padding: EdgeInsets.all(10),
                            //         child: ClipRRect(
                            //           borderRadius:
                            //               BorderRadius.circular(8),
                            //           child: Image.asset(
                            //             trustUsImageURL[index],
                            //             fit: BoxFit.contain,
                            //             alignment: Alignment.center,
                            //           ),
    
                            //           // CachedNetworkImage(
                            //           //     imageUrl: trustUsImageURL[index],
                            //           //     fit: BoxFit.contain,
                            //           //     errorWidget: (context, child,
                            //           //         loadingProgress) {
                            //           //       return Container(
                            //           //         height: 10,
                            //           //         width: 10,
                            //           //         child:
                            //           //             CircularProgressIndicator(),
                            //           //       );
                            //           //     }),
                            //         ),
                            //       );
                            //     },
                            //   ),
                            // ),
    
                            SizedBox(
                              height: sizedboxHeight14,
                            )
                          ],
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Benefits to our",
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: global.fontMontserratLight,
                                fontWeight: FontWeight.w200,
                                fontSize: 19,
                                color: Colors.black)),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Partners",
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: global.fontMontserratLight,
                                fontWeight: FontWeight.w200,
                                fontSize: 19,
                                color: ColorConstants.appColor)),
                      ],
                    ),
    
                    SizedBox(
                      height: 20,
                    ),
    
                    Row(
                      children: [
                        Container(
                          width: (infinityWidth / 2) - 20,
                          height: 70,
                          margin: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: ColorConstants.allBorderColor)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Image.asset(
                                'assets/images/corporate_offer_icon.png',
                                width: 25,
                                height: 30,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(width: 15),
                              Container(
                                width: (infinityWidth / 2) - 90,
                                child: Text("Quality Assurance",
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontFamily:
                                            global.fontRailwayRegular,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        color: ColorConstants.pureBlack)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: (infinityWidth / 2) - 20,
                          height: 70,
                          margin: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: ColorConstants.allBorderColor)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Image.asset(
                                'assets/images/corporate_extensive_icon.png',
                                width: 30,
                                height: 30,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(width: 15),
                              Container(
                                width: (infinityWidth / 2) - 90,
                                child: Text("Extensive Product portfolio",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        height: 1.2,
                                        fontFamily:
                                            global.fontRailwayRegular,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        color: ColorConstants.pureBlack)),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sizedboxHeight14,
                    ),
                    // Container(
                    //   width: infinityWidth,
                    //   height: 70,
                    //   margin: EdgeInsets.only(left: 10, right: 10),
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(10),
                    //       border: Border.all(
                    //           color: ColorConstants.allBorderColor)),
                    //   child: Row(
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: [
                    //       SizedBox(
                    //         width: 20,
                    //       ),
                    //       Image.asset(
                    //         'assets/images/corporate_extensive_icon.png',
                    //         width: 25,
                    //         height: 25,
                    //         fit: BoxFit.fill,
                    //       ),
                    //       SizedBox(width: 15),
                    //       Column(
                    //         mainAxisAlignment: MainAxisAlignment.start,
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Expanded(child: Text("")),
                    //           Text("Extensive Product portfolio",
                    //               maxLines: 1,
                    //               textAlign: TextAlign.center,
                    //               style: TextStyle(
                    //                   fontFamily:
                    //                       global.fontRailwayRegular,
                    //                   fontWeight: FontWeight.w600,
                    //                   fontSize: 13,
                    //                   color: ColorConstants.pureBlack)),
                    //           // SizedBox(
                    //           //   height: 5,
                    //           // ),
                    //           // Text("",
                    //           //     maxLines: 1,
                    //           //     textAlign: TextAlign.center,
                    //           //     style: TextStyle(
                    //           //         fontFamily:
                    //           //             global.fontRailwayRegular,
                    //           //         fontWeight: FontWeight.w200,
                    //           //         fontSize: 11,
                    //           //         color: ColorConstants.pureBlack)),
                    //           Expanded(child: Text("")),
                    //         ],
                    //       )
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: sizedboxHeight14,
                    // ),
    
                    Container(
                      width: infinityWidth - 50, //(infinityWidth/2)-20,
                      height: 70,
                      margin: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: ColorConstants.allBorderColor)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Expanded(child: Text("")),
                          Image.asset(
                            'assets/images/corporate_ProductCustomization_icon.png',
                            width: 30,
                            height: 30,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(width: 15),
                          Text("Customization that defines your brand",
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              style: TextStyle(
                                  height: 1.2,
                                  fontFamily: global.fontRailwayRegular,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: ColorConstants.pureBlack)),
                          // Expanded(child: Text("")),
                        ],
                      ),
                    ),
    
                    SizedBox(
                      height: 24,
                    ),
                    // Container(
                    //   width: infinityWidth,
                    //   margin: EdgeInsets.only(left: 10, right: 10),
                    //   decoration: BoxDecoration(
                    //     color: ColorConstants.greyDull,
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //   child: Column(
                    //     children: [
                    //       SizedBox(
                    //         height: sizedboxHeight14,
                    //       ),
                    //       Text("CONTACT US",
                    //           maxLines: 1,
                    //           textAlign: TextAlign.center,
                    //           style: TextStyle(
                    //               fontFamily: global.fontMontserratLight,
                    //               fontWeight: FontWeight.w200,
                    //               fontSize: 19,
                    //               color: Colors.black)),
                    //       SizedBox(
                    //         height: sizedboxHeight14,
                    //       ),
                    //       Container(
                    //         decoration: BoxDecoration(
                    //             color: ColorConstants.white,
                    //             borderRadius:
                    //                 BorderRadius.all(Radius.circular(7.0))),
                    //         margin: EdgeInsets.only(
                    //             top: 0, left: 10, right: 10),
                    //         padding: EdgeInsets.only(),
                    //         child: MaterialTextField(
                    //             style: TextStyle(
                    //                 fontFamily:
                    //                     global.fontRailwayRegular,
                    //                 fontSize: 14,
                    //                 fontWeight: FontWeight.w200,
                    //                 color: ColorConstants.pureBlack),
                    //             theme: FilledOrOutlinedTextTheme(
                    //               radius: 8,
                    //               contentPadding:
                    //                   const EdgeInsets.symmetric(
                    //                       horizontal: 4, vertical: 4),
                    //               errorStyle: const TextStyle(
                    //                   fontSize: 10,
                    //                   fontFamily:
                    //                       global.fontRailwayRegular,
                    //                   fontWeight: FontWeight.w200),
                    //               fillColor: Colors.transparent,
                    //               enabledColor: Colors.grey,
                    //               focusedColor: ColorConstants.appColor,
                    //               floatingLabelStyle: const TextStyle(
                    //                   color: ColorConstants.appColor),
                    //               width: 0.5,
                    //               labelStyle: const TextStyle(
                    //                   fontSize: 14, color: Colors.grey),
                    //             ),
                    //             controller: _firstNameTextController,
                    //             labelText: "First Name*",
                    //             keyboardType: TextInputType.name,
                    //             onChanged: (val) {
                    //               boolSubmitMessage = false;
                    //               setState(() {});
                    //               if (submitClicked &&
                    //                   _formCorporateGiftsKey.currentState!
                    //                       .validate()) {
                    //                 print("Submit Data");
                    //               }
                    //             },
                    //             validator: (value) {
                    //               print(value);
                    //               if (value == null || value.isEmpty) {
                    //                 return "Please enter First Name";
                    //               } else {
                    //                 return null;
                    //               }
                    //             }),
                    //       ),
                    //       SizedBox(
                    //         height: 10,
                    //       ),
                    //       Container(
                    //         decoration: BoxDecoration(
                    //             color: ColorConstants.white,
                    //             borderRadius:
                    //                 BorderRadius.all(Radius.circular(7.0))),
                    //         margin: EdgeInsets.only(
                    //             top: 0, left: 10, right: 10),
                    //         padding: EdgeInsets.only(),
                    //         child: MaterialTextField(
                    //             style: TextStyle(
                    //                 fontFamily:
                    //                     global.fontRailwayRegular,
                    //                 fontSize: 14,
                    //                 fontWeight: FontWeight.w200,
                    //                 color: ColorConstants.pureBlack),
                    //             theme: FilledOrOutlinedTextTheme(
                    //               radius: 8,
                    //               contentPadding:
                    //                   const EdgeInsets.symmetric(
                    //                       horizontal: 4, vertical: 4),
                    //               errorStyle: const TextStyle(
                    //                   fontSize: 10,
                    //                   fontFamily:
                    //                       global.fontRailwayRegular,
                    //                   fontWeight: FontWeight.w200),
                    //               fillColor: Colors.transparent,
                    //               enabledColor: Colors.grey,
                    //               focusedColor: ColorConstants.appColor,
                    //               floatingLabelStyle: const TextStyle(
                    //                   color: ColorConstants.appColor),
                    //               width: 0.5,
                    //               labelStyle: const TextStyle(
                    //                   fontSize: 14, color: Colors.grey),
                    //             ),
                    //             controller: _lastNameTextController,
                    //             labelText: "Last Name*",
                    //             keyboardType: TextInputType.name,
                    //             onChanged: (val) {
                    //               boolSubmitMessage = false;
                    //               setState(() {});
                    //               if (submitClicked &&
                    //                   _formCorporateGiftsKey.currentState!
                    //                       .validate()) {
                    //                 print("Submit Data");
                    //               }
                    //             },
                    //             validator: (value) {
                    //               print(value);
                    //               if (value == null || value.isEmpty) {
                    //                 return "Please enter Last Name  ";
                    //               } else {
                    //                 return null;
                    //               }
                    //             }),
                    //       ),
                    //       SizedBox(
                    //         height: 10,
                    //       ),
                    //       Container(
                    //         decoration: BoxDecoration(
                    //             color: ColorConstants.white,
                    //             borderRadius:
                    //                 BorderRadius.all(Radius.circular(7.0))),
                    //         margin: EdgeInsets.only(
                    //             top: 0, left: 10, right: 10),
                    //         padding: EdgeInsets.only(),
                    //         child: MaterialTextField(
                    //             style: TextStyle(
                    //                 fontFamily:
                    //                     global.fontRailwayRegular,
                    //                 fontSize: 14,
                    //                 fontWeight: FontWeight.w200,
                    //                 color: ColorConstants.pureBlack),
                    //             theme: FilledOrOutlinedTextTheme(
                    //               radius: 8,
                    //               contentPadding:
                    //                   const EdgeInsets.symmetric(
                    //                       horizontal: 4, vertical: 4),
                    //               errorStyle: const TextStyle(
                    //                   fontSize: 10,
                    //                   fontFamily:
                    //                       global.fontRailwayRegular,
                    //                   fontWeight: FontWeight.w200),
                    //               fillColor: Colors.transparent,
                    //               enabledColor: Colors.grey,
                    //               focusedColor: ColorConstants.appColor,
                    //               floatingLabelStyle: const TextStyle(
                    //                   color: ColorConstants.appColor),
                    //               width: 0.5,
                    //               labelStyle: const TextStyle(
                    //                   fontSize: 14, color: Colors.grey),
                    //             ),
                    //             controller: _emailIDTextController,
                    //             labelText: "Email ID*",
                    //             keyboardType: TextInputType.emailAddress,
                    //             onChanged: (val) {
                    //               boolSubmitMessage = false;
                    //               setState(() {});
                    //               if (submitClicked &&
                    //                   _formCorporateGiftsKey.currentState!
                    //                       .validate()) {
                    //                 print("Submit Data");
                    //               }
                    //             },
                    //             validator: (value) {
                    //               print(value);
                    //               if (value == null || value.isEmpty) {
                    //                 return "Please enter your Email";
                    //               } else if (!EmailValidator.validate(
                    //                   value)) {
                    //                 return "Please enter valid Email";
                    //               } else {
                    //                 return null;
                    //               }
                    //             }),
                    //       ),
                    //       SizedBox(
                    //         height: 10,
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.only(
                    //           left: 10,
                    //           right: 10,
                    //         ),
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.start,
                    //           children: [
                    //             InkWell(
                    //               onTap: () {
                    //                 showCountryPicker(
                    //                   countryListTheme:
                    //                       CountryListThemeData(
                    //                           inputDecoration:
                    //                               InputDecoration(
                    //                                   hintText: "",
                    //                                   label: Text(
                    //                                     "Search",
                    //                                     style: TextStyle(
                    //                                         fontSize: 16,
                    //                                         fontFamily:
                    //                                             fontRailwayRegular,
                    //                                         color: ColorConstants
                    //                                             .appColor),
                    //                                   )),
                    //                           searchTextStyle: TextStyle(
                    //                               color: ColorConstants
                    //                                   .pureBlack),
                    //                           textStyle: TextStyle(
                    //                               fontFamily:
                    //                                   fontRailwayRegular,
                    //                               fontWeight:
                    //                                   FontWeight.w200,
                    //                               fontSize: 16,
                    //                               color: ColorConstants
                    //                                   .pureBlack,
                    //                               letterSpacing: 1)),
                    //                   context: context,
                    //                   showPhoneCode:
                    //                       true, // optional. Shows phone code before the country name.
                    //                   onSelect: (Country country) {
                    //                     boolSubmitMessage = false;
                    //                     setState(() {});
                    //                     print(
                    //                         'Select country: ${country.displayName} & ${country.countryCode} & ${country.flagEmoji}');
                    //                     countryCode = country.phoneCode;
                    //                     countryCodeFlg =
                    //                         "${country.flagEmoji}";
                    //                     countryCodeSelected =
                    //                         country.phoneCode;
                    //                     _phonenumMaxLength1 =
                    //                         country.example.length;
    
                    //                     setState(() {
                    //                       _mobileTextController.text = "";
                    //                     });
                    //                   },
                    //                 );
                    //               },
                    //               child: Container(
                    //                 height: 40,
                    //                 width: 125,
                    //                 margin: EdgeInsets.only(
                    //                     bottom: mobileValid ? 0 : 20),
                    //                 decoration: BoxDecoration(
                    //                     border: Border.all(
                    //                       color: Colors.grey.shade300,
                    //                     ),
                    //                     color: Colors.white,
                    //                     borderRadius: BorderRadius.all(
                    //                         Radius.circular(7.0))),
                    //                 child: Padding(
                    //                     padding: const EdgeInsets.fromLTRB(
                    //                         5, 1, 0, 0),
                    //                     child: Row(
                    //                       children: [
                    //                         Text(countryCodeFlg!,
                    //                             style: TextStyle(
                    //                                 fontFamily:
                    //                                     fontMontserratMedium,
                    //                                 fontWeight:
                    //                                     FontWeight.bold,
                    //                                 fontSize: 25,
                    //                                 color: ColorConstants
                    //                                     .pureBlack,
                    //                                 letterSpacing: 1)),
                    //                         Expanded(
                    //                             child: Text(
                    //                                 countryCodeSelected!,
                    //                                 style: TextStyle(
                    //                                     fontFamily:
                    //                                         fontRailwayRegular,
                    //                                     fontWeight:
                    //                                         FontWeight.w200,
                    //                                     fontSize: 16,
                    //                                     color:
                    //                                         ColorConstants
                    //                                             .pureBlack,
                    //                                     letterSpacing: 1))),
                    //                         Icon(
                    //                           Icons.arrow_drop_down,
                    //                           size: 30,
                    //                           color:
                    //                               global.bgCompletedColor,
                    //                         )
                    //                       ],
                    //                     )),
                    //               ),
                    //             ),
                    //             Expanded(
                    //               child: Container(
                    //                 height: mobileValid ? 40 : 60,
                    //                 decoration: BoxDecoration(
                    //                     color: Colors.white,
                    //                     borderRadius: BorderRadius.all(
                    //                         Radius.circular(0.0))),
                    //                 margin: EdgeInsets.only(
                    //                     left: 8,
                    //                     right: 1,
                    //                     top: 10,
                    //                     bottom: 10),
                    //                 padding: EdgeInsets.only(),
                    //                 child: TextFormField(
                    //                   inputFormatters: <TextInputFormatter>[
                    //                     FilteringTextInputFormatter
                    //                         .digitsOnly
                    //                   ],
                    //                   key: Key('1'),
                    //                   cursorColor: Colors.black,
                    //                   controller: _mobileTextController,
                    //                   style: TextStyle(
                    //                       fontSize: 14,
                    //                       fontFamily: fontRailwayRegular,
                    //                       fontWeight: FontWeight.w200,
                    //                       color: ColorConstants.pureBlack,
                    //                       letterSpacing: 1),
                    //                   keyboardType: TextInputType.phone,
                    //                   maxLength: _phonenumMaxLength1 == 0
                    //                       ? 9
                    //                       : _phonenumMaxLength1,
                    //                   focusNode: _fPhone,
                    //                   onFieldSubmitted: (val) {
                    //                     FocusScope.of(context)
                    //                         .requestFocus(_fPhone);
                    //                   },
                    //                   obscuringCharacter: '*',
                    //                   decoration: InputDecoration(
                    //                       counterText: "",
                    //                       border: OutlineInputBorder(),
                    //                       labelStyle: TextStyle(
                    //                           fontSize: 14,
                    //                           fontFamily:
                    //                               fontRailwayRegular,
                    //                           fontWeight: FontWeight.w200,
                    //                           color: _mobileTextController
                    //                                       .text.length >
                    //                                   0
                    //                               ? ColorConstants.appColor
                    //                               : ColorConstants.grey),
                    //                       labelText: "Mobile Number*",
                    //                       focusedBorder: OutlineInputBorder(
                    //                         borderRadius:
                    //                             BorderRadius.circular(7),
                    //                         borderSide: BorderSide(
                    //                             color: _mobileTextController
                    //                                         .text.length >
                    //                                     0
                    //                                 ? ColorConstants
                    //                                     .appColor
                    //                                 : Colors.grey.shade400,
                    //                             width: 0.5),
                    //                       ),
                    //                       enabledBorder: OutlineInputBorder(
                    //                         borderRadius:
                    //                             BorderRadius.circular(7),
                    //                         borderSide: BorderSide(
                    //                             color: _mobileTextController
                    //                                         .text.length >
                    //                                     0
                    //                                 ? ColorConstants
                    //                                     .appColor
                    //                                 : Colors.grey.shade400,
                    //                             width: 0.5),
                    //                       ),
                    //                       hintText: '561234567',
                    //                       errorStyle: const TextStyle(
                    //                           fontSize: 10,
                    //                           fontFamily: global
                    //                               .fontRailwayRegular,
                    //                           fontWeight: FontWeight.w200),
                    //                       hintStyle: TextStyle(
                    //                           fontFamily:
                    //                               fontRailwayRegular,
                    //                           fontSize: 14)),
                    //                   onChanged: (val) {
                    //                     boolSubmitMessage = false;
                    //                     setState(() {});
                    //                     if (submitClicked &&
                    //                         _formCorporateGiftsKey
                    //                             .currentState!
                    //                             .validate()) {}
                    //                   },
                    //                   validator: (value) {
                    //                     print(value);
                    //                     if (value == null ||
                    //                         value.isEmpty) {
                    //                       mobileValid = false;
                    //                       setState(() {});
                    //                       return "Please enter your mobile number";
                    //                     } else if (_mobileTextController
                    //                             .text.isNotEmpty &&
                    //                         _phonenumMaxLength1 == 0 &&
                    //                         _mobileTextController
                    //                                 .text.length <
                    //                             9) {
                    //                       mobileValid = false;
                    //                       setState(() {});
                    //                       return "Please enter valid mobile number";
                    //                     } else if (_phonenumMaxLength1 >
                    //                             0 &&
                    //                         _mobileTextController
                    //                                 .text.length <
                    //                             _phonenumMaxLength1) {
                    //                       mobileValid = false;
                    //                       setState(() {});
                    //                       return "Please enter valid mobile number";
                    //                     } else {
                    //                       mobileValid = true;
                    //                       setState(() {});
                    //                       return null;
                    //                     }
                    //                   },
                    //                 ),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       SizedBox(
                    //         height: 10,
                    //       ),
                    //       Container(
                    //         decoration: BoxDecoration(
                    //             color: ColorConstants.white,
                    //             borderRadius:
                    //                 BorderRadius.all(Radius.circular(7.0))),
                    //         margin: EdgeInsets.only(
                    //             top: 0, left: 10, right: 10),
                    //         padding: EdgeInsets.only(),
                    //         child: MaterialTextField(
                    //             style: TextStyle(
                    //                 fontFamily:
                    //                     global.fontRailwayRegular,
                    //                 fontSize: 14,
                    //                 fontWeight: FontWeight.w200,
                    //                 color: ColorConstants.pureBlack),
                    //             theme: FilledOrOutlinedTextTheme(
                    //               radius: 8,
                    //               contentPadding:
                    //                   const EdgeInsets.symmetric(
                    //                       horizontal: 4, vertical: 4),
                    //               errorStyle: const TextStyle(
                    //                   fontSize: 10,
                    //                   fontFamily:
                    //                       global.fontRailwayRegular,
                    //                   fontWeight: FontWeight.w200),
                    //               fillColor: Colors.transparent,
                    //               enabledColor: Colors.grey,
                    //               focusedColor: ColorConstants.appColor,
                    //               floatingLabelStyle: const TextStyle(
                    //                   color: ColorConstants.appColor),
                    //               width: 0.5,
                    //               labelStyle: const TextStyle(
                    //                   fontSize: 14, color: Colors.grey),
                    //             ),
                    //             controller: _messageTextController,
                    //             labelText: "Message*",
                    //             keyboardType: TextInputType.name,
                    //             onChanged: (val) {
                    //               boolSubmitMessage = false;
                    //               setState(() {});
                    //               // if (addButtonClicked &&
                    //               //     _formAddMemberKey
                    //               //         .currentState!
                    //               //         .validate()) {
                    //               //   print("Submit Data");
                    //               // }
                    //             },
                    //             validator: (value) {
                    //               print(value);
                    //               if (value == null || value.isEmpty) {
                    //                 return "Please enter message  ";
                    //               } else {
                    //                 return null;
                    //               }
                    //             }),
                    //       ),
    
                    //       SizedBox(
                    //         height: 10,
                    //       ),
                    //       Container(
                    //         child: InkWell(
                    //           onTap: () {
                    //             boolSubmitMessage = false;
                    //             setState(() {});
                    //             if (_formCorporateGiftsKey.currentState!
                    //                 .validate()) {
                    //               submitContactUS();
                    //             }
                    //           },
                    //           child: Padding(
                    //             padding: const EdgeInsets.only(
                    //                 left: 2, right: 2),
                    //             child: Container(
                    //               height: 35,
                    //               width: MediaQuery.of(context).size.width /
                    //                   2.2,
                    //               decoration: BoxDecoration(
                    //                   borderRadius:
                    //                       BorderRadius.circular(10),
                    //                   color: ColorConstants.appColor,
                    //                   border: Border.all(
                    //                       width: 0.5,
                    //                       color: ColorConstants.appColor)),
                    //               child: Align(
                    //                 alignment: Alignment.center,
                    //                 child: Text(
                    //                   // _productDetail.productDetail.cartQty != 0
                    //                   //     ? "GO TO CART"
                    //                   // :
                    //                   "SUBMIT",
                    //                   style: TextStyle(
                    //                       fontFamily: fontMontserratMedium,
                    //                       fontWeight: FontWeight.bold,
                    //                       fontSize: 16,
                    //                       color: ColorConstants.white,
                    //                       letterSpacing: 1),
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
    
                    //       SizedBox(
                    //         height: 10,
                    //       ),
                    //       Visibility(
                    //         visible: boolSubmitMessage,
                    //         child: Container(
                    //           margin: EdgeInsets.only(left: 10, right: 10),
                    //           child: Text(submitMessage,
                    //               textAlign: TextAlign.center,
                    //               style: TextStyle(
                    //                   fontFamily:
                    //                       global.fontRailwayRegular,
                    //                   fontWeight: FontWeight.w600,
                    //                   fontSize: 13,
                    //                   color: ColorConstants.appColor)),
                    //         ),
                    //       ),
                    //       boolSubmitMessage
                    //           ? SizedBox(
                    //               height: 10,
                    //             )
                    //           : SizedBox(),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(left: 12, right: 12),
                        height: MediaQuery.of(context).size.width / 2,
                        // height: MediaQuery.of(context).size.height - 370,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            bottomImageURI[0],
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          ),
                        )
                        // ListView.builder(
                        //   scrollDirection: Axis.horizontal,
                        // shrinkWrap: true,
                        // itemCount: 1,//bottomImageURI.length,
                        // itemBuilder: (context, index) {
                        //     return
                        // Row(
                        //   children: [
                        //     SizedBox(width: 5,),
                        //     Container(
                        //       height: 300,
                        //       // width: infinityWidth-20,
                        //       child: Expanded(
                        //         child: ClipRRect(
                        //                                         borderRadius: BorderRadius.circular(10),
                        //                                         child:Image.asset(
                        //                         bottomImageURI[index],
                        //                         fit: BoxFit.cover,
                        //                         alignment: Alignment.center,
                        //                       ),
                        //                                         ),
                        //       )),
                        //     SizedBox(width: 5,),
                        //   ],
                        // );
                        // }
                        // )
    
                        ),
    
                    // CachedNetworkImage(
                    //   imageUrl:
                    //       "https://www.byyu.com/assets/images/corporate_giftimg.png",
                    //   fit: BoxFit.cover,
                    //   errorWidget: (context, child, loadingProgress) {
                    //     return Container(
                    //       height: 10,
                    //       width: 10,
                    //       child: CircularProgressIndicator(),
                    //     );
                    //   },
                    // ),
    
                    SizedBox(
                      height: 5,
                    )
                  ],
                ),
              ),
            )
          : Container(
              width: infinityWidth,
              height: infinityHeight,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width / 3,
        
        padding: EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
        decoration: BoxDecoration(
          color: ColorConstants.appColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.transparent, width: 1),
        ),
        child: InkWell(
          onTap: () {
            boolSubmitMessage = false;
            submitMessage = "";
            contactUsView();
          },
          child: Row(
            children: [
              Icon(
                Icons.email_outlined,
                color: ColorConstants.white,
                size: 22,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "EMAIL US",
                style: TextStyle(
                    fontFamily: fontMontserratMedium,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: ColorConstants.white,
                    letterSpacing: 1),
              ),
            ],
          ),
        ),
      ),
    
      // Icon(
      //   Icons.contact_support,
      //   color: Colors.red,
      //   size: 40,
      // ),
    );
  }

  final _localCaptchaController = LocalCaptchaController();
  contactUsView() {
// Refresh captcha code.
    _localCaptchaController.refresh();
    _captchaTextController.text = "";
    showModalBottomSheet(
        isScrollControlled: true, // <-- Add this line

      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, state) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque, // Ensures taps are detected on empty space
    onTap: () {
      FocusScope.of(context).unfocus(); // Hides the keyboard
    },
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.75,
                  ),
                child: Form(
                  key: _formCorporateGiftsKey,
                  child: SingleChildScrollView(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            
                    child: Column(
                      children: [
                        SizedBox(
                          height: sizedboxHeight14,
                        ),
                        Row(
                          children: [
                            Expanded(child: Text("")),
                            Text("Email Us",
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: global.fontMontserratLight,
                                    fontWeight: FontWeight.w200,
                                    fontSize: 19,
                                    color: Colors.black)),
                            Expanded(
                                child: Row(
                              children: [
                                Expanded(child: Text("")),
                                InkWell(
                                  onTap: () async {
                                    await _launchWhatsapp(state);
                                  },
                                  child: Icon(
                                    FontAwesomeIcons.whatsapp,
                                    color: ColorConstants.whatsAppGreenColor,
                                    size: 30,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                )
                              ],
                            )),
                          ],
                        ),
              
                        SizedBox(
                          height: sizedboxHeight14,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: ColorConstants.white,
                              borderRadius: BorderRadius.all(Radius.circular(7.0))),
                          margin: EdgeInsets.only(top: 0, left: 20, right: 20),
                          padding: EdgeInsets.only(),
                          child: MaterialTextField(
                              style: TextStyle(
                                  fontFamily: global.fontRailwayRegular,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w200,
                                  color: ColorConstants.pureBlack),
                              theme: FilledOrOutlinedTextTheme(
                                radius: 8,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 4),
                                errorStyle: const TextStyle(
                                    fontSize: 10,
                                    fontFamily: global.fontRailwayRegular,
                                    fontWeight: FontWeight.w200),
                                fillColor: Colors.transparent,
                                enabledColor: Colors.grey,
                                focusedColor: ColorConstants.appColor,
                                floatingLabelStyle:
                                    const TextStyle(color: ColorConstants.appColor),
                                width: 0.5,
                                labelStyle: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              controller: _firstNameTextController,
                              labelText: "First Name*",
                              keyboardType: TextInputType.name,
                              onChanged: (val) {
                                boolSubmitMessage = false;
                                String filtered = val.replaceAll(RegExp(r'[^a-zA-Z\s]'), '');
                                if (filtered != val) {
                                  _firstNameTextController.text = filtered;
                                  _firstNameTextController.selection = TextSelection.fromPosition(
                                    TextPosition(offset: filtered.length),
                                  );
                                }
                                setState(() {});
                                if (submitClicked &&
                                    _formCorporateGiftsKey.currentState!
                                        .validate()) {
                                  print("Submit Data");
                                }
                              },
                              validator: (value) {
                                print(value);
                                if (value == null || value.isEmpty) {
                                  return "Please enter First Name";
                                } else {
                                  return null;
                                }
                              }),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: ColorConstants.white,
                              borderRadius: BorderRadius.all(Radius.circular(7.0))),
                          margin: EdgeInsets.only(top: 0, left: 20, right: 20),
                          padding: EdgeInsets.only(),
                          child: MaterialTextField(
                              style: TextStyle(
                                  fontFamily: global.fontRailwayRegular,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w200,
                                  color: ColorConstants.pureBlack),
                              theme: FilledOrOutlinedTextTheme(
                                radius: 8,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 4),
                                errorStyle: const TextStyle(
                                    fontSize: 10,
                                    fontFamily: global.fontRailwayRegular,
                                    fontWeight: FontWeight.w200),
                                fillColor: Colors.transparent,
                                enabledColor: Colors.grey,
                                focusedColor: ColorConstants.appColor,
                                floatingLabelStyle:
                                    const TextStyle(color: ColorConstants.appColor),
                                width: 0.5,
                                labelStyle: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              controller: _lastNameTextController,
                              labelText: "Last Name*",
                              keyboardType: TextInputType.name,
                              
                              onChanged: (val) {
                                boolSubmitMessage = false;
                                String filtered = val.replaceAll(RegExp(r'[^a-zA-Z\s]'), '');
                                if (filtered != val) {
                                  _lastNameTextController.text = filtered;
                                  _lastNameTextController.selection = TextSelection.fromPosition(
                                    TextPosition(offset: filtered.length),
                                  );
                                }
                                setState(() {});
                                if (submitClicked &&
                                    _formCorporateGiftsKey.currentState!
                                        .validate()) {
                                  print("Submit Data");
                                }
                              },
                              validator: (value) {
                                print(value);
                                if (value == null || value.isEmpty) {
                                  return "Please enter Last Name  ";
                                } else if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
      return "Only alphabets are allowed";
    } else {
                                  return null;
                                }
                              }),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: ColorConstants.white,
                              borderRadius: BorderRadius.all(Radius.circular(7.0))),
                          margin: EdgeInsets.only(top: 0, left: 20, right: 20),
                          padding: EdgeInsets.only(),
                          child: MaterialTextField(
                              style: TextStyle(
                                  fontFamily: global.fontRailwayRegular,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w200,
                                  color: ColorConstants.pureBlack),
                              theme: FilledOrOutlinedTextTheme(
                                radius: 8,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 4),
                                errorStyle: const TextStyle(
                                    fontSize: 10,
                                    fontFamily: global.fontRailwayRegular,
                                    fontWeight: FontWeight.w200),
                                fillColor: Colors.transparent,
                                enabledColor: Colors.grey,
                                focusedColor: ColorConstants.appColor,
                                floatingLabelStyle:
                                    const TextStyle(color: ColorConstants.appColor),
                                width: 0.5,
                                labelStyle: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              controller: _emailIDTextController,
                              labelText: "Email ID*",
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (val) {
                                boolSubmitMessage = false;
                                setState(() {});
                                if (submitClicked &&
                                    _formCorporateGiftsKey.currentState!
                                        .validate()) {
                                  print("Submit Data");
                                }
                              },
                              validator: (value) {
                                print(value);
                                if (value == null || value.isEmpty) {
                                  return "Please enter your Email";
                                } else if (!EmailValidator.validate(value)) {
                                  return "Please enter valid Email";
                                } else {
                                  return null;
                                }
                              }),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  showCountryPicker(
                                    countryListTheme: CountryListThemeData(
                                        inputDecoration: InputDecoration(
                                            hintText: "",
                                            label: Text(
                                              "Search",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: fontRailwayRegular,
                                                  color: ColorConstants.appColor),
                                            )),
                                        searchTextStyle: TextStyle(
                                            color: ColorConstants.pureBlack),
                                        textStyle: TextStyle(
                                            fontFamily: fontRailwayRegular,
                                            fontWeight: FontWeight.w200,
                                            fontSize: 16,
                                            color: ColorConstants.pureBlack,
                                            letterSpacing: 1)),
                                    context: context,
                                    showPhoneCode:
                                        true, // optional. Shows phone code before the country name.
                                    onSelect: (Country country) {
                                      boolSubmitMessage = false;
                                      setState(() {});
                                      print(
                                          'Select country: ${country.displayName} & ${country.countryCode} & ${country.flagEmoji}');
                                      countryCode = country.phoneCode;
                                      countryCodeFlg = "${country.flagEmoji}";
                                      countryCodeSelected = country.phoneCode;
                                      _phonenumMaxLength1 = country.example.length;
              
                                      setState(() {
                                        _mobileTextController.text = "";
                                      });
                                    },
                                  );
                                },
                                child: Container(
                                  height: 40,
                                  width: 125,
                                  margin:
                                      EdgeInsets.only(bottom: mobileValid ? 0 : 20),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(7.0))),
                                  child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 1, 0, 0),
                                      child: Row(
                                        children: [
                                          Text(countryCodeFlg!,
                                              style: TextStyle(
                                                  fontFamily: fontMontserratMedium,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25,
                                                  color: ColorConstants.pureBlack,
                                                  letterSpacing: 1)),
                                          Expanded(
                                              child: Text(countryCodeSelected!,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          fontRailwayRegular,
                                                      fontWeight: FontWeight.w200,
                                                      fontSize: 16,
                                                      color:
                                                          ColorConstants.pureBlack,
                                                      letterSpacing: 1))),
                                          Icon(
                                            Icons.arrow_drop_down,
                                            size: 30,
                                            color: global.bgCompletedColor,
                                          )
                                        ],
                                      )),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: mobileValid ? 40 : 60,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(0.0))),
                                  margin: EdgeInsets.only(
                                      left: 8, right: 1, top: 10, bottom: 10),
                                  padding: EdgeInsets.only(),
                                  child: TextFormField(
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    key: Key('1'),
                                    cursorColor: Colors.black,
                                    controller: _mobileTextController,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: fontRailwayRegular,
                                        fontWeight: FontWeight.w200,
                                        color: ColorConstants.pureBlack,
                                        letterSpacing: 1),
                                    keyboardType: TextInputType.text,
                                    maxLength: _phonenumMaxLength1 == 0
                                        ? 9
                                        : _phonenumMaxLength1,
                                    focusNode: _fPhone,
                                    // onFieldSubmitted: (val) {
                                    //   FocusScope.of(context).requestFocus(_fPhone);
                                    // },
                                    obscuringCharacter: '*',
                                    decoration: InputDecoration(
                                        counterText: "",
                                        border: OutlineInputBorder(),
                                        labelStyle: TextStyle(
                                            fontSize: 14,
                                            fontFamily: fontRailwayRegular,
                                            fontWeight: FontWeight.w200,
                                            color:
                                                _mobileTextController.text.length >
                                                        0
                                                    ? ColorConstants.appColor
                                                    : ColorConstants.grey),
                                        labelText: "Mobile Number*",
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(7),
                                          borderSide: BorderSide(
                                              color: _mobileTextController
                                                          .text.length >
                                                      0
                                                  ? ColorConstants.appColor
                                                  : Colors.grey.shade400,
                                              width: 0.5),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(7),
                                          borderSide: BorderSide(
                                              color: _mobileTextController
                                                          .text.length >
                                                      0
                                                  ? ColorConstants.appColor
                                                  : Colors.grey.shade400,
                                              width: 0.5),
                                        ),
                                        hintText: '561234567',
                                        errorStyle: const TextStyle(
                                            fontSize: 10,
                                            fontFamily:
                                                global.fontRailwayRegular,
                                            fontWeight: FontWeight.w200),
                                        hintStyle: TextStyle(
                                            fontFamily: fontRailwayRegular,
                                            fontSize: 14)),
                                    onChanged: (val) {
                                      boolSubmitMessage = false;
                                      setState(() {});
                                      if (submitClicked &&
                                          _formCorporateGiftsKey.currentState!
                                              .validate()) {}
                                    },
                                    validator: (value) {
                                      print(value);
                                      if (value == null || value.isEmpty) {
                                        mobileValid = false;
                                        setState(() {});
                                        return "Please enter your mobile number";
                                      } else if (_mobileTextController
                                              .text.isNotEmpty &&
                                          _phonenumMaxLength1 == 0 &&
                                          _mobileTextController.text.length < 9) {
                                        mobileValid = false;
                                        setState(() {});
                                        return "Please enter valid mobile number";
                                      } else if (_phonenumMaxLength1 > 0 &&
                                          _mobileTextController.text.length <
                                              _phonenumMaxLength1) {
                                        mobileValid = false;
                                        setState(() {});
                                        return "Please enter valid mobile number";
                                      } else {
                                        mobileValid = true;
                                        setState(() {});
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: ColorConstants.white,
                              borderRadius: BorderRadius.all(Radius.circular(7.0))),
                          margin: EdgeInsets.only(top: 0, left: 20, right: 20),
                          padding: EdgeInsets.only(),
                          child: MaterialTextField(
                              textInputAction: TextInputAction.done,
                              style: TextStyle(
                                  fontFamily: global.fontRailwayRegular,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w200,
                                  color: ColorConstants.pureBlack),
                              theme: FilledOrOutlinedTextTheme(
                                radius: 8,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 4),
                                errorStyle: const TextStyle(
                                    fontSize: 10,
                                    fontFamily: global.fontRailwayRegular,
                                    fontWeight: FontWeight.w200),
                                fillColor: Colors.transparent,
                                enabledColor: Colors.grey,
                                focusedColor: ColorConstants.appColor,
                                floatingLabelStyle:
                                    const TextStyle(color: ColorConstants.appColor),
                                width: 0.5,
                                labelStyle: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              controller: _messageTextController,
                              labelText: "Message*",
                              keyboardType: TextInputType.name,
                              onChanged: (val) {
                                boolSubmitMessage = false;
                                setState(() {});
                                // if (addButtonClicked &&
                                //     _formAddMemberKey
                                //         .currentState!
                                //         .validate()) {
                                //   print("Submit Data");
                                // }
                              },
                              validator: (value) {
                                print(value);
                                if (value == null || value.isEmpty) {
                                  return "Please enter message  ";
                                } else {
                                  return null;
                                }
                              }),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 0, left: 20, right: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: LocalCaptcha(
                            key: const ValueKey('localCaptcha'),
                            controller: _localCaptchaController,
                            height: 70,
                            width: MediaQuery.of(context).size.width - 20,
                            backgroundColor: Colors.grey[100]!,
                            chars:
                                'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ123456789',
                            length: 6,
                            fontSize: 55.0,
                            textColors: [
                              Colors.black54,
                              Colors.grey,
                              Colors.blueGrey,
                              Colors.redAccent,
                              Colors.teal,
                              Colors.amber,
                              Colors.brown,
                            ],
                            noiseColors: [
                              Colors.black54,
                              Colors.grey,
                              Colors.blueGrey,
                              Colors.redAccent,
                              Colors.teal,
                              Colors.amber,
                              Colors.brown,
                            ],
                            caseSensitive: false,
                            codeExpireAfter: Duration(minutes: 10),
                          ),
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        // Container(
                        //   width: MediaQuery.of(context).size.width,
                        //   margin: EdgeInsets.only(top: 0, left: 20, right: 20),
                        //   child: Align(
                        //     alignment: Alignment.centerRight,
                        //     child: InkWell(
                        //       onTap: (){
                        //         _localCaptchaController.refresh();
                        //         _captchaTextController.text="";
                        //         state(() { });
                        //       },
                        //       child: Icon(
                        //         MdiIcons.refresh,
                        //         size: 30,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                              color: ColorConstants.white,
                              borderRadius: BorderRadius.all(Radius.circular(7.0))),
                          margin: EdgeInsets.only(top: 0, left: 20, right: 20),
                          padding: EdgeInsets.only(),
                          child: Row(
                            children: [
                              Expanded(
                                child: MaterialTextField(
                                    style: TextStyle(
                                        fontFamily: global.fontRailwayRegular,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w200,
                                        color: ColorConstants.pureBlack),
                                    theme: FilledOrOutlinedTextTheme(
                                      radius: 8,
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 4),
                                      errorStyle: const TextStyle(
                                          fontSize: 10,
                                          fontFamily: global.fontRailwayRegular,
                                          fontWeight: FontWeight.w200),
                                      fillColor: Colors.transparent,
                                      enabledColor: Colors.grey,
                                      focusedColor: ColorConstants.appColor,
                                      floatingLabelStyle: const TextStyle(
                                          color: ColorConstants.appColor),
                                      width: 0.5,
                                      labelStyle: const TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    ),
                                    controller: _captchaTextController,
                                    labelText: "Code*",
                                    keyboardType: TextInputType.text,
                                    onChanged: (val) {
                                      boolSubmitMessage = false;
                                      // state(() {});
                                      if (submitClicked &&
                                          _formCorporateGiftsKey.currentState!
                                              .validate()) {
                                        print("Submit Data");
                                      }
                                    },
                                    validator: (value) {
                                      print(value);
                                      if (value == null || value.isEmpty) {
                                        return "Please enter captcha code";
                                      } else {
                                        return null;
                                      }
                                    }),
                              ),
                              Container(
                                height: 30,
                                width: 30,
                                child: InkWell(
                                  onTap: () {
                                    _localCaptchaController.refresh();
                                    _captchaTextController.text = "";
                                    state(() {});
                                  },
                                  child: Icon(
                                    MdiIcons.refresh,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: boolSubmitMessage,
                          child: Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Text(submitMessage,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: global.fontRailwayRegular,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: ColorConstants.appColor)),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: InkWell(
                            onTap: () {
                              boolSubmitMessage = false;
                              state(() {});
                              if (_formCorporateGiftsKey.currentState!.validate()) {
                                if (_localCaptchaController.validate(
                                        _captchaTextController.text.toString()) ==
                                    LocalCaptchaValidation.valid) {
                                  submitContactUS(state);
                                  state(() {});
                                } else if (_localCaptchaController.validate(
                                        _captchaTextController.text.toString()) ==
                                    LocalCaptchaValidation.codeExpired) {
                                  boolSubmitMessage = true;
                                  submitMessage = "Captcha Expired";
                                  _captchaTextController.text = "";
                                  _localCaptchaController.refresh();
                                  state(() {});
                                } else if (_localCaptchaController.validate(
                                        _captchaTextController.text.toString()) ==
                                    LocalCaptchaValidation.invalidCode) {
                                  boolSubmitMessage = true;
                                  submitMessage = "Invalid code";
                                  state(() {});
                                }
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: 2, right: 2 ,bottom: MediaQuery.of(context).padding.bottom+10),
                              child: Container(
                                height: 35,
                                width: MediaQuery.of(context).size.width / 2.2,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: ColorConstants.appColor,
                                    border: Border.all(
                                        width: 0.5,
                                        color: ColorConstants.appColor)),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    // _productDetail.productDetail.cartQty != 0
                                    //     ? "GO TO CART"
                                    // :
                                    "SUBMIT",
                                    style: TextStyle(
                                        fontFamily: fontMontserratMedium,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: ColorConstants.white,
                                        letterSpacing: 1),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
              
                        boolSubmitMessage
                            ? SizedBox(
                                height: 10,
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  _launchWhatsapp(state) async {
    print(global.appInfo.contactWhatsApp!.replaceAll(" ", ""));
    var whatsapp = "";
    if (global.appInfo.contactWhatsApp!.contains(" ")) {
      whatsapp = global.appInfo.contactWhatsApp!.replaceAll(" ", "");
    } else {
      whatsapp = global.appInfo.contactWhatsApp!;
    }

    var iosUrl = "https://wa.me/$whatsapp?text=${Uri.parse('hello')}";
    if (Platform.isIOS) {
      if (await canLaunch(iosUrl)) {
        await launch(iosUrl, forceSafariVC: false);
      } else {
        boolSubmitMessage = true;
        submitMessage = "WhatsApp is not installed on the device";
        updated(state);
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //     content: new Text("WhatsApp is not installed on the device")));
      }
    } else {
      var whatsappUrl = "whatsapp://send?phone=$whatsapp";
      await canLaunch(whatsappUrl)
          ? launch(whatsappUrl)
          : print(
              "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(Uri.parse(whatsappUrl));
      } else {
        boolSubmitMessage = true;
        submitMessage = "WhatsApp is not installed on the device";
        updated(state);

        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text("WhatsApp is not installed on the device"),
        //   ),
        // );
      }
    }
  }

  Future<Null> updated(StateSetter updateState) async {
    updateState(() {});
  }

  @override
  void initState() {
    super.initState();
    global.goToCorporatePage = false;
    bannerImageURL
        .add("https://www.byyu.com/assets/images/corporate_banner.png");

    trustUsImageURL.add("assets/images/corporate_trustimg_1.png");
    trustUsImageURL.add("assets/images/corporate_trustimg_2.png");
    trustUsImageURL.add("assets/images/corporate_trustimg_3.png");
    trustUsImageURL.add("assets/images/corporate_trustimg_4.png");
    sampleProductsImageURL
        .add("https://www.byyu.com/assets/images/corporate_product_img1.png");
    sampleProductsImageURL
        .add("https://www.byyu.com/assets/images/corporate_product_img2.png");
    sampleProductsImageURL
        .add("https://www.byyu.com/assets/images/corporate_product_img3.png");
    sampleProductsImageURL
        .add("https://www.byyu.com/assets/images/corporate_product_img4.png");
    sampleProductsImageURL
        .add("https://www.byyu.com/assets/images/corporate_product_img3.png");

    countryCodeSelected = "+971";
    bottomImageURI.add("assets/images/corporate_bottom_1.png");
    bottomImageURI.add("assets/images/corporate_bottom_2.jpg");
    bottomImageURI.add("assets/images/corporate_bottom_3.jpg");
    bottomImageURI.add("assets/images/corporate_bottom_4.png");
    bottomImageURI.add("assets/images/corporate_bottom_5.png");
    bottomImageURI.add("assets/images/corporate_bottom_6.png");
    bottomImageURI.add("assets/images/corporate_bottom_7.png");
    bottomImageURI.add("assets/images/corporate_bottom_8.png");
    // if (sampleProductsImageURL.length % 3 == 0) {
    //   print("hello Nikhil");

    //   sampleProductLength = (sampleProductsImageURL.length / 3).round();
    // } else if (sampleProductsImageURL.length % 3 == 1 ||
    //     sampleProductsImageURL.length % 3 == 2) {
    //   sampleProductLength = ((sampleProductsImageURL.length / 3).round()) + 1;
    //   print("####################");
    //   print(sampleProductsImageURL.length % 3);
    // }

    _isDataLoaded = true;
  }

  submitContactUS(state) async {
    try {
      showOnlyLoaderDialog();
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        await apiHelper
            .corporateContactUS(
                _firstNameTextController.text,
                _lastNameTextController.text,
                _emailIDTextController.text,
                countryCodeSelected! + "" + _mobileTextController.text,
                _messageTextController.text)
            .then((result) async {
          if (result != null) {
            if (result.status == "1") {
              boolSubmitMessage = true;
              submitMessage = result.message;

              _firstNameTextController.text = "";
              _lastNameTextController.text = "";
              _emailIDTextController.text = "";
              _mobileTextController.text = "";
              _messageTextController.text = "";
              _captchaTextController.text = "";
              _localCaptchaController.refresh();
              state(() {});
              setState(() {});
              hideLoader();
            } else {
              boolSubmitMessage = true;
              submitMessage = result.message;
              hideLoader();
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey!);
        hideLoader();
      }

      setState(() {});
    } catch (e) {
      hideLoader();
      boolSubmitMessage = true;
      submitMessage = "Something went wrong";
      print("Exception - CorporateGifts.dart - submitContactUS():" +
          e.toString());
    }
  }

  showOnlyLoaderDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Center(child: new CircularProgressIndicator()),
        );
      },
    );
  }

  void hideloader() {
    Navigator.pop(context);
  }
}
