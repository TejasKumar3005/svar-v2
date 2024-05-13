import 'package:svar_new/presentation/ling_learning/ling_learning_provider.dart.dart';
import 'package:svar_new/widgets/custom_icon_button.dart';

import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';


class LingLearningScreen extends StatefulWidget {
const LingLearningScreen({Key? key})
: super(
key: key,
);

@override
LingLearningScreenState createState() => LingLearningScreenState();

static Widget builder(BuildContext context) {
return ChangeNotifierProvider(
create: (context) => LingLearningProvider(),
child: LingLearningScreen(),
);
}
}

class LingLearningScreenState extends State<LingLearningScreen> {
@override
void initState() {
super.initState();
}

@override
Widget build(BuildContext context) {
return SafeArea(
child: Scaffold(
body: SizedBox(
height: 432.v,
width: 768.h,
child: Stack(
alignment: Alignment.bottomRight,
children: [
Align(
alignment: Alignment.center,
child: Container(
padding: EdgeInsets.symmetric(
horizontal: 18.h,
vertical: 36.v,
),
decoration: BoxDecoration(
image: DecorationImage(
image: AssetImage(
ImageConstant.imgGroup7,
),
fit: BoxFit.cover,
),
),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
_buildAppBar(context),
SizedBox(height: 56.v),
Align(
alignment: Alignment.centerRight,
child: Padding(
padding: EdgeInsets.only(left: 84.h),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Padding(
padding: EdgeInsets.only(bottom: 14.v),
child: Column(
children: [
CustomImageView(
imagePath: ImageConstant.imgImage85,
height: 166.v,
width: 195.h,
),
SizedBox(height: 27.v),
GestureDetector(
onTap: () {
onTapNextBTNTextButton(context);
},
child: Container(
width: 114.h,
margin: EdgeInsets.symmetric(
horizontal: 40.h),
padding: EdgeInsets.symmetric(
horizontal: 3.h,
vertical: 1.v,
),
decoration: AppDecoration
.gradientGreenToLightgreen80001
.copyWith(
borderRadius:
BorderRadiusStyle.roundedBorder10,
),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
Align(
alignment: Alignment.centerRight,
child: Row(
mainAxisAlignment:
MainAxisAlignment.end,
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
CustomImageView(
imagePath: ImageConstant
.imgEllipse39,
height: 3.v,
width: 4.h,
margin: EdgeInsets.only(
bottom: 5.v),
),
CustomImageView(
imagePath: ImageConstant
.imgUserWhiteA700018x9,
height: 8.v,
width: 9.h,
radius:
BorderRadius.circular(
4.h,
),
)
],
),
),
SizedBox(height: 9.v),
Row(
mainAxisAlignment:
MainAxisAlignment.center,
children: [
Container(
margin: EdgeInsets.symmetric(
vertical: 1.v),
decoration: AppDecoration
.outlineBlack900,
child: Text(
"lbl_next2"
.tr
.toUpperCase(),
style: theme
.textTheme.titleMedium,
),
),
CustomImageView(
imagePath: ImageConstant
.imgArrowLeft,
height: 16.v,
width: 19.h,
margin: EdgeInsets.only(
left: 8.h),
)
],
)
],
),
),
)
],
),
),
CustomImageView(
imagePath: ImageConstant.imgLaptop,
height: 86.v,
width: 88.h,
margin: EdgeInsets.only(top: 160.v),
onTap: () {
onTapImgLaptop(context);
},
)
],
),
),
),
SizedBox(height: 19.v)
],
),
),
),
CustomImageView(
imagePath: ImageConstant.imgProtaganist1,
height: 663.v,
width: 290.h,
alignment: Alignment.bottomRight,
margin: EdgeInsets.only(right: 103.h),
)
],
),
),
),
);
}

/// Section Widget
Widget _buildAppBar(BuildContext context) {
return Padding(
padding: EdgeInsets.only(
left: 11.h,
right: 6.h,
),
child: Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
CustomIconButton(
height: 37.adaptSize,
width: 37.adaptSize,
padding: EdgeInsets.all(9.h),
decoration:
IconButtonStyleHelper.gradientDeepOrangeToDeepOrangeTL18,
onTap: () {
onTapBtnArrowDown(context);
},
child: CustomImageView(
imagePath: ImageConstant.imgArrowDownWhiteA70001,
),
),
Spacer(),
CustomIconButton(
height: 37.adaptSize,
width: 37.adaptSize,
padding: EdgeInsets.all(3.h),
child: CustomImageView(
imagePath: ImageConstant.imgHomeBtn,
),
),
Padding(
padding: EdgeInsets.only(left: 4.h),
child: CustomIconButton(
height: 37.adaptSize,
width: 37.adaptSize,
padding: EdgeInsets.all(3.h),
child: CustomImageView(
imagePath: ImageConstant.imgFullvolBtn,
),
),
)
],
),
);
}

/// Navigates to the phonemsLevelScreenTwoScreen when the action is triggered.
onTapBtnArrowDown(BuildContext context) {
NavigatorService.pushNamed(
AppRoutes.phonemsLevelScreenTwoScreen,
);
}

/// Navigates to the lingLearningQuickTipScreen when the action is triggered.
onTapNextBTNTextButton(BuildContext context) {
NavigatorService.pushNamed(
AppRoutes.lingLearningQuickTipScreen,
);
}

/// Navigates to the lingLearningQuickTipScreen when the action is triggered.
onTapImgLaptop(BuildContext context) {
NavigatorService.pushNamed(
AppRoutes.lingLearningQuickTipScreen,
);
}
}

