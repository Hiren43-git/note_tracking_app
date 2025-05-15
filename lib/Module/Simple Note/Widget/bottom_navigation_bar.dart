import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Provider/List%20Note%20Provider/list_note_provider.dart';
import 'package:note_tracking_app/Core/Provider/Note%20Provider/note_provider.dart';
import 'package:note_tracking_app/Module/Simple%20Note/Widget/styleButton.dart';
import 'package:note_tracking_app/Module/Welcome/Widget/text_widget.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';
import 'package:note_tracking_app/Utils/Constant/Strings/strings.dart';

SafeArea bottomNavigationBar(
    NoteProvider? provider, ListNoteProvider? listProvider, double width) {
  return SafeArea(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(
          thickness: 1,
          color: AppColors.divider,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              styleButton(
                  AppStrings.bold,
                  () => (provider!.list == true || provider.subList == true)
                      ? listProvider!.bold()
                      : provider.bold()),
              SizedBox(
                width: width * 0.113,
              ),
              styleButton(
                  AppStrings.underLine,
                  () => (provider!.list == true || provider.subList == true)
                      ? listProvider!.underline()
                      : provider.underline()),
              SizedBox(
                width: width * 0.113,
              ),
              styleButton(
                  AppStrings.italic,
                  () => (provider!.list == true || provider.subList == true)
                      ? listProvider!.italic()
                      : provider.italic()),
              SizedBox(
                width: width * 0.08,
              ),
              Container(
                height: 18,
                width: 2,
                color: AppColors.divider,
              ),
              SizedBox(
                width: width * 0.046,
              ),
              styleButton(
                AppStrings.h1,
                () => (provider!.list == true || provider.subList == true)
                    ? listProvider!.h1()
                    : provider.h1(),
              ),
              SizedBox(
                width: width * 0.065,
              ),
              styleButton(
                AppStrings.h2,
                () => (provider!.list == true || provider.subList == true)
                    ? listProvider!.h2()
                    : provider.h2(),
              ),
              SizedBox(
                width: width * 0.065,
              ),
              styleButton(
                AppStrings.h3,
                () => (provider!.list == true || provider.subList == true)
                    ? listProvider!.h3()
                    : provider.h3(),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                border: Border.all(
                  color: (provider!.list == true || provider.subList == true)
                      ? listProvider!.textColor
                      : provider.textColor,
                  width: 1,
                ),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: TextWidget(
                color: (provider.list == true || provider.subList == true)
                    ? listProvider!.textColor
                    : provider.textColor,
                size: 24,
                text: AppStrings.a,
                weight: FontWeight.bold,
              ),
            ),
            Container(
              height: 18,
              width: 2,
              color: AppColors.divider,
            ),
            ...provider.colorList.map(
              (e) => GestureDetector(
                onTap: () {
                  (provider.list == true || provider.subList == true)
                      ? listProvider!.setColor(e)
                      : provider.setColor(e);
                },
                child: Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    color: e,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 6,
        )
      ],
    ),
  );
}
