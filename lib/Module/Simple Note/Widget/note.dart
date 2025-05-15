import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Provider/List%20Note%20Provider/list_note_provider.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';
import 'package:note_tracking_app/Utils/Constant/Strings/strings.dart';
import 'package:provider/provider.dart';

class NoteWidget extends StatefulWidget {
  final int index;
  const NoteWidget({super.key, required this.index});

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  @override
  Widget build(BuildContext context) {
    final listProvider = Provider.of<ListNoteProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 18,
          width: 18,
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  (listProvider.notesPointController[widget.index].text.isEmpty)
                      ? AppColors.divider
                      : listProvider.pointStyle.color ?? AppColors.text,
              width: 1,
            ),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(
          width: 18,
        ),
        Expanded(
          child: Consumer<ListNoteProvider>(
              builder: (context, listProvider, child) {
            return TextField(
              focusNode: listProvider.pointFocus[widget.index],
              controller: listProvider.notesPointController[widget.index],
              style: (listProvider
                      .notesPointController[widget.index].text.isNotEmpty)
                  ? listProvider.pointStyle
                  : null,
              onSubmitted: (value) {
                if (value.isNotEmpty &&
                    widget.index ==
                        listProvider.notesPointController.length - 1) {
                  listProvider.addPoint(widget.index);
                } else {
                  listProvider.removePoint(widget.index);
                }
              },
              onChanged: (value) {
                setState(() {});
              },
              cursorColor: AppColors.text,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: AppStrings.defaultList,
                hintStyle: TextStyle(
                  color: AppColors.divider,
                  fontSize: 18,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
