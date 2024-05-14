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
                          margin: EdgeInsets.symmetric(horizontal: 151.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 33.h,
                            vertical: 8.v,
                          ),
                          decoration: AppDecoration.fillAmber.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder27,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 1.v),
                              Text(
                                "msg_let_s_learn_phonemes".tr.toUpperCase(),
                                style: theme.textTheme.headlineMedium,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 64.v),
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
          height: 37.adaptSize,
          width: 37.adaptSize,
          padding: EdgeInsets.all(11.h),
          decoration: IconButtonStyleHelper.gradientDeepOrangeToDeepOrangeTL18,
          child: CustomImageView(
            imagePath: ImageConstant.imgArrowDownWhiteA70001,
          ),
        ),
        CustomIconButton(
          height: 37.adaptSize,
          width: 37.adaptSize,
          padding: EdgeInsets.all(5.h),
          child: CustomImageView(
            imagePath: ImageConstant.imgHomeBtn,
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildGrid(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.h),
        child: Consumer<PhonmesListProvider>(
          builder: (context, provider, child) {
            return ListView.separated(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (
                context,
                index,
              ) {
                return SizedBox(
                  height: 1.v,
                );
              },
              itemCount: provider.phonmesListModelObj.gridItemList.length,
              itemBuilder: (context, index) {
                GridItemModel model =
                    provider.phonmesListModelObj.gridItemList[index];
                return GridItemWidget(
                  model,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
