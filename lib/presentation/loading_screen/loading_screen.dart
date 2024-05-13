import 'package:svar_new/core/app_export.dart';

import 'models/loading_model.dart';
import 'package:flutter/material.dart';

import 'provider/loading_provider.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key})
      : super(
          key: key,
        );

  @override
  LoadingScreenState createState() => LoadingScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoadingProvider(),
      child: LoadingScreen(),
    );
  }
}

class LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff00FFFF),
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Container(
          width: SizeUtils.width,
          height: SizeUtils.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                ImageConstant.imgMainInteraction,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            width: 768.h,
            padding: EdgeInsets.symmetric(vertical: 38.v),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Spacer(),
                SizedBox(
                  height: 102.v,
                  width: 454.h,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 87.h),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 47.v,
                                width: 279.h,
                                decoration: BoxDecoration(
                                  color: appTheme.whiteA70001,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(72.h),
                                  ),
                                ),
                              ),
                              SizedBox(height: 25.v),
                              Text(
                                "lbl_loading".tr,
                                style: CustomTextStyles.titleLarge21,
                              )
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 28.v,
                          width: 300.h,
                          margin: EdgeInsets.only(bottom: 27.v),
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.h,
                            vertical: 3.v,
                          ),
                          decoration: AppDecoration.fillLightGreen.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder15,
                          ),
                          child: LinearProgressIndicator(
                            borderRadius: BorderRadiusStyle.roundedBorder15,
                            color: PrimaryColors().green30001,
                            value: controller.value,
                            semanticsLabel: 'Linear progress indicator',        
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
