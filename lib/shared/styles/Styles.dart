
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData theme = ThemeData(
 useMaterial3: true,
 visualDensity: VisualDensity.adaptivePlatformDensity,
 fontFamily: 'Varela',
 scaffoldBackgroundColor: HexColor('151d24'),
 colorScheme: ColorScheme.dark(
  primary: HexColor('4bb1fe',)
 ),
 appBarTheme: AppBarTheme(
  backgroundColor:  HexColor('151d24'),
  systemOverlayStyle: SystemUiOverlayStyle(
    statusBarColor: HexColor('151d24'),
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: HexColor('151d24'),
    statusBarBrightness: Brightness.light,
  ),
   titleTextStyle: const TextStyle(
     fontFamily: 'Varela',
     fontSize: 19.0,
   ),
  ),
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
 );


// 151F28