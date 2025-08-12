import 'package:byyu/constants/color_constants.dart';
import 'package:flutter/material.dart';

  
import 'package:shared_preferences/shared_preferences.dart';
import 'package:byyu/models/businessLayer/baseRoute.dart';
import 'package:byyu/screens/auth/login_screen.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;

class IntroScreen extends BaseRoute {
  IntroScreen({a, o}) : super(a: a, o: o, r: 'IntroScreen');
  @override
  _IntroScreenState createState() => new _IntroScreenState();
}

class _IntroScreenState extends BaseRouteState {
  int _currentIndex = 0;
  PageController? _pageController;
  _IntroScreenState() : super();
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
          body: Stack(children: [
        Image.asset(
          'assets/images/bg_doted.png',
          height: 300,
          width: 300,
        ),
        Container(
          child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                _currentIndex = index;
                setState(() {});
              },
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Image.asset(
                        'assets/images/Byyu_vertical.png',
                        height: 280,
                      ),
                      margin: EdgeInsets.only(bottom: 20),
                    ),
                    Container(
                      height: 40,
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Over',
                              style: TextStyle(
                fontFamily: global.fontMontserratLight,
                fontWeight: FontWeight.w600,
                fontSize: 28,
                color: ColorConstants.pureBlack)),
                          Text(' 1700+ Product',
                              style: TextStyle(
                fontFamily: global.fontMontserratLight,
                fontWeight: FontWeight.w600,
                fontSize: 28,
                color: ColorConstants.pureBlack))
                        ],
                      ),
                    ),
                    Text('in One App...',
                        style: TextStyle(
                fontFamily: global.fontMontserratLight,
                fontWeight: FontWeight.w600,
                fontSize: 28,
                color: ColorConstants.pureBlack))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Image.asset(
                        'assets/images/BYYU_Logo.png',
                        height: 300,
                      ),
                      margin: EdgeInsets.only(bottom: 20),
                    ),
                    Container(
                      height: 40,
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Get',
                              style: TextStyle(
                fontFamily: global.fontMontserratLight,
                fontWeight: FontWeight.w600,
                fontSize: 28,
                color: ColorConstants.pureBlack)),
                          Text(' Live Order',
                              style: TextStyle(
                fontFamily: global.fontMontserratLight,
                fontWeight: FontWeight.w600,
                fontSize: 28,
                color: ColorConstants.pureBlack))
                        ],
                      ),
                    ),
                    Text('Tracking...',
                        style: TextStyle(
                fontFamily: global.fontMontserratLight,
                fontWeight: FontWeight.w600,
                fontSize: 28,
                color: ColorConstants.pureBlack))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Image.asset(
                        'assets/images/Byyu_vertical.png',
                        height: 300,
                      ),
                      margin: EdgeInsets.only(bottom: 20),
                    ),
                    Container(
                      height: 40,
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Get',
                              style: TextStyle(
                fontFamily: global.fontMontserratLight,
                fontWeight: FontWeight.w600,
                fontSize: 28,
                color: ColorConstants.pureBlack)),
                          Text(' Offers, Discounts',
                              style: TextStyle(
                fontFamily: global.fontMontserratLight,
                fontWeight: FontWeight.w600,
                fontSize: 28,
                color: ColorConstants.pureBlack))
                        ],
                      ),
                    ),
                    Text('& Rewards...',
                        style: TextStyle(
                fontFamily: global.fontMetropolisRegular,
                fontWeight: FontWeight.w200,
                fontSize: 28,
                color: ColorConstants.pureBlack))
                  ],
                ),
              ]),
        ),
        Column(
          children: [
            Expanded(child: Container()),
            Container(
              margin: EdgeInsets.only(top: 30, bottom: 60, left: 20),
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(right: 15, top: 20),
                      width: 120,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                for (int i = 0; i < 3; i++)
                                  if (i == _currentIndex) ...[
                                    circleBar(true)
                                  ] else
                                    circleBar(false),
                              ],
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ],
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: 15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent)),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginScreen(
                                a: widget.analytics,
                                o: widget.observer,
                              )));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Skip',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: global.skipColor,
                        letterSpacing: 2.0,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(global.bgCompletedColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                onPressed: () async {
                  if (_currentIndex < 2) {
                    _pageController!.animateToPage(_currentIndex + 1,
                        duration: Duration(seconds: 1),
                        curve: Curves.fastOutSlowIn);
                  } else {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginScreen(
                                  a: widget.analytics,
                                  o: widget.observer,
                                )));
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _currentIndex < 2 ? '   Next   ' : '   Get Started   ',
                      style: TextStyle(
                fontFamily: global.fontMontserratLight,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: ColorConstants.pureBlack),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ])),
    );
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 50),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 10 : 10,
      width: isActive ? 30 : 10,
      decoration: BoxDecoration(
          color: isActive ? global.yellow : global.whiteCircle.withOpacity(0.5),
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = new PageController(initialPage: _currentIndex);
    _pageController!.addListener(() {});
  }
}
