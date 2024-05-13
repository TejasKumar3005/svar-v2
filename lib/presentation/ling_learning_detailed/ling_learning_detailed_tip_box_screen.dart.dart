import 'package:svar_new/presentation/ling_learning_detailed/ling_learning_detailed_tip_box_provider.dart.dart';
import 'package:svar_new/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';


class LingLearningDetailedTipBoxScreen extends StatefulWidget {
const LingLearningDetailedTipBoxScreen({Key? key})
: super(
key: key,
);

@override
LingLearningDetailedTipBoxScreenState createState() =>
LingLearningDetailedTipBoxScreenState();

static Widget builder(BuildContext context) {
return ChangeNotifierProvider(
create: (context) => LingLearningDetailedTipBoxProvider(),
child: LingLearningDetailedTipBoxScreen(),
);
}
}

class LingLearningDetailedTipBoxScreenState
extends State<LingLearningDetailedTipBoxScreen> {
@override
void initState() {
super.initState();
NavigatorService.pushNamed(
AppRoutes.tipBoxVideoScreen,
);
}

@override
Widget build(BuildContext context) {
return SafeArea(
child: Scaffold(
body: SizedBox(
height: 432.v,
width: 768.h,
child: Stack(
alignment: Alignment.bottomLeft,
children: [
CustomImageView(
imagePath: ImageConstant.imgGroup7,
height: 430.v,
width: 768.h,
alignment: Alignment.center,
),
CustomImageView(
imagePath: ImageConstant.imgProtaganist1,
height: 693.v,
width: 303.h,
alignment: Alignment.bottomLeft,
margin: EdgeInsets.only(left: 81.h),
),
Align(
alignment: Alignment.center,
child: Container(
padding: EdgeInsets.symmetric(
horizontal: 24.h,
vertical: 36.v,
),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
_buildAppBar(context),
SizedBox(height: 23.v),
Align(
alignment: Alignment.centerRight,
child: Container(
margin: EdgeInsets.only(
left: 356.h,
right: 18.h,
),
padding: EdgeInsets.symmetric(
horizontal: 45.h,
vertical: 15.v,
),
decoration: AppDecoration.outlineTeal.copyWith(
borderRadius: BorderRadiusStyle.roundedBorder20,
),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
Text(
"msg_parental_tip_box".tr,
style:
CustomTextStyles.titleSmallPoppinsTeal900,
),
SizedBox(height: 14.v),
Align(
alignment: Alignment.centerLeft,
child: Card(
clipBehavior: Clip.antiAlias,
elevation: 0,
shape: RoundedRectangleBorder(
side: BorderSide(
color: appTheme.lime90002,
width: 2.h,
),
borderRadius:
BorderRadiusStyle.roundedBorder1,
),
child: Container(
height: 126.v,
width: 238.h,
decoration:
AppDecoration.outlineLime.copyWith(
borderRadius:
BorderRadiusStyle.roundedBorder1,
),
child: Stack(
alignment: Alignment.topRight,
children: [
CustomImageView(
imagePath: ImageConstant.imgMouth1,
height: 126.v,
width: 238.h,
radius: BorderRadius.circular(
1.h,
),
alignment: Alignment.center,
),
Align(
alignment: Alignment.topRight,
child: Container(
height: 88.v,
width: 96.h,
margin: EdgeInsets.only(
top: 11.v,
right: 56.h,
),
child: Stack(
alignment: Alignment.topRight,
children: [
Align(
alignment: Alignment.topRight,
child: Container(
height: 6.v,
width: 13.h,
margin: EdgeInsets.only(
top: 20.v,
right: 30.h,
),
decoration: BoxDecoration(
color: appTheme
.deepOrangeA70001,
borderRadius:
BorderRadius.circular(
6.h,
),
),
),
),
CustomImageView(
imagePath: ImageConstant
.imgCheckmark,
height: 17.v,
width: 31.h,
alignment: Alignment.topRight,
),
CustomIconButton(
height: 74.adaptSize,
width: 74.adaptSize,
padding: EdgeInsets.all(15.h),
decoration:
IconButtonStyleHelper
.outlineTeal,
alignment:
Alignment.bottomLeft,
onTap: () {
onTapBtnUser(context);
},
child: CustomImageView(
imagePath: ImageConstant
.imgUserWhiteA7000174x74,
),
)
],
),
),
)
],
),
),
),
),
SizedBox(height: 16.v),
SizedBox(
width: 245.h,
child: Text(
"msg_apply_a_drop_of".tr,
maxLines: 4,
overflow: TextOverflow.ellipsis,
textAlign: TextAlign.center,
style: CustomTextStyles
.labelLargeNunitoSansGray5002,
),
),
SizedBox(height: 6.v)
],
),
),
),
SizedBox(height: 10.v)
],
),
),
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
padding: EdgeInsets.only(left: 4.h),
child: Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
CustomIconButton(
height: 37.adaptSize,
width: 37.adaptSize,
padding: EdgeInsets.all(9.h),
decoration:
IconButtonStyleHelper.gradientDeepOrangeToDeepOrangeTL18,
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

/// Navigates to the tipBoxVideoScreen when the action is triggered.
onTapBtnUser(BuildContext context) {
NavigatorService.pushNamed(
AppRoutes.tipBoxVideoScreen,
);
}
}

