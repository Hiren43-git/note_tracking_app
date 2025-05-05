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

class NoteDetailScreen extends StatefulWidget {
  final int index;
  final int? noteId;
  final int? listNoteId;
  const NoteDetailScreen(
      {super.key, required this.index, this.noteId, this.listNoteId});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.noteId != null) {
      Provider.of<NoteProvider>(context, listen: false)
          .loadSubNote(widget.noteId!);
    }
    if (widget.listNoteId != null) {
      Provider.of<ListNoteProvider>(context, listen: false)
          .loadSubNote(widget.listNoteId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NoteProvider>(context);
    final listProvider = Provider.of<ListNoteProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back,
              color: AppColors.title,
              size: 26,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 22.0),
            child: GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.share,
                color: AppColors.title,
                size: 26,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26.0),
        child: (provider.list == false)
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    Consumer<NoteProvider>(
                      builder: (context, provider, child) {
                        final note = provider.notes.length > widget.index
                            ? provider.notes[widget.index]
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
                                provider.deleteNote(
                                    provider.notes[widget.index].id!);
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
                                          TextWidget(
                                            color: AppColors.title,
                                            size: 20,
                                            text: provider
                                                .notes[widget.index].title,
                                            weight: FontWeight.bold,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      NoteScreen(
                                                    note: provider
                                                        .notes[widget.index],
                                                  ),
                                                ),
                                              );
                                              provider.simple = true;
                                              provider.list = false;
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
                                          text: provider
                                                  .notes[widget.index].view
                                              ? provider.notes[widget.index]
                                                  .description
                                              : trimText(
                                                  provider.notes[widget.index]
                                                      .description,
                                                  TextStyle(
                                                    color:
                                                        AppColors.description,
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
                                              text: provider
                                                      .notes[widget.index].view
                                                  ? AppStrings.viewLess
                                                  : AppStrings.viewMore,
                                              style: TextStyle(
                                                color: AppColors.title,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () => provider
                                                    .descriptionShow(provider
                                                        .notes[widget.index]
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
                    ),
                    (provider.subNotes.isNotEmpty)
                        ? Consumer<NoteProvider>(
                            builder: (context, provider, child) {
                              final subNotes = provider.getSubNotes(
                                  (widget.noteId != null) ? widget.noteId! : 0);
                              return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: subNotes.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      GestureDetector(
                                        onLongPress: () {
                                          provider.deleteSubNote(
                                              subNotes[index].id!);
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color:
                                                AppColors.textFieldBackground,
                                            borderRadius:
                                                BorderRadius.circular(12),
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
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    TextWidget(
                                                      color: AppColors.title,
                                                      size: 20,
                                                      text:
                                                          subNotes[index].title,
                                                      weight: FontWeight.bold,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    NoteScreen(
                                                              subNote: subNotes[
                                                                  index],
                                                            ),
                                                          ),
                                                        );
                                                        provider.subSimple =
                                                            true;
                                                        provider.list = false;
                                                        provider.subList =
                                                            false;
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
                                                  color: AppColors
                                                      .detailCardDivider,
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    text: provider
                                                            .subNotes[index]
                                                            .view
                                                        ? subNotes[index]
                                                            .description
                                                        : trimText(
                                                            subNotes[index]
                                                                .description,
                                                            TextStyle(
                                                              color: AppColors
                                                                  .description,
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                            context,
                                                          ),
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.description,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: provider
                                                                .subNotes[index]
                                                                .view
                                                            ? AppStrings
                                                                .viewLess
                                                            : AppStrings
                                                                .viewMore,
                                                        style: TextStyle(
                                                          color:
                                                              AppColors.title,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        recognizer: TapGestureRecognizer()
                                                          ..onTap = () => provider
                                                              .subDescriptionShow(
                                                                  provider
                                                                      .subNotes[
                                                                          index]
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
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Consumer<ListNoteProvider>(
                      builder: (context, listProvider, child) {
                        final note =
                            listProvider.listNotes.length > widget.index
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
                                listProvider.deleteNote(
                                    listProvider.listNotes[widget.index].id!);
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
                                          TextWidget(
                                            color: AppColors.title,
                                            size: 20,
                                            text: listProvider
                                                .listNotes[widget.index].title,
                                            weight: FontWeight.bold,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              provider.simple = false;

                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      NoteScreen(
                                                    listNote:
                                                        listProvider.listNotes[
                                                            widget.index],
                                                  ),
                                                ),
                                              );
                                              provider.list = true;
                                              listProvider.listTitle.clear();
                                              listProvider.notesPointController
                                                  .clear();
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
                                          text: listProvider
                                                  .listNotes[widget.index].view
                                              ? listProvider
                                                  .listNotes[widget.index]
                                                  .points
                                                  .asMap()
                                                  .entries
                                                  .where(
                                                    (element) =>
                                                        !(element.key ==
                                                                listProvider
                                                                        .listNotes[widget
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
                                                      .listNotes[widget.index]
                                                      .points
                                                      .asMap()
                                                      .entries
                                                      .where(
                                                        (element) =>
                                                            !(element.key ==
                                                                    listProvider
                                                                            .listNotes[widget
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
                                                      .join('\n'),
                                                  TextStyle(
                                                    color:
                                                        AppColors.description,
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
                                                      .listNotes[widget.index]
                                                      .view
                                                  ? AppStrings.viewLess
                                                  : AppStrings.viewMore,
                                              style: TextStyle(
                                                color: AppColors.title,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () =>
                                                    provider.descriptionShow(
                                                        listProvider
                                                            .listNotes[
                                                                widget.index]
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      GestureDetector(
                                        onLongPress: () {
                                          listProvider.deleteSubNote(
                                              subListNotes[index].id!);
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color:
                                                AppColors.textFieldBackground,
                                            borderRadius:
                                                BorderRadius.circular(12),
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
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    TextWidget(
                                                      color: AppColors.title,
                                                      size: 20,
                                                      text: subListNotes[index]
                                                          .title,
                                                      weight: FontWeight.bold,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    NoteScreen(
                                                              subListNote:
                                                                  subListNotes[
                                                                      index],
                                                            ),
                                                          ),
                                                        );
                                                        provider.subSimple =
                                                            false;
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
                                                  color: AppColors
                                                      .detailCardDivider,
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    text: listProvider
                                                            .subListNotes[index]
                                                            .view
                                                        ? listProvider
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
                                                            .join('\n')
                                                        : listProvider
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
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.description,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: listProvider
                                                                .subListNotes[
                                                                    index]
                                                                .view
                                                            ? AppStrings
                                                                .viewLess
                                                            : AppStrings
                                                                .viewMore,
                                                        style: TextStyle(
                                                          color:
                                                              AppColors.title,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        recognizer: TapGestureRecognizer()
                                                          ..onTap = () => provider
                                                              .subDescriptionShow(
                                                                  listProvider
                                                                      .subListNotes[
                                                                          index]
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
              ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          if (provider.simple) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NoteScreen(),
              ),
            );
            provider.subSimple = true;
            provider.subList = false;
            provider.list = false;
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NoteScreen(),
              ),
            );
            provider.subSimple = false;
            provider.subList = true;
            provider.simple = false;
          }
        },
        child: Container(
          height: 46,
          width: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.button,
          ),
          child: Icon(
            Icons.add,
            color: AppColors.title,
            size: 32,
          ),
        ),
      ),
    );
  }
}
