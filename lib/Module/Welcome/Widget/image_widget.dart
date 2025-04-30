import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Provider/Auth%20Provider/auth_provider.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';
import 'package:provider/provider.dart';

class ImageWidget extends StatefulWidget {
  const ImageWidget({super.key});

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          height: width * 0.266,
          width: width * 0.266,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.textFieldBackground,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: (authProvider.image != null)
                  ? FileImage(authProvider.image!)
                  : AssetImage(
                      'assets/Images/manager.png',
                    ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            authProvider.pickImage();
          },
          child: Padding(
            padding: EdgeInsets.only(
              right: width * 0.01,
              bottom: width * 0.006,
            ),
            child: Container(
              height: width * 0.07,
              width: width * 0.07,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.divider, width: 0.6),
                shape: BoxShape.circle,
                color: AppColors.editContainer,
              ),
              child: Icon(
                Icons.edit,
                color: AppColors.title,
                size: width * 0.04,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
