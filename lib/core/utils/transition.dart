import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:svar_new/presentation/main_interaction_screen/main_interaction_screen.dart';
import 'package:svar_new/routes/app_routes.dart';

class RivePageRoute extends PageRouteBuilder {
  final String routeName;
  final dynamic arguments;
  final String riveFileName;

  RivePageRoute({required this.routeName, this.arguments, required this.riveFileName})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) {
            var builder = AppRoutes.routes[routeName];
            return builder != null ? builder(context) : MainInteractionScreen();
          },
          transitionDuration: Duration(seconds: 1),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return Stack(
              children: <Widget>[
                child,
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      // Only show the Rive animation when the animation is not yet completed.
                      return animation.isCompleted ? SizedBox() : RiveAnimationTransition(
                        animation: animation,
                        riveFileName: riveFileName,
                      );
                    },
                  ),
                ),
              ],
            );
          },
);
}

// class RiveAnimationTransition extends StatelessWidget {
//   final Animation<double> animation;
//   final String riveFileName;

//   RiveAnimationTransition({required this.animation, required this.riveFileName});

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: animation,
//       builder: (context, child) => Opacity(
//         opacity: 1.0, // - animation.value,
//         child: RiveAnimation.asset(
//           riveFileName,
//           fit: BoxFit.cover,
//           // animations: ['Transition'],
//         ),
//       ),
//     );
//   }
// }

class RiveAnimationTransition extends StatefulWidget {
  final Animation<double> animation;
  final String riveFileName;

  RiveAnimationTransition({required this.animation, required this.riveFileName});

  @override
  _RiveAnimationTransitionState createState() => _RiveAnimationTransitionState();
}

class _RiveAnimationTransitionState extends State<RiveAnimationTransition> {
  late RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = OneShotAnimation('Timeline 1', autoplay: false);
    widget.animation.addStatusListener(_animationStatusListener);
  }

  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      Future.delayed(Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _controller.isActive = false;  // This will stop the Rive animation
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(
      widget.riveFileName,
      controllers: [_controller],
      fit: BoxFit.cover,
      onInit: (_) => _controller.isActive = true,  // Start animation on init
    );
  }

  @override
  void dispose() {
    widget.animation.removeStatusListener(_animationStatusListener);
    super.dispose();
  }
}
