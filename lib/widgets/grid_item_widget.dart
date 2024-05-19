import 'package:flutter/widgets.dart';
import 'package:svar_new/presentation/phenome_list/phonmes_list_model.dart';
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
        height: 150.v,
        width: 118.h,
        decoration: AppDecoration.outlineWhiteA700015.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder20,
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              children: [
                Text(
                  gridItemModelObj.widget!,
                  style: theme.textTheme.displayLarge!.copyWith(fontSize: 41),
                ),
                Container(
                  height: 8.v,
                  width: 45.h,
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
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: CustomImageView(
                imagePath: ImageConstant.imgShine,
                height: 23.v,
                width: 30.h,
                fit: BoxFit.contain,
                alignment: Alignment.topLeft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
