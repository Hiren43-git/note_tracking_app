import 'package:flutter/material.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';

import '../../../Utils/Constant/Strings/strings.dart';

class DividerWidget extends StatefulWidget {
  const DividerWidget({super.key});

  @override
  State<DividerWidget> createState() => _DividerWidgetState();
}

class _DividerWidgetState extends State<DividerWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.detailCardDivider,
            thickness: 0.5,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
          child: Text(
            AppStrings.or,
            style: TextStyle(
              color: AppColors.detailCardDivider,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColors.detailCardDivider,
            thickness: 0.5,
          ),
        ),
      ],
    );
  }
}
