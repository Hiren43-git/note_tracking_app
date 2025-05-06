import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Provider/Note%20Provider/note_provider.dart';
import 'package:note_tracking_app/Module/Note%20Detail/Widget/text_view_widget.dart';
import 'package:note_tracking_app/Module/Simple%20Note/Screens/note_screen.dart';
import 'package:note_tracking_app/Module/Welcome/Widget/text_widget.dart';
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
              if (note == null) return SizedBox();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onLongPress: () {
                      provider.deleteNote(provider.notes[widget.index].id!);
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
                                    text: provider.notes[widget.index].title,
                                    weight: FontWeight.bold,
                                    line: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
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
                                text: provider.notes[widget.index].view
                                    ? provider.notes[widget.index].description
                                    : trimText(
                                        provider
                                            .notes[widget.index].description,
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
                                    text: provider.notes[widget.index].view
                                        ? AppStrings.viewLess
                                        : AppStrings.viewMore,
                                    style: TextStyle(
                                      color: AppColors.title,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => provider.descriptionShow(
                                            provider.notes[widget.index].id!,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onLongPress: () {
                                provider.deleteSubNote(subNotes[index].id!);
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
                                              text: subNotes[index].title,
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
                                                    subNote: subNotes[index],
                                                  ),
                                                ),
                                              );
                                              provider.subSimple = true;
                                              provider.list = false;
                                              provider.subList = false;
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
                                          text: provider.subNotes[index].view
                                              ? subNotes[index].description
                                              : trimText(
                                                  subNotes[index].description,
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
                                              text:
                                                  provider.subNotes[index].view
                                                      ? AppStrings.viewLess
                                                      : AppStrings.viewMore,
                                              style: TextStyle(
                                                color: AppColors.title,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () => provider
                                                    .subDescriptionShow(provider
                                                        .subNotes[index].id!),
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
