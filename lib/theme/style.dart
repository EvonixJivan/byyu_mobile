import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:flutter/material.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;

TextStyle appBarTitleStyle(BuildContext context) =>
    Theme.of(context).textTheme.headline6!.copyWith(
          color: ColorConstants.pureBlack,
          fontWeight: FontWeight.normal,
        );

// Additional text themes
TextStyle boldCaptionStyle(BuildContext context) =>
    Theme.of(context).textTheme.caption!.copyWith(fontWeight: FontWeight.bold);

TextStyle boldSubtitle(BuildContext context) =>
    Theme.of(context).textTheme.subtitle1!.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        );

TextStyle loginButtonTextStyle(BuildContext context) =>
    Theme.of(context).textTheme.button!.copyWith(color: Colors.black);

TextStyle normalCaptionStyle(BuildContext context) =>
    Theme.of(context).textTheme.caption!.copyWith(
          color: Colors.grey,
          fontSize: 10,
        );

TextStyle normalHeadingStyle(BuildContext context) => Theme.of(context)
    .textTheme
    .headline6!
    .copyWith(fontWeight: FontWeight.normal, color: global.bgCompletedColor);

TextStyle textFieldHintStyle(BuildContext context) =>
    Theme.of(context).textTheme.caption!.copyWith(
          color: Colors.grey[600],
          fontWeight: FontWeight.normal,
          fontSize: 15,
        );

TextStyle textFieldInputStyle(BuildContext context, FontWeight fontWeight) =>
    Theme.of(context).textTheme.bodyText1!.copyWith(
          color: Colors.black,
          fontSize: 18,
          fontWeight: fontWeight ?? FontWeight.normal,
        );

TextStyle textFieldLabelStyle(BuildContext context) =>
    Theme.of(context).textTheme.caption!.copyWith(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        );

TextStyle textFieldSuffixStyle(BuildContext context) =>
    Theme.of(context).textTheme.caption!.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        );

class ThemeUtils {
  static final ThemeData defaultAppThemeData = appTheme();

  static ThemeData appTheme() {
    // Color primaryColor = Color(0xffFF0000);
    //Color primaryColor = Color(0xffFF0000);
    // Color primaryColor = Color(0xff3b006c);
    Color primaryColor = Color(0xff000000);
    Color secondryColor = Color(0xffece7b1);
    Color accentColor = Color(0xffFFFFFF);

    return ThemeData(
        useMaterial3: false,
        //primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: global.fontMetropolisRegular,
        primaryColor: primaryColor,
        // primarySwatch: MaterialColor(primary, swatch),
        colorScheme: ColorScheme.fromSwatch(accentColor: Color(0x26dc2e45)),
        hintColor: Color(0xFF999999),
        // Widget theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Color(0xffFFFFFF),
            //primary: primaryColor,

            // onPrimary: Color(0xffffde34),
            disabledForegroundColor: Color(0xff707070).withOpacity(0.38),
            disabledBackgroundColor:
                Color(0xff707070).withOpacity(0.12), // Disabled button color

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: primaryColor),
        ),
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: primaryColor),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: primaryColor,
          elevation: 5.0,
          unselectedIconTheme: IconThemeData(color: Colors.grey[600]),
        ),
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.all<Color>(primaryColor),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: primaryColor,
          textTheme: ButtonTextTheme.primary,
          shape: StadiumBorder(),
          disabledColor: Color(0xFFE5E3DC),
          height: 50,
        ),
        sliderTheme: SliderThemeData(
          thumbColor: primaryColor,
          activeTrackColor: primaryColor,
        ),
        cardColor: Colors.white,
        cardTheme: CardTheme(
          elevation: 5,
          surfaceTintColor: Colors.white,
          color: white,
        ),
        appBarTheme: AppBarTheme(
          color: ColorConstants.appBrownFaintColor,
          surfaceTintColor: white, // scroll color change issue resolve ?
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: primaryColor,
          opacity: 1.0,
        ),
        textTheme: TextTheme(
          headline5: TextStyle(
            fontWeight: FontWeight.w900,
            color: secondryColor,
          ),
          headline6: TextStyle(
            fontWeight: FontWeight.normal,
            color: secondryColor,
          ),
          subtitle1: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: primaryColor,
          ),
          subtitle2: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
          bodyText2: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          caption: TextStyle(
            fontSize: 13,
            color: Colors.black,
          ),
          bodyText1: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
          button: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            // color: Color(0xffffde34),
            fontSize: 15,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 2.0,
                color: Colors.black,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 0.7,
                color: Colors.black,
              ),
            ),
            contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
            hintStyle: TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontWeight: FontWeight.normal,
            )));
  }
}
