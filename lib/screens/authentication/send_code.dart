import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/login.dart';

import 'package:sheqlee/providers/auth/send_code_provider.dart';
import 'package:flutter/services.dart';
import 'package:sheqlee/widget/app_primary_button.dart';
import 'package:sheqlee/widget/apptextformfield.dart';
import 'package:sheqlee/widget/backbutton.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheqlee/providers/auth/reset_password_provider.dart';
import 'package:sheqlee/utils/validator.dart';
import 'package:sheqlee/widget/autherrorIndicator.dart';

class PasswordReset extends ConsumerStatefulWidget {
  const PasswordReset({super.key});

  @override
  ConsumerState<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends ConsumerState<PasswordReset> {
  final _formKey = GlobalKey<FormState>();
  final _emailFocus = FocusNode();
  final _emailController = TextEditingController();
  String? _generalError;

  @override
  void dispose() {
    _emailFocus.dispose();
    super.dispose();
  }

  void _dosending() async {
    // 1. Validate the form localy
    if (_formKey.currentState?.validate() ?? false) {
      // 2. Call the provider to start loading and send the email
      // This will set state.loading = true automatically
      await ref.read(passwordResetProvider.notifier).sendResetCode();

      // 3. Navigate only after the code is "sent" (after the await)
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResetPasswordScreen(email: _emailController.text),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(passwordResetProvider);
    final notifier = ref.read(passwordResetProvider.notifier);
    final bool isFormValid =
        AppValidators.validateEmail(_emailController.text) == null;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 0,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, top: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // 2. THE REUSABLE BACK BUTTON (Fixed Position)
                Positioned(top: 89, left: 25.02, child: const AppBackButton()),

                const SizedBox(height: 15),

                const Text(
                  "Reset password",
                  style: TextStyle(
                    fontSize: 26,
                    fontFamily: 'pretendard',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "You’ll receive a password reset code on your email.",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),

                const SizedBox(height: 75),

                Form(
                  key: _formKey,
                  child: AppTextField(
                    controller: _emailController,
                    focusNode: _emailFocus,
                    hintText: "E-mail",
                    autofocus: false,

                    keyboardType: TextInputType.emailAddress,
                    hasError: _generalError != null,
                    onChanged: (v) {
                      if (_generalError != null) {
                        setState(() => _generalError = null);
                      }
                      notifier.setEmail(v);
                    },
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(
                    // top: 340,
                    //left: 10,
                    //right: 10,
                    bottom: 50,
                  ),
                  child: AppPrimaryButton(
                    text: 'Send code',
                    // Logic: Purple only if both
                    enabled: isFormValid,
                    // Button turns purple when valid  Shows spinner when true
                    loading: state.loading,
                    onPressed: () {
                      _dosending();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ResetPasswordScreen extends ConsumerStatefulWidget {
  ResetPasswordScreen({super.key, required this.email});
  final String email;

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final TextEditingController _codeCtrl = TextEditingController();
  final TextEditingController _newPassCtrl = TextEditingController();
  final TextEditingController _confirmCtrl = TextEditingController();
  // String? _generalError;

  @override
  void dispose() {
    _codeCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(resetPasswordProvider);
    final notifier = ref.read(resetPasswordProvider.notifier);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // 1. Exact Positioned Back Button

            // 2. Main Content
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100), // Vertical space for header
                    const Text(
                      "Set a new password",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff000000),
                      ),
                    ),
                    Text(
                      "A code has been sent to ${widget.email}.",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xff000000),
                        fontFamily: 'pretendard',
                      ),
                    ),

                    const SizedBox(height: 50),

                    // reusable Code Field
                    AppTextField(
                      hintText: "Code",
                      controller: _codeCtrl,
                      autofocus: false,
                      iscode: true,
                      keyboardType: TextInputType.number,
                      onChanged: notifier.setCode,
                    ),

                    const SizedBox(height: 56),

                    // reusable Password Field
                    AppTextField(
                      hintText: "New Password",
                      controller: _newPassCtrl,
                      isPassword: true,
                      obscureText: state.obscure,
                      onChanged: notifier.setPassword,
                      hasError:
                          state.confirmPassword.isNotEmpty &&
                          !state.passwordsMatch,
                    ),

                    const SizedBox(height: 36),

                    // reusable Confirm Password Field
                    AppTextField(
                      hintText: "Confirm Password",
                      controller: _confirmCtrl,
                      isPassword: true,
                      obscureText: state.obscure,
                      onChanged: notifier.setConfirmPassword,
                      // hasError: _generalError != null,

                      // Logic for red line/error
                      hasError:
                          state.confirmPassword.isNotEmpty &&
                          !state.passwordsMatch,
                    ),
                    const SizedBox(height: 26),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AuthErrorIndicator(
                            // THIS IS THE KEY: Use the getter from the state class
                            errorText: state.currentError,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => notifier
                              .toggleObscure(), // Call notifier to change state
                          child: Row(
                            children: [
                              // Icon updates based on state.obscure
                              SvgPicture.asset(
                                state.obscure
                                    ? 'assets/icons/hide.svg'
                                    : 'assets/icons/seen.svg',
                                width: 20,
                                color: state.obscure
                                    ? Colors.grey
                                    : Color(0xff8967B3),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                state.obscure ? 'Hidden' : 'Show',
                                style: TextStyle(
                                  color: state.obscure
                                      ? Colors.grey
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(top: 81, left: 26.02, child: AppBackButton()),
            Padding(
              padding: const EdgeInsets.only(
                top: 720,
                left: 25,
                right: 25,
                bottom: 50,
              ),
              child: AppPrimaryButton(
                text: "Change Password",
                loading: state.isLoading,
                enabled: state.canSubmit,
                onPressed: () async {
                  final success = await notifier.submitReset();
                  if (success && context.mounted) {
                    //loading:
                    state.isLoading;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IntroLoginScreen(),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
