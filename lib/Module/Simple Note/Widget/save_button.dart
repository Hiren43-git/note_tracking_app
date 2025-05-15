import 'package:flutter/material.dart';
import 'package:note_tracking_app/Module/Welcome/Widget/text_widget.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';
import 'package:note_tracking_app/Utils/Constant/Strings/strings.dart';

Container saveButton() {
  return Container(
    height: 36,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(
        20,
      ),
      color: AppColors.button,
    ),
    alignment: Alignment.center,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextWidget(
            color: AppColors.title,
            size: 16,
            text: AppStrings.save,
            weight: FontWeight.bold,
          ),
          SizedBox(
            width: 8,
          ),
          Image(
            height: 18,
            image: AssetImage(
              AppStrings.saveImage,
            ),
          ),
        ],
      ),
    ),
  );
}
