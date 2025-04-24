import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Provider/note_provider.dart';
import 'package:note_tracking_app/Module/Note%20Detail/Widget/text_view_widget.dart';
import 'package:note_tracking_app/Module/Simple%20Note/Screens/note_screen.dart';
import 'package:note_tracking_app/Module/Welcome/Widget/text_widget.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';
import 'package:note_tracking_app/Utils/Constant/Strings/strings.dart';
import 'package:provider/provider.dart';

class NoteDetailScreen extends StatefulWidget {
  const NoteDetailScreen({super.key});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.textFieldBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget(
                            color: AppColors.title,
                            size: 20,
                            text: 'fewrf edfsdffdf',
                            weight: FontWeight.bold,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => NoteScreen(),
                                ),
                              );
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
                          text: (provider.viewMore)
                              ? 'fewrf edfsdffdf fdsf fsdf sdf dfdfsdfd dsfds dfd dfdsf dffds fsfd sfddfdfsfdsfsdf fsddsfsdfsdfd'
                              : trimText(
                                  'fewrf edfsdffdf fdsf fsdf sdf dfdfsdfd dsfds dfd dfdsf dffds fsfd fsdfdfffffsf fdsfsdfsdfsdfdsf',
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
                              text: provider.viewMore
                                  ? AppStrings.viewLess
                                  : AppStrings.viewMore,
                              style: TextStyle(
                                color: AppColors.title,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => provider.descriptionShow(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {},
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
