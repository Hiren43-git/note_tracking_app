import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Provider/note_provider.dart';
import 'package:note_tracking_app/Module/Simple%20Note/Screens/note_screen.dart';
import 'package:note_tracking_app/Module/Welcome/Widget/text_widget.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';
import 'package:note_tracking_app/Utils/Constant/Strings/strings.dart';
import 'package:provider/provider.dart';

class AddWidget extends StatefulWidget {
  const AddWidget({super.key});

  @override
  State<AddWidget> createState() => _AddWidgetState();
}

class _AddWidgetState extends State<AddWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NoteProvider>(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.title,
            borderRadius: BorderRadius.circular(
              22,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  color: AppColors.text,
                  size: 26,
                  text: AppStrings.addNew,
                  weight: FontWeight.bold,
                ),
                SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => NoteScreen(),
                      ),
                    );
                    provider.list = false;
                    provider.simple = true;
                  },
                  child: TextWidget(
                    color: AppColors.text,
                    size: 16,
                    text: AppStrings.simpleNote,
                    weight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 28,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => NoteScreen(),
                      ),
                    );
                    provider.list = true;
                    provider.simple = false;
                  },
                  child: TextWidget(
                    color: AppColors.text,
                    size: 16,
                    text: AppStrings.list2,
                    weight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
