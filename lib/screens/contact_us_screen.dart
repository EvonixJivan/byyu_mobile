import 'dart:convert';
import 'dart:io';
// import 'dart:typed_data';

import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/models/contactUsDropDown.dart';
import 'package:country_picker/country_picker.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:get/get.dart';
//import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:material_text_fields/material_text_fields.dart';
import 'package:material_text_fields/theme/material_text_field_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;

class ContactUsScreen extends BaseRoute {
  ContactUsScreen({a, o}) : super(a: a, o: o, r: 'ContactUsScreen');
  @override
  _ContactUsScreenState createState() => new _ContactUsScreenState();
}

class _ContactUsScreenState extends BaseRouteState {
  final _formContactKey = GlobalKey<FormState>();
  var _cFeedback = new TextEditingController();
  var _fFeedback = new FocusNode();
  TextEditingController _cName = new TextEditingController();
  TextEditingController _cMessage = new TextEditingController();
  TextEditingController _cPhone = new TextEditingController();
  bool mobileInputEnabled = true;
  String countryCode = "+971";
  FocusNode _fName = new FocusNode();
  GlobalKey<ScaffoldState>? _scaffoldKey;
  List<String> _storeName = ['Admin'];
  String _selectedStore = 'Admin';

  bool _isDataLoaded = false;

  String countryCodeSelected = "+971", countryCodeFlg = "🇦🇪";
  int _phonenumMaxLength1 = 0;
  int _phonenumMaxLength = 9;
  FocusNode _fPhone = FocusNode();

  FocusNode textFieldFocusNode = FocusNode();
  SingleValueDropDownController _dropdowncontroller =
      SingleValueDropDownController();
  FocusNode searchFocusNode = FocusNode();
  List<ContactUsDropDownList> dropDownListData = [];
  List<DropDownValueModel> feedBackdropDownValues = [];
  String selectedFeedBack = "";
  int? selectedFeedBackindex;
  bool feedBackSelected = false;
  bool contactSendClicked = false;
  bool mobileValid = true;
  bool isTypeSelected = true;

  _ContactUsScreenState() : super();

  Future<void> _launchSocialMediaAppIfInstalled({
    String? url,
  }) async {
    try {
      bool launched = await launch(url!,
          forceSafariVC: false); // Launch the app if installed!

      if (!launched) {
        launch(url); // Launch web view if app is not installed!
      }
    } catch (e) {
      launch(url!); // Launch web view if app is not installed!
    }
  }

  _launchWhatsapp() async {
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: new Text("WhatsApp is not installed on the device")));
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("WhatsApp is not installed on the device"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        //backgroundColor: Theme.of(context).inputDecorationTheme.fillColor,
        backgroundColor: white,
        appBar: AppBar(
          backgroundColor: ColorConstants.appBarColorWhite,
          centerTitle: false,
          title: Text(
            "Contact us",
            // "${AppLocalizations.of(context).tle_contact_us} ",
            style: TextStyle(
                fontFamily: fontRailwayRegular,
                fontWeight: FontWeight.w200,
                color: ColorConstants.newTextHeadingFooter), //textTheme.titleLarge
          ),
          leading: BackButton(
            onPressed: () {
              // Navigator.pop(context);
              Navigator.pop(context);
            },
            //icon: Icon(Icons.keyboard_arrow_left),
            color: ColorConstants.appColor,
          ),
        ),
        body: Form(
          key: _formContactKey,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Padding(
                  //   padding:
                  //       const EdgeInsets.only(top: 10, left: 20, right: 25),
                  //   child: Text(
                  //     "Drop us a line and let's chat",
                  //     style: TextStyle(
                  //         fontFamily: fontRailwayRegular,
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 15,
                  //         color: ColorConstants.pureBlack),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //       left: 2, right: 2, top: 5, bottom: 5),
                  //   child: Divider(
                  //     thickness: 1,
                  //   ),
                  // ),

                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //       left: 20, right: 20, top: 5, bottom: 0),
                  //   child: Divider(
                  //     thickness: 1,
                  //   ),
                  // ),

                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //     left: 1,
                  //     right: 1,
                  //   ),
                  //   child: Container(
                  //       width: MediaQuery.of(context).size.width - 40,
                  //       margin: EdgeInsets.only(
                  //           left: 20, top: 5, bottom: 5, right: 20),
                  //       decoration: BoxDecoration(
                  //           border: Border.all(
                  //             width: 0.5,
                  //             color: Colors.grey,
                  //           ),
                  //           color: ColorConstants.white,
                  //           borderRadius:
                  //               BorderRadius.all(Radius.circular(10.0))),
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(left: 20, right: 20),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           crossAxisAlignment: CrossAxisAlignment.center,
                  //           children: [
                  //             Expanded(
                  //               child: Container(
                  //                   height: isTypeSelected ? 40 : 70,
                  //                   child: DropDownTextField(
                  //                     controller: _dropdowncontroller,
                  //                     textStyle: TextStyle(
                  //                         fontFamily:
                  //                             global.fontRailwayRegular,
                  //                         fontWeight: FontWeight.w200,
                  //                         color: ColorConstants.pureBlack,
                  //                         fontSize: 13),
                  //                     listTextStyle: TextStyle(
                  //                         fontFamily:
                  //                             global.fontRailwayRegular,
                  //                         fontWeight: FontWeight.w200,
                  //                         color: ColorConstants.pureBlack,
                  //                         fontSize: 13),
                  //                     clearOption: false,
                  //                     textFieldFocusNode: textFieldFocusNode,
                  //                     searchFocusNode: searchFocusNode,
                  //                     // searchAutofocus: true,

                  //                     dropDownItemCount:
                  //                         feedBackdropDownValues.length,
                  //                     searchShowCursor: false,
                  //                     enableSearch: false,
                  //                     searchKeyboardType: TextInputType.number,
                  //                     dropDownList: feedBackdropDownValues,
                  //                     dropdownColor: ColorConstants.white,
                  //                     textFieldDecoration: InputDecoration(
                  //                       enabledBorder: InputBorder.none,
                  //                       hintText: "Choose Type",
                  //                       errorStyle: TextStyle(
                  //                           fontSize: 10,
                  //                           fontFamily:
                  //                               global.fontRailwayRegular,
                  //                           fontWeight: FontWeight.w200),
                  //                       hintStyle: TextStyle(
                  //                           fontFamily:
                  //                               global.fontRailwayRegular,
                  //                           fontWeight: FontWeight.w200,
                  //                           color: ColorConstants.pureBlack,
                  //                           fontSize: 13),
                  //                       //focusedBorder: InputBorder.none,
                  //                     ),
                  //                     onChanged: (val) {
                  //                       DropDownValueModel model = val;
                  //                       print(model.value);
                  //                       print(model.name);
                  //                       selectedFeedBack = model.name;
                  //                       feedBackSelected = true;
                  //                       isTypeSelected = true;
                  //                       selectedFeedBackindex =
                  //                           int.parse(model.value);
                  //                       if (contactSendClicked &&
                  //                           _formContactKey.currentState!
                  //                               .validate()) {
                  //                         print("Submit Data");
                  //                       }
                  //                       setState(() {});
                  //                     },
                  //                     validator: (value) {
                  //                       print(value);
                  //                       if (value == null || value.isEmpty) {
                  //                         isTypeSelected = false;
                  //                         setState(() {});
                  //                         return "Please select Type";
                  //                       } else {
                  //                         return null;
                  //                       }
                  //                     },
                  //                   )),
                  //             ),
                  //           ],
                  //         ),
                  //       )),
                  // ),

                  // Container(
                  //   decoration: BoxDecoration(
                  //       color: ColorConstants.white,
                  //       borderRadius: BorderRadius.all(Radius.circular(7.0))),
                  //   margin: EdgeInsets.only(top: 8, left: 20, right: 20),
                  //   padding: EdgeInsets.only(),
                  //   child: MaterialTextField(
                  //       style: TextStyle(
                  //           fontFamily: global.fontRailwayRegular,
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.w200,
                  //           color: ColorConstants.pureBlack),
                  //       theme: FilledOrOutlinedTextTheme(
                  //         radius: 8,
                  //         contentPadding: const EdgeInsets.symmetric(
                  //             horizontal: 4, vertical: 4),
                  //         errorStyle: const TextStyle(
                  //             fontSize: 10,
                  //             fontFamily: global.fontRailwayRegular,
                  //             fontWeight: FontWeight.w200),
                  //         fillColor: Colors.transparent,
                  //         enabledColor: Colors.grey,
                  //         focusedColor: ColorConstants.appColor,
                  //         floatingLabelStyle:
                  //             const TextStyle(color: ColorConstants.appColor),
                  //         width: 0.5,
                  //         labelStyle:
                  //             const TextStyle(fontSize: 14, color: Colors.grey),
                  //       ),
                  //       controller: _cName,
                  //       labelText: "Full Name*",
                  //       // hintText:
                  //       //     "Email", //"${AppLocalizations.of(context).lbl_email}",
                  //       keyboardType: TextInputType.name,
                  //       onChanged: (val) {
                  //         if (contactSendClicked &&
                  //             _formContactKey.currentState!.validate()) {
                  //           print("Submit Data");
                  //         }
                  //         //FocusScope.of(context).requestFocus(_fPhoneCode);
                  //       },
                  //       validator: (value) {
                  //         print(value);
                  //         if (value == null || value.isEmpty) {
                  //           return "Please enter your Full Name  ";
                  //         } else {
                  //           return null;
                  //         }
                  //       }),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //     left: 20,
                  //     right: 20,
                  //   ),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       InkWell(
                  //         onTap: () {
                  //           showCountryPicker(
                  //             countryListTheme: CountryListThemeData(
                  //                 flagSize: 20,
                  //                 textStyle: TextStyle(
                  //                   overflow: TextOverflow.ellipsis,
                  //                   fontFamily: fontRailwayRegular,
                  //                   fontWeight: FontWeight.w200,
                  //                   fontSize: 15,
                  //                   color: ColorConstants.pureBlack,
                  //                 )),
                  //             context: context,
                  //             showPhoneCode:
                  //                 true, // optional. Shows phone code before the country name.
                  //             onSelect: (Country country) {
                  //               _cPhone.text = "";
                  //               print(
                  //                   'Select country: ${country.displayName} & ${country.countryCode} & ${country.flagEmoji}');
                  //               countryCode = country.phoneCode;
                  //               countryCodeFlg = "${country.flagEmoji}";
                  //               countryCodeSelected = "+${country.phoneCode}";
                  //               _phonenumMaxLength1 = country.example.length;
                  //               setState(() {});
                  //             },
                  //           );
                  //         },
                  //         child: Container(
                  //           height: 40,
                  //           width: 125,
                  //           margin:
                  //               EdgeInsets.only(bottom: mobileValid ? 1 : 20),
                  //           decoration: BoxDecoration(
                  //               border: Border.all(
                  //                 color: Colors.grey.shade300,
                  //               ),
                  //               borderRadius:
                  //                   BorderRadius.all(Radius.circular(7.0))),
                  //           child: Padding(
                  //               padding: const EdgeInsets.fromLTRB(5, 1, 0, 0),
                  //               child: Row(
                  //                 children: [
                  //                   Text(countryCodeFlg,
                  //                       style: TextStyle(
                  //                           fontFamily: fontMontserratMedium,
                  //                           fontWeight: FontWeight.bold,
                  //                           fontSize: 25,
                  //                           color: ColorConstants.pureBlack,
                  //                           letterSpacing: 1)),
                  //                   Expanded(
                  //                       child: Text(countryCodeSelected,
                  //                           style: TextStyle(
                  //                               fontFamily:
                  //                                   fontRailwayRegular,
                  //                               fontWeight: FontWeight.w200,
                  //                               fontSize: 16,
                  //                               color: ColorConstants.pureBlack,
                  //                               letterSpacing: 1))),
                  //                   Icon(
                  //                     Icons.arrow_drop_down,
                  //                     size: 30,
                  //                     color: global.bgCompletedColor,
                  //                   )
                  //                 ],
                  //               )),
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: Container(
                  //           height: mobileValid ? 40 : 60,
                  //           decoration: BoxDecoration(
                  //               borderRadius:
                  //                   BorderRadius.all(Radius.circular(0.0))),
                  //           margin: EdgeInsets.only(
                  //               left: 8, right: 1, top: 10, bottom: 10),
                  //           padding: EdgeInsets.only(),
                  //           child: TextFormField(
                  //             inputFormatters: <TextInputFormatter>[
                  //               FilteringTextInputFormatter.digitsOnly
                  //             ],
                  //             key: Key('1'),
                  //             cursorColor: Colors.black,
                  //             controller: _cPhone,
                  //             style: TextStyle(
                  //                 fontSize: 14,
                  //                 fontFamily: fontRailwayRegular,
                  //                 fontWeight: FontWeight.w200,
                  //                 color: ColorConstants.pureBlack,
                  //                 letterSpacing: 1),
                  //             keyboardType: TextInputType.number,
                  //             textCapitalization: TextCapitalization.words,
                  //             maxLength: _phonenumMaxLength1 == 0
                  //                 ? 9
                  //                 : _phonenumMaxLength1,
                  //             focusNode: _fPhone,
                  //             onFieldSubmitted: (val) {
                  //               FocusScope.of(context).requestFocus(_fPhone);
                  //             },
                  //             obscuringCharacter: '*',
                  //             decoration: InputDecoration(
                  //                 counterText: "",
                  //                 border: OutlineInputBorder(),
                  //                 labelStyle: TextStyle(
                  //                     color: _cPhone.text.length > 0
                  //                         ? ColorConstants.appColor
                  //                         : ColorConstants.grey),
                  //                 labelText: "Mobile Number*",
                  //                 focusedBorder: OutlineInputBorder(
                  //                   borderRadius: BorderRadius.circular(7),
                  //                   borderSide: BorderSide(
                  //                       color: Colors.grey.shade400,
                  //                       width: 0.0),
                  //                 ),
                  //                 enabledBorder: OutlineInputBorder(
                  //                   borderRadius: BorderRadius.circular(7),
                  //                   borderSide: BorderSide(
                  //                       color: Colors.grey.shade400,
                  //                       width: 0.0),
                  //                 ),
                  //                 errorStyle: const TextStyle(
                  //                     fontSize: 10,
                  //                     fontFamily: global.fontRailwayRegular,
                  //                     fontWeight: FontWeight.w200),
                  //                 hintText: '561234567',
                  //                 hintStyle: TextStyle(
                  //                     fontFamily: fontRailwayRegular,
                  //                     fontSize:
                  //                         14) //textFieldHintStyle(context),
                  //                 ),
                  //             onChanged: (val) {
                  //               if (contactSendClicked &&
                  //                   _formContactKey.currentState!.validate()) {}
                  //               //FocusScope.of(context).requestFocus(_fPhoneCode);
                  //             },
                  //             validator: (value) {
                  //               print(value);
                  //               if (value == null || value.isEmpty) {
                  //                 mobileValid = false;
                  //                 setState(() {});
                  //                 return "Please enter your mobile number";
                  //               } else if (_cPhone.text.isNotEmpty &&
                  //                   _phonenumMaxLength1 == 0 &&
                  //                   _cPhone.text.length < 9) {
                  //                 mobileValid = false;
                  //                 setState(() {});
                  //                 return "Please enter valid mobile number";
                  //               } else if (_phonenumMaxLength1 > 0 &&
                  //                   _cPhone.text.length < _phonenumMaxLength1) {
                  //                 mobileValid = false;
                  //                 setState(() {});
                  //                 return "Please enter valid mobile number";
                  //               } else {
                  //                 mobileValid = true;
                  //                 setState(() {});
                  //                 return null;
                  //               }
                  //             },
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //       color: ColorConstants.white,
                  //       borderRadius: BorderRadius.all(Radius.circular(7.0))),
                  //   margin: EdgeInsets.only(top: 0, left: 20, right: 20),
                  //   padding: EdgeInsets.only(),
                  //   child: MaterialTextField(
                  //       style: TextStyle(
                  //           fontFamily: global.fontRailwayRegular,
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.w200,
                  //           color: ColorConstants.pureBlack),
                  //       theme: FilledOrOutlinedTextTheme(
                  //         radius: 8,
                  //         contentPadding: const EdgeInsets.symmetric(
                  //             horizontal: 4, vertical: 4),
                  //         errorStyle: const TextStyle(
                  //             fontSize: 10,
                  //             fontFamily: global.fontRailwayRegular,
                  //             fontWeight: FontWeight.w200),
                  //         fillColor: Colors.transparent,
                  //         enabledColor: Colors.grey,
                  //         focusedColor: ColorConstants.appColor,
                  //         floatingLabelStyle:
                  //             const TextStyle(color: ColorConstants.appColor),
                  //         width: 0.5,
                  //         labelStyle:
                  //             const TextStyle(fontSize: 14, color: Colors.grey),
                  //       ),
                  //       controller: _cMessage,
                  //       labelText: "Enter message here*",

                  //       // hintText:
                  //       //     "Email", //"${AppLocalizations.of(context).lbl_email}",
                  //       keyboardType: TextInputType.text,
                  //       onChanged: (val) {
                  //         if (contactSendClicked &&
                  //             _formContactKey.currentState!.validate()) {
                  //           print("Submit Data");
                  //         }
                  //         //FocusScope.of(context).requestFocus(_fPhoneCode);
                  //       },
                  //       validator: (value) {
                  //         print(value);
                  //         if (value == null || value.isEmpty) {
                  //           return "Please enter message";
                  //         } else {
                  //           return null;
                  //         }
                  //       }),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // feedBackSelected &&
                  //         dropDownListData[selectedFeedBackindex!]
                  //                 .imageRequired!
                  //                 .toLowerCase() ==
                  //             "true"
                  //     ? Container(
                  //         margin: EdgeInsets.only(top: 8, left: 20, right: 20),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Text(
                  //               "Attach Image*",
                  //               style: TextStyle(
                  //                   fontFamily: fontRailwayRegular,
                  //                   color: ColorConstants.pureBlack,
                  //                   fontWeight: FontWeight.w200,
                  //                   fontSize: 14),
                  //             ),
                  //             InkWell(
                  //                 onTap: () async {
                  //                   _showCupertinoModalSheet();
                  //                 },
                  //                 child: uploaadImageFile == null
                  //                     ? Container(
                  //                         child: Icon(
                  //                           // Icons.ios_share,
                  //                           FontAwesomeIcons.arrowUpFromBracket,
                  //                           // Icons.share_outlined,
                  //                           size: 25,
                  //                           weight: 0.1,
                  //                           opticalSize: 1,
                  //                           fill: 0.1,
                  //                           color: ColorConstants.grey,
                  //                         ),
                  //                       )
                  //                     : CircleAvatar(
                  //                         backgroundColor: Colors.white,
                  //                         radius: 20,
                  //                         backgroundImage: FileImage(
                  //                             File(uploaadImageFile!.path)))),
                  //           ],
                  //         ),
                  //       )
                  //     : SizedBox(),

                  // InkWell(
                  //   onTap: () {
                  //     contactSendClicked = true;
                  //     if (_formContactKey.currentState!.validate() &&
                  //         !selectedFeedBack.isEmpty &&
                  //         dropDownListData[selectedFeedBackindex!]
                  //                 .imageRequired ==
                  //             'false') {
                  //       print("Submit Data");
                  //       _submitFeedBack();
                  //     } else if (_formContactKey.currentState!.validate() &&
                  //         !selectedFeedBack.isEmpty &&
                  //         dropDownListData[selectedFeedBackindex!]
                  //                 .imageRequired ==
                  //             'true' &&
                  //         uploaadImageFile != null) {
                  //       print("Submit Data");
                  //       _submitFeedBack();
                  //     } else if (!selectedFeedBack.isEmpty &&
                  //         dropDownListData[selectedFeedBackindex!]
                  //                 .imageRequired ==
                  //             'true' &&
                  //         uploaadImageFile == null) {
                  //       print("Hello ${selectedFeedBackindex}");

                  //       showSnackBar(
                  //           snackBarMessage:
                  //               // '${AppLocalizations.of(context).txt_enter_feedback}',
                  //               "Please Add Image.",
                  //           key: _scaffoldKey);
                  //     }
                  //   },
                  //   child: Container(
                  //     margin: EdgeInsets.only(top: 8, left: 20, right: 20),
                  //     padding: EdgeInsets.all(10),
                  //     height: 35,
                  //     width: MediaQuery.of(context).size.width - 40,
                  //     decoration: BoxDecoration(
                  //         color: ColorConstants.appColor,
                  //         border: Border.all(
                  //             color: ColorConstants.appColor, width: 0.5),
                  //         borderRadius: BorderRadius.circular(10)),
                  //     child: Text(
                  //       "SEND",
                  //       textAlign: TextAlign.center,
                  //       // "${AppLocalizations.of(context).tle_add_new_address} ",
                  //       style: TextStyle(
                  //           fontFamily: fontMontserratMedium,
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 16,
                  //           color: ColorConstants.white,
                  //           letterSpacing: 1),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Padding(
                  //   padding:
                  //       const EdgeInsets.only(top: 10, left: 20, right: 20),
                  //   child: Text(
                  //     "Contact us!",
                  //     style: TextStyle(
                  //         fontFamily: fontRailwayRegular,
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 15,
                  //         color: ColorConstants.pureBlack),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //       left: 2, right: 2, top: 5, bottom: 10),
                  //   child: Divider(
                  //     thickness: 1,
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 30),
                    child: InkWell(
                      onTap: () {
                        final Uri _emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: appInfo.contactEmail,
                            queryParameters: {'subject': ''});
                        launch(_emailLaunchUri.toString());
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            color: ColorConstants.pureBlack,
                            size: 30,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "EMAIL",
                                style: TextStyle(
                                    fontFamily: fontRailwayRegular,
                                    color: ColorConstants.pureBlack,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14),
                              ),
                              SizedBox(height: 5),
                              // Text(
                              //   global.appInfo != null &&
                              //           global.appInfo.contactEmail != null &&
                              //           global.appInfo.contactEmail.length > 0
                              //       ? "${global.appInfo.contactEmail}"
                              //       : "",
                              //   style: TextStyle(
                              //       fontFamily: fontRailwayRegular,
                              //       color: ColorConstants.appColor,
                              //       fontWeight: FontWeight.normal,
                              //       fontSize: 14),
                              // ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 30),
                    child: InkWell(
                      onTap: () async {
                        await _launchWhatsapp();
                      },
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.whatsapp,
                            color: ColorConstants.pureBlack,
                            size: 30,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "WHATSAPP",
                                style: TextStyle(
                                    fontFamily: fontRailwayRegular,
                                    color: ColorConstants.pureBlack,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14),
                              ),
                              SizedBox(height: 5),
                              // Text(
                              //   global.appInfo != null &&
                              //           global.appInfo.contactWhatsApp != null &&
                              //           global.appInfo.contactWhatsApp.length > 0
                              //       ? "${global.appInfo.contactWhatsApp}"
                              //       : "",
                              //   style: TextStyle(
                              //       fontFamily: fontRailwayRegular,
                              //       color: ColorConstants.appColor,
                              //       fontWeight: FontWeight.normal,
                              //       fontSize: 14),
                              // ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 30),
                    child: InkWell(
                      onTap: () {
                        callNumberStore(global.appInfo.contactPhone);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            color: ColorConstants.pureBlack,
                            size: 30,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "CONTACT NUMBER",
                                style: TextStyle(
                                    fontFamily: fontRailwayRegular,
                                    color: ColorConstants.pureBlack,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14),
                              ),
                              SizedBox(height: 5),
                              Text(
                                global.appInfo != null &&
                                        global.appInfo.contactPhone != null &&
                                        global.appInfo.contactPhone!.length > 0
                                    ? "${global.appInfo.contactPhone!.trim()}"
                                    : "",
                                style: TextStyle(
                                    fontFamily: fontRailwayRegular,
                                    color: ColorConstants.appColor,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding:
                  //       const EdgeInsets.only(top: 40, left: 20, right: 25),
                  //   child: Text(
                  //     "Social Links: ",
                  //     style: TextStyle(
                  //         fontFamily: fontRailwayRegular,
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 15,
                  //         color: ColorConstants.pureBlack),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 2, right: 2, top: 5, bottom: 10),
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: InkWell(
                          onTap: () {
                            _launchSocialMediaAppIfInstalled(
                              url:
                                  'https://www.facebook.com/profile.php?id=61552755963187', // Facebook
                            );
                          },
                          child: Image.asset(
                            "assets/images/facebookgrad.png",
                            fit: BoxFit.contain,
                            height: 45,
                            width: 45,
                            alignment: Alignment.center,
                          ),
                        ),

                        // IconButton(
                        //   onPressed: () {
                        //     _launchSocialMediaAppIfInstalled(
                        //       url:
                        //           'https://www.facebook.com/profile.php?id=61551455799889', // Facebook
                        //     );
                        //   },
                        //   icon: Icon(
                        //     FontAwesomeIcons.facebookF,
                        //     color: ColorConstants.white,
                        //     size: 30,
                        //   ),
                        // ),
                      ),
                      Container(
                        child: InkWell(
                          onTap: () {
                            _launchSocialMediaAppIfInstalled(
                                url: "https://twitter.com/byyu_com");
                          },
                          child: Image.asset(
                            "assets/images/twitter_gradient.png",
                            fit: BoxFit.contain,
                            height: 45,
                            width: 45,
                            alignment: Alignment.center,
                          ),
                        ),

                        // IconButton(
                        //   onPressed: () {

                        //   },
                        //   icon: Icon(
                        //     FontAwesomeIcons.twitter,
                        //     color: ColorConstants.white,
                        //     size: 30,
                        //   ),
                        // ),
                      ),
                      Container(
                        child: InkWell(
                          onTap: () {
                            _launchSocialMediaAppIfInstalled(
                                url:
                                    "https://www.linkedin.com/company/101379431/admin/settings/");
                          },
                          child: Image.asset(
                            "assets/images/linkedin_gradient.png",
                            fit: BoxFit.contain,
                            height: 45,
                            width: 45,
                            alignment: Alignment.center,
                          ),
                        ),

                        // IconButton(
                        //   onPressed: () {
                        //     _launchSocialMediaAppIfInstalled(
                        //         url:
                        //             "https://www.linkedin.com/company/98773769/admin/feed/posts/");
                        //   },
                        //   icon: Icon(
                        //     FontAwesomeIcons.linkedinIn,
                        //     color: ColorConstants.white,
                        //     size: 30,
                        //   ),
                        // ),
                      ),
                      Container(
                        child: InkWell(
                          onTap: () {
                            _launchSocialMediaAppIfInstalled(
                                url: "https://www.instagram.com/byyu.ae/");
                          },
                          child: Image.asset(
                            "assets/images/instagram_grdient.png",
                            fit: BoxFit.contain,
                            height: 45,
                            width: 45,
                            alignment: Alignment.center,
                          ),
                        ),

                        // IconButton(
                        //   onPressed: () {

                        //   },
                        //   icon: Icon(
                        //     FontAwesomeIcons.instagram,
                        //     color: ColorConstants.white,
                        //     size: 30,
                        //   ),
                        // ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: Platform.isIOS ? 20 : 10,
                  )
                ],
              ),
            ),
          ),
        ),
        // bottomNavigationBar: Padding(
        //   padding: const EdgeInsets.all(20.0),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: [

        //     ],
        //   ),
        // )
      ),
    );
  }

  void callNumberStore(store_number) async {
    await launch('tel:$store_number');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    callContactUsDropDownAPI();
    // if (global.appInfo.store_id != null) {
    //   _storeName.insert(0, global.nearStoreModel.storeName);
    // }
  }

  File? uploaadImageFile;
  _showCupertinoModalSheet() {
    try {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: Text('Choose'),
          actions: [
            CupertinoActionSheetAction(
              child: Text(
                'Capture',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorConstants
                                                          .newTextHeadingFooter,
                    ),
              ),
              onPressed: () async {
                Navigator.pop(context);
                uploaadImageFile = await br!.openCamera();

                setState(() {});
              },
            ),
            CupertinoActionSheetAction(
              child: Text(
                'Upload Image',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorConstants
                                                          .newTextHeadingFooter,
                    ),
              ),
              onPressed: () async {
                Navigator.pop(context);
                uploaadImageFile = (await br!.selectImageFromGallery())!;

                setState(() {});
              },
            ),
            CupertinoActionSheetAction(
              child: Text(
                'Remove Image',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorConstants
                                                          .newTextHeadingFooter,
                    ),
              ),
              onPressed: () async {
                uploaadImageFile = null;
                Navigator.pop(context);
                // _tImage = null;

                // removeProfileImage();
                setState(() {});
              },
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('Cancel',
                style: TextStyle(color: Theme.of(context).primaryColor)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
    } catch (e) {
      print(
          "Exception - profile_edit_screen.dart - _showCupertinoModalSheet():" +
              e.toString());
    }
  }

  Future<Image> convertFileToImage(File picture) async {
    List<int> imageBase64 = picture.readAsBytesSync();
    String imageAsString = base64Encode(imageBase64);
    Uint8List uint8list = base64.decode(imageAsString);
    Image image = Image.memory(uint8list);
    return image;
  }

  // _sendCallbackRequest() async {
  //   try {
  //     bool isConnected = await br.checkConnectivity();
  //     if (isConnected) {
  //       showOnlyLoaderDialog();
  //       await apiHelper
  //           .calbackRequest(_selectedStore == 'Admin' ? null : _selectedStore)
  //           .then((result) async {
  //         if (result != null) {
  //           if (result.status == "1") {
  //             hideLoader();
  //             showSnackBar(
  //                 snackBarMessage:
  //                     // '${AppLocalizations.of(context).txt_callback_request_sent} ',
  //                     "Callback request sent successfully.",
  //                 key: _scaffoldKey);
  //           } else {
  //             hideLoader();
  //             showSnackBar(
  //                 snackBarMessage:
  //                     // '${AppLocalizations.of(context).txt_something_went_wrong}, ${AppLocalizations.of(context).txt_please_try_again_after_sometime}',
  //                     "Something went wrong Please try again after sometime.",
  //                 key: _scaffoldKey);
  //           }
  //         }
  //       });
  //     } else {
  //       showNetworkErrorSnackBar(_scaffoldKey);
  //     }
  //   } catch (e) {
  //     print("Exception - contact_us_screen.dart - _submitFeedBack():" +
  //         e.toString());
  //   }
  // }

  _submitFeedBack() async {
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog();
        print(countryCode.length > 0
            ? countryCode
            : global.currentUser.countryCode ?? "0");
        await apiHelper
            .sendUserFeedback(
                selectedFeedBack,
                _cName.text,
                _cPhone.text,
                countryCode.length > 0
                    ? countryCode
                    : global.currentUser.countryCode ?? "0",
                _cMessage.text,
                uploaadImageFile?.path ?? ""

                //  ( uploaadImageFile != null ? uploaadImageFile : null)!

                )
            .then((result) async {
          if (result != null) {
            if (result.status == "1") {
              hideLoader();
              setState(() {
                _dropdowncontroller.clearDropDown();
                selectedFeedBack = '';
                selectedFeedBackindex = 0;
                uploaadImageFile = null;
                _cName.clear();
                _cPhone.clear();
                _cMessage.clear();
              });
              showSnackBar(
                  snackBarMessage:
                      // '${AppLocalizations.of(context).txt_feedback_sent}',
                      "Feedback sent successfully",
                  key: _scaffoldKey);
            } else {
              hideLoader();
              showSnackBar(
                  snackBarMessage:
                      // '${AppLocalizations.of(context).txt_something_went_wrong}, ${AppLocalizations.of(context).txt_please_try_again_after_sometime}',
                      "Something went wrong Please try again after sometime.",
                  key: _scaffoldKey);
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey!);
      }
    } catch (e) {
      hideLoader();
      showSnackBar(
          snackBarMessage:
              // '${AppLocalizations.of(context).txt_something_went_wrong}, ${AppLocalizations.of(context).txt_please_try_again_after_sometime}',
              "Something went wrong.",
          key: _scaffoldKey);
      print("Exception - contact_us_screen.dart - _submitFeedBack(11):" +
          e.toString());
    }
  }

  callContactUsDropDownAPI() async {
    try {
      print('HomeScreen data');
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        await apiHelper.getContactUsDropDown().then((result) async {
          if (result != null) {
            dropDownListData = result.data;
            for (int i = 0; i < dropDownListData.length; i++) {
              feedBackdropDownValues.add(DropDownValueModel(
                  value: "${i}", name: dropDownListData[i].type!));
            }
            //selectionData = selectionFilterModel.selectionData;

            setState(() {
              _isDataLoaded = true;
            });
          }
        });
      } else {
        Fluttertoast.showToast(
          msg: "Enter House no./Building", // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.CENTER, // location
          // duration
        );
      }
    } catch (e) {
      print(
          "Exception - dashboard_screen.dart callFiltersApi- _getHomeScreenData():" +
              e.toString());
    }
  }
}
