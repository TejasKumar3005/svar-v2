import 'package:flutter/cupertino.dart';
import 'package:svar_new/widgets/grid_item_model.dart';
import 'package:svar_new/presentation/ling_learning/ling_learning_provider.dart';
import '../../../core/app_export.dart';
import 'package:provider/provider.dart'; 


class PhonmesListModel {
List<GridItemModel> gridItemList = [
  GridItemModel(widget: "क"),
  GridItemModel(widget: "ख"),
  GridItemModel(widget: "ग"),
  GridItemModel(widget: "घ"),
  GridItemModel(widget: "च"),
  GridItemModel(widget: "छ"),
  GridItemModel(widget: "ज"),
  GridItemModel(widget: "झ"),
  GridItemModel(widget: "ट"),
  GridItemModel(widget: "ठ"),
  GridItemModel(widget: "ड"),
  GridItemModel(widget: "ढ"),
  GridItemModel(widget: "ण"),
  GridItemModel(widget: "त"),
  GridItemModel(widget: "थ"),
  GridItemModel(widget: "द"),
  GridItemModel(widget: "ध"),
  GridItemModel(widget: "न"),
  GridItemModel(widget: "प"),
  GridItemModel(widget: "फ"),
  GridItemModel(widget: "ब"),
  GridItemModel(widget: "भ"),
  GridItemModel(widget: "म"),
  GridItemModel(widget: "य"),
  GridItemModel(widget: "र"),
  GridItemModel(widget: "ल"),
  GridItemModel(widget: "व"),
  GridItemModel(widget: "श"),
  GridItemModel(widget: "ष"),
  GridItemModel(widget: "स"),
  GridItemModel(widget: "ह"),
];


  void onTapCharacter(BuildContext context, String character) {
    LingLearningProvider lingLearningProvider =
        Provider.of<LingLearningProvider>(context, listen: false);
    lingLearningProvider.setSelectedCharacter(character);
  }
}
