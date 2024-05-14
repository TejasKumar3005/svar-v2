import 'package:svar_new/widgets/grid_item_model.dart.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';

// ignore: must_be_immutable
class GridItemWidget extends StatelessWidget {
  GridItemWidget(
    this.gridItemModelObj, {
    Key? key,
  }) : super(
          key: key,
        );

  GridItemModel gridItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      margin: EdgeInsets.all(0),
      color: appTheme.deepOrange400,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: appTheme.whiteA70001,
          width: 3.h,
        ),
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      child: Container(
        height: 133.v,
        width: 118.h,
        padding: EdgeInsets.all(5.h),
        decoration: AppDecoration.outlineWhiteA700015.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder20,
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 14.v),
                child: Container(
                  height: 10.v,
                  width: 86.h,
                  decoration: BoxDecoration(
                    color: appTheme.whiteA70001,
                    borderRadius: BorderRadius.circular(
                      5.h,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      5.h,
                    ),
                    child: LinearProgressIndicator(
                      value: 0.39,
                      backgroundColor: appTheme.whiteA70001,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        appTheme.teal90001,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 11.v),
                child: Text(
                  gridItemModelObj.widget!,
                  style: theme.textTheme.displayLarge,
                ),
              ),
            ),
            CustomImageView(
              imagePath: ImageConstant.imgShineWhiteA7000123x30,
              height: 23.v,
              width: 30.h,
              alignment: Alignment.topLeft,
            ),
          ],
        ),
      ),
    );
  }
}
