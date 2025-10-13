import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

  
import 'package:shimmer/shimmer.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/notificationModel.dart';
import 'package:byyu/theme/style.dart';

class NotificationScreen extends BaseRoute {
  NotificationScreen({a, o}) : super(a: a, o: o, r: 'NotificationScreen');
  @override
  _NotificationScreenState createState() => new _NotificationScreenState();
}

class _NotificationScreenState extends BaseRouteState {
  List<NotificationModel> _notificationList = [];
  bool _isDataLoaded = false;
  int page = 1;
  bool _isRecordPending = true;
  bool _isMoreDataLoaded = false;
  GlobalKey<ScaffoldState>? _scaffoldKey;
  ScrollController _scrollController = ScrollController();
  _NotificationScreenState() : super();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: global.white,
      child: SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: ColorConstants.appBarColorWhite,
              leading: IconButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: ColorConstants.newAppColor,
                ),
              ),
              centerTitle: false,
              title: Text(
                // "${AppLocalizations.of(context).btn_notification}",
                "Notification",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: ColorConstants.pureBlack,
                    fontFamily: fontRailwayRegular,
                    fontWeight: FontWeight.w200),
              ),

              /// Delete Notification funtioanlity
              /*actions: [
              _notificationList.length > 0
                  ? IconButton(
                      onPressed: () async {
                        await deleteConfirmationDialog();
                      },
                      icon: Icon(
                        FontAwesomeIcons.trashCan,
                        color: Theme.of(context).primaryColor,
                      ))
                  : SizedBox()
            ],*/
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              color: ColorConstants.colorPageBackground,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: RefreshIndicator(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  color: Theme.of(context).primaryColor,
                  onRefresh: () async {
                    _isDataLoaded = false;
                    _isRecordPending = true;
                    _notificationList.clear();
                    setState(() {});
                    await _init();
                  },
                  child: _isDataLoaded
                      ? _notificationList.length > 0
                          ? SingleChildScrollView(
                              controller: _scrollController,
                              child: Column(
                                children: [
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: _notificationList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(7.0)),
                                        margin: EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 10,
                                            bottom: 5),
                                        //color: ColorConstants.StarRating,
                                        child: Container(
                                          // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            border: Border.all(
                                                width: 0.2,
                                                color: ColorConstants.appColor),
                                            color: ColorConstants
                                                .appBrownFaintColor,
                                          ),
                                          // color: Colors.yellow,
                                          child: Theme(
                                            data: ThemeData(
                                                dividerColor:
                                                    Colors.transparent),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    _notificationList[index]
                                                                .image !=
                                                            null
                                                        ? Container(
                                                            height: 50,
                                                            width: 50,
                                                            alignment: Alignment
                                                                .center,
                                                            child: _notificationList[
                                                                            index]
                                                                        .image !=
                                                                    null
                                                                ? CachedNetworkImage(
                                                                    imageUrl: global
                                                                            .catImageBaseUrl +
                                                                        _notificationList[index]
                                                                            .image!,
                                                                    imageBuilder:
                                                                        (context,
                                                                                imageProvider) =>
                                                                            Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                        image: DecorationImage(
                                                                            image:
                                                                                imageProvider,
                                                                            fit:
                                                                                BoxFit.cover),
                                                                      ),
                                                                    ),
                                                                    placeholder: (context,
                                                                            url) =>
                                                                        Center(
                                                                            child:
                                                                                CircularProgressIndicator()),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                        image: DecorationImage(
                                                                            image:
                                                                                AssetImage('assets/images/404_error_image.png'),
                                                                            fit: BoxFit.cover),
                                                                      ),
                                                                    ),
                                                                  )
                                                                // : Container(
                                                                //     decoration:
                                                                //         BoxDecoration(
                                                                //       borderRadius:
                                                                //           BorderRadius
                                                                //               .circular(
                                                                //                   15),
                                                                //       image: DecorationImage(
                                                                //           image: AssetImage(
                                                                //               'assets/images/icon.png'),
                                                                //           fit: BoxFit
                                                                //               .cover),
                                                                //       // image: DecorationImage(image: AssetImage(global.noImage), fit: BoxFit.cover),
                                                                //     ),
                                                                //   )
                                                                : Container(),
                                                          )
                                                        : Container(),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        _notificationList[index]
                                                            .notiTitle!,
                                                        style: TextStyle(
                                                          fontFamily: global
                                                              .fontRailwayRegular,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 16,
                                                          color: ColorConstants
                                                              .pureBlack,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 12,
                                                ),
                                                Row(
                                                  children: [
                                                    Flexible(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10,
                                                                right: 10),
                                                        child: Text(
                                                          '${_notificationList[index].notiMessage}',
                                                          style: TextStyle(
                                                              fontFamily: global
                                                                  .fontRailwayRegular,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200,
                                                              fontSize: 14,
                                                              color:
                                                                  ColorConstants
                                                                      .pureBlack,
                                                              letterSpacing: 1),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(child: Text("")),
                                                    Container(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 5),
                                                        child: Text(
                                                          '\n${global.getFormattedDate(dateandtime.format(_notificationList[index].createdAt!))}',//'\n${dateOnly.format(_notificationList[index].createdAt!)}',
                                                          style: TextStyle(
                                                              fontFamily: global
                                                                  .fontRailwayRegular,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200,
                                                              fontSize: 12,
                                                              color:
                                                                  ColorConstants
                                                                      .pureBlack,
                                                              letterSpacing: 1),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                            // child: ExpansionTile(
                                            //   // backgroundColor: isExpanded ? lightPurple : cardLightPurple,
                                            //   tilePadding: EdgeInsets.all(0),
                                            //   initiallyExpanded: true,
                                            //   enabled: false,
                                            //   childrenPadding:
                                            //       EdgeInsets.all(0),
                                            //   title: Container(
                                            //     child: Row(
                                            //       children: [
                                            //         _notificationList[index]
                                            //                     .image !=
                                            //                 null
                                            //             ? Container(
                                            //                 height: 50,
                                            //                 width: 50,
                                            //                 alignment: Alignment
                                            //                     .center,
                                            //                 child: _notificationList[
                                            //                                 index]
                                            //                             .image !=
                                            //                         null
                                            //                     ? CachedNetworkImage(
                                            //                         imageUrl: global
                                            //                                 .catImageBaseUrl +
                                            //                             _notificationList[index]
                                            //                                 .image!,
                                            //                         imageBuilder:
                                            //                             (context,
                                            //                                     imageProvider) =>
                                            //                                 Container(
                                            //                           alignment:
                                            //                               Alignment
                                            //                                   .center,
                                            //                           decoration:
                                            //                               BoxDecoration(
                                            //                             borderRadius:
                                            //                                 BorderRadius.circular(15),
                                            //                             image: DecorationImage(
                                            //                                 image:
                                            //                                     imageProvider,
                                            //                                 fit:
                                            //                                     BoxFit.cover),
                                            //                           ),
                                            //                         ),
                                            //                         placeholder: (context,
                                            //                                 url) =>
                                            //                             Center(
                                            //                                 child:
                                            //                                     CircularProgressIndicator()),
                                            //                         errorWidget: (context,
                                            //                                 url,
                                            //                                 error) =>
                                            //                             Container(
                                            //                           decoration:
                                            //                               BoxDecoration(
                                            //                             borderRadius:
                                            //                                 BorderRadius.circular(15),
                                            //                             image: DecorationImage(
                                            //                                 image:
                                            //                                     AssetImage('assets/images/404_error_image.png'),
                                            //                                 fit: BoxFit.cover),
                                            //                           ),
                                            //                         ),
                                            //                       )
                                            //                     // : Container(
                                            //                     //     decoration:
                                            //                     //         BoxDecoration(
                                            //                     //       borderRadius:
                                            //                     //           BorderRadius
                                            //                     //               .circular(
                                            //                     //                   15),
                                            //                     //       image: DecorationImage(
                                            //                     //           image: AssetImage(
                                            //                     //               'assets/images/icon.png'),
                                            //                     //           fit: BoxFit
                                            //                     //               .cover),
                                            //                     //       // image: DecorationImage(image: AssetImage(global.noImage), fit: BoxFit.cover),
                                            //                     //     ),
                                            //                     //   )
                                            //                     : Container(),
                                            //               )
                                            //             : Container(),
                                            //         SizedBox(
                                            //           width: 15,
                                            //         ),
                                            //         Expanded(
                                            //           child: Text(
                                            //             _notificationList[index]
                                            //                 .notiTitle!,
                                            //             style: TextStyle(
                                            //               fontFamily: global
                                            //                   .fontRailwayRegular,
                                            //               fontWeight:
                                            //                   FontWeight.w400,
                                            //               fontSize: 14,
                                            //               color: ColorConstants
                                            //                   .pureBlack,
                                            //             ),
                                            //           ),
                                            //         ),
                                            //       ],
                                            //     ),
                                            //   ),
                                            //   children: [
                                            //     SizedBox(
                                            //       height: 5,
                                            //     ),
                                            //     Container(
                                            //       child: Padding(
                                            //         padding:
                                            //             const EdgeInsets.only(
                                            //                 left: 10,
                                            //                 right: 10),
                                            //         child: Text(
                                            //           '${_notificationList[index].notiMessage}',
                                            //           style: TextStyle(
                                            //               fontFamily: global
                                            //                   .fontRailwayRegular,
                                            //               fontWeight:
                                            //                   FontWeight.w200,
                                            //               fontSize: 12,
                                            //               color: ColorConstants
                                            //                   .pureBlack,
                                            //               letterSpacing: 1),
                                            //         ),
                                            //       ),
                                            //     ),
                                            //     // SizedBox(
                                            //     //   height: 3,
                                            //     // ),
                                            //     Container(
                                            //       alignment:
                                            //           Alignment.centerRight,
                                            //       child: Padding(
                                            //         padding:
                                            //             const EdgeInsets.only(
                                            //                 bottom: 5),
                                            //         child: Text(
                                            //           '\n${getlocaleNotifyTime(_notificationList[index].createdAt!.toString())}',
                                            //           style:
                                            //               GoogleFonts.poppins(
                                            //                   fontWeight:
                                            //                       FontWeight
                                            //                           .w500,
                                            //                   fontSize: 12,
                                            //                   color: global
                                            //                       .indigoColor,
                                            //                   letterSpacing: 1),
                                            //         ),
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  _isMoreDataLoaded
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            backgroundColor: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : SizedBox()
                                ],
                              ),
                            )
                          : Center(
                              child: Text(
                                // "${AppLocalizations.of(context).txt_nothing_to_show}",
                                "Nothing is yet to see here",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: global.fontRalewayMedium,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: ColorConstants.newAppColor),
                              ),
                            )
                      : _shimmerWidget(),
                ),
              ),
            )),
      ),
    );
  }

  Future deleteConfirmationDialog() async {
    try {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                // '${AppLocalizations.of(context).lbl_delete_notification}'
                "Delete All Notification",
              ),
              content: Text(
                  // "${AppLocalizations.of(context).txt_delete_notification_desc}",
                  "Are you sure you want to delete all notification?",
                  style: Theme.of(context).textTheme.bodyMedium),
              actions: [
                ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await _deleteAllNotification();
                    },
                    child: Text(
                        'YES')), //${AppLocalizations.of(context).btn_yes}')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('NO}'))
              ],
            );
          });
    } catch (e) {
      print(
          "Exception - notification_screen.dart - deleteConfirmationDialog():" +
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
    _init();
  }

  _deleteAllNotification() async {
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog();
        await apiHelper.deleteAllNotification().then((result) async {
          if (result != null) {
            if (result.status == "1") {
              hideLoader();
              _notificationList.clear();
              setState(() {});
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey!);
      }
    } catch (e) {
      print("Exception - notification_screen.dart - _deleteAllNotification():" +
          e.toString());
    }
  }

  _getData() async {
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        if (_isRecordPending) {
          setState(() {
            _isMoreDataLoaded = true;
          });
          if (_notificationList.isEmpty) {
            page = 1;
          } else {
            page++;
          }
          await apiHelper.getAllNotification(page).then((result) async {
            if (result != null) {
              if (result.status == "1") {
                List<NotificationModel> _tList = result.data;
                if (_tList.isEmpty) {
                  _isRecordPending = false;
                }
                _notificationList.addAll(_tList);
                print(global.catImageBaseUrl + _notificationList[0].image!);
                setState(() {
                  _isMoreDataLoaded = false;
                });
              }
            }
          });
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey!);
      }
    } catch (e) {
      print(
          "Exception - notification_screen.dart - _getData():" + e.toString());
    }
  }

  _init() async {
    try {
      await _getData();
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent &&
            !_isMoreDataLoaded) {
          setState(() {
            _isMoreDataLoaded = true;
          });
          await _getData();
          setState(() {
            _isMoreDataLoaded = false;
          });
        }
      });
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - notification_screen.dart - _init():" + e.toString());
    }
  }

  Widget _shimmerWidget() {
    try {
      return ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
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
      print("Exception - notification_screen.dart - _shimmerWidget():" +
          e.toString());
      return SizedBox();
    }
  }
}
