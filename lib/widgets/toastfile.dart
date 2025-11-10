import 'package:byyu/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String message){
  Fluttertoast.showToast(msg: message,gravity: ToastGravity.CENTER,textColor: Colors.white,fontSize: 12, backgroundColor: ColorConstants.newTextHeadingFooter);
}