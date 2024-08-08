import 'package:svar_new/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'provider/phonems_level_screen_two_provider.dart';

class PhonemsLevelScreenTwoScreen extends StatefulWidget {
const PhonemsLevelScreenTwoScreen({Key? key})
: super(
key: key,
);

@override
PhonemsLevelScreenTwoScreenState createState() =>
PhonemsLevelScreenTwoScreenState();
static Widget builder(BuildContext context) {
return ChangeNotifierProvider(
create: (context) => PhonemsLevelScreenTwoProvider(),
child: PhonemsLevelScreenTwoScreen(),
);
}
}

class PhonemsLevelScreenTwoScreenState
extends State<PhonemsLevelScreenTwoScreen> {
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
resizeToAvoidBottomInset: false,
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
Align(
alignment: Alignment.topRight,
child: Container(
height: 44.v,
width: 56.h,
margin: EdgeInsets.only(top: 7.v),
decoration: BoxDecoration(
color: appTheme.yellow400,
borderRadius: BorderRadius.circular(
8.h,
),
border: Border.all(
color: appTheme.black900,
width: 2.h,
),
boxShadow: [
BoxShadow(
color: appTheme.lightGreen400,
spreadRadius: 2.h,
blurRadius: 2.h,
offset: Offset(
0,
2,
),
),
],
),
),
),
Align(
alignment: Alignment.topRight,
child: Padding(
padding: EdgeInsets.only(right: 11.h),
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
top: 141.v,
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
top: 11.v,
),
decoration: BoxDecoration(
color: appTheme.lime90001,
),
),
),
Align(
alignment: Alignment.topLeft,
child: Container(
height: 44.v,
width: 56.h,
margin: EdgeInsets.only(top: 7.v),
decoration: BoxDecoration(
color: appTheme.green900,
borderRadius: BorderRadius.circular(
8.h,
),
border: Border.all(
color: appTheme.black900,
width: 2.h,
),
boxShadow: [
BoxShadow(
color: appTheme.lightGreen400,
spreadRadius: 2.h,
blurRadius: 2.h,
offset: Offset(
0,
2,
),
),
],
),
),
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
top: 184.v,
right: 142.h,
bottom: 184.v,
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
top: 21.v,
right: 54.h,
),
decoration: BoxDecoration(
color: appTheme.lime90001,
),
),
),
Align(
alignment: Alignment.bottomRight,
child: Container(
height: 44.v,
width: 56.h,
margin: EdgeInsets.only(bottom: 7.v),
decoration: BoxDecoration(
color: appTheme.tealA200,
borderRadius: BorderRadius.circular(
8.h,
),
border: Border.all(
color: appTheme.black900,
width: 2.h,
),
boxShadow: [
BoxShadow(
color: appTheme.lightGreen400,
spreadRadius: 2.h,
blurRadius: 2.h,
offset: Offset(
0,
2,
),
),
],
),
),
),
Align(
alignment: Alignment.bottomRight,
child: Padding(
padding: EdgeInsets.only(right: 16.h),
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
bottom: 108.v,
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
bottom: 37.v,
),
decoration: BoxDecoration(
color: appTheme.lime90001,
),
),
),
Align(
alignment: Alignment.bottomLeft,
child: Container(
height: 44.v,
width: 56.h,
margin: EdgeInsets.only(bottom: 11.v),
decoration: BoxDecoration(
color: appTheme.blue300,
borderRadius: BorderRadius.circular(
8.h,
),
border: Border.all(
color: appTheme.black900,
width: 2.h,
),
boxShadow: [
BoxShadow(
color: appTheme.lightGreen400,
spreadRadius: 2.h,
blurRadius: 2.h,
offset: Offset(
0,
2,
),
),
],
),
),
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
top: 45.v,
right: 175.h,
bottom: 45.v,
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
bottom: 35.v,
),
decoration: BoxDecoration(
color: appTheme.lime90001,
),
),
),
Padding(
padding: EdgeInsets.only(bottom: 9.v),
child: Selector<PhonemsLevelScreenTwoProvider,
TextEditingController?>(
selector: (
context,
provider,
) =>
provider.imageSeventyNineController,
builder:
(context, imageSeventyNineController, child) {
return CustomTextFormField(
width: 56.h,
controller: imageSeventyNineController,
textInputAction: TextInputAction.done,
alignment: Alignment.bottomRight,
);
},
),
),
Align(
alignment: Alignment.bottomRight,
child: Padding(
padding: EdgeInsets.only(right: 12.h),
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
Align(
alignment: Alignment.bottomLeft,
child: Container(
height: 44.v,
width: 56.h,
margin: EdgeInsets.only(bottom: 7.v),
decoration: BoxDecoration(
color: appTheme.red300,
borderRadius: BorderRadius.circular(
8.h,
),
border: Border.all(
color: appTheme.black900,
width: 2.h,
),
boxShadow: [
BoxShadow(
color: appTheme.lightGreen400,
spreadRadius: 2.h,
blurRadius: 2.h,
offset: Offset(
0,
2,
),
),
],
),
),
),
Align(
alignment: Alignment.bottomLeft,
child: Padding(
padding: EdgeInsets.only(left: 18.h),
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

