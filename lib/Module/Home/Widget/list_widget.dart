import 'dart:math';

import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Provider/Auth%20Provider/auth_provider.dart';
import 'package:note_tracking_app/Core/Provider/Note%20Provider/note_provider.dart';
import 'package:note_tracking_app/Module/Note%20Detail/Screens/note_detail_screen.dart';
import 'package:note_tracking_app/Module/Simple%20Note/Screens/note_screen.dart';
import 'package:note_tracking_app/Module/Welcome/Widget/text_widget.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';
import 'package:note_tracking_app/Utils/Constant/Strings/strings.dart';
import 'package:provider/provider.dart';

import '../../../Core/Provider/List Note Provider/list_note_provider.dart';

class ListWidget extends StatefulWidget {
  const ListWidget({super.key});

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final provider = Provider.of<NoteProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 22, right: 26, left: 26, bottom: 0),
      child: Consumer<ListNoteProvider>(
        builder: (context, listProvider, child) {
          return listProvider.listNotes.isEmpty
              ? Center(
                  child: TextWidget(
                    color: AppColors.title,
                    size: 16,
                    text: AppStrings.emptyListNote,
                  ),
                )
              : SingleChildScrollView(
                  child: Wrap(
                    spacing: width * 0.0266,
                    runSpacing: width * 0.0266,
                    children: List.generate(listProvider.listNotes.length + 1,
                        (index) {
                      final color = provider
                          .colors[Random().nextInt(provider.colors.length)];
                      int currentIndex = index;
                      if (index == listProvider.listNotes.length &&
                          listProvider.listNotes.isNotEmpty) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => NoteScreen(),
                              ),
                            );
                            provider.simple = false;
                            provider.list = true;
                            provider.subList = false;
                            provider.subSimple = false;
                            listProvider.listTitle.clear();
                            listProvider.notesPointController.clear();
                          },
                          child: Container(
                            height: width * 0.4,
                            width: (index % 4 == 0 || index % 4 == 3)
                                ? width * 0.47466
                                : width * 0.36,
                            alignment: Alignment.center,
                            child: Container(
                              height: width * 0.12,
                              width: width * 0.12,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.button,
                              ),
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Image(
                                  fit: BoxFit.cover,
                                  image:
                                      AssetImage('assets/Images/Icons/add.png'),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => NoteDetailScreen(
                                  index: index,
                                  listNoteId: listProvider.listNotes[index].id,
                                ),
                              ),
                            );
                            AuthProvider().getCurrentUserId(
                                listProvider.listNotes[index].id!);
                            listProvider.getCurrentNoteId(
                                listProvider.listNotes[index].id!);
                            provider.list = true;
                            provider.simple = false;
                            provider.subList = false;
                            provider.subSimple = false;
                            provider.title.clear();
                            provider.description.clear();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            height: width * 0.4,
                            width: (index % 4 == 0 || index % 4 == 3)
                                ? width * 0.47466
                                : width * 0.36,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    color: AppColors.text,
                                    size: width * 0.046,
                                    text: listProvider.listNotes[index].title,
                                    weight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                    line: 1,
                                  ),
                                  ...List.generate(
                                      listProvider.listNotes[currentIndex]
                                          .points.length, (index) {
                                    final text = listProvider
                                        .listNotes[currentIndex].points[index];
                                    return text.isNotEmpty
                                        ? TextWidget(
                                            color: AppColors.text,
                                            size: width * 0.038,
                                            text: listProvider
                                                    .listNotes[currentIndex]
                                                    .points[index]
                                                    .isNotEmpty
                                                ? '○ ${listProvider.listNotes[currentIndex].points[index]}'
                                                : '',
                                            weight: FontWeight.w500,
                                            overflow: TextOverflow.ellipsis,
                                            height: 1.4,
                                            line: 4,
                                          )
                                        : SizedBox.shrink();
                                  }),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    }),
                  ),
                );
        },
      ),
    );
  }
}
