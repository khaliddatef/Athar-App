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
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      // التعديل السحري هنا: استخدم start ليكون الـ Label على اليمين في العربي
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [
        if (label != null)
          Text(
            label!,
            // حذفنا textAlign و textDirection لأن الـ Column سيقوم بالمهمة بناءً على اتجاه التطبيق
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold, // لجعلها واضحة مثل الصورة
            ),
          ),

        const SizedBox(height: 8),

        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          // اجعل المحاذاة start لتتبع اتجاه اللغة (العربي يبدأ من اليمين)
          textAlign: TextAlign.start, 
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            fillColor: Colors.white,
            filled: true,
            // لجعل التصميم يشبه الصورة الثانية (إضافة حدود خفيفة)
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }
}
// class TextFormFieldCustom extends StatelessWidget {
//   const TextFormFieldCustom({
//     super.key,
//     this.label,
//     this.prefixIcon,
//     this.suffixIcon,
//     this.obscureText = false,
//     this.controller,
//     this.validator,
//   });

//   final String? label;
//   final Widget? prefixIcon;
//   final Widget? suffixIcon;
//   final bool? obscureText;
//   final TextEditingController? controller;
//   final String? Function(String?)? validator;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         // Label فوق الحقل
//         if (label != null)
//           Text(
//             label!,
//             textDirection: TextDirection.rtl,
//             style: const TextStyle(
//               color: Colors.black,
//               fontSize: 16,
//             ),
//           ),

//         const SizedBox(height: 8),

//         // TextFormField
//         TextFormField(
//           controller: controller,
//           validator: validator,
//           obscureText: obscureText!,
     
//           decoration: InputDecoration(
//             prefixIcon: prefixIcon, 
//             suffixIcon: suffixIcon, 
//             fillColor: Colors.white,
//             filled: true,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide.none,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
