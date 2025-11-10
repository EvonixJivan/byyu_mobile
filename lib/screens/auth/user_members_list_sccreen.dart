import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/models/eventsListModel.dart';
import 'package:byyu/screens/auth/add_member.dart';
import 'package:byyu/widgets/bottom_button.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/userModel.dart';

class UserInfoTile extends StatefulWidget {
  final String? value;
  final Widget? leadingIcon;
  final String? heading;
  final Function? onPressed;
  final key;

  UserInfoTile(
      {@required this.heading,
      this.value,
      this.leadingIcon,
      this.onPressed,
      this.key})
      : super();

  @override
  _UserInfoTileState createState() => _UserInfoTileState();
}

class UserMemberListScreen extends BaseRoute {
  UserMemberListScreen({a, o}) : super(a: a, o: o, r: 'UserMemberListScreen');

  @override
  _UserMemberListScreenState createState() => _UserMemberListScreenState();
}

class _UserInfoTileState extends State<UserInfoTile> {
  String? value;
  Widget? leadingIcon;
  String? heading;
  Function? onPressed;
  var key;

  _UserInfoTileState(
      {@required this.heading,
      this.value,
      this.leadingIcon,
      this.onPressed,
      this.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return InkWell(
      key: key,
      onTap: () => onPressed!(),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  leadingIcon ?? Container(),
                  leadingIcon == null ? Container() : SizedBox(width: 8),
                  Text(
                    heading!,
                    style: textTheme.bodyLarge!.copyWith(
                        fontWeight:
                            value == null ? FontWeight.bold : FontWeight.normal,
                        fontSize: 15),
                  ),
                ],
              ),
              SizedBox(height: 8),
              value == null
                  ? Container()
                  : Text(
                      value!,
                      style: textTheme.bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
              value == null ? Container() : SizedBox(height: 8),
              Divider(
                thickness: 2.0,
              ),
            ],
          ),
          onPressed == null
              ? Container()
              : Positioned(
                  bottom: 24,
                  right: global.isRTL ? null : 0,
                  left: global.isRTL ? 0 : null,
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                  ),
                ),
        ],
      ),
    );
  }
}

class _UserMemberListScreenState extends BaseRouteState {
  bool _isDataLoaded = false;
  GlobalKey<ScaffoldState>? _scaffoldKey1;
  List<AddMemberList> memberList = [];
  GlobalKey<ScaffoldState>? _scaffoldKey;
  List<EventsData> _eventsList = [];

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
        key: _scaffoldKey1,
        appBar: AppBar(
          leading: BackButton(
              onPressed: () {
                print("Go back");
                Navigator.pop(context);
              },
              color: ColorConstants.appColor,
            ),
            actions: [],
            backgroundColor: ColorConstants.appBarColorWhite,
            leadingWidth: 46,
            centerTitle: false,
            title: Text(
              "Special Days",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: ColorConstants.newTextHeadingFooter,
                  fontFamily: fontRailwayRegular,
                  fontWeight: FontWeight.w200),
            )),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.transparent, width: 1),
          ),
          child: BottomButton(
              color: ColorConstants.appColor,
              child: Text(
                "ADD",
                style: TextStyle(
                    fontFamily: fontRalewayMedium,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: ColorConstants.white,
                    letterSpacing: 1),
              ),
              loadingState: false,
              disabledState: false,
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                          builder: (context) => AddMemberScreen(
                                a: widget.analytics,
                                o: widget.observer,
                              )),
                    )
                    .then((value) => {
                          print(
                              "this is the then function of user member where value =${value}"),
                          value == "true" ? _callGetMemberApi() : Container(),
                        });
              }),
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            color: ColorConstants.colorPageBackground,
            child: memberList.length > 0
                ? _isDataLoaded
                    ? RefreshIndicator(
                        onRefresh: () async {
                          global.userProfileController.currentUser =
                              new CurrentUser();
                          await _callGetMemberApi();
                        },
                        child: SafeArea(
                          top: false,
                          bottom: true,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10, right: 0, left: 0),
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            top: 5,
                                            bottom: 5,
                                            right: 3,
                                            left: 3),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                color:
                                                    ColorConstants.newAppColor)),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              'assets/images/swipeleft.png',
                                              width: 30,
                                              height: 30,
                                              color: ColorConstants.appColor,
                                              fit: BoxFit.contain,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Swipe left to",
                                              style: TextStyle(
                                                  fontFamily:
                                                      global.fontRailwayRegular,
                                                  fontWeight: FontWeight.w200,
                                                  fontSize: 13,
                                                  color:
                                                      ColorConstants.newTextHeadingFooter),
                                            ),
                                            Text(
                                              " Delete",
                                              style: TextStyle(
                                                  fontFamily:
                                                      global.fontRailwayRegular,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13,
                                                  color: ColorConstants
                                                      .newTextHeadingFooter),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            top: 5,
                                            bottom: 5,
                                            right: 3,
                                            left: 3),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                color:
                                                    ColorConstants.newAppColor)),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Swipe right to",
                                              style: TextStyle(
                                                  fontFamily:
                                                      global.fontRailwayRegular,
                                                  fontWeight: FontWeight.w200,
                                                  fontSize: 13,
                                                  color:
                                                      ColorConstants.newTextHeadingFooter),
                                            ),
                                            Text(
                                              " Edit",
                                              style: TextStyle(
                                                  fontFamily:
                                                      global.fontRailwayRegular,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13,
                                                  color: ColorConstants
                                                      .newTextHeadingFooter),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Image.asset(
                                              'assets/images/swiperight.png',
                                              width: 30,
                                              height: 30,
                                              fit: BoxFit.contain,
                                              color: ColorConstants.newAppColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20,
                                        left: 10,
                                        right: 10,
                                        bottom: 5),
                                    child: Container(
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: memberList.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Dismissible(
                                              key: UniqueKey(),
                                              direction:
                                                  DismissDirection.horizontal,
                                              onDismissed: (direction) async {
                                                if (direction ==
                                                    DismissDirection
                                                        .endToStart) {
                                                  callMemberDeleteAPI(
                                                      memberList[index].id!);
                                                } else {
                                                  Navigator.of(context)
                                                      .push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                AddMemberScreen(
                                                                  a: widget
                                                                      .analytics,
                                                                  o: widget
                                                                      .observer,
                                                                  memberID:
                                                                      memberList[
                                                                              index]
                                                                          .id,
                                                                  fullName:
                                                                      memberList[
                                                                              index]
                                                                          .name,
                                                                  relation: memberList[
                                                                          index]
                                                                      .relation,
                                                                  specialDay: memberList[
                                                                          index]
                                                                      .celebrationName,
                                                                  date: memberList[
                                                                          index]
                                                                      .dateDay,
                                                                  month: memberList[
                                                                          index]
                                                                      .dateMonth,
                                                                )),
                                                      )
                                                      .then((value) => {
                                                            print(
                                                                "this is the then function of user member where value =${value}"),
                                                            value == "true"
                                                                ? _callGetMemberApi()
                                                                : Container(),
                                                          });
                                                }

                                                print(
                                                    "Nikhil swipe ${direction}");

                                                setState(() {});
                                              },
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 5),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3.6,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Stack(
                                                  children: <Widget>[
                                                    Card(
                                                      elevation: 0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: ColorConstants
                                                                .colorHomePageSectiondim,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300)),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        2,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              10,
                                                                          left:
                                                                              5),
                                                                      child:
                                                                          Text(
                                                                        "${memberList[index].name} ",
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        maxLines:
                                                                            1,
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                fontRailwayRegular,
                                                                            fontWeight:
                                                                                FontWeight.w900,
                                                                            color: ColorConstants.newTextHeadingFooter,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            fontSize: 16),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        2,
                                                                    child:
                                                                        Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              5),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(
                                                                          top:
                                                                              5,
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Text(
                                                                              "Relation: ",
                                                                              textAlign: TextAlign.start,
                                                                              maxLines: 1,
                                                                              style: TextStyle(overflow: TextOverflow.ellipsis, fontFamily: fontRailwayRegular, fontWeight: FontWeight.w200, color: ColorConstants.pureBlack, fontSize: 14),
                                                                            ),
                                                                            Expanded(
                                                                              child: Text(
                                                                                "${memberList[index].relation}",
                                                                                textAlign: TextAlign.start,
                                                                                maxLines: 1,
                                                                                style: TextStyle(overflow: TextOverflow.ellipsis, fontFamily: fontRailwayRegular, fontWeight: FontWeight.w600, color: ColorConstants.newTextHeadingFooter, fontSize: 14),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        2,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              3,
                                                                          left:
                                                                              5),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Text(
                                                                            "Date: ",
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style: TextStyle(
                                                                                fontFamily: fontRailwayRegular,
                                                                                fontWeight: FontWeight.w200,
                                                                                color: ColorConstants.pureBlack,
                                                                                fontSize: 14),
                                                                          ),
                                                                          Text(
                                                                            "${memberList[index].dateDay} ${memberList[index].dateMonth!.substring(0, 3).capitalizeFirst}",
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style: TextStyle(
                                                                                fontFamily: fontRailwayRegular,
                                                                                fontWeight: FontWeight.w600,
                                                                                color: ColorConstants.newTextHeadingFooter,
                                                                                fontSize: 14),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top: 1),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Flexible(
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(100),
                                                                        child:
                                                                            CachedNetworkImage(
                                                                          width:
                                                                              55,
                                                                          height:
                                                                              55,
                                                                          fit: BoxFit
                                                                              .contain,
                                                                          imageUrl:
                                                                              global.imageBaseUrl + memberList[index].icon!,
                                                                          placeholder: (context, url) => Center(
                                                                              child: CircularProgressIndicator(
                                                                            strokeWidth:
                                                                                1.0,
                                                                          )),
                                                                          errorWidget: (context, url, error) => Container(
                                                                              child: Image.asset(
                                                                            global.noImage,
                                                                            fit:
                                                                                BoxFit.contain,
                                                                            width:
                                                                                175,
                                                                            height:
                                                                                210,
                                                                            alignment:
                                                                                Alignment.center,
                                                                          )),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                    Text(
                                                                      memberList[
                                                                              index]
                                                                          .celebrationName!,
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              fontRailwayRegular,
                                                                          fontWeight: FontWeight
                                                                              .w900,
                                                                          color: ColorConstants
                                                                              .newTextHeadingFooter,
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          memberList[index].monthValue == 0
                                                                              ? "Today"
                                                                              : memberList[index].monthValue != 1
                                                                                  ? "Next ${memberList[index].monthValue.toString().substring(1)}"
                                                                                  : "Tomorrow",
                                                                          style: TextStyle(
                                                                              fontFamily: fontRailwayRegular,
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: ColorConstants.appColor),
                                                                        ),
                                                                        Text(
                                                                          memberList[index].monthValue == 0 || memberList[index].monthValue == 1
                                                                              ? ""
                                                                              : " Days",
                                                                          style: TextStyle(
                                                                              fontFamily: fontRailwayRegular,
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: ColorConstants.appColor),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        height: 100,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            10,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: ColorConstants.colorPageBackground,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    margin: EdgeInsets.only(left: 8, right: 8),
                    color: ColorConstants.colorPageBackground,
                    child: Center(
                      child: Text(
                        "Never miss any occasion! Set up personalized reminders for your loved ones and make every celebration memorable.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: global.fontRalewayMedium,
                            fontSize: 20,
                            fontWeight: FontWeight.w200,
                            color: ColorConstants.newAppColor),
                      ),
                    ),
                  )));
  }

  String allWordsCapitilize(String str) {
    return str.toLowerCase().split(' ').map((word) {
      String leftText = (word.length > 1) ? word.substring(1, word.length) : '';
      return word[0].toUpperCase() + leftText;
    }).join(' ');
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      this._callGetMemberApi();
    });
  }

  _callGetMemberApi() async {
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        await apiHelper.getMemberList().then((result) async {
          if (result != null) {
            List<AddMemberList> _tList = result.data;
            if (result.data != null) {
              memberList.clear();
              memberList.addAll(_tList);
              print("Member list  length${memberList.length}");
              for (int j = 0; j < memberList.length; j++) {
                for (int i = 0; i < _eventsList.length; i++) {
                  if (memberList[j].celebrationName!.toLowerCase() ==
                      _eventsList[i].eventName!.toLowerCase()) {
                    memberList[j].eventImage =
                        _eventsList[i].eventImage.toString();
                  }
                }
              }
              for (int i = 0; i < memberList.length; i++) {
                if (memberList[i].dateMonth != null &&
                    memberList[i].dateDay != null) {
                  for (int j = 0; j < global.allMonths.length; j++) {
                    if (memberList[i].dateMonth!.toLowerCase() ==
                        global.allMonths[j].toLowerCase()) {
                      int value = j + 1;
                      final tomorrow = DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day + 1);
                      final dateToCheck = DateTime(DateTime.now().year, value,
                          int.parse(memberList[i].dateDay!));
                      if (tomorrow == dateToCheck) {
                        memberList[i].monthValue = 1;
                      } else {
                        var duration = DateTime.now()
                                .difference(DateTime(DateTime.now().year, value,
                                    int.parse(memberList[i].dateDay!)))
                                .inHours /
                            24.round();
                        print(
                            "this is the duration ahhead days calculation part ${duration}");
                        if (duration.toInt().isNegative) {
                          if (duration.toString().contains(".")) {
                            memberList[i].monthValue = duration.round() - 1;
                          } else {
                            memberList[i].monthValue = duration.round();
                          }
                          print("this is the duration ahhead  ${duration}");
                        } else {
                          print("Else part started");
                          duration = DateTime.now()
                                  .difference(DateTime(DateTime.now().year + 1,
                                      value, int.parse(memberList[i].dateDay!)))
                                  .inHours /
                              24.round();
                          if (duration.toInt() > 1) {
                            print("this is grater than 1 condition");
                            memberList[i].monthValue = duration.toInt();
                          } else {
                            if (duration.toString().contains("365.") ||
                                duration.round().toString().contains("365") ||
                                (duration.toInt().isNegative &&
                                    double.parse(duration.toString().substring(
                                            1, duration.toString().length)) >
                                        364)) {
                              memberList[i].monthValue = 0;
                              print("this is 365 if condition");
                            } else {
                              if (duration.toString().contains(".")) {
                                memberList[i].monthValue = duration.round() - 1;
                              } else {
                                memberList[i].monthValue = duration.round();
                              }

                              print("this is 365 else condition${duration}");
                            }
                          }
                        }
                      }
                    }
                  }
                } else {
                  memberList.removeAt(i);
                }
              }
              memberList.sort((a, b) => b.monthValue!.compareTo(a.monthValue!));

              setState(() {
                _isDataLoaded = true;
              });
            } else {
              showSnackBarWithDuration(
                key: _scaffoldKey1,
                snackBarMessage: result.message.toString(),
              );
            }
          }
        });
      } else {}
    } catch (e) {
      print(
          "Exception -  get user member list api call - _callGetMemberApi():" +
              e.toString());
    }
  }

  _getEventsList() async {
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        await apiHelper.getEventsList().then((result) async {
          if (result != null) {
            List<EventsData> _tList = result.data;

            _eventsList.addAll(_tList);

            _callGetMemberApi();
            setState(() {});
          }
        });
      } else {
        showNetworkErrorSnackBar1(_scaffoldKey!);
      }
    } catch (e) {
      print("Exception - all_categories_screen.dart - _getEventsList():" +
          e.toString());
    }
  }

  showNetworkErrorSnackBar1(GlobalKey<ScaffoldState> scaffoldKey) {
    try {
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
                  'No internet available',
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
            textColor: Colors.white, label: 'RETRY', onPressed: () {}),
        backgroundColor: Colors.grey,
      ));
    } catch (e) {
      print("Exception -  base.dart - showNetworkErrorSnackBar1():" +
          e.toString());
    }
  }

  callMemberDeleteAPI(int memberID) async {
    showOnlyLoaderDialog();
    try {
      print('HomeScreen data');
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        await apiHelper.deleteMemberAPI(memberID).then((result) async {
          if (result != null) {
            print(result.data.toString());
            if (result.data.toString() == "1") {
              print("NIKHIL STATUS 1");
              hideLoader();
              _callGetMemberApi();
              _isDataLoaded = false;
            } else {
              hideLoader();
              Fluttertoast.showToast(
                msg: "Something went wrong", // message
                toastLength: Toast.LENGTH_SHORT, // length
                gravity: ToastGravity.CENTER, // location
                // duration
              );
            }
          }
        });
      } else {
        hideLoader();
        showNetworkErrorSnackBar1(_scaffoldKey!);
      }
    } catch (e) {
      hideLoader();
      print(
          "Exception - dashboard_screen.dart callFiltersApi- _getHomeScreenData():" +
              e.toString());
    }
  }
}
