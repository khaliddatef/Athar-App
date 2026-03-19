import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sanad/core/helper/helper_functions/build_snack_bar.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/networking/api_exception.dart';
import 'package:sanad/core/routing/router.dart';
import 'package:sanad/core/widgets/app_button.dart';
import 'package:sanad/core/widgets/loading_app.dart';
import 'package:sanad/features/auth/login/view/widget/header_auth.dart';
import 'package:sanad/features/auth/login/view/widget/text_form_field_custom.dart';
import 'package:sanad/features/auth/view_model/controller/auth_controller.dart';
import 'package:sanad/features/auth/login/view_model/controller/login_controller.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final TextEditingController national = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void dispose() {
    national.dispose();
    password.dispose();
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
                        verticalSpace(context, height: 40),
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
                        const SizedBox(height: 16),
                        Consumer<LoginController>(
                          builder: (context, controller, child) {
                            return TextFormFieldCustom(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء إدخال كلمة المرور';
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
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                context.push(AppRouter.kforget);
                              },
                              child: const Text(
                                'نسيت كلمة المرور ؟',
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                        verticalSpace(context, height: 10),
                        AppButton(
                          text: 'تسجيل دخول',
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) return;

                            setState(() => isLoading = true);

                            try {
                              final authController = context
                                  .read<AuthController>();

                              await authController.login(
                                nationalId: national.text.trim(),
                                password: password.text,
                              );

                              if (!context.mounted) {
                                return;
                              }

                              buildSnackBar(
                                context: context,
                                text: 'تم تسجيل الدخول بنجاح',
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

                        //  verticalSpace(context, height: 40),
                        // //  GoogleLoginButton(),
                        //  verticalSpace(context, height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'ليس لديك حساب ؟ ',
                              style: TextStyle(color: Colors.black),
                            ),
                            horizontalSpace(context, width: 4),
                            TextButton(
                              onPressed: () {
                                context.go(AppRouter.kregister);
                              },
                              child: const Text(
                                'سجل الأن',
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
