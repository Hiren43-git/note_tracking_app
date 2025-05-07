import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Model/List%20Note%20Model/list_note_model.dart';
import 'package:note_tracking_app/Core/Model/List%20Note%20Model/sub_list_model.dart';
import 'package:note_tracking_app/Core/Model/Note%20Model/note_model.dart';
import 'package:note_tracking_app/Core/Model/Note%20Model/sub_note_model.dart';
import 'package:note_tracking_app/Core/Provider/Auth%20Provider/auth_provider.dart';
import 'package:note_tracking_app/Core/Provider/List%20Note%20Provider/list_note_provider.dart';
import 'package:note_tracking_app/Core/Provider/Note%20Provider/note_provider.dart';
import 'package:note_tracking_app/Module/Simple%20Note/Widget/note.dart';
import 'package:note_tracking_app/Module/Simple%20Note/Widget/styleButton.dart';
import 'package:note_tracking_app/Module/Simple%20Note/Widget/styleColor.dart';
import 'package:note_tracking_app/Module/Simple%20Note/Widget/textField_widget.dart';
import 'package:note_tracking_app/Module/Welcome/Widget/text_widget.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';
import 'package:note_tracking_app/Utils/Constant/Strings/strings.dart';

import 'package:provider/provider.dart';

class NoteScreen extends StatefulWidget {
  final NoteModel? note;
  final ListNoteModel? listNote;
  final SubNoteModel? subNote;
  final SubListNoteModel? subListNote;
  const NoteScreen(
      {super.key, this.note, this.listNote, this.subNote, this.subListNote});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.subNote != null) {
      Provider.of<NoteProvider>(context, listen: false).title.text =
          widget.subNote!.title;
      Provider.of<NoteProvider>(context, listen: false).description.text =
          widget.subNote!.description;
    }
    if (widget.note != null) {
      Provider.of<NoteProvider>(context, listen: false).title.text =
          widget.note!.title;
      Provider.of<NoteProvider>(context, listen: false).description.text =
          widget.note!.description;
    }
    if (widget.listNote != null) {
      Provider.of<ListNoteProvider>(context, listen: false).listTitle.text =
          widget.listNote!.title;

      while (Provider.of<ListNoteProvider>(context, listen: false)
              .notesPointController
              .length <
          widget.listNote!.points.length) {
        if (widget.listNote!.points.isNotEmpty) {
          Provider.of<ListNoteProvider>(context, listen: false)
              .notesPointController
              .add(TextEditingController());
        } else {
          widget.listNote!.points.length = widget.listNote!.points.length - 1;
        }
      }

      for (int i = 0; i < widget.listNote!.points.length; i++) {
        if (widget.listNote!.points[i].isEmpty) {
          widget.listNote!.points.removeAt(i);
          Provider.of<ListNoteProvider>(context, listen: false)
              .notesPointController
              .removeAt(i);
        } else {
          Provider.of<ListNoteProvider>(context, listen: false)
              .notesPointController[i]
              .text = widget.listNote!.points[i];
        }
      }
    }
    if (widget.subListNote != null) {
      Provider.of<ListNoteProvider>(context, listen: false).listTitle.text =
          widget.subListNote!.title;

      while (Provider.of<ListNoteProvider>(context, listen: false)
              .notesPointController
              .length <
          widget.subListNote!.points.length) {
        if (widget.subListNote!.points.isNotEmpty) {
          Provider.of<ListNoteProvider>(context, listen: false)
              .notesPointController
              .add(TextEditingController());
        } else {
          widget.subListNote!.points.length =
              widget.subListNote!.points.length - 1;
        }
      }

      for (int i = 0; i < widget.subListNote!.points.length; i++) {
        if (widget.subListNote!.points[i].isEmpty) {
          widget.subListNote!.points.removeAt(i);
          Provider.of<ListNoteProvider>(context, listen: false)
              .notesPointController
              .removeAt(i);
        } else {
          Provider.of<ListNoteProvider>(context, listen: false)
              .notesPointController[i]
              .text = widget.subListNote!.points[i];
        }
      }
    }
    if (Provider.of<ListNoteProvider>(context, listen: false)
        .notesPointController
        .isEmpty) {
      Provider.of<ListNoteProvider>(context, listen: false)
          .notesPointController
          .add(TextEditingController());
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final provider = Provider.of<NoteProvider>(context);
    final listProvider = Provider.of<ListNoteProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.title,
      appBar: AppBar(
        surfaceTintColor: AppColors.title,
        backgroundColor: AppColors.title,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 18, bottom: 18),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              provider.title.clear();
              provider.description.clear();
              listProvider.listTitle.clear();
              listProvider.notesPointController.clear();
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
                if (provider.subSimple == true || provider.simple == true) {
                  if (provider.title.text.isEmpty ||
                      provider.description.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Add note data !',
                        ),
                      ),
                    );
                  } else {
                    if (provider.subSimple == true) {
                      provider.simple = false;
                      if (widget.subNote != null) {
                        final update = SubNoteModel(
                          id: widget.subNote!.id,
                          noteId: provider.currentNoteId,
                          title: provider.title.text,
                          description: provider.description.text,
                        );
                        await provider.updateSubNote(update);
                        await provider.loadSubNote(provider.currentNoteId);
                      } else {
                        provider.addSubNotes(
                          SubNoteModel(
                            noteId: provider.currentNoteId,
                            title: provider.title.text,
                            description: provider.description.text,
                          ),
                        );
                      }
                      provider.title.clear();
                      provider.description.clear();
                      Navigator.of(context).pop();
                    }
                    if (provider.simple == true) {
                      if (widget.note != null) {
                        final update = NoteModel(
                          id: widget.note!.id,
                          userId: widget.note!.userId,
                          title: provider.title.text,
                          description: provider.description.text,
                        );
                        await provider.updateNote(update);
                        provider.title.clear();
                        provider.description.clear();
                      } else {
                        provider.addNotes(
                          NoteModel(
                            userId: authProvider.currentUserId!,
                            title: provider.title.text,
                            description: provider.description.text,
                          ),
                        );
                      }
                      await provider.loadNote(authProvider.currentUserId!);
                      provider.title.clear();
                      provider.description.clear();
                      Navigator.of(context).pop();
                    }
                  }
                  provider.simple = true;
                }
                if (provider.subList == true || provider.list == true) {
                  if (listProvider.listTitle.text.isEmpty ||
                      listProvider.notesPointController[0].text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Add note data !',
                        ),
                      ),
                    );
                  } else {
                    if (provider.subList == true) {
                      provider.list = false;
                      if (widget.subListNote != null) {
                        final update = SubListNoteModel(
                          id: widget.subListNote!.id,
                          listNoteId: listProvider.currentNoteId,
                          title: listProvider.listTitle.text,
                          points: listProvider.notesPointController
                              .map(
                                (e) => e.text,
                              )
                              .toList(),
                        );
                        await listProvider.updateSubNote(update);
                        await listProvider
                            .loadSubNote(listProvider.currentNoteId);
                      } else {
                        listProvider.addSubNotes(
                          SubListNoteModel(
                            listNoteId: listProvider.currentNoteId,
                            title: listProvider.listTitle.text,
                            points: listProvider.notesPointController
                                .map(
                                  (e) => e.text,
                                )
                                .toList(),
                          ),
                        );
                      }
                      listProvider.listTitle.clear();
                      listProvider.notesPointController.clear();
                      Navigator.of(context).pop();
                    }
                    if (provider.list == true) {
                      if (widget.listNote != null) {
                        final update = ListNoteModel(
                          id: widget.listNote!.id,
                          userId: widget.listNote!.userId,
                          title: listProvider.listTitle.text,
                          points: listProvider.notesPointController
                              .map(
                                (e) => e.text,
                              )
                              .toList(),
                        );

                        await listProvider.updateNote(update);
                      } else {
                        listProvider.addNotes(
                          ListNoteModel(
                            userId: authProvider.currentUserId!,
                            title: listProvider.listTitle.text,
                            points: listProvider.notesPointController
                                .map(
                                  (e) => e.text,
                                )
                                .toList(),
                          ),
                        );
                      }
                      await listProvider.loadNote(authProvider.currentUserId!);
                      listProvider.listTitle.clear();
                      listProvider.notesPointController.clear();
                      Navigator.of(context).pop();
                    }
                  }
                  provider.list = true;
                }
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
              if (provider.simple == true || provider.subSimple == true)
                textField(provider, provider.title, AppStrings.defaultTitle, 1),
              if (provider.simple == true || provider.subSimple == true)
                textField(provider, provider.description,
                    AppStrings.description, null),
              if (provider.list == true || provider.subList == true) ...[
                listTextField(
                  provider,
                  listProvider,
                  listProvider.listTitle,
                  AppStrings.defaultListTitle,
                ),
                SizedBox(
                  height: 8,
                ),
                ListView.builder(
                  itemCount: listProvider.notesPointController.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    print('list ${listProvider.notesPointController.length}');
                    return NoteWidget(
                      index: index,
                      textColor: provider.textColor,
                    );
                  },
                )
              ],
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
