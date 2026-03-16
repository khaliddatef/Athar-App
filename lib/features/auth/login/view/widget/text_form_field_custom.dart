import 'package:flutter/material.dart';

class TextFormFieldCustom extends StatelessWidget {
  const TextFormFieldCustom({
    super.key,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.controller,
    this.validator,
  });

  final String? label;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Label فوق الحقل
        if (label != null)
          Text(
            label!,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),

        const SizedBox(height: 8),

        // TextFormField
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureText!,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            prefixIcon: prefixIcon, 
            suffixIcon: suffixIcon, 
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
