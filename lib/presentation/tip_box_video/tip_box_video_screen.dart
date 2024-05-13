import 'package:svar_new/widgets/custom_icon_button.dart';
import 'models/tip_box_video_model.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'provider/tip_box_video_provider.dart';

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
return SafeArea(
child: Scaffold(
body: SizedBox(
height: 432.v,
width: 768.h,
child: Stack(
alignment: Alignment.bottomLeft,
children: [
Align(
alignment: Alignment.center,
child: Container(
padding: EdgeInsets.symmetric(
horizontal: 74.h,
vertical: 53.v,
),
decoration: AppDecoration.outlineBlack9006.copyWith(
borderRadius: BorderRadiusStyle.roundedBorder20,
),
child: Column(
mainAxisSize: MainAxisSize.min,
mainAxisAlignment: MainAxisAlignment.center,
children: [
Text(
"msg_parental_tip_box".tr,
style: CustomTextStyles.headlineLargeBlack,
),
SizedBox(height: 12.v),
CustomImageView(
imagePath: ImageConstant.imgImage86,
height: 219.v,
width: 492.h,
),
SizedBox(height: 11.v),
Container(
width: 593.h,
margin: EdgeInsets.only(left: 23.h),
child: Text(
"msg_apply_a_drop_of".tr,
maxLines: 2,
overflow: TextOverflow.ellipsis,
textAlign: TextAlign.center,
style: CustomTextStyles.titleMediumNunitoSansTeal900,
),
),
SizedBox(height: 2.v)
],
),
),
),
CustomImageView(
imagePath: ImageConstant.imgEllipse179,
height: 309.v,
width: 108.h,
alignment: Alignment.bottomLeft,
),
CustomImageView(
imagePath: ImageConstant.imgEllipse180,
height: 150.v,
width: 306.h,
alignment: Alignment.topLeft,
margin: EdgeInsets.only(left: 1.h),
),
CustomImageView(
imagePath: ImageConstant.imgEllipse182,
height: 180.v,
width: 128.h,
alignment: Alignment.topRight,
margin: EdgeInsets.only(top: 70.v),
),
_buildAppBar(context)
],
),
),
),
);
}

/// Section Widget
Widget _buildAppBar(BuildContext context) {
return Align(
alignment: Alignment.topCenter,
child: GestureDetector(
onTap: () {
onTapAppBar(context);
},
child: Padding(
padding: EdgeInsets.fromLTRB(29.h, 36.v, 24.h, 358.v),
child: Row(
mainAxisAlignment: MainAxisAlignment.center,
mainAxisSize: MainAxisSize.min,
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

