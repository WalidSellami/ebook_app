import 'package:ebook/modules/homeScreen/HomeScreen.dart';
import 'package:ebook/shared/components/Components.dart';
import 'package:ebook/shared/cubit/Cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Visibility(
          visible: isVisible,
          child: FadeTransition(
            opacity: animation,
            child: SvgPicture.asset(
              'assets/images/EBOOK_logo.svg',
              height: 250.0,
              width: 250.0,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }

  void initialize() {
    Future.delayed(const Duration(milliseconds: 700)).then((value) {
      setState(() {
        isVisible = true;
      });
    });

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    animation = Tween<double>(begin: 0, end: 1).animate(animationController);
    animationController.forward();

    Future.delayed(const Duration(milliseconds: 2500)).then((value) {
      navigateToAndNotReturn(context: context, screen: const HomeScreen());
      AppCubit.get(context).changeStatusScreen();
    });
  }
}
