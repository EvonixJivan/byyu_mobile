import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/screens/home_screen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
  
import 'package:byyu/controllers/cart_controller.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/screens/cart_screen/cart_screen.dart';
import 'package:byyu/screens/auth/login_screen.dart';

class CartItemCountButton extends StatefulWidget {
  final dynamic analytics;
  final dynamic observer;
  final CartController? cartController;
  CartItemCountButton({this.analytics, this.observer, this.cartController})
      : super();

  @override
  _CartItemCountButtonState createState() => _CartItemCountButtonState(
      analytics: analytics, observer: observer, cartController: cartController);
}

class _CartItemCountButtonState extends State<CartItemCountButton> {
  final dynamic analytics;
  final dynamic observer;
  CartController? cartController;
  _CartItemCountButtonState(
      {this.analytics, this.observer, this.cartController});

  @override
  Widget build(BuildContext context) {
    // double totAmount=1;
    // if(cartController.cartItemsList.cartList.isNotEmpty)
    //    totAmount = global.total_delivery_count * cartController.cartItemsList.totalPrice;
    return GetBuilder<CartController>(
      init: cartController,
      builder: (value) => global.cartCount != null && global.cartCount != 0
          ? SizedBox(
              height: 50,
              width: Get.width / 1.1,
              child: ElevatedButton.icon(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(ColorConstants.appColor)),
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    color: global.white,
                  ),
                  label: Text(
                    "${global.cartCount} ITEMS IN CART",
                    style: TextStyle(
                fontFamily: global.fontMontserratMedium,
                fontWeight: FontWeight.w200,
                fontSize: 14,
                color: ColorConstants.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomeScreen(
                              a: widget.analytics,
                              o: widget.observer,
                              selectedIndex: 2,
                              screenId: 0,
                            )));
                  }),
            )
          //   ?  Container(
          //   decoration: BoxDecoration(
          //     color: global.indigoColor,
          //     borderRadius: BorderRadius.circular(8),
          //   ),
          //   height: 50,
          //   width: Get.width / 1.1,
          //   child: Row(
          //     children: <Widget>[
          //       Container( margin: EdgeInsets.only(left: 10, right: 5),
          //       child: Text('${global.cartCount} Items',
          //         style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: global.yellow),),),
          //       Container(height: 30,width: 1, margin: EdgeInsets.only(right: 5),color: global.yellow,),
          //       Container( margin: EdgeInsets.only(right: 5),
          //         child: Text('${} ${totAmount}',
          //           style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: global.yellow),),),
          //     ],
          //   ),
          // )

          : SizedBox(),
    );
  }
}
