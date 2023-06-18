import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CircularLoadingAdaptive extends StatelessWidget {
  final String os;

  const CircularLoadingAdaptive({super.key, required this.os});

  @override
  Widget build(BuildContext context) {
    if (os == 'android') {
      return const CircularProgressIndicator();
    } else {
      return const CupertinoActivityIndicator();
    }
  }
}
