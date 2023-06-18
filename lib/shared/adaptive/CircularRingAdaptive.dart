import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';

class CircularRingAdaptive extends StatelessWidget {
  final String os;

  const CircularRingAdaptive({super.key, required this.os});

  @override
  Widget build(BuildContext context) {
    if (os == 'android') {
      return SpinKitRing(
        size: 30.0,
        lineWidth: 3.0,
        color: HexColor(
          '0098db',
        ),
      );
    } else {
      return SpinKitFadingCircle(
        color: HexColor(
          '0098db',
        ),
        size: 30.0,
      );
    }
  }
}
