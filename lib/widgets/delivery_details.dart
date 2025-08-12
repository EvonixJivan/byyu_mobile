import 'package:flutter/material.dart';

import 'package:byyu/models/orderModel.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;

class DeliveryDetails extends StatefulWidget {
  final Order? order;
  final String? address;
  DeliveryDetails({this.order, this.address}) : super();

  @override
  _DeliveryDetailsState createState() =>
      _DeliveryDetailsState(order: order!, address: address!);
}

class _DeliveryDetailsState extends State<DeliveryDetails> {
  Order? order;
  String? address;
  _DeliveryDetailsState({this.order, this.address});
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Color(0xffF4F4F4),
          width: 1.5,
        ),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: 32),
                SizedBox(
                  child: Text(
                    "Total weeks : ${order!.total_delivery}",
                    style: textTheme.bodyText1!.copyWith(fontSize: 13),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  color: Colors.black,
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: 250,
                  child: Text(
                    "Start Date of Delivery : ${order!.deliveryDate}",
                    maxLines: 2,
                    style: textTheme.bodyText1!.copyWith(fontSize: 13),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(width: 32),
                SizedBox(
                  width: 250,
                  child: Text(
                    "Delivery time: ${order!.timeSlot}",
                    style: textTheme.bodyText1!.copyWith(fontSize: 13),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.black,
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: 250,
                  child: Text(
                    '$address',
                    maxLines: 2,
                    style: textTheme.bodyText1!.copyWith(fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
