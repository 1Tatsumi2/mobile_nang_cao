import 'package:do_an_mobile/common/styles/spacing_styles.dart';
import 'package:do_an_mobile/common/widgets/login_signup/form_divider.dart';
import 'package:do_an_mobile/common/widgets/login_signup/social_buttons.dart';
import 'package:do_an_mobile/features/authentication/screens/login/widgets/login_form.dart';
import 'package:do_an_mobile/features/authentication/screens/login/widgets/login_header.dart';
import 'package:do_an_mobile/utils/constants/sizes.dart';
import 'package:do_an_mobile/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),

              /// Title & Subtitle
              TLoginHeader(),

              /// Form
              TLoginForm(),

              /// Divider
              TFormDivider(dividerText: TTexts.orSignInWith.capitalize!),

              /// Footer
              const SizedBox(height: TSizes.spaceBtwItems),
              TSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
