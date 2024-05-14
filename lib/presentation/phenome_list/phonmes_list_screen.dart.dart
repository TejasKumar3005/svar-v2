import 'package:svar_new/presentation/phenome_list/phonmes_list_provider.dart.dart';
import 'package:svar_new/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/widgets/grid_item_model.dart.dart';
import 'package:svar_new/widgets/grid_item_widget.dart';

class PhonmesListScreen extends StatefulWidget {
  const PhonmesListScreen({Key? key})
      : super(
          key: key,
        );

  @override
  PhonmesListScreenState createState() => PhonmesListScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PhonmesListProvider(),
      child: PhonmesListScreen(),
    );
  }
}

class PhonmesListScreenState extends State<PhonmesListScreen> {
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
        body: Container(
          width: SizeUtils.width,
          height: SizeUtils.height,
          decoration: BoxDecoration(
            color: appTheme.whiteA70001,
            image: DecorationImage(
              image: AssetImage(
                ImageConstant.imgGroup358,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            width: 768.h,
            padding: EdgeInsets.symmetric(
              horizontal: 29.h,
              vertical: 35.v,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 5.v),
                Expanded(
                  child: SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      children: [
                        _buildAppBar(context),
                        SizedBox(height: 2.v),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 33.h,
                            vertical: 8.v,
                          ),
                          decoration: AppDecoration.fillAmber.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder27,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 20.h),
                              Text(
                                "msg_let_s_learn_phonemes".tr.toUpperCase(),
                                style: theme.textTheme.headlineMedium,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 70.v),
                        _buildGrid(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomIconButton(
          height: 60.adaptSize,
          width: 60.adaptSize,
          
          child: CustomImageView(
            imagePath: ImageConstant.imgBackBtn,
          ),
        ),
        CustomIconButton(
          height: 60.adaptSize,
          width: 60.adaptSize,
          child: CustomImageView(
            imagePath: ImageConstant.imgMenuBtn,
          ),
        ),
      ],
    );
  }

Widget _buildGrid(BuildContext context) {
  return Expanded(
    child: Padding(
     padding: EdgeInsets.only(top: 10),
      child: Consumer<PhonmesListProvider>(
        builder: (context, provider, child) {
          return GridView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: provider.phonmesListModelObj.gridItemList.length,
            itemBuilder: (context, index) {
              GridItemModel model =
                  provider.phonmesListModelObj.gridItemList[index];
              return Align(
                child: GridItemWidget(model),
              );
            },
          );
        },
      ),
    ),
  );
}

}
