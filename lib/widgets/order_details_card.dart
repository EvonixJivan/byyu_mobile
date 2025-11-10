import 'package:byyu/constants/color_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
  
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/categoryProductModel.dart';
import 'package:byyu/models/orderModel.dart';
import 'package:byyu/theme/style.dart';
import 'package:byyu/widgets/toastfile.dart';

import '../controllers/order_controller.dart';
import '../models/businessLayer/apiHelper.dart';
import '../screens/cart_screen/cart_screen.dart';

class OrderDetailsCard extends StatefulWidget {
  final Order order;
  final dynamic analytics;
  final dynamic observer;
  final OrderController? orderController;
  OrderDetailsCard(this.order,
      {this.analytics, this.observer, this.orderController})
      : super();

  @override
  _OrderDetailsCardState createState() =>
      _OrderDetailsCardState(order, analytics, observer, orderController!);
}

class OrderedProductsMenuItem extends StatefulWidget {
  final Product? product;

  OrderedProductsMenuItem({
    @required this.product,
  }) : super();

  @override
  _OrderedProductsMenuItemState createState() =>
      _OrderedProductsMenuItemState(product: product!);
}

class _OrderDetailsCardState extends State<OrderDetailsCard> {
  Order order;
  dynamic analytics;
  dynamic observer;
  OrderController orderController;
  APIHelper apiHelper = new APIHelper();

  _OrderDetailsCardState(
      this.order, this.analytics, this.observer, this.orderController);

  String allWordsCapitilize(String str) {
    // var str1 = str.splitMapJoin(RegExp(r'\w+'),
    //     onMatch: (m) =>
    //         '${m.group(0)}'.substring(0, 1).toUpperCase() +
    //         '${m.group(0)}'.substring(1).toLowerCase(),
    //     onNonMatch: (n) => ', ');
    // return str1;
    return str.toLowerCase().split(' ').map((word) {
      String leftText = (word.length > 1) ? word.substring(1, word.length) : '';
      return word[0].toUpperCase() + leftText;
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.only(top: 0, right: 0, left: 0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 5.0, top: 3),
                child: Text(
                  // "${AppLocalizations.of(context).lbl_items}",
                  "Items",
                  style: textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: order.productList!.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0)),
                    color: global.cardColor,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, right: 10, left: 10, bottom: 0),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              OrderedProductsMenuItem(
                                  product: order.productList![index]),
                              Spacer(),
                            ],
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: Text("Repeat Days: ",
                                      // style: textTheme.subtitle2.copyWith(
                                      //   fontWeight: FontWeight.w100, ),
                                      style: TextStyle(
                                          color: ColorConstants.newTextHeadingFooter,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w300)),
                                ),
                                Text(
                                    // order.productList[index].repeatDays,
                                    //  order.productList[index].repeatDays.splitMapJoin(RegExp(r'\w+'),onMatch: (m)=> '${m.group(0)}'.substring(0,1).toUpperCase() +'${m.group(0)}'.substring(1).toLowerCase() ,onNonMatch: (n)=> ', '),
                                    allWordsCapitilize(
                                        order.productList![index].repeatDays!),
                                    style: TextStyle(
                                        color: global.indigoColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                order.productList![index].next_delivery_date !=
                                        ''
                                    ? Padding(
                                        padding: EdgeInsets.only(left: 5.0),
                                        child: Text("Delivery Date: ",
                                            style: TextStyle(
                                                color: ColorConstants.newTextHeadingFooter,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w300)),
                                      )
                                    : Container(),
                                Text(
                                    order.productList![index]
                                        .next_delivery_date!,
                                    style: TextStyle(
                                        color: global.indigoColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                                order.productList![index].next_delivery_date !=
                                        ''
                                    ? Expanded(child: Text(''))
                                    : Container(),
                                Padding(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: Text("Order Status:",
                                      style: TextStyle(
                                          color: ColorConstants.newTextHeadingFooter,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w300)),
                                ),
                                Text(
                                    order.productList![index]
                                        .order_status_delivery!,
                                    style: TextStyle(
                                        color: global.indigoColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(0),
                            child:
                                _orderStatusNotifier(order, textTheme, index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Cart Total", //${AppLocalizations.of(context).txt_total_price}",
                    style: textTheme.titleMedium,
                  ),
                  Expanded(child: Text('')),
                  Text("${global.appInfo.currencySign} ",
                      style: TextStyle(
                          color: global.indigoColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w500)),
                  Text("${order.totalProductsMrp!.toStringAsFixed(2)}",
                      style: TextStyle(
                          color: global.indigoColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         "Discount",//${AppLocalizations.of(context).txt_discount_price}",
            //         style: textTheme.titleMedium,
            //       ),
            //       Text(
            //         order.discountonmrp != null && order.discountonmrp > 0 ? "- ${global.appInfo.currencySign} ${order.discountonmrp.toStringAsFixed(2)}" : '${global.appInfo.currencySign} ${order.discountonmrp.toStringAsFixed(2)}',
            //         style: textTheme.subtitle2,
            //       )
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         "Discounted Price",
            //         style: textTheme.titleMedium,
            //       ),
            //       Text(
            //         "${global.appInfo.currencySign} ${order.priceWithoutDelivery.toStringAsFixed(2)}",
            //         style: textTheme.subtitle2,
            //       )
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         "${AppLocalizations.of(context).txt_coupon_discount}",
            //         style: textTheme.titleMedium,
            //       ),
            //       Text(
            //         order.couponDiscount != null && order.couponDiscount > 0 ? "- ${global.appInfo.currencySign} ${order.couponDiscount.toStringAsFixed(2)}" : '${global.appInfo.currencySign} ${order.couponDiscount.toStringAsFixed(2)}',
            //         style: textTheme.subtitle2,
            //       )
            //     ],
            //   ),
            // ),

            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Delivery Fee", //${AppLocalizations.of(context).txt_delivery_charges}",
                    style: textTheme.titleMedium,
                  ),
                  // Text(
                  //   "${global.appInfo.currencySign} ${order.deliveryCharge.toStringAsFixed(2)}",
                  //   style: textTheme.subtitle2,
                  // )
                  Expanded(child: Text('')),
                  Text("${global.appInfo.currencySign} ",
                      style: TextStyle(
                          color: global.indigoColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w500)),
                  Text("${order.deliveryCharge!.toStringAsFixed(2)}",
                      style: TextStyle(
                          color: global.indigoColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         "${AppLocalizations.of(context).txt_tax}",
            //         style: textTheme.titleMedium,
            //       ),
            //       Text(
            //         "${global.appInfo.currencySign} ${order.totalTaxPrice.toStringAsFixed(2)}",
            //         style: textTheme.subtitle2,
            //       )
            //     ],
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Subscription Fee",
                    style: textTheme.titleMedium,
                  ),
                  // Text(
                  //   "${global.appInfo.currencySign} 0.00", //${(order.priceWithoutDelivery - order.couponDiscount).toStringAsFixed(2)}",
                  //   style: textTheme.subtitle2
                  //       .copyWith(color: Theme.of(context).primaryColor),
                  // )
                  Expanded(child: Text('')),
                  Text("${global.appInfo.currencySign} ",
                      style: TextStyle(
                          color: global.indigoColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w500)),
                  Text("0.00",
                      style: TextStyle(
                          color: global.indigoColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Coupon Discount",
                    style: textTheme.titleMedium,
                  ),
                  // Text(
                  //   "${global.appInfo.currencySign} ${order.couponDiscount.toStringAsFixed(2)}", //${(order.priceWithoutDelivery - order.couponDiscount).toStringAsFixed(2)}",
                  //   style: textTheme.subtitle2
                  //       .copyWith(color: Theme.of(context).primaryColor),
                  // )
                  Expanded(child: Text('')),
                  Text("${global.appInfo.currencySign} ",
                      style: TextStyle(
                          color: global.indigoColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w500)),
                  Text("${order.couponDiscount!.toStringAsFixed(2)}",
                      style: TextStyle(
                          color: global.indigoColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Order Amount",
                    style: textTheme.titleMedium,
                  ),
                  // Text(
                  //   "${global.appInfo.currencySign} ${(order.priceWithoutDelivery - order.couponDiscount).toStringAsFixed(2)}",
                  //   style: textTheme.subtitle2
                  //       .copyWith(color: Theme.of(context).primaryColor),
                  // )
                  Expanded(child: Text('')),
                  Text("${global.appInfo.currencySign} ",
                      style: TextStyle(
                          color: global.indigoColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w500)),
                  Text(
                      "${(order.priceWithoutDelivery! - order.couponDiscount!).toStringAsFixed(2)}",
                      style: TextStyle(
                          color: global.indigoColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         "${AppLocalizations.of(context).lbl_paid_by_wallet}",
            //         style: textTheme.titleMedium,
            //       ),
            //       Text(
            //         "${global.appInfo.currencySign} ${order.paidByWallet.toStringAsFixed(2)}",
            //         style: textTheme.subtitle2,
            //       )
            //     ],
            //   ),
            // ),

            // SizedBox(height: 8.0),
            // Divider(),
            // SizedBox(height: 8.0),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       "Remaining Amount\n(Paid Online/COD)",
            //       style: TextStyle(
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //     Text(
            //       //"${global.appInfo.currencySign} ${order.remPrice.toStringAsFixed(2)}",
            //       "${global.appInfo.currencySign} ${(order.priceWithoutDelivery - order.couponDiscount).toStringAsFixed(2)}",
            //       style: TextStyle(
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget _orderStatusNotifier(Order order, TextTheme textTheme, int index) {
    if (order.orderStatus == "Pending" || order.orderStatus == "Confirmed") {
      return Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 5,
                  backgroundColor: Colors.blue,
                ),
                SizedBox(width: 8),
                Text(
                  "${('${order.orderStatus}'.toUpperCase() == 'PENDING' ? 'Order Placed' : order.orderStatus)}",
                  style: TextStyle(
                fontFamily: global.fontMontserratLight,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: ColorConstants.pureBlack),
                ),
                Expanded(child: Text("")),
                order.orderStatus == "Pending" ||
                        order.orderStatus == "Confirmed"
                    ? TextButton(
                        // onPressed: () => _trackOrder(),
                        child: Text(
                          // "${AppLocalizations.of(context).tle_track_order}",
                          "Track Order",
                          style: TextStyle(
                fontFamily: global.fontMontserratLight,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: ColorConstants.pureBlack),
                        ),
                        onPressed: () {
                          if (order.is_subscription == 1) {
                            // Get.to(() => MySubcriptionDetailScreen(
                            //     a: widget.analytics,
                            //     o: widget.observer,
                            //     cardid: order.cartid,
                            //     storeOrderId:
                            //         order.productList[index].storeOrderId));
                          } else {
                            _trackOrder();
                          }
                        },
                      )
                    : SizedBox()
              ],
            ),
            // Padding(
            //   padding: const EdgeInsets.only(),
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: [
            //       // TextButton(
            //       //   onPressed: () => Get.to(() => CancelOrderScreen(
            //       //         a: widget.analytics,
            //       //         o: widget.observer,
            //       //         order: order,
            //       //         orderController: orderController,
            //       //       )),
            //       //   child: Text(
            //       //     "${AppLocalizations.of(context).tle_cancel_order}",
            //       //     style: GoogleFonts.poppins(
            //       //         fontWeight: FontWeight.w500,
            //       //         fontSize: 12,
            //       //         color: global.cardTextColor),
            //       //   ),
            //       // ),

            //     ],
            //   ),
            // ),
          ],
        ),
      );
    }
    // else if (order.orderStatus == "Out_For_Delivery") {
    //   return Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Row(
    //         children: [
    //           CircleAvatar(
    //             radius: 5,
    //             backgroundColor: Colors.green,
    //           ),
    //           SizedBox(width: 8),
    //           Text(
    //             "${AppLocalizations.of(context).lbl_out_of_delivery}",
    //             style: textTheme.titleMedium.copyWith(
    //               color: Colors.green,
    //             ),
    //           )
    //         ],
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.only(top: 8.0),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
    //           children: [
    //             TextButton(
    //               onPressed: () => _trackOrder(),
    //               child: Text(
    //                 "${AppLocalizations.of(context).tle_track_order}",
    //                 style: TextStyle(
    //                   color: Theme.of(context).primaryColor,
    //                 ),
    //               ),
    //             )
    //           ],
    //         ),
    //       ),
    //     ],
    //   );
    // } else if (order.orderStatus == "Completed") {
    //   return Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Row(
    //         children: [
    //           CircleAvatar(
    //             radius: 5,
    //             backgroundColor: Colors.purple,
    //           ),
    //           SizedBox(width: 8),
    //           Text(
    //             "${AppLocalizations.of(context).txt_completed}",
    //             style: textTheme.titleMedium.copyWith(
    //               color: Colors.purple,
    //             ),
    //           ),
    //         ],
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.only(top: 8.0),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
    //           children: [
    //             global.nearStoreModel != null
    //                 ? TextButton(
    //                     onPressed: () {
    //                       _reOrderItems();
    //                     },
    //                     child: Text(
    //                       "${AppLocalizations.of(context).btn_reorder_items}",
    //                       style: TextStyle(
    //                         color: Theme.of(context).primaryColor,
    //                       ),
    //                     ),
    //                   )
    //                 : SizedBox(),
    //             TextButton(
    //               onPressed: () => _trackOrder(),
    //               child: Text(
    //                 "${AppLocalizations.of(context).tle_track_order}",
    //                 style: TextStyle(
    //                   color: Theme.of(context).primaryColor,
    //                 ),
    //               ),
    //             )
    //           ],
    //         ),
    //       ),
    //     ],
    //   );
    // } else if (order.orderStatus == "Cancelled") {
    //   return Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Row(
    //         children: [
    //           CircleAvatar(
    //             radius: 5,
    //             backgroundColor: Colors.grey[600],
    //           ),
    //           SizedBox(width: 8),
    //           Text(
    //             "${AppLocalizations.of(context).lbl_order_cancel}",
    //             style: textTheme.titleMedium.copyWith(
    //               color: Colors.grey[600],
    //             ),
    //           )
    //         ],
    //       ),
    //       // TextButton(
    //       //   onPressed: () => _trackOrder(),
    //       //   child: Text(
    //       //     "${AppLocalizations.of(context).tle_track_order}",
    //       //     style: TextStyle(
    //       //       color: Theme.of(context).primaryColor,
    //       //     ),
    //       //   ),
    //       // )
    //     ],
    //   );
    // }
    else {
      return SizedBox();
    }
  }

 
  _trackOrder() async {
    try {
      await apiHelper.trackOrder(order.cartid!).then((result) async {
        if (result != null) {
          if (result.status == "1") {
            Order _newOrder = new Order();
            _newOrder = result.data;
            // Get.to(() => MapScreen(
            //       _newOrder,
            //       orderController,
            //       a: widget.analytics,
            //       o: widget.observer,
            //     ));
          }
        }
      });
    } catch (e) {
      print("Exception - order_history_card.dart - _trackOrder():" +
          e.toString());
    }
  }
}

class _OrderedProductsMenuItemState extends State<OrderedProductsMenuItem> {
  Product? product;

  _OrderedProductsMenuItemState({
    @required this.product,
  });
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      // height: 125 * screenHeight / 910,
      child: Card(
        color: global.cardColor,
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: product!.thumbnail != null &&
                      product!.thumbnail!.isNotEmpty &&
                      product!.thumbnail != ''
                  ? global.appInfo.imageUrl! + product!.thumbnail!
                  : global.appInfo.imageUrl! + product!.varientImage!,

              // imageUrl: global.appInfo.imageUrl + product.varientImage,
              imageBuilder: (context, imageProvider) => Container(
                // color: Color(0xffF7F7F7),
                padding: EdgeInsets.all(0),
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      // color: Color(0xffF7F7F7),
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.contain)),
                ),
              ),
              placeholder: (context, url) => SizedBox(
                  height: 60,
                  width: 60,
                  child: Center(child: CircularProgressIndicator())),
              errorWidget: (context, url, error) => Container(
                height: 60,
                width: 60,
                child: Icon(
                  Icons.image,

                  // color: Colors.grey[500],
                ),
              ),
            ),
            SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: screenWidth - 180, //width: 140,
                  child: Text(
                    '${product!.productName} ',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: textTheme.titleMedium!
                        .copyWith(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ),
                SizedBox(height: 3.0),
                SizedBox(
                  width: screenWidth - 180,
                  child: Text(
                      // product.description != null && product.description != ''
                      //     ? product.description
                      //     : product.type,
                      "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          color: ColorConstants.newTextHeadingFooter,
                          fontSize: 11,
                          fontWeight: FontWeight.w300)),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    // Text(
                    //   "${product.qty}",
                    //   style: textTheme.titleMedium.copyWith(
                    //       fontWeight: FontWeight.normal, fontSize: 11),
                    // ),
                    // Text(
                    //   ' | ',
                    //   style: TextStyle(color: Colors.grey[400]),
                    // ),
                    Text("Price: ",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: ColorConstants.newTextHeadingFooter,
                            fontSize: 11,
                            fontWeight: FontWeight.w300)),
                    Text("${global.appInfo.currencySign} ",
                        style: TextStyle(
                            color: global.indigoColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w500)),
                    Text("${product!.price!.toStringAsFixed(2)}",
                        style: TextStyle(
                            color: global.indigoColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    // SizedBox(width: 2),
                    Text(
                      ' | ',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    SizedBox(width: 1),
                    Text("Qty: ",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: ColorConstants.newTextHeadingFooter,
                            fontSize: 11,
                            fontWeight: FontWeight.w300)),
                    Text(
                      "${product!.qty}",
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium!
                          .copyWith(fontWeight: FontWeight.w200, fontSize: 15),
                    ),
                    // SizedBox(width: 5),
                    // Text(
                    //   "${product.unit}",
                    //   overflow: TextOverflow.ellipsis,
                    //   style: textTheme.titleMedium
                    //       .copyWith(fontWeight: FontWeight.w200, fontSize: 10),
                    // ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
