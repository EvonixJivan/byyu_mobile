import 'package:flutter/material.dart';
import 'package:byyu/constants/color_constants.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;

class BottomButton extends StatefulWidget {
  final Widget? child;
  final Function? onPressed;
  @required
  final bool? loadingState;
  final Color? color;
  final bool? disabledState;
  final key;

  BottomButton(
      {this.child,
      this.loadingState,
      this.disabledState,
      this.color,
      this.onPressed,
      this.key})
      : super();
  @override
  _BottomButtonState createState() => _BottomButtonState(
      child: child,
      onPressed: onPressed,
      loadingState: loadingState,
      color: color,
      disabledState: disabledState,
      key: key);
}

class _BottomButtonState extends State<BottomButton> {
  Widget? child;
  Function? onPressed;
  bool? loadingState;
  Color? color;
  bool? disabledState;
  var key;

  _BottomButtonState(
      {this.child,
      this.loadingState,
      this.disabledState,
      this.onPressed,
      this.color,
      this.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      // width: MediaQuery.of(context).size.width - 40,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              color != null ? color : ColorConstants.appColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        // onPressed: () {
        //   if (loadingState! && disabledState!) {
        //     return null;
        //   } else {
        //     onPressed!();
        //   }
        // },

        // AA---->1 uncommented code
        onPressed: () {
          onPressed!();
          // if ((loadingState! || disabledState!)) {
          //   onPressed!();
          //  }
        },

        child: !loadingState!
            ? child
            : SizedBox(
                height: 20.0,
                width: 20.0,
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                ),
              ),
        // onPressed: loadingState || disabledState ? null  :onPressed,
        // onPressed: () {
        //   loadingState! || disabledState! ? null : onPressed;
        // },
      ),
    );
  }
}
