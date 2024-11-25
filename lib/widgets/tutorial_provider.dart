import 'package:flutter/foundation.dart';
import 'package:svar_new/widgets/tutorial_coach_mark/lib/src/target/target_focus.dart';

class TapHandlerProvider extends ChangeNotifier {
  int nextIndex = 0;

  Future<void> tapHandler({
    bool targetTap = false,
    bool overlayTap = false,
    Function? clickTarget,
    Function? clickOverlay,
    Function? revertAnimation,
    required TargetFocus targetFocus,
  }) async {
    print("tapped in provider");
    nextIndex++;

    if (targetTap && clickTarget != null) {
      await clickTarget(targetFocus);
    }
    if (overlayTap && clickOverlay != null) {
      await clickOverlay(targetFocus);
    }
    if (revertAnimation != null) {
      return revertAnimation();
    }
  }
}
