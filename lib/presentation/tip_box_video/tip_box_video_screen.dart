import 'dart:html';

import 'package:svar_new/database/userController.dart';
import 'package:svar_new/presentation/ling_learning/ling_learning_provider.dart';
import 'package:svar_new/providers/userDataProvider.dart';
import 'package:svar_new/widgets/custom_icon_button.dart';
import 'models/tip_box_video_model.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'provider/tip_box_video_provider.dart';
import 'package:svar_new/widgets/custom_button.dart';

class TipBoxVideoScreen extends StatefulWidget {
  const TipBoxVideoScreen({Key? key})
      : super(
          key: key,
        );

  @override
  TipBoxVideoScreenState createState() => TipBoxVideoScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TipBoxVideoProvider(),
      child: TipBoxVideoScreen(),
    );
  }
}

class TipBoxVideoScreenState extends State<TipBoxVideoScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userprovider = context.watch<UserDataProvider>();
    print(userprovider.parentaltips);
    var levelprovider = context.watch<LingLearningProvider>();
    print(levelprovider.selectedCharacter);
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/tip_vdo.png"),
                fit: BoxFit.fill),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildAppBar(context),
              Text(
                "msg_parental_tip_box".tr,
                style: CustomTextStyles.headlineLargeBlack,
              ),
              SizedBox(height: 12.v),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 30.h, vertical: 10.v),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                
                Image(
                  image: NetworkImage(
                    userprovider.parentaltips[levelprovider.selectedCharacter] !=
                            null
                        ? userprovider
                                .parentaltips[levelprovider.selectedCharacter]
                            ["image"]
                        : "",
                  ),
                  height: 219.v,
                  width: MediaQuery.of(context).size.width * 0.45,
                  fit: BoxFit.contain,
                ),
                Container(
                  height: 219.v,
                  width:  MediaQuery.of(context).size.width * 0.45,
                  child: Text(
                    userprovider.parentaltips[levelprovider.selectedCharacter] !=
                            null
                        ? userprovider
                            .parentaltips[levelprovider.selectedCharacter]["tips"]
                        : "tips",
                  
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: CustomTextStyles.titleMediumNunitoSansTeal900,
                  ),
                ),
                ],),
              ),
              SizedBox(height: 2.v)
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildAppBar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapAppBar(context);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.v),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 1.h),
              child: CustomButton(
                  type: ButtonType.Back,
                  onPressed: () {
                    NavigatorService.pushNamed(AppRoutes.lingLearningScreen);
                  }),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(left: 1.h),
              child: CustomButton(type: ButtonType.Replay, onPressed: () {}),
            ),
            SizedBox(width: 5),
            Padding(
              padding: EdgeInsets.only(left: 1.h),
              child:
                  CustomButton(type: ButtonType.FullVolume, onPressed: () {}),
            )
          ],
        ),
      ),
    );
  }

  /// Navigates to the lingLearningDetailedTipBoxScreen when the action is triggered.
  onTapAppBar(BuildContext context) {
    NavigatorService.pushNamed(
      AppRoutes.lingLearningDetailedTipBoxScreen,
    );
  }
}
