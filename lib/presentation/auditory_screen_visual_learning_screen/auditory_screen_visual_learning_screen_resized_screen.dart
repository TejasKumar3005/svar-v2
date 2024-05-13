
import 'package:svar_new/widgets/appbar_leading_image.dart';
import 'package:svar_new/widgets/appbar_title.dart';
import 'package:svar_new/widgets/appbar_trailing_iconbutton.dart';
import 'package:svar_new/widgets/custom_app_bar.dart';
import 'package:svar_new/widgets/custom_icon_button.dart';
import 'models/auditory_screen_visual_learning_screen_resized_model.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'provider/auditory_screen_visual_learning_screen_resized_provider.dart';

class AuditoryScreenVisualLearningScreenResizedScreen extends StatefulWidget {
const AuditoryScreenVisualLearningScreenResizedScreen({Key? key})
: super(
key: key,
);

@override
AuditoryScreenVisualLearningScreenResizedScreenState createState() =>
AuditoryScreenVisualLearningScreenResizedScreenState();

static Widget builder(BuildContext context) {
return ChangeNotifierProvider(
create: (context) => AuditoryScreenVisualLearningScreenResizedProvider(),
child: AuditoryScreenVisualLearningScreenResizedScreen(),
);
}
}

class AuditoryScreenVisualLearningScreenResizedScreenState
extends State<AuditoryScreenVisualLearningScreenResizedScreen> {
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
color: appTheme.whiteA70001,
image: DecorationImage(
image: AssetImage(
ImageConstant.imgAuditoryScreen,
),
fit: BoxFit.cover,
),
),
child: SizedBox(
width: 768.h,
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
SizedBox(height: 39.v),
_buildHomeBTN(context),
Container(
padding: EdgeInsets.symmetric(
horizontal: 36.h,
vertical: 118.v,
),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Padding(
padding: EdgeInsets.only(
top: 1.v,
bottom: 75.v,
),
child: CustomIconButton(
height: 40.adaptSize,
width: 40.adaptSize,
padding: EdgeInsets.all(3.h),
decoration:
IconButtonStyleHelper.gradientOrangeABfToOrangeE,
child: CustomImageView(
imagePath: ImageConstant.imgFullvolBtn,
),
),
),
Padding(
padding: EdgeInsets.only(bottom: 75.v),
child: CustomIconButton(
height: 40.adaptSize,
width: 40.adaptSize,
padding: EdgeInsets.all(10.h),
onTap: () {
onTapBtnArrowLeft(context);
},
child: CustomImageView(
imagePath: ImageConstant.imgArrowLeft,
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

/// Section Widget
Widget _buildHomeBTN(BuildContext context) {
return Padding(
padding: EdgeInsets.only(
left: 34.h,
right: 30.h,
),
child: Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
CustomAppBar(
leadingWidth: 71.h,
leading: AppbarLeadingImage(
imagePath: ImageConstant.imgHomeBtnWhiteA70001,
margin: EdgeInsets.only(left: 34.h),
),
centerTitle: true,
title: SizedBox(
height: 31.v,
width: 204.h,
child: Stack(
alignment: Alignment.center,
children: [
Align(
alignment: Alignment.center,
child: Container(
height: 26.v,
width: 204.h,
margin: EdgeInsets.symmetric(vertical: 2.v),
decoration: BoxDecoration(
color: appTheme.yellow90001,
borderRadius: BorderRadius.circular(
13.h,
),
),
),
),
AppbarTitle(
text: "lbl_clapping".tr.toUpperCase(),
margin: EdgeInsets.only(
left: 46.h,
right: 45.h,
),
)
],
),
),
actions: [
AppbarTrailingIconbutton(
imagePath: ImageConstant.imgHomeBtn,
margin: EdgeInsets.symmetric(horizontal: 77.h),
)
],
),
CustomIconButton(
height: 37.adaptSize,
width: 37.adaptSize,
padding: EdgeInsets.all(3.h),
child: CustomImageView(
imagePath: ImageConstant.imgFullvolBtn,
),
)
],
),
);
}

/// Navigates to the auditoryScreenAssessmentScreenAudioVisualResizedScreen when the action is triggered.
onTapBtnArrowLeft(BuildContext context) {
NavigatorService.pushNamed(
AppRoutes.auditoryScreenAssessmentScreenAudioVisualResizedScreen,
);
}
}

