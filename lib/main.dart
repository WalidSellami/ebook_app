import 'package:ebook/modules/splashScreen/SplashScreen.dart';
import 'package:ebook/shared/cubit/Cubit.dart';
import 'package:ebook/shared/network/DioHelper.dart';
import 'package:ebook/shared/styles/Styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppCubit()..checkConnection(context),),
      ],
      child: OverlaySupport.global(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'EBooK App',
          theme: theme,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
