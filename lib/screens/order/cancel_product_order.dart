import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:material_text_fields/material_text_fields.dart';
import 'package:material_text_fields/theme/material_text_field_theme.dart';
import 'package:shimmer/shimmer.dart';

import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/cancelOrderStatusModel.dart';

import 'package:byyu/widgets/toastfile.dart';

class CancelProductOrderScreen extends BaseRoute {
  final String? cartId;
  final String? storeOrderId;

  CancelProductOrderScreen({
    a,
    o,
    this.cartId,
    this.storeOrderId,
  }) : super(a: a, o: o, r: 'CouponsScreen');

  @override
  _CancelProductOrderScreenState createState() =>
      _CancelProductOrderScreenState();
}

class _CancelProductOrderScreenState extends BaseRouteState {
  List<CancelStatusListModel> _cancelStatusList = [];
  bool _isDataLoaded = false;

  GlobalKey<ScaffoldState>? _scaffoldKey;
  bool isOthersSelected = false;
  String? cartId, storeOrderId, selectedStatus = "";
  bool _load = false;
  TextEditingController _cReason = new TextEditingController();
  FocusNode _fReason = new FocusNode();
  _CancelProductOrderScreenState({
    this.cartId,
    this.storeOrderId,
  });

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _load
        ? new Container(
            color: Colors.grey[300],
            width: 100.0,
            height: 100.0,
            child: new Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Center(child: new CircularProgressIndicator()),
                    SizedBox(
                      height: 10,
                    ),
                    new Center(child: Text('Loading...')),
                  ],
                )),
          )
        : new Container();
    int count = _cancelStatusList.length;
    int height = count * 35;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
          color: ColorConstants.pureBlack,
        ),
        backgroundColor: ColorConstants.appBrownFaintColor,
        elevation: 0,
        title: Text(
          "Cancel Order",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height - 83,
          child: Stack(
            children: [
              // child:
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: Container()),
                ],
              ),
              Column(
                children: [
                  _isDataLoaded
                      ? _cancelStatusList != null &&
                              _cancelStatusList.length > 0
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, top: 0, right: 10, bottom: 100),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: 5,
                                      right: 5,
                                      bottom: 0,
                                    ),
                                    child: Text('Reasons for cancellation',
                                        style: TextStyle(
                                            fontFamily:
                                                global.fontMetropolisRegular,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: ColorConstants.pureBlack)),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 5, right: 5, top: 10, bottom: 10),
                                    child: Text(
                                        // 'We will miss you! Please select one of the reasons below to proceed',
                                        'Please tell us correct reason cancellation. This information is only used to improve our service',
                                        style: TextStyle(
                                            fontFamily:
                                                global.fontMetropolisRegular,
                                            fontWeight: FontWeight.w200,
                                            fontSize: 14,
                                            color: ColorConstants.pureBlack)),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 5, right: 5, bottom: 5),
                                    color: Colors.grey,
                                    height: 1,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: 5,
                                      right: 5,
                                      bottom: 0,
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                          text: 'Select Reasons',
                                          style: TextStyle(
                                              fontFamily:
                                                  global.fontMetropolisRegular,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: ColorConstants.pureBlack),
                                          children: [
                                            TextSpan(
                                                text: '*',
                                                style: TextStyle(
                                                    fontFamily: global
                                                        .fontMetropolisRegular,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                    color: ColorConstants
                                                        .pureBlack))
                                          ]),
                                    ),
                                  ),
                                  Container(
                                    height: height.toDouble(),
                                    child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: _cancelStatusList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Container(
                                            height: 35,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: Radio(
                                                    value:
                                                        _cancelStatusList[index]
                                                            .reason,
                                                    groupValue: selectedStatus,
                                                    activeColor:
                                                        global.indigoColor,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        print('G1--->01');
                                                        if (_cancelStatusList
                                                                .length >
                                                            0) {
                                                          for (CancelStatusListModel model
                                                              in _cancelStatusList) {
                                                            if (model.reason!
                                                                    .toLowerCase() ==
                                                                _cancelStatusList[
                                                                        index]
                                                                    .reason!
                                                                    .toLowerCase()) {
                                                              model.isStatusSelected =
                                                                  1;
                                                              selectedStatus =
                                                                  model.reason;
                                                              if (model.reason!
                                                                      .toLowerCase() ==
                                                                  'others') {
                                                                isOthersSelected =
                                                                    true;
                                                              } else {
                                                                isOthersSelected =
                                                                    false;
                                                                _cReason.text =
                                                                    "";
                                                              }
                                                              setState(() {});
                                                              break;
                                                            } else {
                                                              model.isStatusSelected =
                                                                  1;
                                                              setState(() {});
                                                            }
                                                          }
                                                          setState(() {});
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Text(
                                                  "${_cancelStatusList[index].reason}",
                                                  style: TextStyle(
                                                      fontFamily: global
                                                          .fontMetropolisRegular,
                                                      fontWeight:
                                                          FontWeight.w200,
                                                      fontSize: 14,
                                                      color: ColorConstants
                                                          .pureBlack),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Visibility(
                                    visible: isOthersSelected,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: ColorConstants.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7.0))),
                                      margin: EdgeInsets.only(
                                          top: 0, left: 20, right: 20),
                                      padding:
                                          EdgeInsets.only(top: 8, bottom: 0),
                                      child: MaterialTextField(
                                        style: TextStyle(
                                            fontFamily:
                                                global.fontMetropolisRegular,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w200,
                                            color: ColorConstants.pureBlack),
                                        theme: FilledOrOutlinedTextTheme(
                                          radius: 8,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 4, vertical: 4),
                                          errorStyle: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700),
                                          fillColor: Colors.transparent,
                                          enabledColor: Colors.grey,
                                          focusedColor: ColorConstants.appColor,
                                          floatingLabelStyle: const TextStyle(
                                              color: ColorConstants.appColor),
                                          width: 0.5,
                                          labelStyle: const TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                        controller: _cReason,
                                        labelText: "Reason",

                                        // hintText:
                                        //     "Email", //"${AppLocalizations.of(context).lbl_email}",
                                        keyboardType: TextInputType.name,
                                        onChanged: (p0) {
                                          //_cName.text = p0.toString();
                                          // if(EmailValidator.validate(_cEmail.text)){

                                          // }
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 170,
                                      child: MaterialButton(
                                        height: 40,

                                        onPressed: () {
                                          if (selectedStatus!.isEmpty) {
                                            showToast(
                                                "Please select cancel reason");
                                          } else if (selectedStatus!
                                                  .toLowerCase() ==
                                              "others") {
                                            if (_cReason.text.isEmpty) {
                                              showToast(
                                                  "Please enter cancel reason");
                                            } else {
                                              _cancelOrderDialog(_cReason.text);
                                            }
                                          } else {
                                            _cancelOrderDialog(selectedStatus!);
                                          }
                                        },
                                        color: global.bgCompletedColor,
                                        //height: 70,
                                        padding: EdgeInsets.zero,
                                        child: Text(
                                          'Cancel Order',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: global.white,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                ],
                              ),
                            )
                          : Center(
                              child: Text("Data not available"),
                            )
                      : Container(),
                ],
              ),
              new Align(
                child: loadingIndicator,
                alignment: FractionalOffset.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateUI(String card) {
    print('g1---->01');
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        print('g1---->02');
        Navigator.pop(context);
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _init();
  }

  //API call for bank list... G1
  _getCancelOrderResonsList() async {
    try {
      setState(() {
        _load = true;
      });
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        await apiHelper.getCancelOrderResons().then((result) async {
          if (result != null) {
            if (result.status == "1") {
              setState(() {
                _load = false;
              });
              _cancelStatusList = result.data;

              selectedStatus = _cancelStatusList[0].reason;
              print(result.data.toString());
            } else {
              setState(() {
                _load = false;
              });
              showToast(result.message);
            }
          } else {
            setState(() {
              _load = false;
            });
            showToast(result.message);
          }
        });
      } else {
        setState(() {
          _load = false;
        });
        showNetworkErrorSnackBar(_scaffoldKey!);
      }

      setState(() {});
    } catch (e) {
      setState(() {
        _load = false;
      });
      print("Exception - banck list.dart():" + e.toString());
    }
  }

  _init() async {
    try {
      await _getCancelOrderResonsList();
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - banklist.dart - _init():" + e.toString());
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
              itemCount: 3,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      elevation: 0,
                    ));
              })),
    );
  }

  _cancelOrderDialog(String selectedStatus1) async {
    try {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(dialogBackgroundColor: Colors.white),
              child: CupertinoAlertDialog(
                title: Text(
                  'Cancel Order',
                ),
                content: Text(
                  'Do you want to cancel this order?',
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(
                      'No',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: fontMetropolisRegular,
                          fontWeight: FontWeight.w200,
                          color: ColorConstants.appColor),
                    ),
                    onPressed: () {
                      return Navigator.of(context).pop(false);
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text('Yes',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: fontMetropolisRegular,
                            fontWeight: FontWeight.w200,
                            color: Colors.blue)),
                    onPressed: () async {
                      Navigator.pop(context);
                      cancelOrder(selectedStatus1);
                    },
                  ),
                ],
              ),
            );
          });
    } catch (e) {
      print('Exception - app_menu_screen.dart - exitAppDialog(): ' +
          e.toString());
    }
  }

  //Cancel order ...G1
  cancelOrder(String selectedStatus1) async {
    setState(() {
      showOnlyLoaderDialog();
    });
    try {
      apiHelper
          .cancelOrder(cart_id: cartId, cancel_reason: selectedStatus1)
          .then((result) async {
        print('g1---->${result.toString()}');
        if (result != null) {
          if (result.status == "1") {
            setState(() {
              print('g1---->');
              showToast(result.message);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              //sahil change
              // int count = 0;
              // Navigator.of(context).pushAndRemoveUntil(
              //   MaterialPageRoute(
              //     builder: (context) => MySubcriptionScreen(
              //         a: widget.analytics, o: widget.observer),
              //   ),
              //   (Route<dynamic> route) => false,
              // );
              // count++ == 2;
              // Get.to(() => MySubcriptionScreen(
              //       a: widget.analytics,
              //       o: widget.observer,
              //     ));
              // int count = 0;
              // Navigator.popUntil(context, (route) {
              //   setState(() {});
              //   return count++ == 2;
              // });
            });
          } else {
            setState(() {
              showToast(result.message);
            });
          }
        } else {
          setState(() {
            hideLoader();
          });

          showToast('Something went Wrong. Please try again');
        }
      });
    } catch (e) {
      print("Exception -  cancelOrder.dart - cancelOrder():" + e.toString());
    }
  }
}
