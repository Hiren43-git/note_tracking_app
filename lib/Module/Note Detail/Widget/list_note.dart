import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Provider/List%20Note%20Provider/list_note_provider.dart';
import 'package:note_tracking_app/Core/Provider/Note%20Provider/note_provider.dart';
import 'package:note_tracking_app/Module/Note%20Detail/Widget/text_view_widget.dart';
import 'package:note_tracking_app/Module/Simple%20Note/Screens/note_screen.dart';
import 'package:note_tracking_app/Module/Welcome/Widget/text_widget.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';
import 'package:note_tracking_app/Utils/Constant/Strings/strings.dart';
import 'package:provider/provider.dart';

class ListNotes extends StatefulWidget {
  final int index;
  final int? listNoteId;
  const ListNotes({super.key, this.listNoteId, required this.index});

  @override
  State<ListNotes> createState() => _ListNotesState();
}

class _ListNotesState extends State<ListNotes> {
  @override
  Widget build(BuildContext context) {
    final listProvider = Provider.of<ListNoteProvider>(context);
    final provider = Provider.of<NoteProvider>(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          Consumer<ListNoteProvider>(
            builder: (context, listProvider, child) {
              final note = listProvider.listNotes.length > widget.index
                  ? listProvider.listNotes[widget.index]
                  : null;
              if (note == null) return SizedBox();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onLongPress: () {
                      listProvider
                          .deleteNote(listProvider.listNotes[widget.index].id!);
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.textFieldBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: TextWidget(
                                    color: AppColors.title,
                                    size: 20,
                                    text: listProvider
                                        .listNotes[widget.index].title,
                                    weight: FontWeight.bold,
                                    line: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    provider.simple = false;

                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => NoteScreen(
                                          listNote: listProvider
                                              .listNotes[widget.index],
                                        ),
                                      ),
                                    );
                                    provider.list = true;
                                    listProvider.listTitle.clear();
                                    listProvider.notesPointController.clear();
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    color: AppColors.title,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Divider(
                              thickness: 0.2,
                              color: AppColors.detailCardDivider,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            RichText(
                              text: TextSpan(
                                text: listProvider.listNotes[widget.index].view
                                    ? listProvider
                                        .listNotes[widget.index].points
                                        .asMap()
                                        .entries
                                        .where(
                                          (element) =>
                                              !(element.key ==
                                                      listProvider
                                                              .listNotes[
                                                                  widget.index]
                                                              .points
                                                              .length -
                                                          1 &&
                                                  element.value.isEmpty) &&
                                              element.value.trim().isNotEmpty,
                                        )
                                        .map(
                                          (e) => '○ ${e.value}',
                                        )
                                        .join('\n')
                                    : trimText(
                                        listProvider
                                            .listNotes[widget.index].points
                                            .asMap()
                                            .entries
                                            .where(
                                              (element) =>
                                                  !(element.key ==
                                                          listProvider
                                                                  .listNotes[
                                                                      widget
                                                                          .index]
                                                                  .points
                                                                  .length -
                                                              1 &&
                                                      element.value.isEmpty) &&
                                                  element.value
                                                      .trim()
                                                      .isNotEmpty,
                                            )
                                            .map(
                                              (e) => '○ ${e.value}',
                                            )
                                            .join('\n'),
                                        TextStyle(
                                          color: AppColors.description,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        context,
                                      ),
                                style: TextStyle(
                                  color: AppColors.description,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                ),
                                children: [
                                  TextSpan(
                                    text: listProvider
                                            .listNotes[widget.index].view
                                        ? AppStrings.viewLess
                                        : AppStrings.viewMore,
                                    style: TextStyle(
                                      color: AppColors.title,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () =>
                                          listProvider.listDescriptionShow(
                                            listProvider
                                                .listNotes[widget.index].id!,
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                ],
              );
            },
          ),
          (listProvider.subListNotes.isNotEmpty)
              ? Consumer<ListNoteProvider>(
                  builder: (context, listProvider, child) {
                    final subListNotes =
                        listProvider.getSubNotes(widget.listNoteId!);
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: subListNotes.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onLongPress: () {
                                listProvider
                                    .deleteSubNote(subListNotes[index].id!);
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.textFieldBackground,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: TextWidget(
                                              color: AppColors.title,
                                              size: 20,
                                              text: subListNotes[index].title,
                                              weight: FontWeight.bold,
                                              line: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      NoteScreen(
                                                    subListNote:
                                                        subListNotes[index],
                                                  ),
                                                ),
                                              );
                                              provider.subSimple = false;
                                              provider.simple = false;
                                              provider.subList = true;
                                            },
                                            child: Icon(
                                              Icons.edit,
                                              color: AppColors.title,
                                              size: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Divider(
                                        thickness: 0.2,
                                        color: AppColors.detailCardDivider,
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text:
                                              listProvider
                                                      .subListNotes[index].view
                                                  ? listProvider
                                                      .subListNotes[index]
                                                      .points
                                                      .asMap()
                                                      .entries
                                                      .where(
                                                        (element) =>
                                                            !(element.key ==
                                                                    listProvider
                                                                            .subListNotes[widget
                                                                                .index]
                                                                            .points
                                                                            .length -
                                                                        1 &&
                                                                element.value
                                                                    .isEmpty) &&
                                                            element.value
                                                                .trim()
                                                                .isNotEmpty,
                                                      )
                                                      .map(
                                                        (e) => '○ ${e.value}',
                                                      )
                                                      .join('\n')
                                                  : trimText(
                                                      listProvider
                                                          .subListNotes[index]
                                                          .points
                                                          .asMap()
                                                          .entries
                                                          .where(
                                                            (element) =>
                                                                !(element.key ==
                                                                        listProvider.subListNotes[widget.index].points.length -
                                                                            1 &&
                                                                    element
                                                                        .value
                                                                        .isEmpty) &&
                                                                element.value
                                                                    .trim()
                                                                    .isNotEmpty,
                                                          )
                                                          .map(
                                                            (e) =>
                                                                '○ ${e.value}',
                                                          )
                                                          .join('\n'),
                                                      TextStyle(
                                                        color: AppColors
                                                            .description,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      context,
                                                    ),
                                          style: TextStyle(
                                            color: AppColors.description,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: listProvider
                                                      .subListNotes[index].view
                                                  ? AppStrings.viewLess
                                                  : AppStrings.viewMore,
                                              style: TextStyle(
                                                color: AppColors.title,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () => listProvider
                                                    .subListDescriptionShow(
                                                        listProvider
                                                            .subListNotes[index]
                                                            .id!),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
