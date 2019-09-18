import 'package:flutter/material.dart';

/**
 * see:
 * https://stackoverflow.com/questions/49704497/how-to-make-flutter-app-responsive-according-to-different-screen-size
 * https://medium.com/flutter-community/flutter-effectively-scale-ui-according-to-different-screen-sizes-2cb7c115ea0a
 * https://medium.com/flutter-community/developing-for-multiple-screen-sizes-and-orientations-in-flutter-fragments-in-flutter-a4c51b849434
 * https://stackoverflow.com/questions/49484549/can-we-check-the-device-to-be-smartphone-or-tablet-in-flutter
 * @author Hilfritz Camallere
 */
class DisplayElements{
  static double width = 0;
  static double height = 0;
  static double blockSize = 0;
  static double blockSizeVertical = 0;
  static double safeBlockHorizontal, safeBlockVertical = 0;
  static double safeAreaHorizontal = 0;
  static double safeAreaVertical = 0;
  static bool useMobileLayout = false;

  static void init(BuildContext context){
    var mediaQueryData = MediaQuery.of(context);
    width = mediaQueryData.size.width;
    height = mediaQueryData.size.height;
    blockSize = width / 100;
    blockSizeVertical = height / 100;

    safeAreaHorizontal = mediaQueryData.padding.left +
        mediaQueryData.padding.right;
    safeAreaHorizontal = width - safeAreaHorizontal; //this line will handle notches
    safeAreaVertical = mediaQueryData.padding.top +
        mediaQueryData.padding.bottom;
    //safeAreaVertical = height - safeAreaVertical;

    safeBlockHorizontal = (width -
        safeAreaHorizontal) / 100;
    safeBlockVertical = (height -
        safeAreaVertical) / 100;


    //check if mobile layout
    // The equivalent of the "smallestWidth" qualifier on Android.
    var shortestSide = mediaQueryData.size.shortestSide;
    // Determine if we should use mobile layout or not, 600 here is
    // a common breakpoint for a typical 7-inch tablet.
    useMobileLayout = shortestSide < 600;
    return null;
  }
}
