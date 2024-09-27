import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

OverlayEntry celebrationOverlay(
    BuildContext context, Function() removeOverlay) {
  return OverlayEntry(
    builder: (context) => Material(
        color: Colors.transparent,
        child: CelebrationOverlayWidget(
          removeOverlay: removeOverlay,
        )),
  );
}

class CelebrationOverlayWidget extends StatefulWidget {
  Function() removeOverlay;
  CelebrationOverlayWidget({super.key, required this.removeOverlay});

  @override
  State<CelebrationOverlayWidget> createState() =>
      _CelebrationOverlayWidgetState();
}

class _CelebrationOverlayWidgetState extends State<CelebrationOverlayWidget> {
  Artboard? _artboard;
  SMITrigger? successTrigger;
  SMITrigger? resetTrigger;
  late Timer timer;
  @override
  void initState() {
    rootBundle.load("assets/rive/congrats.riv").then(
      (data) {

        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        StateMachineController? stateMachineController =
            StateMachineController.fromArtboard(artboard, "State Machine 1");
        if (stateMachineController != null) {
          artboard.addController(stateMachineController!);

          stateMachineController!.inputs.forEach((element) {
            if (element.name == "Trigger explosion") {
              successTrigger = element as SMITrigger;
            } else if (element.name == "Reset") {
              resetTrigger = element as SMITrigger;
            }
          });
        }

        setState(() => _artboard = artboard);
      },
    );
  if(_artboard!=null){

    successTrigger!.fire();
  }
    // Timer(Duration(seconds: 10), () {
    //   widget.removeOverlay();
    //   Navigator.pop(context, true);
    // });
    int sec=0;
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      sec++;
      if(_artboard!=null){
        
      if(sec%2==0 ){
        successTrigger!.fire();
      }else {
        resetTrigger!.fire();
      }
      }

      if (sec == 10) {
        timer.cancel();
        widget.removeOverlay();
      Navigator.pop(context, true);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Visibility(
          visible: _artboard != null,
          child: Rive(
            artboard: _artboard!,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
