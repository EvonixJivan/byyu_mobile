import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart';

class IntroSliderScreen extends BaseRoute {
  IntroSliderScreen({a, o}) : super(a: a, o: o, r: 'IntroScreen');

  @override
  _IntroScreenState createState() => new _IntroScreenState();
}

class _IntroScreenState extends BaseRouteState {
  PageController _pageController = PageController();
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.colorPageBackground,
      body: Container(
        child: Stack(
          children: [
            // Image.asset(
            //   'assets/images/login_bg.png',
            //   //fit: BoxFit.cover,
            //   height: MediaQuery.of(context).size.height,
            //   width: MediaQuery.of(context).size.width,
            // ),

            Container(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  print(_pageController.initialPage);
                  pageIndex = index;
                  setState(() {});
                },
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 8, right: 8),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            sp!.setString(appLoadString, "true");
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                      a: widget.analytics,
                                      o: widget.observer,
                                      selectedIndex: 0,
                                    )));
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 40, right: 10),
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(8),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Skip..",
                                style: TextStyle(
                                    fontFamily: fontMetropolisRegular,
                                    fontWeight: FontWeight.w200,
                                    fontSize: 16,
                                    color: ColorConstants.appColor),
                              ),
                            ),
                          ),
                        ),
                        Expanded(child: Text("")),
                        Container(
                          // color: Colors.amber,
                          child: Image.asset(
                            'assets/images/intro_1.png',
                            width: MediaQuery.of(context).size.width,
                          ),
                          margin: EdgeInsets.only(bottom: 20),
                        ),
                        Container(
                          child: Text(
                            "Effortless gifting \nat your fingertips",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: fontMontserratLight,
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: ColorConstants.newTextHeadingFooter),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Effortless gifting, curated with love, delivered with a smile.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: fontRalewayMedium,
                                fontSize: 14,
                                fontWeight: FontWeight.w200,
                                color: ColorConstants.newAppColor),
                          ),
                        ),
                        Expanded(child: Text("")),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 8, right: 8),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                      a: widget.analytics,
                                      o: widget.observer,
                                      selectedIndex: 0,
                                    )));
                          },
                          child: Container(
                              margin: EdgeInsets.only(top: 40, right: 10),
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(8),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "Skip..",
                                  style: TextStyle(
                                      fontFamily: fontMetropolisRegular,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 16,
                                      color: ColorConstants.appColor),
                                ),
                              )),
                        ),
                        Expanded(child: Text("")),
                        Container(
                          child: Image.asset(
                            'assets/images/intro_2.png',
                            width: MediaQuery.of(context).size.width,
                          ),
                          margin: EdgeInsets.only(bottom: 20),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Unleash your gifting genius!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: fontRalewayMedium,
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: ColorConstants.newTextHeadingFooter),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Discover unique finds, personalize with a touch, send with ease.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: fontRalewayMedium,
                                fontSize: 14,
                                fontWeight: FontWeight.w200,
                                color: ColorConstants.newAppColor),
                          ),
                        ),
                        Expanded(child: Text("")),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 8, right: 8),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                      a: widget.analytics,
                                      o: widget.observer,
                                      selectedIndex: 0,
                                    )));
                          },
                          child: Container(
                              margin: EdgeInsets.only(top: 40, right: 10),
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(8),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "Skip..",
                                  style: TextStyle(
                                      fontFamily: fontMetropolisRegular,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 16,
                                      color: ColorConstants.appColor),
                                ),
                              )),
                        ),
                        Expanded(child: Text("")),
                        Container(
                          child: Image.asset(
                            'assets/images/intro_3.png',
                            width: MediaQuery.of(context).size.width,
                          ),
                          margin: EdgeInsets.only(bottom: 20),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Create memories that last",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: fontRalewayMedium,
                                fontSize: 20,
                                color: ColorConstants.newTextHeadingFooter),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Turn everyday moments into lasting memories with BYYU.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: fontRalewayMedium,
                                fontSize: 14,
                                fontWeight: FontWeight.w200,
                                color: ColorConstants.newAppColor),
                          ),
                        ),
                        Expanded(child: Text("")),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 8, right: 8),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                      a: widget.analytics,
                                      o: widget.observer,
                                      selectedIndex: 0,
                                    )));
                          },
                          child: Container(
                              margin: EdgeInsets.only(top: 40, right: 10),
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(8),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "Skip..",
                                  style: TextStyle(
                                      fontFamily: fontMetropolisRegular,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 16,
                                      color: ColorConstants.appColor),
                                ),
                              )),
                        ),
                        Expanded(child: Text("")),
                        Container(
                          child: Image.asset(
                            'assets/images/intro_4.png',
                            width: MediaQuery.of(context).size.width,
                          ),
                          margin: EdgeInsets.only(bottom: 20),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Say goodbye to gifting woes!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: fontMontserratLight,
                                fontSize: 20,
                                color: ColorConstants.newTextHeadingFooter),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "BYYU curates gifts as unique as they are thoughtful. Discover yours today.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: fontMetropolisRegular,
                                fontSize: 14,
                                fontWeight: FontWeight.w200,
                                color: ColorConstants.newAppColor),
                          ),
                        ),
                        Expanded(child: Text("")),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 8, right: 8),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                      a: widget.analytics,
                                      o: widget.observer,
                                      selectedIndex: 0,
                                    )));
                          },
                          child: Container(
                              margin: EdgeInsets.only(top: 40, right: 10),
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(8),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "Skip..",
                                  style: TextStyle(
                                      fontFamily: fontMetropolisRegular,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 16,
                                      color: ColorConstants.appColor),
                                ),
                              )),
                        ),
                        Expanded(child: Text("")),
                        Container(
                          child: Image.asset(
                            'assets/images/intro_5.png',
                            width: MediaQuery.of(context).size.width,
                          ),
                          margin: EdgeInsets.only(bottom: 20),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Unsure what to gift?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: fontMontserratLight,
                                fontSize: 20,
                                color: ColorConstants.newTextHeadingFooter),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Relax! BYYU guides you through gifting with ease, every step of the way.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: fontMetropolisRegular,
                                fontWeight: FontWeight.w200,
                                fontSize: 14,
                                color: ColorConstants.newAppColor),
                          ),
                        ),
                        Expanded(child: Text("")),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Expanded(child: Text("")),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(child: Text("")),
                        for (int i = 0; i < 5; i++)
                          if (i == pageIndex) ...[circleBar(true)] else
                            circleBar(false),
                        Expanded(child: Text("")),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: ColorConstants.white,
        child: InkWell(
          onTap: () {
            sp!.setString(appLoadString, "true");
            if (pageIndex < 4) {
              pageIndex = pageIndex + 1;
              _pageController.jumpToPage(pageIndex);
            } else {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HomeScreen(
                        a: widget.analytics,
                        o: widget.observer,
                        selectedIndex: 0,
                      )));
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color: ColorConstants.appColor,
                border: Border.all(color: ColorConstants.appColor, width: 0.5),
                borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(8),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: Center(
                  child: Text(pageIndex == 4 ? "GET STARTED" : "NEXT",
                      style: TextStyle(
                          fontFamily: fontMontserratMedium,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: ColorConstants.white,
                          letterSpacing: 1))),
            ),
          ),
        ),
      ),
    );
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 50),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 10 : 10,
      width: isActive ? 30 : 10,
      decoration: BoxDecoration(
          color: isActive ? ColorConstants.appColor : ColorConstants.greyDull,
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }
}
