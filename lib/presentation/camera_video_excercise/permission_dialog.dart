

import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/widgets/custom_button.dart';

OverlayEntry persmissionOverlay(BuildContext context,Function close) {
    return OverlayEntry(
      builder: (context) => Material(
        type: MaterialType.transparency,
        child: Center(
          child:PermissionDialog(context,close),
        ),
      ),
    );
  }

  Widget PermissionDialog(BuildContext context,Function close) {
    return  Container(
    width: MediaQuery.of(context).size.width * 0.5,
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
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 32.v,
                      bottom: 8.v,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "PLEASE GRANT CAMERA PERMISSION",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge,
                        ),
                        SizedBox(height: 22.v),
                      CustomButton(type: ButtonType.Next, onPressed: (){})
                      ],
                    ),
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
                  "CAMERA ACCESS DENIED",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(right: 5.h),
              child: GestureDetector(
                onTap: () {
                  close();
                },
                child: Icon(
                  Icons.close,
                  color: appTheme.whiteA70001,
                  size: 30.h,
                ),
              ),
            ),
          )
        ])
      ],
    ),
  );
  }