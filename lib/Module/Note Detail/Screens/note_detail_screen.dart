import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Provider/Auth%20Provider/auth_provider.dart';
import 'package:note_tracking_app/Core/Provider/List%20Note%20Provider/list_note_provider.dart';
import 'package:note_tracking_app/Core/Provider/Note%20Provider/note_provider.dart';
import 'package:note_tracking_app/Module/Note%20Detail/Widget/list_note.dart';
import 'package:note_tracking_app/Module/Note%20Detail/Widget/main_note.dart';
import 'package:note_tracking_app/Module/Simple%20Note/Screens/note_screen.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';
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
      Provider.of<NoteProvider>(context, listen: false).loadNote(
          Provider.of<AuthProvider>(context, listen: false).currentUserId!);
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
            ? MainNotes(
                index: widget.index,
                noteId: widget.noteId,
              )
            : ListNotes(
                index: widget.index,
                listNoteId: widget.listNoteId,
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
