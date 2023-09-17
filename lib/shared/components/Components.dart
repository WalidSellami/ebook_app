import 'package:ebook/shared/adaptive/CircularRingAdaptive.dart';
import 'package:ebook/shared/components/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:hexcolor/hexcolor.dart';

navigateTo({required BuildContext context, required Widget screen}) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));

navigateToAndNotReturn(
        {required BuildContext context, required Widget screen}) =>
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => screen), (route) => false);

Route createRoute({required screen}) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeIn;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      });
}

Route createSecondRoute({required screen}) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeIn;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      });
}


enum ToastStates {success , error , warning}

void showFlutterToast({
  required String message,
  required ToastStates state,
  required BuildContext context,
}) =>
    showToast(
      message,
      context: context,
      backgroundColor: chooseToastColor(s: state),
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.bottom,
      animDuration: const Duration(milliseconds: 1500),
      duration: const Duration(seconds: 3),
      curve: Curves.elasticInOut,
      reverseCurve: Curves.linear,
    );


Color chooseToastColor({
  required ToastStates s,
  context,
}) {
  return switch (s) {
    ToastStates.success => HexColor('009b9b'),
    ToastStates.error => Colors.red,
    ToastStates.warning => Colors.amber.shade900,
  };
}



Widget errorBuilder({
  required double width,
  required double height,
}) => Container(
  height: height,
  width: width,
  decoration: BoxDecoration(
    border: Border.all(
      width: 0.5,
      color: Colors.white,
    ),
    borderRadius: BorderRadius.circular(12.0),
  ),
  child: Image.asset('assets/images/mark.jpg',
    fit: BoxFit.fill,
    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
      if(frame == null) {
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.5,
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Center(child: CircularRingAdaptive(os: getOs())),
        );
      }
      return child;
    },
  ),
);
