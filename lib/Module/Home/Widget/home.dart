import 'dart:math';

import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Provider/Auth%20Provider/auth_provider.dart';
import 'package:note_tracking_app/Core/Provider/note_provider.dart';
import 'package:note_tracking_app/Module/Note%20Detail/Screens/note_detail_screen.dart';
import 'package:note_tracking_app/Module/Simple%20Note/Screens/note_screen.dart';
import 'package:note_tracking_app/Module/Welcome/Widget/text_widget.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';
import 'package:note_tracking_app/Utils/Constant/Strings/strings.dart';
import 'package:provider/provider.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  void initState() {
    if (Provider.of<AuthProvider>(context, listen: false).currentUser != null) {
      Provider.of<NoteProvider>(context, listen: false).loadNote(
          Provider.of<AuthProvider>(context, listen: false).currentUser!.id!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // final provider = Provider.of<NoteProvider>(context);

    return TabBarView(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 22, right: 26, left: 26, bottom: 0),
          child: Consumer<NoteProvider>(
            builder: (context, provider, child) {
              return provider.notes.isEmpty
                  ? Center(
                      child: TextWidget(
                        color: AppColors.title,
                        size: 16,
                        text: AppStrings.emptyNote,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Wrap(
                        spacing: width * 0.0266,
                        runSpacing: width * 0.0266,
                        children:
                            List.generate(provider.notes.length + 1, (index) {
                          final color = provider
                              .colors[Random().nextInt(provider.colors.length)];
                          if (index == provider.notes.length &&
                              provider.notes.isNotEmpty) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => NoteScreen(),
                                  ),
                                );
                                provider.simple = true;
                                provider.list = false;
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
                                      image: AssetImage(
                                          'assets/Images/Icons/add.png'),
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
                                    ),
                                  ),
                                );
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
                                        text: provider.notes[index].title,
                                        weight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                        line: 1,
                                      ),
                                      TextWidget(
                                        color: AppColors.text,
                                        size: width * 0.038,
                                        text: provider.notes[index].description,
                                        weight: FontWeight.w500,
                                        overflow: TextOverflow.ellipsis,
                                        line: 4,
                                      ),
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
        ),
        Center(
          child: TextWidget(
            color: AppColors.title,
            size: 16,
            text: AppStrings.emptyListNote,
          ),
        ),
      ],
    );
  }
}
