import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/routing/router.dart';
import 'package:sanad/core/widgets/app_button.dart';
import 'package:sanad/core/widgets/loading_app.dart';
import 'package:sanad/features/auth/login/view/widget/header_auth.dart';
import 'package:sanad/features/auth/login/view/widget/text_form_field_custom.dart';
import 'package:sanad/features/auth/login/view_model/controller/login_controller.dart';
import '../../../../../core/helper/validation.dart';
import '../../../../../core/theme/text_styles.dart';

class RegisterBody extends StatefulWidget {
  const RegisterBody({super.key});

  @override
  State<RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  final TextEditingController email = TextEditingController();
  final TextEditingController national = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController age = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = context.responsiveWidth(
      16,
      tabletValue: 80,
      desktopValue: 200,
    );

    return SafeArea(
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
                    validator: AppValidator.validateName,
                    controller: name,
                    label: 'الاسم',
                  ),
                  verticalSpace(context, height: 10),
                  TextFormFieldCustom(
                    validator: AppValidator.validateNationalId,
                    controller: national,
                    label: 'الرقم القومي',
                  ),
                  verticalSpace(context, height: 10),
                  TextFormFieldCustom(
                    validator: AppValidator.validateAge,
                    controller: age,
                    label: 'العمر',
                  ),
                  verticalSpace(context, height: 10),
                  TextFormFieldCustom(
                    validator: AppValidator.validateEmail,
                    controller: email,
                    suffixIcon: const Icon(
                      Icons.email_outlined,
                      color: Colors.grey,
                    ),
                    label: 'البريد الإلكتروني',
                  ),
                  verticalSpace(context, height: 10),
                  TextFormFieldCustom(
                    validator: AppValidator.validatePhone,
                    controller: phone,
                    suffixIcon: const Icon(Icons.phone, color: Colors.grey),
                    label: 'رقم الهاتف',
                  ),
                  verticalSpace(context, height: 10),
                  Consumer<LoginController>(
                    builder: (context, controller, child) {
                      return TextFormFieldCustom(
                        validator: AppValidator.validatePassword,
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
                      if (!_formKey.currentState!.validate()) return;
                      showLoadingDialog(context, message: 'جاري إنشاء الحساب');
                      await Future.delayed(const Duration(seconds: 1));
                      if (context.mounted) Navigator.of(context).pop();
                      if (context.mounted) context.go(AppRouter.kmain);
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
    );
  }

  @override
  void dispose() {
    email.dispose();
    national.dispose();
    phone.dispose();
    age.dispose();
    name.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }
}
