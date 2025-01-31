import 'package:flutter/widgets.dart';

class HomeList {
  HomeList({
    this.navigateScreen,
    this.imagePath = '',
  });

  Widget? navigateScreen;
  String imagePath;

  static List<HomeList> homeList = [
    HomeList(
      imagePath: 'assets/introduction_animation/introduction_animation.png',
      //navigateScreen: IntroductionAnimationScreen(),
    ),
    HomeList(
      imagePath: 'assets/design_course/design_course.png',
      //navigateScreen: DesignCourseHomeScreen(),
    ),
  ];
}
