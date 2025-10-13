import 'dart:math';

import 'package:byyu/constants/analytics_GA4.dart';
import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/apiHelper.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:byyu/models/cartModel.dart';
import 'package:byyu/models/varientModel.dart';
import 'package:byyu/screens/product/product_description_screen.dart';
import 'package:byyu/widgets/cart_menu.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/couponsModel.dart';

import 'package:intl/intl.dart';

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

class CartBottomSheetCopy extends StatefulWidget {
  const CartBottomSheetCopy({Key? key}) : super(key: key);
  @override
  State<CartBottomSheetCopy> createState() => _CartBottomSheetCopyState();
}

class _CartBottomSheetCopyState extends State<CartBottomSheetCopy> {
  final List<Map<String, dynamic>> addOns = [
    {
      'image': 'assets/images/iv_gift_box',
      'price': 'AED 150',
    },
    {
      'image': 'assets/images/iv_gift_box.png',
      'price': 'AED 180',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🧾 Header Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Cart Subtotal:",
                  style: TextStyle(
                      fontFamily: global.fontOufitMedium,
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: ColorConstants.newAppColor),
                ),
                Text(
                  " AED 1500",
                  style: TextStyle(
                      fontFamily: global.fontOufitMedium,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: ColorConstants.newAppColor),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close,
                      color: ColorConstants.newAppColor),
                ),
              ],
            ),
          ),

          // Divider

          const SizedBox(height: 10),

          // 🧺 Add-Ons Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Add-Ons",
                style: TextStyle(
                    fontFamily: global.fontOufitMedium,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: ColorConstants.newAppColor),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            height: 1,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 12),

          // 🛍️ Add-Ons List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: addOns.map((item) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(15)),
                          child: Image.asset(
                            item['image'],
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 32, // decreased button height
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  ColorConstants.colorPageBackground,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              "Add to Cart",
                              style: TextStyle(
                                fontFamily: global.fontOufitMedium,
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item['price'],
                          style: TextStyle(
                            fontFamily: global.fontOufitMedium,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const Spacer(),

          // 🟤 Bottom Buttons
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
            child: Row(
              children: [
                // Continue Shopping
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF7B97D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "CONTINUE SHOPPING",
                      style: TextStyle(
                        fontFamily: global.fontOufitMedium,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Checkout
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B3E2E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.shopping_cart_outlined,
                            color: Colors.white, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          "CHECKOUT",
                          style: TextStyle(
                            fontFamily: global.fontOufitMedium,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
