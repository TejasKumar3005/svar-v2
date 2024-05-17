import 'package:flutter/cupertino.dart';
import 'package:svar_new/widgets/grid_item_model.dart.dart';
import 'package:svar_new/presentation/ling_learning/ling_learning_provider.dart';
import '../../../core/app_export.dart';
import 'package:provider/provider.dart'; 


class PhonmesListModel {
  List<GridItemModel> gridItemList = [
    GridItemModel(widget: "ग"),
    GridItemModel(widget: "ख"),
    GridItemModel(widget: "क"),
    GridItemModel(widget: "च"),
    GridItemModel(widget: "छ"),
    GridItemModel(widget: "ज"),
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
  ];

  void onTapCharacter(BuildContext context, String character) {
    LingLearningProvider lingLearningProvider =
        Provider.of<LingLearningProvider>(context, listen: false);
    lingLearningProvider.setSelectedCharacter(character);
  }
}
