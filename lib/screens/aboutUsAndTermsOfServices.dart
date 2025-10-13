import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
//import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:byyu/models/aboutUsModel.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/models/termsOfServicesModel.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;

class AboutUsAndTermsOfServiceScreen extends BaseRoute {
  final bool isPrivacyPolicy;
  AboutUsAndTermsOfServiceScreen(this.isPrivacyPolicy, {a, o})
      : super(a: a, o: o, r: 'AboutUsAndTermsOfServiceScreen');
  @override
  _AboutUsAndTermsOfServiceScreenState createState() =>
      new _AboutUsAndTermsOfServiceScreenState(this.isPrivacyPolicy);
}

class _AboutUsAndTermsOfServiceScreenState extends BaseRouteState {
  bool _isDataLoaded = false;

  GlobalKey<ScaffoldState>? _scaffoldKey;
  final bool isAboutUs;
  String? text;
  AboutUs _aboutUs = new AboutUs();
  TermsOfService _termsOfService = new TermsOfService();
  _AboutUsAndTermsOfServiceScreenState(this.isAboutUs) : super();
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: ColorConstants.appBarColorWhite,
          title: Text(
            isAboutUs
                ? "Privacy Policy" //'${AppLocalizations.of(context).tle_about_us}'
                : "Terms and Conditions",
            // '${AppLocalizations.of(context).tle_term_of_service}',
            style: TextStyle(
                color: ColorConstants.pureBlack,
                fontFamily: fontRailwayRegular,
                fontWeight: FontWeight.w200), //textTheme.titleLarge,
          ),
          centerTitle: false,
          leading: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
              
              color: ColorConstants.appColor),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: _isDataLoaded
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(7.0),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height, //- 120,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Html(
                      data: "$text",
                      style: {
                        "body": Style(
                          fontFamily: global.fontRailwayRegular,
                          fontWeight: FontWeight.normal,
                          fontSize: FontSize.medium,
                          color: Colors.black,
                        )
                        // Style(color: Theme.of(context).textTheme.bodyText1.color),
                      },
                    ),
                  ),
                )
              : _shimmerList(),
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
    _init();
  }

  _init() async {
    try {
      bool isConnected = await br!.checkConnectivity();
      if (isConnected) {
        if (isAboutUs) {
          await apiHelper.appPrivacyPolicy().then((result) async {
            if (result != null) {
              if (result.status == "1") {
                _aboutUs = result.data;
                text = _aboutUs.description!;
              }
            }
          });
        } else {
          await apiHelper.appTermsOfService().then((result) async {
            if (result != null) {
              if (result.status == "1") {
                _termsOfService = result.data;
                text = _termsOfService.description!;
              }
            }
          });
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey!);
      }
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - aboutUsAndTermsOfServiceScreen.dart - _init():" +
          e.toString());
    }
  }

  Widget _shimmerList() {
    try {
      return ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(
              top: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(7.0),
              ),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 112,
                    width: MediaQuery.of(context).size.width,
                    child: Card(),
                  ),
                  Divider(),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(
          "Exception - aboutUsAndTermsOfServiceScreen.dart - _shimmerList():" +
              e.toString());
      return SizedBox();
    }
  }
}
