import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Provider/List%20Note%20Provider/list_note_provider.dart';
import 'package:note_tracking_app/Core/Provider/Note%20Provider/note_provider.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';
import 'package:note_tracking_app/Utils/Constant/Strings/strings.dart';
import 'package:provider/provider.dart';

class NoteWidget extends StatefulWidget {
  final int index;
  final Color textColor;
  const NoteWidget({super.key, required this.index, required this.textColor});

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NoteProvider>(context);
    final listProvider = Provider.of<ListNoteProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 28,
          width: 28,
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  (listProvider.notesPointController[widget.index].text.isEmpty)
                      ? AppColors.divider
                      : provider.textColor,
              width: 1,
            ),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(
          width: 18,
        ),
        Expanded(
          child: TextField(
            controller: listProvider.notesPointController[widget.index],
            style: (listProvider
                    .notesPointController[widget.index].text.isNotEmpty)
                ? provider.textStyle.copyWith(
                    color: provider.textColor,
                    decorationColor: provider.textColor)
                : null,
            onSubmitted: (value) {
              if (value.isNotEmpty &&
                  widget.index ==
                      listProvider.notesPointController.length - 1) {
                listProvider.addNote(widget.index);
              } else {
                listProvider.notesPointController.removeAt(widget.index);
              }
            },
            onChanged: (value) {
              setState(() {});
            },
            cursorHeight: 24,
            cursorColor: AppColors.text,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: AppStrings.defaultList,
              hintStyle: TextStyle(
                color: AppColors.divider,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
