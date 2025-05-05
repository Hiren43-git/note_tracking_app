import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Provider/Auth%20Provider/auth_provider.dart';
import 'package:note_tracking_app/Module/Login%20Screen/Screens/login_screen.dart';
import 'package:note_tracking_app/Module/Welcome/Widget/image_widget.dart';
import 'package:note_tracking_app/Module/Welcome/Widget/text_widget.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';
import 'package:note_tracking_app/Utils/Constant/Strings/strings.dart';
import 'package:provider/provider.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                16,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageWidget(),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        color: AppColors.title,
                        size: 18,
                        text: provider.name.text,
                        weight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                      TextWidget(
                        color: AppColors.title,
                        size: 18,
                        text: provider.email.text,
                        overflow: TextOverflow.ellipsis,
                        line: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () {
              Provider.of<AuthProvider>(context, listen: false).logout(
                  Provider.of<AuthProvider>(context, listen: false)
                      .currentUserId);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
              AuthProvider().name.clear();
              AuthProvider().password.clear();
              AuthProvider().email.clear();
              AuthProvider().confirmPassword.clear();
            },
            child: Row(
              children: [
                Icon(
                  Icons.logout,
                  color: AppColors.red,
                ),
                SizedBox(
                  width: 12,
                ),
                TextWidget(
                  color: AppColors.red,
                  size: 18,
                  text: AppStrings.logout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
