import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Provider/Note%20Provider/note_provider.dart';
import 'package:note_tracking_app/Module/Note%20Detail/Widget/common_widget.dart';
import 'package:note_tracking_app/Module/Note%20Detail/Widget/confirmation_dialog.dart';
import 'package:note_tracking_app/Module/Note%20Detail/Widget/text_view_widget.dart';
import 'package:note_tracking_app/Module/Simple%20Note/Screens/note_screen.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';
import 'package:note_tracking_app/Utils/Constant/Strings/strings.dart';
import 'package:provider/provider.dart';

class MainNotes extends StatefulWidget {
  final int index;
  final int? noteId;
  const MainNotes({super.key, required this.index, this.noteId});

  @override
  State<MainNotes> createState() => _MainNotesState();
}

class _MainNotesState extends State<MainNotes> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NoteProvider>(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          Consumer<NoteProvider>(
            builder: (context, provider, child) {
              final note = provider.notes.length > widget.index
                  ? provider.notes[widget.index]
                  : null;
              if (provider.notes.length <= widget.index) {
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
                  provider.notes[widget.index].desStyle.fontSize!);
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
                          text: AppStrings.confirmNote,
                          onTap: () {
                            provider.getCurrentNoteId(widget.noteId!);
                            provider.deleteNote(
                                provider.notes[widget.index].id!, context);
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                    onTap: () {
                      provider.simple = false;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NoteScreen(
                            note: provider.notes[widget.index],
                          ),
                        ),
                      );
                      provider.simple = true;
                      provider.list = false;
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
                              text: provider.notes[widget.index].title,
                              style: provider.notes[widget.index].titleStyles,
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
                                style: provider.notes[widget.index].desStyle,
                                children: () {
                                  final result = trimText(
                                      provider.notes[widget.index].description,
                                      provider.notes[widget.index].desStyle,
                                      context);
                                  final expand =
                                      provider.notes[widget.index].view;
                                  final text = expand
                                      ? provider.notes[widget.index].description
                                      : result['text'] as String;
                                  final exist = result['exist'] as bool;
                                  return [
                                    TextSpan(text: text),
                                    if (exist)
                                      TextSpan(
                                        text: expand
                                            ? AppStrings.viewLess
                                            : AppStrings.viewMore,
                                        style: provider
                                            .notes[widget.index].desStyle
                                            .copyWith(
                                          decoration: TextDecoration.none,
                                          fontSize: provider.viewMore,
                                          color: AppColors.viewMore,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap =
                                              () => provider.descriptionShow(
                                                    provider.notes[widget.index]
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
          (provider.subNotes.isNotEmpty)
              ? Consumer<NoteProvider>(
                  builder: (context, provider, child) {
                    final subNotes = provider.getSubNotes(widget.noteId!);
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: subNotes.length,
                      itemBuilder: (context, index) {
                        provider
                            .viewMoreSize(subNotes[index].desStyle.fontSize!);
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
                                    text: AppStrings.confirmSubNote,
                                    onTap: () {
                                      provider.getCurrentNoteId(widget.noteId!);
                                      provider
                                          .deleteSubNote(subNotes[index].id!);
                                      provider.loadSubNote(widget.noteId!);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                );
                              },
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => NoteScreen(
                                      subNote: subNotes[index],
                                    ),
                                  ),
                                );
                                provider.subSimple = true;
                                provider.list = false;
                                provider.subList = false;
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
                                        text: subNotes[index].title,
                                        style: subNotes[index].titleStyles,
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
                                          style: subNotes[index].desStyle,
                                          children: () {
                                            final result = trimText(
                                                subNotes[index].description,
                                                subNotes[index].desStyle,
                                                context);
                                            final expand =
                                                provider.subNotes[index].view;
                                            final text = expand
                                                ? subNotes[index].description
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
                                                  style: subNotes[index]
                                                      .desStyle
                                                      .copyWith(
                                                        decoration:
                                                            TextDecoration.none,
                                                        color:
                                                            AppColors.viewMore,
                                                        fontSize:
                                                            provider.viewMore,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () => provider
                                                            .subDescriptionShow(
                                                                provider
                                                                    .subNotes[
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
