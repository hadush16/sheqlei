// sign_up_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
//import 'package:sheqlee/screens/home/home_page.dart';
import 'package:sheqlee/models/signup_request.dart';
import 'package:sheqlee/screens/home/main_shell_screen.dart';
import 'package:sheqlee/service/auth_service.dart';
import 'package:sheqlee/utils/validator.dart';
import 'package:sheqlee/widget/app_primary_button.dart';
import 'package:sheqlee/widget/apptextformfield.dart';
import 'package:sheqlee/widget/autherrorIndicator.dart';
import 'package:sheqlee/widget/backbutton.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  String get Name => 'muruts yftser';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _companyCtrl = TextEditingController();
  final TextEditingController _websiteCtrl = TextEditingController();
  final TextEditingController _repNameCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  final TextEditingController _confirmPassCtrl = TextEditingController();
  //final TextEditingController _domain = TextEditingController();

  bool _isCompany = true;
  bool _hidePassword = true;
  bool _loading = false;
  //bool _hidePassword = true; // Controls eye icon
  bool _isFormFilled = false; // Controls button color/activity
  String? _generalError; // For "Passwords do not match" text

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _companyCtrl.addListener(_refresh);
    _websiteCtrl.addListener(_refresh);
    _repNameCtrl.addListener(_refresh);
    _nameCtrl.addListener(_refresh);
    _emailCtrl.addListener(_refresh);
    _passCtrl.addListener(_refresh);
    _confirmPassCtrl.addListener(_refresh);
  }

  // void _refresh() {
  //   setState(() {
  //     // 1. Sync the general error message
  //     if (_passCtrl.text.isNotEmpty && _confirmPassCtrl.text.isNotEmpty) {
  //       _generalError = AppValidators.validateConfirmPassword(
  //         _passCtrl.text,
  //         _confirmPassCtrl.text,
  //       );
  //     } else {
  //       _generalError = null;
  //     }

  //     // 2. Check if button should enable
  //     bool isEmailValid = AppValidators.validateEmail(_emailCtrl.text) == null;
  //     bool isPassValid = AppValidators.validatePassword(_passCtrl.text) == null;
  //     bool isPassMatch =
  //         _passCtrl.text == _confirmPassCtrl.text && _passCtrl.text.isNotEmpty;
  //     bool isNameValid = AppValidators.validateName(_nameCtrl.text) == null;

  //     // Enable button only if core fields are valid
  //     if (_isCompany) {
  //       bool isCompanyValid =
  //           AppValidators.validateCompany(_companyCtrl.text) == null;
  //       bool isDomainValid =
  //           AppValidators.validateDomain(_websiteCtrl.text) ==
  //           null; // Note: using _websiteCtrl here

  //       _isFormFilled =
  //           isEmailValid &&
  //           isPassValid &&
  //           isPassMatch &&
  //           isNameValid &&
  //           isCompanyValid &&
  //           isDomainValid;
  //     } else {
  //       _isFormFilled =
  //           isEmailValid && isPassValid && isPassMatch && isNameValid;
  //     }
  //   });
  // }
  void _refresh() {
    setState(() {
      // 1. Password Matching Logic
      if (_passCtrl.text.isNotEmpty && _confirmPassCtrl.text.isNotEmpty) {
        _generalError = AppValidators.validateConfirmPassword(
          _passCtrl.text,
          _confirmPassCtrl.text,
        );
      } else {
        _generalError = null;
      }

      // 2. Core Validations
      bool isEmailValid = AppValidators.validateEmail(_emailCtrl.text) == null;
      bool isPassValid = AppValidators.validatePassword(_passCtrl.text) == null;
      bool isPassMatch =
          _passCtrl.text == _confirmPassCtrl.text && _passCtrl.text.isNotEmpty;

      if (_isCompany) {
        // COMPANY SPECIFIC
        bool isCompanyValid =
            AppValidators.validateCompany(_companyCtrl.text) == null;
        bool isDomainValid =
            AppValidators.validateDomain(_websiteCtrl.text) == null;
        // In Company mode, you are using _nameCtrl for the representative name in the UI
        bool isRepNameValid =
            AppValidators.validateName(_nameCtrl.text) == null;

        _isFormFilled =
            isEmailValid &&
            isPassValid &&
            isPassMatch &&
            isRepNameValid &&
            isCompanyValid &&
            isDomainValid;
      } else {
        // PROFESSIONAL SPECIFIC
        bool isNameValid = AppValidators.validateName(_nameCtrl.text) == null;
        _isFormFilled =
            isEmailValid && isPassValid && isPassMatch && isNameValid;
      }
      print("Email: $isEmailValid, Pass: $isPassValid, Match: $isPassMatch");
    });
  }

  @override
  void dispose() {
    _companyCtrl.dispose();
    _websiteCtrl.dispose();
    _repNameCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  // ================= REGISTER =================

  Future<void> _onRegisterTap() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _loading = true);

    final request = SignUpRequest(
      isCompany: _isCompany,
      name: _nameCtrl.text.trim(), // Both modes use _nameCtrl in your UI code
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
      companyName: _isCompany ? _companyCtrl.text.trim() : null,
      website: _isCompany ? _websiteCtrl.text.trim() : null,
      representative: _isCompany ? _nameCtrl.text.trim() : null,
    );

    try {
      await _authService.register(request);
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainShellScreen(username: widget.Name),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Registration failed: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  // ================= UI =================

  Widget _toggle(String label, bool active, VoidCallback onTap) {
    const primary = Color(0xff8967B3);
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: active ? primary : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: active ? primary : Colors.black,
                width: 2,
              ),
            ),
            child: Icon(
              Icons.check,
              size: 18,
              color: active ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'pretendard',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = _isFormFilled ? const Color(0xff8967B3) : Colors.black;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 55, 25, 23),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Positioned(top: 99, left: 25.02, child: const AppBackButton()),
                const Text(
                  'Sign up',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'pretendard',
                    color: Color(0xff000000),
                  ),
                ),
                const SizedBox(height: 25),

                Row(
                  children: [
                    _toggle('Company', _isCompany, () {
                      setState(() {
                        _isCompany = true;
                        _refresh();
                      });
                    }),
                    const SizedBox(width: 36),
                    _toggle('Professional', !_isCompany, () {
                      setState(() {
                        _isCompany = false;
                        _refresh();
                      });
                    }),
                  ],
                ),

                const SizedBox(height: 18),

                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 10,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 0),
                            if (_isCompany) ...[
                              AppTextField(
                                controller: _companyCtrl,
                                hintText: 'Company name',
                                isPassword: false,
                                validator: AppValidators
                                    .validateCompany, // Added                                autofocus: false,
                              ),
                              const SizedBox(height: 12),
                              AppTextField(
                                controller: _websiteCtrl,
                                hintText: 'Domain',
                                isPassword: false,
                                // validator: AppValidators.validateDomain,
                              ),
                              const SizedBox(height: 40),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Company representative',
                                  style: TextStyle(
                                    fontFamily: 'pretendard',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 23),
                              AppTextField(
                                controller: _nameCtrl,
                                hintText: 'Name',
                                isPassword: false,
                                validator: AppValidators.validateName,
                              ),
                              const SizedBox(height: 23),
                              AppTextField(
                                controller: _emailCtrl,

                                //keyboardType: ,
                                hintText: 'E-mail',
                                isPassword: false,
                                validator: AppValidators.validateEmail,
                                //validator: ,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 23),
                              AppTextField(
                                controller: _passCtrl,
                                hintText: 'Password',
                                isPassword: true,
                                obscureText: _hidePassword,
                                // Link the validator here
                                validator: AppValidators.validatePassword,
                                hasError:
                                    _generalError !=
                                    null, // Highlights the line red
                              ),
                              const SizedBox(height: 23),
                              AppTextField(
                                controller: _confirmPassCtrl,
                                hintText: 'Confirm password',
                                isPassword: true,
                                obscureText: _hidePassword,
                                validator: (val) =>
                                    AppValidators.validateConfirmPassword(
                                      _passCtrl.text,
                                      val,
                                    ),
                                // Special validator for matching
                                // validator: (value) =>
                                //     AppValidators.validateConfirmPassword(
                                //       _passCtrl.text,
                                //       value,
                                //     ),
                                hasError: _generalError != null,
                              ),
                            ] else ...[
                              AppTextField(
                                controller: _nameCtrl,
                                hintText: 'Name',
                                isPassword: false,
                                validator: AppValidators.validateName,
                              ),

                              const SizedBox(height: 23),
                              AppTextField(
                                controller: _emailCtrl,

                                //keyboardType: ,
                                hintText: 'E-mail',
                                keyboardType: TextInputType.emailAddress,
                                isPassword: false,
                                validator: AppValidators.validateEmail,
                              ),
                              const SizedBox(height: 23),
                              AppTextField(
                                controller: _passCtrl,
                                hintText: 'Password',
                                isPassword: true,
                                obscureText: _hidePassword,
                                validator: AppValidators.validatePassword,
                                // Use the state variable
                                //onChanged: (_) => _checkValidation(), // Call validation on every keystroke
                              ),
                              const SizedBox(height: 23),
                              AppTextField(
                                controller: _confirmPassCtrl,
                                hintText: 'confirm password',
                                isPassword: true,
                                obscureText:
                                    _hidePassword, // Use the state variable
                                //onChanged: (_) => _checkValidation(),
                                validator: (val) =>
                                    AppValidators.validateConfirmPassword(
                                      _passCtrl.text,
                                      val,
                                    ),
                              ),
                              const SizedBox(height: 6),
                            ],
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () => setState(
                                  () => _hidePassword = !_hidePassword,
                                ),
                                child: Column(
                                  children: [
                                    // 3. THE TOGGLE ROW
                                    const SizedBox(height: 23),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        // Error Indicator (Left side)
                                        Flexible(
                                          child: AuthErrorIndicator(
                                            errorText: _generalError,
                                          ),
                                        ),

                                        // Visibility Toggle (Right side)
                                        GestureDetector(
                                          onTap: () => setState(
                                            () =>
                                                _hidePassword = !_hidePassword,
                                          ),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                _hidePassword
                                                    ? 'assets/icons/hide.svg'
                                                    : 'assets/icons/seen.svg',
                                                width: 20,
                                                height: 20,
                                                colorFilter: ColorFilter.mode(
                                                  _hidePassword
                                                      ? Color(0xffC0C0C0)
                                                      : const Color(0xff8967B3),
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                _hidePassword
                                                    ? 'Hidden'
                                                    : 'Show',
                                                style: TextStyle(
                                                  color: _hidePassword
                                                      ? Color(0xffC0C0C0)
                                                      : Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
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
                            const SizedBox(height: 300),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                    bottom: 9,
                  ),
                  child: AppPrimaryButton(
                    text: 'Register',

                    // Logic: Purple only if both
                    enabled: _isFormFilled,
                    loading: _loading,
                    // Button turns purple when valid  Shows spinner when true
                    onPressed: _onRegisterTap, //() {},
                    // },
                  ),
                ),
                //const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
