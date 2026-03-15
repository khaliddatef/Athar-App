import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/routing/router.dart';
import 'package:sanad/core/widgets/app_button.dart';
import 'package:sanad/core/widgets/loading_app.dart';
import 'package:sanad/features/auth/login/view/widget/header_auth.dart';
import 'package:sanad/features/auth/login/view/widget/text_form_field_custom.dart';
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
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;

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

                          label: 'الرقم القومي',
                        ),

                        verticalSpace(context, height: 16),
                        TextFormFieldCustom(
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'من فضلك ادخل البريد الالكتروني';
                            }
                            final emailRegex = RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            );
                            final phoneRegex = RegExp(r'^[0-9]{10,15}$');

                            if (!emailRegex.hasMatch(value.trim()) &&
                                !phoneRegex.hasMatch(value.trim())) {
                              return 'Enter a valid email or phone number';
                            }
                            return null;
                          },
                          controller: email,
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Colors.grey,
                          ),
                          label: 'البريد الإلكتروني',
                        ),
                        verticalSpace(context, height: 16),
                        TextFormFieldCustom(
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'الرجاء إدخال رقم الهاتف';
                            }
                            return null;
                          },
                          controller: phone,
                          prefixIcon: const Icon(
                            Icons.phone,
                            color: Colors.grey,
                          ),
                          label: 'رقم الهاتف ',
                        ),
                        verticalSpace(context, height: 16),
                        Consumer<LoginController>(
                          builder: (context, controller, child) {
                            return TextFormFieldCustom(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                              controller: password,
                              obscureText: controller.isPasswordHidden,
                              prefixIcon: IconButton(
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
                              obscureText: controller.isPasswordHidden,
                              prefixIcon: IconButton(
                                color: Colors.grey,
                                onPressed: () => controller.isHidden(),
                                icon: Icon(
                                  controller.isPasswordHidden
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
  AppButton(text: 'انشاء حساب',
                        
                              onPressed: () async {
                            if (!_formKey.currentState!.validate()) return;
                            setState(() {
                              isLoading = true;
                            });
                            await Future.delayed(const Duration(seconds: 1));
                            setState(() {
                              isLoading = false;
                            });
                            context.go(AppRouter.khome);
                          },
                        
                        ),
                      
                        //  verticalSpace(context, height: 20),
                        // //  GoogleLoginButton(),
                        //  verticalSpace(context, height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              TextButton(
                              onPressed: () {
                                context.go(AppRouter.klogin);
                              },
                              child: const Text(
                                'تسجيل الدخول',
                                style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),
                              ),
                            ),
                            horizontalSpace(context, width: 4),
                            const Text(
                              'لديك حساب بالفعل؟',
                              style: TextStyle(color: Colors.black),
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
