import 'package:flutter/material.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';

class CommonRawWidget extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final VoidCallback onTap;
  const CommonRawWidget(
      {super.key, required this.text, required this.onTap, this.style});

  @override
  State<CommonRawWidget> createState() => _CommonRawWidgetState();
}

class _CommonRawWidgetState extends State<CommonRawWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.text,
          style: widget.style,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        GestureDetector(
          onTap: widget.onTap,
          child: Icon(
            Icons.edit,
            color: AppColors.title,
            size: 18,
          ),
        ),
      ],
    );
  }
}
