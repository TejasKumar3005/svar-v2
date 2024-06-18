import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';

void ShowLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (
      BuildContext context,
    ) {
      return Dialog(
        child: Center(
          child: LinearProgressIndicator(
            color: appTheme.deepOrange200,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      );
    },
    barrierDismissible: false,
  );
}

OverlayEntry createOverlayEntry(BuildContext context) {
    return OverlayEntry(
      builder: (context) => Material(
        type: MaterialType.transparency,
        child: Center(
          child:_LoadingDialog()
        ),
      ),
    );
  }

void wheelLoadingDialog(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _LoadingDialog();
      });
}

class _LoadingDialog extends StatefulWidget {
  @override
  __LoadingDialogState createState() => __LoadingDialogState();
}

class __LoadingDialogState extends State<_LoadingDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 120,
      padding: EdgeInsets.all(20),
    
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: appTheme.orangeA200, width: 2),
      ),
      child: Center(
        child: RotationTransition(
          turns: _controller,
          child: Image.asset("assets/images/loading.png",height: 100,width: 100,fit: BoxFit.contain,),
        ),
      ),
    );
  }
}
