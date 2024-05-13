import 'package:svar_new/presentation/ling_sound_assessment_screen_correct/ling_sound_assessment_screen_correct_response_provider.dart.dart';
import 'package:svar_new/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';


class LingSoundAssessmentScreenCorrectResponseScreen extends StatefulWidget {
const LingSoundAssessmentScreenCorrectResponseScreen({Key? key})
: super(
key: key,
);

@override
LingSoundAssessmentScreenCorrectResponseScreenState createState() =>
LingSoundAssessmentScreenCorrectResponseScreenState();
static Widget builder(BuildContext context) {
return ChangeNotifierProvider(
create: (context) => LingSoundAssessmentScreenCorrectResponseProvider(),
child: LingSoundAssessmentScreenCorrectResponseScreen(),
);
}
}

class LingSoundAssessmentScreenCorrectResponseScreenState
extends State<LingSoundAssessmentScreenCorrectResponseScreen> {
@override
void initState() {
super.initState();
}

@override
Widget build(BuildContext context) {
return SafeArea(
child: Scaffold(
backgroundColor: appTheme.blueGray50,
body: SizedBox(
height: 432.v,
width: 768.h,
child: Stack(
alignment: Alignment.center,
children: [
Align(
alignment: Alignment.center,
child: Container(
width: 768.h,
margin: EdgeInsets.symmetric(vertical: 1.v),
padding: EdgeInsets.symmetric(
horizontal: 149.h,
vertical: 34.v,
),
decoration: BoxDecoration(
image: DecorationImage(
image: AssetImage(
ImageConstant.imgBg10,
),
fit: BoxFit.cover,
),
),
child: Row(
mainAxisAlignment: MainAxisAlignment.end,
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Container(
height: 38.v,
width: 64.h,
margin: EdgeInsets.only(bottom: 321.v),
child: Stack(
alignment: Alignment.centerLeft,
children: [
Align(
alignment: Alignment.centerRight,
child: Container(
margin: EdgeInsets.only(left: 18.h),
padding: EdgeInsets.symmetric(
horizontal: 4.h,
vertical: 3.v,
),
decoration:
AppDecoration.fillOrange30002.copyWith(
borderRadius:
BorderRadiusStyle.roundedBorder5,
),
child: Container(
width: 38.h,
padding:
EdgeInsets.symmetric(horizontal: 6.h),
decoration:
AppDecoration.fillYellow90002.copyWith(
borderRadius:
BorderRadiusStyle.roundedBorder5,
),
child: Column(
mainAxisSize: MainAxisSize.min,
crossAxisAlignment: CrossAxisAlignment.end,
mainAxisAlignment: MainAxisAlignment.center,
children: [
SizedBox(height: 1.v),
Text(
"lbl_0_16".tr,
style: theme.textTheme.labelSmall,
),
],
),
),
),
),
CustomImageView(
imagePath: ImageConstant.imgStar103,
height: 38.adaptSize,
width: 38.adaptSize,
radius: BorderRadius.circular(
1.h,
),
alignment: Alignment.centerLeft,
),
],
),
),
Container(
height: 37.v,
width: 125.h,
margin: EdgeInsets.only(
left: 10.h,
bottom: 321.v,
),
child: Stack(
alignment: Alignment.centerLeft,
children: [
Padding(
padding: EdgeInsets.only(
left: 18.h,
top: 8.v,
bottom: 8.v,
),
child: _buildTenThousand(
context,
tenThousand: "lbl_0_10000".tr,
text: "lbl2".tr,
),
),
CustomImageView(
imagePath: ImageConstant.imgCandy37x37,
height: 37.adaptSize,
width: 37.adaptSize,
radius: BorderRadius.circular(
18.h,
),
alignment: Alignment.centerLeft,
),
],
),
),
],
),
),
),
Align(
alignment: Alignment.center,
child: Container(
padding: EdgeInsets.symmetric(
horizontal: 44.h,
vertical: 31.v,
),
decoration: BoxDecoration(
image: DecorationImage(
image: AssetImage(
ImageConstant.imgGroup281,
),
fit: BoxFit.cover,
),
),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
SizedBox(height: 8.v),
_buildAppBar(context),
SizedBox(height: 38.v),
Container(
margin: EdgeInsets.symmetric(horizontal: 176.h),
decoration: AppDecoration.outlineBlack.copyWith(
borderRadius: BorderRadiusStyle.roundedBorder15,
),
child: Column(
mainAxisSize: MainAxisSize.min,
mainAxisAlignment: MainAxisAlignment.center,
children: [
SizedBox(height: 1.v),
Container(
height: 197.v,
width: 320.h,
decoration: BoxDecoration(
borderRadius: BorderRadiusStyle.roundedBorder15,
),
child: CustomImageView(
imagePath: ImageConstant.imgGroupBlue200,
height: 197.v,
width: 320.h,
radius: BorderRadius.circular(
16.h,
),
alignment: Alignment.center,
),
),
],
),
),
SizedBox(height: 32.v),
Container(
padding: EdgeInsets.symmetric(
horizontal: 2.h,
vertical: 1.v,
),
decoration: AppDecoration.gradientGreenToLightgreen80001
.copyWith(
borderRadius: BorderRadiusStyle.roundedBorder10,
),
child: Row(
mainAxisAlignment: MainAxisAlignment.end,
crossAxisAlignment: CrossAxisAlignment.start,
mainAxisSize: MainAxisSize.min,
children: [
Padding(
padding: EdgeInsets.only(
left: 13.h,
bottom: 11.v,
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
CustomImageView(
imagePath:
ImageConstant.imgEllipse39WhiteA70001,
height: 3.v,
width: 4.h,
alignment: Alignment.centerRight,
),
SizedBox(height: 5.v),
Container(
width: 76.h,
margin: EdgeInsets.only(right: 2.h),
child: Row(
mainAxisAlignment:
MainAxisAlignment.spaceBetween,
children: [
Container(
margin: EdgeInsets.only(
top: 2.v,
bottom: 1.v,
),
decoration:
AppDecoration.outlineBlack900,
child: Text(
"lbl_next2".tr.toUpperCase(),
style: theme.textTheme.titleMedium,
),
),
CustomImageView(
imagePath: ImageConstant
.imgUserWhiteA7000119x18,
height: 19.v,
width: 18.h,
),
],
),
),
],
),
),
CustomImageView(
imagePath: ImageConstant.imgUserWhiteA7000110x9,
height: 10.v,
width: 9.h,
radius: BorderRadius.circular(
4.h,
),
margin: EdgeInsets.only(bottom: 31.v),
),
],
),
),
],
),
),
),
],
),
),
),
);
}

/// Section Widget
Widget _buildAppBar(BuildContext context) {
return Padding(
padding: EdgeInsets.only(right: 1.h),
child: Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Padding(
padding: EdgeInsets.only(top: 1.v),
child: CustomIconButton(
height: 37.adaptSize,
width: 37.adaptSize,
padding: EdgeInsets.all(9.h),
decoration:
IconButtonStyleHelper.gradientDeepOrangeToDeepOrangeTL18,
child: CustomImageView(
imagePath: ImageConstant.imgArrowDownWhiteA7000137x37,
),
),
),
Spacer(),
SizedBox(
height: 38.v,
width: 63.h,
child: Stack(
alignment: Alignment.centerLeft,
children: [
Align(
alignment: Alignment.centerRight,
child: Container(
margin: EdgeInsets.only(left: 18.h),
padding: EdgeInsets.symmetric(
horizontal: 3.h,
vertical: 2.v,
),
decoration: AppDecoration.fillOrange30002.copyWith(
borderRadius: BorderRadiusStyle.roundedBorder5,
),
child: Container(
width: 37.h,
padding: EdgeInsets.symmetric(horizontal: 6.h),
decoration: AppDecoration.fillYellow90002.copyWith(
borderRadius: BorderRadiusStyle.roundedBorder5,
),
child: Column(
mainAxisSize: MainAxisSize.min,
crossAxisAlignment: CrossAxisAlignment.end,
mainAxisAlignment: MainAxisAlignment.center,
children: [
SizedBox(height: 1.v),
Text(
"lbl_0_16".tr,
style: theme.textTheme.labelSmall,
),
],
),
),
),
),
CustomImageView(
imagePath: ImageConstant.imgStar104,
height: 38.adaptSize,
width: 38.adaptSize,
radius: BorderRadius.circular(
1.h,
),
alignment: Alignment.centerLeft,
),
],
),
),
Container(
height: 36.v,
width: 125.h,
margin: EdgeInsets.only(
left: 9.h,
top: 1.v,
),
child: Stack(
alignment: Alignment.centerLeft,
children: [
Padding(
padding: EdgeInsets.only(
left: 18.h,
top: 8.v,
bottom: 8.v,
),
child: _buildTenThousand(
context,
tenThousand: "lbl_0_10000".tr,
text: "lbl2".tr,
),
),
CustomImageView(
imagePath: ImageConstant.imgCandy36x36,
height: 36.adaptSize,
width: 36.adaptSize,
radius: BorderRadius.circular(
18.h,
),
alignment: Alignment.centerLeft,
),
],
),
),
Padding(
padding: EdgeInsets.only(
left: 22.h,
top: 1.v,
),
child: CustomIconButton(
height: 37.adaptSize,
width: 37.adaptSize,
padding: EdgeInsets.all(3.h),
child: CustomImageView(
imagePath: ImageConstant.imgSettingsWhiteA70001,
),
),
),
Padding(
padding: EdgeInsets.only(
left: 8.h,
top: 1.v,
),
child: CustomIconButton(
height: 37.adaptSize,
width: 37.adaptSize,
padding: EdgeInsets.all(3.h),
child: CustomImageView(
imagePath: ImageConstant.imgSoundBtn,
),
),
),
],
),
);
}

/// Common widget
Widget _buildTenThousand(
BuildContext context, {
required String tenThousand,
required String text,
}) {
return Container(
padding: EdgeInsets.symmetric(
horizontal: 2.h,
vertical: 1.v,
),
decoration: AppDecoration.fillPink.copyWith(
borderRadius: BorderRadiusStyle.roundedBorder5,
),
child: Row(
mainAxisAlignment: MainAxisAlignment.end,
children: [
Container(
margin: EdgeInsets.only(bottom: 1.v),
padding: EdgeInsets.symmetric(horizontal: 21.h),
decoration: AppDecoration.fillPink30001.copyWith(
borderRadius: BorderRadiusStyle.roundedBorder5,
),
child: Column(
mainAxisSize: MainAxisSize.min,
crossAxisAlignment: CrossAxisAlignment.end,
mainAxisAlignment: MainAxisAlignment.center,
children: [
SizedBox(height: 1.v),
Text(
tenThousand,
style: theme.textTheme.labelSmall!.copyWith(
color: appTheme.whiteA70001,
),
),
],
),
),
Padding(
padding: EdgeInsets.only(
left: 4.h,
bottom: 1.v,
),
child: Text(
text,
style: theme.textTheme.labelMedium!.copyWith(
color: appTheme.whiteA70001,
),
),
),
],
),
);
}
}

