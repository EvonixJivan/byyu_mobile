import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/models/productDetailModel.dart';
import 'package:byyu/screens/payment_view/payment_screen.dart';
import 'package:flutter/material.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import 'package:shimmer/shimmer.dart';
import 'package:byyu/controllers/cart_controller.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/categoryProductModel.dart';
import 'package:byyu/models/productFilterModel.dart';
//import 'package:byyu/screens/filter_screen.dart';
import 'package:byyu/screens/home_screen.dart';
import 'package:byyu/widgets/cart_item_count_button.dart';
import 'package:byyu/widgets/products_menu.dart';

class AddMessageScreen extends BaseRoute {
  final String? isHomeSelected;

  AddMessageScreen({a, o, this.isHomeSelected})
      : super(a: a, o: o, r: 'AddMessageScreen');

  @override
  _AddMessageScreenState createState() => _AddMessageScreenState();
}

class _AddMessageScreenState extends BaseRouteState {
  String? isHomeSelected;
  ScrollController eventScrollController = ScrollController();
  GlobalKey<ScaffoldState>? _scaffoldKey;
  List<EventsDetail> _eventList = [];
  List<EventsMessage> eventsMessage = [];
  bool _isDataLoaded = false;
  int selectedEventIndex = 0;

  int eventListSelectedIndex = 0;
  ScrollController eventMsgScrollController = ScrollController();

  int? messageListSeletedIndex = null;
  var selectedOccasionString = new TextEditingController();

  _AddMessageScreenState({this.isHomeSelected});
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: ColorConstants.white,
          // centerTitle: true,
          leadingWidth: 50,
          centerTitle: false,
          toolbarHeight: 60,
          titleSpacing: 0,
          title: Container(
            // width: 450,
            child: Text(
              "Add Message",
              // style: textTheme.titleLarge, maxLines: 1,
              style: TextStyle(
                  color: ColorConstants.pureBlack,
                  fontFamily: fontRailwayRegular,
                  fontWeight: FontWeight.w200),
            ),
          ),
          leading: BackButton(
              onPressed: () {
                if (isHomeSelected == 'home') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeScreen(
                                a: widget.analytics,
                                o: widget.observer,
                                selectedIndex: 0,
                              )));
                } else {
                  Navigator.pop(context);
                }
              },
              //icon: Icon(Icons.keyboard_arrow_left),
              color: ColorConstants.pureBlack),
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
                        margin: EdgeInsets.only(left: 5, right: 5),
                        height: 60,
                        padding: EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            controller: eventScrollController,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: _eventList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => Container(
                                  margin: EdgeInsets.only(
                                      top: 3, bottom: 3, right: 5, left: 5),
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      messageListSeletedIndex = null;
                                      selectedOccasionString.text = "";
                                      selectedEventIndex = index;

                                      setState(() {});
                                    },
                                    child: Wrap(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: selectedEventIndex == index
                                                ? ColorConstants.appColor
                                                : ColorConstants.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                width: 0.5,
                                                color: selectedEventIndex ==
                                                        index
                                                    ? ColorConstants.appColor
                                                    : ColorConstants.pureBlack),
                                          ),
                                          //width: double.infinity,
                                          padding: EdgeInsets.only(
                                              left: 8, right: 8),
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  bottom: 5, top: 5),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              //width: double.infinity,
                                              child: Text(
                                                "${_eventList[index].eventName}",
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontFamily: global
                                                        .fontRailwayRegular,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w200,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: selectedEventIndex ==
                                                            index
                                                        ? ColorConstants.white
                                                        : ColorConstants
                                                            .pureBlack),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 2.0,
                        width: MediaQuery.of(context).size.width,
                        child: Scrollbar(
                          child: ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              controller: eventMsgScrollController,
                              itemCount: _eventList[selectedEventIndex]
                                  .eventsMessage!
                                  .length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) => Container(
                                    margin: EdgeInsets.only(
                                        top: 3, bottom: 3, right: 5, left: 5),
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        selectedOccasionString.text = "";
                                        messageListSeletedIndex = index;

                                        selectedOccasionString.text =
                                            _eventList[selectedEventIndex]
                                                .eventsMessage![index]
                                                .message
                                                .toString();
                                        setState(() {});
                                      },
                                      child: Wrap(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 5,
                                                    right: 5,
                                                    top: 10,
                                                    bottom: 10),
                                                width: double.infinity,
                                                child: Text(
                                                  "${_eventList[selectedEventIndex].eventsMessage![index].message}",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontFamily: global
                                                        .fontRailwayRegular,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w200,
                                                    color:
                                                        messageListSeletedIndex ==
                                                                index
                                                            ? ColorConstants
                                                                .appColor
                                                            : ColorConstants
                                                                .pureBlack,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            color:
                                                messageListSeletedIndex == index
                                                    ? ColorConstants.appColor
                                                    : ColorConstants.grey,
                                            thickness: 0.5,
                                            height: 0.5,
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 1, right: 1, top: 10),
                        child: Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width - 20,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0.5,
                                  color: Colors.grey,
                                ),
                                color: ColorConstants.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 5, right: 5, top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                        // width: 100,
                                        //height: 80,
                                        child: TextFormField(
                                      maxLength: 250,
                                      controller: selectedOccasionString,
                                      maxLines: null,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w200,
                                          fontFamily:
                                              global.fontRailwayRegular,
                                          color: ColorConstants.pureBlack),
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w200,
                                            fontFamily: fontRailwayRegular,
                                            color: ColorConstants.pureBlack),
                                        //labelText: 'Message',
                                        hintText: "Message",
                                        filled: true,
                                        fillColor: Colors.transparent,
                                        contentPadding: const EdgeInsets.only(
                                          left: 8.0,
                                          right: 8.0,
                                          bottom: 8.0,
                                        ),
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                      ),
                                      onChanged: (value) {},
                                    )),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              )
            : Center(child: new CircularProgressIndicator()),
        bottomNavigationBar: _isDataLoaded
            ? BottomAppBar(
                color: ColorConstants.white,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context, selectedOccasionString.text);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: ColorConstants.appColor,
                        border: Border.all(
                            color: ColorConstants.appColor, width: 0.5),
                        borderRadius: BorderRadius.circular(10)),
                    margin:
                        EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 15),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          "Save Message",
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
              )
            : SizedBox(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    try {
      await _getEventMessages();
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - all_categories_screen.dart - _init():" + e.toString());
    }
  }

  _getEventMessages() async {
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        await apiHelper.getEventMessages().then((result) async {
          if (result != null) {
            List<EventsDetail> _tList = result.data;

            _eventList.clear();
            _eventList.addAll(_tList);

            // selectedEventIndex = _eventList.length;

            setState(() {});
          }
        });
      } else {
        showNetworkErrorSnackBar1(_scaffoldKey!);
      }
    } catch (e) {
      print("Exception - all_categories_screen.dart - _getCategoryList():" +
          e.toString());
    }
  }

  _shimmer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: 15,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                    height: 100 * MediaQuery.of(context).size.height / 830,
                    width: MediaQuery.of(context).size.width,
                    child: Card());
              })),
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
              // _onRefresh();
            }),
        backgroundColor: Colors.grey,
      ));
    } catch (e) {
      print("Exception -  base.dart - showNetworkErrorSnackBar1():" +
          e.toString());
    }
  }
}
