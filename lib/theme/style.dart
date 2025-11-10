import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart';
import 'package:flutter/material.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;

TextStyle appBarTitleStyle(BuildContext context) =>
    Theme.of(context).textTheme.titleLarge!.copyWith(
          color: ColorConstants.pureBlack,
          fontWeight: FontWeight.normal,
        );

// Additional text themes
TextStyle boldbodySmallStyle(BuildContext context) =>
    Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold);

TextStyle boldSubtitle(BuildContext context) =>
    Theme.of(context).textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.bold,
          color: ColorConstants.newTextHeadingFooter,
        );

TextStyle loginButtonTextStyle(BuildContext context) =>
    Theme.of(context).textTheme.labelLarge!.copyWith(color: ColorConstants.newTextHeadingFooter);

TextStyle normalbodySmallStyle(BuildContext context) =>
    Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Colors.grey,
          fontSize: 10,
        );

TextStyle normalHeadingStyle(BuildContext context) => Theme.of(context)
    .textTheme
    .titleLarge!
    .copyWith(fontWeight: FontWeight.normal, color: global.bgCompletedColor);

TextStyle textFieldHintStyle(BuildContext context) =>
    Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Colors.grey[600],
          fontWeight: FontWeight.normal,
          fontSize: 15,
        );

TextStyle textFieldInputStyle(BuildContext context, FontWeight fontWeight) =>
    Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: ColorConstants.newTextHeadingFooter,
          fontSize: 18,
          fontWeight: fontWeight ?? FontWeight.normal,
        );

TextStyle textFieldLabelStyle(BuildContext context) =>
    Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        );

TextStyle textFieldSuffixStyle(BuildContext context) =>
    Theme.of(context).textTheme.bodySmall!.copyWith(
          fontWeight: FontWeight.bold,
          color: ColorConstants.newTextHeadingFooter,
        );

class ThemeUtils {
  static final ThemeData defaultAppThemeData = appTheme();

  static ThemeData appTheme() {
    // Color primaryColor = Color(0xffFF0000);
    //Color primaryColor = Color(0xffFF0000);
    // Color primaryColor = Color(0xff3b006c);
    Color primaryColor = Color(0xff000000);
    Color secondryColor = Color(0xffFFFFFF);
    Color accentColor = Color(0xffFFFFFF);

    return ThemeData(
        useMaterial3: false,
        //primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: global.fontRailwayRegular,
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
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: ColorConstants.newAppColor, // <-- Change this to your desired color
          circularTrackColor: Colors.grey.shade300, // optional track color
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: primaryColor),
        ),
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: primaryColor),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
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
        cardTheme: CardThemeData(
          elevation: 5,
          surfaceTintColor: Colors.white,
          color: white,
        ),
        appBarTheme: AppBarTheme(
          color: ColorConstants.appBrownFaintColor,
          surfaceTintColor: white, // scroll color change issue resolve ?
          elevation: 0,
          iconTheme: IconThemeData(color: ColorConstants.newTextHeadingFooter),
        ),
        iconTheme: IconThemeData(
          color: primaryColor,
          opacity: 1.0,
        ),
        textTheme: TextTheme(
          headlineSmall: TextStyle(
            fontWeight: FontWeight.w900,
            color: secondryColor,
          ),
          titleLarge: TextStyle(
            fontWeight: FontWeight.normal,
            color: secondryColor,
          ),
          titleMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: primaryColor,
          ),
          titleSmall: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          bodySmall: TextStyle(
            fontSize: 13,
            color: ColorConstants.newTextHeadingFooter,
          ),
          bodyLarge: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
          labelLarge: TextStyle(
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
                color: ColorConstants.newTextHeadingFooter,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 0.7,
                color: ColorConstants.newTextHeadingFooter,
              ),
            ),
            contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
            hintStyle: TextStyle(
              fontSize: 13,
              color: ColorConstants.newTextHeadingFooter,
              fontWeight: FontWeight.normal,
            )));
  }
}
