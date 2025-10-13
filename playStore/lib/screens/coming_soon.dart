import 'package:flutter/material.dart';
import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart';

class ComingSoon extends StatefulWidget {
  const ComingSoon({Key? key}) : super(key: key);

  @override
  State<ComingSoon> createState() => _ComingSoonState();
}

class _ComingSoonState extends State<ComingSoon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.colorPageBackground,
      body: Center(
        child: Text(
          'Gift wonders are brewing. "This feature is in progress."',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: fontMontserratLight,
              fontSize: 20,
              fontWeight: FontWeight.w200,
              color: ColorConstants.grey),
        ),
      ),
    );
  }
}
