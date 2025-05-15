import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Model/List%20Note%20Model/list_note_model.dart';
import 'package:note_tracking_app/Core/Model/List%20Note%20Model/sub_list_model.dart';
import 'package:note_tracking_app/Core/Model/Note%20Model/note_model.dart';
import 'package:note_tracking_app/Core/Model/Note%20Model/sub_note_model.dart';
import 'package:note_tracking_app/Core/Provider/Auth%20Provider/auth_provider.dart';
import 'package:note_tracking_app/Core/Provider/List%20Note%20Provider/list_note_provider.dart';
import 'package:note_tracking_app/Core/Provider/Note%20Provider/note_provider.dart';
import 'package:note_tracking_app/Module/Simple%20Note/Widget/bottom_navigation_bar.dart';
import 'package:note_tracking_app/Module/Simple%20Note/Widget/note.dart';
import 'package:note_tracking_app/Module/Simple%20Note/Widget/save_button.dart';
import 'package:note_tracking_app/Module/Simple%20Note/Widget/textField_widget.dart';
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
  late ListNoteProvider listProvider;
  late VoidCallback titleListener;
  final Map pointListener = {};
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<NoteProvider>(context, listen: false);
    final listProvider = Provider.of<ListNoteProvider>(context, listen: false);
    if (widget.subNote != null) {
      provider.title.text = widget.subNote!.title;
      provider.description.text = widget.subNote!.description;
      provider.titleStyles =
          SubNoteModel.decodeStyle(widget.subNote!.titleStyle);
      provider.desStyle =
          SubNoteModel.decodeStyle(widget.subNote!.descriptionStyle);
    }
    if (widget.note != null) {
      provider.title.text = widget.note!.title;
      provider.description.text = widget.note!.description;
      provider.titleStyles = NoteModel.decodeStyle(widget.note!.titleStyle);
      provider.desStyle = NoteModel.decodeStyle(widget.note!.descriptionStyle);
    }
    if (widget.listNote != null) {
      listProvider.listTitle.text = widget.listNote!.title;
      listProvider.titleStyles =
          ListNoteModel.decodeStyle(widget.listNote!.titleStyle);
      while (listProvider.notesPointController.length <
          widget.listNote!.points.length) {
        if (widget.listNote!.points.isNotEmpty) {
          listProvider.notesPointController.add(TextEditingController());
          listProvider.pointFocus.add(FocusNode());
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
          Provider.of<ListNoteProvider>(context, listen: false)
              .pointFocus
              .removeAt(i);
        } else {
          Provider.of<ListNoteProvider>(context, listen: false)
              .notesPointController[i]
              .text = widget.listNote!.points[i];
          Provider.of<ListNoteProvider>(context, listen: false).pointStyle =
              ListNoteModel.decodeStyle(widget.listNote!.pointsStyle);
        }
      }
    }
    if (widget.subListNote != null) {
      Provider.of<ListNoteProvider>(context, listen: false).listTitle.text =
          widget.subListNote!.title;
      Provider.of<ListNoteProvider>(context, listen: false).titleStyles =
          SubListNoteModel.decodeStyle(widget.subListNote!.titleStyle);

      while (Provider.of<ListNoteProvider>(context, listen: false)
              .notesPointController
              .length <
          widget.subListNote!.points.length) {
        if (widget.subListNote!.points.isNotEmpty) {
          Provider.of<ListNoteProvider>(context, listen: false)
              .notesPointController
              .add(TextEditingController());
          Provider.of<ListNoteProvider>(context, listen: false)
              .pointFocus
              .add(FocusNode());
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
          Provider.of<ListNoteProvider>(context, listen: false)
              .pointFocus
              .removeAt(i);
        } else {
          Provider.of<ListNoteProvider>(context, listen: false)
              .notesPointController[i]
              .text = widget.subListNote!.points[i];
          Provider.of<ListNoteProvider>(context, listen: false).pointStyle =
              SubListNoteModel.decodeStyle(widget.subListNote!.pointsStyle);
        }
      }
    }

    if (listProvider.notesPointController.isEmpty) {
      listProvider.notesPointController.add(TextEditingController());
      listProvider.pointFocus.add(FocusNode());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    listProvider = Provider.of<ListNoteProvider>(context, listen: false);

    if (!initialized) {
      titleListener = () {
        if (!mounted) return;
        if (mounted && listProvider.titleFocus.hasFocus) {
          setState(() {
            listProvider.field = 'title';
          });
        } else {
          setState(() {
            listProvider.field = 'point';
          });
        }
      };

      listProvider.addListener(titleListener);
      for (var node in listProvider.pointFocus) {
        addPointListener(node);
      }
      initialized = true;
    }
  }

  void addPointListener(FocusNode node) {
    final listener = () {
      if (!mounted) return;
      if (mounted && node.hasFocus) {
        setState(() {
          listProvider.field = 'point';
        });
      } else {
        setState(() {
          listProvider.field = 'title';
        });
      }
    };
    node.addListener(listener);
    pointListener[node] = listener;
  }

  @override
  void dispose() {
    if (initialized) {
      listProvider.disposePoint();
    }
    super.dispose();
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
              provider.clearStyle();
              for (int i = 0;
                  i < listProvider.notesPointController.length;
                  i++) {
                listProvider.notesPointController[i];
                listProvider.clearStyle();
              }
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
                          titleStyle:
                              SubNoteModel.styleToJson(provider.titleStyles),
                          descriptionStyle:
                              SubNoteModel.styleToJson(provider.desStyle),
                        );
                        await provider.updateSubNote(update);
                        provider.clearStyle();
                        await provider.loadSubNote(provider.currentNoteId);
                      } else {
                        provider.addSubNotes(
                          SubNoteModel(
                            noteId: provider.currentNoteId,
                            title: provider.title.text,
                            description: provider.description.text,
                            titleStyle:
                                SubNoteModel.styleToJson(provider.titleStyles),
                            descriptionStyle:
                                SubNoteModel.styleToJson(provider.desStyle),
                          ),
                        );
                        provider.clearStyle();
                        provider.subSimple = false;
                      }
                      provider.title.clear();
                      provider.description.clear();
                      await provider.loadNote(authProvider.currentUserId!);
                      Navigator.of(context).pop();
                    }
                    if (provider.simple == true) {
                      if (widget.note != null) {
                        final update = NoteModel(
                          id: widget.note!.id,
                          userId: widget.note!.userId,
                          title: provider.title.text,
                          description: provider.description.text,
                          titleStyle:
                              NoteModel.styleToJson(provider.titleStyles),
                          descriptionStyle:
                              NoteModel.styleToJson(provider.desStyle),
                        );
                        await provider.updateNote(update);
                        provider.clearStyle();
                        provider.title.clear();
                        provider.description.clear();
                      } else {
                        provider.addNotes(
                          NoteModel(
                            userId: authProvider.currentUserId!,
                            title: provider.title.text,
                            description: provider.description.text,
                            titleStyle:
                                NoteModel.styleToJson(provider.titleStyles),
                            descriptionStyle:
                                NoteModel.styleToJson(provider.desStyle),
                          ),
                        );
                        provider.clearStyle();
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
                          titleStyle: ListNoteModel.styleToJson(
                              listProvider.titleStyles),
                          pointsStyle: ListNoteModel.styleToJson(
                              listProvider.pointStyle),
                        );
                        await listProvider.updateSubNote(update);
                        listProvider.clearStyle();
                        for (int i = 0;
                            i < listProvider.notesPointController.length;
                            i++) {
                          listProvider.notesPointController[i];
                          listProvider.clearStyle();
                        }
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
                            titleStyle: ListNoteModel.styleToJson(
                                listProvider.titleStyles),
                            pointsStyle: ListNoteModel.styleToJson(
                                listProvider.pointStyle),
                          ),
                        );
                        listProvider.clearStyle();
                        for (int i = 0;
                            i < listProvider.notesPointController.length;
                            i++) {
                          listProvider.notesPointController[i];
                          listProvider.clearStyle();
                        }
                        provider.subList = false;
                      }
                      listProvider.listTitle.clear();
                      listProvider.notesPointController.clear();
                      listProvider.pointFocus.clear();
                      await listProvider.loadNote(authProvider.currentUserId!);
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
                          titleStyle: ListNoteModel.styleToJson(
                              listProvider.titleStyles),
                          pointsStyle: ListNoteModel.styleToJson(
                              listProvider.pointStyle),
                        );
                        await listProvider.updateNote(update);
                        listProvider.clearStyle();
                        for (int i = 0;
                            i < listProvider.notesPointController.length;
                            i++) {
                          listProvider.notesPointController[i];
                          listProvider.clearStyle();
                        }
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
                            titleStyle: ListNoteModel.styleToJson(
                                listProvider.titleStyles),
                            pointsStyle: ListNoteModel.styleToJson(
                                listProvider.pointStyle),
                          ),
                        );
                        listProvider.clearStyle();
                        for (int i = 0;
                            i < listProvider.notesPointController.length;
                            i++) {
                          listProvider.notesPointController[i];
                          listProvider.clearStyle();
                        }
                      }
                      await listProvider.loadNote(authProvider.currentUserId!);
                      listProvider.listTitle.clear();
                      listProvider.notesPointController.clear();
                      listProvider.pointFocus.clear();
                      Navigator.of(context).pop();
                    }
                  }
                  provider.list = true;
                }
              },
              child: saveButton(),
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
                textField(
                  provider,
                  provider.title,
                  AppStrings.defaultTitle,
                  1,
                  provider.titleFocus,
                  provider.titleStyles,
                ),
              if (provider.simple == true || provider.subSimple == true)
                textField(
                  provider,
                  provider.description,
                  AppStrings.description,
                  null,
                  provider.descriptionFocus,
                  provider.desStyle,
                ),
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
                    return NoteWidget(
                      index: index,
                    );
                  },
                )
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigationBar(provider, listProvider, width),
    );
  }
}
