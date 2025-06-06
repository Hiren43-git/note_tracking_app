import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Provider/Auth%20Provider/auth_provider.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';
import 'package:provider/provider.dart';

class TextFieldWidget extends StatefulWidget {
  final String text;
  final String? hint;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged? onSubmitted;
  final ValueChanged? onChange;
  final bool hide;
  final bool? read;
  final bool conHide;
  final FocusNode? focus;

  const TextFieldWidget({
    super.key,
    required this.text,
    this.hint,
    required this.controller,
    this.validator,
    this.hide = false,
    this.conHide = false,
    this.read = false,
    this.focus,
    this.onSubmitted,
    this.onChange,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          style: TextStyle(color: AppColors.title, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 6,
        ),
        TextFormField(
          autocorrect: false,
          focusNode: widget.focus,
          readOnly: (widget.read == true) ? true : false,
          obscureText: (widget.controller == authProvider.confirmPassword)
              ? (widget.conHide == true)
                  ? authProvider.conPasswordShow
                  : false
              : (widget.hide == true)
                  ? authProvider.passwordShow
                  : false,
          validator: widget.validator,
          controller: widget.controller,
          cursorColor: AppColors.title,
          onFieldSubmitted: widget.onSubmitted,
          onChanged: widget.onChange,
          style: TextStyle(color: AppColors.title),
          decoration: InputDecoration(
            suffixIcon: (widget.controller == authProvider.confirmPassword)
                ? widget.conHide
                    ? IconButton(
                        icon: Icon(
                          authProvider.conPasswordShow
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: 22,
                        ),
                        color: AppColors.title,
                        onPressed: () {
                          authProvider.showConfirmPassword();
                        },
                      )
                    : null
                : widget.hide
                    ? IconButton(
                        icon: Icon(
                          authProvider.passwordShow
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: 22,
                        ),
                        color: AppColors.title,
                        onPressed: () {
                          authProvider.showPassword();
                        },
                      )
                    : null,
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: AppColors.title,
            ),
            filled: true,
            fillColor: AppColors.textFieldBackground,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }
}
