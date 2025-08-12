import 'package:byyu/constants/color_constants.dart';
import 'package:flutter/material.dart';

import 'package:byyu/controllers/order_controller.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/orderModel.dart';

import 'package:byyu/widgets/delivery_details.dart';
import 'package:byyu/widgets/order_details_card.dart';
import 'package:byyu/widgets/order_status_card.dart';

import 'package:byyu/models/businessLayer/global.dart' as global;

class OrderSummaryScreen extends BaseRoute {
  final Order? order;
  final OrderController? orderController;
  OrderSummaryScreen({a, o, this.order, this.orderController})
      : super(a: a, o: o, r: 'OrderSummaryScreen');
  @override
  _OrderSummaryScreenState createState() =>
      _OrderSummaryScreenState(order: order, orderController: orderController);
}

class _OrderSummaryScreenState extends BaseRouteState {
  Order? order;
  int? screenId;
  bool? isOrderCancelled = true;
  OrderController? orderController;
  GlobalKey<ScaffoldState>? _scaffoldKey;
  _OrderSummaryScreenState({this.order, this.orderController});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: ColorConstants.appBrownFaintColor,
        centerTitle: true,
        title: Text(
          // "${AppLocalizations.of(context).tle_order_summary}",
          "Order Summary",
          style: Theme.of(context).textTheme.headline6, //textTheme.headline6,
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: global.bgCompletedColor,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: SingleChildScrollView(
          child: Column(
            children: [
              OrderStatusCard(order!),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                child: OrderDetailsCard(
                  order!,
                  analytics: widget.analytics,
                  observer: widget.observer,
                ),
              ),
              DeliveryDetails(
                order: order!,
                address: order!.deliveryAddress!,
              ),
              SizedBox(width: 32),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (order!.orderStatus == "Cancelled") {
      isOrderCancelled = false;
    }
  }
}
