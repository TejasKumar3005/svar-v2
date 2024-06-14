import 'package:flutter/cupertino.dart';
import 'package:svar_new/widgets/grid_item_model.dart';
import 'package:svar_new/presentation/ling_learning/ling_learning_provider.dart';
import '../../../core/app_export.dart';
import 'package:provider/provider.dart'; 


class PhonmesListModel {
  List<GridItemModel> gridItemList = [
    GridItemModel(character: 'क'),
    GridItemModel(character: 'ख'),
    GridItemModel(character: 'ग'),
    GridItemModel(character: 'घ'),
    GridItemModel(character: 'च'),
    GridItemModel(character: 'छ'),
    GridItemModel(character: 'ज'),
    GridItemModel(character: 'झ'),
    GridItemModel(character: 'ट'),
    GridItemModel(character: 'ठ'),
    GridItemModel(character: 'ड'),
    GridItemModel(character: 'ढ'),
    GridItemModel(character: 'ण'),
    GridItemModel(character: 'त'),
    GridItemModel(character: 'थ'),
    GridItemModel(character: 'द'),
    GridItemModel(character: 'ध'),
    GridItemModel(character: 'न'),
    GridItemModel(character: 'प'),
    GridItemModel(character: 'फ'),
    GridItemModel(character: 'ब'),
    GridItemModel(character: 'भ'),
    GridItemModel(character: 'म'),
    GridItemModel(character: 'य'),
    GridItemModel(character: 'र'),
    GridItemModel(character: 'ल'),
    GridItemModel(character: 'व'),
    GridItemModel(character: 'श'),
    GridItemModel(character: 'ष'),
    GridItemModel(character: 'स'),
    GridItemModel(character: 'ह'),
  ];

  void onTapCharacter(BuildContext context, String character) {
    LingLearningProvider lingLearningProvider =
        Provider.of<LingLearningProvider>(context, listen: false);
    lingLearningProvider.setSelectedCharacter(character);
    print(lingLearningProvider.selectedCharacter);
  }
}
