import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheqlee/providers/agreement_provider.dart';
import 'package:sheqlee/screens/authentication/sign_up.dart';
import 'package:sheqlee/widget/app_primary_button.dart';
import 'package:sheqlee/widget/backbutton.dart';
import 'package:sheqlee/widget/urllauncher.dart';
import 'package:sheqlee/widget/agreement_tile.dart';

class AgreementScreen extends ConsumerWidget {
  const AgreementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Move URLs to a config or keep here
    const String termsUrl = 'https://digitalsunriseads.netlify.app/';
    const String privacyUrl = 'https://digitalsunriseads.netlify.app/';
    const String marketingUrl = 'https://digitalsunriseads.netlify.app/';

    final state = ref.watch(agreementProvider);
    final notifier = ref.read(agreementProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ REUSABLE BACK BUTTON
              const Padding(
                padding: EdgeInsets.only(top: 50),
                child: AppBackButton(),
              ),

              const SizedBox(height: 15),

              const Text(
                'Agree to terms & conditions',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),

              const Spacer(),

              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: GestureDetector(
                  onTap: () {
                    // Logic: Toggle based on whether everything is currently selected or not
                    bool isAllSelected =
                        state.term1 && state.term2 && state.term3;
                    notifier.toggleAll(!isAllSelected);
                  },
                  child: SvgPicture.asset(
                    // Toggle the path based on the state
                    state.allRequiredAccepted && state.term3
                        ? 'assets/icons/check-button-filled.svg' // Path to your checked SVG
                        : 'assets/icons/check-button-outline.svg', // Path to your unchecked SVG
                    width: 24,
                    height: 24,
                    // Optional: use colorFilter to apply the purple color to the SVG
                    colorFilter: ColorFilter.mode(
                      state.allRequiredAccepted && state.term3
                          ? const Color(0xff8967B3)
                          : Colors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                title: GestureDetector(
                  behavior: HitTestBehavior
                      .opaque, // Makes the entire bounding box of the text tappable
                  onTap: () {
                    // 1. Unfocus the keyboard
                    FocusScope.of(context).unfocus();

                    // 2. Toggle all logic
                    bool isAllSelected =
                        state.term1 && state.term2 && state.term3;
                    notifier.toggleAll(!isAllSelected);
                  },
                  child: const Text(
                    'I agree to all terms',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: 'pretendard',
                      fontSize: 20,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 22),
                child: const Divider(thickness: 0.6),
              ),

              // ✅ REUSABLE TILES
              AgreementTile(
                isRequired: true,
                isChecked: state.term1,
                title: 'I agree to Terms of Service',
                onChanged: notifier.toggleTerm1,
                onArrowTap: () => launchURL(termsUrl),
              ),

              AgreementTile(
                isRequired: true,
                isChecked: state.term2,
                title: 'I agree to Privacy Policy',
                onChanged: notifier.toggleTerm2,
                onArrowTap: () => launchURL(privacyUrl),
              ),

              AgreementTile(
                isRequired: false,
                isChecked: state.term3,
                title: '  I agree to receive marketing e-mails',
                //checked: state.term3,
                onChanged: notifier.toggleTerm3,
                onArrowTap: () => launchURL(marketingUrl),
              ),

              const SizedBox(height: 30),

              // ✅ NEXT BUTTON
              Padding(
                padding: const EdgeInsets.only(
                  //left: 25,
                  //right: 25,
                  bottom: 50,
                ),
                child: AppPrimaryButton(
                  text: "Next",
                  enabled: state.allRequiredAccepted,
                  loading: state
                      .isLoading, // This will now show your CircularProgressIndicator
                  onPressed: () {
                    // Use the notifier to handle the transition
                    notifier.submit(() {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(),
                        ),
                      );
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
