import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Provider/List%20Note%20Provider/list_note_provider.dart';
import 'package:note_tracking_app/Core/Provider/Note%20Provider/note_provider.dart';
import 'package:note_tracking_app/Module/Note%20Detail/Widget/common_widget.dart';
import 'package:note_tracking_app/Module/Note%20Detail/Widget/confirmation_dialog.dart';
import 'package:note_tracking_app/Module/Note%20Detail/Widget/text_view_widget.dart';
import 'package:note_tracking_app/Module/Simple%20Note/Screens/note_screen.dart';
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

              if (listProvider.listNotes.length <= widget.index) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (timeStamp) {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
                );
                return SizedBox();
              }
              if (note == null) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (timeStamp) {
                    Navigator.of(context).pop();
                  },
                );
                return SizedBox();
              }
              provider.viewMoreSize(
                  listProvider.listNotes[widget.index].pointStyle.fontSize!);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) => ConfirmationDialog(
                          text: AppStrings.confirmList,
                          onTap: () {
                            listProvider.getCurrentNoteId(widget.listNoteId!);
                            listProvider.deleteNote(
                                listProvider.listNotes[widget.index].id!,
                                context);
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                    onTap: () {
                      provider.list = false;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NoteScreen(
                            listNote: listProvider.listNotes[widget.index],
                          ),
                        ),
                      );
                      provider.list = true;
                      provider.simple = false;
                      listProvider.listTitle.clear();
                      listProvider.notesPointController.clear();
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
                            CommonRawWidget(
                              text: listProvider.listNotes[widget.index].title,
                              style: listProvider
                                  .listNotes[widget.index].titleStyles,
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
                                children: () {
                                  final result = trimText(
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
                                                element.value.trim().isNotEmpty,
                                          )
                                          // .map(
                                          //   (e) => '${e.value}',
                                          // )
                                          .map(
                                            (e) => TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: '- ',
                                                ),
                                                TextSpan(
                                                  text: e.value,
                                                ),
                                              ],
                                            ),
                                          )
                                          .join('\n'),
                                      listProvider
                                          .listNotes[widget.index].pointStyle,
                                      context);
                                  final expand =
                                      listProvider.listNotes[widget.index].view;
                                  final text = expand
                                      ? listProvider
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
                                                element.value.trim().isNotEmpty,
                                          )
                                          .map(
                                            (e) => '${e.value}',
                                          )
                                          .join('\n')
                                      : result['text'] as String;
                                  final exist = result['exist'] as bool;
                                  return [
                                    TextSpan(
                                      text: text,
                                      style: listProvider
                                          .listNotes[widget.index].pointStyle,
                                    ),
                                    if (exist)
                                      TextSpan(
                                        text: expand
                                            ? AppStrings.viewLess
                                            : AppStrings.viewMore,
                                        style: listProvider
                                            .listNotes[widget.index].pointStyle
                                            .copyWith(
                                          color: AppColors.viewMore,
                                          fontSize: provider.viewMore,
                                          decoration: TextDecoration.none,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () =>
                                              listProvider.listDescriptionShow(
                                                listProvider
                                                    .listNotes[widget.index]
                                                    .id!,
                                              ),
                                      ),
                                  ];
                                }(),
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
                        provider.viewMoreSize(listProvider
                            .subListNotes[index].pointStyle.fontSize!);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => ConfirmationDialog(
                                    text: AppStrings.confirmSubList,
                                    onTap: () {
                                      listProvider
                                          .getCurrentNoteId(widget.listNoteId!);
                                      listProvider.deleteSubNote(
                                          subListNotes[index].id!);
                                      listProvider
                                          .loadSubNote(widget.listNoteId!);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                );
                              },
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => NoteScreen(
                                      subListNote: subListNotes[index],
                                    ),
                                  ),
                                );
                                provider.subSimple = false;
                                provider.simple = false;
                                provider.subList = true;
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
                                      CommonRawWidget(
                                        text: subListNotes[index].title,
                                        style: subListNotes[index].titleStyles,
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
                                          style: listProvider
                                              .subListNotes[index].pointStyle,
                                          children: () {
                                            final result = trimText(
                                                listProvider
                                                    .subListNotes[index].points
                                                    .asMap()
                                                    .entries
                                                    .where(
                                                      (element) =>
                                                          !(element.key ==
                                                                  listProvider
                                                                          .subListNotes[
                                                                              index]
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
                                                      (e) => '${e.value}',
                                                    )
                                                    .join('\n'),
                                                listProvider.subListNotes[index]
                                                    .pointStyle,
                                                context);
                                            final expand = listProvider
                                                .subListNotes[index].view;
                                            final text = expand
                                                ? listProvider
                                                    .subListNotes[index].points
                                                    .asMap()
                                                    .entries
                                                    .where(
                                                      (element) =>
                                                          !(element.key ==
                                                                  listProvider
                                                                          .subListNotes[
                                                                              index]
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
                                                      (e) => '${e.value}',
                                                    )
                                                    .join('\n')
                                                : result['text'] as String;
                                            final exist =
                                                result['exist'] as bool;
                                            return [
                                              TextSpan(text: text),
                                              if (exist)
                                                TextSpan(
                                                  text: expand
                                                      ? AppStrings.viewLess
                                                      : AppStrings.viewMore,
                                                  style: listProvider
                                                      .subListNotes[index]
                                                      .pointStyle
                                                      .copyWith(
                                                    color: AppColors.viewMore,
                                                    fontSize: provider.viewMore,
                                                    decoration:
                                                        TextDecoration.none,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = () => listProvider
                                                        .subListDescriptionShow(
                                                            listProvider
                                                                .subListNotes[
                                                                    index]
                                                                .id!),
                                                ),
                                            ];
                                          }(),
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
