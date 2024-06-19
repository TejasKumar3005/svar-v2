import 'package:auto_size_text/auto_size_text.dart';
import 'package:svar_new/widgets/grid_item_model.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';

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
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Container(
        decoration: AppDecoration.outlineWhiteA700015.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder10,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double fontSize = constraints.maxWidth * 0.5;
            double progressHeight = constraints.maxHeight * 0.1;
            double progressWidth = constraints.maxWidth * 0.8;
            double gapHeight = constraints.maxHeight * 0.05; // Dynamic gap

            return Stack(
              alignment: Alignment.topCenter,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: AutoSizeText(
                        gridItemModelObj.character,
                        style: theme.textTheme.bodyLarge!.copyWith(
                          fontSize: fontSize, 
                          color: appTheme.whiteA70001,
                        ),
                        maxLines: 1,
                        minFontSize: 8,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: gapHeight), // Dynamic gap
                    Container(
                      height: progressHeight,
                      width: progressWidth,
                      decoration: BoxDecoration(
                        color: appTheme.whiteA70001,
                        borderRadius: BorderRadius.circular(
                          progressHeight * 0.5,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          progressHeight * 0.5,
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
                    height: constraints.maxHeight * 0.20,
                    width: constraints.maxWidth * 0.25,
                    fit: BoxFit.contain,
                    alignment: Alignment.topLeft,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
