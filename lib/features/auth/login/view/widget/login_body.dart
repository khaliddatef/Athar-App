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

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final TextEditingController national = TextEditingController();
  final TextEditingController password = TextEditingController();
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
                  verticalSpace(context, height: 40),
                  TextFormFieldCustom(
                    validator: AppValidator.validateNationalId,
                    controller: national,
                    label: 'الرقم القومي',
                  ),
                  verticalSpace(context, height: 16),
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
                  verticalSpace(context, height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => context.push(AppRouter.kforget),
                        child: Text(
                          'نسيت كلمة المرور ؟',
                          style: TextStyles.cairoRegular14Primary(context),
                        ),
                      ),
                    ],
                  ),
                  verticalSpace(context, height: 10),
                  AppButton(
                    text: 'تسجيل دخول',
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      showLoadingDialog(context, message: 'جاري تسجيل الدخول');
                      await Future.delayed(const Duration(seconds: 1));
                      if (context.mounted) Navigator.of(context).pop();
                      if (context.mounted) context.go(AppRouter.kmain);
                    },
                  ),
                  verticalSpace(context, height: 105),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ليس لديك حساب ؟ ',
                        style: TextStyles.cairoRegular14Black(context),
                      ),
                      TextButton(
                        onPressed: () => context.go(AppRouter.kregister),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'سجل الأن',
                          style: TextStyles.cairoRegular14Primary(context),
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
    );
  }

  @override
  void dispose() {
    national.dispose();
    password.dispose();
    super.dispose();
  }
}
