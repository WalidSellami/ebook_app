import 'package:ebook/modules/homeScreen/HomeScreen.dart';
import 'package:ebook/shared/components/Components.dart';
import 'package:ebook/shared/cubit/Cubit.dart';
import 'package:ebook/shared/cubit/States.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool isVisible = false;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit , AppStates>(
      listener: (context , state) {},
      builder: (context , state) {


        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Visibility(
              visible: isVisible,
              child: SvgPicture.asset(
                'assets/images/ebook.svg',
                height: 250.0,
                width: 250.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  void initialize() {

    Future.delayed(const Duration(milliseconds: 700)).then((value) {
      setState(() {
        isVisible = true;
      });
    });

    Future.delayed(const Duration(milliseconds: 2500)).then((value) {
        navigateToAndNotReturn(context: context, screen: const HomeScreen());
        AppCubit.get(context).changeStatusScreen();
      });
  }

}
