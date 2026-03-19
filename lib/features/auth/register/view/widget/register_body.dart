import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sanad/core/helper/helper_functions/build_snack_bar.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/helper/validation.dart';
import 'package:sanad/core/networking/api_exception.dart';
import 'package:sanad/core/routing/router.dart';
import 'package:sanad/core/widgets/app_button.dart';
import 'package:sanad/core/widgets/loading_app.dart';
import 'package:sanad/features/auth/login/view/widget/header_auth.dart';
import 'package:sanad/features/auth/login/view/widget/text_form_field_custom.dart';
import 'package:sanad/features/auth/view_model/controller/auth_controller.dart';
import 'package:sanad/features/auth/login/view_model/controller/login_controller.dart';

class RegisterBody extends StatefulWidget {
  const RegisterBody({super.key});

  @override
  State<RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  final TextEditingController email = TextEditingController();
  final TextEditingController national = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController dateOfBirth = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(now.year - 100),
      lastDate: DateTime(now.year - 10),
      helpText: 'اختر تاريخ الميلاد',
    );

    if (pickedDate == null) {
      return;
    }

    dateOfBirth.text = pickedDate.toIso8601String().split('T').first;
  }

  @override
  void dispose() {
    email.dispose();
    national.dispose();
    phone.dispose();
    dateOfBirth.dispose();
    name.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AbsorbPointer(
          absorbing: isLoading,
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const HeaderAuth(),
                        verticalSpace(context, height: 16),
                        TextFormFieldCustom(
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'الرجاء إدخال الاسم';
                            }
                            return null;
                          },
                          controller: name,
                          label: 'الاسم',
                        ),
                        verticalSpace(context, height: 10),
                        TextFormFieldCustom(
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'الرجاء إدخال الرقم القومي';
                            }

                            final nationalIdRegex = RegExp(r'^[2-3][0-9]{13}$');

                            if (!nationalIdRegex.hasMatch(value.trim())) {
                              return 'الرجاء إدخال رقم قومي صالح مكون من 14 رقم';
                            }

                            return null;
                          },
                          controller: national,
                          keyboardType: TextInputType.number,
                          label: 'الرقم القومي',
                        ),
                        verticalSpace(context, height: 10),
                        TextFormFieldCustom(
                          validator: (value) {
                            return AppValidator.validateBirthdate(value);
                          },
                          controller: dateOfBirth,
                          readOnly: true,
                          onTap: _pickDateOfBirth,
                          suffixIcon: const Icon(
                            Icons.calendar_month_outlined,
                            color: Colors.grey,
                          ),
                          hintText: 'YYYY-MM-DD',
                          label: 'تاريخ الميلاد',
                        ),
                        verticalSpace(context, height: 10),
                        TextFormFieldCustom(
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'من فضلك ادخل البريد الالكتروني';
                            }
                            final emailRegex = RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            );
                            if (!emailRegex.hasMatch(value.trim())) {
                              return 'من فضلك أدخل بريد إلكتروني صحيح ';
                            }
                            return null;
                          },
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          suffixIcon: const Icon(
                            Icons.email_outlined,
                            color: Colors.grey,
                          ),
                          label: 'البريد الإلكتروني',
                        ),
                        verticalSpace(context, height: 10),
                        TextFormFieldCustom(
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'الرجاء إدخال رقم الهاتف';
                            }
                            final phoneRegex = RegExp(r'^[0-9]{10,15}$');
                            if (!phoneRegex.hasMatch(value.trim())) {
                              return 'من فضلك أدخل رقم هاتف صحيح';
                            }
                            return null;
                          },
                          controller: phone,
                          keyboardType: TextInputType.phone,
                          suffixIcon: const Icon(
                            Icons.phone,
                            color: Colors.grey,
                          ),
                          label: 'رقم الهاتف ',
                        ),
                        verticalSpace(context, height: 10),
                        Consumer<LoginController>(
                          builder: (context, controller, child) {
                            return TextFormFieldCustom(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'كلمة المرور مطلوبة';
                                }
                                if (value.length < 6) {
                                  return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                                }
                                return null;
                              },
                              controller: password,
                              obscureText: controller.isPasswordHidden,
                              suffixIcon: IconButton(
                                color: Colors.grey,
                                onPressed: () => controller.isHidden(),
                                icon: Icon(
                                  controller.isPasswordHidden
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                              label: 'كلمة المرور',
                            );
                          },
                        ),

                        verticalSpace(context, height: 10),
                        Consumer<LoginController>(
                          builder: (context, controller, child) {
                            return TextFormFieldCustom(
                              controller: confirmPassword,
                              obscureText: controller.isConfirmPasswordHidden,
                              suffixIcon: IconButton(
                                color: Colors.grey,
                                onPressed: () =>
                                    controller.isHiddenConfirmPassword(),
                                icon: Icon(
                                  controller.isConfirmPasswordHidden
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                              label: 'تأكيد كلمة المرور',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء إدخال كلمة المرور مرة أخرى';
                                }
                                if (value != password.text) {
                                  return 'كلمة المرور غير متطابقة';
                                }
                                return null;
                              },
                            );
                          },
                        ),
                        verticalSpace(context, height: 10),
                        AppButton(
                          text: 'انشاء حساب',
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) return;

                            setState(() => isLoading = true);

                            try {
                              final authController = context
                                  .read<AuthController>();

                              await authController.register(
                                fullName: name.text.trim(),
                                nationalId: national.text.trim(),
                                email: email.text.trim(),
                                phone: phone.text.trim(),
                                dateOfBirth: dateOfBirth.text.trim(),
                                password: password.text,
                                confirmPassword: confirmPassword.text,
                              );

                              if (!context.mounted) {
                                return;
                              }

                              buildSnackBar(
                                context: context,
                                text: 'تم إنشاء الحساب بنجاح',
                                color: Colors.green,
                              );
                            } on ApiException catch (error) {
                              if (!context.mounted) {
                                return;
                              }

                              buildSnackBar(
                                context: context,
                                text: error.message,
                                color: Colors.red,
                              );
                            } finally {
                              if (mounted) {
                                setState(() => isLoading = false);
                              }
                            }
                          },
                        ),

                        verticalSpace(context, height: 10),
                        // //  GoogleLoginButton(),
                        //  verticalSpace(context, height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'لديك حساب بالفعل؟',
                              style: TextStyle(color: Colors.black),
                            ),
                            horizontalSpace(context, width: 4),
                            TextButton(
                              onPressed: () {
                                context.go(AppRouter.klogin);
                              },
                              child: const Text(
                                'تسجيل الدخول',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        if (isLoading) LoadingApp(),
      ],
    );
  }
}
