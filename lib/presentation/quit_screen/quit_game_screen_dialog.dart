import 'package:flutter/services.dart';
// import 'package:flutter_svg_provider/flutter_svg_provider.dart' as fs;
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
// ignore_for_file: must_be_immutable

void showQuitDialog(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: QuitDialog(context),
          elevation: 0,
          backgroundColor: Colors.transparent,
        );
      });
}

Widget QuitDialog(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.6,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                SizedBox(
                  height: 35.v,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 11.h,
                    vertical: 6.v,
                  ),
                  decoration: AppDecoration.outlineWhiteA70001.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder27,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        height: 187.v,
                        width: 132.h,
                        margin: EdgeInsets.only(top: 13.v),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgMascot136x118,
                              height: 136.v,
                              fit: BoxFit.contain,
                              width: 118.h,
                              alignment: Alignment.bottomLeft,
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                margin: EdgeInsets.only(left: 35.h),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 23.h,
                                  vertical: 12.v,
                                ),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      ImageConstant.imgThoughtCloud,
                                    ),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 55.h,
                                      child: Text(
                                        "lbl_don_t_leave".tr,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: CustomTextStyles
                                            .titleSmallTeal90001,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.v,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 32.v,
                          bottom: 8.v,
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10.v),
                              padding: EdgeInsets.symmetric(
                                horizontal: 19.h,
                                vertical: 14.v,
                              ),
                              decoration:
                                  AppDecoration.outlineWhiteA700013.copyWith(
                                borderRadius: BorderRadiusStyle.roundedBorder5,
                              ),
                              child: SizedBox(
                                width: 121.h,
                                child: Text(
                                  "msg_do_you_really_want_to".tr,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.titleLarge,
                                ),
                              ),
                            ),
                            SizedBox(height: 22.v),
                            SizedBox(
                            
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 5.h),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 5.h,
                                          vertical: 4.v,
                                        ),
                                        decoration: AppDecoration
                                            .outlineWhiteA700011
                                            .copyWith(
                                          borderRadius:
                                              BorderRadiusStyle.roundedBorder10,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Opacity(
                                              opacity: 0.62,
                                              child: CustomImageView(
                                                imagePath: ImageConstant
                                                    .imgExitBtnShine,
                                                height: 9.v,
                                                width: 76.h,
                                                radius: BorderRadius.circular(
                                                  4.h,
                                                ),
                                                margin:
                                                    EdgeInsets.only(top: 1.v),
                                              ),
                                            ),
                                            SizedBox(height: 1.v),
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "lbl_cancel".tr,
                                                style: CustomTextStyles
                                                    .titleMedium17,
                                              ),
                                            ),
                                            SizedBox(height: 10.v)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.h,
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        // ParentalControlIntegration
                                        //         .checkParentalControlPIN("1234")
                                        //     .then((value) => {if(value){
                                        //       Navigator.of(context).pop()
                                        //     }});
                                        SystemNavigator.pop();
                                        // FirebaseAuth.instance
                                        //     .signOut()
                                        //     .then((value) => {
                                        //           Navigator.of(context)
                                        //               .pushNamedAndRemoveUntil(
                                        //                   AppRoutes
                                        //                       .registerFormScreenPotratitV1ChildScreen,
                                        //                   (route) => false)
                                        //         });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 5.h),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 5.h,
                                          vertical: 4.v,
                                        ),
                                        decoration: AppDecoration
                                            .outlineWhiteA700012
                                            .copyWith(
                                          borderRadius:
                                              BorderRadiusStyle.roundedBorder10,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Opacity(
                                              opacity: 0.62,
                                              child: CustomImageView(
                                                imagePath: ImageConstant
                                                    .imgExitBtnShine,
                                                height: 9.v,
                                                width: 76.h,
                                                radius: BorderRadius.circular(
                                                  4.h,
                                                ),
                                                margin:
                                                    EdgeInsets.only(top: 1.v),
                                              ),
                                            ),
                                            SizedBox(height: 1.v),
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "lbl_exit".tr,
                                                style: CustomTextStyles
                                                    .titleMedium19,
                                              ),
                                            ),
                                            SizedBox(height: 10.v)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 19.h,
                vertical: 14.v,
              ),
              decoration: AppDecoration.outlineWhiteA700013.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder36,
                  border: Border.all(width: 5.h, color: appTheme.whiteA70001)),
              child: SizedBox(
                child: Text(
                  "msg_quit_game".tr,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ),
          )
        ])
      ],
    ),
  );
}
