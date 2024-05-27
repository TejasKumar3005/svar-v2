import 'package:svar_new/presentation/ling_sound_assessment/ling_sound_assessment_provider.dart.dart';
import 'package:svar_new/widgets/auditoryAppbar.dart';
import 'package:svar_new/widgets/custom_icon_button.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as fs;
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/widgets/game_stats_header.dart';
import 'package:svar_new/widgets/custom_button.dart';

class LingSoundAssessmentScreen extends StatefulWidget {
  const LingSoundAssessmentScreen({Key? key})
      : super(
          key: key,
        );

  @override
  LingSoundAssessmentScreenState createState() =>
      LingSoundAssessmentScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LingSoundAssessmentProvider(),
      child: LingSoundAssessmentScreen(),
    );
  }
}

class LingSoundAssessmentScreenState extends State<LingSoundAssessmentScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.blueGray50,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 5.v),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(ImageConstant.imgBg10), fit: BoxFit.cover)),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 7.v),
              AuditoryAppBar(context),
              SizedBox(height: 32.v),
              Container(
                width: MediaQuery.of(context).size.width - 30.h,
                height: 75.v,
                padding: EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
                decoration: AppDecoration.outlineBlack
                    .copyWith(borderRadius: BorderRadiusStyle.roundedBorder10),
                child: Row(
                  children: [
                    CustomButton(
                        type: ButtonType.ImagePlay,
                        onPressed: () {
                          
                        }),
                    Spacer(),
                    CustomImageView(
                      height: 70.v,
                      fit: BoxFit.fill,
                      width: (MediaQuery.of(context).size.width - 130.h),
                      imagePath: "assets/images/audio_spectrum.png",
                    )
                  ],
                ),
              ),
              SizedBox(height: 23.v),
              _buildOptnOne(context),
              SizedBox(height: 27.v),
              _buildNavigationBtn(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildOptnOne(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 100.v,
          decoration: AppDecoration.outlineBlack.copyWith(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/images/radial_ray_blue.png",
                  ),
                  fit: BoxFit.cover),
              borderRadius: BorderRadiusStyle.roundedBorder10),
          child: Image(
              image: AssetImage("assets/images/clap_vector.png"),
              fit: BoxFit.cover),
        ),
        Container(
          height: 100.v,
          decoration: AppDecoration.outlineBlack.copyWith(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/images/radial_ray_blue.png",
                  ),
                  fit: BoxFit.cover),
              borderRadius: BorderRadiusStyle.roundedBorder10),
          child: Image(
              image: AssetImage("assets/images/img_opt_2_1.png"),
              fit: BoxFit.fitWidth),
        ),
        Container(
          height: 100.v,
          decoration: AppDecoration.outlineBlack.copyWith(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/images/radial_ray_blue.png",
                  ),
                  fit: BoxFit.cover),
              borderRadius: BorderRadiusStyle.roundedBorder10),
          child: Image(
              image: AssetImage("assets/images/girlspeaking.png"),
              fit: BoxFit.cover),
        ),
        Container(
          height: 100.v,
          decoration: AppDecoration.outlineBlack.copyWith(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/images/radial_ray_blue.png",
                  ),
                  fit: BoxFit.cover),
              borderRadius: BorderRadiusStyle.roundedBorder10),
          child: Image(
              image: AssetImage("assets/images/bus.png"),
              fit: BoxFit.cover),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildNavigationBtn(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomButton(
            type: ButtonType.ArrowLeftYellow,
            onPressed: () {
              
            }),
        CustomButton(
            type: ButtonType.ArrowRightGreen,
            onPressed: () {
             
            })
      ],
    );
  }
}
