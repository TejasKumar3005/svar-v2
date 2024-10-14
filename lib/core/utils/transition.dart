import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:svar_new/presentation/home/home.dart';
import 'package:svar_new/routes/app_routes.dart';

class RivePageRoute extends PageRouteBuilder {
  final String routeName;
  final dynamic arguments;
  final String riveFileName;

  RivePageRoute(
      {required this.routeName, this.arguments, required this.riveFileName})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) {

          return FutureBuilder(
            future: Future.delayed(Duration(seconds: 1)), // 1-second delay
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // After the delay, return the page
                var builder = AppRoutes.routes[routeName];
                return builder != null ? builder(context) : HomeScreen();
              } else {
                // While waiting, you can show a loading indicator or a placeholder
                return Container(); // Replace with a loading widget if desired
              }
            },
          );

          },
          settings: RouteSettings(
        arguments: arguments, // Pass arguments using RouteSettings
      ),
          transitionDuration: Duration(seconds: 5),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return Stack(
              children: <Widget>[
                child,
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      // Only show the Rive animation when the animation is not yet completed.
                      return animation.isCompleted
                          ? SizedBox()
                          : RiveAnimationTransition(
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

class RiveAnimationTransition extends StatefulWidget {
  final Animation<double> animation;
  final String riveFileName;

  RiveAnimationTransition(
      {required this.animation, required this.riveFileName});

  @override
  _RiveAnimationTransitionState createState() =>
      _RiveAnimationTransitionState();
}

class _RiveAnimationTransitionState extends State<RiveAnimationTransition> {
  StateMachineController? _stateMachineController;
  // SMITrigger? _trigger; // Example input; adjust based on your state machine
  bool _isAnimationActive = false;

  @override
  void dispose() {
    // Dispose of the state machine controller if it's been initialized
    _stateMachineController?.dispose();
    super.dispose();
  }

  void _onRiveInit(Artboard artboard) {
    // Initialize the StateMachineController with the Artboard and the state machine name
    _stateMachineController =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    
    if (_stateMachineController != null) {
      artboard.addController(_stateMachineController!);
      
      // Example: Retrieve a trigger input from the state machine
      // Replace 'TriggerName' with the actual name of your trigger
      // _trigger = _stateMachineController!.findInput<SMITrigger>('TriggerName');
      
      // Activate the animation
      setState(() {
        _isAnimationActive = true;
      });
      
      // Optionally, you can activate a trigger to start the animation
      // _trigger?.fire();
      
      // Listen for changes or transitions in the state machine if needed
      // This requires additional logic based on your specific state machine setup
    }
  }

  void _handleAnimationCompletion() {
    // This method can be called based on your state machine's logic
    // For example, after a certain state is reached
    Future.delayed(Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _isAnimationActive = false;
          _stateMachineController?.isActive = false; // Deactivate the controller
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(
      widget.riveFileName,
      onInit: _onRiveInit,
      fit: BoxFit.cover,
      // Optionally, you can set `artboard` or other properties here
    );
  }
}