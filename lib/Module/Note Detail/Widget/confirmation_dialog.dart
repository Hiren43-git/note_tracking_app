import 'package:flutter/material.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';

class ConfirmationDialog extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  const ConfirmationDialog(
      {super.key, required this.text, required this.onTap});

  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AlertDialog(
        content: Text(widget.text),
        actions: <Widget>[
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                'CANCEL',
              )),
          ElevatedButton(
            onPressed: widget.onTap,
            child: Text(
              'DELETE',
              style: TextStyle(color: AppColors.red),
            ),
          ),
        ],
      ),
    );
  }
}
