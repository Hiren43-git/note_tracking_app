import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Model/Note%20Model/note_model.dart';
import 'package:note_tracking_app/Core/Provider/Auth%20Provider/auth_provider.dart';
import 'package:note_tracking_app/Core/Provider/note_provider.dart';
import 'package:note_tracking_app/Module/Simple%20Note/Widget/note.dart';
import 'package:note_tracking_app/Module/Simple%20Note/Widget/styleButton.dart';
import 'package:note_tracking_app/Module/Simple%20Note/Widget/styleColor.dart';
import 'package:note_tracking_app/Module/Welcome/Widget/text_widget.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';
import 'package:note_tracking_app/Utils/Constant/Strings/strings.dart';

import 'package:provider/provider.dart';

class NoteScreen extends StatefulWidget {
  final NoteModel? note;
  const NoteScreen({super.key, this.note});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final provider = Provider.of<NoteProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.title,
      appBar: AppBar(
        backgroundColor: AppColors.title,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 18, bottom: 18),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Image.asset(
              fit: BoxFit.contain,
              'assets/Images/Icons/close.png',
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () async {
                if (provider.simple == true) {
                  if (provider.title.text.isEmpty &&
                      provider.description.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Add note data !',
                        ),
                      ),
                    );
                  } else {
                    provider.addNotes(
                      NoteModel(
                        userId: authProvider.currentUser!.id!,
                        title: provider.title.text,
                        description: provider.description.text,
                      ),
                    );
                    provider.title.clear();
                    provider.description.clear();
                  }
                  if (widget.note != null) {
                    final update = NoteModel(
                      id: widget.note!.id,
                      userId: widget.note!.userId,
                      title: provider.title.text,
                      description: provider.description.text,
                    );
                    await provider.updateNote(update);
                  }
                }
                Navigator.of(context).pop();
              },
              child: Container(
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
                          'assets/Images/Icons/check.png',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 34,
              ),
              if (provider.simple == true)
                TextField(
                  controller: provider.title,
                  style: provider.textStyle.copyWith(
                      color: provider.textColor,
                      decorationColor: provider.textColor),
                  cursorHeight: 29,
                  cursorColor: AppColors.text,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: AppStrings.defaultTitle,
                    hintStyle: TextStyle(
                      color: AppColors.divider,
                      fontWeight: FontWeight.w500,
                      fontSize: 32,
                    ),
                  ),
                ),
              if (provider.simple == true)
                TextField(
                  controller: provider.description,
                  style: provider.textStyle.copyWith(
                      color: provider.textColor,
                      decorationColor: provider.textColor),
                  cursorHeight: 24,
                  cursorColor: AppColors.text,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: AppStrings.description,
                    hintStyle: TextStyle(
                      color: AppColors.divider,
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                    ),
                  ),
                ),
              if (provider.list == true)
                ListView(
                  shrinkWrap: true,
                  children: [
                    TextField(
                      controller: provider.listTitle,
                      style: provider.textStyle.copyWith(
                          color: provider.textColor,
                          decorationColor: provider.textColor),
                      cursorHeight: 29,
                      cursorColor: AppColors.text,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: AppStrings.defaultListTitle,
                        hintStyle: TextStyle(
                          color: AppColors.divider,
                          fontWeight: FontWeight.w500,
                          fontSize: 32,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    ...List.generate(
                      provider.notes.length,
                      (index) => NoteWidget(
                        index: index,
                        textColor: provider.textColor,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
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
                    () => provider.style(
                      TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.113,
                  ),
                  styleButton(
                    AppStrings.underLine,
                    () => provider.style(
                      TextStyle(
                        decoration: TextDecoration.underline,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.113,
                  ),
                  styleButton(
                    AppStrings.italic,
                    () => provider.style(
                      TextStyle(
                        decoration: TextDecoration.none,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
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
                    () => provider.style(
                      TextStyle(fontSize: 26),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.065,
                  ),
                  styleButton(
                    AppStrings.h2,
                    () => provider.style(
                      TextStyle(fontSize: 22),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.065,
                  ),
                  styleButton(
                    AppStrings.h3,
                    () => provider.style(
                      TextStyle(fontSize: 16),
                    ),
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
                      color: provider.textColor,
                      width: 1,
                    ),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: TextWidget(
                    color: provider.textColor,
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
                StyleColor(
                  color: AppColors.styleColor,
                ),
                StyleColor(
                  color: AppColors.styleColor2,
                ),
                StyleColor(
                  color: AppColors.styleColor3,
                ),
                StyleColor(
                  color: AppColors.styleColor4,
                ),
                StyleColor(
                  color: AppColors.styleColor5,
                ),
              ],
            ),
            SizedBox(
              height: 6,
            )
          ],
        ),
      ),
    );
  }
}
