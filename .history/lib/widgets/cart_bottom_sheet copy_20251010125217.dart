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
      'image': 'assets/images/referral_first.png',
      'price': 'AED 150',
    },
    {
      'image': 'assets/images/referral_first.png',
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
          const SizedBox(height: 10),
          // 🧾 Header Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Cart Subtotal: ",
                      style: TextStyle(
                          fontFamily: global.fontOufitMedium,
                          fontSize: 22,
                          fontWeight: FontWeight.w300,
                          color: ColorConstants.newAppColor),
                    ),
                    Text(
                      " AED 1500",
                      style: TextStyle(
                          fontFamily: global.fontOufitMedium,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: ColorConstants.newAppColor),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child:
                      const Icon(Icons.close, color: ColorConstants.pureBlack),
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
          const SizedBox(height: 35),

          // 🛍️ Add-Ons List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: addOns.map((item) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Column(
                      children: [
                        // 🟠 Image container with ClipRRect
                        Container(
                          height: 150,
                          width: 80,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            child: Image.asset(
                              item['image'], // local asset path
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // 🟤 Add to Cart button
                        SizedBox(
                          height: 24,
                          width: 70,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConstants.colorContinueShop,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0, // no shadow
                              minimumSize: const Size.fromHeight(24),
                            ),
                            onPressed: () {},
                            child: Text(
                              "Add to Cart",
                              style: TextStyle(
                                fontFamily: global.fontOufitMedium,
                                color: ColorConstants.newAppColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 5),

                        // 💰 Price text
                        Text(
                          item['price'],
                          style: TextStyle(
                            fontFamily: global.fontOufitMedium,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: ColorConstants.newAppColor,
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
                const EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 10),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // center the buttons horizontally
              children: [
                // Continue Shopping
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.colorContinueShop,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    elevation: 0, // optional: remove shadow if needed
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisSize:
                        MainAxisSize.min, // ensures button width fits content
                    children: [
                      const Icon(Icons.shopping_bag,
                          color: ColorConstants.newAppColor, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        "CONTINUE SHOPPING",
                        style: TextStyle(
                          fontFamily: global.fontOufitMedium,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: ColorConstants.newAppColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12), // spacing between buttons

                // Checkout
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.newAppColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    elevation: 0, // optional
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisSize:
                        MainAxisSize.min, // ensures button width fits content
                    children: [
                      const Icon(Icons.shopping_cart_outlined,
                          color: Colors.white, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        "CHECKOUT",
                        style: TextStyle(
                          fontFamily: global.fontOufitMedium,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
