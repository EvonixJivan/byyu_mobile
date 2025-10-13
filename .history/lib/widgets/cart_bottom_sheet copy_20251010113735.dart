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

class CartBottomSheetCopy extends StatefulWidget {
  const CartBottomSheetCopy({Key? key}) : super(key: key);

  @override
  State<CartBottomSheetCopy> createState() => _CartBottomSheetCopyState();
}

class _CartBottomSheetCopyState extends State<CartBottomSheetCopy> {
  // ✅ Dummy cart list for UI display
  final List<Map<String, dynamic>> cartItems = [
    {
      'productName': 'Product 1',
      'productImage': 'https://via.placeholder.com/150',
      'price': 120.0,
      'qty': 1
    },
    {
      'productName': 'Product 2',
      'productImage': 'https://via.placeholder.com/150',
      'price': 99.0,
      'qty': 2
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      decoration: const BoxDecoration(
        color: ColorConstants.colorPageBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          // 🛒 Header Row
          Row(
            children: [
              const Expanded(
                child: Center(
                  child: Text(
                    "My Cart",
                    style: TextStyle(
                      fontFamily: global.fontRalewayMedium,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: ColorConstants.newTextHeadingFooter,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.black54),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),

          // 🧾 Cart Items List
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: ColorConstants.colorPageBackground,
                  elevation: 0.5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 📸 Product Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            imageUrl: item['productImage'],
                            placeholder: (context, url) => const Center(
                              child:
                                  CircularProgressIndicator(strokeWidth: 1.0),
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              global.noImage,
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // 📝 Product Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Name + Remove
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item['productName'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontFamily: global.fontRalewayMedium,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            ColorConstants.newTextHeadingFooter,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        cartItems.removeAt(index);
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 18,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),

                              // ➕➖ Qty and 💰 Price
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (item['qty'] > 1) {
                                                item['qty']--;
                                              } else {
                                                cartItems.removeAt(index);
                                              }
                                            });
                                          },
                                          child: Container(
                                            width: 25,
                                            height: 25,
                                            child: Icon(
                                              item['qty'] > 1
                                                  ? Icons.remove
                                                  : Icons.delete_outline,
                                              size: 16,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "${item['qty']}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              item['qty']++;
                                            });
                                          },
                                          child: Container(
                                            width: 25,
                                            height: 25,
                                            child: const Icon(
                                              Icons.add,
                                              size: 16,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "AED ${item['price']}",
                                    style: const TextStyle(
                                      fontFamily: "outfit",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 🟤 Checkout Button (Optional)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.appColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {},
              child: const Text(
                "Proceed to Checkout",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: global.fontRalewayMedium,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
