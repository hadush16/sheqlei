import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheqlee/providers/profile/update_profile_provider.dart';
import 'package:sheqlee/screens/authentication/logout.dart';
import 'package:sheqlee/screens/profile/delete_account.dart';
import 'package:sheqlee/utils/validator.dart';
import 'package:sheqlee/widget/home/app_sliver_header.dart';
// import 'package:sheqlee/widget/login/action_dialog.dart';
import 'package:sheqlee/widget/login/app_primary_button.dart';
import 'package:sheqlee/widget/login/apptextformfield.dart';
import 'package:sheqlee/widget/login/autherrorIndicator.dart';
// Import your reusable files here
// import 'app_text_field.dart';
// import 'custom_bottom_nav.dart';
// import 'app_sliver_header.dart';

class UpdateProfileScreen extends ConsumerStatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  ConsumerState<UpdateProfileScreen> createState() =>
      _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends ConsumerState<UpdateProfileScreen> {
  // Controllers for your AppTextField
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passController;
  late TextEditingController confirmController;

  bool isPassObscure = true;
  bool isConfirmObscure = true;

  @override
  void initState() {
    super.initState();
    final initialData = ref.read(profileProvider);
    nameController = TextEditingController(text: initialData.fullName);
    emailController = TextEditingController(text: initialData.email);
    passController = TextEditingController();
    confirmController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final notifier = ref.read(profileProvider.notifier);
    final bool isFormValid =
        nameController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        passController.text.trim().isNotEmpty &&
        confirmController.text.trim().isNotEmpty;
    // AppValidators.validateEmail(nameController.text) == null &&
    // AppValidators.validatePassword(emailController.text) == null &&
    // AppValidators.validatePassword(passController.text) == null &&
    // AppValidators.validatePassword(confirmController.text) == null;
    // Use your AppValidators here
    String? passError = AppValidators.validateConfirmPassword(
      profileState.password,
      profileState.confirmPassword,
    );
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        // Reusing your Bottom Nav
        //bottomNavigationBar: const MyCustomBottomNav(currentIndex: 3),
        body: CustomScrollView(
          slivers: [
            // Reusing your App Sliver Header
            const AppSliverHeader(),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(26.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // EDIT THIS PART:

                    // _buildProfileHeader(),
                    ///const SizedBox(height: 30),

                    // Full Name Field
                    //_buildLabel("Full name *"),
                    AppTextField(
                      labelText: 'Full name *',
                      controller: nameController,
                      hintText: "Enter full name",
                      onChanged: notifier.updateFullName,
                      useBorder: true,
                    ),
                    //const SizedBox(height: 25),

                    // Email Field
                    //_buildLabel("E-mail *"),
                    AppTextField(
                      labelText: 'E-mail *',
                      controller: emailController,
                      hintText: "E-mail",
                      keyboardType: TextInputType.emailAddress,
                      onChanged: notifier.updateEmail,
                      useBorder: true,
                    ),
                    //const SizedBox(height: 25),

                    // Password Field
                    // _buildLabel("Password"),
                    AppTextField(
                      labelText: 'Password',
                      controller: passController,
                      hintText: "New password",
                      isPassword: true,
                      useBorder: true,
                      obscureText: isPassObscure,
                      hasError:
                          profileState.hasAttemptedSubmit && passError != null,

                      onChanged: notifier.updatePassword,
                      suffixIcon: GestureDetector(
                        onTap: () =>
                            setState(() => isPassObscure = !isPassObscure),
                        child: isPassObscure
                            ? SvgPicture.asset('assets/icons/hide (1).svg')
                            : SvgPicture.asset('assets/icons/seen.svg'),
                        //   size: 20,
                        //   color: Colors.grey,
                        // ),
                      ),
                    ),
                    //const SizedBox(height: 25),

                    // Confirm Password Field
                    // _buildLabel("Confirm password"),
                    AppTextField(
                      labelText: 'Confirm password',
                      controller: confirmController,
                      hintText: "Repeat for confirmation",
                      useBorder: true,
                      isPassword: true,
                      obscureText: isConfirmObscure,
                      hasError:
                          profileState.hasAttemptedSubmit && passError != null,

                      onChanged: notifier.updateConfirmPassword,
                      suffixIcon: GestureDetector(
                        onTap: () => setState(
                          () => isConfirmObscure = !isConfirmObscure,
                        ),
                        child: isConfirmObscure
                            ? SvgPicture.asset('assets/icons/hide (1).svg')
                            : SvgPicture.asset('assets/icons/seen.svg'),
                      ),
                    ),
                    AuthErrorIndicator(
                      // Only pass the error text if the button has been pressed
                      errorText: profileState.hasAttemptedSubmit
                          ? passError
                          : null,
                    ),
                    // Validation Error Message
                    // const Padding(
                    //   padding: EdgeInsets.only(top: 8),
                    //   child: Text(
                    //     "Password doesn't match",
                    //     style: TextStyle(
                    //       color: Color(0xffEA4335),
                    //       fontSize: 12,
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 9),
                    Text(
                      'Leave empty if you do not want to change your password.',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'pretendard',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 36),
                    // Update Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 90,
                          right: 0,
                          bottom: 0,
                        ),
                        child: AppPrimaryButton(
                          text: 'Update settings',
                          // Logic: Purple only if both
                          enabled: isFormValid,
                          loading: profileState.isLoading,
                          onPressed: () => notifier.saveSettings(),
                          // onPressed: () {
                          //   //LogoutScreen;
                          // },
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => AuthUtils.showLogoutDialog(
                          context,
                        ), // One-line call
                        child: const Text(
                          'Log out',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0x00000000),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DeleteAccountScreen(),
                            ),
                          );
                          //logoutpop(context, ref);
                        },
                        child: Text(
                          'Delete account',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
