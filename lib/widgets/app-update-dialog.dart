import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/providers/appUpdateProvider.dart';

class UpdateDialog extends StatefulWidget {

  const UpdateDialog({Key? key}) : super(key: key);

  @override
  _UpdateDialogState createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  @override
  Widget build(BuildContext context) {
    var provider= context.watch<AppUpdateProvider>();
    return AlertDialog(
      title: Text('App Update'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(provider.status),
          if (provider.progress > 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: LinearProgressIndicator(
                value: provider.progress,
              ),
            ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}