import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';

class ExitScreen extends StatefulWidget {
  const ExitScreen({Key? key})
      : super(
          key: key,
        );

  @override
  ExitScreenState createState() => ExitScreenState();

  static Widget builder(BuildContext context) {
    return ExitScreen();
  }
}

class ExitScreenState extends State<ExitScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.cyanA40001,
        body: SizedBox(
          height: 432.v,
          width: 768.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgBgGreen500,
                height: 431.v,
                width: 768.h,
                alignment: Alignment.center,
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 51.h,
                    vertical: 39.v,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgMascot277x222,
                        height: 277.v,
                        width: 222.h,
                        margin: EdgeInsets.only(top: 77.v),
                      ),
                      Container(
                        height: 203.v,
                        width: 394.h,
                        margin: EdgeInsets.only(
                          top: 76.v,
                          right: 6.h,
                          bottom: 74.v,
                        ),
                        child: Stack(
                          alignment: Alignment.topLeft,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 72.h,
                                  vertical: 12.v,
                                ),
                                decoration:
                                    AppDecoration.outlineWhiteA70001.copyWith(
                                  borderRadius:
                                      BorderRadiusStyle.roundedBorder36,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(height: 6.v),
                                    Container(
                                      decoration:
                                          AppDecoration.outlineErrorContainer,
                                      child: Text(
                                        "lbl_leaving".tr,
                                        style: CustomTextStyles
                                            .displaySmallNunitoWhiteA70001,
                                      ),
                                    ),
                                    SizedBox(height: 19.v),
                                    SizedBox(
                                      width: 245.h,
                                      child: Text(
                                        "msg_your_progress_will".tr,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.titleLarge,
                                      ),
                                    ),
                                    SizedBox(height: 23.v),
                                    Container(
                                      width: 221.h,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 13.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(right: 15.h),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 4.h,
                                                vertical: 3.v,
                                              ),
                                              decoration: AppDecoration
                                                  .outlineWhiteA700011
                                                  .copyWith(
                                                borderRadius: BorderRadiusStyle
                                                    .roundedBorder10,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Opacity(
                                                        opacity: 0.62,
                                                        child: CustomImageView(
                                                          imagePath: ImageConstant
                                                              .imgTelevisionWhiteA70001,
                                                          height: 7.v,
                                                          width: 65.h,
                                                          radius: BorderRadius
                                                              .circular(
                                                            3.h,
                                                          ),
                                                        ),
                                                      ),
                                                      Opacity(
                                                        opacity: 0.62,
                                                        child: CustomImageView(
                                                          imagePath: ImageConstant
                                                              .imgEllipse67WhiteA70001,
                                                          height: 5.adaptSize,
                                                          width: 5.adaptSize,
                                                          margin:
                                                              EdgeInsets.only(
                                                            left: 1.h,
                                                            bottom: 3.v,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(height: 1.v),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "lbl_cancel".tr,
                                                      style: CustomTextStyles
                                                          .titleMedium16,
                                                    ),
                                                  ),
                                                  SizedBox(height: 8.v)
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                onTapExitBTNIcnButton(context);
                                              },
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 15.h),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 4.h,
                                                  vertical: 3.v,
                                                ),
                                                decoration: AppDecoration
                                                    .outlineWhiteA700012
                                                    .copyWith(
                                                  borderRadius:
                                                      BorderRadiusStyle
                                                          .roundedBorder10,
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: 30.v,
                                                      width: 65.h,
                                                      margin: EdgeInsets.only(
                                                          bottom: 9.v),
                                                      child: Stack(
                                                        alignment:
                                                            Alignment.topCenter,
                                                        children: [
                                                          Align(
                                                            alignment: Alignment
                                                                .bottomRight,
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          4.h),
                                                              child: Text(
                                                                "lbl_exit".tr,
                                                                style: CustomTextStyles
                                                                    .titleMedium17,
                                                              ),
                                                            ),
                                                          ),
                                                          Opacity(
                                                            opacity: 0.62,
                                                            child:
                                                                CustomImageView(
                                                              imagePath:
                                                                  ImageConstant
                                                                      .imgTelevisionWhiteA70001,
                                                              height: 7.v,
                                                              width: 65.h,
                                                              radius:
                                                                  BorderRadius
                                                                      .circular(
                                                                3.h,
                                                              ),
                                                              alignment:
                                                                  Alignment
                                                                      .topCenter,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Opacity(
                                                      opacity: 0.62,
                                                      child: CustomImageView(
                                                        imagePath: ImageConstant
                                                            .imgEllipse67WhiteA70001,
                                                        height: 5.adaptSize,
                                                        width: 5.adaptSize,
                                                        margin: EdgeInsets.only(
                                                          left: 1.h,
                                                          bottom: 35.v,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
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
                            Align(
                              alignment: Alignment.topLeft,
                              child: SizedBox(
                                height: 31.v,
                                width: 43.h,
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    CustomImageView(
                                      imagePath: ImageConstant.imgHome,
                                      height: 31.v,
                                      width: 43.h,
                                      alignment: Alignment.center,
                                    ),
                                    CustomImageView(
                                      imagePath: ImageConstant.imgEllipse67,
                                      height: 10.v,
                                      width: 13.h,
                                      alignment: Alignment.bottomRight,
                                      margin: EdgeInsets.only(
                                        right: 5.h,
                                        bottom: 7.v,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            CustomImageView(
                              imagePath: ImageConstant.imgHome,
                              height: 31.v,
                              width: 43.h,
                              alignment: Alignment.topRight,
                            )
                          ],
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
    );
  }

  /// Navigates to the welcomeScreenPotraitScreen when the action is triggered.
  onTapExitBTNIcnButton(BuildContext context) {
    NavigatorService.pushNamed(
      AppRoutes.welcomeScreenPotraitScreen,
    );
  }
}
