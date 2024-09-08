import 'package:flutter/cupertino.dart';
import 'package:svar_new/widgets/grid_item_model.dart';
import 'package:svar_new/presentation/ling_learning/ling_learning_provider.dart';
import '../../../core/app_export.dart';
import 'package:provider/provider.dart';

class PhonmesListModel {
  Map<String, String> hindiToEnglishPhonemeMap = {
    'अ': 'AH',
    'आ': 'AA',
    'इ': 'IH',
    'ई': 'IY',
    'उ': 'UH',
    'ऊ': 'UW',
    'ए': 'EY',
    'ऐ': 'AY',
    'ओ': 'OW',
    'औ': 'AW',
    'क': 'K',
    'ख': 'KH',
    'ग': 'G',
    'घ': 'GH',
    'च': 'CH',
    'छ': 'CH',
    'ज': 'JH',
    'झ': 'JH',
    'ट': 'T',
    'ठ': 'TH',
    'ड': 'D',
    'ढ': 'DH',
    'त': 'T',
    'थ': 'TH',
    'द': 'D',
    'ध': 'DH',
    'न': 'N',
    'प': 'P',
    'फ': 'F',
    'ब': 'B',
    'भ': 'BH',
    'म': 'M',
    'य': 'Y',
    'र': 'R',
    'ल': 'L',
    'व': 'V',
    'श': 'SH',
    'ष': 'SH',
    'स': 'S',
    'ह': 'HH',
    'क्ष': 'KSH',
    'त्र': 'TR',
    'ज्ञ': 'GY'
  };
  List<String> addedPhonemes = [
    "B","CH","D","DH","G","F","HH","JH","L","M","N","OW","P","R","S","SH","T","TH","V","Y"
  ];
  List<GridItemModel> gridItemList = [
    // GridItemModel(character: 'क'),
    // GridItemModel(character: 'ख'),
    GridItemModel(character: 'ग'),
    // GridItemModel(character: 'घ'),
    GridItemModel(character: 'च'),
    // GridItemModel(character: 'छ'),
    GridItemModel(character: 'ज'),
    // GridItemModel(character: 'झ'),
    GridItemModel(character: 'ट'),
    // GridItemModel(character: 'ठ'),
    GridItemModel(character: 'ड'),
    // GridItemModel(character: 'ढ'),
    // GridItemModel(character: 'ण'),
    GridItemModel(character: 'त'),
    GridItemModel(character: 'थ'),
    GridItemModel(character: 'द'),
    // GridItemModel(character: 'ध'),
    GridItemModel(character: 'न'),
    GridItemModel(character: 'प'),
    GridItemModel(character: 'फ'),
    GridItemModel(character: 'ब'),
    // GridItemModel(character: 'भ'),
    GridItemModel(character: 'म'),
    GridItemModel(character: 'य'),
    GridItemModel(character: 'र'),
    GridItemModel(character: 'ल'),
    GridItemModel(character: 'व'),
    GridItemModel(character: 'श'),
    // GridItemModel(character: 'ष'),
    GridItemModel(character: 'स'),
    GridItemModel(character: 'ह'),
  ];

  Map<String,String> tips={
  'अ': 'Have the child pinch their nose while producing the /a/ to prevent nasalization.',
    'आ': 'AA',
    'इ': 'IH',
    'ई': 'Focus on proper tongue positioning against the alveolar ridge to prevent lateralization.',
    'उ': 'UH',
    'ऊ': 'UW',
    'ए': 'EY',
    'ऐ': 'AY',
    'ओ': 'OW',
    'औ': 'AW',
    'क': 'K',
    'ख': 'KH',
    'ग': 'Ask the child to feel the back of their mouth with their tongue.Practice pushing the back of the tongue up against the soft palate.',
    'घ': 'GH',
    'च': 'Show a visual of a train and make the /ch-ch/ sound, emphasizing the initial stop. Have the child feel the burst of air on their hand when you pronounce the /ch/ sound correctly.',
    'छ': 'CH',
    'ज': 'Ask the child to elevate the front part of the tongue towards the roof of the mouth.Practice making the /j/ sound.',
    'झ': 'JH',
    'ट': 'Practice placing the tongue at the alveolar ridge, just behind the front teeth.',
    'ठ': 'TH',
    'ड': 'D',
    'ढ': 'DH',
    'त': 'T',
    'थ': 'Teach the child to place the tip of the tongue between the teeth and blow air without vibrating the vocal cords.',
    'द': 'Teach the child to place the tip of the tongue between the teeth and blow air while vibrating the vocal cords.',
    'ध': 'DH',
    'न': 'Ask the child to touch the roof of their mouth with their tongue tip while pronouncing /n/. This ensures proper tongue placement.',
    'प': 'Ask the child to press their lips together firmly before releasing the /p/ sound. This will give the burst needed.',
    'फ': 'F',
    'ब': 'B',
    'भ': 'BH',
    'म': 'Using a mirror, show the child how the lips press together. Encourage them to press their lips together firmly and say the /m/ sound.',
    'य': 'Ask the child to slide the tongue from the alveolar ridge (as in /d/) backward to the palate to produce the /y/ sound.',
    'र': 'Try to touch the tongue lightly to the roof of the mouth',
    'ल': 'L',
    'व': 'Practice producing the sound while placing a hand on the throat to feel the vibrations, emphasizing voicing.',
    'श': 'Teach the correct tongue placement for /ʃ/ sound (near the alveopalatal region).',
    'ष': 'Teach the correct tongue placement for /ʃ/ sound (near the alveopalatal region).',
    'स': 'Teach the proper tongue positioning for /s/ sound (tongue against alveolar ridge, not front teeth).Use a mirror to help individuals see and adjust their tongue placement during /s/ sound production.',
    'ह': 'HH',
    'क्ष': 'KSH',
    'त्र': 'TR',
    'ज्ञ': 'GY'
  };
  

  void onTapCharacter(BuildContext context, String character) {
    LingLearningProvider lingLearningProvider =
        Provider.of<LingLearningProvider>(context, listen: false);
    lingLearningProvider.setSelectedCharacter(character);
    lingLearningProvider.setTip(tips[character]!=null?tips[character]!:'Tips');
    print(lingLearningProvider.selectedCharacter);
  }
}
