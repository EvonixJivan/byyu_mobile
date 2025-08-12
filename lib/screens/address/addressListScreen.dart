import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get_state_manager/src/simple/get_state.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'package:byyu/controllers/user_profile_controller.dart';
import 'package:byyu/models/addressModel.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;

import 'package:byyu/screens/address/add_address_screen.dart';
import 'package:byyu/screens/home_screen.dart';

class AddressListScreen extends BaseRoute {
  AddressListScreen({a, o}) : super(a: a, o: o, r: 'AddressListScreen');
  @override
  _AddressListScreenState createState() => new _AddressListScreenState();
}

class _AddressListScreenState extends BaseRouteState {
  bool? _isDataLoaded = false;
  bool? islogin = false;
  GlobalKey<ScaffoldState>? _scaffoldKey;
  _AddressListScreenState() : super();
  List<Address1> addressList = [];

  String? dropdownValuestate;
  String? dropdownValueCode;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Container(
          color: global.white,
          child: SafeArea(
            child: Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                backgroundColor: ColorConstants.appBrownFaintColor,
                leading: InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreen(
                                  a: widget.analytics,
                                  o: widget.observer,
                                  screenId: 1,
                                  selectedIndex: null,
                                )));
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Icon(Icons.keyboard_arrow_left,
                        color: global.bgCompletedColor),
                  ),
                ),
                centerTitle: true,
                title: Text(
                  'My Address',
                  style: Theme.of(context)
                      .textTheme
                      .headline6, //textTheme.headline6,
                ),
              ),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: RefreshIndicator(
                  onRefresh: () async {
                    _isDataLoaded = false;
                    setState(() {});
                    await _getMyAddressList();
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: islogin!,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddAddressScreen(
                                          new Address1(),
                                          a: widget.analytics,
                                          o: widget.observer,
                                          fromWhere: "addAddress",
                                          countryCode: dropdownValuestate,
                                          prefixCode: dropdownValueCode,
                                        )));
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 20),
                            width: double.infinity,
                            child: Text(
                              'Add delivery address',
                              style: TextStyle(
                                  fontFamily: global.fontMontserratLight,
                                  fontWeight: FontWeight.w200,
                                  fontSize: 14,
                                  color: bgCompletedColor),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: _isDataLoaded!
                            ? global.userProfileController.addressList !=
                                        null &&
                                    global.userProfileController.addressList
                                            .length >
                                        0
                                ? GetBuilder<UserProfileController>(
                                    init: global.userProfileController,
                                    builder: (value) => ListView.builder(
                                      itemCount: global.userProfileController
                                          .addressList.length,
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Container(
                                          height: 150,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(7.0)),
                                            margin: EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                bottom: 20),
                                            color: global.cardColor,
                                            child: InkWell(
                                              onTap: () async {
                                                global.currentLocation =
                                                    "${global.userProfileController.addressList[index].type} ";

                                                global.currentLocationSelected =
                                                    true;
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                prefs.setString(
                                                    'type',
                                                    global
                                                        .userProfileController
                                                        .addressList[index]
                                                        .type!);
                                                prefs.setDouble(
                                                    'lat',
                                                    double.parse(global
                                                        .userProfileController
                                                        .addressList[index]
                                                        .lat!));
                                                prefs.setDouble(
                                                    'lng',
                                                    double.parse(global
                                                        .userProfileController
                                                        .addressList[index]
                                                        .lng!));
                                                Navigator.of(context).pop();

                                                setState(() {});
                                              },
                                              child: ListTile(
                                                contentPadding:
                                                    EdgeInsets.all(7),
                                                title: SizedBox(
                                                  height: 25,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            if (global
                                                                    .userProfileController
                                                                    .addressList[
                                                                        index]
                                                                    .type ==
                                                                'Home')
                                                              WidgetSpan(
                                                                  child: Icon(
                                                                FontAwesomeIcons
                                                                    .house,
                                                                size: 15,
                                                              ))
                                                            else if (global
                                                                    .userProfileController
                                                                    .addressList[
                                                                        index]
                                                                    .type ==
                                                                'Office')
                                                              WidgetSpan(
                                                                  child: Icon(
                                                                FontAwesomeIcons
                                                                    .briefcase,
                                                                size: 16,
                                                              ))
                                                            else if (global
                                                                    .userProfileController
                                                                    .addressList[
                                                                        index]
                                                                    .type ==
                                                                'Other')
                                                              WidgetSpan(
                                                                  child: Icon(
                                                                FontAwesomeIcons
                                                                    .addressBook,
                                                                size: 16,
                                                              )),
                                                            TextSpan(
                                                              text:
                                                                  (' ${global.userProfileController.addressList[index].recepientName == null ? global.userProfileController.addressList[index].recepientName : ""} ${global.userProfileController.addressList[index].type}'),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      fontMetropolisRegular,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w200,
                                                                  fontSize: 16,
                                                                  color: ColorConstants
                                                                      .pureBlack),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(child: Text('')),
                                                      IconButton(
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        AddAddressScreen(
                                                                          global
                                                                              .userProfileController
                                                                              .addressList[index],
                                                                          fromWhere:
                                                                              "EditButton",
                                                                          countryCode:
                                                                              dropdownValuestate,
                                                                          prefixCode:
                                                                              dropdownValueCode,
                                                                        ))).then(
                                                                (value) {
                                                              setState(() {});
                                                            });
                                                          },
                                                          icon: Icon(
                                                            FontAwesomeIcons
                                                                .penToSquare,
                                                            size: 16,
                                                          )),
                                                      Visibility(
                                                        visible: global
                                                                .userProfileController
                                                                .addressList[
                                                                    index]
                                                                .type!
                                                                .toLowerCase() !=
                                                            'home',
                                                        child: IconButton(
                                                            onPressed:
                                                                () async {
                                                              await deleteConfirmationDialog(
                                                                  index);
                                                            },
                                                            icon: Icon(
                                                              FontAwesomeIcons
                                                                  .trashCan,
                                                              size: 16,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                subtitle: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Text(
                                                      global
                                                                  .userProfileController
                                                                  .addressList[
                                                                      index]
                                                                  .street ==
                                                              null
                                                          ? "${global.userProfileController.addressList[index].building_villa}, ${global.userProfileController.addressList[index].society}"
                                                          : "${global.userProfileController.addressList[index].building_villa}, ${global.userProfileController.addressList[index].street}, ${global.userProfileController.addressList[index].society}",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              fontMetropolisRegular,
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          fontSize: 12,
                                                          color: ColorConstants
                                                              .pureBlack),
                                                      maxLines: 3,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      "", //'${AppLocalizations.of(context).txt_no_address}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12),
                                    ),
                                  )
                            : _shimmerList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Future deleteConfirmationDialog(int index) async {
    try {
      await showCupertinoDialog<bool>(
        context: context,
        builder: (context) => Theme(
          data: ThemeData(dialogBackgroundColor: Colors.white),
          child: CupertinoAlertDialog(
            title: Text(
              "", // " ${AppLocalizations.of(context).tle_delete_address} ",
            ),
            content: Text(
              // "${AppLocalizations.of(context).lbl_delete_address_desc}  ",
              'Are you sure you want to delete this address?',
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(
                  "", //'${AppLocalizations.of(context).btn_ok}',
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  showOnlyLoaderDialog();
                  await _removeAddress(index);
                },
              ),
              CupertinoDialogAction(
                child: Text(
                    // ${AppLocalizations.of(context).lbl_cancel}
                    "Cancel",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: fontMetropolisRegular,
                        fontWeight: FontWeight.w200,
                        color: ColorConstants.appColor)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      print("Exception - addressListScreen.dart - deleteConfirmationDialog():" +
          e.toString());
      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (global.currentUser.id != null) {
      islogin = true;
      _getMyAddressList();
    } else {
      islogin = false;
      _isDataLoaded = true;
    }
  }

  _getMyAddressList() async {
    try {
      await global.userProfileController.getUserAddressList();
      if (global.userProfileController.addressList.length > 0) {
        _isDataLoaded = true;
      } else {
        _isDataLoaded = false;
      }
      print('G1--->${global.userProfileController.addressList.length}');
      setState(() {});
    } catch (e) {
      print("Exception - addressListScreen.dart - _getMyAddressList():" +
          e.toString());
    }
  }

  _removeAddress(int index) async {
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        global.userProfileController.removeUserAddress(index);
        hideLoader();
      } else {
        hideLoader();
        showNetworkErrorSnackBar(_scaffoldKey!);
      }
    } catch (e) {
      print("Exception - addressListScreen.dart - _removeAddress():" +
          e.toString());
    }
  }

  Widget _shimmerList() {
    try {
      return ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(
              top: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(7.0),
              ),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 112,
                    width: MediaQuery.of(context).size.width,
                    child: Card(),
                  ),
                  Divider(),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      print("Exception - addressListScreen.dart - _shimmerList():" +
          e.toString());
      return SizedBox();
    }
  }
}
