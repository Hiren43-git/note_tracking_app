import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Provider/Auth%20Provider/auth_provider.dart';
import 'package:note_tracking_app/Module/Login%20Screen/Screens/login_screen.dart';
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
    double width = MediaQuery.of(context).size.width;
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
                Container(
                  height: width * 0.266,
                  width: width * 0.266,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.textFieldBackground,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: (provider.image != null)
                          ? FileImage(provider.image!)
                          : AssetImage(
                              'assets/Images/manager.png',
                            ),
                    ),
                  ),
                ),
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
                        text: provider.currentUserName,
                        weight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                      TextWidget(
                        color: AppColors.title,
                        size: 15,
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
              provider.logout();
              provider.name.clear();
              provider.password.clear();
              provider.email.clear();
              provider.confirmPassword.clear();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
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
