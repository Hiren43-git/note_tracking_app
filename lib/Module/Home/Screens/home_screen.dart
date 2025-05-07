import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Provider/Auth%20Provider/auth_provider.dart';
import 'package:note_tracking_app/Core/Provider/List%20Note%20Provider/list_note_provider.dart';
import 'package:note_tracking_app/Core/Provider/Note%20Provider/note_provider.dart';
import 'package:note_tracking_app/Module/Home/Widget/add_widget.dart';
import 'package:note_tracking_app/Module/Home/Widget/list_widget.dart';
import 'package:note_tracking_app/Module/Home/Widget/note_widget.dart';
import 'package:note_tracking_app/Module/Home/Widget/profile.dart';
import 'package:note_tracking_app/Module/Search/Screens/search_screen.dart';
import 'package:note_tracking_app/Module/Welcome/Screens/welcome_screen.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';
import 'package:note_tracking_app/Utils/Constant/Strings/strings.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    if (Provider.of<AuthProvider>(context, listen: false).currentUserId != 0) {
      Provider.of<NoteProvider>(context, listen: false).loadNote(
          Provider.of<AuthProvider>(context, listen: false).currentUserId!);
      Provider.of<ListNoteProvider>(context, listen: false).loadNote(
          Provider.of<AuthProvider>(context, listen: false).currentUserId!);
    }
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NoteProvider>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: (provider.selectedIndexOfBottom == 0)
            ? AppBar(
                toolbarHeight: 100,
                backgroundColor: AppColors.background,
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 29.0),
                  child: TextField(
                    // controller: searchController,
                    cursorColor: AppColors.title,
                    style: TextStyle(color: AppColors.title),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SearchScreen(),
                        ),
                      );
                    },
                    // onChanged: (value) {
                    //   if (value.trim().isNotEmpty) {
                    //     if (tabController.index == 0) {
                    //       provider.search(value.trim());
                    //     }
                    //     if (tabController.index == 1) {
                    //       listProvider.search(value.trim());
                    //     }
                    //   } else {
                    //     if (tabController.index == 0) {
                    //       int? id =
                    //           Provider.of<AuthProvider>(context, listen: false)
                    //               .currentUserId;
                    //       if (id != 0) {
                    //         provider.clearSearch(id!);
                    //         searchController.clear();
                    //       }
                    //     }
                    //     if (tabController.index == 1) {
                    //       int? id =
                    //           Provider.of<AuthProvider>(context, listen: false)
                    //               .currentUserId;
                    //       if (id != 0) {
                    //         listProvider.clearSearch(id!);
                    //         searchController.clear();
                    //       }
                    //     }
                    //   }
                    // },
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
                bottom: TabBar(
                  controller: tabController,
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: MaterialStateProperty.all(
                    AppColors.transparent,
                  ),
                  unselectedLabelStyle: TextStyle(color: AppColors.noteTaking),
                  dividerColor: AppColors.background,
                  padding: EdgeInsets.only(left: 26, right: 26),
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(
                      text: AppStrings.note,
                    ),
                    Tab(
                      text: AppStrings.list,
                    ),
                  ],
                  labelColor: AppColors.title,
                  unselectedLabelColor: AppColors.title,
                  indicatorColor: AppColors.title,
                ),
              )
            : AppBar(
                backgroundColor: AppColors.background,
                actions: [
                  if (provider.selectedIndexOfBottom == 2)
                    Padding(
                      padding: const EdgeInsets.only(right: 22.0),
                      child: GestureDetector(
                        onTap: () {
                          provider.edit = true;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => WelcomeScreen(),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.edit,
                          color: AppColors.title,
                          size: 22,
                        ),
                      ),
                    ),
                ],
              ),
        body: Consumer<NoteProvider>(
          builder: (context, value, child) {
            if (provider.selectedIndexOfBottom == 0) {
              return TabBarView(
                controller: tabController,
                children: [
                  NoteWidget(),
                  ListWidget(),
                ],
              );
            } else if (provider.selectedIndexOfBottom == 1) {
              return AddWidget();
            } else {
              return ProfileWidget();
            }
          },
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(
              color: AppColors.textFieldBackground,
              thickness: 2,
            ),
            Theme(
              data: Theme.of(context).copyWith(
                splashColor: AppColors.transparent,
                highlightColor: AppColors.transparent,
              ),
              child: BottomNavigationBar(
                onTap: (int index) {
                  setState(() {
                    provider.selectedIndexOfBottom = index;
                  });
                },
                currentIndex: provider.selectedIndexOfBottom,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.note),
                    label: AppStrings.home,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.add),
                    label: AppStrings.add,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: AppStrings.profile,
                  ),
                ],
                backgroundColor: AppColors.background,
                selectedItemColor: AppColors.button,
                selectedIconTheme: IconThemeData(size: 24),
                unselectedIconTheme: IconThemeData(size: 24),
                unselectedFontSize: 14,
                selectedFontSize: 14,
                unselectedItemColor: AppColors.noteTaking,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
