import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:svar_new/presentation/home/home.dart';
import 'package:svar_new/presentation/patient_report/patient_assessment_page.dart';
import 'package:svar_new/presentation/user_profile_screen/user_profile_screen.dart';
import 'package:svar_new/widgets/fees_page.dart'; // Import the Rive package

class RiveBottomnav extends StatefulWidget {
  final int currentIndex;
  final Function(int) onIndexChanged;
  final String stateMachineName;
  final String artboardName;

  RiveBottomnav({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
    this.stateMachineName = "State Machine 1", // Default state machine name
    this.artboardName = "", // Default: use the first/default artboard
  });

  @override
  State<RiveBottomnav> createState() => _RiveBottomnavState();
}

class _RiveBottomnavState extends State<RiveBottomnav> {

  StateMachineController? _controller;
  Artboard? _riveArtboard;
  SMITrigger? _smiToday;
  SMITrigger? _smiReport;
  SMITrigger? _smiCalendar;
  SMITrigger? _smiProfile;

  // List to map index to SMI inputs and listener names easily
  final List<String> _smiNames = ["Today", "Report", "Calendar", "Profile"];
  late List<SMITrigger?> _smiInputs;

  @override
  void initState() {
    super.initState();
    _smiInputs = List.filled(_smiNames.length, null); // Initialize with nulls
  }

  @override
  void dispose() {
    _controller?.dispose(); // Dispose the controller when the widget is removed
    super.dispose();
  }

  // Callback when Rive animation initializes
  void _onRiveInit(Artboard artboard) {
    _riveArtboard = artboard;
    // Find the state machine controller by name
    _controller = StateMachineController.fromArtboard(
      artboard,
      widget.stateMachineName, // Use the specified state machine name
      onStateChange:
          _onStateChange, // Optional: If you need state change events
    );

    if (_controller != null) {
      artboard.addController(_controller!);
      print("State Machine Controller found: ${widget.stateMachineName}");

      // Find all the SMITrigger inputs by their names
      for (int i = 0; i < _smiNames.length; i++) {
        final input = _controller!.findInput<bool>(_smiNames[i]) as SMITrigger;
        if (input != null) {
          _smiInputs[i] = input;
          print("Found SMI Trigger: ${_smiNames[i]}");
        } else {
          print("⚠️ Could not find SMI Trigger: ${_smiNames[i]}");
        }
      }

      // Find and attach the listeners
      _controller!.addEventListener(_onRiveEvent);

      // Trigger the initial state based on the initial currentIndex
      _fireTriggerByIndex(widget.currentIndex);
    } else {
      print(
          "⚠️ Could not find State Machine Controller: ${widget.stateMachineName}");
    }

    setState(() {});
  }

  // --- Listener Callback ---
  void _onRiveEvent(RiveEvent event) {
    print("Rive Event Received: ${event.name}, Data: ${event.properties}");

    int triggeredIndex = _smiNames.indexOf(event.name);
    int index = triggeredIndex;
    int currentIndex = widget.currentIndex;

    widget.onIndexChanged(index);
  }

  // --- Optional State Change Callback ---
  void _onStateChange(String stateMachineName, String stateName) {
    // You can react to specific state changes in your Rive state machine if needed
    print('State Changed: $stateMachineName - $stateName');
  }

  // --- Triggering Animation ---
  void _fireTriggerByIndex(int index) {
    if (_controller == null) {
      print("⚠️ Cannot fire trigger: Controller not initialized.");
      return;
    }
    if (index >= 0 && index < _smiInputs.length) {
      final smi = _smiInputs[index];
      if (smi != null) {
        print("Firing trigger for index $index: ${_smiNames[index]}");
        smi.fire();
      } else {
        print(
            "⚠️ Cannot fire trigger: SMI input for index $index (${_smiNames[index]}) not found.");
      }
    } else {
      print("⚠️ Cannot fire trigger: Invalid index $index");
    }
  }

  // --- Handling External Index Changes ---
  @override
  void didUpdateWidget(covariant RiveBottomnav oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the index passed from the parent changes, fire the corresponding trigger
    if (widget.currentIndex != oldWidget.currentIndex) {
      print(
          "currentIndex changed from ${oldWidget.currentIndex} to ${widget.currentIndex}. Firing trigger.");
      _fireTriggerByIndex(widget.currentIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
      height: 85, // Adjust height as needed
      // Adjust width as needed
      width: MediaQuery.of(context).size.width,

      decoration: BoxDecoration(
        color: Colors.transparent
        // color: Color(0xFFF9F2EF)
      ),
      child: RiveAnimation.asset(
        'assets/rive/nav.riv',

        artboard: widget.artboardName.isNotEmpty
            ? widget.artboardName
            : null, // Use specified artboard or default
        onInit: _onRiveInit, // Callback when Rive initializes
        fit: BoxFit.fitHeight, // Adjust fit as needed (contain, cover, etc.)
      ),
    );
  }
}
