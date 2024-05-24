import 'models/phonems_level_screen_one_model.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'provider/phonems_level_screen_one_provider.dart';

class PhonemsLevelScreenOneScreen extends StatefulWidget {
  const PhonemsLevelScreenOneScreen({Key? key})
      : super(
          key: key,
        );

  @override
  PhonemsLevelScreenOneScreenState createState() =>
      PhonemsLevelScreenOneScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PhonemsLevelScreenOneProvider(),
      child: PhonemsLevelScreenOneScreen(),
    );
  }
}

class PhonemsLevelScreenOneScreenState
    extends State<PhonemsLevelScreenOneScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Container(
          width: SizeUtils.width,
          height: SizeUtils.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.47, 0.06),
              end: Alignment(0.59, 1.61),
              colors: [
                appTheme.lightGreen400,
                appTheme.teal800,
              ],
            ),
          ),
          child: SizedBox(
            height: 432.v,
            width: 768.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 432.v,
                    width: 768.h,
                    padding: EdgeInsets.only(
                      top: 65.v,
                      right: 277.h,
                    ),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            height: 12.v,
                            width: 27.h,
                            margin: EdgeInsets.only(
                              top: 32.v,
                              right: 48.h,
                            ),
                            decoration: BoxDecoration(
                              color: appTheme.lime90001,
                            ),
                          ),
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgImage83,
                          height: 44.v,
                          width: 56.h,
                          radius: BorderRadius.circular(
                            8.h,
                          ),
                          alignment: Alignment.topRight,
                          margin: EdgeInsets.only(top: 7.v),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 16.h),
                            child: Text(
                              "lbl_6".tr,
                              style: theme.textTheme.displayMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 432.v,
                    width: 768.h,
                    padding: EdgeInsets.only(
                      left: 162.h,
                      top: 143.v,
                    ),
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            height: 12.v,
                            width: 20.h,
                            margin: EdgeInsets.only(
                              left: 53.h,
                              top: 9.v,
                            ),
                            decoration: BoxDecoration(
                              color: appTheme.lime90001,
                            ),
                          ),
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgImage83,
                          height: 44.v,
                          width: 56.h,
                          radius: BorderRadius.circular(
                            8.h,
                          ),
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(top: 5.v),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 12.h),
                            child: Text(
                              "lbl_5".tr,
                              style: theme.textTheme.displayMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 432.v,
                    width: 768.h,
                    padding: EdgeInsets.only(
                      top: 181.v,
                      right: 142.h,
                      bottom: 181.v,
                    ),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            height: 12.v,
                            width: 30.h,
                            margin: EdgeInsets.only(
                              top: 24.v,
                              right: 54.h,
                            ),
                            decoration: BoxDecoration(
                              color: appTheme.lime90001,
                            ),
                          ),
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgImage83,
                          height: 44.v,
                          width: 56.h,
                          radius: BorderRadius.circular(
                            8.h,
                          ),
                          alignment: Alignment.bottomRight,
                          margin: EdgeInsets.only(bottom: 10.v),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 17.h),
                            child: Text(
                              "lbl_4".tr,
                              style: theme.textTheme.displaySmall,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 432.v,
                    width: 768.h,
                    padding: EdgeInsets.only(
                      left: 260.h,
                      bottom: 106.v,
                    ),
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            height: 12.v,
                            width: 18.h,
                            margin: EdgeInsets.only(
                              left: 53.h,
                              bottom: 39.v,
                            ),
                            decoration: BoxDecoration(
                              color: appTheme.lime90001,
                            ),
                          ),
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgImage83,
                          height: 44.v,
                          width: 56.h,
                          radius: BorderRadius.circular(
                            8.h,
                          ),
                          alignment: Alignment.bottomLeft,
                          margin: EdgeInsets.only(bottom: 13.v),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 14.h),
                            child: Text(
                              "lbl_32".tr,
                              style: theme.textTheme.displayMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 432.v,
                    width: 768.h,
                    padding: EdgeInsets.only(
                      top: 43.v,
                      right: 175.h,
                      bottom: 43.v,
                    ),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            height: 12.v,
                            width: 28.h,
                            margin: EdgeInsets.only(
                              right: 50.h,
                              bottom: 37.v,
                            ),
                            decoration: BoxDecoration(
                              color: appTheme.lime90001,
                            ),
                          ),
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgImage83,
                          height: 44.v,
                          width: 56.h,
                          radius: BorderRadius.circular(
                            8.h,
                          ),
                          alignment: Alignment.bottomRight,
                          margin: EdgeInsets.only(bottom: 11.v),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 9.h),
                            child: Text(
                              "lbl_2".tr,
                              style: theme.textTheme.displayMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 432.v,
                    width: 768.h,
                    padding: EdgeInsets.only(left: 122.h),
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            height: 12.v,
                            width: 24.h,
                            margin: EdgeInsets.only(
                              left: 52.h,
                              bottom: 35.v,
                            ),
                            decoration: BoxDecoration(
                              color: appTheme.lime90001,
                            ),
                          ),
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgImage83,
                          height: 44.v,
                          width: 56.h,
                          radius: BorderRadius.circular(
                            8.h,
                          ),
                          alignment: Alignment.bottomLeft,
                          margin: EdgeInsets.only(bottom: 7.v),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 15.h),
                            child: Text(
                              "lbl_1".tr,
                              style: theme.textTheme.displayMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgTreesAndRocks,
                  height: 380.v,
                  width: 735.h,
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(bottom: 12.v),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgSnakePath,
                  height: 432.v,
                  width: 350.h,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 191.h),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}