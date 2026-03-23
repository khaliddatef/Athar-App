import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sanad/core/helper/helper_functions/build_snack_bar.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/helper/validation.dart';
import 'package:sanad/core/networking/api_exception.dart';
import 'package:sanad/core/routing/router.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'package:sanad/core/widgets/app_button.dart';
import 'package:sanad/core/widgets/loading_app.dart';
import 'package:sanad/features/auth/login/view/widget/header_auth.dart';
import 'package:sanad/features/auth/login/view/widget/text_form_field_custom.dart';
import 'package:sanad/features/auth/login/view_model/controller/login_controller.dart';
import 'package:sanad/features/auth/view_model/controller/auth_controller.dart';

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
    final horizontalPadding = context.responsiveWidth(
      16,
      tabletValue: 80,
      desktopValue: 200,
    );

    return Stack(
      children: [
        AbsorbPointer(
          absorbing: isLoading,
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const HeaderAuth(),
                        verticalSpace(context, height: 16),
                        TextFormFieldCustom(
                          controller: name,
                          label: 'الاسم',
                          validator: AppValidator.validateName,
                        ),
                        verticalSpace(context, height: 10),
                        TextFormFieldCustom(
                          controller: national,
                          keyboardType: TextInputType.number,
                          label: 'الرقم القومي',
                          validator: AppValidator.validateNationalId,
                        ),
                        verticalSpace(context, height: 10),
                        TextFormFieldCustom(
                          controller: dateOfBirth,
                          readOnly: true,
                          onTap: _pickDateOfBirth,
                          suffixIcon: const Icon(
                            Icons.calendar_month_outlined,
                            color: Colors.grey,
                          ),
                          hintText: 'YYYY-MM-DD',
                          label: 'تاريخ الميلاد',
                          validator: AppValidator.validateBirthdate,
                        ),
                        verticalSpace(context, height: 10),
                        TextFormFieldCustom(
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          suffixIcon: const Icon(
                            Icons.email_outlined,
                            color: Colors.grey,
                          ),
                          label: 'البريد الإلكتروني',
                          validator: AppValidator.validateEmail,
                        ),
                        verticalSpace(context, height: 10),
                        TextFormFieldCustom(
                          controller: phone,
                          keyboardType: TextInputType.phone,
                          suffixIcon: const Icon(
                            Icons.phone,
                            color: Colors.grey,
                          ),
                          label: 'رقم الهاتف',
                          validator: AppValidator.validatePhone,
                        ),
                        verticalSpace(context, height: 10),
                        Consumer<LoginController>(
                          builder: (context, controller, child) {
                            return TextFormFieldCustom(
                              controller: password,
                              obscureText: controller.isPasswordHidden,
                              suffixIcon: IconButton(
                                color: Colors.grey,
                                onPressed: controller.isHidden,
                                icon: Icon(
                                  controller.isPasswordHidden
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                              label: 'كلمة المرور',
                              validator: AppValidator.validatePassword,
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
                                onPressed: controller.isHiddenConfirmPassword,
                                icon: Icon(
                                  controller.isConfirmPasswordHidden
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                              label: 'تأكيد كلمة المرور',
                              validator: (value) =>
                                  AppValidator.validateConfirmPassword(
                                    value,
                                    password.text,
                                  ),
                            );
                          },
                        ),
                        verticalSpace(context, height: 10),
                        AppButton(
                          text: 'انشاء حساب',
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }

                            setState(() => isLoading = true);

                            try {
                              final authController = context.read<AuthController>();

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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'لديك حساب بالفعل؟',
                              style: TextStyles.cairoRegular14Black(context),
                            ),
                            horizontalSpace(context, width: 4),
                            TextButton(
                              onPressed: () => context.go(AppRouter.klogin),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'تسجيل الدخول',
                                style: TextStyles.cairoBold14Primary(context),
                              ),
                            ),
                          ],
                        ),
                        verticalSpace(context, height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (isLoading) const LoadingApp(),
      ],
    );
  }
}
