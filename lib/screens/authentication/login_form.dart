import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheqlee/providers/auth/login_provider.dart';
import 'package:sheqlee/screens/authentication/send_code.dart';
//import 'package:sheqlee/screens/home/home_page.dart';
import 'package:sheqlee/screens/home/main_shell_screen.dart';
import 'package:sheqlee/utils/validator.dart';
import 'package:sheqlee/widget/app_primary_button.dart';
import 'package:sheqlee/widget/apptextformfield.dart';
import 'package:sheqlee/widget/AuthErrorIndicator.dart';

class LoginFormScreen extends ConsumerStatefulWidget {
  const LoginFormScreen({super.key});
  @override
  ConsumerState<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends ConsumerState<LoginFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();

  String? _generalError;

  void _handleLogin() async {
    // Clear error before starting
    setState(() => _generalError = null);

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // 1. Local check: if empty, show "Incorrect credentials" immediately
    if (email.isEmpty || password.isEmpty) {
      setState(() => _generalError = "Incorrect credentials");
      return;
    }
    // 2. Perform Login
    final success = await ref.read(loginProvider.notifier).login();
    if (success) {
      final String displayName = email.split('@')[0];
      // Navigate to Home on success
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainShellScreen(username: displayName),
          ),
        );
      }
    } else {
      if (mounted) {
        setState(() {
          // Check if it was a mismatch error or general auth error
          final providerError = ref.read(loginProvider).error;
          if (providerError != null && providerError.contains("match")) {
            _generalError = "Password doesn’t match";
          } else {
            _generalError = "Incorrect credentials";
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    // Assuming 'state' handles your obscureText and loading
    final state = ref.watch(loginProvider);

    final notifier = ref.read(loginProvider.notifier);
    final bool isFormValid =
        AppValidators.validateEmail(_emailController.text) == null &&
        AppValidators.validatePassword(_passwordController.text) == null;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),

      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- HEADER ----------
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // BACK BUTTON: Removing all internal padding for perfect alignment
                    Transform.translate(
                      offset: const Offset(
                        -18,
                        0,
                      ), // Moves icon left to align visually with text
                      child: IconButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context);
                        },
                        icon: SvgPicture.asset(
                          'assets/icons/arrow-down-sign-to-navigate.svg',
                          width: 11,
                          height: 20,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ), // Tight space between icon and Log in
                    const Text(
                      "Log in",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // ---------- FORM ----------
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Form(
                    key: _formKey,
                    child: // Inside your View...
                    Column(
                      children: [
                        AppTextField(
                          controller: _emailController,
                          //focusNode: _emailFocus,
                          hintText: "E-mail",
                          autofocus: true,

                          keyboardType: TextInputType.emailAddress,
                          hasError: _generalError != null,
                          onChanged: (v) {
                            if (_generalError != null) {
                              setState(() => _generalError = null);
                            }
                            notifier.setEmail(v);
                          },
                          suffixIcon: _emailController.text.isNotEmpty
                              ? IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: SvgPicture.asset(
                                    'assets/icons/cancel - alt2.svg',
                                    width: 15,
                                    height: 15,
                                  ),
                                  onPressed: () {
                                    _emailController.clear();
                                    ref
                                        .read(loginProvider.notifier)
                                        .setEmail('');
                                  },
                                )
                              : null,
                        ),
                        const SizedBox(height: 30),
                        AppTextField(
                          controller: _passwordController,
                          hintText: "Password",
                          isPassword: true,
                          obscureText: state.obscure,
                          hasError: _generalError != null,
                          focusNode: _passwordFocus,

                          onChanged: (v) {
                            if (_generalError != null) {
                              setState(() => _generalError = null);
                            }
                            notifier.setPassword(v);
                          },
                        ),
                        const SizedBox(height: 26),
                        // 3. THE TOGGLE ROW
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: AuthErrorIndicator(
                                errorText: _generalError,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // This triggers the Riverpod notifier to change state.obscure
                                notifier.toggleObscure();
                              },
                              child: Row(
                                children: [
                                  // Icon updates based on state.obscure
                                  SvgPicture.asset(
                                    state.obscure
                                        ? 'assets/icons/hide.svg'
                                        : 'assets/icons/seen.svg',
                                    width: 20,
                                    color: state.obscure
                                        ? Color((0xffC0C0C0))
                                        : Color(0xff8967B3),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    state.obscure ? 'Hidden' : 'Show',
                                    style: TextStyle(
                                      color: state.obscure
                                          ? Color(0xffC0C0C0)
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
              ),

              // ---------- BOTTOM SECTION ----------
              Column(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PasswordReset(),
                        ),
                      );
                    },
                    child: const Text(
                      'Forgot password',
                      style: TextStyle(
                        color: Color(0xff8967B3),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 25,
                      right: 25,
                      bottom: 50,
                    ),
                    child: AppPrimaryButton(
                      text: 'Log in',
                      // Logic: Purple only if both
                      enabled: isFormValid,
                      // Button turns purple when valid  Shows spinner when true
                      loading: state.isLoading,
                      onPressed: () {
                        _handleLogin();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
