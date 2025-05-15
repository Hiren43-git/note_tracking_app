import 'dart:math';

import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Provider/Auth%20Provider/auth_provider.dart';
import 'package:note_tracking_app/Core/Provider/List%20Note%20Provider/list_note_provider.dart';
import 'package:note_tracking_app/Core/Provider/Note%20Provider/note_provider.dart';
import 'package:note_tracking_app/Module/Note%20Detail/Screens/note_detail_screen.dart';
import 'package:note_tracking_app/Module/Welcome/Widget/text_widget.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';
import 'package:note_tracking_app/Utils/Constant/Strings/strings.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NoteProvider>(context);
    final listProvider = Provider.of<ListNoteProvider>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
            int? id =
                Provider.of<AuthProvider>(context, listen: false).currentUserId;
            if (id != 0) {
              provider.clearSearch(id!);
              listProvider.clearSearch(id);
              searchController.clear();
            }
          },
          child: Icon(
            Icons.arrow_back,
            color: AppColors.title,
          ),
        ),
        toolbarHeight: 74,
        backgroundColor: AppColors.background,
        title: TextField(
          controller: searchController,
          cursorColor: AppColors.title,
          style: TextStyle(color: AppColors.title),
          onChanged: (value) {
            if (value.trim().isNotEmpty) {
              provider.search(value.trim());
              listProvider.search(value.trim());
            } else {
              int? id = Provider.of<AuthProvider>(context, listen: false)
                  .currentUserId;
              if (id != 0) {
                provider.clearSearch(id!);
                listProvider.clearSearch(id);
                searchController.clear();
              }
            }
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.title,
            ),
            hintText: AppStrings.search,
            hintStyle: TextStyle(
              color: AppColors.title,
            ),
            filled: true,
            fillColor: AppColors.textFieldBackground,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 22, right: 26, left: 26, bottom: 0),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (provider.searchNotes.isNotEmpty &&
                      listProvider.searchNotes.isNotEmpty)
                  ? TextWidget(
                      color: AppColors.title,
                      size: 18,
                      text: AppStrings.simpleNote,
                      weight: FontWeight.w600,
                    )
                  : SizedBox(),
              SizedBox(
                height: 16,
              ),
              Consumer<NoteProvider>(
                builder: (context, provider, child) {
                  return provider.searchNotes.isEmpty &&
                          listProvider.searchNotes.isEmpty
                      ? Column(
                          children: [
                            SizedBox(height: height * 0.36),
                            Center(
                              child: TextWidget(
                                color: AppColors.title,
                                size: 16,
                                text: AppStrings.noteNotFound,
                              ),
                            ),
                            SizedBox(height: height * 0.36),
                          ],
                        )
                      : Wrap(
                          spacing: width * 0.0266,
                          runSpacing: width * 0.0266,
                          children: List.generate(
                            provider.searchNotes.length,
                            (index) {
                              final color = provider.colors[
                                  Random().nextInt(provider.colors.length)];
                              return GestureDetector(
                                onTap: () {
                                  final note = provider.notes.firstWhere(
                                    (element) =>
                                        element.title ==
                                        provider.searchNotes[index].title,
                                    orElse: () => provider.searchNotes[index],
                                  );
                                  int originalIndex = provider.notes.indexWhere(
                                    (element) =>
                                        element.id ==
                                        provider.searchNotes[index].id,
                                  );
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => NoteDetailScreen(
                                        index: originalIndex,
                                        noteId: note.id,
                                      ),
                                    ),
                                  );
                                  provider.getCurrentNoteId(
                                    note.id!,
                                  );
                                  provider.list = false;
                                  provider.simple = true;
                                  provider.subSimple = false;
                                  provider.subList = false;
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextWidget(
                                          color: AppColors.text,
                                          size: width * 0.046,
                                          text:
                                              provider.searchNotes[index].title,
                                          weight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis,
                                          line: 1,
                                        ),
                                        TextWidget(
                                          color: AppColors.text,
                                          size: width * 0.038,
                                          text: provider
                                              .searchNotes[index].description,
                                          weight: FontWeight.w500,
                                          overflow: TextOverflow.ellipsis,
                                          line: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                },
              ),
              SizedBox(
                height: 16,
              ),
              (provider.searchNotes.isNotEmpty &&
                      listProvider.searchNotes.isNotEmpty)
                  ? TextWidget(
                      color: AppColors.title,
                      size: 18,
                      text: AppStrings.listNote,
                      weight: FontWeight.w600,
                    )
                  : SizedBox(),
              SizedBox(
                height: 16,
              ),
              Consumer<ListNoteProvider>(
                builder: (context, listProvider, child) {
                  return Wrap(
                    spacing: width * 0.0266,
                    runSpacing: width * 0.0266,
                    children: List.generate(
                      listProvider.searchNotes.length,
                      (index) {
                        final color = provider
                            .colors[Random().nextInt(provider.colors.length)];
                        int currentIndex = index;
                        return GestureDetector(
                          onTap: () {
                            final note = listProvider.listNotes.firstWhere(
                              (element) =>
                                  element.title ==
                                  listProvider.searchNotes[index].title,
                              orElse: () => listProvider.searchNotes[index],
                            );
                            int originalIndex = provider.notes.indexWhere(
                              (element) =>
                                  element.id == provider.searchNotes[index].id,
                            );
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => NoteDetailScreen(
                                  index: originalIndex,
                                  noteId: note.id,
                                ),
                              ),
                            );
                            listProvider.getCurrentNoteId(note.id!);
                            provider.list = true;
                            provider.simple = false;
                            provider.subSimple = false;
                            provider.subList = false;
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    color: AppColors.text,
                                    size: width * 0.046,
                                    text: listProvider.searchNotes[index].title,
                                    weight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                    line: 1,
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: (listProvider
                                                .listNotes[currentIndex]
                                                .points
                                                .length >
                                            4)
                                        ? 4
                                        : listProvider.listNotes[currentIndex]
                                            .points.length,
                                    itemBuilder: (context, index) {
                                      final text = listProvider
                                          .listNotes[currentIndex]
                                          .points[index];
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
                                              line: 1,
                                            )
                                          : SizedBox.shrink();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
