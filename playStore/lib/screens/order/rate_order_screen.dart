import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/models/orderDetailsModel.dart';
import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;

import 'package:byyu/screens/home_screen.dart';
import 'package:material_text_fields/material_text_fields.dart';
import 'package:material_text_fields/theme/material_text_field_theme.dart';

class RateOrderScreen extends BaseRoute {
  final OrderDetails order;
  final int index;
  RateOrderScreen(this.order, this.index, {a, o})
      : super(a: a, o: o, r: 'RateOrderScreen');
  @override
  _RateOrderScreenState createState() =>
      new _RateOrderScreenState(this.order, this.index);
}

class _RateOrderScreenState extends BaseRouteState {
  OrderDetails order;
  int index;
  var _cComment = new TextEditingController();
  double _userRating = 0;
  var _fComment = new FocusNode();
  GlobalKey<ScaffoldState>? _scaffoldKey;

  _RateOrderScreenState(this.order, this.index) : super();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstants.colorPageBackground,
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: ColorConstants.appBarColorWhite,
          centerTitle: false,
          title: Text(
            // "${AppLocalizations.of(context).btn_rate_order}",
            "Rate Product",
            style: TextStyle(
                fontFamily: fontRailwayRegular,
                color: ColorConstants.pureBlack), //textTheme.titleLarge,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        // '${AppLocalizations.of(context).lbl_order_id}',
                        "Order ID",
                        style: TextStyle(
                            fontFamily: fontRailwayRegular,
                            fontWeight: FontWeight.normal,
                            color: ColorConstants.pureBlack,
                            fontSize: 14,
                            letterSpacing: 1),
                      ),
                      Text(
                        '${order.cartId}',
                        style: TextStyle(
                            fontFamily: fontRailwayRegular,
                            fontWeight: FontWeight.normal,
                            color: ColorConstants.pureBlack,
                            fontSize: 14,
                            letterSpacing: 1),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        // '${AppLocalizations.of(context).lbl_number_of_items}',
                        "Number of  Items",
                        style: TextStyle(
                            fontFamily: fontRailwayRegular,
                            fontWeight: FontWeight.normal,
                            color: ColorConstants.pureBlack,
                            fontSize: 14,
                            letterSpacing: 1),
                      ),
                      Text(
                        '1',
                        style: TextStyle(
                            fontFamily: fontRailwayRegular,
                            fontWeight: FontWeight.normal,
                            color: ColorConstants.pureBlack,
                            fontSize: 14,
                            letterSpacing: 1),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        // '${AppLocalizations.of(context).lbl_delivered_on}',
                        "Delivered on",
                        style: TextStyle(
                            fontFamily: fontRailwayRegular,
                            fontWeight: FontWeight.normal,
                            color: ColorConstants.pureBlack,
                            fontSize: 14,
                            letterSpacing: 1),
                      ),
                      Text(
                        '${order.deliveryDate}',
                        style: TextStyle(
                            fontFamily: fontRailwayRegular,
                            fontWeight: FontWeight.normal,
                            color: ColorConstants.pureBlack,
                            fontSize: 14,
                            letterSpacing: 1),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        // '${AppLocalizations.of(context).lbl_total_amount}',
                        "Total Amount",
                        style: TextStyle(
                            fontFamily: fontRailwayRegular,
                            fontWeight: FontWeight.normal,
                            color: ColorConstants.pureBlack,
                            fontSize: 14,
                            letterSpacing: 1),
                      ),
                      Text(
                        '${order.totalProductsMrp} AED',
                        style: TextStyle(
                            fontFamily: fontRailwayRegular,
                            fontWeight: FontWeight.normal,
                            color: ColorConstants.pureBlack,
                            fontSize: 14,
                            letterSpacing: 1),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  color: Color(0xFFCCD6DF),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  // "${AppLocalizations.of(context).lbl_rate_overall_exp}",
                  "Rate Overall Experience",
                  style: TextStyle(
                      fontFamily: fontRailwayRegular,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.pureBlack,
                      fontSize: 14,
                      letterSpacing: 1),
                ),
                SizedBox(
                  height: 10,
                ),
                RatingBar.builder(
                  initialRating: order.product!.userRating != null
                      ? double.parse(order.product!.userRating.toString())
                          .toDouble()
                      : 0,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 25,
                  itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: ColorConstants.StarRating,
                  ),
                  updateOnDrag: false,
                  onRatingUpdate: (rating) {
                    _userRating = rating;
                    setState(() {});
                  },
                  tapOnlyMode: true,
                ),
                SizedBox(
                  height: 30,
                ),
                Divider(
                  color: Color(0xFFCCD6DF),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                      // border: Border.all(width: 0.0),

                      borderRadius: BorderRadius.circular(7)),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: MaterialTextField(
                    style: TextStyle(
                        fontFamily: global.fontRailwayRegular,
                        fontSize: 16,
                        fontWeight: FontWeight.w200,
                        color: ColorConstants.pureBlack),
                    theme: FilledOrOutlinedTextTheme(
                      radius: 8,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 4),
                      errorStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700),
                      fillColor: Colors.transparent,
                      enabledColor: Colors.grey,
                      focusedColor: ColorConstants.appColor,
                      floatingLabelStyle:
                          const TextStyle(color: ColorConstants.appColor),
                      width: 0.5,
                      labelStyle:
                          const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    controller: _cComment,

                    labelText: "Your Comment",

                    // hintText:
                    //     "Email", //"${AppLocalizations.of(context).lbl_email}",
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      //_cEmail.text = value.toString();
                      // if(EmailValidator.validate(_cEmail.text)){

                      // }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: InkWell(
          onTap: () {
            _submitRating();
          },
          child: Container(
            margin: EdgeInsets.only(top: 8, left: 20, right: 20, bottom: 10),
            padding: EdgeInsets.all(12),
            height: 40,
            width: MediaQuery.of(context).size.width - 40,
            decoration: BoxDecoration(
                color: ColorConstants.appColor,
                border: Border.all(color: ColorConstants.appColor, width: 0.5),
                borderRadius: BorderRadius.circular(10)),
            child: Text(
              "ADD RATING",
              textAlign: TextAlign.center,
              // "${AppLocalizations.of(context).tle_add_new_address} ",
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
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print("this is the rate screen order ${order.product.toString()}");
    // _cComment =
    //     TextEditingController(text: order.productList[index].ratingDescription);
    // _userRating = order.productList[index].userRating.toDouble();
  }

  _submitRating() async {
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        if (_userRating != null &&
            _userRating > 0 &&
            _cComment.text.trim().isNotEmpty) {
          showOnlyLoaderDialog();
          await apiHelper
              .addProductRating(
                  order.product!.varientId!, _userRating, _cComment.text.trim())
              .then((result) async {
            if (result != null) {
              if (result.status == "1") {
                hideLoader();
                showSnackBar(
                    key: _scaffoldKey, snackBarMessage: result.message);
                Future.delayed(Duration(seconds: 2), () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(
                        a: widget.analytics,
                        o: widget.observer,
                        selectedIndex: 0,
                      ),
                    ),
                  );
                });
              } else {
                hideLoader();
                showSnackBar(
                  key: _scaffoldKey,
                  snackBarMessage:
                      // '${AppLocalizations.of(context).txt_something_went_wrong}'
                      "Something went wrong",
                );
              }
            }
          });
        } else if (_userRating == 0) {
          showSnackBar(
            key: _scaffoldKey,
            snackBarMessage:
                // '${AppLocalizations.of(context).txt_please_give_ratings}'
                "Please give rating",
          );
        } else if (_cComment.text.isEmpty) {
          showSnackBar(
            key: _scaffoldKey,
            snackBarMessage:
                // '${AppLocalizations.of(context).txt_enter_description}'
                "Please enter description.",
          );
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey!);
      }
    } catch (e) {
      print("Exception - rate_order_screen.dart - _submitRating():" +
          e.toString());
    }
  }
}
